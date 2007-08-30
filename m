Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:37245 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759548AbXH3XF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 19:05:57 -0400
Date: Thu, 30 Aug 2007 18:05:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Change Kconfig help text to match b43
Message-ID: <46d74d27.t9Eit/LAinpbIKhk%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch updates the b43legacy Kconfig text to match the latest
b43 version.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 1 file changed, 14 insertions(+), 11 deletions(-)
finger@larrylap:/home/finger/wireless-dev>

Index: wireless-dev/drivers/net/wireless/b43legacy/Kconfig
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/Kconfig
+++ wireless-dev/drivers/net/wireless/b43legacy/Kconfig
@@ -1,21 +1,24 @@
 config B43LEGACY
-	tristate "Broadcom BCM43xx legacy wireless support (mac80211 stack)"
-	depends on SSB_POSSIBLE && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	tristate "Broadcom 43xx-legacy wireless support (mac80211 stack)"
+	depends on SSB_POSSIBLE && MAC80211 && WLAN_80211
 	select SSB
 	select FW_LOADER
 	select HW_RANDOM
 	---help---
-	  This is a driver for 802.11b devices from Broadcom (BCM4301 and
-	  BCM4303).  It is also the driver for early model 802.11g chips (BCM4306
-	  Ver. 2) that were used in the Linksys WPC54G V1 PCMCIA devices. Newer
-	  devices need b43. It is safe to include both b43legacy and b43 as the
-	  ssb driver will select the correct version for your hardware.
+	  b43legacy is a driver for 802.11b devices from Broadcom (BCM4301 and
+	  BCM4303) and early model 802.11g chips (BCM4306 Ver. 2) used in the
+	  Linksys WPC54G V1 PCMCIA devices.
+
+	  Newer 802.11g and 802.11a devices need b43.
+
+	  It is safe to include both b43 and b43legacy as the underlying glue
+	  layer will automatically load the correct version for your device.
 
 	  This driver uses V3 firmware, which must be installed separately using
 	  b43-fwcutter.
 
-	  This driver can be compiled as a module (recommended) that will be
-	  called "b43legacy".
+	  This driver can be built as a module (recommended) that will be
+	  called "b43legacy". If unsure, say M.
 
 # Auto-select SSB PCI-HOST support, if possible
 config B43LEGACY_PCI_AUTOSELECT
@@ -32,7 +35,7 @@ config B43LEGACY_PCICORE_AUTOSELECT
 	default y
 
 config B43LEGACY_DEBUG
-	bool "Broadcom B43legacy debugging (RECOMMENDED)"
+	bool "Broadcom 43xx-legacy debugging"
 	depends on B43LEGACY
 	default y
 	---help---
@@ -48,7 +51,7 @@ config B43LEGACY_PIO
 	depends on B43LEGACY
 
 choice
-	prompt "B43LEGACY data transfer mode"
+	prompt "Broadcom 43xx-legacy data transfer mode"
 	depends on B43LEGACY
 	default B43LEGACY_DMA_AND_PIO_MODE
 
