Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:36390 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755106Ab1CHNhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 08:37:36 -0500
Received: by mail-ew0-f50.google.com with SMTP id 26so2271038ewy.23
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2011 05:37:35 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: shahar_levi@ti.com
Cc: linux-wireless@vger.kernel.org, coelho@ti.com
Subject: [PATCH] wl12xx: fixes for 1281/1283 support - New boot sequence
Date: Tue,  8 Mar 2011 15:37:29 +0200
Message-Id: <1299591449-14741-1-git-send-email-coelho@ti.com>
In-Reply-To: <1299421940-26292-7-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-7-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes up some issues with patch 06/15 in the wl128x support
series:

* Remove unnecessary else block in wl128x_switch_fref;
* Remove unnecessary change in main.c;
* Remove some unnecessary debug prints and comments;
* Fix potential use of uninitialized value (pll_config)
* Add more all the defines for HCI_IO_DS_* instead of having them in a comment

This has been compile-tested only.  I will test this changes after I
go through the whole series and, if everything is still ok, I'll merge
this patch into 06/15.

Cc: Shahar Levi <shahar_levi@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c |  106 +++++++++++++++---------------------
 drivers/net/wireless/wl12xx/boot.h |    5 ++
 2 files changed, 48 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index e0d60ab..ffdcb7e 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -533,46 +533,42 @@ static int wl128x_switch_fref(struct wl1271 *wl, bool *is_ref_clk)
 
 	/* if working on XTAL-only mode go directly to TCXO TO FREF SWITCH */
 	if ((wl->ref_clock == CONF_REF_CLK_38_4_M_XTAL) ||
-	    (wl->ref_clock == CONF_REF_CLK_26_M_XTAL)) {
-		wl1271_debug(DEBUG_BOOT, "XTAL-only mode go directly to"
-					 " TCXO TO FREF SWITCH");
-
+	    (wl->ref_clock == CONF_REF_CLK_26_M_XTAL))
 		return true;
-	} else {
-		/* Read clock source FREF or TCXO */
-		sys_clk_cfg_val = wl1271_top_reg_read(wl, SYS_CLK_CFG_REG);
 
-		if (sys_clk_cfg_val & PRCM_CM_EN_MUX_WLAN_FREF) {
-			/* if bit 3 is set - working with FREF clock */
-			wl1271_debug(DEBUG_BOOT, "working with FREF clock, skip"
-						 " to FREF");
+	/* Read clock source FREF or TCXO */
+	sys_clk_cfg_val = wl1271_top_reg_read(wl, SYS_CLK_CFG_REG);
+
+	if (sys_clk_cfg_val & PRCM_CM_EN_MUX_WLAN_FREF) {
+		/* if bit 3 is set - working with FREF clock */
+		wl1271_debug(DEBUG_BOOT, "working with FREF clock, skip"
+			     " to FREF");
 
 		*is_ref_clk = true;
-		} else {
-			/* if bit 3 is clear - working with TCXO clock */
-			wl1271_debug(DEBUG_BOOT, "working with TCXO clock");
+	} else {
+		/* if bit 3 is clear - working with TCXO clock */
+		wl1271_debug(DEBUG_BOOT, "working with TCXO clock");
 
-			/* TCXO to FREF switch, check TXCO clock config */
-			if ((wl->tcxo_clock != CLOCK_TCXO_16_368_M) &&
-			    (wl->tcxo_clock != CLOCK_TCXO_32_736_M)) {
-				/*
+		/* TCXO to FREF switch, check TXCO clock config */
+		if ((wl->tcxo_clock != CLOCK_TCXO_16_368_M) &&
+		    (wl->tcxo_clock != CLOCK_TCXO_32_736_M)) {
+			/*
 			 * not 16.368Mhz and not 32.736Mhz - skip to
-				 * configure ELP stage
-				 */
-				wl1271_debug(DEBUG_BOOT, "NEW PLL ALGO:"
-					" TcxoRefClk=%d - not 16.368Mhz and not"
-					" 32.736Mhz - skip to configure ELP"
-					" stage", wl->tcxo_clock);
-
-				*is_ref_clk = false;
-			} else {
-				wl1271_debug(DEBUG_BOOT, "NEW PLL ALGO:"
-					"TcxoRefClk=%d - 16.368Mhz or 32.736Mhz"
-					" - TCXO to FREF switch",
-					wl->tcxo_clock);
-
-				return true;
-			}
+			 * configure ELP stage
+			 */
+			wl1271_debug(DEBUG_BOOT, "NEW PLL ALGO:"
+				     " TcxoRefClk=%d - not 16.368Mhz and not"
+				     " 32.736Mhz - skip to configure ELP"
+				     " stage", wl->tcxo_clock);
+
+			*is_ref_clk = false;
+		} else {
+			wl1271_debug(DEBUG_BOOT, "NEW PLL ALGO:"
+				     "TcxoRefClk=%d - 16.368Mhz or 32.736Mhz"
+				     " - TCXO to FREF switch",
+				     wl->tcxo_clock);
+
+			return true;
 		}
 	}
 
@@ -581,8 +577,9 @@ static int wl128x_switch_fref(struct wl1271 *wl, bool *is_ref_clk)
 
 static int wl128x_boot_clk(struct wl1271 *wl, bool *is_ref_clk)
 {
-
 	if (wl128x_switch_fref(wl, is_ref_clk)) {
+		wl1271_debug(DEBUG_BOOT, "XTAL-only mode go directly to"
+					 " TCXO TO FREF SWITCH");
 		/* TCXO to FREF switch - for PG2.0 */
 		wl1271_top_reg_write(wl, WL_SPARE_REG,
 				     WL_SPARE_MASK_8526);
@@ -590,31 +587,22 @@ static int wl128x_boot_clk(struct wl1271 *wl, bool *is_ref_clk)
 		wl1271_top_reg_write(wl, SYS_CLK_CFG_REG,
 			WL_CLK_REQ_TYPE_PG2 | MCS_PLL_CLK_SEL_FREF);
 
-		wl1271_debug(DEBUG_BOOT, "Wait settling time, "
-					 "Read FREF_CLK_DETECT_REG");
-
 		*is_ref_clk = true;
-		/* wait 15ms */
 		mdelay(15);
 	}
 
-	wl1271_debug(DEBUG_BOOT, "Setting bit 2 in spare register to avoid "
-				 "illegal access");
+	/* Set bit 2 in spare register to avoid illegal access */
 	wl1271_top_reg_write(wl, WL_SPARE_REG, WL_SPARE_VAL);
 
 	/* working with TCXO clock */
 	if ((*is_ref_clk == false) &&
 	    ((wl->tcxo_clock == CLOCK_TCXO_16_8_M) ||
 	     (wl->tcxo_clock == CLOCK_TCXO_33_6_M))) {
+		wl1271_debug(DEBUG_BOOT, "16_8_M or 33_6_M TCXO detected");
 
 		/* Manually Configure MCS PLL settings PG2.0 Only */
-		wl1271_debug(DEBUG_BOOT, "16_8_M or 33_6_M TCXO detected so "
-			"configure the MCS PLL settings manually!!!!");
-
 		wl1271_top_reg_write(wl, MCS_PLL_M_REG, MCS_PLL_M_REG_VAL);
-
 		wl1271_top_reg_write(wl, MCS_PLL_N_REG, MCS_PLL_N_REG_VAL);
-
 		wl1271_top_reg_write(wl, MCS_PLL_CONFIG_REG,
 				     MCS_PLL_CONFIG_REG_VAL);
 	} else {
@@ -631,7 +619,6 @@ static int wl128x_boot_clk(struct wl1271 *wl, bool *is_ref_clk)
 
 		mcs_pll_config_val = wl1271_top_reg_read(wl,
 						 MCS_PLL_CONFIG_REG);
-
 		/*
 		 * Set the MCS PLL input frequency value according to the
 		 * reference clock value detected/read
@@ -644,6 +631,8 @@ static int wl128x_boot_clk(struct wl1271 *wl, bool *is_ref_clk)
 				 ||
 				 (wl->tcxo_clock == CLOCK_TCXO_52_M))
 				pll_config = 2;
+			else
+				return -EINVAL;
 		} else {
 			if ((wl->ref_clock == CONF_REF_CLK_19_2_E) ||
 			    (wl->ref_clock == CONF_REF_CLK_38_4_E))
@@ -651,12 +640,12 @@ static int wl128x_boot_clk(struct wl1271 *wl, bool *is_ref_clk)
 			else if ((wl->ref_clock == CONF_REF_CLK_26_E) ||
 				 (wl->ref_clock == CONF_REF_CLK_52_E))
 				pll_config = 2;
+			else
+				return -EINVAL;
 		}
 
-		/* Setting Bits[6:4]  */
 		mcs_pll_config_val |= (pll_config << (MCS_SEL_IN_FREQ_SHIFT)) &
 				      (MCS_SEL_IN_FREQ_MASK);
-
 		wl1271_top_reg_write(wl, MCS_PLL_CONFIG_REG,
 				     mcs_pll_config_val);
 	}
@@ -683,7 +672,7 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 	else
 		return -EINVAL;
 
-	if (wl->ref_clock != 0) {
+	if (wl->ref_clock != CONF_REF_CLK_19_2_E) {
 		u16 val;
 		/* Set clock type (open drain) */
 		val = wl1271_top_reg_read(wl, OCP_REG_CLK_TYPE);
@@ -753,8 +742,9 @@ int wl1271_load_firmware(struct wl1271 *wl)
 			clk |= ((wl->tcxo_clock & 0x3) << 1) << 4;
 		else
 			clk |= ((wl->ref_clock & 0x3) << 1) << 4;
-	} else
-		clk |= ((wl->ref_clock & 0x3) << 1) << 4;
+	} else {
+		clk |= (wl->ref_clock << 1) << 4;
+	}
 
 	wl1271_write32(wl, DRPW_SCRATCH_START, clk);
 
@@ -788,18 +778,8 @@ int wl1271_load_firmware(struct wl1271 *wl)
 	/* WL1271: The reference driver skips steps 7 to 10 (jumps directly
 	 * to upload_fw) */
 
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
-		/*
-		 * Configure SDIO/wSPI DS according to the following table:
-		 * 00   8mA.
-		 * 01   4mA (default).
-		 * 10   6mA.
-		 * 11   2mA.
-		 * Write bits [1:0] of Register 0xd14
-		 * data is in pWlanParams->PlatformConfiguration bits [2:1]
-		 */
+	if (wl->chip.id == CHIP_ID_1283_PG20)
 		wl1271_top_reg_write(wl, SDIO_IO_DS, HCI_IO_DS_6MA);
-	}
 
 	ret = wl1271_boot_upload_firmware(wl);
 	if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
index daaf0e7..429c926 100644
--- a/drivers/net/wireless/wl12xx/boot.h
+++ b/drivers/net/wireless/wl12xx/boot.h
@@ -125,7 +125,12 @@ struct wl1271_static_data {
 #define MCS_PLL_N_REG_VAL            0x07
 
 #define SDIO_IO_DS                   0xd14
+
+/* SDIO/wSPI DS configuration values */
+#define HCI_IO_DS_8MA                0
+#define HCI_IO_DS_4MA                1 /* default */
 #define HCI_IO_DS_6MA                2
+#define HCI_IO_DS_2MA                4
 
 #define HW_CONFIG_19_2_M             1
 #define HW_CONFIG_26_M               2
-- 
1.7.1

