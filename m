Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58092 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933045AbXCHSzA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 13:55:00 -0500
Date: Thu, 8 Mar 2007 10:54:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ivo van Doorn <ivdoorn@gmail.com>
cc: Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	linux-sparse@vger.kernel.org
Subject: Re: sparse using insane amounts of memory
In-Reply-To: <200703081908.40997.IvDoorn@gmail.com>
Message-ID: <Pine.LNX.4.64.0703081023490.10832@woody.linux-foundation.org>
References: <1173319356.3546.54.camel@johannes.berg> <1173375270.15842.24.camel@dv>
 <1173375791.3248.37.camel@johannes.berg> <200703081908.40997.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Thu, 8 Mar 2007, Ivo van Doorn wrote:
> 
> Those checks are intended to doublecheck the register FIELD{16,32}
> defines. Since all register definitions were rewritten from the legacy driver,
> (legacy driver used unions and structs for all registers) some of those
> defines weren't done correctly (A bitmask could for example be in binary 000110111
> which is very wrong).
>
> To check those the register checks were added to ensure the register defines
> were at least correct. I am however open to suggestions on how this should be improved
> and cleaned up, since it is not my favorite piece of code. ;)

What is the check? Just checking that something is an exact power of two?

To check a value for being a nice range of consecutive bits, you can 
simply do:

	#define is_power_of_two(x) (!((x) & ((x)-1)))
	#define low_bit_mask(x) (((x)-1) & ~(x))
	#define is_contiguous_mask(x) is_power_of_two(1 + (x) + low_bit_mask(x))

and now you have a nice and simple (and efficient) expression for whether 
something is a contiguous mask of bits.

You can then make it a compile-time failure with something like

	extern unsigned int this_doesnt_exist_and_wont_link;

	is_contiguous_mask(x) ? (x) : this_doesnt_exist_and_wont_link;

which returns "x" if it's ok, and an unlinkable expression if it isn't.

[ Explanation, if anybody cares:

 - is_power_of_two(x) is hopefully obvious to all. But anyway: the "x-1" 
   means that the lowest bit set will be borrowed out of, turning all bits 
   *below* it to 1, and leaving all bits *above* it unchanged. So when you 
   do "x & (x-1)" that's zero *only* if "x" itself was zero, or it was a 
   power of two (ie there was just a single bit set - otherwise the bits 
   above that bit would survive the bitwise 'and' operation, and the end 
   result would be non-zero.

 - low_bits_mask(x) takes "x", and turns the lowest zero bits on, and 
   clears all other bits. It does so by again subtracting 1 (same trick as 
   above: the bits below the first 1-bit will become 1 through the borrow, 
   and the lowest bit itself will be cleared.

   Doing the "& ~x" will then mask off all the higher bits if there were 
   any (and obviouly the lowest bit too, since that was cleared by the 
   "-1" when we borrowed out of it).

 - "is_contiguous_mask()" basically just says: if we take the low zero 
   bits, and turn them into ones, and add one, the end result should then 
   carry out to become a power-of-two.

  Example:  x = 0x01c ( 0000.0001.1100 )

	x - 1 = 0x01b ( 0000.0001.1011 )

	   ~x = 0xfe3 ( 1111.1110.0011 )
	
	low   = 0x003 ( 0000.0000.0011 ) (bitwise "and")

    x + low   = 0x01f ( 0000.0001.1111 ) (effectively just the bitwise "or")

    1+x+low   = 0x020 ( 0000.0010.0000 )

   and that's obviously a power of two (test with the trivial thing). ]

Thus endeth Linus' "games with bits" lecture. It was probably more than 
you really wanted to know. There's a ton of games you can play with simple 
"x-1" and bitmasking ops like this).

		Linus
