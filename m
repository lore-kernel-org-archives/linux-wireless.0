Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33053 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab1FEWIV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2011 18:08:21 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org
Cc: zajec5@gmail.com, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC][PATCH 04/10] bcma: add mips driver
Date: Mon,  6 Jun 2011 00:07:32 +0200
Message-Id: <1307311658-15853-5-git-send-email-hauke@hauke-m.de> (sfid-20110606_000825_458036_F130B5FE)
In-Reply-To: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a mips driver to bcma. This is only found on embedded
devices. For now the driver just initializes the irqs used on this
system.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/Kconfig                  |   11 ++-
 drivers/bcma/Makefile                 |    1 +
 drivers/bcma/bcma_private.h           |    3 +
 drivers/bcma/driver_mips.c            |  227 +++++++++++++++++++++++++++++++++
 drivers/bcma/main.c                   |    8 +
 include/linux/bcma/bcma.h             |    2 +
 include/linux/bcma/bcma_driver_mips.h |   40 ++++++
 7 files changed, 291 insertions(+), 1 deletions(-)
 create mode 100644 drivers/bcma/driver_mips.c
 create mode 100644 include/linux/bcma/bcma_driver_mips.h

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 0390e32..568d30b 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -29,9 +29,18 @@ config BCMA_HOST_PCI
 
 config BCMA_HOST_EMBEDDED
 	bool
-	depends on BCMA && MIPS
+	depends on BCMA_DRIVER_MIPS
 	default n
 
+config BCMA_DRIVER_MIPS
+	bool "BCMA Broadcom MIPS core driver"
+	depends on BCMA && MIPS
+	help
+	  Driver for the Broadcom MIPS core attached to Broadcom specific
+	  Advanced Microcontroller Bus.
+
+	  If unsure, say N
+
 config BCMA_DEBUG
 	bool "BCMA debugging"
 	depends on BCMA
diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
index e509b1b..50ddab8 100644
--- a/drivers/bcma/Makefile
+++ b/drivers/bcma/Makefile
@@ -1,6 +1,7 @@
 bcma-y					+= main.o scan.o core.o
 bcma-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
 bcma-y					+= driver_pci.o
+bcma-$(CONFIG_BCMA_DRIVER_MIPS)		+= driver_mips.o
 bcma-$(CONFIG_BCMA_HOST_PCI)		+= host_pci.o
 bcma-$(CONFIG_BCMA_HOST_EMBEDDED)	+= host_embedded.o
 obj-$(CONFIG_BCMA)			+= bcma.o
diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 2f72e9c..842ee17 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -19,6 +19,9 @@ extern void bcma_bus_unregister(struct bcma_bus *bus);
 /* scan.c */
 int bcma_bus_scan(struct bcma_bus *bus);
 
+/* driver_mips.c */
+extern unsigned int bcma_core_mips_irq(struct bcma_device *dev);
+
 #ifdef CONFIG_BCMA_HOST_PCI
 /* host_pci.c */
 extern int __init bcma_host_pci_init(void);
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
new file mode 100644
index 0000000..0a6c217
--- /dev/null
+++ b/drivers/bcma/driver_mips.c
@@ -0,0 +1,227 @@
+/*
+ * Sonics Silicon Backplane
+ * Broadcom MIPS core driver
+ *
+ * Copyright 2005, Broadcom Corporation
+ * Copyright 2006, 2007, Michael Buesch <mb@bu3sch.de>
+ * Copyright 2010, Bernhard Loos <bernhardloos@googlemail.com>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include <linux/bcma/bcma.h>
+
+#include <linux/serial.h>
+#include <linux/serial_core.h>
+#include <linux/serial_reg.h>
+#include <linux/time.h>
+
+#include "bcma_private.h"
+
+/* The 47162a0 hangs when reading its registers */
+static inline bool bcma_core_mips_bcm47162a0_quirk(struct bcma_device *dev)
+{
+	return dev->bus->chipinfo.id == 47162 && dev->bus->chipinfo.rev == 0 &&
+	       dev->id.id == BCMA_CORE_MIPS_74K;
+}
+
+static inline u32 mips_read32(struct bcma_drv_mips *mcore,
+			      u16 offset)
+{
+	return bcma_read32(mcore->core, offset);
+}
+
+static inline void mips_write32(struct bcma_drv_mips *mcore,
+				u16 offset,
+				u32 value)
+{
+	bcma_write32(mcore->core, offset, value);
+}
+
+static const u32 ipsflag_irq_mask[] = {
+	0,
+	BCMA_MIPS_IPSFLAG_IRQ1,
+	BCMA_MIPS_IPSFLAG_IRQ2,
+	BCMA_MIPS_IPSFLAG_IRQ3,
+	BCMA_MIPS_IPSFLAG_IRQ4,
+};
+
+static const u32 ipsflag_irq_shift[] = {
+	0,
+	BCMA_MIPS_IPSFLAG_IRQ1_SHIFT,
+	BCMA_MIPS_IPSFLAG_IRQ2_SHIFT,
+	BCMA_MIPS_IPSFLAG_IRQ3_SHIFT,
+	BCMA_MIPS_IPSFLAG_IRQ4_SHIFT,
+};
+
+static u32 bcma_core_mips_irqflag(struct bcma_device *dev)
+{
+	u32 flag;
+
+	if (bcma_core_mips_bcm47162a0_quirk(dev))
+		return dev->core_index;
+	flag = bcma_aread32(dev, BCMA_MIPS_OOBSELOUTA30);
+
+	return flag & 0x1F;
+}
+
+
+/* Get the MIPS IRQ assignment for a specified device.
+ * If unassigned, 0 is returned.
+ * If disabled, 5 is returned.
+ * If not supported, 6 is returned.
+ */
+unsigned int bcma_core_mips_irq(struct bcma_device *dev)
+{
+	struct bcma_device *mdev = dev->bus->drv_mips.core;
+	u32 irqflag;
+	unsigned int irq;
+
+	irqflag = bcma_core_mips_irqflag(dev);
+
+	for (irq = 1; irq <= 4; irq++)
+		if (bcma_read32(mdev, BCMA_MIPS_MIPS74K_INTMASK(irq)) & (1 << irqflag))
+			break;
+
+	if (irq == 5)
+		irq = 0;
+
+	return irq;
+}
+
+static void bcma_core_mips_set_irq(struct bcma_device *dev, unsigned int irq)
+{
+	unsigned int oldirq = bcma_core_mips_irq(dev);
+	struct bcma_bus *bus = dev->bus;
+	struct bcma_device *mdev = bus->drv_mips.core;
+	u32 irqflag;
+
+	irqflag = bcma_core_mips_irqflag(dev);
+	BUG_ON(oldirq == 6);
+
+	dev->irq = irq + 2;
+
+	/* clear the old irq */
+	if (oldirq == 0)
+		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(0),
+			    bcma_read32(mdev, BCMA_MIPS_MIPS74K_INTMASK(0)) &
+			    ~(1 << irqflag));
+	else
+		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(irq), 0);
+
+	/* assign the new one */
+	if (irq == 0) {
+		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(0),
+			    bcma_read32(mdev, BCMA_MIPS_MIPS74K_INTMASK(0)) |
+			    (1 << irqflag));
+	} else {
+		u32 oldirqflag = bcma_read32(mdev,
+					     BCMA_MIPS_MIPS74K_INTMASK(irq));
+		if (oldirqflag) {
+			int i;
+			/* backplane irq line is in use, find out who uses
+			 * it and set user to irq 0
+			 */
+			for (i = 0; i < bus->nr_cores; i++)
+				if ((1 << bcma_core_mips_irqflag(&bus->cores[i])) == oldirqflag) {
+					bcma_core_mips_set_irq(&bus->cores[i], 0);
+					break;
+				}
+		}
+		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(irq), 1 << irqflag);
+	}
+
+	pr_info("set_irq: core 0x%04x, irq %d => %d\n",
+		dev->id.id, oldirq + 2, irq + 2);
+}
+
+static void bcma_core_mips_print_irq(struct bcma_device *dev, unsigned int irq)
+{
+	int i;
+	static const char *irq_name[] = {"2(S)", "3", "4", "5", "6", "D", "I"};
+	printk(KERN_INFO KBUILD_MODNAME ": core 0x%04x, irq :", dev->id.id);
+	for (i = 0; i <= 6; i++)
+		printk(" %s%s", irq_name[i], i == irq ? "*" : " ");
+	printk("\n");
+}
+
+static void bcma_core_mips_dump_irq(struct bcma_bus *bus)
+{
+	int i;
+	for (i = 0; i < bus->nr_cores; i++) {
+		struct bcma_device *dev;
+		dev = &(bus->cores[i]);
+		bcma_core_mips_print_irq(dev, bcma_core_mips_irq(dev));
+	}
+}
+
+static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
+{
+	struct bcma_bus *bus = mcore->core->bus;
+
+	mcore->flash_buswidth = 2;
+	if (bus->drv_cc.core) {
+		mcore->flash_window = 0x1c000000;
+		mcore->flash_window_size = 0x02000000;
+		switch (bus->drv_cc.capabilities & BCMA_CC_CAP_FLASHT) {
+		case BCMA_CC_FLASHT_STSER:
+		case BCMA_CC_FLASHT_ATSER:
+			pr_err("Serial flash not supported.\n");
+			break;
+		case BCMA_CC_FLASHT_PARA:
+			if ((bcma_read32(bus->drv_cc.core, BCMA_CC_FLASH_CFG) &
+			     BCMA_CC_OTPS) == 0)
+				mcore->flash_buswidth = 1;
+			break;
+		}
+	} else {
+		mcore->flash_window = 0x1fc00000;
+		mcore->flash_window_size = 0x00400000;
+	}
+}
+
+void bcma_core_mips_init(struct bcma_drv_mips *mcore)
+{
+	struct bcma_bus *bus;
+	struct bcma_device *dev;
+	unsigned int irq, i;
+
+	if (!mcore->core)
+		return; /* We don't have a MIPS core */
+
+	pr_info("Initializing MIPS core...\n");
+
+	bus = mcore->core->bus;
+
+	/* Assign IRQs to all cores on the bus */
+	for (irq = 1, i = 0; i < bus->nr_cores; i++) {
+		int mips_irq;
+		dev = &(bus->cores[i]);
+		mips_irq = bcma_core_mips_irq(dev);
+		if (mips_irq > 4)
+			dev->irq = 0;
+		else
+			dev->irq = mips_irq + 2;
+		if (dev->irq > 5)
+			continue;
+		switch (dev->id.id) {
+		case BCMA_CORE_PCI:
+		case BCMA_CORE_PCIE:
+		case BCMA_CORE_ETHERNET:
+		case BCMA_CORE_ETHERNET_GBIT:
+		case BCMA_CORE_MAC_GBIT:
+		case BCMA_CORE_80211:
+		case BCMA_CORE_USB20_HOST:
+			/* These devices get their own IRQ line if available,
+			 * the rest goes on IRQ0
+			 */
+			if (irq <= 4)
+				bcma_core_mips_set_irq(dev, irq++);
+			break;
+		}
+	}
+	pr_info("after irq reconfiguration\n");
+	bcma_core_mips_dump_irq(bus);
+
+	bcma_core_mips_flash_detect(mcore);
+}
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index c5bcb5f..0b4e26d 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -96,6 +96,7 @@ static int bcma_register_cores(struct bcma_bus *bus)
 		case BCMA_CORE_CHIPCOMMON:
 		case BCMA_CORE_PCI:
 		case BCMA_CORE_PCIE:
+		case BCMA_CORE_MIPS_74K:
 			continue;
 		}
 
@@ -198,6 +199,13 @@ int bcma_bus_register(struct bcma_bus *bus)
 		bcma_core_chipcommon_init(&bus->drv_cc);
 	}
 
+	/* Init MIPS core */
+	core = bcma_find_core(bus, BCMA_CORE_MIPS_74K);
+	if (core) {
+		bus->drv_mips.core = core;
+		bcma_core_mips_init(&bus->drv_mips);
+	}
+
 	/* Find PCIE core */
 	core = bcma_find_core(bus, BCMA_CORE_PCIE);
 	if (core) {
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 192c4ae..c5d7d4d 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -6,6 +6,7 @@
 
 #include <linux/bcma/bcma_driver_chipcommon.h>
 #include <linux/bcma/bcma_driver_pci.h>
+#include <linux/bcma/bcma_driver_mips.h>
 
 #include "bcma_regs.h"
 
@@ -198,6 +199,7 @@ struct bcma_bus {
 
 	struct bcma_drv_cc drv_cc;
 	struct bcma_drv_pci drv_pci;
+	struct bcma_drv_mips drv_mips;
 
 	/* Internal-only stuff follows. Do not touch. */
 	struct list_head attach_list;
diff --git a/include/linux/bcma/bcma_driver_mips.h b/include/linux/bcma/bcma_driver_mips.h
new file mode 100644
index 0000000..5faf30c
--- /dev/null
+++ b/include/linux/bcma/bcma_driver_mips.h
@@ -0,0 +1,40 @@
+#ifndef LINUX_BCMA_DRIVER_MIPS_H_
+#define LINUX_BCMA_DRIVER_MIPS_H_
+
+#define BCMA_MIPS_IPSFLAG		0x0F08
+#define	 BCMA_MIPS_IPSFLAG_IRQ1		0x0000003F /* which sbflags get routed to mips interrupt 1 */
+#define	 BCMA_MIPS_IPSFLAG_IRQ1_SHIFT	0
+#define	 BCMA_MIPS_IPSFLAG_IRQ2		0x00003F00 /* which sbflags get routed to mips interrupt 2 */
+#define	 BCMA_MIPS_IPSFLAG_IRQ2_SHIFT	8
+#define	 BCMA_MIPS_IPSFLAG_IRQ3		0x003F0000 /* which sbflags get routed to mips interrupt 3 */
+#define	 BCMA_MIPS_IPSFLAG_IRQ3_SHIFT	16
+#define	 BCMA_MIPS_IPSFLAG_IRQ4		0x3F000000 /* which sbflags get routed to mips interrupt 4 */
+#define	 BCMA_MIPS_IPSFLAG_IRQ4_SHIFT	24
+
+/* MIPS 74K core registers */
+#define BCMA_MIPS_MIPS74K_CORECTL	0x0000
+#define BCMA_MIPS_MIPS74K_EXCEPTBASE	0x0004
+#define BCMA_MIPS_MIPS74K_BIST		0x000C
+#define BCMA_MIPS_MIPS74K_INTMASK_INT0	0x0014
+#define BCMA_MIPS_MIPS74K_INTMASK(int) ((int) * 4 + BCMA_MIPS_MIPS74K_INTMASK_INT0)
+#define BCMA_MIPS_MIPS74K_NMIMASK	0x002C
+#define BCMA_MIPS_MIPS74K_GPIOSEL	0x0040
+#define BCMA_MIPS_MIPS74K_GPIOOUT	0x0044
+#define BCMA_MIPS_MIPS74K_GPIOEN	0x0048
+#define BCMA_MIPS_MIPS74K_CLKCTLST	0x01E0
+
+#define BCMA_MIPS_OOBSELOUTA30		0x100
+
+struct bcma_device;
+
+struct bcma_drv_mips {
+	struct bcma_device *core;
+
+	u8 flash_buswidth;
+	u32 flash_window;
+	u32 flash_window_size;
+};
+
+extern void bcma_core_mips_init(struct bcma_drv_mips *mcore);
+
+#endif /* LINUX_BCMA_DRIVER_MIPS_H_ */
-- 
1.7.4.1

