Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59840 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbXGIMDj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 08:03:39 -0400
Subject: Re: alignment issue between 32bit userland and 64bit kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	geoffrey.levand@am.sony.com, Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <20070709201037.D02C.MOKUNO@sm.sony.co.jp>
References: <20070709201037.D02C.MOKUNO@sm.sony.co.jp>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Vk3+EdMmPEm9gpQOiNIU"
Date: Mon, 09 Jul 2007 14:03:23 +0200
Message-Id: <1183982603.18986.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Vk3+EdMmPEm9gpQOiNIU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> While developing the wireless support for PS3, I'd noticed there were ali=
gnment
> issues if we issued some wireless ioctl from 32bit userland to 64bit
> kernel (ppc64 PS3 does have).=20
>=20
>  - IW_EV_LCP_LEN in 32bit userland and 64bit kernel differ
>  - offsetof(struct iw_point, length) differ

Yeah, we're aware of them.

> The former issue could be fixed if we added 'packed' attribute to
> iw_event structure, but it would break existing 64bit userland.  I have
> no idea to resolve latter issue because the first member of struct
> iw_point is a pointer.
>=20
> Does anyone have idea to fix these issues?
> (except compiling all userland apps in 64bit mode...)

Jean wants to fix them in userspace. In fact, if you upgrade your
userspace to the really latest version it *should* work. wpa_supplicant
still doesn't work, nor do most distribution's versions of network
manager because the fixes haven't been backported.

johannes

--=-Vk3+EdMmPEm9gpQOiNIU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGkiQJ/ETPhpq3jKURAr4BAJ48WGHvT2D7M1h30iteIADiuUfQDACgnwfT
hy9nqJNSHOqIUSGsX2o4E5I=
=ibGB
-----END PGP SIGNATURE-----

--=-Vk3+EdMmPEm9gpQOiNIU--

