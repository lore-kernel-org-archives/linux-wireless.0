Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbZAYQpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 11:45:24 -0500
Subject: Re: [PATCH] ath5k: Set TSF fix
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <bcopeland@gmail.com>
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <b6c5339f0901250841r22635bd7q40532891293a6744@mail.gmail.com> (sfid-20090125_174113_839483_F2509A6D)
References: <20090124081223.50440@gmx.net>
	 <b6c5339f0901250841r22635bd7q40532891293a6744@mail.gmail.com>
	 (sfid-20090125_174113_839483_F2509A6D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-G+oGRz49gCAoEfbwe7Dn"
Date: Sun, 25 Jan 2009 17:45:17 +0100
Message-Id: <1232901917.3837.0.camel@johannes.local> (sfid-20090125_174530_368724_94B45788)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-G+oGRz49gCAoEfbwe7Dn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-01-25 at 11:41 -0500, Bob Copeland wrote:
> On Sat, Jan 24, 2009 at 3:12 AM, Alina Friedrichsen <x-alina@gmx.net> wro=
te:
> >  {
> >        ATH5K_TRACE(ah->ah_sc);
> >
> > -       ath5k_hw_reg_write(ah, 0x00000000, AR5K_TSF_L32);
> > -       ath5k_hw_reg_write(ah, (tsf64 >> 32) & 0xffffffff, AR5K_TSF_U32=
);
> >        ath5k_hw_reg_write(ah, tsf64 & 0xffffffff, AR5K_TSF_L32);
> > +       ath5k_hw_reg_write(ah, (tsf64 >> 32) & 0xffffffff, AR5K_TSF_U32=
);
> >  }
>=20
> Perhaps there is an internal latch on this pair; that may explain why
> you need to write low->high order.

Either way, I think the changelog should back up the claim by
_something_. Even if it's just "tested on device XXX, old way doesn't
work, new way does" or "looked at legacy HAL code" or ...

johannes

--=-G+oGRz49gCAoEfbwe7Dn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfJcaAAoJEKVg1VMiehFYlb0P+QFg7x5TzfwHhZV6mv6x7DKn
UUq8qq0efBoheNHYzyPFFu1nPuXswpaPffdrPz4sEZ2ggfE2X3Nyo52vauM3vr8m
SYTkqwPMfx9DeVhLZEDr1PDKuPLotUoWXfMTuuZn0tKYoDyZRsKZRSMGvcaA1oKm
TqmQbSCGdl8LDXzUc9ZZr0YVW6oXlgSvnurVyBM6Y9LfrSYdacTC7/Ld0KIh25Ww
xMv9ft+7OHbRWT/CguCEtDrymruCEqQvMVk1cZaaKaum9Sn98fBFK8bgdQW7ZmdV
VNVFf4qprMfYYQBq+9jBbiUBPMtRcBC26gCNgcv+lv6CxMj0fVemWw3oFOllzm3h
L1WatGXVY3/rzbvHydB+RLirNiqxlK7EQ37USV4SZHvvSq4lqdJxJ+WR43A8ER7c
pHTaaRaHLaV4zrZH8H1XI4aJF5fvjfUoFPJr2nC5R1K3x+WlqfYnolcnEZkbYVPE
9o6A4OSscDjQP6IDiRfIJEZys2KWaCsXoWOZxovgKqbj5u9HE6NYUCh02QnEw6ik
2PXORZ0CCkno0aJoYFZSXW//AdgNK5lTi3rUgnziJOWtHDq6IUuBgZp8HcfBmUKr
f3er1hsKV0XiezgoV3IJj8B7jQwL5KVaxFgsX9cFrAwSLSqnbXxKvXTXZR1uJf6R
D5jMaGhfjC5jLA8gGZ7P
=x6z4
-----END PGP SIGNATURE-----

--=-G+oGRz49gCAoEfbwe7Dn--

