Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35395 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbYDZQKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 12:10:38 -0400
Subject: Re: [PATCH RFT] tkip: fix iv32 calculation in
	ieee80211_get_tkip_key()
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240804260825qcae5777qddd2d1e91a0277dc@mail.gmail.com> (sfid-20080426_172604_795906_4CB85248)
References: <1209081653.12561.50.camel@dv>
	 <1ba2fa240804260825qcae5777qddd2d1e91a0277dc@mail.gmail.com>
	 (sfid-20080426_172604_795906_4CB85248)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0FkuMgW6ZZwLiYBK13G1"
Date: Sat, 26 Apr 2008 18:10:28 +0200
Message-Id: <1209226228.10943.45.camel@johannes.berg> (sfid-20080426_181056_501113_FEE168CA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0FkuMgW6ZZwLiYBK13G1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  It's a side product of testing a sparse patch by Linus Torvalds.
> >  Compile tested only.

> >         iv32 =3D data[hdr_len + 4] +
> >  -               (data[hdr_len + 5] >> 8) +
> >  -               (data[hdr_len + 6] >> 16) +
> >  -               (data[hdr_len + 7] >> 24);
> >  +               (data[hdr_len + 5] << 8) +
> >  +               (data[hdr_len + 6] << 16) +
> >  +               (data[hdr_len + 7] << 24);
> >
> >   #ifdef CONFIG_TKIP_DEBUG
> >         printk(KERN_DEBUG "TKIP encrypt: iv16 =3D 0x%04x, iv32 =3D 0x%0=
8x\n",
> >
> >
>=20
> We've tested TKIP code well and I'm not sure we wouldn't pay attention
> to such mistake.

But the code does look a bit fishy. I'm confused.

johannes

--=-0FkuMgW6ZZwLiYBK13G1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBNT86Vg1VMiehFYAQKynRAAt5dfUON68R8CStUR6f0v5YyO3WErV5jQ
3i2WVeyIeaaAc211/j4zuhw+xRwLUM1tgSO5nVJhOJ+1W8BYPkWW7zeCSBMCpM/C
7dUTS783quJdr3W5Jka3tc+jqrEUlRnW3LbNpEyr2GxEtNM9VLZ2GA1nCeUlnNrg
PeCtfCPpXa7NKr9S1PaVNYpGf5T8f3jXMoZGWhokID6NXxe8IF8z/4FnlaEezXlm
S58JGdXOcDWPNiF1WjJ3fj+eD9/8raWpou7sb4pwg4c59dEFT+EpsbpNB7jVt9S7
lAttz+LuSDivMX3zTWO7pF2MS3hi/N+84zZNZN/uNYyT3VKQ6nQPhBZpVXYuSYEZ
wwc3SEKr9XvhLrd1u5sngj6Ur3DgcZ41z2SbqZVmQcG5yQiPyl5YNZ0HBosWDiWH
J6pOISOlm6G4n/BRbx+0cSol5QctSzOlKLzgNYH5VgZzg0VDVM/Q95OdxKfMxrpW
9PcZIksGpF6/+j5+v+Th9xQtSgv9mdi15k87A8LSQhHvTLgShlE4jL8vNdsHmQVy
RnGriWhA2+dG+KNEo8vaXpB6t+GGz3u1suVUm879uLMVKraPrtZYHveqojCH0Psc
88ry7ddnz8lWutLGmm7l28XkXQyE5DwbIQWWkcstCXh+tv8pFp4uAi3Ugxzph0Nb
ANJXBjo+HpQ=
=K+lS
-----END PGP SIGNATURE-----

--=-0FkuMgW6ZZwLiYBK13G1--

