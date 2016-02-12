Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35278 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbcBLJP6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2016 04:15:58 -0500
Received: by mail-lb0-f169.google.com with SMTP id bc4so41924177lbc.2
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2016 01:15:57 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] bcma: move parallel flash support to separated file
Date: Fri, 12 Feb 2016 10:15:44 +0100
Message-Id: <1455268545-11667-2-git-send-email-zajec5@gmail.com> (sfid-20160212_101607_216333_FF49C30A)
In-Reply-To: <1455268545-11667-1-git-send-email-zajec5@gmail.com>
References: <1455268545-11667-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This follows the way of handling other flashes and cleans code a bit. As
next task we will want to move flash code to ChipCommon driver as:
1) Flash controllers are accesible using ChipCommon registers
2) This code isn't MIPS specific
This change prepares bcma for that.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/Kconfig                        |  5 +++
 drivers/bcma/Makefile                       |  1 +
 drivers/bcma/bcma_private.h                 | 18 +++++++++--
 drivers/bcma/driver_chipcommon_pflash.c     | 49 +++++++++++++++++++++++++++++
 drivers/bcma/driver_mips.c                  | 35 +--------------------
 drivers/bcma/main.c                         |  2 +-
 include/linux/bcma/bcma_driver_chipcommon.h |  8 +++--
 7 files changed, 78 insertions(+), 40 deletions(-)
 create mode 100644 drivers/bcma/driver_chipcommon_pflash.c

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 023d448..efdc2ae 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -70,6 +70,11 @@ config BCMA_DRIVER_MIPS
 
 	  If unsure, say N
 
+config BCMA_PFLASH
+	bool
+	depends on BCMA_DRIVER_MIPS
+	default y
+
 config BCMA_SFLASH
 	bool
 	depends on BCMA_DRIVER_MIPS
diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
index f32af9b..087948a 100644
--- a/drivers/bcma/Makefile
+++ b/drivers/bcma/Makefile
@@ -1,6 +1,7 @@
 bcma-y					+= main.o scan.o core.o sprom.o
 bcma-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
 bcma-y					+= driver_chipcommon_b.o
+bcma-$(CONFIG_BCMA_PFLASH)		+= driver_chipcommon_pflash.o
 bcma-$(CONFIG_BCMA_SFLASH)		+= driver_chipcommon_sflash.o
 bcma-$(CONFIG_BCMA_NFLASH)		+= driver_chipcommon_nflash.o
 bcma-$(CONFIG_BCMA_DRIVER_PCI)		+= driver_pci.o
diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 7e4ddfb..eda0909 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -47,9 +47,6 @@ int bcma_sprom_get(struct bcma_bus *bus);
 void bcma_core_chipcommon_early_init(struct bcma_drv_cc *cc);
 void bcma_core_chipcommon_init(struct bcma_drv_cc *cc);
 void bcma_chipco_bcm4331_ext_pa_lines_ctl(struct bcma_drv_cc *cc, bool enable);
-#ifdef CONFIG_BCMA_DRIVER_MIPS
-extern struct platform_device bcma_pflash_dev;
-#endif /* CONFIG_BCMA_DRIVER_MIPS */
 
 /* driver_chipcommon_b.c */
 int bcma_core_chipcommon_b_init(struct bcma_drv_cc_b *ccb);
@@ -61,6 +58,21 @@ void bcma_pmu_init(struct bcma_drv_cc *cc);
 u32 bcma_pmu_get_alp_clock(struct bcma_drv_cc *cc);
 u32 bcma_pmu_get_cpu_clock(struct bcma_drv_cc *cc);
 
+/**************************************************
+ * driver_chipcommon_sflash.c
+ **************************************************/
+
+#ifdef CONFIG_BCMA_PFLASH
+extern struct platform_device bcma_pflash_dev;
+int bcma_pflash_init(struct bcma_drv_cc *cc);
+#else
+static inline int bcma_pflash_init(struct bcma_drv_cc *cc)
+{
+	bcma_err(cc->core->bus, "Parallel flash not supported\n");
+	return 0;
+}
+#endif /* CONFIG_BCMA_PFLASH */
+
 #ifdef CONFIG_BCMA_SFLASH
 /* driver_chipcommon_sflash.c */
 int bcma_sflash_init(struct bcma_drv_cc *cc);
diff --git a/drivers/bcma/driver_chipcommon_pflash.c b/drivers/bcma/driver_chipcommon_pflash.c
new file mode 100644
index 0000000..3b497c9
--- /dev/null
+++ b/drivers/bcma/driver_chipcommon_pflash.c
@@ -0,0 +1,49 @@
+/*
+ * Broadcom specific AMBA
+ * ChipCommon parallel flash
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "bcma_private.h"
+
+#include <linux/bcma/bcma.h>
+#include <linux/mtd/physmap.h>
+#include <linux/platform_device.h>
+
+static const char * const part_probes[] = { "bcm47xxpart", NULL };
+
+static struct physmap_flash_data bcma_pflash_data = {
+	.part_probe_types	= part_probes,
+};
+
+static struct resource bcma_pflash_resource = {
+	.name	= "bcma_pflash",
+	.flags  = IORESOURCE_MEM,
+};
+
+struct platform_device bcma_pflash_dev = {
+	.name		= "physmap-flash",
+	.dev		= {
+		.platform_data  = &bcma_pflash_data,
+	},
+	.resource	= &bcma_pflash_resource,
+	.num_resources	= 1,
+};
+
+int bcma_pflash_init(struct bcma_drv_cc *cc)
+{
+	struct bcma_pflash *pflash = &cc->pflash;
+
+	pflash->present = true;
+
+	if (!(bcma_read32(cc->core, BCMA_CC_FLASH_CFG) & BCMA_CC_FLASH_CFG_DS))
+		bcma_pflash_data.width = 1;
+	else
+		bcma_pflash_data.width = 2;
+
+	bcma_pflash_resource.start = BCMA_SOC_FLASH2;
+	bcma_pflash_resource.end = BCMA_SOC_FLASH2 + BCMA_SOC_FLASH2_SZ;
+
+	return 0;
+}
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 20c134c..967b0e8 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -14,8 +14,6 @@
 
 #include <linux/bcma/bcma.h>
 
-#include <linux/mtd/physmap.h>
-#include <linux/platform_device.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
@@ -32,26 +30,6 @@ enum bcma_boot_dev {
 	BCMA_BOOT_DEV_NAND,
 };
 
-static const char * const part_probes[] = { "bcm47xxpart", NULL };
-
-static struct physmap_flash_data bcma_pflash_data = {
-	.part_probe_types	= part_probes,
-};
-
-static struct resource bcma_pflash_resource = {
-	.name	= "bcma_pflash",
-	.flags  = IORESOURCE_MEM,
-};
-
-struct platform_device bcma_pflash_dev = {
-	.name		= "physmap-flash",
-	.dev		= {
-		.platform_data  = &bcma_pflash_data,
-	},
-	.resource	= &bcma_pflash_resource,
-	.num_resources	= 1,
-};
-
 /* The 47162a0 hangs when reading MIPS DMP registers registers */
 static inline bool bcma_core_mips_bcm47162a0_quirk(struct bcma_device *dev)
 {
@@ -276,7 +254,6 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 {
 	struct bcma_bus *bus = mcore->core->bus;
 	struct bcma_drv_cc *cc = &bus->drv_cc;
-	struct bcma_pflash *pflash = &cc->pflash;
 	enum bcma_boot_dev boot_dev;
 
 	switch (cc->capabilities & BCMA_CC_CAP_FLASHT) {
@@ -287,17 +264,7 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 		break;
 	case BCMA_CC_FLASHT_PARA:
 		bcma_debug(bus, "Found parallel flash\n");
-		pflash->present = true;
-
-		if ((bcma_read32(cc->core, BCMA_CC_FLASH_CFG) &
-		     BCMA_CC_FLASH_CFG_DS) == 0)
-			bcma_pflash_data.width = 1;
-		else
-			bcma_pflash_data.width = 2;
-
-		bcma_pflash_resource.start = BCMA_SOC_FLASH2;
-		bcma_pflash_resource.end = BCMA_SOC_FLASH2 + BCMA_SOC_FLASH2_SZ;
-
+		bcma_pflash_init(cc);
 		break;
 	default:
 		bcma_err(bus, "Flash type not supported\n");
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index c466f75..786be8f 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -350,7 +350,7 @@ static int bcma_register_devices(struct bcma_bus *bus)
 		bcma_register_core(bus, core);
 	}
 
-#ifdef CONFIG_BCMA_DRIVER_MIPS
+#ifdef CONFIG_BCMA_PFLASH
 	if (bus->drv_cc.pflash.present) {
 		err = platform_device_register(&bcma_pflash_dev);
 		if (err)
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 16eaaad..846513c 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -576,10 +576,11 @@ struct bcma_chipcommon_pmu {
 	u32 crystalfreq;	/* The active crystal frequency (in kHz) */
 };
 
-#ifdef CONFIG_BCMA_DRIVER_MIPS
+#ifdef CONFIG_BCMA_PFLASH
 struct bcma_pflash {
 	bool present;
 };
+#endif
 
 #ifdef CONFIG_BCMA_SFLASH
 struct mtd_info;
@@ -603,6 +604,7 @@ struct bcma_nflash {
 };
 #endif
 
+#ifdef CONFIG_BCMA_DRIVER_MIPS
 struct bcma_serial_port {
 	void *regs;
 	unsigned long clockspeed;
@@ -622,8 +624,9 @@ struct bcma_drv_cc {
 	/* Fast Powerup Delay constant */
 	u16 fast_pwrup_delay;
 	struct bcma_chipcommon_pmu pmu;
-#ifdef CONFIG_BCMA_DRIVER_MIPS
+#ifdef CONFIG_BCMA_PFLASH
 	struct bcma_pflash pflash;
+#endif
 #ifdef CONFIG_BCMA_SFLASH
 	struct bcma_sflash sflash;
 #endif
@@ -631,6 +634,7 @@ struct bcma_drv_cc {
 	struct bcma_nflash nflash;
 #endif
 
+#ifdef CONFIG_BCMA_DRIVER_MIPS
 	int nr_serial_ports;
 	struct bcma_serial_port serial_ports[4];
 #endif /* CONFIG_BCMA_DRIVER_MIPS */
-- 
1.8.4.5

