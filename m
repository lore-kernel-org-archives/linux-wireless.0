Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:65021 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab3ICOee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 10:34:34 -0400
Received: by mail-we0-f176.google.com with SMTP id u56so2447466wes.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Sep 2013 07:34:32 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/12] wl18xx: fix boot process in high temperature environment
Date: Tue,  3 Sep 2013 17:34:06 +0300
Message-Id: <1378218848-7853-10-git-send-email-eliad@wizery.com> (sfid-20130903_163437_489736_F3DEA7F7)
In-Reply-To: <1378218848-7853-1-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

In addition to existing WCS PLL configuration add and enable
also the coex PLL during init phase. This fixes boot failures
due to silicon latchup in high temperature environment (>85c).

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Nadim Zubidat <nadimz@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c | 53 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/reg.h  | 13 +++++++++
 2 files changed, 66 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 7aa0eb8..b47eb62 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -623,6 +623,18 @@ static const int wl18xx_rtable[REG_TABLE_LEN] = {
 	[REG_RAW_FW_STATUS_ADDR]	= WL18XX_FW_STATUS_ADDR,
 };
 
+static const struct wl18xx_clk_cfg wl18xx_clk_table_coex[NUM_CLOCK_CONFIGS] = {
+	[CLOCK_CONFIG_16_2_M]	= { 8,  121, 0, 0, false },
+	[CLOCK_CONFIG_16_368_M]	= { 8,  120, 0, 0, false },
+	[CLOCK_CONFIG_16_8_M]	= { 8,  117, 0, 0, false },
+	[CLOCK_CONFIG_19_2_M]	= { 10, 128, 0, 0, false },
+	[CLOCK_CONFIG_26_M]	= { 11, 104, 0, 0, false },
+	[CLOCK_CONFIG_32_736_M]	= { 8,  120, 0, 0, false },
+	[CLOCK_CONFIG_33_6_M]	= { 8,  117, 0, 0, false },
+	[CLOCK_CONFIG_38_468_M]	= { 10, 128, 0, 0, false },
+	[CLOCK_CONFIG_52_M]	= { 11, 104, 0, 0, false },
+};
+
 static const struct wl18xx_clk_cfg wl18xx_clk_table[NUM_CLOCK_CONFIGS] = {
 	[CLOCK_CONFIG_16_2_M]	= { 7,  104,  801, 4,  true },
 	[CLOCK_CONFIG_16_368_M]	= { 9,  132, 3751, 4,  true },
@@ -704,6 +716,23 @@ static int wl18xx_set_clk(struct wl1271 *wl)
 		     wl18xx_clk_table[clk_freq].p, wl18xx_clk_table[clk_freq].q,
 		     wl18xx_clk_table[clk_freq].swallow ? "swallow" : "spit");
 
+	/* coex PLL configuration */
+	ret = wl18xx_top_reg_write(wl, PLLSH_COEX_PLL_N,
+				   wl18xx_clk_table_coex[clk_freq].n);
+	if (ret < 0)
+		goto out;
+
+	ret = wl18xx_top_reg_write(wl, PLLSH_COEX_PLL_M,
+				   wl18xx_clk_table_coex[clk_freq].m);
+	if (ret < 0)
+		goto out;
+
+	/* bypass the swallowing logic */
+	ret = wl18xx_top_reg_write(wl, PLLSH_COEX_PLL_SWALLOW_EN,
+				   PLLSH_COEX_PLL_SWALLOW_EN_VAL1);
+	if (ret < 0)
+		goto out;
+
 	ret = wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_N,
 				   wl18xx_clk_table[clk_freq].n);
 	if (ret < 0)
@@ -745,6 +774,30 @@ static int wl18xx_set_clk(struct wl1271 *wl)
 					   PLLSH_WCS_PLL_SWALLOW_EN_VAL2);
 	}
 
+	/* choose WCS PLL */
+	ret = wl18xx_top_reg_write(wl, PLLSH_WL_PLL_SEL,
+				   PLLSH_WL_PLL_SEL_WCS_PLL);
+	if (ret < 0)
+		goto out;
+
+	/* enable both PLLs */
+	ret = wl18xx_top_reg_write(wl, PLLSH_WL_PLL_EN, PLLSH_WL_PLL_EN_VAL1);
+	if (ret < 0)
+		goto out;
+
+	udelay(1000);
+
+	/* disable coex PLL */
+	ret = wl18xx_top_reg_write(wl, PLLSH_WL_PLL_EN, PLLSH_WL_PLL_EN_VAL2);
+	if (ret < 0)
+		goto out;
+
+	/* reset the swallowing logic */
+	ret = wl18xx_top_reg_write(wl, PLLSH_COEX_PLL_SWALLOW_EN,
+				   PLLSH_COEX_PLL_SWALLOW_EN_VAL2);
+	if (ret < 0)
+		goto out;
+
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index 05dd8ba..88de3f2 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -114,6 +114,11 @@
 #define PLATFORM_DETECTION		0xA0E3E0
 #define OCS_EN				0xA02080
 #define PRIMARY_CLK_DETECT		0xA020A6
+#define PLLSH_COEX_PLL_N		0xA02384
+#define PLLSH_COEX_PLL_M		0xA02382
+#define PLLSH_COEX_PLL_SWALLOW_EN	0xA0238E
+#define PLLSH_WL_PLL_SEL		0xA02398
+
 #define PLLSH_WCS_PLL_N			0xA02362
 #define PLLSH_WCS_PLL_M			0xA02360
 #define PLLSH_WCS_PLL_Q_FACTOR_CFG_1	0xA02364
@@ -128,9 +133,17 @@
 #define PLLSH_WCS_PLL_P_FACTOR_CFG_1_MASK	0xFFFF
 #define PLLSH_WCS_PLL_P_FACTOR_CFG_2_MASK	0x000F
 
+#define PLLSH_WL_PLL_EN_VAL1		0x7
+#define PLLSH_WL_PLL_EN_VAL2		0x2
+#define PLLSH_COEX_PLL_SWALLOW_EN_VAL1	0x2
+#define PLLSH_COEX_PLL_SWALLOW_EN_VAL2	0x11
+
 #define PLLSH_WCS_PLL_SWALLOW_EN_VAL1	0x1
 #define PLLSH_WCS_PLL_SWALLOW_EN_VAL2	0x12
 
+#define PLLSH_WL_PLL_SEL_WCS_PLL	0x0
+#define PLLSH_WL_PLL_SEL_COEX_PLL	0x1
+
 #define WL18XX_REG_FUSE_DATA_1_3	0xA0260C
 #define WL18XX_PG_VER_MASK		0x70
 #define WL18XX_PG_VER_OFFSET		4
-- 
1.8.3.rc1.35.g9b79519

