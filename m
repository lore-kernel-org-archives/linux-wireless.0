Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39152 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab1FQWXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 18:23:44 -0400
Received: by eyx24 with SMTP id 24so1078682eyx.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 15:23:43 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2] bcma: clean exports of functions
Date: Sat, 18 Jun 2011 01:01:59 +0200
Message-Id: <1308351719-6215-1-git-send-email-zajec5@gmail.com> (sfid-20110618_002347_941810_2C04EE73)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Function managing IRQs is needed for external drivers like b43.
On the other side we do not expect writing any hosts drivers outside of
bcma, so this is safe to do not export functions related to this.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: John, I asked you to take my V1 instead of "bcma: export
bcma_core_disable() function", however today I can see you took the
patch in question anyway.
So I prepared V2 which is V1 - CHANGES_FROM_ARENDS_PATCH.
You can take it on top of applied Arend's patch, without reverting etc.
---
 drivers/bcma/bcma_private.h          |    4 ++--
 drivers/bcma/driver_pci.c            |    1 +
 drivers/bcma/main.c                  |    2 --
 include/linux/bcma/bcma_driver_pci.h |    2 ++
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 12a75ab..4228736 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -13,8 +13,8 @@
 struct bcma_bus;
 
 /* main.c */
-extern int bcma_bus_register(struct bcma_bus *bus);
-extern void bcma_bus_unregister(struct bcma_bus *bus);
+int bcma_bus_register(struct bcma_bus *bus);
+void bcma_bus_unregister(struct bcma_bus *bus);
 
 /* scan.c */
 int bcma_bus_scan(struct bcma_bus *bus);
diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index 789d68b..b0c19ed 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -184,3 +184,4 @@ int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc, struct bcma_device *core,
 out:
 	return err;
 }
+EXPORT_SYMBOL_GPL(bcma_core_pci_irq_ctl);
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 11e96dc..ba15105 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -160,13 +160,11 @@ int bcma_bus_register(struct bcma_bus *bus)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(bcma_bus_register);
 
 void bcma_bus_unregister(struct bcma_bus *bus)
 {
 	bcma_unregister_cores(bus);
 }
-EXPORT_SYMBOL_GPL(bcma_bus_unregister);
 
 int __bcma_driver_register(struct bcma_driver *drv, struct module *owner)
 {
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index b7e191c..3871b66 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -85,5 +85,7 @@ struct bcma_drv_pci {
 #define pcicore_write32(pc, offset, val)	bcma_write32((pc)->core, offset, val)
 
 extern void bcma_core_pci_init(struct bcma_drv_pci *pc);
+extern int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc,
+				 struct bcma_device *core, bool enable);
 
 #endif /* LINUX_BCMA_DRIVER_PCI_H_ */
-- 
1.7.3.4

