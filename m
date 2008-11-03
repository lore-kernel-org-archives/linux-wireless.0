Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45825 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbYKCUHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 15:07:35 -0500
Subject: Re: print_ssid undefined (linux-next 20081103)
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20081103114222.b257f711.randy.dunlap@oracle.com> (sfid-20081103_204257_052396_C3A3F03F)
References: <20081103114222.b257f711.randy.dunlap@oracle.com>
	 (sfid-20081103_204257_052396_C3A3F03F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fJzmVJ+NCYejOJLLUGi3"
Date: Mon, 03 Nov 2008 21:07:34 +0100
Message-Id: <1225742854.3619.64.camel@johannes.berg> (sfid-20081103_210752_100750_D63F6D2A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fJzmVJ+NCYejOJLLUGi3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-03 at 11:42 -0800, Randy Dunlap wrote:
> Hi,
>=20
> I'm seeing a few instances of
>=20
> ERROR: "print_ssid" [drivers/net/wireless/ipw2100.ko] undefined!
>=20
> with ipw2100 & ipw2200 in today's linux-next (20081103).

missing lib80211, because those drivers select IEEE80211 which in turns
selects a few things that are then not selected... oh well

> These configs have
> # CONFIG_WIRELESS is not set
> CONFIG_WIRELESS_EXT=3Dy
>=20
> In looking into this more, I see that the wireless drivers can be enabled
> & built even when CONFIG_WIRELESS=3Dn.  Is this the expected behavior?
> Seems a bit odd.

Yeah, side effect of my patch to hide the IEEE80211 stuff. We may need
to revert that.

johannes

--=-fJzmVJ+NCYejOJLLUGi3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJD1oCAAoJEKVg1VMiehFYRqYP/29ggu9nRXVgb/tLrOq6r1ad
xxqzkFbwHyfPy7LMN52aWzi9oxtYXruAEyEbZQP4VCT8SW8VDN41vrDuawhCc4LC
JCiRuIxC5IK47Fzz64YGNX1yCMYZoGYMcL+5jKkb1qcr4S1aXR1VHmtDmRpTF1tz
21sZ/BUy4okeKHUBBGuffQRZCbOJ5+k0AbbhVGWbjcqp3GMgZDePnV6UbYMaD017
sNd2CwrRI69/GwsP2odeH4VTCBX38FySd748tlUmunEA9si+uTBWUwZ+LgPzWpFj
XjKLQS0hj83+HoUc/UwzQ5wo/arByX/wkftSZOhi/yhS8UckdaZ+gqy2Q3hIAJ55
7oKKd/SZWs4teuasF370EtPKk05OQK+POG3wWTzJyb3l6sq4C4kwoC7HUaPSYEzS
oEkxXuCgJKYxCTv2QbGzqe4ZoW9fA6HmHfpT42HmDKSYnbESy3TRbJX8Vp7fyttU
MIxHoWZCfCSVvCjYuwnuKuOk6T4ECSdLfZNbm4ISNGg4Yo8e6eFNkvnV1qq6xo/c
AfIeiYvPyuqEo7Xv8tETCK3pLCvA77MAQdEC0V9oHd2YMNCJIXniGls37mUhoFdH
LHHYsdBJIAvAYdfjyhJPZQ3spFopVnTYpqMo0r3zANK1BfjjVxtxS2DlW3WWXn6Z
8YQZRT2A+t/msNFX1p2x
=XZ9J
-----END PGP SIGNATURE-----

--=-fJzmVJ+NCYejOJLLUGi3--

