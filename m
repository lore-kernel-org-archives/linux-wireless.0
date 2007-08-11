Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41354
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbXHKAGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 20:06:10 -0400
Message-Id: <20070811000357.633337000@bu3sch.de>
References: <20070811000354.611868000@bu3sch.de>
Date: Sat, 11 Aug 2007 02:03:58 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 4/5] ssb: Fix EXPERIMENTAL annotations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ssb-core is not experimental anymore.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: ssb-merge/drivers/ssb/Kconfig
===================================================================
--- ssb-merge.orig/drivers/ssb/Kconfig	2007-08-10 12:52:50.000000000 +0200
+++ ssb-merge/drivers/ssb/Kconfig	2007-08-10 13:35:27.000000000 +0200
@@ -2,7 +2,7 @@ menu "Sonics Silicon Backplane"
 
 config SSB
 	tristate "Sonics Silicon Backplane support"
-	depends on EXPERIMENTAL && HAS_IOMEM
+	depends on HAS_IOMEM
 	help
 	  Support for the Sonics Silicon Backplane bus
 
@@ -21,8 +21,8 @@ config SSB_PCIHOST
 	  If unsure, say Y
 
 config SSB_PCMCIAHOST
-	bool "Support for SSB on PCMCIA-bus host"
-	depends on SSB && PCMCIA
+	bool "Support for SSB on PCMCIA-bus host (EXPERIMENTAL)"
+	depends on SSB && PCMCIA && EXPERIMENTAL
 	help
 	  Support for a Sonics Silicon Backplane on top
 	  of a PCMCIA device.
@@ -65,14 +65,14 @@ config SSB_DRIVER_PCICORE
 	  If unsure, say Y
 
 config SSB_PCICORE_HOSTMODE
-	bool "Hostmode support for SSB PCI core"
-	depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS
+	bool "Hostmode support for SSB PCI core (EXPERIMENTAL)"
+	depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS && EXPERIMENTAL
 	help
 	  PCIcore hostmode operation (external PCI bus).
 
 config SSB_DRIVER_MIPS
-	bool "SSB Broadcom MIPS core driver"
-	depends on SSB && MIPS
+	bool "SSB Broadcom MIPS core driver (EXPERIMENTAL)"
+	depends on SSB && MIPS && EXPERIMENTAL
 	select SSB_SERIAL
 	help
 	  Driver for the Sonics Silicon Backplane attached
@@ -81,8 +81,8 @@ config SSB_DRIVER_MIPS
 	  If unsure, say N
 
 config SSB_DRIVER_EXTIF
-	bool "SSB Broadcom EXTIF core driver"
-	depends on SSB_DRIVER_MIPS
+	bool "SSB Broadcom EXTIF core driver (EXPERIMENTAL)"
+	depends on SSB_DRIVER_MIPS && EXPERIMENTAL
 	help
 	  Driver for the Sonics Silicon Backplane attached
 	  Broadcom EXTIF core.

-- 

