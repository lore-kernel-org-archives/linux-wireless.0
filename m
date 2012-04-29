Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44803 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab2D2ATU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:19:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, arend@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/4] bcma: add bcma_core_pci_extend_L1timer
Date: Sun, 29 Apr 2012 02:18:50 +0200
Message-Id: <1335658732-24351-3-git-send-email-hauke@hauke-m.de> (sfid-20120429_021957_024780_50054B67)
In-Reply-To: <1335658732-24351-1-git-send-email-hauke@hauke-m.de>
References: <1335658732-24351-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code is based on code from pcie_extendL1timer() in brcmsmac. This
patch is part of the move of pci specific code from brcmsmac to bcma.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_pci.c            |   16 ++++++++++++++--
 include/linux/bcma/bcma_driver_pci.h |    2 ++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index 4d38ae1..9492066 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -24,14 +24,12 @@ u32 bcma_pcie_read(struct bcma_drv_pci *pc, u32 address)
 	return pcicore_read32(pc, BCMA_CORE_PCI_PCIEIND_DATA);
 }
 
-#if 0
 static void bcma_pcie_write(struct bcma_drv_pci *pc, u32 address, u32 data)
 {
 	pcicore_write32(pc, BCMA_CORE_PCI_PCIEIND_ADDR, address);
 	pcicore_read32(pc, BCMA_CORE_PCI_PCIEIND_ADDR);
 	pcicore_write32(pc, BCMA_CORE_PCI_PCIEIND_DATA, data);
 }
-#endif
 
 static void bcma_pcie_mdio_set_phy(struct bcma_drv_pci *pc, u8 phy)
 {
@@ -224,3 +222,17 @@ out:
 	return err;
 }
 EXPORT_SYMBOL_GPL(bcma_core_pci_irq_ctl);
+
+void bcma_core_pci_extend_L1timer(struct bcma_drv_pci *pc, bool extend)
+{
+	u32 w;
+
+	w = bcma_pcie_read(pc, BCMA_CORE_PCI_DLLP_PMTHRESHREG);
+	if (extend)
+		w |= BCMA_CORE_PCI_ASPMTIMER_EXTEND;
+	else
+		w &= ~BCMA_CORE_PCI_ASPMTIMER_EXTEND;
+	bcma_pcie_write(pc, BCMA_CORE_PCI_DLLP_PMTHRESHREG, w);
+	bcma_pcie_read(pc, BCMA_CORE_PCI_DLLP_PMTHRESHREG);
+}
+EXPORT_SYMBOL_GPL(bcma_core_pci_extend_L1timer);
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 46c71e2..20c9f96 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -133,6 +133,7 @@ struct pci_dev;
 #define BCMA_CORE_PCI_DLLP_LRREG		0x120	/* Link Replay */
 #define BCMA_CORE_PCI_DLLP_LACKTOREG		0x124	/* Link Ack Timeout */
 #define BCMA_CORE_PCI_DLLP_PMTHRESHREG		0x128	/* Power Management Threshold */
+#define  BCMA_CORE_PCI_ASPMTIMER_EXTEND		0x01000000 /* > rev7: enable extend ASPM timer */
 #define BCMA_CORE_PCI_DLLP_RTRYWPREG		0x12C	/* Retry buffer write ptr */
 #define BCMA_CORE_PCI_DLLP_RTRYRPREG		0x130	/* Retry buffer Read ptr */
 #define BCMA_CORE_PCI_DLLP_RTRYPPREG		0x134	/* Retry buffer Purged ptr */
@@ -207,6 +208,7 @@ struct bcma_drv_pci {
 extern void __devinit bcma_core_pci_init(struct bcma_drv_pci *pc);
 extern int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc,
 				 struct bcma_device *core, bool enable);
+extern void bcma_core_pci_extend_L1timer(struct bcma_drv_pci *pc, bool extend);
 
 extern int bcma_core_pci_pcibios_map_irq(const struct pci_dev *dev);
 extern int bcma_core_pci_plat_dev_init(struct pci_dev *dev);
-- 
1.7.9.5

