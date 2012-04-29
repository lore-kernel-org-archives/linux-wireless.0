Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44817 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933Ab2D2ATY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:19:24 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, arend@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] bcma: add bcma_core_pci_config_fixup()
Date: Sun, 29 Apr 2012 02:18:52 +0200
Message-Id: <1335658732-24351-5-git-send-email-hauke@hauke-m.de> (sfid-20120429_021956_510839_214C75F5)
In-Reply-To: <1335658732-24351-1-git-send-email-hauke@hauke-m.de>
References: <1335658732-24351-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code is based on code from pcie_misc_config_fixup() in brcmsmac.
This patch is part of the move of pci specific code from brcmsmac to
bcma.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_pci.c            |   18 ++++++++++++++++++
 include/linux/bcma/bcma_driver_pci.h |    4 ++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index 472d14f..9a96f14 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -186,6 +186,23 @@ static void bcma_core_pci_fixcfg(struct bcma_drv_pci *pc)
 	}
 }
 
+/* Fix MISC config to allow coming out of L2/L3-Ready state w/o PRST */
+/* Needs to happen when coming out of 'standby'/'hibernate' */
+static void bcma_core_pci_config_fixup(struct bcma_drv_pci *pc)
+{
+	u16 val16;
+	uint regoff;
+
+	regoff = BCMA_CORE_PCI_SPROM(BCMA_CORE_PCI_SPROM_MISC_CONFIG);
+
+	val16 = pcicore_read16(pc, regoff);
+
+	if (!(val16 & BCMA_CORE_PCI_SPROM_L23READY_EXIT_NOPERST)) {
+		val16 |= BCMA_CORE_PCI_SPROM_L23READY_EXIT_NOPERST;
+		pcicore_write16(pc, regoff, val16);
+	}
+}
+
 /**************************************************
  * Init.
  **************************************************/
@@ -194,6 +211,7 @@ static void __devinit bcma_core_pci_clientmode_init(struct bcma_drv_pci *pc)
 {
 	bcma_core_pci_fixcfg(pc);
 	bcma_pcicore_serdes_workaround(pc);
+	bcma_core_pci_config_fixup(pc);
 }
 
 void __devinit bcma_core_pci_init(struct bcma_drv_pci *pc)
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 5b0542c..41da581 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -90,6 +90,10 @@ struct pci_dev;
 #define  BCMA_CORE_PCI_SPROM_PI_OFFSET		0	/* first word */
 #define   BCMA_CORE_PCI_SPROM_PI_MASK		0xf000	/* bit 15:12 */
 #define   BCMA_CORE_PCI_SPROM_PI_SHIFT		12	/* bit 15:12 */
+#define  BCMA_CORE_PCI_SPROM_MISC_CONFIG	5	/* word 5 */
+#define   BCMA_CORE_PCI_SPROM_L23READY_EXIT_NOPERST	0x8000	/* bit 15 */
+#define   BCMA_CORE_PCI_SPROM_CLKREQ_OFFSET_REV5	20	/* word 20 for srom rev <= 5 */
+#define   BCMA_CORE_PCI_SPROM_CLKREQ_ENB	0x0800	/* bit 11 */
 
 /* SBtoPCIx */
 #define BCMA_CORE_PCI_SBTOPCI_MEM		0x00000000
-- 
1.7.9.5

