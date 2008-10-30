Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbYJ3Oy4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 10:54:56 -0400
Subject: Re: [PATCH for 2.6.28] mac80211: fix basic rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810300751h5c1ba5e0mefc4fc89dbc7418e@mail.gmail.com> (sfid-20081030_155201_619699_E768280A)
References: <1225300446.5439.27.camel@johannes.berg>
	 <1ba2fa240810300623o51dbd0a6p7a7bc89795dc5d35@mail.gmail.com>
	 <1225376692.3690.46.camel@johannes.berg>
	 <1ba2fa240810300739m69ec943didc1d76b82da7f1e5@mail.gmail.com>
	 <1225377700.3690.53.camel@johannes.berg>
	 <1ba2fa240810300751h5c1ba5e0mefc4fc89dbc7418e@mail.gmail.com>
	 (sfid-20081030_155201_619699_E768280A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VID+GUmChDe4mLU0Pn+g"
Date: Thu, 30 Oct 2008 15:54:52 +0100
Message-Id: <1225378492.3690.56.camel@johannes.berg> (sfid-20081030_155500_593010_236F3761)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VID+GUmChDe4mLU0Pn+g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 16:51 +0200, Tomas Winkler wrote:

> Oh, I now I got it out of index. What about coding it in more readable wa=
y?
>=20
>=20
> for (i =3D 0; i < elems.supp_rates_len; i++) {
>                 int rate =3D (elems.supp_rates[i] & 0x7f) * 5;
>                 bool is_basic =3D !!(elems.supp_rates[i] & 0x80);
>=20
>                 if (rate > 110)
>                         have_higher_than_11mbit =3D true;
>=20
>                 for (j =3D 0; j < sband->n_bitrates; j++) {
>                         if (sband->bitrates[j].bitrate =3D=3D rate) {
>                                 rates |=3D BIT(j);
>                                 if (is_basic)
>                                         basic_rates |=3D BIT(j);
>                                 break;

yeah, that works too, and the break is probably a good idea, want to
send a patch to supersede this one?

johannes

--=-VID+GUmChDe4mLU0Pn+g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCcq4AAoJEKVg1VMiehFYjiEP/21BYk1SEqIICMeZeRvvsN9P
MAwoFZK5YZ9olxsXit1wAcPuxYLW18riZmMZtLsJwlwluQpXHjXytAVZ19izkuvl
pOIZAtHtKFkqd/Oop9jF3Ql7KB95/oZYVcpZOvXPXxOHVKcTB3uUwLa+tp0hm7ml
1iPQ8+i0jzSqh8nmC0prpxhomn7qYta1IiSF9B2jfmVuCloxYLLoY8ajodbMabAz
nsO914dqJ5MoXEfXtGGb8eKwtt1jsYvgVfJUt30KrpB47X+Q/H0trE1GjNPWuZN0
skgvKR1HXXNpIF6KF/gI1SmIF1znSS/S5C2CWjAQJK1g9TNFUSvXQPSWBOvsdmMT
4vl7Oh0b2AUqm8G0Z/OzzGUHO0JULi+JSB1rvMo7T9TMqxHweRBZPaZvk9arL+GX
txqS9gDVfgm/NO9PhNxuO6tYevckR9nlptwyXkE7NQNp5JykaXTA097rn5jgz4Vt
WXexWWvmoKDM3aakke6Wiy2HGqhWxksEjITc2K+WyXNFmgUjw7L6y7Ta66bfbMLq
xsQmXj+F6yKgNrzGozcAF/qGWIx8LlpfWAjPemlX9iDLJnKDLbQzne6Y6mw/GU1v
BItfYIgJaXbGB8Ah3+JtksyjWDpM2XszoZ1uawa3zaVpGGigdDfQzVokHrhU6tlV
dlDjgrpja7MnBNB+VzP9
=8SxP
-----END PGP SIGNATURE-----

--=-VID+GUmChDe4mLU0Pn+g--

