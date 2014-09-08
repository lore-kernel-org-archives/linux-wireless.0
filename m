Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:49622 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbaIHUxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 16:53:52 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] bcma: add support for chipcommon B core
Date: Mon,  8 Sep 2014 22:53:36 +0200
Message-Id: <1410209616-8518-2-git-send-email-hauke@hauke-m.de> (sfid-20140908_225356_187609_89CEE1ED)
In-Reply-To: <1410209616-8518-1-git-send-email-hauke@hauke-m.de>
References: <1410209616-8518-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This core is used on BCM4708 to configure the PCIe and USB3 PHYs and it
contains the addresses to the Device Management unit. This will be used
by the PCIe driver first.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/Makefile                       |  1 +
 drivers/bcma/bcma_private.h                 |  4 ++
 drivers/bcma/driver_chipcommon_b.c          | 61 +++++++++++++++++++++++++++++
 drivers/bcma/main.c                         | 10 +++++
 drivers/bcma/scan.c                         |  1 +
 include/linux/bcma/bcma.h                   |  1 +
 include/linux/bcma/bcma_driver_chipcommon.h |  8 ++++
 7 files changed, 86 insertions(+)
 create mode 100644 drivers/bcma/driver_chipcommon_b.c

diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
index 91290f7..838b4b9 100644
--- a/drivers/bcma/Makefile
+++ b/drivers/bcma/Makefile
@@ -1,5 +1,6 @@
 bcma-y					+= main.o scan.o core.o sprom.o
 bcma-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
+bcma-y					+= driver_chipcommon_b.o
 bcma-$(CONFIG_BCMA_SFLASH)		+= driver_chipcommon_sflash.o
 bcma-$(CONFIG_BCMA_NFLASH)		+= driver_chipcommon_nflash.o
 bcma-y					+= driver_pci.o
diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 09b632a..b40be43 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -50,6 +50,10 @@ void bcma_chipco_serial_init(struct bcma_drv_cc *cc);
 extern struct platform_device bcma_pflash_dev;
 #endif /* CONFIG_BCMA_DRIVER_MIPS */
 
+/* driver_chipcommon_b.c */
+int bcma_core_chipcommon_b_init(struct bcma_drv_cc_b *ccb);
+void bcma_core_chipcommon_b_free(struct bcma_drv_cc_b *ccb);
+
 /* driver_chipcommon_pmu.c */
 u32 bcma_pmu_get_alp_clock(struct bcma_drv_cc *cc);
 u32 bcma_pmu_get_cpu_clock(struct bcma_drv_cc *cc);
diff --git a/drivers/bcma/driver_chipcommon_b.c b/drivers/bcma/driver_chipcommon_b.c
new file mode 100644
index 0000000..c20b5f4
--- /dev/null
+++ b/drivers/bcma/driver_chipcommon_b.c
@@ -0,0 +1,61 @@
+/*
+ * Broadcom specific AMBA
+ * ChipCommon B Unit driver
+ *
+ * Copyright 2014, Hauke Mehrtens <hauke@hauke-m.de>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "bcma_private.h"
+#include <linux/export.h>
+#include <linux/bcma/bcma.h>
+
+static bool bcma_wait_reg(struct bcma_bus *bus, void __iomem *addr, u32 mask,
+			  u32 value, int timeout)
+{
+	unsigned long deadline = jiffies + timeout;
+	u32 val;
+
+	do {
+		val = readl(addr);
+		if ((val & mask) == value)
+			return true;
+		cpu_relax();
+		udelay(10);
+	} while (!time_after_eq(jiffies, deadline));
+
+	bcma_err(bus, "Timeout waiting for register %p\n", addr);
+
+	return false;
+}
+
+void bcma_chipco_b_mii_write(struct bcma_drv_cc_b *ccb, u32 offset, u32 value)
+{
+	struct bcma_bus *bus = ccb->core->bus;
+
+	writel(offset, ccb->mii + 0x00);
+	bcma_wait_reg(bus, ccb->mii + 0x00, 0x0100, 0x0000, 100);
+	writel(value, ccb->mii + 0x04);
+	bcma_wait_reg(bus, ccb->mii + 0x00, 0x0100, 0x0000, 100);
+}
+EXPORT_SYMBOL_GPL(bcma_chipco_b_mii_write);
+
+int bcma_core_chipcommon_b_init(struct bcma_drv_cc_b *ccb)
+{
+	if (ccb->setup_done)
+		return 0;
+
+	ccb->setup_done = 1;
+	ccb->mii = ioremap_nocache(ccb->core->addr_s[1], BCMA_CORE_SIZE);
+	if (!ccb->mii)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void bcma_core_chipcommon_b_free(struct bcma_drv_cc_b *ccb)
+{
+	if (ccb->mii)
+		iounmap(ccb->mii);
+}
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 0ff8d58..e32d4ad 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -130,6 +130,7 @@ static int bcma_register_cores(struct bcma_bus *bus)
 		switch (core->id.id) {
 		case BCMA_CORE_4706_CHIPCOMMON:
 		case BCMA_CORE_CHIPCOMMON:
+		case BCMA_CORE_NS_CHIPCOMMON_B:
 		case BCMA_CORE_PCI:
 		case BCMA_CORE_PCIE:
 		case BCMA_CORE_PCIE2:
@@ -261,6 +262,13 @@ int bcma_bus_register(struct bcma_bus *bus)
 		bcma_core_chipcommon_init(&bus->drv_cc);
 	}
 
+	/* Init CC core */
+	core = bcma_find_core(bus, BCMA_CORE_NS_CHIPCOMMON_B);
+	if (core) {
+		bus->drv_cc_b.core = core;
+		bcma_core_chipcommon_b_init(&bus->drv_cc_b);
+	}
+
 	/* Init MIPS core */
 	core = bcma_find_core(bus, BCMA_CORE_MIPS_74K);
 	if (core) {
@@ -315,6 +323,8 @@ void bcma_bus_unregister(struct bcma_bus *bus)
 	else if (err)
 		bcma_err(bus, "Can not unregister GPIO driver: %i\n", err);
 
+	bcma_core_chipcommon_b_free(&bus->drv_cc_b);
+
 	cores[0] = bcma_find_core(bus, BCMA_CORE_MIPS_74K);
 	cores[1] = bcma_find_core(bus, BCMA_CORE_PCIE);
 	cores[2] = bcma_find_core(bus, BCMA_CORE_4706_MAC_GBIT_COMMON);
diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 3cd5a5b..978bafd 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -314,6 +314,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		/* Some specific cores don't need wrappers */
 		switch (core->id.id) {
 		case BCMA_CORE_4706_MAC_GBIT_COMMON:
+		case BCMA_CORE_NS_CHIPCOMMON_B:
 		/* Not used yet: case BCMA_CORE_OOB_ROUTER: */
 			break;
 		default:
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index ad44711..69051a5 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -336,6 +336,7 @@ struct bcma_bus {
 	u8 num;
 
 	struct bcma_drv_cc drv_cc;
+	struct bcma_drv_cc_b drv_cc_b;
 	struct bcma_drv_pci drv_pci[2];
 	struct bcma_drv_pcie2 drv_pcie2;
 	struct bcma_drv_mips drv_mips;
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 63d105c..db6fa21 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -644,6 +644,12 @@ struct bcma_drv_cc {
 #endif
 };
 
+struct bcma_drv_cc_b {
+	struct bcma_device *core;
+	u8 setup_done:1;
+	void __iomem *mii;
+};
+
 /* Register access */
 #define bcma_cc_read32(cc, offset) \
 	bcma_read32((cc)->core, offset)
@@ -699,4 +705,6 @@ extern void bcma_pmu_spuravoid_pllupdate(struct bcma_drv_cc *cc, int spuravoid);
 
 extern u32 bcma_pmu_get_bus_clock(struct bcma_drv_cc *cc);
 
+void bcma_chipco_b_mii_write(struct bcma_drv_cc_b *ccb, u32 offset, u32 value);
+
 #endif /* LINUX_BCMA_DRIVER_CC_H_ */
-- 
1.9.1

