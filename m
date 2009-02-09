Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbZBIWcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 17:32:09 -0500
Subject: Re: [PATCH] mac80211: split managed/ibss code a little more
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090209222915.90830@gmx.net> (sfid-20090209_232946_198947_591EBB4D)
References: <1234217077.4175.257.camel@johannes.local>
	 <20090209222915.90830@gmx.net> (sfid-20090209_232946_198947_591EBB4D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-29zOy9PipOn6hrep21uJ"
Date: Mon, 09 Feb 2009 23:31:34 +0100
Message-Id: <1234218694.4175.259.camel@johannes.local> (sfid-20090209_233214_250724_BEC0D5F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-29zOy9PipOn6hrep21uJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-09 at 23:29 +0100, Alina Friedrichsen wrote:
> Hello Johannes!
>=20
> > It appears that you can completely mess up mac80211 in IBSS
> > mode by sending it a disassoc or deauth: it'll stop queues
> > and do a lot more but not ever do anything again. Fix this
> > by not handling all those frames in IBSS mode,=20
>=20
> This is a huge change. Hopefully it doesn't break anything.

Hopefully; but it shouldn't. There was one strange thing with the
channel that I removed, we'll have to take a look at that maybe.

> Applying this patch fails for me. Can you please send me your mlme.c?

You need to apply the previous patch ("mac80211: fix IBSS auth") first.

johannes

--=-29zOy9PipOn6hrep21uJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkK7DAAoJEKVg1VMiehFYrJwQAJtxQJVoyZrT0D/PaJHvXQ17
1AoCBIK2fwp37ycXb/weBkeyRcC+vPizuv/iJ/TMOS1D2lCda234VeSbn9zgb40R
KRX7Vkp1UAtjRTObsPxtbYVV+3tulDs05ZGpAgpw3R3+Fo1GIYmdSOEW7qj5VaBO
rORq4PmPLjSqPSHBUeJM1sSHpal+MGjEuHPX0I++7vJio7RbioSeXO20TS5zFTN6
yeWtEI7tpHZXEoHWA3SdXJ4EuveVOm//IVRGxrB9AJHH/aRw3PEKHo4+CIDye69t
xLNQXk3K9otUay/OSxcwY8GpWJmP83ZKALN8iBepufwnS34M2YBqPKsouenoGXsu
imb7r2MFv/kpK59bLzKUckRPuzd+V6bU6dK/VnrsIJcV6vgdvMA6tN5yTlu2ngLA
V4GAxIbigArRXibf1Y1N/eje7BkX5iPVVWtpKzc3ki8sc7p4isdBCUG6ERZTtUc4
X/FLjKkXlMFJbYQQpyqq/53jR9C0nGndfjElDxgWZmVPmnmcj9Z5LRk6VbMsuqmg
G5J+TlD6yHHus+SkK4cpZk7Zr5tF5x+3RBUZSoijhQWylKAbsl1JibShaDcunfs3
4Td73BZQ7fFEp32votxaP+mXccTzO8Yhnz6ye08kRz0UUhUblLqmbTWxVBgpKbVl
+Pd/1oZLtQ//Fn1YojwB
=o/uo
-----END PGP SIGNATURE-----

--=-29zOy9PipOn6hrep21uJ--

