Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZG1Hh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 03:37:58 -0400
Subject: Re: [RFC] cfg80211: send country ie processing on the reg_work
 struct
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248744593-6597-1-git-send-email-lrodriguez@atheros.com>
References: <1248744593-6597-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZIXM/NMkZlt0sUqlkq0e"
Date: Tue, 28 Jul 2009 09:37:26 +0200
Message-Id: <1248766646.8113.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZIXM/NMkZlt0sUqlkq0e
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-27 at 18:29 -0700, Luis R. Rodriguez wrote:
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>=20
> Did this in a flash, so just want to see if this is you like this
> approach. Of course a lot of cleaning can be done here but ignore that
> for now (like the fact that beacon hint doesn't really process IEs,
> and the functions names used here).
>=20
> This just compiles for me, never tested it.

Looks ok, but I don't see why you need this type enum?

> + * enum beacon_hint_type - type of regulatory beacon hint

I mean -- if the beacon was received we could just process it as before,
and if it also has a country IE we can just process that additionally?
Why bother doing both separately?

Also, I would have allocated the struct and the space for the IE
together, but that really doesn't matter :)

johannes

--=-ZIXM/NMkZlt0sUqlkq0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbqqxAAoJEODzc/N7+Qma4WsQAM609te4sIBIPhxpgmpv9haL
WJ+r7Fob8ebpXfhVfI5a4QR6OE50eSWfxWQQBWLoGqVZbb+nHW73I3PhzhZZ2qZ5
3vFy/O+TtrNSxhKxu1dKcTWkKhDo6Yjv7hjTzFZweYsUY/AeLTNdasJtGSkqm92l
P3ilQwA83js1lYhSgFcJgdOrKoJ5ebiXYnHa7w8FfV4ibbZU1rnLaxwR2fSm9BVq
cqleLIKl2p3Ai8OaFA1mRHlsM8jH5kwgLjwmruNWqYwUweGvHziDUMAozOmeHCpZ
kzBBkIOsdj/aVPyZACOutyyVFYgTiv9nIf2hBt2xzAsEEdtcVjXbymfNXigRa5LF
5TJApxAVWYhxEb7N60fiqebYkg+37FoavyUTGS4Q0oPIsFHkoFP5ZYOaLp+ssQZX
S5nBz2Rpae+A4K4mXoR3zTWE0RfbMdlsKNffyhoRWkdGuKGyHDJK2xEJg/QIPCRm
jO433URt7XckWVpaCo5OWFySJVXYjWzDzHuMA9zPQ3ScirzdyC6SFIlEjGH/Isrn
ldqe08N8l3s5AROFKMEztFO0v3lwzkRhxDpncpaafxBcXmCwXDQUngkI3ZR8lFMa
/YulaDHLSi+ZQtCGiqgkRwa+0fuHzhqptJ5q9UBcXAvWE0pM+/xAnyjUSXP4/gvu
MyhAqXHePb9Xa4iMaiMm
=4t/l
-----END PGP SIGNATURE-----

--=-ZIXM/NMkZlt0sUqlkq0e--

