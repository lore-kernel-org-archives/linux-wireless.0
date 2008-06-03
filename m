Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33531 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759916AbYFCUmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 16:42:55 -0400
Subject: Re: [PATCH 01/11 v3] rt2x00: Calculate register offset during
	compile time
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <200806032245.35830.IvDoorn@gmail.com> (sfid-20080603_223846_328625_E1C0343A)
References: <200806032024.52931.IvDoorn@gmail.com>
	 <200806032029.35662.IvDoorn@gmail.com>
	 <200806032205.17071.IvDoorn@gmail.com>
	 <200806032245.35830.IvDoorn@gmail.com>
	 (sfid-20080603_223846_328625_E1C0343A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-smkvgR1cAOwsY4u2kQGs"
Date: Tue, 03 Jun 2008 22:41:46 +0200
Message-Id: <1212525706.14371.2.camel@johannes.berg> (sfid-20080603_224334_341717_23636290)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-smkvgR1cAOwsY4u2kQGs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-03 at 22:45 +0200, Ivo van Doorn wrote:
> By using __ffs() the register offsets were always calculated
> at run-time which all FIELD32/FIELD16 definitions were builtin
> constants. This means we can heavily optimize the register handling
> by allowing GCC to do all the work during compilation.
>=20
> Add some compile_ffs() macros to perform the calculation at
> compile time. After this each rt2x00 module size is reduced
> by ~2500 bytes. And the stack size of several functions is reduced
> as well which further limits the number of rt2x00 results in
> 'make checkstack'.
>=20
> v2: Merge GertJan's bugfix of patch [1/11] directly into this patch
>       instead of providing it as seperate patch.
> v3: Add extra parentheses when bitshifting __x
>=20
> Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
> John, this patch is a combination of patch [1/11] and [2/11] so please
> either apply those 2 patches or just this single patch to get the correct=
 result :)

This, however, is no longer true ;) You need this one, not the other
two.

johannes

--=-smkvgR1cAOwsY4u2kQGs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEWsiaVg1VMiehFYAQINMg//d5SAtYpNMAIXvjU72SG5qtHoZxXZuMrD
qSpm22VL659SmQrJ487yJK7Ui1tnWj6KgJe2ke71D1qsqnVjP0T9vP57KQpD+EEq
6PUqYAxJCgpadBkOdCTLSZPJY2SLaQ/80ccNj85GEOYkkQExqWRbTsJWbYJec0M9
UceQjGV3wmoNhoBfY6kJzXzg9APasGM0Ck3IcMsxTyyL3Sw0cgN+nQ0n2jXXgGRf
o0QKDGJWY1FeEemSn3x/Ca6uLIek6n4uyNxeyiaQiqggpSSYFbY62wVJiJWb4/hd
spbR7Om8f5LIvMj6C3Z67/Sbx66i/R3xGg/jBHAiLlTx5xjFmIKSOxHJKxl0Qeo/
3+nBp7e/f4iZEZ5eGbe8krU7XXYgfxqavIJJ2YqvJU4r9Cm1gTYbO+E/w9XBw/1c
x1+/VtU2fXuz3eGMWVh7/P0+bdGziBOu2h79jtw9KXOZ1MpSJljZEmv6SUQvM6wW
sSclTYehZKj9RhjYc8px2N/94g25N+TA9w1QptJO52Vssit1nTnnD5sI/68I/YgL
WuAKQP8ytD43XDQpkx1iW9u2ZUwpnR/a+ZQ26kwBew1ZYo0LOwZ/mUWvHGoWTge8
ZgwZq9b5MF4EtmvyBpgNPMU3iBzI107fR5B13tssyeB46LlTMybSJaQ/bw58cHlT
zmokWWgPvD8=
=T1NP
-----END PGP SIGNATURE-----

--=-smkvgR1cAOwsY4u2kQGs--

