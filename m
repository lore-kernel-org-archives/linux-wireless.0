Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:38639 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2DBOem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 10:34:42 -0400
Date: Mon, 2 Apr 2012 10:25:37 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: [PATCH 2/2] rtl8192de: Recognize 92D E-CUT version.
Message-ID: <20120402142537.GB20611@alittletooquiet.net> (sfid-20120402_163445_901833_90395E28)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Forest Bond <forest.bond@rapidrollout.com>

The chip version constant (0xCC33) was taken from version 0001.0105.2011
of the GPL vendor driver.  Note that this driver version also ships a
firmware update, but I am unsure if it is required for E-CUT chips to
function properly.

A nearby spelling error was also corrected.

Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
---
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wire=
less/rtlwifi/rtl8192de/hw.c
index 509f5af..b338d52 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -1743,9 +1743,13 @@ static void _rtl92de_efuse_update_chip_version(struc=
t ieee80211_hw *hw)
 		chipver |=3D CHIP_92D_D_CUT;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "D-CUT!!!\n");
 		break;
+	case 0xCC33:
+		chipver |=3D CHIP_92D_E_CUT;
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "E-CUT!!!\n");
+		break;
 	default:
 		chipver |=3D CHIP_92D_D_CUT;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "Unkown CUT!\n");
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "Unknown CUT!\n");
 		break;
 	}
 	rtlpriv->rtlhal.version =3D chipver;
--=20
1.7.0.4

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk95tuEACgkQRO4fQQdv5AzaNgCeMe+SDxT1ZkHchXtrB7MDfP1F
U0oAni0bFgXrR1a+Dw4tGg/Z5GS6V8mq
=zqe1
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
