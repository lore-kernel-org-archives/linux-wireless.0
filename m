Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbYGWOze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 10:55:34 -0400
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
	rtl8187
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <4886C50E.6040304@lwfinger.net>
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <200807221613.34434.herton@mandriva.com.br>
	 <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>
	 <200807221940.20009.herton@mandriva.com.br> <4886AA3B.3000406@lwfinger.net>
	 <4886C50E.6040304@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JMKJ5UdLSoJqilbugeqU"
Date: Wed, 23 Jul 2008 16:55:17 +0200
Message-Id: <1216824917.13587.9.camel@johannes.berg> (sfid-20080723_165555_146417_BAD2F5E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JMKJ5UdLSoJqilbugeqU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-23 at 00:43 -0500, Larry Finger wrote:
> Johannes,
>=20
> In the current wireless-testing (v2.6.26-rc9-14207-ga520bdb), rtl8187 is =
broken.=20
> In most cases, it is unable to complete a connection. Occasionally, it wi=
ll=20
> authenticate and even get an IP using DHCP; however, only a few pings get=
=20
> through to the AP before the connection fails completely.
>=20
> Using bisection, this problem was traced to:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> commit 741b4fbc441dba885cc8f97a10e87f2acd04c5f2
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Thu Jul 10 11:21:26 2008 +0200
>=20
>      mac80211: fix TX sequence numbers

> The validity of the bisection was confirmed by reverse application of the=
 patch.=20
> The resulting driver worked.
>=20
> The appears that rtl8187 needs some kind of modification such as b43, b43=
legacy,=20
> and rt2x00 got in the original patch. I'll be studying the changes to the=
 other=20
> drivers to see if I can find the problem, but I will appreciate your help=
 when=20
> you get a chance. Perhaps after your trip to Canada is over.

Oh, crap. If you look at the patch, it removes the sequence numbers for
non-TID frames, and puts them back into rt2x00 because I thought rt2x00
was the only driver that needed software sequence numbering. It looks
like rtl8187 and zd1211 might need that too, so we need to copy the
rt2x00 code that I put into that particular patch to those drivers.

johannes

--=-JMKJ5UdLSoJqilbugeqU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIh0ZSAAoJEKVg1VMiehFY9msP/A9Z7ReGn6jxayqRzK+ljpcG
9xkyAmteMk5gRfhmMhvF/Z9MpcNnDUu1EIkFoa09Y5UIbh+LEZNw4bCAJO7jIA/D
vHlcbRnb3qZwliOYNCzpvLEGmucfc2SQXk8IzpqjPIjUsvdh6SAqYKLrI2xBSzm6
to+9lswYSXWD4FvzPQvMlqs5ezxF14Q38EOlCYR4JJo2EXKggFG4phTrCNzj3wzr
mTk+iJU5y8C8+uiFNWcVcsxiErU1wBCujJa/0gz83+f45NTfA0AInDUJyEhdImhn
IjuPf+fLZ7+TwFy7qedzLcfCawv1aLyR3cZ//osk0YHC9v7Y42MgL26cR+k2YkWo
Y5abtcYFF7z/wJE4R67voh11HiZ2SceM8D7ueU8nGUkFSkySFJFOTwbFtJDs3Jhy
JWLdJOxYcz+s/40xy2l9KSQZTwuriI4zH6n8IUh/SQ7VKWCYyrS3hS2MH4fzrZtm
13+QAtDvBhDKgkPEEwGOeIiqsWcaHg5AyQ4jDpeAdZJb7lGvDZHtqKxTKjs7asyu
e2oEUwZ49XYgsE1Q8McvS2xwqF6ggMlhNzNkWPRx4bb4X7w2j+8vzgETea1Udy3r
IV0WPovqnnvoijJmhok9VW9xpNsFTpxabWUhglSbNLtlPn+0Vb8WBzwNb/HZNUn8
tdnBMLaVWX2n/BWb6nX3
=BTlO
-----END PGP SIGNATURE-----

--=-JMKJ5UdLSoJqilbugeqU--

