Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180Ab2EJJPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:49 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1111470wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:48 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 36/78] wl18xx: read clock frequency and do top init accordingly
Date: Thu, 10 May 2012 12:13:41 +0300
Message-Id: <1336641263-5761-37-git-send-email-arik@wizery.com> (sfid-20120510_112222_748702_DC8749F7)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Instead of using hardcoded values for a single frequency, we need to
read the frequency and use the appropriate values for it in the top
initialization.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/Makefile |    2 +-
 drivers/net/wireless/ti/wl18xx/io.c     |   60 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/io.h     |   28 +++++++++++++++
 drivers/net/wireless/ti/wl18xx/main.c   |   51 ++++++++++++++++++++++++--
 drivers/net/wireless/ti/wl18xx/reg.h    |   22 ++++++++++++
 drivers/net/wireless/ti/wl18xx/wl18xx.h |   22 ++++++++++++
 6 files changed, 181 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wl18xx/io.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/io.h

diff --git a/drivers/net/wireless/ti/wl18xx/Makefile b/drivers/net/wireless/ti/wl18xx/Makefile
index 764d598..abd881f 100644
--- a/drivers/net/wireless/ti/wl18xx/Makefile
+++ b/drivers/net/wireless/ti/wl18xx/Makefile
@@ -1,3 +1,3 @@
-wl18xx-objs	= main.o acx.o tx.o
+wl18xx-objs	= main.o acx.o tx.o io.o
 
 obj-$(CONFIG_WL18XX)		+= wl18xx.o
diff --git a/drivers/net/wireless/ti/wl18xx/io.c b/drivers/net/wireless/ti/wl18xx/io.c
new file mode 100644
index 0000000..598c057
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/io.c
@@ -0,0 +1,60 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2011 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include "../wlcore/wlcore.h"
+#include "../wlcore/io.h"
+
+#include "io.h"
+
+void wl18xx_top_reg_write(struct wl1271 *wl, int addr, u16 val)
+{
+	u32 tmp;
+
+	if (WARN_ON(addr % 2))
+		return;
+
+	if ((addr % 4) == 0) {
+		tmp = wl1271_read32(wl, addr);
+		tmp = (tmp & 0xffff0000) | val;
+		wl1271_write32(wl, addr, tmp);
+	} else {
+		tmp = wl1271_read32(wl, addr - 2);
+		tmp = (tmp & 0xffff) | (val << 16);
+		wl1271_write32(wl, addr - 2, tmp);
+	}
+}
+
+u16 wl18xx_top_reg_read(struct wl1271 *wl, int addr)
+{
+	u32 val;
+
+	if (WARN_ON(addr % 2))
+		return 0;
+
+	if ((addr % 4) == 0) {
+		/* address is 4-bytes aligned */
+		val = wl1271_read32(wl, addr);
+		return val & 0xffff;
+	} else {
+		val = wl1271_read32(wl, addr - 2);
+		return (val & 0xffff0000) >> 16;
+	}
+}
diff --git a/drivers/net/wireless/ti/wl18xx/io.h b/drivers/net/wireless/ti/wl18xx/io.h
new file mode 100644
index 0000000..be4e126
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/io.h
@@ -0,0 +1,28 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2011 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL18XX_IO_H__
+#define __WL18XX_IO_H__
+
+void wl18xx_top_reg_write(struct wl1271 *wl, int addr, u16 val);
+u16 wl18xx_top_reg_read(struct wl1271 *wl, int addr);
+
+#endif /* __WL18XX_IO_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 0f07886..ce13249 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -37,6 +37,7 @@
 #include "acx.h"
 #include "tx.h"
 #include "wl18xx.h"
+#include "io.h"
 
 
 #define WL18XX_RX_CHECKSUM_MASK      0x40
@@ -561,6 +562,18 @@ static const int wl18xx_rtable[REG_TABLE_LEN] = {
 	[REG_RAW_FW_STATUS_ADDR]	= WL18XX_FW_STATUS_ADDR,
 };
 
+static const struct wl18xx_clk_cfg wl18xx_clk_table[NUM_CLOCK_CONFIGS] = {
+	[CLOCK_CONFIG_16_2_M]	= { 7,  104,  801, 4,  true },
+	[CLOCK_CONFIG_16_368_M]	= { 9,  132, 3751, 4,  true },
+	[CLOCK_CONFIG_16_8_M]	= { 7,  100,    0, 0, false },
+	[CLOCK_CONFIG_19_2_M]	= { 8,  100,    0, 0, false },
+	[CLOCK_CONFIG_26_M]	= { 13, 120,    0, 0, false },
+	[CLOCK_CONFIG_32_736_M]	= { 9,  132, 3751, 4,  true },
+	[CLOCK_CONFIG_33_6_M]	= { 7,  100,    0, 0, false },
+	[CLOCK_CONFIG_38_468_M]	= { 8,  100,    0, 0, false },
+	[CLOCK_CONFIG_52_M]	= { 13, 120,    0, 0, false },
+};
+
 /* TODO: maybe move to a new header file? */
 #define WL18XX_FW_NAME "ti-connectivity/wl18xx-fw.bin"
 
@@ -592,15 +605,47 @@ out:
 static void wl18xx_set_clk(struct wl1271 *wl)
 {
 	struct wl18xx_priv *priv = wl->priv;
+	u32 clk_freq;
 
 	/* write the translated board type to SCR_PAD2 */
 	wl1271_write32(wl, WL18XX_SCR_PAD2,
 		       wl18xx_board_type_to_scrpad2[priv->board_type]);
 
 	wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
-	wl1271_write32(wl, 0x00A02360, 0xD0078);
-	wl1271_write32(wl, 0x00A0236c, 0x12);
-	wl1271_write32(wl, 0x00A02390, 0x20118);
+
+	/* TODO: PG2: apparently we need to read the clk type */
+
+	clk_freq = wl18xx_top_reg_read(wl, PRIMARY_CLK_DETECT);
+	wl1271_debug(DEBUG_BOOT, "clock freq %d (%d, %d, %d, %d, %s)", clk_freq,
+		     wl18xx_clk_table[clk_freq].n, wl18xx_clk_table[clk_freq].m,
+		     wl18xx_clk_table[clk_freq].p, wl18xx_clk_table[clk_freq].q,
+		     wl18xx_clk_table[clk_freq].swallow ? "swallow" : "spit");
+
+	wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_N, wl18xx_clk_table[clk_freq].n);
+	wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_M, wl18xx_clk_table[clk_freq].m);
+
+	if (wl18xx_clk_table[clk_freq].swallow) {
+		/* first the 16 lower bits */
+		wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_Q_FACTOR_CFG_1,
+				     wl18xx_clk_table[clk_freq].q &
+				     PLLSH_WCS_PLL_Q_FACTOR_CFG_1_MASK);
+		/* then the 16 higher bits, masked out */
+		wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_Q_FACTOR_CFG_2,
+				     (wl18xx_clk_table[clk_freq].q >> 16) &
+				     PLLSH_WCS_PLL_Q_FACTOR_CFG_2_MASK);
+
+		/* first the 16 lower bits */
+		wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_P_FACTOR_CFG_1,
+				     wl18xx_clk_table[clk_freq].p &
+				     PLLSH_WCS_PLL_P_FACTOR_CFG_1_MASK);
+		/* then the 16 higher bits, masked out */
+		wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_P_FACTOR_CFG_2,
+				     (wl18xx_clk_table[clk_freq].p >> 16) &
+				     PLLSH_WCS_PLL_P_FACTOR_CFG_2_MASK);
+	} else {
+		wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_SWALLOW_EN,
+				     PLLSH_WCS_PLL_SWALLOW_EN_VAL2);
+	}
 }
 
 static void wl18xx_boot_soft_reset(struct wl1271 *wl)
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index e0170ae..1ea3393 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -107,6 +107,28 @@
 #define WL18XX_WELP_ARM_COMMAND		(WL18XX_REGISTERS_BASE + 0x7100)
 #define WL18XX_ENABLE			(WL18XX_REGISTERS_BASE + 0x01543C)
 
+/* PRCM registers */
+#define PLATFORM_DETECTION		0xA0E3E0
+#define OCS_EN				0xA02080
+#define PRIMARY_CLK_DETECT		0xA020A6
+#define PLLSH_WCS_PLL_N			0xA02362
+#define PLLSH_WCS_PLL_M			0xA02360
+#define PLLSH_WCS_PLL_Q_FACTOR_CFG_1	0xA02364
+#define PLLSH_WCS_PLL_Q_FACTOR_CFG_2	0xA02366
+#define PLLSH_WCS_PLL_P_FACTOR_CFG_1	0xA02368
+#define PLLSH_WCS_PLL_P_FACTOR_CFG_2	0xA0236A
+#define PLLSH_WCS_PLL_SWALLOW_EN	0xA0236C
+#define PLLSH_WL_PLL_EN			0xA02392
+
+#define PLLSH_WCS_PLL_Q_FACTOR_CFG_1_MASK	0xFFFF
+#define PLLSH_WCS_PLL_Q_FACTOR_CFG_2_MASK	0x007F
+#define PLLSH_WCS_PLL_P_FACTOR_CFG_1_MASK	0xFFFF
+#define PLLSH_WCS_PLL_P_FACTOR_CFG_2_MASK	0x000F
+
+#define PLLSH_WCS_PLL_SWALLOW_EN_VAL1	0x1
+#define PLLSH_WCS_PLL_SWALLOW_EN_VAL2	0x12
+
+
 #define WL18XX_CMD_MBOX_ADDRESS		0xB007B4
 
 #define WL18XX_FW_STATUS_ADDR		0x50F8
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 5bcc7f0..75abb5b 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -56,4 +56,26 @@ struct wl18xx_fw_status_priv {
 	u8 padding[2];
 };
 
+struct wl18xx_clk_cfg {
+	u32 n;
+	u32 m;
+	u32 p;
+	u32 q;
+	bool swallow;
+};
+
+enum {
+	CLOCK_CONFIG_16_2_M	= 1,
+	CLOCK_CONFIG_16_368_M,
+	CLOCK_CONFIG_16_8_M,
+	CLOCK_CONFIG_19_2_M,
+	CLOCK_CONFIG_26_M,
+	CLOCK_CONFIG_32_736_M,
+	CLOCK_CONFIG_33_6_M,
+	CLOCK_CONFIG_38_468_M,
+	CLOCK_CONFIG_52_M,
+
+	NUM_CLOCK_CONFIGS,
+};
+
 #endif /* __WL18XX_PRIV_H__ */
-- 
1.7.9.5

