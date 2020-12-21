class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = '-' * word.length
  end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word_with_guesses

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(word)
    if word == nil or word.length == 0 or !/[a-zA-Z]/.match(word)
      raise ArgumentError
    end
    word = word.downcase
    @guesses.each_char do |c|
      if word == c
        return false
      end
    end
    @wrong_guesses.each_char do |c|
      if word == c
        return false
      end
    end
    i = 0
    @word.each_char {|c|
      if word == c
        @word_with_guesses[i] = word
      end
      i += 1
    }
    @word.each_char do |c|
      if word == c
        @guesses.insert(-1, word)
        return
      end
    end
    @wrong_guesses.insert(-1, word)
  end

  def check_win_or_lose
    if @wrong_guesses.length >= 7
      return :lose
    end
    if @word_with_guesses == word
      return :win
    end
    :play
  end

end
