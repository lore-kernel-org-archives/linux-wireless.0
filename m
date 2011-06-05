Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33060 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab1FEWIX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2011 18:08:23 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org
Cc: zajec5@gmail.com, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC][PATCH 05/10] bcma: add serial console support
Date: Mon,  6 Jun 2011 00:07:33 +0200
Message-Id: <1307311658-15853-6-git-send-email-hauke@hauke-m.de> (sfid-20110606_000827_388430_08BA5E69)
In-Reply-To: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for serial console to bcma, when operating on an
embedded device.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/bcma_private.h           |    4 ++
 drivers/bcma/driver_chipcommon.c      |   62 +++++++++++++++++++++++++++++++++
 drivers/bcma/driver_mips.c            |    9 +++++
 include/linux/bcma/bcma_driver_mips.h |   11 ++++++
 4 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 842ee17..c65a6e2 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -22,6 +22,10 @@ int bcma_bus_scan(struct bcma_bus *bus);
 /* driver_mips.c */
 extern unsigned int bcma_core_mips_irq(struct bcma_device *dev);
 
+/* driver_chipcommon.c */
+extern int bcma_chipco_serial_init(struct bcma_drv_cc *cc,
+				   struct bcma_drv_mips_serial_port *ports);
+
 #ifdef CONFIG_BCMA_HOST_PCI
 /* host_pci.c */
 extern int __init bcma_host_pci_init(void);
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 6061022..b582570 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -87,3 +87,65 @@ u32 bcma_chipco_gpio_polarity(struct bcma_drv_cc *cc, u32 mask, u32 value)
 {
 	return bcma_cc_write32_masked(cc, BCMA_CC_GPIOPOL, mask, value);
 }
+
+int bcma_chipco_serial_init(struct bcma_drv_cc *cc,
+			    struct bcma_drv_mips_serial_port *ports)
+{
+	int nr_ports = 0;
+	u32 plltype;
+	unsigned int irq;
+	u32 baud_base, div;
+	u32 i, n;
+	unsigned int ccrev = cc->core->id.rev;
+
+	plltype = (cc->capabilities & BCMA_CC_CAP_PLLT);
+	irq = bcma_core_mips_irq(cc->core);
+
+	if ((ccrev >= 11) && (ccrev != 15) && (ccrev != 20)) {
+		/* Fixed ALP clock */
+		baud_base = 20000000;
+		if (cc->capabilities & BCMA_CC_CAP_PMU) {
+			/* FIXME: baud_base is different for devices with a PMU */
+			WARN_ON(1);
+		}
+		div = 1;
+		if (ccrev >= 21) {
+			/* Turn off UART clock before switching clocksource. */
+			bcma_cc_write32(cc, BCMA_CC_CORECTL,
+				       bcma_cc_read32(cc, BCMA_CC_CORECTL)
+				       & ~BCMA_CC_CORECTL_UARTCLKEN);
+		}
+		/* Set the override bit so we don't divide it */
+		bcma_cc_write32(cc, BCMA_CC_CORECTL,
+			       bcma_cc_read32(cc, BCMA_CC_CORECTL)
+			       | BCMA_CC_CORECTL_UARTCLK0);
+		if (ccrev >= 21) {
+			/* Re-enable the UART clock. */
+			bcma_cc_write32(cc, BCMA_CC_CORECTL,
+				       bcma_cc_read32(cc, BCMA_CC_CORECTL)
+				       | BCMA_CC_CORECTL_UARTCLKEN);
+		}
+	} else
+		pr_err("serial not supported on this device ccrev: 0x%x\n",
+		       ccrev);
+
+	/* Determine the registers of the UARTs */
+	n = (cc->capabilities & BCMA_CC_CAP_NRUART);
+	for (i = 0; i < n; i++) {
+		void __iomem *cc_mmio;
+		void __iomem *uart_regs;
+
+		cc_mmio = cc->core->bus->mmio +
+			  (cc->core->core_index * BCMA_CORE_SIZE);
+		uart_regs = cc_mmio + BCMA_CC_UART0_DATA;
+		uart_regs += (i * 256);
+
+		nr_ports++;
+		ports[i].regs = uart_regs;
+		ports[i].irq = irq;
+		ports[i].baud_base = baud_base;
+		ports[i].reg_shift = 0;
+	}
+
+	return nr_ports;
+}
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 0a6c217..40e4a6d 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -155,6 +155,14 @@ static void bcma_core_mips_dump_irq(struct bcma_bus *bus)
 	}
 }
 
+static void bcma_core_mips_serial_init(struct bcma_drv_mips *mcore)
+{
+	struct bcma_bus *bus = mcore->core->bus;
+
+	mcore->nr_serial_ports = bcma_chipco_serial_init(&bus->drv_cc,
+							 mcore->serial_ports);
+}
+
 static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 {
 	struct bcma_bus *bus = mcore->core->bus;
@@ -223,5 +231,6 @@ void bcma_core_mips_init(struct bcma_drv_mips *mcore)
 	pr_info("after irq reconfiguration\n");
 	bcma_core_mips_dump_irq(bus);
 
+	bcma_core_mips_serial_init(mcore);
 	bcma_core_mips_flash_detect(mcore);
 }
diff --git a/include/linux/bcma/bcma_driver_mips.h b/include/linux/bcma/bcma_driver_mips.h
index 5faf30c..6584e7d 100644
--- a/include/linux/bcma/bcma_driver_mips.h
+++ b/include/linux/bcma/bcma_driver_mips.h
@@ -27,9 +27,20 @@
 
 struct bcma_device;
 
+struct bcma_drv_mips_serial_port {
+	void *regs;
+	unsigned long clockspeed;
+	unsigned int irq;
+	unsigned int baud_base;
+	unsigned int reg_shift;
+};
+
 struct bcma_drv_mips {
 	struct bcma_device *core;
 
+	int nr_serial_ports;
+	struct bcma_drv_mips_serial_port serial_ports[4];
+
 	u8 flash_buswidth;
 	u32 flash_window;
 	u32 flash_window_size;
-- 
1.7.4.1

