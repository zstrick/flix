class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i,
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6, allow_blank: true }
  validates :username, presence: true,
                       format: /\A[A-Z0-9]+\z/i,
                       uniqueness: { case_sensitive: false }

  before_save :format_username, :format_email

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def self.authenticate(email_or_username, password)
    user = User.find_by(email: email_or_username) || User.find_by(username: email_or_username)
    user && user.authenticate(password)
  end

  def format_username
    self.username = username.downcase
  end

  def format_email
    self.email = email.downcase
  end
end
