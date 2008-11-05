Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37566 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbYKEPkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 10:40:25 -0500
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets
	using tx close descriptor for 8187B
From: Johannes Berg <johannes@sipsolutions.net>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
In-Reply-To: <200811051338.33882.herton@mandriva.com.br>
References: <1225806649-10050-1-git-send-email-herton@mandriva.com.br>
	 <4910CD42.4010402@lwfinger.net> <1225884552.3619.74.camel@johannes.berg>
	 <200811051338.33882.herton@mandriva.com.br>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QlkqzfBIB/cPBwqqWMuz"
Date: Wed, 05 Nov 2008 16:40:22 +0100
Message-Id: <1225899623.3619.119.camel@johannes.berg> (sfid-20081105_164030_068362_95680E10)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QlkqzfBIB/cPBwqqWMuz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-05 at 13:38 -0200, Herton Ronaldo Krzesinski wrote:

> > > WARNING: line over 80 characters
> > > #138: FILE: drivers/net/wireless/rtl8187_dev.c:475:
> > > +                       if ((le16_to_cpu(ieee80211hdr->seq_ctrl) & 0x=
FFF)
> > > =3D=3D seq_no)
>=20
> Ops, I forgot to run checkpatch.pl here, will run and fix it when I submi=
t=20
> next patch.

I wouldn't worry about lines > 80 chars too much, breaking this down
wouldn't make more readable but less so, in my opinion. I tend to ignore
that rule where it makes the code unreadable :)

> > Besides, that line looks wrong? the lowest 4 bits are teh fragment
> > number.
>=20
> It's intended, because the hardware instead of reporting just the sequenc=
e=20
> number in its 12 bits is reporting fragment number + sequence number, thi=
s is=20
> a workaround.

Ah. A comment might be appropriate that "seq_no" doesn't actually
contain the sequence number?

johannes

--=-QlkqzfBIB/cPBwqqWMuz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEb5jAAoJEKVg1VMiehFY68IP/j53fwQqYQkJgpur5SN4ojVV
1jH96XSde7HW0mDtQGsrdGV88GTeOO5QdOJ98/BIx/rMEt+dJZEzOG+BHqNewnYm
Wj3mpC4o8DM7mGwFpNO1bGL0tuCfeV1fO51kgUqi5VFwdCExeUWxF2Lqt00gnkV3
1NqPG3NDSpcpVsyqvakqS84qWPF8H5SWPs6fMIl5qtLgE9QDNd1gRdVQl1+lZumQ
eJS9SaB0doloS/NBeRyvpZtK3O56TLAhKcX7NNdXokp1s8M74TNqT6rNU2Nwo05R
bPM1S0D/MwR9g49gUm94lCh9mNMlxBend7sokGDIA9RB7l+/fFnelJZciHSz+qwz
6QvHlp4q/g7FIy1aZ6DDr4TrXMWQ/BD6V6Hyfj0j9gpHMMlwM8Fi5mvqv82jRlL4
Ry2qPjoAhXwzkSAa32J6IaTmZKeCeFYCy4L4NHBdr0IASzK46kjDyOufLJH2S1vk
e/FbnfChpjFfI7F2Zvw3O0jE/NO60+Lt/rMqJqojVhXvwVtk/IG+UlVWZLwVvpo7
d+bikK0JcRj+F4VS7pwoZPEOfmJFwB/Nwio8eWZfQ2Fx4QP0EE1X6QYvxkqflo3f
Ug2Z6EMlXEdalcuWSwb43ngDRBNNz0bmDfzy7ARNcCYTz35DluIEnBw42tN7rJew
PB7z8thj8TKOCicTWgJQ
=qPtc
-----END PGP SIGNATURE-----

--=-QlkqzfBIB/cPBwqqWMuz--

