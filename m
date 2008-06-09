Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58080 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044AbYFIJQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 05:16:09 -0400
Subject: Re: [PATCH 4/7] mac80211: make ieee80211_get_hdrlen_from_skb
	return unsigned
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1212805460.6340.91.camel@brick> (sfid-20080607_042423_652950_5D44593F)
References: <1212774672.6340.78.camel@brick>
	 <200806062024.24681.mb@bu3sch.de>  <1212778061.6340.85.camel@brick>
	 <1212783357.29134.5.camel@dv>  <1212805460.6340.91.camel@brick>
	 (sfid-20080607_042423_652950_5D44593F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Pxe4viiuMULkZexLyMKB"
Date: Mon, 09 Jun 2008 11:15:31 +0200
Message-Id: <1213002931.698.65.camel@johannes.berg> (sfid-20080609_111613_304874_ECA0AE71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Pxe4viiuMULkZexLyMKB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> unlikely() isn't some magic make-me-faster function, it just moves
> code
> to the end of the function to get it out of the icache and jumps to it
> in the unlikely case it is taken.  When all there is is a return, I
> don't think it even makes any difference.  In both these cases a
> comment
> is probably more appropriate.

That's not true on ppc where you can actually tell the processor about
the jump likelyhood for its branch prediction.

> On X86-32 at least the generated code is exactly the same with or
> without the unlikely()s.  I'll put them back in a follow-on if people
> are really attached to them.

Please keep them there, I think they make sense for normal operation.

johannes

--=-Pxe4viiuMULkZexLyMKB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITPSvAAoJEKVg1VMiehFY6NUP/jdK6WCI/45RIYqEIyu0wRTG
GYnsjYMRM+Q0nS7jjkVtG+6t+8QN0L4iw4qbyTWFqG2M8AP6lZpdDxfFNi/x2wzm
w8ONaL9Xqo1FywYZdcqT0HCqwrNb4PnnNW07XonSl/21IjM+XuNk/SFjhmu9BHDF
3JI/VYEoUDbuNUYel2asx+lPBOHTnXDgkGh/fWJfRJ2kOZtBMhAClGWqqb9X6H7+
PIkg2QRb8qgS5RjS1E6oBwk9IAPxtS7pvB/sjcXHqb0uqisJNgHqZbzRp52jxN4K
VNkdEw/8ZElX4Z0CKHZhKzRG6S1rwiAu3HUMmdPCx+w1Yw531MqjPEkkuS07RgC1
42NuyRaR0l1+2zkqmycD+Id/50QAsMPZhv6zjwagw6SoVJIEdCqd4YJLjTuXnYOQ
GOgW49Q43bWApWdHUXjZeRUl1Tzrst2dFTpqIgo2kiKYaZJJ/m8iYh8HRgtPo9ae
E9bHCxSKg4nn7Ygcf61oTBgFfGhuoobuqoZ1KQHGEekB6CYl7TlWLsmcpJhiHWQW
XVMyEJ/2ZUFhilq39eh91PNSu+yTbo/ronuAEBQNnZxxunPhv55oHt6Mv7OUsEFN
sLSYPmNJd4P4yn30mPYWj0GhNsh41ViOTetYMEQoi1KGILpOyBdq61dHdtXPWGIv
qXvjySa0r3MEIwPYmqWe
=zCtZ
-----END PGP SIGNATURE-----

--=-Pxe4viiuMULkZexLyMKB--

