Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51210 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881Ab3HWWcq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 18:32:46 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/5] bcma: do not export bcma_core_pci_extend_L1timer()
Date: Sat, 24 Aug 2013 00:32:32 +0200
Message-Id: <1377297154-14525-3-git-send-email-hauke@hauke-m.de> (sfid-20130824_003252_151217_8B5FBB67)
In-Reply-To: <1377297154-14525-1-git-send-email-hauke@hauke-m.de>
References: <1377297154-14525-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is not called any more, do not export it.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_pci.c            |    3 +--
 include/linux/bcma/bcma_driver_pci.h |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index 6ea817f..d51d194 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -262,7 +262,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(bcma_core_pci_irq_ctl);
 
-void bcma_core_pci_extend_L1timer(struct bcma_drv_pci *pc, bool extend)
+static void bcma_core_pci_extend_L1timer(struct bcma_drv_pci *pc, bool extend)
 {
 	u32 w;
 
@@ -274,7 +274,6 @@ void bcma_core_pci_extend_L1timer(struct bcma_drv_pci *pc, bool extend)
 	bcma_pcie_write(pc, BCMA_CORE_PCI_DLLP_PMTHRESHREG, w);
 	bcma_pcie_read(pc, BCMA_CORE_PCI_DLLP_PMTHRESHREG);
 }
-EXPORT_SYMBOL_GPL(bcma_core_pci_extend_L1timer);
 
 void bcma_core_pci_up(struct bcma_bus *bus)
 {
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 27f9ceb..0234955 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -220,7 +220,6 @@ struct bcma_drv_pci {
 extern void bcma_core_pci_init(struct bcma_drv_pci *pc);
 extern int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc,
 				 struct bcma_device *core, bool enable);
-extern void bcma_core_pci_extend_L1timer(struct bcma_drv_pci *pc, bool extend);
 extern void bcma_core_pci_up(struct bcma_bus *bus);
 extern void bcma_core_pci_down(struct bcma_bus *bus);
 
-- 
1.7.10.4

