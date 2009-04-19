Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48693 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757106AbZDSP5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 11:57:14 -0400
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090419155319.158810@gmx.net> (sfid-20090419_175352_161479_A88396A3)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240097845.25826.1.camel@johannes.local>
	 <20090419125212.158800@gmx.net>
	 (sfid-20090419_145246_566920_BF082D12) <1240147050.25826.5.camel@johannes.local>
	 <20090419133544.158820@gmx.net>
	 (sfid-20090419_153615_967882_D1A9F951) <1240148519.898.3.camel@johannes.local>
	 <20090419140523.158830@gmx.net>
	 (sfid-20090419_160555_446977_A429511B) <1240150277.898.7.camel@johannes.local>
	 <20090419151629.158790@gmx.net>
	 (sfid-20090419_171702_263242_9A8C16F9) <1240154704.898.18.camel@johannes.local>
	 <20090419155319.158810@gmx.net> (sfid-20090419_175352_161479_A88396A3)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QVQVcmBYjDNn9yrQy9B3"
Date: Sun, 19 Apr 2009 17:57:11 +0200
Message-Id: <1240156631.917.1.camel@johannes.local> (sfid-20090419_175717_182507_19D3EB58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QVQVcmBYjDNn9yrQy9B3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 17:53 +0200, Alina Friedrichsen wrote:
> Hello!
>=20
> > It will pass in a cfg80211_bss structure instead of all those parameter=
s
> > once we move all the stuff into cfg80211.
>=20
> This is not mode specific.

Well, the struct isn't but ibss cannot use a bss structure because then
we'd have to fake one without knowing what is around us.

> All members of cfg80211_bss are not known by the user-space without
> scanning.=20

Nope. Not the IEs for the locally created IBSS for example.

> I don't like the idea of needing the wpa_supplicant for joining an
> unencrypted network.

You don't need wpa_supplicant, you just need an SME for that. Eventually
we'll implement one in iw.

johannes

--=-QVQVcmBYjDNn9yrQy9B3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ60nUAAoJEKVg1VMiehFY0rEP/j8czcD/GX3RezaV8jCUeusO
EhgF8Ft2oO8JrJ9lbirLgKbVkIiYZ/ircZeU8yLOrqA64hBHheCm0qtA4af+Yv5f
qUBIFcM/LM9Yp3j6sPkz5Ky4FOJ7iJxJfjX9DpszOhO6Foq+aPP/AV1WgBl5q06S
EzeUHWpTwVaLVfhzc5yvQwP/tUM1ZoD14rToe3IZszIn0pXz7niX4aeGuz/jDU3U
hmpYrgYyDKf1iT6IWsF4fzWzLSbfDwXL9OFH9g0jxNb+iFw3V21ogwmEg1HtyRE1
Y1C0VW95qgPFME3tPuqLfx5Wp++qPEI0DoXopD5yHP3qmcGAsqWZyGlj+NxPfxPz
Lirv0+z5mM8nOH7k/uVquKs/CVO/hdwimywbFSc+wPHzvTjzSC5PvOfGc6477tpO
RCYgF0XKVu2Egfd/VCVdJ3mNTIJ7PnCVXyJXw7/JWZtluzcQScQNuqC+swiKyZUs
0S06N20is6GX6+/7WK5/d7WPD138ZG0kFGKDefC4AQ5tSqypxwRfQITf9/LH4XSH
HZk2DSF8lyeNuT27KLyRwv8OG5pwI0GkOCaj7VMyeeK8UEsPaNx1G/5lgiHtqOk0
x5XZ6n8KmJ/HwoXwMbMtMR2bbThAsy4Gwq35p3IRqddu9YREOC6Vkq6yaAkXcWaJ
XeMqd0krn6DgRBtsfmHr
=kWXx
-----END PGP SIGNATURE-----

--=-QVQVcmBYjDNn9yrQy9B3--

