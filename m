Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35331 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbYIRRuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 13:50:14 -0400
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200809181942.29122.IvDoorn@gmail.com> (sfid-20080918_194236_689430_7EB36354)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net>
	 <48D25BFE.6020708@lwfinger.net> <200809181934.03026.mb@bu3sch.de>
	 <200809181942.29122.IvDoorn@gmail.com>
	 (sfid-20080918_194236_689430_7EB36354)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-c80AIBgkRym7PJmGTRKe"
Date: Thu, 18 Sep 2008 19:49:29 +0200
Message-Id: <1221760169.9262.91.camel@johannes.berg> (sfid-20080918_195019_138343_3B655E85)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-c80AIBgkRym7PJmGTRKe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-18 at 19:42 +0200, Ivo van Doorn wrote:

> Well from my perspective:
> Note that 'sw' is the RADIO state as requested by mac80211 and
> 'hw' is the RFKILL state as indicated by the hardware
>=20
> radio: block, rfkill: block =3D> BLOCK
> radio: block, rfkill: unblock =3D> UNBLOCK
> radio: unblock, rfkill: block =3D> BLOCK
> radio: unblock, rfkill: unblock =3D> UNBLOCK

Can't that crap just live in rfkill?

rfkill_announce_softstate(OPEN/BLOCKED)
rfkill_announce_hardstate(OPEN/BLOCKED)

and all the other junk happens there. And make sure this can be called
from interrupts.

johannes

--=-c80AIBgkRym7PJmGTRKe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0pSmAAoJEKVg1VMiehFYWM4P/jv6S2+Px0uJ/P2/Y5+p3eVt
iOk80EzQvYVY5BFA/b/ujLxriqYpfgUmVtoKZYrfAuoM0vynaG0hAwq8CZ85dTXj
IjV2qwGGDh9xHXWaJvec0q4NNKxZFlWtA7tQkMrDnkQLSZFPzZXdyFtnrJ75w4F4
exNWicHVK3HeZ1yp+wQKuvNYx++azXl+1Yv4RZRibiCItSgZ+hiCIMHIdSxEtKIz
cRDLOeluR3uTaKeecb67hrkUd/g7TrPQ3g3/Rw5tdg27RH+H4EjB0eH1zg5XO8cv
a5G/Z2QNFSTQEbkSzxQyfosn0juFsMR+FhUB3yPsqvfqx4DiuDILyw//xs585wSq
32K7jChgNGLJxFdHmjE3Ubt7fb53cvKJCjIlcrxFeDB3pvaRdthLis5Y8pmVIUgd
oM66JKdCQKBBdZXSwnYabOsm3hFjaIp+KhuapD87mzt/HfZRhCyL6jGGhhUinLp9
0d2qiEUACr8y7tEroetcs5Osn73a07wlq7AMSzVe2xck9imrZHsiVu2qOLpoItb9
HQlZZ8RZHEtk6Ja6BczVFFkVo9CnmbcY7DdXnmqsxYJLLtvMhkdDRGCwW6a44a/R
J4cR7b0He11F6edQ6Tr041kd2grkbnn5SpQFgptGlBa8TRodsPqWdPHEoVbK4D5v
q+D4Y6FuOgjibOOZBYKO
=/+sH
-----END PGP SIGNATURE-----

--=-c80AIBgkRym7PJmGTRKe--

