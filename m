Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41402 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab2KSSdT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 13:33:19 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=20220/493=5D=20bcma=3A=20remove=20use=20of=20=5F=5Fdevinit?=
Date: Mon, 19 Nov 2012 13:22:49 -0500
Message-Id: <1353349642-3677-220-git-send-email-wfp5p@virginia.edu> (sfid-20121119_193331_875608_9C4EF98E)
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devinit is no longer
needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: "Rafał Miłecki" <zajec5@gmail.com> 
Cc: linux-wireless@vger.kernel.org 
---
 drivers/bcma/bcma_private.h               | 6 +++---
 drivers/bcma/driver_gmac_cmn.c            | 2 +-
 drivers/bcma/driver_pci.c                 | 4 ++--
 drivers/bcma/driver_pci_host.c            | 8 ++++----
 drivers/bcma/host_pci.c                   | 2 +-
 drivers/bcma/main.c                       | 2 +-
 include/linux/bcma/bcma_driver_gmac_cmn.h | 2 +-
 include/linux/bcma/bcma_driver_pci.h      | 2 +-
 8 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 169fc58..f73fcf7 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -22,7 +22,7 @@
 struct bcma_bus;
 
 /* main.c */
-int __devinit bcma_bus_register(struct bcma_bus *bus);
+int bcma_bus_register(struct bcma_bus *bus);
 void bcma_bus_unregister(struct bcma_bus *bus);
 int __init bcma_bus_early_register(struct bcma_bus *bus,
 				   struct bcma_device *core_cc,
@@ -85,8 +85,8 @@ extern void __exit bcma_host_pci_exit(void);
 u32 bcma_pcie_read(struct bcma_drv_pci *pc, u32 address);
 
 #ifdef CONFIG_BCMA_DRIVER_PCI_HOSTMODE
-bool __devinit bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc);
-void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc);
+bool bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc);
+void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc);
 #endif /* CONFIG_BCMA_DRIVER_PCI_HOSTMODE */
 
 #endif
diff --git a/drivers/bcma/driver_gmac_cmn.c b/drivers/bcma/driver_gmac_cmn.c
index 834225f..dcb1379 100644
--- a/drivers/bcma/driver_gmac_cmn.c
+++ b/drivers/bcma/driver_gmac_cmn.c
@@ -8,7 +8,7 @@
 #include "bcma_private.h"
 #include <linux/bcma/bcma.h>
 
-void __devinit bcma_core_gmac_cmn_init(struct bcma_drv_gmac_cmn *gc)
+void bcma_core_gmac_cmn_init(struct bcma_drv_gmac_cmn *gc)
 {
 	mutex_init(&gc->phy_mutex);
 }
diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index c39ee6d..cf7a476 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -207,14 +207,14 @@ static void bcma_core_pci_config_fixup(struct bcma_drv_pci *pc)
  * Init.
  **************************************************/
 
-static void __devinit bcma_core_pci_clientmode_init(struct bcma_drv_pci *pc)
+static void bcma_core_pci_clientmode_init(struct bcma_drv_pci *pc)
 {
 	bcma_core_pci_fixcfg(pc);
 	bcma_pcicore_serdes_workaround(pc);
 	bcma_core_pci_config_fixup(pc);
 }
 
-void __devinit bcma_core_pci_init(struct bcma_drv_pci *pc)
+void bcma_core_pci_init(struct bcma_drv_pci *pc)
 {
 	if (pc->setup_done)
 		return;
diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index e564495..f5ef43c 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -24,7 +24,7 @@
 #define BCMA_PCI_SLOT_MAX	16
 #define	PCI_CONFIG_SPACE_SIZE	256
 
-bool __devinit bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc)
+bool bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc)
 {
 	struct bcma_bus *bus = pc->core->bus;
 	u16 chipid_top;
@@ -264,7 +264,7 @@ static int bcma_core_pci_hostmode_write_config(struct pci_bus *bus,
 }
 
 /* return cap_offset if requested capability exists in the PCI config space */
-static u8 __devinit bcma_find_pci_capability(struct bcma_drv_pci *pc,
+static u8 bcma_find_pci_capability(struct bcma_drv_pci *pc,
 					     unsigned int dev,
 					     unsigned int func, u8 req_cap_id,
 					     unsigned char *buf, u32 *buflen)
@@ -334,7 +334,7 @@ static u8 __devinit bcma_find_pci_capability(struct bcma_drv_pci *pc,
  * Retry Status (CRS) Completion Status to software then
  * enable the feature.
  */
-static void __devinit bcma_core_pci_enable_crs(struct bcma_drv_pci *pc)
+static void bcma_core_pci_enable_crs(struct bcma_drv_pci *pc)
 {
 	struct bcma_bus *bus = pc->core->bus;
 	u8 cap_ptr, root_ctrl, root_cap, dev;
@@ -381,7 +381,7 @@ static void __devinit bcma_core_pci_enable_crs(struct bcma_drv_pci *pc)
 	}
 }
 
-void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
+void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 {
 	struct bcma_bus *bus = pc->core->bus;
 	struct bcma_drv_pci_host *pc_host;
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index fdd8dde..efb8cec 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -155,7 +155,7 @@ static const struct bcma_host_ops bcma_host_pci_ops = {
 	.awrite32	= bcma_host_pci_awrite32,
 };
 
-static int __devinit bcma_host_pci_probe(struct pci_dev *dev,
+static int bcma_host_pci_probe(struct pci_dev *dev,
 					 const struct pci_device_id *id)
 {
 	struct bcma_bus *bus;
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index a971889..9388bda 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -179,7 +179,7 @@ static void bcma_unregister_cores(struct bcma_bus *bus)
 	}
 }
 
-int __devinit bcma_bus_register(struct bcma_bus *bus)
+int bcma_bus_register(struct bcma_bus *bus)
 {
 	int err;
 	struct bcma_device *core;
diff --git a/include/linux/bcma/bcma_driver_gmac_cmn.h b/include/linux/bcma/bcma_driver_gmac_cmn.h
index def894b..4dd1f33 100644
--- a/include/linux/bcma/bcma_driver_gmac_cmn.h
+++ b/include/linux/bcma/bcma_driver_gmac_cmn.h
@@ -92,7 +92,7 @@ struct bcma_drv_gmac_cmn {
 #define gmac_cmn_write32(gc, offset, val)	bcma_write32((gc)->core, offset, val)
 
 #ifdef CONFIG_BCMA_DRIVER_GMAC_CMN
-extern void __devinit bcma_core_gmac_cmn_init(struct bcma_drv_gmac_cmn *gc);
+extern void bcma_core_gmac_cmn_init(struct bcma_drv_gmac_cmn *gc);
 #else
 static inline void bcma_core_gmac_cmn_init(struct bcma_drv_gmac_cmn *gc) { }
 #endif
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 41da581..c48d98d 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -214,7 +214,7 @@ struct bcma_drv_pci {
 #define pcicore_write16(pc, offset, val)	bcma_write16((pc)->core, offset, val)
 #define pcicore_write32(pc, offset, val)	bcma_write32((pc)->core, offset, val)
 
-extern void __devinit bcma_core_pci_init(struct bcma_drv_pci *pc);
+extern void bcma_core_pci_init(struct bcma_drv_pci *pc);
 extern int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc,
 				 struct bcma_device *core, bool enable);
 extern void bcma_core_pci_extend_L1timer(struct bcma_drv_pci *pc, bool extend);
-- 
1.8.0

