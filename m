Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37568 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbYCCAcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 19:32:24 -0500
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Franz Apeltauer <franz.apeltauer@gmx.at>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <47CB3B5E.4020701@gmx.at> (sfid-20080302_234250_620354_B59BDB8D)
References: <47CB3B5E.4020701@gmx.at> (sfid-20080302_234250_620354_B59BDB8D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-shCcVmxPfzywrz41eYsl"
Date: Mon, 03 Mar 2008 01:32:11 +0100
Message-Id: <1204504331.3917.31.camel@johannes.berg> (sfid-20080303_003229_419436_C4300101)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-shCcVmxPfzywrz41eYsl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


>    CC [M]
> .../compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2x00firmware.o
> .../compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2x00firmware.c:116:
> Fehler: Redefinition von =C2=BBrt2x00lib_load_firmware=C2=AB
> =3D Error: redefiniton of  =C2=BBrt2x00lib_load_firmware=C2=AB
>=20
> When I tried to "export CONFIG_CRC_ITU_T=3Dy" before "make",=20
> rt2x00firmware.c compiled fine. (Probably this is not a good idea. I=20
> just wanted to see, if it compiles then.)

That's odd because the latest config.mk should check for CRC_ITU_T
before... Ivo could there be a problem with rt2x00 when crc-itu-t isn't
available?

> In /usr/src/linux-headers-2.6.22-14/include/linux/slab.h I found:
>     struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
> 		unsigned long,
> 		void (*)(void *, struct kmem_cache *, unsigned long),
> 		void (*)(void *, struct kmem_cache *, unsigned long));
> i.e. the old, 6-parameter version.
>=20
> So, IMHO the #define kmem_cache_create in
> - compat-wireless-2.6/include/net/compat.h, line 120 and
> - compat-wireless-2.6/compat/compat.h, line 120
> should be moved 2 lines downwards into the block named
> /* Compat work for 2.6.22 and 2.6.23 */
> Then it compiles fine.

Ok, indeed, it should be moved then, I was working on .21 when I noticed
that needed to be done.

johannes

--=-shCcVmxPfzywrz41eYsl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8tHCqVg1VMiehFYAQKoDA/+NPsruLBN1hvKMA79eKGFuGy6rYvYx1gy
twlW7ImYBPPKVYj6uwifKymNXKayuIY0XLs5dWWf8Run2Q5AzcEqOJwvGInHmwVt
eltymNZf0/7wEFB765rZRx76aHo4Wk00ADzrTq1rkdtKBW1ynr9PXUS5daZhGlB7
4bORsqG+j7m87WQlv7hiDUtqpotwnzhjNk+VtndhS1zfO3E9zTOydP5xDHxT5Wft
dDr83CMTwi8ljdfUlti+pOC2Ez7EvjFiQk1LB34R81PsuR1DjSo2D7k4FZcGMXJJ
l/i9cXgMgUSuiCI+a9HqLy1ffTaCQ1AV52MXqfphP5JwcZP+9WtWonM/MmkSPPOe
olO40ANTU5y6iMIqqSuUHUoL2RvBI8QoSuWhWYLWGjhy7wc4v8vhjoAE2TdvqyKA
CSmRGcN1LHvDQHxyfwMv6iRJzYsAIoZ7ijbLt9H9g2ZgXXZmTk/U2pDXwlDiEeiw
tnN/GMIE2rhdBN1ZSj6eqt8qGUSg81wUdfqv9pxGcStRjho7k/sKgXn4RuwJWGNF
pOAZP8NEFIQzHa5WWBXeqWK3zWrosLO50ZA6SOC4BRBYPSP3eTBtKqhGJM7Ov1MV
CJVX4R7GaY9w8R51ERkMCcC3r52UZbbcr+YUVk3wRH34UtJ2Gg67q6jsAyzDjxSc
luC+3tkAfQ0=
=iKaL
-----END PGP SIGNATURE-----

--=-shCcVmxPfzywrz41eYsl--

