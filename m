Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59386 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763629AbZD3PH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 11:07:27 -0400
Subject: Re: [RFC v6] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>,
	Matthew Garrett <mjg@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20090430031903.GD18827@khazad-dum.debian.net>
References: <1238349195.24972.5.camel@johannes.local>
	 <1239745712.4205.17.camel@johannes.local>
	 <1239750483.4205.28.camel@johannes.local>
	 <20090430031903.GD18827@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DRrORX0eIYqauUJPx2hS"
Date: Thu, 30 Apr 2009 17:06:54 +0200
Message-Id: <1241104014.29878.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DRrORX0eIYqauUJPx2hS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-30 at 00:19 -0300, Henrique de Moraes Holschuh wrote:

> The return values for rfkill_alloc() are not the same on the stub and
> real functions.  The stub function uses ERR_PTR, while the real
> function uses NULL for any errors.   Please make them do the same
> thing, and it is probably a damn good idea to document in the
> kerneldoc what kind of return values one should expect when you return
> a pointer and the function can fail (i.e. NULL or ERR_PTR).

Actually, I was going to clean this up, and then I noticed you're
wrong. :) Returning ERR_PTR(-ENODEV) is intentional, in the non-RFKILL
case. Imagine a driver like this:

	ASDF
	rf =3D rfkill_alloc(...)
	if (!rf)
		return -ENOMEM;
	err =3D rfkill_register(rf);
	if (err) {
		rfkill_destroy(rf);
		return err;
	}
	GHJK

Now, in the non-RFKILL case, this boils down to:
	rf =3D ERR_PTR(-ENODEV);
	...

and given compiler optimisations will end up like this:
	ASDF
	GHJK

Which is good :)

johannes

--=-DRrORX0eIYqauUJPx2hS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+b6LAAoJEKVg1VMiehFYc9cP/i796UQfoLm6TFtp/jgx38Hp
deojRdAiiQ87KFflWi9BJrKPBjaOlY/qtv6zPiIDN7JyV5aAxLz89k9gsAZF2I2P
DNT+0b9lmxLhrAeFRo1iaHYynKAPbtcDsyDyA9S3rh9NwTXziDTFpfqGWx2DUoqv
iqCXMMYcnWY6GnEfZdRCv2JV2Y4pDo900C3bOe6PUEtVoH0j13WoalS228CwYUcD
uFqdZNxI7gofiTNlbvF8rGcmRHcm2g5G11aoOeITiXZmE0IH+meYPq3w8TL7lPcL
fssfikBvr5AAiPHe910ns38IH7xKfdC5NW73dbDrFfjFcGQLEerfjghxYCTEER+c
Z1XFXvQz54sOScyKP/RQRJt0Anlc/4EqfqXH8Gmyu0wJ4FikPlS7TAGbNhyP0f7l
o2bLbTUfhjkZ2fxKZybYQu0h46wRrcWaYBfBK3c6DLEUrm3sg4QFxtbFTCfRr7C6
gfgvrFsJU5FZznoIzxztxI6Bu7MTG97FuVG+Iw9joqRqHjraYG3F9DojaZllhxj0
R8n+vorHsVXVfRbIEAjvHm7Tvg+AnZw1uYUo6HKjFce3t8cCnGQKIUZvhrvphM/U
cNAxcI28G56OOj1xvNo/8p+heSAuAzZ/bTVqszNgyLnXqfaSjIpN02jTL9KUYZWF
ccR8VYU++ezsMq/Gf3gy
=dzYO
-----END PGP SIGNATURE-----

--=-DRrORX0eIYqauUJPx2hS--

