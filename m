Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46416 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbZCTPsQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 11:48:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] ssb: remove EXPERIMENTAL dependencies.
Date: Fri, 20 Mar 2009 16:43:20 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903201643.20500.mb@bu3sch.de> (sfid-20090320_164819_323652_57A08BD7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ssb is not experimental anymore.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for the next feature release.


Index: wireless-testing/drivers/ssb/Kconfig
===================================================================
--- wireless-testing.orig/drivers/ssb/Kconfig	2009-03-20 16:40:14.000000000 +0100
+++ wireless-testing/drivers/ssb/Kconfig	2009-03-20 16:40:59.000000000 +0100
@@ -53,11 +53,11 @@ config SSB_B43_PCI_BRIDGE
 
 config SSB_PCMCIAHOST_POSSIBLE
 	bool
-	depends on SSB && (PCMCIA = y || PCMCIA = SSB) && EXPERIMENTAL
+	depends on SSB && (PCMCIA = y || PCMCIA = SSB)
 	default y
 
 config SSB_PCMCIAHOST
-	bool "Support for SSB on PCMCIA-bus host (EXPERIMENTAL)"
+	bool "Support for SSB on PCMCIA-bus host"
 	depends on SSB_PCMCIAHOST_POSSIBLE
 	select SSB_SPROM
 	help
@@ -107,14 +107,14 @@ config SSB_DRIVER_PCICORE
 	  If unsure, say Y
 
 config SSB_PCICORE_HOSTMODE
-	bool "Hostmode support for SSB PCI core (EXPERIMENTAL)"
-	depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS && EXPERIMENTAL
+	bool "Hostmode support for SSB PCI core"
+	depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS
 	help
 	  PCIcore hostmode operation (external PCI bus).
 
 config SSB_DRIVER_MIPS
-	bool "SSB Broadcom MIPS core driver (EXPERIMENTAL)"
-	depends on SSB && MIPS && EXPERIMENTAL
+	bool "SSB Broadcom MIPS core driver"
+	depends on SSB && MIPS
 	select SSB_SERIAL
 	help
 	  Driver for the Sonics Silicon Backplane attached
@@ -129,8 +129,8 @@ config SSB_EMBEDDED
 	default y
 
 config SSB_DRIVER_EXTIF
-	bool "SSB Broadcom EXTIF core driver (EXPERIMENTAL)"
-	depends on SSB_DRIVER_MIPS && EXPERIMENTAL
+	bool "SSB Broadcom EXTIF core driver"
+	depends on SSB_DRIVER_MIPS
 	help
 	  Driver for the Sonics Silicon Backplane attached
 	  Broadcom EXTIF core.

-- 
Greetings, Michael.
