Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37099
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872AbXHNSOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 14:14:04 -0400
Message-Id: <20070814181217.291720000@bu3sch.de>
References: <20070814181213.135874000@bu3sch.de>
Date: Tue, 14 Aug 2007 20:12:22 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 9/9] b43: Rewrite kconfig to get rid of the advice hack.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should properly autoselect the SSB options without
introducing a dependency hell.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/Kconfig	2007-08-14 20:09:15.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/Kconfig	2007-08-14 20:11:07.000000000 +0200
@@ -1,49 +1,31 @@
-config B43_DEP_HACK
-	bool
-	depends on SSB && SSB_PCIHOST && SSB_DRIVER_PCICORE
-	default y
-
-config B43_ADVICE_HACK
-	bool "Broadcom 43xx PCI (mac80211) not available. Read the help text of this option!"
-	depends on !B43_DEP_HACK
-	---help---
-	  The B43 driver for B43 PCI devices can not be enabled,
-	  because the required dependencies are not selected.
-
-	  In order to be able to select the B43-mac80211 driver, you
-	  need to enable the following options first:
-
-	  CONFIG_SSB found in menu:
-	  Device Drivers/Sonics Silicon Backplane/Sonics Silicon Backplane support
-	  CONFIG_SSB_PCIHOST found in menu:
-	  Device Drivers/Sonics Silicon Backplane/Support for SSB on PCI-bus host
-	  CONFIG_SSB_DRIVER_PCICORE found in menu:
-	  Device Drivers/Sonics Silicon Backplane/SSB PCI core driver
-
 config B43
 	tristate "Broadcom 43xx wireless support (mac80211 stack)"
-	depends on SSB && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on SSB_POSSIBLE && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	select SSB
 	select FW_LOADER
 	select HW_RANDOM
 	---help---
 	  This is an experimental driver for the Broadcom 43xx wireless chip,
 	  found in the Apple Airport Extreme and various other devices.
 
-config B43_PCI
-	bool "Broadcom 43xx PCI device support"
-	depends on B43 && SSB_PCIHOST && SSB_DRIVER_PCICORE
+# Auto-select SSB PCI-HOST support, if possible
+config B43_PCI_AUTOSELECT
+	bool
+	depends on SSB_PCIHOST_POSSIBLE
+	select SSB_PCIHOST
 	default y
-	---help---
-	  Broadcom 43xx PCI device support.
 
-	  Say Y, if you have a B43 device connected through the PCI bus.
-	  Please note that most PC-CARD devices are (to the kernel) PCI devices,
-	  too and not PCMCIA.
-	  It's safe to select Y here, even if you don't have a B43 PCI device.
+# Auto-select SSB PCICORE driver, if possible
+config B43_PCICORE_AUTOSELECT
+	bool
+	depends on SSB_DRIVER_PCICORE_POSSIBLE
+	select SSB_DRIVER_PCICORE
+	default y
 
 config B43_PCMCIA
 	bool "Broadcom 43xx PCMCIA device support"
-	depends on B43 && SSB_PCMCIAHOST
+	depends on B43 && SSB_PCMCIAHOST_POSSIBLE
+	select SSB_PCMCIAHOST
 	---help---
 	  Broadcom 43xx PCMCIA device support.
 

-- 

