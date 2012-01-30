Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35980 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab2A3XE1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 18:04:27 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/7] bcma: make some functions __devinit
Date: Tue, 31 Jan 2012 00:03:34 +0100
Message-Id: <1327964617-7910-5-git-send-email-hauke@hauke-m.de> (sfid-20120131_000430_869998_50FD5A2C)
In-Reply-To: <1327964617-7910-1-git-send-email-hauke@hauke-m.de>
References: <1327964617-7910-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bcma_core_pci_hostmode_init() has to be in __devinit as it will call a
function in that section and so all functions calling it also have to
be in __devinit.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/bcma_private.h          |    4 ++--
 drivers/bcma/driver_pci.c            |    6 +++---
 drivers/bcma/driver_pci_host.c       |    2 +-
 drivers/bcma/host_pci.c              |    4 ++--
 drivers/bcma/main.c                  |    2 +-
 include/linux/bcma/bcma_driver_pci.h |    2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 6109da5..63c5242 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -13,7 +13,7 @@
 struct bcma_bus;
 
 /* main.c */
-int bcma_bus_register(struct bcma_bus *bus);
+int __devinit bcma_bus_register(struct bcma_bus *bus);
 void bcma_bus_unregister(struct bcma_bus *bus);
 int __init bcma_bus_early_register(struct bcma_bus *bus,
 				   struct bcma_device *core_cc,
@@ -52,7 +52,7 @@ extern void __exit bcma_host_pci_exit(void);
 u32 bcma_pcie_read(struct bcma_drv_pci *pc, u32 address);
 
 #ifdef CONFIG_BCMA_DRIVER_PCI_HOSTMODE
-void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc);
+void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc);
 #endif /* CONFIG_BCMA_DRIVER_PCI_HOSTMODE */
 
 #endif
diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index 20ceebd..161c8ba 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -174,12 +174,12 @@ static void bcma_pcicore_serdes_workaround(struct bcma_drv_pci *pc)
  * Init.
  **************************************************/
 
-static void bcma_core_pci_clientmode_init(struct bcma_drv_pci *pc)
+static void __devinit bcma_core_pci_clientmode_init(struct bcma_drv_pci *pc)
 {
 	bcma_pcicore_serdes_workaround(pc);
 }
 
-static bool bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc)
+static bool __devinit bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc)
 {
 	struct bcma_bus *bus = pc->core->bus;
 	u16 chipid_top;
@@ -204,7 +204,7 @@ static bool bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc)
 	return true;
 }
 
-void bcma_core_pci_init(struct bcma_drv_pci *pc)
+void __devinit bcma_core_pci_init(struct bcma_drv_pci *pc)
 {
 	if (pc->setup_done)
 		return;
diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index eb332b7..99e040b 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -8,7 +8,7 @@
 #include "bcma_private.h"
 #include <linux/bcma/bcma.h>
 
-void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
+void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 {
 	pr_err("No support for PCI core in hostmode yet\n");
 }
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index f59244e..e3928d6 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -154,8 +154,8 @@ const struct bcma_host_ops bcma_host_pci_ops = {
 	.awrite32	= bcma_host_pci_awrite32,
 };
 
-static int bcma_host_pci_probe(struct pci_dev *dev,
-			     const struct pci_device_id *id)
+static int __devinit bcma_host_pci_probe(struct pci_dev *dev,
+					 const struct pci_device_id *id)
 {
 	struct bcma_bus *bus;
 	int err = -ENOMEM;
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index febbc0a..3363036 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -132,7 +132,7 @@ static void bcma_unregister_cores(struct bcma_bus *bus)
 	}
 }
 
-int bcma_bus_register(struct bcma_bus *bus)
+int __devinit bcma_bus_register(struct bcma_bus *bus)
 {
 	int err;
 	struct bcma_device *core;
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 67ea7be..679d4ca 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -169,7 +169,7 @@ struct bcma_drv_pci {
 #define pcicore_read32(pc, offset)		bcma_read32((pc)->core, offset)
 #define pcicore_write32(pc, offset, val)	bcma_write32((pc)->core, offset, val)
 
-extern void bcma_core_pci_init(struct bcma_drv_pci *pc);
+extern void __devinit bcma_core_pci_init(struct bcma_drv_pci *pc);
 extern int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc,
 				 struct bcma_device *core, bool enable);
 
-- 
1.7.5.4

