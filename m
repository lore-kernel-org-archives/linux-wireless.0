Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:47305 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbZCWOth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 10:49:37 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: Kconfig maintenance
Date: Mon, 23 Mar 2009 15:49:33 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903231549.34020.chunkeey@web.de> (sfid-20090323_154940_232004_A1912DCD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch updates p54's Kconfig entry and removes the out-dated device list.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John,

This patch goes on top of "[PATCH v2] p54: fix SoftLED compile dependencies".

Regards,
	Chr
---
diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
index 0e344ac..ee1aaca 100644
--- a/drivers/net/wireless/p54/Kconfig
+++ b/drivers/net/wireless/p54/Kconfig
@@ -1,9 +1,10 @@
 config P54_COMMON
 	tristate "Softmac Prism54 support"
-	depends on MAC80211 && WLAN_80211 && FW_LOADER && EXPERIMENTAL
+	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
+	select FW_LOADER
 	---help---
-	  This is common code for isl38xx based cards.
-	  This module does nothing by itself - the USB/PCI frontends
+	  This is common code for isl38xx/stlc45xx based modules.
+	  This module does nothing by itself - the USB/PCI/SPI front-ends
 	  also need to be enabled in order to support any devices.
 
 	  These devices require softmac firmware which can be found at
@@ -17,31 +18,6 @@ config P54_USB
 	select CRC32
 	---help---
 	  This driver is for USB isl38xx based wireless cards.
-	  These are USB based adapters found in devices such as:
-
-	  3COM 3CRWE254G72
-	  SMC 2862W-G
-	  Accton 802.11g WN4501 USB
-	  Siemens Gigaset USB
-	  Netgear WG121
-	  Netgear WG111
-	  Medion 40900, Roper Europe
-	  Shuttle PN15, Airvast WM168g, IOGear GWU513
-	  Linksys WUSB54G
-	  Linksys WUSB54G Portable
-	  DLink DWL-G120 Spinnaker
-	  DLink DWL-G122
-	  Belkin F5D7050 ver 1000
-	  Cohiba Proto board
-	  SMC 2862W-G version 2
-	  U.S. Robotics U5 802.11g Adapter
-	  FUJITSU E-5400 USB D1700
-	  Sagem XG703A
-	  DLink DWL-G120 Cohiba
-	  Spinnaker Proto board
-	  Linksys WUSB54AG
-	  Inventel UR054G
-	  Spinnaker DUT
 
 	  These devices require softmac firmware which can be found at
 	  http://prism54.org/
