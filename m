Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53477 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab1GVXUr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 19:20:47 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-mips@linux-mips.org
Cc: jonas.gorski@gmail.com, ralf@linux-mips.org, zajec5@gmail.com,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 06/11] bcma: add serial console support
Date: Sat, 23 Jul 2011 01:20:10 +0200
Message-Id: <1311376815-15755-7-git-send-email-hauke@hauke-m.de> (sfid-20110723_012050_295213_CEBEA3FD)
In-Reply-To: <1311376815-15755-1-git-send-email-hauke@hauke-m.de>
References: <1311376815-15755-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for serial console to bcma, when operating on an SoC.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/bcma_private.h                 |    8 ++++
 drivers/bcma/driver_chipcommon.c            |   48 +++++++++++++++++++++++++++
 drivers/bcma/driver_chipcommon_pmu.c        |   26 ++++++++++++++
 drivers/bcma/driver_mips.c                  |    1 +
 include/linux/bcma/bcma_driver_chipcommon.h |   14 ++++++++
 5 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index b97633d..22d3052 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -29,6 +29,14 @@ void bcma_init_bus(struct bcma_bus *bus);
 /* sprom.c */
 int bcma_sprom_get(struct bcma_bus *bus);
 
+/* driver_chipcommon.c */
+#ifdef CONFIG_BCMA_DRIVER_MIPS
+void bcma_chipco_serial_init(struct bcma_drv_cc *cc);
+#endif /* CONFIG_BCMA_DRIVER_MIPS */
+
+/* driver_chipcommon_pmu.c */
+u32 bcma_pmu_alp_clock(struct bcma_drv_cc *cc);
+
 #ifdef CONFIG_BCMA_HOST_PCI
 /* host_pci.c */
 extern int __init bcma_host_pci_init(void);
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 75f1ad7..12b42ea 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -106,3 +106,51 @@ u32 bcma_chipco_gpio_polarity(struct bcma_drv_cc *cc, u32 mask, u32 value)
 {
 	return bcma_cc_write32_masked(cc, BCMA_CC_GPIOPOL, mask, value);
 }
+
+#ifdef CONFIG_BCMA_DRIVER_MIPS
+void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
+{
+	unsigned int irq;
+	u32 baud_base;
+	u32 i;
+	unsigned int ccrev = cc->core->id.rev;
+	struct bcma_serial_port *ports = cc->serial_ports;
+
+	if (ccrev >= 11 && ccrev != 15) {
+		/* Fixed ALP clock */
+		baud_base = bcma_pmu_alp_clock(cc);
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
+	} else {
+		pr_err("serial not supported on this device ccrev: 0x%x\n",
+		       ccrev);
+		return;
+	}
+
+	irq = bcma_core_mips_irq(cc->core);
+
+	/* Determine the registers of the UARTs */
+	cc->nr_serial_ports = (cc->capabilities & BCMA_CC_CAP_NRUART);
+	for (i = 0; i < cc->nr_serial_ports; i++) {
+		ports[i].regs = cc->core->io_addr + BCMA_CC_UART0_DATA +
+				(i * 256);
+		ports[i].irq = irq;
+		ports[i].baud_base = baud_base;
+		ports[i].reg_shift = 0;
+	}
+}
+#endif /* CONFIG_BCMA_DRIVER_MIPS */
diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index dd5846b..59d2b26 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -136,3 +136,29 @@ void bcma_pmu_init(struct bcma_drv_cc *cc)
 	bcma_pmu_swreg_init(cc);
 	bcma_pmu_workarounds(cc);
 }
+
+u32 bcma_pmu_alp_clock(struct bcma_drv_cc *cc)
+{
+	struct bcma_bus *bus = cc->core->bus;
+
+	switch (bus->chipinfo.id) {
+	case 0x4716:
+	case 0x4748:
+	case 47162:
+	case 0x4313:
+	case 0x5357:
+	case 0x4749:
+	case 53572:
+		/* always 20Mhz */
+		return 20000 * 1000;
+	case 0x5356:
+	case 0x5300:
+		/* always 25Mhz */
+		return 25000 * 1000;
+	default:
+		pr_warn("No ALP clock specified for %04X device, "
+			"pmu rev. %d, using default %d Hz\n",
+			bus->chipinfo.id, cc->pmu.rev, BCMA_CC_PMU_ALP_CLOCK);
+	}
+	return BCMA_CC_PMU_ALP_CLOCK;
+}
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 4b60c9f9..b17233c 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -238,6 +238,7 @@ void bcma_core_mips_init(struct bcma_drv_mips *mcore)
 	if (mcore->setup_done)
 		return;
 
+	bcma_chipco_serial_init(&bus->drv_cc);
 	bcma_core_mips_flash_detect(mcore);
 	mcore->setup_done = true;
 }
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 03cde8d..b9a930e 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -241,6 +241,9 @@
 #define BCMA_CC_SPROM			0x0800 /* SPROM beginning */
 #define BCMA_CC_SPROM_PCIE6		0x0830 /* SPROM beginning on PCIe rev >= 6 */
 
+/* ALP clock on pre-PMU chips */
+#define BCMA_CC_PMU_ALP_CLOCK		20000000
+
 /* Data for the PMU, if available.
  * Check availability with ((struct bcma_chipcommon)->capabilities & BCMA_CC_CAP_PMU)
  */
@@ -255,6 +258,14 @@ struct bcma_pflash {
 	u32 window;
 	u32 window_size;
 };
+
+struct bcma_serial_port {
+	void *regs;
+	unsigned long clockspeed;
+	unsigned int irq;
+	unsigned int baud_base;
+	unsigned int reg_shift;
+};
 #endif /* CONFIG_BCMA_DRIVER_MIPS */
 
 struct bcma_drv_cc {
@@ -268,6 +279,9 @@ struct bcma_drv_cc {
 	struct bcma_chipcommon_pmu pmu;
 #ifdef CONFIG_BCMA_DRIVER_MIPS
 	struct bcma_pflash pflash;
+
+	int nr_serial_ports;
+	struct bcma_serial_port serial_ports[4];
 #endif /* CONFIG_BCMA_DRIVER_MIPS */
 };
 
-- 
1.7.4.1

