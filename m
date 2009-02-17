Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39097 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZBQUzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 15:55:16 -0500
Subject: Re: Missing link quality with wireless-testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1234902294.4678.12.camel@californication>
References: <1234896777.4678.7.camel@californication>
	 (sfid-20090217_195251_321967_5E2E0AB8)  <1234899806.29785.35.camel@johannes.local>
	 <1234902294.4678.12.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+AxrXhtn8MBMr8JEx4w4"
Date: Tue, 17 Feb 2009 21:55:11 +0100
Message-Id: <1234904111.29785.44.camel@johannes.local> (sfid-20090217_215520_696202_92B2DDA3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+AxrXhtn8MBMr8JEx4w4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-02-17 at 21:24 +0100, Marcel Holtmann wrote:

> > What exactly is broken by this? Wext never guaranteed that 'qual' value=
s
> > be present, and thus any application that breaks from not having 'qual'
> > is broken anyway.
>=20
> that be it, but I would still consider this a regression. Since when do
> we just start removing API details without any proper warning or grace
> period?

Why not? The API even contains whether or not the values are valid, and
after discussing with many of the stakeholders (network manager,
wpa_supplicant) we've decided that there's little use in the qual.qual
value. Especially since you want to compare the 'quality' of the AP
against the one you're associated to, so qual isn't really useful at all
due to the various factors it can contain.

So hey, if you want to scream "regression" then we can add a 'qual.qual'
value back. It'll still be entirely pointless, and I'll still be against
it, but I'm not going to risk anyone reverting this patch, it's way too
useful. And if you're going to scream regression then please keep in
mind that then you're going to scream about the wext limit again... I
can't fix it up in the next couple of weeks anyway.

johannes

--=-+AxrXhtn8MBMr8JEx4w4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmyQsAAoJEKVg1VMiehFYWmgP/A+xw7H2RYAV9W6ilJAI/FUC
vN7oyrtXMl36BXJXe0llmLZpkvQvWVbLloiMb1DYOP9LuDNiUs4sEkg9qxSRDXm5
6K2ObX4IH4d5QfX1GXBtEkVHUSB9dfVhBVFZSN6gJNEi8hEzqZ6XLjuP2O0Ci1RG
uycH7COqxO7R24gWT+yUUvCT23v2uCdNJHdQmmrbRAGv7pvtFRHXUXeRDMgp6ofW
JNcftdvj4eoH+fCXt6YJjewm2Pl441vUI9XF1/Cw5nQTn1qlRb1PyscFyXPdoRWJ
PdWLrSw58NCBYYjU7EK2WSCLBcVqOmoZ6IyxfcdzFGMp9QBI4Cr1Z7O6G6i0654p
WSKoUdf1V2mE3ZKYykWtyAYDBjbtsQYmFyHjGzonLq+z3kyKaduTebL/bq1l/z4e
aCskEEsv9cj/ewXFXwH/LYv//wYtFRPK5Ijitn/1yaEBHgmmjZ4R3dpZYHrqKfmK
rTFYkfO42HyccpSfA3Wu4BMDmanr8u1dAE8hEhRflPjXhLUA8NbS0kFb05x5aIqw
cz5pXHRFithGWaK891rvLNQEbi2vtb3fk5lMf/ftbZHsQ7TQb1WCy6mvGQqPe/Ib
H/eLMsiByq0RwvOPYRw3/evAZMwFhEq9or2K+hFsTA49W7bZAQjBD9Zcg+aFegoO
wDNjwMa33I8wJAcEBym1
=hYPf
-----END PGP SIGNATURE-----

--=-+AxrXhtn8MBMr8JEx4w4--

