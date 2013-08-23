Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50935 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab3HWVXS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 17:23:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: change max PCI read request size to 128
Date: Fri, 23 Aug 2013 23:22:29 +0200
Message-Id: <1377292949-7033-1-git-send-email-hauke@hauke-m.de> (sfid-20130823_232322_263408_F37FDE02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This PCIe controller does not support a max read request size above 128
bytes. The sold card I tested this controller with used 128 as default
value, but some new routers are sold with BCM4331 chips, which have a
default max read request size of 512. This device fails at the first
DMA reqeust whch is bigger than 126 bytes.

This patch changes the max read request size to 128 for every device on
the PCIe link.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_pci_host.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index 30629a3..c3d7b03 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -581,6 +581,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, bcma_core_pci_fixup_addresses);
 int bcma_core_pci_plat_dev_init(struct pci_dev *dev)
 {
 	struct bcma_drv_pci_host *pc_host;
+	int readrq;
 
 	if (dev->bus->ops->read != bcma_core_pci_hostmode_read_config) {
 		/* This is not a device on the PCI-core bridge. */
@@ -595,6 +596,11 @@ int bcma_core_pci_plat_dev_init(struct pci_dev *dev)
 	dev->irq = bcma_core_irq(pc_host->pdev->core);
 	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, dev->irq);
 
+	readrq = pcie_get_readrq(dev);
+	if (readrq > 128) {
+		pr_info("change PCIe max read request size from %i to 128\n", readrq);
+		pcie_set_readrq(dev, 128);
+	}
 	return 0;
 }
 EXPORT_SYMBOL(bcma_core_pci_plat_dev_init);
-- 
1.7.10.4

