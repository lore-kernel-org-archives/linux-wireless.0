Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41350
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbXHKAGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 20:06:10 -0400
Message-Id: <20070811000355.861811000@bu3sch.de>
References: <20070811000354.611868000@bu3sch.de>
Date: Sat, 11 Aug 2007 02:03:55 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Aurelien Jarno <aurelien@aurel32.net>
Subject: [patch 1/5] ssb: pcicore compile fix
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aurelien Jarno <aurelien@aurel32.net>

The patch below against 2.6.23-rc1-mm1 fixes the definition of
pcibios_map_irq in the SSB code. The corresponding include file has been
changed in commit 19df0d1169b3ddcc84933794d1401aaafe2f0000.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: ssb-merge/drivers/ssb/driver_pcicore.c
===================================================================
--- ssb-merge.orig/drivers/ssb/driver_pcicore.c	2007-08-10 13:30:22.000000000 +0200
+++ ssb-merge/drivers/ssb/driver_pcicore.c	2007-08-10 13:30:23.000000000 +0200
@@ -102,7 +102,7 @@ static void __init ssb_fixup_pcibridge(s
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_ANY_ID, PCI_ANY_ID, ssb_fixup_pcibridge);
 
-int __init pcibios_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	return ssb_mips_irq(extpci_core->dev) + 2;
 }

-- 

