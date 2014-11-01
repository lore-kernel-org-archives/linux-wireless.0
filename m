Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:46662 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbaKAPzF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2014 11:55:05 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, arnd@arndb.de, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v7 1/2] bcma: make it possible to specify a IRQ num in bcma_core_irq()
Date: Sat,  1 Nov 2014 16:54:55 +0100
Message-Id: <1414857296-1287-2-git-send-email-hauke@hauke-m.de> (sfid-20141101_165517_100088_E608D91F)
In-Reply-To: <1414857296-1287-1-git-send-email-hauke@hauke-m.de>
References: <1414857296-1287-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This moves bcma_core_irq() to main.c and add a extra parameter with a
number so that we can return different irq number for devices with more
than one.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon.c      |  2 +-
 drivers/bcma/driver_gpio.c            |  4 ++--
 drivers/bcma/driver_mips.c            | 11 ++---------
 drivers/bcma/driver_pci_host.c        |  4 ++--
 drivers/bcma/main.c                   | 22 ++++++++++++++++++++++
 include/linux/bcma/bcma.h             |  2 ++
 include/linux/bcma/bcma_driver_mips.h |  4 ++--
 7 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index b068f98..19f6796 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -339,7 +339,7 @@ void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
 		return;
 	}
 
-	irq = bcma_core_irq(cc->core);
+	irq = bcma_core_irq(cc->core, 0);
 
 	/* Determine the registers of the UARTs */
 	cc->nr_serial_ports = (cc->capabilities & BCMA_CC_CAP_NRUART);
diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 706b9ae..598a6cd 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -152,7 +152,7 @@ static int bcma_gpio_irq_domain_init(struct bcma_drv_cc *cc)
 					 handle_simple_irq);
 	}
 
-	hwirq = bcma_core_irq(cc->core);
+	hwirq = bcma_core_irq(cc->core, 0);
 	err = request_irq(hwirq, bcma_gpio_irq_handler, IRQF_SHARED, "gpio",
 			  cc);
 	if (err)
@@ -183,7 +183,7 @@ static void bcma_gpio_irq_domain_exit(struct bcma_drv_cc *cc)
 		return;
 
 	bcma_cc_mask32(cc, BCMA_CC_IRQMASK, ~BCMA_CC_IRQ_GPIO);
-	free_irq(bcma_core_irq(cc->core), cc);
+	free_irq(bcma_core_irq(cc->core, 0), cc);
 	for (gpio = 0; gpio < chip->ngpio; gpio++) {
 		int irq = irq_find_mapping(cc->irq_domain, gpio);
 
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 004d6aa..5ec69c3 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -115,7 +115,7 @@ static u32 bcma_core_mips_irqflag(struct bcma_device *dev)
  * If disabled, 5 is returned.
  * If not supported, 6 is returned.
  */
-static unsigned int bcma_core_mips_irq(struct bcma_device *dev)
+unsigned int bcma_core_mips_irq(struct bcma_device *dev)
 {
 	struct bcma_device *mdev = dev->bus->drv_mips.core;
 	u32 irqflag;
@@ -133,13 +133,6 @@ static unsigned int bcma_core_mips_irq(struct bcma_device *dev)
 	return 5;
 }
 
-unsigned int bcma_core_irq(struct bcma_device *dev)
-{
-	unsigned int mips_irq = bcma_core_mips_irq(dev);
-	return mips_irq <= 4 ? mips_irq + 2 : 0;
-}
-EXPORT_SYMBOL(bcma_core_irq);
-
 static void bcma_core_mips_set_irq(struct bcma_device *dev, unsigned int irq)
 {
 	unsigned int oldirq = bcma_core_mips_irq(dev);
@@ -423,7 +416,7 @@ void bcma_core_mips_init(struct bcma_drv_mips *mcore)
 		break;
 	default:
 		list_for_each_entry(core, &bus->cores, list) {
-			core->irq = bcma_core_irq(core);
+			core->irq = bcma_core_irq(core, 0);
 		}
 		bcma_err(bus,
 			 "Unknown device (0x%x) found, can not configure IRQs\n",
diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index c3d7b03..c8a6b74 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -593,7 +593,7 @@ int bcma_core_pci_plat_dev_init(struct pci_dev *dev)
 	pr_info("PCI: Fixing up device %s\n", pci_name(dev));
 
 	/* Fix up interrupt lines */
-	dev->irq = bcma_core_irq(pc_host->pdev->core);
+	dev->irq = bcma_core_irq(pc_host->pdev->core, 0);
 	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, dev->irq);
 
 	readrq = pcie_get_readrq(dev);
@@ -617,6 +617,6 @@ int bcma_core_pci_pcibios_map_irq(const struct pci_dev *dev)
 
 	pc_host = container_of(dev->bus->ops, struct bcma_drv_pci_host,
 			       pci_ops);
-	return bcma_core_irq(pc_host->pdev->core);
+	return bcma_core_irq(pc_host->pdev->core, 0);
 }
 EXPORT_SYMBOL(bcma_core_pci_pcibios_map_irq);
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index a15e0bc..03cd421 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -169,6 +169,28 @@ static void bcma_of_fill_device(struct platform_device *parent,
 }
 #endif /* CONFIG_OF */
 
+unsigned int bcma_core_irq(struct bcma_device *core, int num)
+{
+	struct bcma_bus *bus = core->bus;
+	unsigned int mips_irq;
+
+	switch (bus->hosttype) {
+	case BCMA_HOSTTYPE_PCI:
+		return bus->host_pci->irq;
+	case BCMA_HOSTTYPE_SOC:
+		if (bus->drv_mips.core && num == 0) {
+			mips_irq = bcma_core_mips_irq(core);
+			return mips_irq <= 4 ? mips_irq + 2 : 0;
+		}
+		break;
+	case BCMA_HOSTTYPE_SDIO:
+		return 0;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(bcma_core_irq);
+
 void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
 {
 	core->dev.release = bcma_release_core_dev;
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 729f48e..eb1c6a4 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -447,4 +447,6 @@ extern u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset);
 #define  BCMA_DMA_TRANSLATION_DMA64_CMT	0x80000000 /* Client Mode Translation for 64-bit DMA */
 extern u32 bcma_core_dma_translation(struct bcma_device *core);
 
+extern unsigned int bcma_core_irq(struct bcma_device *core, int num);
+
 #endif /* LINUX_BCMA_H_ */
diff --git a/include/linux/bcma/bcma_driver_mips.h b/include/linux/bcma/bcma_driver_mips.h
index fb61f3f..0b3b32a 100644
--- a/include/linux/bcma/bcma_driver_mips.h
+++ b/include/linux/bcma/bcma_driver_mips.h
@@ -43,12 +43,12 @@ struct bcma_drv_mips {
 extern void bcma_core_mips_init(struct bcma_drv_mips *mcore);
 extern void bcma_core_mips_early_init(struct bcma_drv_mips *mcore);
 
-extern unsigned int bcma_core_irq(struct bcma_device *core);
+extern unsigned int bcma_core_mips_irq(struct bcma_device *dev);
 #else
 static inline void bcma_core_mips_init(struct bcma_drv_mips *mcore) { }
 static inline void bcma_core_mips_early_init(struct bcma_drv_mips *mcore) { }
 
-static inline unsigned int bcma_core_irq(struct bcma_device *core)
+static inline unsigned int bcma_core_mips_irq(struct bcma_device *dev)
 {
 	return 0;
 }
-- 
1.9.1

