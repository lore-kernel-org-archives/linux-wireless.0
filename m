Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49229
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758897AbXHRXxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 19:53:22 -0400
Message-Id: <20070818234835.514400000@bu3sch.de>
References: <20070818234833.623623000@bu3sch.de>
Date: Sun, 19 Aug 2007 01:48:37 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [patch 4/6] b43: Update Kconfig help text
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>

The help text in Kconfig for b43 is updated to indicate the devices that it
does not support and to note that it can coexist with b43legacy.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/Kconfig	2007-08-15 15:18:34.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/Kconfig	2007-08-17 20:20:27.000000000 +0200
@@ -6,7 +6,16 @@ config B43
 	select HW_RANDOM
 	---help---
 	  This is an experimental driver for the Broadcom 43xx wireless chip,
-	  found in the Apple Airport Extreme and various other devices.
+	  found in the Apple Airport Extreme and various other devices. This
+	  driver supports 802.11a and 802.11g, but not 802.11b. As a result,
+	  BCM4301 and BCM4303 are not supported - use b43legacy instead.
+	  It is safe to include both b43 and b43legacy as the ssb driver will
+	  load the correct version for your device.
+
+	  This driver uses V4 firmware, which must be installed separately using
+	  b43-fwcutter.
+
+	  This driver can be built as a module (recommended) that will be called "b43".
 
 # Auto-select SSB PCI-HOST support, if possible
 config B43_PCI_AUTOSELECT

-- 

