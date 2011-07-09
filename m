Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60768 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab1GILGp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 07:06:45 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: ralf@linux-mips.org, linux-wireless@vger.kernel.org,
	zajec5@gmail.com, linux-mips@linux-mips.org
Cc: mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 06/11] bcma: add serial console support
Date: Sat,  9 Jul 2011 13:05:58 +0200
Message-Id: <1310209563-6405-7-git-send-email-hauke@hauke-m.de> (sfid-20110709_130648_363005_0F483789)
In-Reply-To: <1310209563-6405-1-git-send-email-hauke@hauke-m.de>
References: <1310209563-6405-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for serial console to bcma, when operating on an SoC.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/bcma_private.h           |    6 +++
 drivers/bcma/driver_chipcommon.c      |   64 +++++++++++++++++++++++++++++++++
 drivers/bcma/driver_mips.c            |    9 +++++
 include/linux/bcma/bcma_driver_mips.h |   11 ++++++
 4 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 830386c..92ec671 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -26,6 +26,12 @@ int __init bcma_bus_scan_early(struct bcma_bus *bus,
 			       struct bcma_device *core);
 void bcma_init_bus(struct bcma_bus *bus);
 
+/* driver_chipcommon.c */
+#ifdef CONFIG_BCMA_DRIVER_MIPS
+extern int bcma_chipco_serial_init(struct bcma_drv_cc *cc,
+				   struct bcma_drv_mips_serial_port *ports);
+#endif /* CONFIG_BCMA_DRIVER_MIPS */
+
 #ifdef CONFIG_BCMA_HOST_PCI
 /* host_pci.c */
 extern int __init bcma_host_pci_init(void);
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 70321c6..88533ca 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -92,3 +92,67 @@ u32 bcma_chipco_gpio_polarity(struct bcma_drv_cc *cc, u32 mask, u32 value)
 {
 	return bcma_cc_write32_masked(cc, BCMA_CC_GPIOPOL, mask, value);
 }
+
+#ifdef CONFIG_BCMA_DRIVER_MIPS
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
+#endif /* CONFIG_BCMA_DRIVER_MIPS */
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 605bb08..3989fb9 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -156,6 +156,14 @@ static void bcma_core_mips_dump_irq(struct bcma_bus *bus)
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
@@ -228,6 +236,7 @@ void bcma_core_mips_init(struct bcma_drv_mips *mcore)
 	if (mcore->setup_done)
 		return;
 
+	bcma_core_mips_serial_init(mcore);
 	bcma_core_mips_flash_detect(mcore);
 	mcore->setup_done = true;
 }
diff --git a/include/linux/bcma/bcma_driver_mips.h b/include/linux/bcma/bcma_driver_mips.h
index f19b21a..13b44c2 100644
--- a/include/linux/bcma/bcma_driver_mips.h
+++ b/include/linux/bcma/bcma_driver_mips.h
@@ -32,11 +32,22 @@
 
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
 	u8 setup_done:1;
 	unsigned int assigned_irqs;
 
+	int nr_serial_ports;
+	struct bcma_drv_mips_serial_port serial_ports[4];
+
 	u8 flash_buswidth;
 	u32 flash_window;
 	u32 flash_window_size;
-- 
1.7.4.1

