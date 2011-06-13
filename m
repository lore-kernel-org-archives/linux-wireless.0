Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53262 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab1FMOvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 10:51:45 -0400
Received: by bwz15 with SMTP id 15so3757169bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2011 07:51:44 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] bcma: clean exports of functions
Date: Mon, 13 Jun 2011 17:29:47 +0200
Message-Id: <1307978987-2537-1-git-send-email-zajec5@gmail.com> (sfid-20110613_165148_822562_7082D1F2)
In-Reply-To: <1307642840-3043-1-git-send-email-arend@broadcom.com>
References: <1307642840-3043-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I forgot to export function disabling core, which is obviously required
by drivers. Function managing IRQs will be also needed soon.
On the other side we do not expect writing any hosts drivers outside of
bcma, so this is safe to do not export functions related to this.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Rafal Milecki <zajec5@gmail.com>
---
John, if you didn't take "bcma: export bcma_core_disable() function"
yet, can you take this one instead?
---
 drivers/bcma/bcma_private.h          |    4 ++--
 drivers/bcma/core.c                  |    3 ++-
 drivers/bcma/driver_pci.c            |    1 +
 drivers/bcma/main.c                  |    2 --
 include/linux/bcma/bcma.h            |    1 +
 include/linux/bcma/bcma_driver_pci.h |    2 ++
 6 files changed, 8 insertions(+), 5 deletions(-)

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
diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
index ced379f..1ec7d45 100644
--- a/drivers/bcma/core.c
+++ b/drivers/bcma/core.c
@@ -19,7 +19,7 @@ bool bcma_core_is_enabled(struct bcma_device *core)
 }
 EXPORT_SYMBOL_GPL(bcma_core_is_enabled);
 
-static void bcma_core_disable(struct bcma_device *core, u32 flags)
+void bcma_core_disable(struct bcma_device *core, u32 flags)
 {
 	if (bcma_aread32(core, BCMA_RESET_CTL) & BCMA_RESET_CTL_RESET)
 		return;
@@ -31,6 +31,7 @@ static void bcma_core_disable(struct bcma_device *core, u32 flags)
 	bcma_awrite32(core, BCMA_RESET_CTL, BCMA_RESET_CTL_RESET);
 	udelay(1);
 }
+EXPORT_SYMBOL_GPL(bcma_core_disable);
 
 int bcma_core_enable(struct bcma_device *core, u32 flags)
 {
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
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 6ff080e..3895aeb 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -244,6 +244,7 @@ void bcma_awrite32(struct bcma_device *core, u16 offset, u32 value)
 }
 
 extern bool bcma_core_is_enabled(struct bcma_device *core);
+extern void bcma_core_disable(struct bcma_device *core, u32 flags);
 extern int bcma_core_enable(struct bcma_device *core, u32 flags);
 
 #endif /* LINUX_BCMA_H_ */
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

