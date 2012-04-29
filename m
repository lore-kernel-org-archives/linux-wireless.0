Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44809 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882Ab2D2ATW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:19:22 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, arend@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/4] bcma: add bcma_core_pci_fixcfg()
Date: Sun, 29 Apr 2012 02:18:51 +0200
Message-Id: <1335658732-24351-4-git-send-email-hauke@hauke-m.de> (sfid-20120429_021954_233550_E7C8DB05)
In-Reply-To: <1335658732-24351-1-git-send-email-hauke@hauke-m.de>
References: <1335658732-24351-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code is based on code from pcicore_fixcfg() in brcmsmac. This
patch is part of the move of pci specific code from brcmsmac to bcma.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_pci.c            |   19 +++++++++++++++++++
 include/linux/bcma/bcma_driver_pci.h |    5 +++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index 9492066..472d14f 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -168,12 +168,31 @@ static void bcma_pcicore_serdes_workaround(struct bcma_drv_pci *pc)
 		                     tmp & ~BCMA_CORE_PCI_PLL_CTRL_FREQDET_EN);
 }
 
+static void bcma_core_pci_fixcfg(struct bcma_drv_pci *pc)
+{
+	struct bcma_device *core = pc->core;
+	u16 val16, core_index;
+	uint regoff;
+
+	regoff = BCMA_CORE_PCI_SPROM(BCMA_CORE_PCI_SPROM_PI_OFFSET);
+	core_index = (u16)core->core_index;
+
+	val16 = pcicore_read16(pc, regoff);
+	if (((val16 & BCMA_CORE_PCI_SPROM_PI_MASK) >> BCMA_CORE_PCI_SPROM_PI_SHIFT)
+	     != core_index) {
+		val16 = (core_index << BCMA_CORE_PCI_SPROM_PI_SHIFT) |
+			(val16 & ~BCMA_CORE_PCI_SPROM_PI_MASK);
+		pcicore_write16(pc, regoff, val16);
+	}
+}
+
 /**************************************************
  * Init.
  **************************************************/
 
 static void __devinit bcma_core_pci_clientmode_init(struct bcma_drv_pci *pc)
 {
+	bcma_core_pci_fixcfg(pc);
 	bcma_pcicore_serdes_workaround(pc);
 }
 
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 20c9f96..5b0542c 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -87,6 +87,9 @@ struct pci_dev;
 #define BCMA_CORE_PCI_PCICFG2			0x0600	/* PCI config space 2 (rev >= 8) */
 #define BCMA_CORE_PCI_PCICFG3			0x0700	/* PCI config space 3 (rev >= 8) */
 #define BCMA_CORE_PCI_SPROM(wordoffset)		(0x0800 + ((wordoffset) * 2)) /* SPROM shadow area (72 bytes) */
+#define  BCMA_CORE_PCI_SPROM_PI_OFFSET		0	/* first word */
+#define   BCMA_CORE_PCI_SPROM_PI_MASK		0xf000	/* bit 15:12 */
+#define   BCMA_CORE_PCI_SPROM_PI_SHIFT		12	/* bit 15:12 */
 
 /* SBtoPCIx */
 #define BCMA_CORE_PCI_SBTOPCI_MEM		0x00000000
@@ -202,7 +205,9 @@ struct bcma_drv_pci {
 };
 
 /* Register access */
+#define pcicore_read16(pc, offset)		bcma_read16((pc)->core, offset)
 #define pcicore_read32(pc, offset)		bcma_read32((pc)->core, offset)
+#define pcicore_write16(pc, offset, val)	bcma_write16((pc)->core, offset, val)
 #define pcicore_write32(pc, offset, val)	bcma_write32((pc)->core, offset, val)
 
 extern void __devinit bcma_core_pci_init(struct bcma_drv_pci *pc);
-- 
1.7.9.5

