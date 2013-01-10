Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58847 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213Ab3AJQyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 11:54:38 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	nlhintz@hotmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: return the mips irq number in bcma_core_irq
Date: Thu, 10 Jan 2013 17:54:09 +0100
Message-Id: <1357836849-12492-1-git-send-email-hauke@hauke-m.de> (sfid-20130110_175445_777909_A89BCA11)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nathan Hintz <nlhintz@hotmail.com>

The irq signal numbers that are send by the cpu are increased by 2 from
the number programmed into the mips core by bcma.
Return the irq number on which the irqs are send in bcma_core_irq() now.

Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 arch/mips/bcm47xx/serial.c            |    2 +-
 drivers/bcma/driver_chipcommon.c      |    2 +-
 drivers/bcma/driver_mips.c            |   12 +++++++++---
 drivers/bcma/driver_pci_host.c        |    4 ++--
 include/linux/bcma/bcma_driver_mips.h |    2 +-
 5 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/mips/bcm47xx/serial.c b/arch/mips/bcm47xx/serial.c
index 57981e4..b8ef965 100644
--- a/arch/mips/bcm47xx/serial.c
+++ b/arch/mips/bcm47xx/serial.c
@@ -62,7 +62,7 @@ static int __init uart8250_init_bcma(void)
 
 		p->mapbase = (unsigned int) bcma_port->regs;
 		p->membase = (void *) bcma_port->regs;
-		p->irq = bcma_port->irq + 2;
+		p->irq = bcma_port->irq;
 		p->uartclk = bcma_port->baud_base;
 		p->regshift = bcma_port->reg_shift;
 		p->iotype = UPIO_MEM;
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index e461ad2..28fa50a 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -329,7 +329,7 @@ void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
 		return;
 	}
 
-	irq = bcma_core_mips_irq(cc->core);
+	irq = bcma_core_irq(cc->core);
 
 	/* Determine the registers of the UARTs */
 	cc->nr_serial_ports = (cc->capabilities & BCMA_CC_CAP_NRUART);
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 90f20a2..a808404 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -85,7 +85,7 @@ static u32 bcma_core_mips_irqflag(struct bcma_device *dev)
  * If disabled, 5 is returned.
  * If not supported, 6 is returned.
  */
-unsigned int bcma_core_mips_irq(struct bcma_device *dev)
+static unsigned int bcma_core_mips_irq(struct bcma_device *dev)
 {
 	struct bcma_device *mdev = dev->bus->drv_mips.core;
 	u32 irqflag;
@@ -102,7 +102,13 @@ unsigned int bcma_core_mips_irq(struct bcma_device *dev)
 
 	return 5;
 }
-EXPORT_SYMBOL(bcma_core_mips_irq);
+
+unsigned int bcma_core_irq(struct bcma_device *dev)
+{
+	unsigned int mips_irq = bcma_core_mips_irq(dev);
+	return mips_irq <= 4 ? mips_irq + 2 : 0;
+}
+EXPORT_SYMBOL(bcma_core_irq);
 
 static void bcma_core_mips_set_irq(struct bcma_device *dev, unsigned int irq)
 {
@@ -299,7 +305,7 @@ void bcma_core_mips_init(struct bcma_drv_mips *mcore)
 		break;
 	default:
 		list_for_each_entry(core, &bus->cores, list) {
-			core->irq = bcma_core_mips_irq(core) + 2;
+			core->irq = bcma_core_irq(core);
 		}
 		bcma_err(bus,
 			 "Unknown device (0x%x) found, can not configure IRQs\n",
diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index e6b5c89..ef9f093 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -577,7 +577,7 @@ int bcma_core_pci_plat_dev_init(struct pci_dev *dev)
 	pr_info("PCI: Fixing up device %s\n", pci_name(dev));
 
 	/* Fix up interrupt lines */
-	dev->irq = bcma_core_mips_irq(pc_host->pdev->core) + 2;
+	dev->irq = bcma_core_irq(pc_host->pdev->core);
 	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, dev->irq);
 
 	return 0;
@@ -596,6 +596,6 @@ int bcma_core_pci_pcibios_map_irq(const struct pci_dev *dev)
 
 	pc_host = container_of(dev->bus->ops, struct bcma_drv_pci_host,
 			       pci_ops);
-	return bcma_core_mips_irq(pc_host->pdev->core) + 2;
+	return bcma_core_irq(pc_host->pdev->core);
 }
 EXPORT_SYMBOL(bcma_core_pci_pcibios_map_irq);
diff --git a/include/linux/bcma/bcma_driver_mips.h b/include/linux/bcma/bcma_driver_mips.h
index 6495579..73c7f4b 100644
--- a/include/linux/bcma/bcma_driver_mips.h
+++ b/include/linux/bcma/bcma_driver_mips.h
@@ -48,6 +48,6 @@ static inline void bcma_core_mips_early_init(struct bcma_drv_mips *mcore) { }
 
 extern u32 bcma_cpu_clock(struct bcma_drv_mips *mcore);
 
-extern unsigned int bcma_core_mips_irq(struct bcma_device *dev);
+extern unsigned int bcma_core_irq(struct bcma_device *core);
 
 #endif /* LINUX_BCMA_DRIVER_MIPS_H_ */
-- 
1.7.10.4

