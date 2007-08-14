Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50355
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765539AbXHNRA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 13:00:58 -0400
Message-Id: <20070814165750.102981000@bu3sch.de>
References: <20070814165746.863593000@bu3sch.de>
Date: Tue, 14 Aug 2007 18:57:53 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 7/7] ssb: Add kconfig SELECT workaround
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: ssb-merge-new/drivers/ssb/Kconfig
===================================================================
--- ssb-merge-new.orig/drivers/ssb/Kconfig	2007-08-14 17:05:12.000000000 +0200
+++ ssb-merge-new/drivers/ssb/Kconfig	2007-08-14 17:22:13.000000000 +0200
@@ -1,18 +1,33 @@
 menu "Sonics Silicon Backplane"
 
+config SSB_POSSIBLE
+	bool
+	depends on HAS_IOMEM
+	default y
+
 config SSB
 	tristate "Sonics Silicon Backplane support"
-	depends on HAS_IOMEM
+	depends on SSB_POSSIBLE
 	help
-	  Support for the Sonics Silicon Backplane bus
+	  Support for the Sonics Silicon Backplane bus.
+	  You only need to enable this option, if you are
+	  configuring a kernel for an embedded system with
+	  this bus.
+	  It will be auto-selected if needed in other
+	  environments.
 
-	  The module will be called ssb
+	  The module will be called ssb.
 
-	  If unsure, say M
+	  If unsure, say N.
+
+config SSB_PCIHOST_POSSIBLE
+	bool
+	depends on SSB && PCI
+	default y
 
 config SSB_PCIHOST
 	bool "Support for SSB on PCI-bus host"
-	depends on SSB && PCI
+	depends on SSB_PCIHOST_POSSIBLE
 	default y
 	help
 	  Support for a Sonics Silicon Backplane on top
@@ -20,9 +35,14 @@ config SSB_PCIHOST
 
 	  If unsure, say Y
 
+config SSB_PCMCIAHOST_POSSIBLE
+	bool
+	depends on SSB && PCMCIA && EXPERIMENTAL
+	default y
+
 config SSB_PCMCIAHOST
 	bool "Support for SSB on PCMCIA-bus host (EXPERIMENTAL)"
-	depends on SSB && PCMCIA && EXPERIMENTAL
+	depends on SSB_PCMCIAHOST_POSSIBLE
 	help
 	  Support for a Sonics Silicon Backplane on top
 	  of a PCMCIA device.
@@ -31,7 +51,7 @@ config SSB_PCMCIAHOST
 
 config SSB_SILENT
 	bool "No SSB kernel messages"
-	depends on SSB
+	depends on SSB && EMBEDDED
 	help
 	  This option turns off all Sonics Silicon Backplane printks.
 	  Note that you won't be able to identify problems, once
@@ -55,9 +75,14 @@ config SSB_SERIAL
 	depends on SSB
 	# ChipCommon and ExtIf serial support routines.
 
+config SSB_DRIVER_PCICORE_POSSIBLE
+	bool
+	depends on SSB_PCIHOST
+	default y
+
 config SSB_DRIVER_PCICORE
 	bool "SSB PCI core driver"
-	depends on SSB && SSB_PCIHOST
+	depends on SSB_DRIVER_PCICORE_POSSIBLE
 	help
 	  Driver for the Sonics Silicon Backplane attached
 	  Broadcom PCI core.

-- 

