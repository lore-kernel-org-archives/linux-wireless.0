Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55212
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764225AbXHWW1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 18:27:04 -0400
Message-Id: <20070823222154.137089000@bu3sch.de>
References: <20070823222153.073035000@bu3sch.de>
Date: Fri, 24 Aug 2007 00:21:54 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
Subject: [patch 1/7] b43: Change Kconfig help text
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hopefully people can understand this better.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <larry.finger@lwfinger.net>

Index: wireless-dev-new/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/Kconfig	2007-08-23 22:55:18.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/Kconfig	2007-08-23 23:31:09.000000000 +0200
@@ -1,21 +1,31 @@
 config B43
 	tristate "Broadcom 43xx wireless support (mac80211 stack)"
-	depends on SSB_POSSIBLE && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on SSB_POSSIBLE && MAC80211 && WLAN_80211
 	select SSB
 	select FW_LOADER
 	select HW_RANDOM
 	---help---
-	  This is an experimental driver for the Broadcom 43xx wireless chip,
-	  found in the Apple Airport Extreme and various other devices. This
-	  driver supports 802.11a and 802.11g, but not 802.11b. As a result,
-	  BCM4301 and BCM4303 are not supported - use b43legacy instead.
-	  It is safe to include both b43 and b43legacy as the ssb driver will
-	  load the correct version for your device.
+	  b43 is a driver for the Broadcom 43xx series wireless devices.
+
+	  Check "lspci" for something like
+	  "Broadcom Corporation BCM43XX 802.11 Wireless LAN Controller"
+	  to determine whether you own such a device.
+
+	  This driver supports the new BCM43xx IEEE 802.11G devices, but not
+	  the old IEEE 802.11B devices. Old devices are supported by
+	  the b43legacy driver.
+	  Note that this has nothing to do with the standard that your AccessPoint
+	  supports (A, B, G or a combination).
+	  IEEE 802.11G devices can talk to IEEE 802.11B AccessPoints.
+
+	  It is safe to include both b43 and b43legacy as the underlying glue
+	  layer will automatically load the correct version for your device.
 
 	  This driver uses V4 firmware, which must be installed separately using
 	  b43-fwcutter.
 
 	  This driver can be built as a module (recommended) that will be called "b43".
+	  If unsure, say M.
 
 # Auto-select SSB PCI-HOST support, if possible
 config B43_PCI_AUTOSELECT
@@ -32,8 +42,8 @@ config B43_PCICORE_AUTOSELECT
 	default y
 
 config B43_PCMCIA
-	bool "Broadcom 43xx PCMCIA device support"
-	depends on B43 && SSB_PCMCIAHOST_POSSIBLE
+	bool "Broadcom 43xx PCMCIA device support (EXPERIMENTAL)"
+	depends on B43 && SSB_PCMCIAHOST_POSSIBLE && EXPERIMENTAL
 	select SSB_PCMCIAHOST
 	---help---
 	  Broadcom 43xx PCMCIA device support.
@@ -41,7 +51,7 @@ config B43_PCMCIA
 	  Support for 16bit PCMCIA devices.
 	  Please note that most PC-CARD devices are _NOT_ 16bit PCMCIA
 	  devices, but 32bit CardBUS devices. CardBUS devices are supported
-	  by "B43 PCI device support".
+	  out of the box by b43.
 
 	  With this config option you can drive b43 cards in
 	  CompactFlash formfactor in a PCMCIA adaptor.

-- 

