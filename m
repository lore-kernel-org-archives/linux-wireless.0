Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43412 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbYI0LsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2008 07:48:15 -0400
Subject: Re: wireless-testing modpost failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, YanBo <dreamfly281@gmail.com>
In-Reply-To: <2da21fe50809270354i4d28335vfe166c166d33dc7@mail.gmail.com> (sfid-20080927_125412_466264_1CBEFB30)
References: <2da21fe50809261104m3b7d99e3g8b56416b8182ca45@mail.gmail.com>
	 <20080926190007.GD3483@tuxdriver.com>
	 <1222457416.3798.25.camel@johannes.berg>
	 <2da21fe50809261325o62dea98dyf40b06e373f29f53@mail.gmail.com>
	 <1222504695.3798.38.camel@johannes.berg>
	 <1222507225.3798.45.camel@johannes.berg>
	 <2da21fe50809270354i4d28335vfe166c166d33dc7@mail.gmail.com>
	 (sfid-20080927_125412_466264_1CBEFB30)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3N4jOjqClDygqh2y6BIl"
Date: Sat, 27 Sep 2008 13:48:09 +0200
Message-Id: <1222516090.3798.62.camel@johannes.berg> (sfid-20080927_134824_501774_03FC88E2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3N4jOjqClDygqh2y6BIl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-27 at 12:54 +0200, Davide Pesavento wrote:

> > Ok... I can't reproduce it. Can you turn off CONFIG_MAC80211_NOINLINE
> > and see if that helps?
> >
>=20
> Yes, it works without CONFIG_MAC80211_NOINLINE.
>=20
> I guess that it fails because gcc doesn't optimize out
> CALL_RXH(ieee80211_rx_h_mesh_fwding) in
> ieee80211_invoke_rx_handlers(), even if the comparison is always
> false... (btw, there's an extra semicolon at the end of that line).

Ok, strange. I suggest we simply remove the debug_noinline from
ieee80211_rx_h_mesh_fwding then, want to do a patch?

johannes

--=-3N4jOjqClDygqh2y6BIl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3h12AAoJEKVg1VMiehFYTaQP/3TKmRqyPnq7v8mt93RNgV6l
r/0G9dFRsWIR1OCcJ9CXuYljYW05pa9uHwdluFJ8hq2QIaXasHUBQU+hyaPHs08/
gpZ/EgW1QWw1m9FUlgKIJsUvG/f97YNrvgs8gOxKSis7bmRL+vtRQD2W+iN7CZR/
OpVuDP64omrDIgsvtpYdbwdl8J4wK6Yxb7Ag+ebBeTEeT1p/870IShu2oitUvXBR
lz8xHAzbE/ofYf5QE+4mP2ATeO6JV4YuhFB3Lqk0zNt4ZG9EnkVFPmNTZGElIEcS
WHEoEXtJyKZynvDFEyo3edchX0gCdQuE6ERcIMuNY59jLWff/RHPFVa/B0Jdk6T0
Bki8lpeTpHWOZIiVKhZtGoo6Dsrmem+4S3N/mSIo1pV/fum2oXUFeLVAwSku+Ta5
qTNbpfeGAFiciO139PVTIoAY55JjweqfrEgivUu19Tr5sQouSnXYBc8gDCAbY7oW
aMTkMyjSn7xJsL3kvNb0bodyXFQUHshr/YMuMU0BIwC5uhBQALIJFL1c8DiCddqA
kKiVs3V3UO+zzT3b8jKHu0HoYmQg5XJmIWttyq66sFkHd3X31zEnR2JTuAseD4nr
5bn5LyFvEwhVK9ffe3/1sfA/68VwPqx13+eB+xH337MS9R4lxLZvPLevqpE5byrN
Lwy+5+Nv68TXQ5nIJj0M
=IAGQ
-----END PGP SIGNATURE-----

--=-3N4jOjqClDygqh2y6BIl--

