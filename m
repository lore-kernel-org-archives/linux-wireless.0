Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:9349 "EHLO annwn13.rutgers.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161344AbXDKXEB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 19:04:01 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: [PATCH] bcm43xx: Hide if bcm43xx-mac80211 is builtin
Date: Wed, 11 Apr 2007 19:01:06 -0400
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1328119.EjFDdGe3nu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704111901.06403.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1328119.EjFDdGe3nu
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

bcm43xx: Hide if bcm43xx-mac80211 is builtin

From: Michael Wu <flamingice@sourmilk.net>

This prevents users from compiling bcm43xx (softmac) and bcm43xx-mac80211
into the kernel at the same time. In the case that it is attempted, make
bcm43xx (softmac) not build.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/bcm43xx/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/bcm43xx/Kconfig b/drivers/net/wireless/bcm43xx/Kconfig
index ce397e4..f69510d 100644
--- a/drivers/net/wireless/bcm43xx/Kconfig
+++ b/drivers/net/wireless/bcm43xx/Kconfig
@@ -1,6 +1,7 @@
 config BCM43XX
 	tristate "Broadcom BCM43xx wireless support"
 	depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211 && EXPERIMENTAL
+	depends on BCM43XX_MAC80211 != 'y'
 	select WIRELESS_EXT
 	select FW_LOADER
 	select HW_RANDOM

--nextPart1328119.EjFDdGe3nu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGHWiyT3Oqt9AH4aERAnyoAKCiXATfxWEs4LYhG7VzxU/xJ6Cd5gCgxMtT
9MhOwDFmkn6ReUgaUwQpX6I=
=vuf9
-----END PGP SIGNATURE-----

--nextPart1328119.EjFDdGe3nu--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
