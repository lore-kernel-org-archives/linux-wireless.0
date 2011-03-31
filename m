Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50168 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab1CaIHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 04:07:19 -0400
Received: by fxm17 with SMTP id 17so1636302fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 01:07:18 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH 1/5] wl12xx: Clean up and fix the 128x boot sequence
Date: Thu, 31 Mar 2011 10:06:57 +0200
Message-Id: <1301558821-17787-2-git-send-email-ido@wizery.com>
In-Reply-To: <1301558821-17787-1-git-send-email-ido@wizery.com>
References: <1301558821-17787-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean up the boot sequence code & fix the following issues:
1. Always read the registers' values and set the relevant bits instead of
   zeroing all other bits
2. Handle cases where wl1271_top_reg_read returns an error
3. Verify that the HW can detect the selected clock source
4. Remove 128x PG10 initialization code
5. Configure the MCS PLL to work in HP mode

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/boot.c |  235 ++++++++++++++++++------------------
 drivers/net/wireless/wl12xx/boot.h |    1 +
 include/linux/wl12xx.h             |   10 +-
 3 files changed, 123 insertions(+), 123 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 34bf2fe..b5ec2c2 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -523,137 +523,137 @@ static void wl1271_boot_hw_version(struct wl1271 *wl)
 		wl->quirks |= WL12XX_QUIRK_END_OF_TRANSACTION;
 }
 
-/*
- * WL128x has two clocks input - TCXO and FREF.
- * TCXO is the main clock of the device, while FREF is used to sync
- * between the GPS and the cellular modem.
- * In cases where TCXO is 32.736MHz or 16.368MHz, the FREF will be used
- * as the WLAN/BT main clock.
- */
-static int wl128x_switch_fref(struct wl1271 *wl, bool *is_ref_clk)
+static int wl128x_switch_tcxo_to_fref(struct wl1271 *wl)
 {
-	u16 sys_clk_cfg_val;
+	u16 spare_reg;
 
-	/* if working on XTAL-only mode go directly to TCXO TO FREF SWITCH */
-	if ((wl->ref_clock == CONF_REF_CLK_38_4_M_XTAL) ||
-	    (wl->ref_clock == CONF_REF_CLK_26_M_XTAL))
-		return true;
+	/* Mask bits [2] & [8:4] in the sys_clk_cfg register */
+	spare_reg = wl1271_top_reg_read(wl, WL_SPARE_REG);
+	if (spare_reg == 0xFFFF)
+		return -EFAULT;
+	spare_reg |= (BIT(3) | BIT(5) | BIT(6));
+	wl1271_top_reg_write(wl, WL_SPARE_REG, spare_reg);
 
-	/* Read clock source FREF or TCXO */
-	sys_clk_cfg_val = wl1271_top_reg_read(wl, SYS_CLK_CFG_REG);
+	/* Enable FREF_CLK_REQ & mux MCS and coex PLLs to FREF */
+	wl1271_top_reg_write(wl, SYS_CLK_CFG_REG,
+			     WL_CLK_REQ_TYPE_PG2 | MCS_PLL_CLK_SEL_FREF);
 
-	if (sys_clk_cfg_val & PRCM_CM_EN_MUX_WLAN_FREF) {
-		/* if bit 3 is set - working with FREF clock */
-		wl1271_debug(DEBUG_BOOT, "working with FREF clock, skip"
-			     " to FREF");
+	/* Delay execution for 15msec, to let the HW settle */
+	mdelay(15);
 
-		*is_ref_clk = true;
-	} else {
-		/* if bit 3 is clear - working with TCXO clock */
-		wl1271_debug(DEBUG_BOOT, "working with TCXO clock");
-
-		/* TCXO to FREF switch, check TXCO clock config */
-		if ((wl->tcxo_clock != WL12XX_TCXOCLOCK_16_368) &&
-		    (wl->tcxo_clock != WL12XX_TCXOCLOCK_32_736)) {
-			/*
-			 * not 16.368Mhz and not 32.736Mhz - skip to
-			 * configure ELP stage
-			 */
-			wl1271_debug(DEBUG_BOOT, "NEW PLL ALGO:"
-				     " TcxoRefClk=%d - not 16.368Mhz and not"
-				     " 32.736Mhz - skip to configure ELP"
-				     " stage", wl->tcxo_clock);
-
-			*is_ref_clk = false;
-		} else {
-			wl1271_debug(DEBUG_BOOT, "NEW PLL ALGO:"
-				     "TcxoRefClk=%d - 16.368Mhz or 32.736Mhz"
-				     " - TCXO to FREF switch",
-				     wl->tcxo_clock);
+	return 0;
+}
 
-			return true;
-		}
-	}
+static bool wl128x_is_tcxo_valid(struct wl1271 *wl)
+{
+	u16 tcxo_detection;
+
+	tcxo_detection = wl1271_top_reg_read(wl, TCXO_CLK_DETECT_REG);
+	if (tcxo_detection & TCXO_DET_FAILED)
+		return false;
 
-	return false;
+	return true;
 }
 
-static int wl128x_boot_clk(struct wl1271 *wl, bool *is_ref_clk)
+static bool wl128x_is_fref_valid(struct wl1271 *wl)
 {
-	if (wl128x_switch_fref(wl, is_ref_clk)) {
-		wl1271_debug(DEBUG_BOOT, "XTAL-only mode go directly to"
-					 " TCXO TO FREF SWITCH");
-		/* TCXO to FREF switch - for PG2.0 */
-		wl1271_top_reg_write(wl, WL_SPARE_REG,
-				     WL_SPARE_MASK_8526);
-
-		wl1271_top_reg_write(wl, SYS_CLK_CFG_REG,
-			WL_CLK_REQ_TYPE_PG2 | MCS_PLL_CLK_SEL_FREF);
-
-		*is_ref_clk = true;
-		mdelay(15);
-	}
+	u16 fref_detection;
 
-	/* Set bit 2 in spare register to avoid illegal access */
-	wl1271_top_reg_write(wl, WL_SPARE_REG, WL_SPARE_VAL);
+	fref_detection = wl1271_top_reg_read(wl, FREF_CLK_DETECT_REG);
+	if (fref_detection & FREF_CLK_DETECT_FAIL)
+		return false;
 
-	/* working with TCXO clock */
-	if ((*is_ref_clk == false) &&
-	    ((wl->tcxo_clock == WL12XX_TCXOCLOCK_16_8) ||
-	     (wl->tcxo_clock == WL12XX_TCXOCLOCK_33_6))) {
-		wl1271_debug(DEBUG_BOOT, "16_8_M or 33_6_M TCXO detected");
+	return true;
+}
 
-		/* Manually Configure MCS PLL settings PG2.0 Only */
-		wl1271_top_reg_write(wl, MCS_PLL_M_REG, MCS_PLL_M_REG_VAL);
-		wl1271_top_reg_write(wl, MCS_PLL_N_REG, MCS_PLL_N_REG_VAL);
-		wl1271_top_reg_write(wl, MCS_PLL_CONFIG_REG,
-				     MCS_PLL_CONFIG_REG_VAL);
-	} else {
-		int pll_config;
-		u16 mcs_pll_config_val;
+static int wl128x_manually_configure_mcs_pll(struct wl1271 *wl)
+{
+	wl1271_top_reg_write(wl, MCS_PLL_M_REG, MCS_PLL_M_REG_VAL);
+	wl1271_top_reg_write(wl, MCS_PLL_N_REG, MCS_PLL_N_REG_VAL);
+	wl1271_top_reg_write(wl, MCS_PLL_CONFIG_REG, MCS_PLL_CONFIG_REG_VAL);
 
-		/*
-		 * Configure MCS PLL settings to FREF Freq
-		 * Set the values that determine the time elapse since the PLL's
-		 * get their enable signal until the lock indication is set
-		 */
-		wl1271_top_reg_write(wl, PLL_LOCK_COUNTERS_REG,
-			PLL_LOCK_COUNTERS_COEX | PLL_LOCK_COUNTERS_MCS);
+	return 0;
+}
 
-		mcs_pll_config_val = wl1271_top_reg_read(wl,
-						 MCS_PLL_CONFIG_REG);
-		/*
-		 * Set the MCS PLL input frequency value according to the
-		 * reference clock value detected/read
-		 */
-		if (*is_ref_clk == false) {
-			if ((wl->tcxo_clock == WL12XX_TCXOCLOCK_19_2) ||
-			    (wl->tcxo_clock == WL12XX_TCXOCLOCK_38_4))
-				pll_config = 1;
-			else if ((wl->tcxo_clock == WL12XX_TCXOCLOCK_26)
-				 ||
-				 (wl->tcxo_clock == WL12XX_TCXOCLOCK_52))
-				pll_config = 2;
-			else
-				return -EINVAL;
-		} else {
-			if ((wl->ref_clock == CONF_REF_CLK_19_2_E) ||
-			    (wl->ref_clock == CONF_REF_CLK_38_4_E))
-				pll_config = 1;
-			else if ((wl->ref_clock == CONF_REF_CLK_26_E) ||
-				 (wl->ref_clock == CONF_REF_CLK_52_E))
-				pll_config = 2;
-			else
-				return -EINVAL;
-		}
+static int wl128x_configure_mcs_pll(struct wl1271 *wl, int clk)
+{
+	u16 spare_reg;
+	u16 pll_config;
+	u8 input_freq;
+
+	/* Mask bits [3:1] in the sys_clk_cfg register */
+	spare_reg = wl1271_top_reg_read(wl, WL_SPARE_REG);
+	if (spare_reg == 0xFFFF)
+		return -EFAULT;
+	spare_reg |= BIT(2);
+	wl1271_top_reg_write(wl, WL_SPARE_REG, spare_reg);
+
+	/* Handle special cases of the TCXO clock */
+	if (wl->tcxo_clock == WL12XX_TCXOCLOCK_16_8 ||
+	    wl->tcxo_clock == WL12XX_TCXOCLOCK_33_6)
+		return wl128x_manually_configure_mcs_pll(wl);
+
+	/* Set the input frequency according to the selected clock source */
+	input_freq = (clk & 1) + 1;
+
+	pll_config = wl1271_top_reg_read(wl, MCS_PLL_CONFIG_REG);
+	if (pll_config == 0xFFFF)
+		return -EFAULT;
+	pll_config |= (input_freq << MCS_SEL_IN_FREQ_SHIFT);
+	pll_config |= MCS_PLL_ENABLE_HP;
+	wl1271_top_reg_write(wl, MCS_PLL_CONFIG_REG, pll_config);
 
-		mcs_pll_config_val |= (pll_config << (MCS_SEL_IN_FREQ_SHIFT)) &
-				      (MCS_SEL_IN_FREQ_MASK);
-		wl1271_top_reg_write(wl, MCS_PLL_CONFIG_REG,
-				     mcs_pll_config_val);
+	return 0;
+}
+
+/*
+ * WL128x has two clocks input - TCXO and FREF.
+ * TCXO is the main clock of the device, while FREF is used to sync
+ * between the GPS and the cellular modem.
+ * In cases where TCXO is 32.736MHz or 16.368MHz, the FREF will be used
+ * as the WLAN/BT main clock.
+ */
+static int wl128x_boot_clk(struct wl1271 *wl, int *selected_clock)
+{
+	u16 sys_clk_cfg;
+
+	/* For XTAL-only modes, FREF will be used after switching from TCXO */
+	if (wl->ref_clock == WL12XX_REFCLOCK_26_XTAL ||
+	    wl->ref_clock == WL12XX_REFCLOCK_38_XTAL) {
+		if (!wl128x_switch_tcxo_to_fref(wl))
+			return -EINVAL;
+		goto fref_clk;
 	}
 
-	return 0;
+	/* Query the HW, to determine which clock source we should use */
+	sys_clk_cfg = wl1271_top_reg_read(wl, SYS_CLK_CFG_REG);
+	if (sys_clk_cfg == 0xFFFF)
+		return -EINVAL;
+	if (sys_clk_cfg & PRCM_CM_EN_MUX_WLAN_FREF)
+		goto fref_clk;
+
+	/* If TCXO is either 32.736MHz or 16.368MHz, switch to FREF */
+	if (wl->tcxo_clock == WL12XX_TCXOCLOCK_16_368 ||
+	    wl->tcxo_clock == WL12XX_TCXOCLOCK_32_736) {
+		if (!wl128x_switch_tcxo_to_fref(wl))
+			return -EINVAL;
+		goto fref_clk;
+	}
+
+	/* TCXO clock is selected */
+	if (!wl128x_is_tcxo_valid(wl))
+		return -EINVAL;
+	*selected_clock = wl->tcxo_clock;
+	goto config_mcs_pll;
+
+fref_clk:
+	/* FREF clock is selected */
+	if (!wl128x_is_fref_valid(wl))
+		return -EINVAL;
+	*selected_clock = wl->ref_clock;
+
+config_mcs_pll:
+	return wl128x_configure_mcs_pll(wl, *selected_clock);
 }
 
 static int wl127x_boot_clk(struct wl1271 *wl)
@@ -713,10 +713,10 @@ int wl1271_load_firmware(struct wl1271 *wl)
 {
 	int ret = 0;
 	u32 tmp, clk;
-	bool is_ref_clk = false;
+	int selected_clock = -1;
 
 	if (wl->chip.id == CHIP_ID_1283_PG20) {
-		ret = wl128x_boot_clk(wl, &is_ref_clk);
+		ret = wl128x_boot_clk(wl, &selected_clock);
 		if (ret < 0)
 			goto out;
 	} else {
@@ -741,10 +741,7 @@ int wl1271_load_firmware(struct wl1271 *wl)
 	wl1271_debug(DEBUG_BOOT, "clk2 0x%x", clk);
 
 	if (wl->chip.id == CHIP_ID_1283_PG20) {
-		if (is_ref_clk == false)
-			clk |= ((wl->tcxo_clock & 0x3) << 1) << 4;
-		else
-			clk |= ((wl->ref_clock & 0x3) << 1) << 4;
+		clk |= ((selected_clock & 0x3) << 1) << 4;
 	} else {
 		clk |= (wl->ref_clock << 1) << 4;
 	}
diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
index 1f5ee31..d9de64a 100644
--- a/drivers/net/wireless/wl12xx/boot.h
+++ b/drivers/net/wireless/wl12xx/boot.h
@@ -107,6 +107,7 @@ struct wl1271_static_data {
 #define MCS_SEL_IN_FREQ_MASK         0x0070
 #define MCS_SEL_IN_FREQ_SHIFT        4
 #define MCS_PLL_CONFIG_REG_VAL       0x73
+#define MCS_PLL_ENABLE_HP            (BIT(0) | BIT(1))
 
 #define MCS_PLL_M_REG                0xD94
 #define MCS_PLL_N_REG                0xD96
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index eb8aaca..c1a743e 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -26,10 +26,12 @@
 
 /* Reference clock values */
 enum {
-	WL12XX_REFCLOCK_19 = 0,	/* 19.2 MHz */
-	WL12XX_REFCLOCK_26 = 1,	/* 26 MHz */
-	WL12XX_REFCLOCK_38 = 2,	/* 38.4 MHz */
-	WL12XX_REFCLOCK_54 = 3,	/* 54 MHz */
+	WL12XX_REFCLOCK_19	= 0, /* 19.2 MHz */
+	WL12XX_REFCLOCK_26	= 1, /* 26 MHz */
+	WL12XX_REFCLOCK_38	= 2, /* 38.4 MHz */
+	WL12XX_REFCLOCK_52	= 3, /* 52 MHz */
+	WL12XX_REFCLOCK_38_XTAL = 4, /* 38.4 MHz, XTAL */
+	WL12XX_REFCLOCK_26_XTAL = 5, /* 26 MHz, XTAL */
 };
 
 /* TCXO clock values */
-- 
1.7.1

