Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:33200 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946102Ab3BHJeR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 04:34:17 -0500
Message-ID: <1360315992.12803.33.camel@cumari.coelho.fi> (sfid-20130208_103422_427108_E50E4501)
Subject: pull request: TI wireless drivers 2013-02-08 (for 3.9)
From: Luciano Coelho <coelho@ti.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <balbi@ti.com>
Date: Fri, 8 Feb 2013 11:33:12 +0200
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-+ImjhTfTEQNNYKg4LDUt"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-+ImjhTfTEQNNYKg4LDUt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

A few more patches intended for 3.9.  Mostly some clean-ups I've been
doing to make it easier to support device-tree.  Also including one bug
fix for wl12xx where the rates we advertise were wrong and an update in
the wlconf structure to support newer firmwares.

Please let me know if you have any problems with it!


The following changes since commit b26f5f09ebdeb85ab152344cc1d6d484a3ce967d=
:

  rtlwifi: rtl8723ae: Fix W=3D1 compile warnings (2013-02-01 14:27:27 -0500=
)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

for you to fetch changes up to 9c3a8d99346040010a82ae8088b055f85cf8a2e9:

  wlcore: fix wrong remote rates when starting STA role (2013-02-08 10:20:1=
6 +0200)

----------------------------------------------------------------
Luciano Coelho (8):
      wlcore: use single-role version when verifying the PLT firmware
      wlcore: remove unused set_power method
      wlcore: remove if_ops from platform_data
      wlcore: use wl12xx_platform_data pointer from wlcore_pdev_data
      wlcore: use PLATFORM_DEVID_AUTO for plat dev creation to avoid confli=
cts
      wlcore: move wl12xx_platform_data up and make it truly optional
      wlcore: don't hide real error code when booting fails
      wlcore: fix wrong remote rates when starting STA role

Victor Goldenshtein (1):
      wl18xx: add new phy configuration parameters for telec support

 arch/arm/mach-omap2/board-omap3evm.c                               |   10 =
++++-----
 drivers/net/wireless/ti/Kconfig                                    |    9 =
++++++++
 drivers/net/wireless/ti/Makefile                                   |    4 =
+++-
 .../ti/{wlcore/wl12xx_platform_data.c =3D> wilink_platform_data.c}   |    =
0
 drivers/net/wireless/ti/wl12xx/main.c                              |    3 =
++-
 drivers/net/wireless/ti/wl18xx/conf.h                              |    7 =
+++---
 drivers/net/wireless/ti/wl18xx/main.c                              |    5 =
+++++
 drivers/net/wireless/ti/wlcore/Kconfig                             |    5 =
-----
 drivers/net/wireless/ti/wlcore/Makefile                            |    3 =
---
 drivers/net/wireless/ti/wlcore/boot.c                              |    4 =
++--
 drivers/net/wireless/ti/wlcore/cmd.c                               |    8 =
++++---
 drivers/net/wireless/ti/wlcore/main.c                              |   17 =
++++++---------
 drivers/net/wireless/ti/wlcore/sdio.c                              |   33 =
++++++++++++++++++-----------
 drivers/net/wireless/ti/wlcore/spi.c                               |   28 =
+++++++++++++++++-------
 drivers/net/wireless/ti/wlcore/wlcore.h                            |    1 =
-
 drivers/net/wireless/ti/wlcore/wlcore_i.h                          |    5 =
+++++
 include/linux/wl12xx.h                                             |   16 =
+++++++++-----
 17 files changed, 99 insertions(+), 59 deletions(-)
 rename drivers/net/wireless/ti/{wlcore/wl12xx_platform_data.c =3D> wilink_=
platform_data.c} (100%)

--=20
Cheers,
Luca.



--=-+ImjhTfTEQNNYKg4LDUt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJRFMZYAAoJEKFHnKIaPMX6pi8P+wWdt2FjSVvWsJAvE1l7WrUc
Zqu8aiwvJmR112urgaO3j2PiiYSRtJDqMwMcTyoFXqAuY4Kwn7mJwtVs5jj2/ttd
6VDwzNbBs8kEsEXHnIK6xaEgg+HuXj37hIWenpSawR/jqvYUL72DLNhUpuK3RQZg
kJZwcAnhoRkoprappJa0SGSfkKYynpP7UURmN0LSZ08cHvTmfkIvJBbWAUUSeP5h
5RpQfNT+3XNxZoIWK4jDRI9T3StacFiPVlsKTLp+s4yYBleYQHSVLuR151icvoif
PgtG8u+dPUO5TPmGWIlQrkUO2lqeycHKi3uuCCrVw9czuvw0+8YKmR4FTPbtqzCl
uGLVIweYc+gIGi/s3DplWSKmO8+BE1UYj+HtR3wWTNNn/869W+3af8CEPDMckII/
XSKnQcsre17bbCmA16k9i2o4+LuJuc16U1NqyPfrT0uJ1cvXEMnS1Rtfb+cPciED
IFHf41JKcthlNEXrRWft6HlqKQj6QRniMtskiPY7LLOCtFDXus3fssXeE1NGeJZz
mgviZxok7lDk0LF1dtShqyz5bK1Z3w5k+Vicrhxe2WvLA/PpOnSwGWLH20YKSrK0
PHVhf4inmk8kakmeHKxkwInt+3R2vQXyj+A5BJUiWOuKW2VBwoBAAQqBdUGNLMwf
md4AoeXalkVeteAvnZYH
=uQii
-----END PGP SIGNATURE-----

--=-+ImjhTfTEQNNYKg4LDUt--
