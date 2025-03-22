extends CharacterBody2D

signal hit

var screen_size # Size of the game window.

const SPEED = 300.0

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x = 0
	velocity.y = 0
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_just_pressed("dig"):
		dig()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x > 0:
		$AnimatedSprite2D.animation = "walk_right"
	elif velocity.x < 0:
		$AnimatedSprite2D.animation = "walk_left"
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "walk_up"
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "walk_down"
		
	move_and_slide()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func dig():
	var scene_to_instance = preload("res://hole.tscn")
	var object = scene_to_instance.instantiate()
	var coordinates = $AnimatedSprite2D.global_position
	object.add_to_group(&"MapObjectsGroup")
	var main = $AnimatedSprite2D.get_parent().get_parent()
	var MOG = main.get_node("MapObjectsGroup")
	MOG.add_child(object)
	object.position = Vector2(coordinates)
	
