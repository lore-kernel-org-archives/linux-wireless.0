Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51199 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab3HWWco (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 18:32:44 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/5] bcma: add method to power up and down the PCIe core by wifi driver
Date: Sat, 24 Aug 2013 00:32:30 +0200
Message-Id: <1377297154-14525-1-git-send-email-hauke@hauke-m.de> (sfid-20130824_003249_648938_0418C486)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wifi driver should tell the PCIe core that it is now in operation
so that some workarounds can be applied and the power state is changed.
This should replace the call to bcma_core_pci_extend_L1timer by the
brcmsmac driver.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_pci.c            |   26 ++++++++++++++++++++++++++
 include/linux/bcma/bcma_driver_pci.h |    3 +++
 2 files changed, 29 insertions(+)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index cf7a476..6ea817f 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -275,3 +275,29 @@ void bcma_core_pci_extend_L1timer(struct bcma_drv_pci *pc, bool extend)
 	bcma_pcie_read(pc, BCMA_CORE_PCI_DLLP_PMTHRESHREG);
 }
 EXPORT_SYMBOL_GPL(bcma_core_pci_extend_L1timer);
+
+void bcma_core_pci_up(struct bcma_bus *bus)
+{
+	struct bcma_drv_pci *pc;
+
+	if (bus->hosttype != BCMA_HOSTTYPE_PCI)
+		return;
+
+	pc = &bus->drv_pci[0];
+
+	bcma_core_pci_extend_L1timer(pc, true);
+}
+EXPORT_SYMBOL_GPL(bcma_core_pci_up);
+
+void bcma_core_pci_down(struct bcma_bus *bus)
+{
+	struct bcma_drv_pci *pc;
+
+	if (bus->hosttype != BCMA_HOSTTYPE_PCI)
+		return;
+
+	pc = &bus->drv_pci[0];
+
+	bcma_core_pci_extend_L1timer(pc, false);
+}
+EXPORT_SYMBOL_GPL(bcma_core_pci_down);
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 424760f..27f9ceb 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -185,6 +185,7 @@ struct pci_dev;
 #define BCMA_CORE_PCI_RC_CRS_VISIBILITY		0x0001
 
 struct bcma_drv_pci;
+struct bcma_bus;
 
 #ifdef CONFIG_BCMA_DRIVER_PCI_HOSTMODE
 struct bcma_drv_pci_host {
@@ -220,6 +221,8 @@ extern void bcma_core_pci_init(struct bcma_drv_pci *pc);
 extern int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc,
 				 struct bcma_device *core, bool enable);
 extern void bcma_core_pci_extend_L1timer(struct bcma_drv_pci *pc, bool extend);
+extern void bcma_core_pci_up(struct bcma_bus *bus);
+extern void bcma_core_pci_down(struct bcma_bus *bus);
 
 extern int bcma_core_pci_pcibios_map_irq(const struct pci_dev *dev);
 extern int bcma_core_pci_plat_dev_init(struct pci_dev *dev);
-- 
1.7.10.4

