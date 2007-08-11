Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41348
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbXHKAGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 20:06:10 -0400
Message-Id: <20070811000356.595396000@bu3sch.de>
References: <20070811000354.611868000@bu3sch.de>
Date: Sat, 11 Aug 2007 02:03:56 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Aurelien Jarno <aurelien@aurel32.net>
Subject: [patch 2/5] ssb: pci core driver fixes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aurelien Jarno <aurelien@aurel32.net>

Fixes various things on the SSB
PCI core driver:
 - Correctly write the configuration register value in 
   ssb_extpci_write_config() for len = 1 or len = 2.
 - Set the PCI_LATENCY_TIMER to handle devices on the PCI bus.
 - Set the PCI arbiter control to internal.
 - Add some delay between the configuration of the PCI controller 
   and its registration.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: ssb-merge/drivers/ssb/driver_pcicore.c
===================================================================
--- ssb-merge.orig/drivers/ssb/driver_pcicore.c	2007-08-10 13:30:23.000000000 +0200
+++ ssb-merge/drivers/ssb/driver_pcicore.c	2007-08-10 13:30:50.000000000 +0200
@@ -99,6 +99,9 @@ static void __init ssb_fixup_pcibridge(s
 
 	/* Enable PCI bridge BAR1 prefetch and burst */
 	pci_write_config_dword(dev, SSB_BAR1_CONTROL, 3);
+
+	/* Make sure our latency is high enough to handle the devices behind us */
+	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0xa8);
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_ANY_ID, PCI_ANY_ID, ssb_fixup_pcibridge);
 
@@ -230,7 +233,7 @@ static int ssb_extpci_write_config(struc
 		val = *((const u32 *)buf);
 		break;
 	}
-	writel(*((const u32 *)buf), mmio);
+	writel(val, mmio);
 
 	err = 0;
 unmap:
@@ -311,6 +314,8 @@ static void ssb_pcicore_init_hostmode(st
 	udelay(150); /* Assertion time demanded by the PCI standard */
 	val |= SSB_PCICORE_CTL_RST; /* Deassert RST# */
 	pcicore_write32(pc, SSB_PCICORE_CTL, val);
+	val = SSB_PCICORE_ARBCTL_INTERN;
+	pcicore_write32(pc, SSB_PCICORE_ARBCTL, val);
 	udelay(1); /* Assertion time demanded by the PCI standard */
 
 	/*TODO cardbus mode */
@@ -340,6 +345,9 @@ static void ssb_pcicore_init_hostmode(st
 	 * The following needs change, if we want to port hostmode
 	 * to non-MIPS platform. */
 	set_io_port_base((unsigned long)ioremap_nocache(SSB_PCI_MEM, 0x04000000));
+	/* Give some time to the PCI controller to configure itself with the new
+	 * values. Not waiting at this point causes crashes of the machine. */
+	mdelay(10);
 	register_pci_controller(&ssb_pcicore_controller);
 }
 

-- 

