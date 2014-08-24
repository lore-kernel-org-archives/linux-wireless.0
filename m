Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from test.hauke-m.de ([5.39.93.123]:43922 "EHLO test.hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbaHXVZW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2014 17:25:22 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org
Cc: zajec5@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC 1/7] MIPS: BCM47XX: move the nvram header file into common space
Date: Sun, 24 Aug 2014 23:24:39 +0200
Message-Id: <1408915485-8078-3-git-send-email-hauke@hauke-m.de> (sfid-20140824_232527_110461_0D824C81)
In-Reply-To: <1408915485-8078-1-git-send-email-hauke@hauke-m.de>
References: <1408915485-8078-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving mach-bcm47xx/bcm47xx_nvram.h to include/linux/bcm47xx_nvram.h
makes it possible to reuse this header on the ARM based bcm47xx/bcm53xx
SoCs (e.g. BCM5301X devices). Broadcom uses ARM CPUs in their new SoC
form the bcm47xx and bcm53xx line, but many other things like nvram
stayed the same.

This is a preparation for adding a new nvram driver, which can be used
by the ARM SoC and the MIPS SoC code. The device drivers accessing
nvram do not have to care about ARM or MIPS SoC version.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 arch/mips/bcm47xx/board.c                          |  2 +-
 arch/mips/bcm47xx/nvram.c                          |  2 +-
 arch/mips/bcm47xx/setup.c                          |  2 +-
 arch/mips/bcm47xx/sprom.c                          |  2 +-
 arch/mips/bcm47xx/time.c                           |  2 +-
 arch/mips/include/asm/mach-bcm47xx/bcm47xx_nvram.h | 53 -----------------
 drivers/net/ethernet/broadcom/b44.c                |  8 +--
 drivers/net/ethernet/broadcom/bgmac.c              |  2 +-
 drivers/ssb/driver_chipcommon_pmu.c                |  6 +-
 include/linux/bcm47xx_nvram.h                      | 66 ++++++++++++++++++++++
 10 files changed, 74 insertions(+), 71 deletions(-)
 delete mode 100644 arch/mips/include/asm/mach-bcm47xx/bcm47xx_nvram.h
 create mode 100644 include/linux/bcm47xx_nvram.h

diff --git a/arch/mips/bcm47xx/board.c b/arch/mips/bcm47xx/board.c
index b3ae068..ec46fd7 100644
--- a/arch/mips/bcm47xx/board.c
+++ b/arch/mips/bcm47xx/board.c
@@ -2,7 +2,7 @@
 #include <linux/export.h>
 #include <linux/string.h>
 #include <bcm47xx_board.h>
-#include <bcm47xx_nvram.h>
+#include <linux/bcm47xx_nvram.h>
 
 struct bcm47xx_board_type {
 	const enum bcm47xx_board board;
diff --git a/arch/mips/bcm47xx/nvram.c b/arch/mips/bcm47xx/nvram.c
index 2bed73a..c47a4a8 100644
--- a/arch/mips/bcm47xx/nvram.c
+++ b/arch/mips/bcm47xx/nvram.c
@@ -17,7 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <asm/addrspace.h>
-#include <bcm47xx_nvram.h>
+#include <linux/bcm47xx_nvram.h>
 #include <asm/mach-bcm47xx/bcm47xx.h>
 
 static char nvram_buf[NVRAM_SPACE];
diff --git a/arch/mips/bcm47xx/setup.c b/arch/mips/bcm47xx/setup.c
index 2b63e7e..deadb71 100644
--- a/arch/mips/bcm47xx/setup.c
+++ b/arch/mips/bcm47xx/setup.c
@@ -42,7 +42,7 @@
 #include <asm/reboot.h>
 #include <asm/time.h>
 #include <bcm47xx.h>
-#include <bcm47xx_nvram.h>
+#include <linux/bcm47xx_nvram.h>
 #include <bcm47xx_board.h>
 
 union bcm47xx_bus bcm47xx_bus;
diff --git a/arch/mips/bcm47xx/sprom.c b/arch/mips/bcm47xx/sprom.c
index 41226b6..29ced12 100644
--- a/arch/mips/bcm47xx/sprom.c
+++ b/arch/mips/bcm47xx/sprom.c
@@ -27,7 +27,7 @@
  */
 
 #include <bcm47xx.h>
-#include <bcm47xx_nvram.h>
+#include <linux/bcm47xx_nvram.h>
 #include <linux/if_ether.h>
 #include <linux/etherdevice.h>
 
diff --git a/arch/mips/bcm47xx/time.c b/arch/mips/bcm47xx/time.c
index 2c85d92..c57a515 100644
--- a/arch/mips/bcm47xx/time.c
+++ b/arch/mips/bcm47xx/time.c
@@ -27,7 +27,7 @@
 #include <linux/ssb/ssb.h>
 #include <asm/time.h>
 #include <bcm47xx.h>
-#include <bcm47xx_nvram.h>
+#include <linux/bcm47xx_nvram.h>
 #include <bcm47xx_board.h>
 
 void __init plat_time_init(void)
diff --git a/arch/mips/include/asm/mach-bcm47xx/bcm47xx_nvram.h b/arch/mips/include/asm/mach-bcm47xx/bcm47xx_nvram.h
deleted file mode 100644
index 36a3fc1..0000000
--- a/arch/mips/include/asm/mach-bcm47xx/bcm47xx_nvram.h
+++ /dev/null
@@ -1,53 +0,0 @@
-/*
- *  Copyright (C) 2005, Broadcom Corporation
- *  Copyright (C) 2006, Felix Fietkau <nbd@openwrt.org>
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-
-#ifndef __BCM47XX_NVRAM_H
-#define __BCM47XX_NVRAM_H
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-
-struct nvram_header {
-	u32 magic;
-	u32 len;
-	u32 crc_ver_init;	/* 0:7 crc, 8:15 ver, 16:31 sdram_init */
-	u32 config_refresh;	/* 0:15 sdram_config, 16:31 sdram_refresh */
-	u32 config_ncdl;	/* ncdl values for memc */
-};
-
-#define NVRAM_HEADER		0x48534C46	/* 'FLSH' */
-#define NVRAM_VERSION		1
-#define NVRAM_HEADER_SIZE	20
-#define NVRAM_SPACE		0x8000
-
-#define FLASH_MIN		0x00020000	/* Minimum flash size */
-
-#define NVRAM_MAX_VALUE_LEN 255
-#define NVRAM_MAX_PARAM_LEN 64
-
-extern int bcm47xx_nvram_getenv(char *name, char *val, size_t val_len);
-
-static inline void bcm47xx_nvram_parse_macaddr(char *buf, u8 macaddr[6])
-{
-	if (strchr(buf, ':'))
-		sscanf(buf, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx", &macaddr[0],
-			&macaddr[1], &macaddr[2], &macaddr[3], &macaddr[4],
-			&macaddr[5]);
-	else if (strchr(buf, '-'))
-		sscanf(buf, "%hhx-%hhx-%hhx-%hhx-%hhx-%hhx", &macaddr[0],
-			&macaddr[1], &macaddr[2], &macaddr[3], &macaddr[4],
-			&macaddr[5]);
-	else
-		printk(KERN_WARNING "Can not parse mac address: %s\n", buf);
-}
-
-int bcm47xx_nvram_gpio_pin(const char *name);
-
-#endif /* __BCM47XX_NVRAM_H */
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 4a7028d..d2714a2 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -31,6 +31,7 @@
 #include <linux/ssb/ssb.h>
 #include <linux/slab.h>
 #include <linux/phy.h>
+#include <linux/bcm47xx_nvram.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -399,8 +400,6 @@ static void b44_set_flow_ctrl(struct b44 *bp, u32 local, u32 remote)
 	__b44_set_flow_ctrl(bp, pause_enab);
 }
 
-#ifdef CONFIG_BCM47XX
-#include <bcm47xx_nvram.h>
 static void b44_wap54g10_workaround(struct b44 *bp)
 {
 	char buf[20];
@@ -429,11 +428,6 @@ static void b44_wap54g10_workaround(struct b44 *bp)
 error:
 	pr_warning("PHY: cannot reset MII transceiver isolate bit\n");
 }
-#else
-static inline void b44_wap54g10_workaround(struct b44 *bp)
-{
-}
-#endif
 
 static int b44_setup_phy(struct b44 *bp)
 {
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 05c6af6..bdda57b 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -16,7 +16,7 @@
 #include <linux/phy.h>
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
-#include <bcm47xx_nvram.h>
+#include <linux/bcm47xx_nvram.h>
 
 static const struct bcma_device_id bgmac_bcma_tbl[] = {
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_4706_MAC_GBIT, BCMA_ANY_REV, BCMA_ANY_CLASS),
diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
index 1173a09..8d07d4d 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -13,9 +13,7 @@
 #include <linux/ssb/ssb_driver_chipcommon.h>
 #include <linux/delay.h>
 #include <linux/export.h>
-#ifdef CONFIG_BCM47XX
-#include <bcm47xx_nvram.h>
-#endif
+#include <linux/bcm47xx_nvram.h>
 
 #include "ssb_private.h"
 
@@ -320,11 +318,9 @@ static void ssb_pmu_pll_init(struct ssb_chipcommon *cc)
 	u32 crystalfreq = 0; /* in kHz. 0 = keep default freq. */
 
 	if (bus->bustype == SSB_BUSTYPE_SSB) {
-#ifdef CONFIG_BCM47XX
 		char buf[20];
 		if (bcm47xx_nvram_getenv("xtalfreq", buf, sizeof(buf)) >= 0)
 			crystalfreq = simple_strtoul(buf, NULL, 0);
-#endif
 	}
 
 	switch (bus->chip_id) {
diff --git a/include/linux/bcm47xx_nvram.h b/include/linux/bcm47xx_nvram.h
new file mode 100644
index 0000000..333d32c
--- /dev/null
+++ b/include/linux/bcm47xx_nvram.h
@@ -0,0 +1,66 @@
+/*
+ *  Copyright (C) 2005, Broadcom Corporation
+ *  Copyright (C) 2006, Felix Fietkau <nbd@openwrt.org>
+ *  Copyright (C) 2014 Hauke Mehrtens <hauke@hauke-m.de>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#ifndef __BCM47XX_NVRAM_H
+#define __BCM47XX_NVRAM_H
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+
+struct nvram_header {
+	u32 magic;
+	u32 len;
+	u32 crc_ver_init;	/* 0:7 crc, 8:15 ver, 16:31 sdram_init */
+	u32 config_refresh;	/* 0:15 sdram_config, 16:31 sdram_refresh */
+	u32 config_ncdl;	/* ncdl values for memc */
+};
+
+#define NVRAM_HEADER		0x48534C46	/* 'FLSH' */
+#define NVRAM_VERSION		1
+#define NVRAM_HEADER_SIZE	20
+#define NVRAM_SPACE		0x8000
+
+#define FLASH_MIN		0x00020000	/* Minimum flash size */
+
+#define NVRAM_MAX_VALUE_LEN 255
+#define NVRAM_MAX_PARAM_LEN 64
+
+#ifdef CONFIG_BCM47XX
+int bcm47xx_nvram_getenv(const char *name, char *val, size_t val_len);
+
+int bcm47xx_nvram_gpio_pin(const char *name);
+#else
+static inline int bcm47xx_nvram_getenv(const char *name, char *val,
+				       size_t val_len)
+{
+	return -ENXIO;
+}
+
+static inline int bcm47xx_nvram_gpio_pin(const char *name)
+{
+	return -ENXIO;
+}
+#endif
+
+static inline void bcm47xx_nvram_parse_macaddr(char *buf, u8 macaddr[6])
+{
+	if (strchr(buf, ':'))
+		sscanf(buf, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx", &macaddr[0],
+			&macaddr[1], &macaddr[2], &macaddr[3], &macaddr[4],
+			&macaddr[5]);
+	else if (strchr(buf, '-'))
+		sscanf(buf, "%hhx-%hhx-%hhx-%hhx-%hhx-%hhx", &macaddr[0],
+			&macaddr[1], &macaddr[2], &macaddr[3], &macaddr[4],
+			&macaddr[5]);
+	else
+		pr_warn("Can not parse mac address: %s\n", buf);
+}
+#endif /* __BCM47XX_NVRAM_H */
-- 
1.9.1

