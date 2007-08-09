Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41841
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761317AbXHIAO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 20:14:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: pcicore compile fix
Date: Thu, 9 Aug 2007 02:14:08 +0200
Cc: aurelien@aurel32.net, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200708090214.08991.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aurelien Jarno <aurelien@aurel32.net>

The patch below against 2.6.23-rc1-mm1 fixes the definition of
pcibios_map_irq in the SSB code. The corresponding include file has been
changed in commit 19df0d1169b3ddcc84933794d1401aaafe2f0000.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

diff -puN drivers/ssb/driver_pcicore.c~ssb-compile-fix drivers/ssb/driver_pcicore.c
--- a/drivers/ssb/driver_pcicore.c~ssb-compile-fix
+++ a/drivers/ssb/driver_pcicore.c
@@ -102,7 +102,7 @@ static void __init ssb_fixup_pcibridge(s
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_ANY_ID, PCI_ANY_ID, ssb_fixup_pcibridge);
 
-int __init pcibios_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	return ssb_mips_irq(extpci_core->dev) + 2;
 }
_

