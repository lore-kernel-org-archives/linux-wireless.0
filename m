Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55907 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbZDROKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 10:10:39 -0400
Subject: Re: Rfkill rewrite: eeepc-laptop resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <49E9DD64.7000902@tuffmail.co.uk> (sfid-20090418_160245_391864_C41C477B)
References: <49DCA88E.6060400@tuffmail.co.uk>
	 (sfid-20090408_153722_059382_FB44D658) <1239204090.16477.1.camel@johannes.local>
	 <49DCDD2E.80705@tuffmail.co.uk>  <49E38BBC.5010708@tuffmail.co.uk>
	 (sfid-20090413_205524_915082_56358705) <1239741968.4205.1.camel@johannes.local>
	 <49E98C86.2040308@tuffmail.co.uk>
	 (sfid-20090418_101208_980691_83127E2F) <1240043283.5792.0.camel@johannes.local>
	 <49E9A0C7.8040602@tuffmail.co.uk>
	 (sfid-20090418_114338_695917_3CBF9024) <1240057470.4755.7.camel@johannes.local>
	 <49E9D5AE.50509@tuffmail.co.uk>
	 (sfid-20090418_152951_979624_DE0ADF1D) <1240061621.4755.35.camel@johannes.local>
	 <49E9DD64.7000902@tuffmail.co.uk> (sfid-20090418_160245_391864_C41C477B)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-aCZNYz0axhWWRDwZcEEI"
Date: Sat, 18 Apr 2009 16:10:27 +0200
Message-Id: <1240063827.20540.2.camel@johannes.local> (sfid-20090418_161043_382078_2D42C5D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aCZNYz0axhWWRDwZcEEI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-18 at 15:02 +0100, Alan Jenkins wrote:

> >>  * This function tells the rfkill core that the device is capable of
> >>  * remembering soft blocks (which it is notified of via the set_block
> >>  * method) -- this means that the driver may ignore the return value
> >>  * from rfkill_set_hw_state().
> >>
> >> Doesn't this conflict with the declaration of rfkill_set_sw_state() as
> >> __must_check?
> >>    =20
> >
> > Yeah, in a way it does, but I figure it's rare enough that those who
> > really can ignore it can write
> > 	(void) rfkill_set_sw_state(...)
> >
> > Don't really have a strong opinion, it just seemed the mistake in the
> > other direction would be more common.
> >  =20
> Oops... I meant to write rfkill_set_hw_state(), I think you copied me.  O=
k.

I, uh, didn't even pay that much attention.

> So then why is the _sw_ variant marked __must_check?  That looks like a
> mistake.  I don't see what I can sensibly do with the return value.=20
> Unless you want EPO to veto a firmware-initiated enable?

Good question. It gives you the hardware enable state but I guess you
know about that already. Hmm :) Yeah it seems that we should remove that
__must_check.

johannes

--=-aCZNYz0axhWWRDwZcEEI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6d9RAAoJEKVg1VMiehFYVNcP/jOOOxXQMvhJ6sc7rfIXLGIY
G3ogMmAxNwr7TjU5jKHr3/XPv8e0+CiPRyIACb3tqpdOus00RoneRJYREpo6t3VB
bZzxpjMZrTTyXMXv3fcGl6yjZcSlzqxhG0Vxi+I3k+wvQzgIt4AiV0emHs2gAm/Z
3PAZYNyqGuXZZ/5YaMG9D9u899/GP13K1bK/vfkkx9nkyqZPkkw8as6bYcSp0W6u
l9qronzHy1lWkIUtvKKRCCWM9IHe7gmf/1Hi925q0szrQ4bL0dEaqGrcdxLti+gq
C0u+z+LG8RjOBmj3gAm6KkYkTMyZXyBCCMmw0lIi8NpULzpdMCNAPvBxpzQ63gfa
f6ocixJfsvnZ2lxTzG628XSGOQ+9b858BaWshmRk2URguAeGVNByEAjKK//6ISip
Ny6LZjcGclvqXjNrlwUs2h9nPj0+8Q4Bkbcpulw5LIGedFz8dImuMbJXsxh3ZTXX
nNtufOWZUR20z4n5qO0LhnB+kMxWsJt76GKIa0qKu/DmpDceIY6HiG2ykbr+osch
R+ZGGkjJxrQV/1m5xSMFV5q5LOoLJj993rf+qmESjrqyGneVowq+iKpmZVIaRQ3l
N4lxGkLVrcZL87NvZJs5dTYsPBIFlrAba5U7Ja7JeqHHv1me12Qr4gmajLLxmjgX
Sdfkxe15A7yLr8Bl4ecc
=7Urm
-----END PGP SIGNATURE-----

--=-aCZNYz0axhWWRDwZcEEI--

