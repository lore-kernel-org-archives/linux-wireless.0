Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34125 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab1CFO2Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:16 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p26ESGCw019825
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 6 Mar 2011 08:28:16 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH 06/15] wl12xx: 1281/1283 support - New boot sequence
Date: Sun,  6 Mar 2011 16:32:11 +0200
Message-Id: <1299421940-26292-7-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Boot sequence support FREF clock and TCXO clock.
WL128x has two clocks input - TCXO and FREF.
TCXO is the main clock of the device, while FREF is used to sync
between the GPS and the cellular modem.
Auto-detection checks where TCXO is 32.736MHz or 16.368MHz, in that
case the FREF will be used as the WLAN/BT main clock.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c      |  200 +++++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/main.c      |    2 +-
 drivers/net/wireless/wl12xx/sdio.c      |    1 +
 drivers/net/wireless/wl12xx/sdio_test.c |    1 +
 drivers/net/wireless/wl12xx/spi.c       |    1 +
 drivers/net/wireless/wl12xx/wl12xx.h    |    1 +
 include/linux/wl12xx.h                  |    1 +
 7 files changed, 199 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 7984631..2f40909 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -519,18 +519,164 @@ static void wl1271_boot_hw_version(struct wl1271 *wl)
 		wl->quirks |= WL12XX_QUIRK_END_OF_TRANSACTION;
 }
 
-/* uploads NVS and firmware */
-int wl1271_load_firmware(struct wl1271 *wl)
+/*
+ * WL128x has two clocks input - TCXO and FREF.
+ * TCXO is the main clock of the device, while FREF is used to sync
+ * between the GPS and the cellular modem.
+ * In cases where TCXO is 32.736MHz or 16.368MHz, the FREF will be used
+ * as the WLAN/BT main clock.
+ */
+static int wl128x_switch_fref(struct wl1271 *wl, bool *is_ref_clk)
 {
-	int ret = 0;
-	u32 tmp, clk, pause;
+	u16 sys_clk_cfg_val;
+
+	/* if working on XTAL-only mode go directly to TCXO TO FREF SWITCH */
+	if ((wl->ref_clock == CONF_REF_CLK_38_4_M_XTAL) ||
+	    (wl->ref_clock == CONF_REF_CLK_26_M_XTAL)) {
+		wl1271_debug(DEBUG_BOOT, "XTAL-only mode go directly to"
+					 " TCXO TO FREF SWITCH");
+
+		return true;
+	} else {
+		/* Read clock source FREF or TCXO */
+		sys_clk_cfg_val = wl1271_top_reg_read(wl, SYS_CLK_CFG_REG);
+
+		if (sys_clk_cfg_val & PRCM_CM_EN_MUX_WLAN_FREF) {
+			/* if bit 3 is set - working with FREF clock */
+			wl1271_debug(DEBUG_BOOT, "working with FREF clock, skip"
+						 " to FREF");
+
+		*is_ref_clk = true;
+		} else {
+			/* if bit 3 is clear - working with TCXO clock */
+			wl1271_debug(DEBUG_BOOT, "working with TCXO clock");
+
+			/* TCXO to FREF switch, check TXCO clock config */
+			if ((wl->tcxo_clock != CLOCK_TCXO_16_368_M) &&
+			    (wl->tcxo_clock != CLOCK_TCXO_32_736_M)) {
+				/*
+			 * not 16.368Mhz and not 32.736Mhz - skip to
+				 * configure ELP stage
+				 */
+				wl1271_debug(DEBUG_BOOT, "NEW PLL ALGO:"
+					" TcxoRefClk=%d - not 16.368Mhz and not"
+					" 32.736Mhz - skip to configure ELP"
+					" stage", wl->tcxo_clock);
+
+				*is_ref_clk = false;
+			} else {
+				wl1271_debug(DEBUG_BOOT, "NEW PLL ALGO:"
+					"TcxoRefClk=%d - 16.368Mhz or 32.736Mhz"
+					" - TCXO to FREF switch",
+					wl->tcxo_clock);
+
+				return true;
+			}
+		}
+	}
+
+	return false;
+}
+
+static int wl128x_boot_clk(struct wl1271 *wl, bool *is_ref_clk)
+{
+
+	if (wl128x_switch_fref(wl, is_ref_clk)) {
+		/* TCXO to FREF switch - for PG2.0 */
+		wl1271_top_reg_write(wl, WL_SPARE_REG,
+				     WL_SPARE_MASK_8526);
+
+		wl1271_top_reg_write(wl, SYS_CLK_CFG_REG,
+			WL_CLK_REQ_TYPE_PG2 | MCS_PLL_CLK_SEL_FREF);
+
+		wl1271_debug(DEBUG_BOOT, "Wait settling time, "
+					 "Read FREF_CLK_DETECT_REG");
+
+		*is_ref_clk = true;
+		/* wait 15ms */
+		mdelay(15);
+	}
+
+	wl1271_debug(DEBUG_BOOT, "Setting bit 2 in spare register to avoid "
+				 "illegal access");
+	wl1271_top_reg_write(wl, WL_SPARE_REG, WL_SPARE_VAL);
+
+	/* working with TCXO clock */
+	if ((*is_ref_clk == false) &&
+	    ((wl->tcxo_clock == CLOCK_TCXO_16_8_M) ||
+	     (wl->tcxo_clock == CLOCK_TCXO_33_6_M))) {
+
+		/* Manually Configure MCS PLL settings PG2.0 Only */
+		wl1271_debug(DEBUG_BOOT, "16_8_M or 33_6_M TCXO detected so "
+			"configure the MCS PLL settings manually!!!!");
+
+		wl1271_top_reg_write(wl, MCS_PLL_M_REG, MCS_PLL_M_REG_VAL);
+
+		wl1271_top_reg_write(wl, MCS_PLL_N_REG, MCS_PLL_N_REG_VAL);
+
+		wl1271_top_reg_write(wl, MCS_PLL_CONFIG_REG,
+				     MCS_PLL_CONFIG_REG_VAL);
+	} else {
+		int pll_config;
+		u16 mcs_pll_config_val;
+
+		/*
+		 * Configure MCS PLL settings to FREF Freq
+		 * Set the values that determine the time elapse since the PLL's
+		 * get their enable signal until the lock indication is set
+		 */
+		wl1271_top_reg_write(wl, PLL_LOCK_COUNTERS_REG,
+			PLL_LOCK_COUNTERS_COEX | PLL_LOCK_COUNTERS_MCS);
+
+		mcs_pll_config_val = wl1271_top_reg_read(wl,
+						 MCS_PLL_CONFIG_REG);
+
+		/*
+		 * Set the MCS PLL input frequency value according to the
+		 * reference clock value detected/read
+		 */
+		if (*is_ref_clk == false) {
+			if ((wl->tcxo_clock == CLOCK_TCXO_19_2_M) ||
+			    (wl->tcxo_clock == CLOCK_TCXO_38_4_M))
+				pll_config = 1;
+			else if ((wl->tcxo_clock == CLOCK_TCXO_26_M)
+				 ||
+				 (wl->tcxo_clock == CLOCK_TCXO_52_M))
+				pll_config = 2;
+		} else {
+			if ((wl->ref_clock == CONF_REF_CLK_19_2_E) ||
+			    (wl->ref_clock == CONF_REF_CLK_38_4_E))
+				pll_config = 1;
+			else if ((wl->ref_clock == CONF_REF_CLK_26_E) ||
+				 (wl->ref_clock == CONF_REF_CLK_52_E))
+				pll_config = 2;
+		}
+
+		/* Setting Bits[6:4]  */
+		mcs_pll_config_val |= (pll_config << (MCS_SEL_IN_FREQ_SHIFT)) &
+				      (MCS_SEL_IN_FREQ_MASK);
+
+		wl1271_top_reg_write(wl, MCS_PLL_CONFIG_REG,
+				     mcs_pll_config_val);
+	}
+
+	return 0;
+}
+
+static int wl127x_boot_clk(struct wl1271 *wl)
+{
+	u32 pause;
+	u32 clk;
 
 	wl1271_boot_hw_version(wl);
 
-	if (wl->ref_clock == 0 || wl->ref_clock == 2 || wl->ref_clock == 4)
+	if (wl->ref_clock == CONF_REF_CLK_19_2_E ||
+	    wl->ref_clock == CONF_REF_CLK_38_4_E ||
+	    wl->ref_clock == CONF_REF_CLK_38_4_M_XTAL)
 		/* ref clk: 19.2/38.4/38.4-XTAL */
 		clk = 0x3;
-	else if (wl->ref_clock == 1 || wl->ref_clock == 3)
+	else if (wl->ref_clock == CONF_REF_CLK_26_E ||
+		 wl->ref_clock == CONF_REF_CLK_52_E)
 		/* ref clk: 26/52 */
 		clk = 0x5;
 	else
@@ -566,6 +712,26 @@ int wl1271_load_firmware(struct wl1271 *wl)
 	pause |= WU_COUNTER_PAUSE_VAL;
 	wl1271_write32(wl, WU_COUNTER_PAUSE, pause);
 
+	return 0;
+}
+
+/* uploads NVS and firmware */
+int wl1271_load_firmware(struct wl1271 *wl)
+{
+	int ret = 0;
+	u32 tmp, clk;
+	bool is_ref_clk = false;
+
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		ret = wl128x_boot_clk(wl, &is_ref_clk);
+		if (ret < 0)
+			goto out;
+	} else {
+		ret = wl127x_boot_clk(wl);
+		if (ret < 0)
+			goto out;
+	}
+
 	/* Continue the ELP wake up sequence */
 	wl1271_write32(wl, WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
 	udelay(500);
@@ -581,7 +747,14 @@ int wl1271_load_firmware(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_BOOT, "clk2 0x%x", clk);
 
-	clk |= (wl->ref_clock << 1) << 4;
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		if (is_ref_clk == false)
+			clk |= ((wl->tcxo_clock & 0x3) << 1) << 4;
+		else
+			clk |= ((wl->ref_clock & 0x3) << 1) << 4;
+	} else
+		clk |= ((wl->ref_clock & 0x3) << 1) << 4;
+
 	wl1271_write32(wl, DRPW_SCRATCH_START, clk);
 
 	wl1271_set_partition(wl, &part_table[PART_WORK]);
@@ -614,6 +787,19 @@ int wl1271_load_firmware(struct wl1271 *wl)
 	/* WL1271: The reference driver skips steps 7 to 10 (jumps directly
 	 * to upload_fw) */
 
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		/*
+		 * Configure SDIO/wSPI DS according to the following table:
+		 * 00   8mA.
+		 * 01   4mA (default).
+		 * 10   6mA.
+		 * 11   2mA.
+		 * Write bits [1:0] of Register 0xd14
+		 * data is in pWlanParams->PlatformConfiguration bits [2:1]
+		 */
+		wl1271_top_reg_write(wl, SDIO_IO_DS, HCI_IO_DS_6MA);
+	}
+
 	ret = wl1271_boot_upload_firmware(wl);
 	if (ret < 0)
 		goto out;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 4823897..4bcac46 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -307,7 +307,7 @@ static struct conf_drv_settings default_conf = {
 		.min_req_tx_blocks            = 100,
 		.min_req_rx_blocks            = 22,
 		.tx_min                       = 27,
-	}
+	},
 };
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index ed0f37e..521a187 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -252,6 +252,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 
 	wl->irq = wlan_data->irq;
 	wl->ref_clock = wlan_data->board_ref_clock;
+	wl->tcxo_clock = wlan_data->board_tcxo_clock;
 
 	ret = request_threaded_irq(wl->irq, wl1271_hardirq, wl1271_irq,
 				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
diff --git a/drivers/net/wireless/wl12xx/sdio_test.c b/drivers/net/wireless/wl12xx/sdio_test.c
index e6e2ad6..c02c870 100644
--- a/drivers/net/wireless/wl12xx/sdio_test.c
+++ b/drivers/net/wireless/wl12xx/sdio_test.c
@@ -421,6 +421,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 
 	wl->irq = wlan_data->irq;
 	wl->ref_clock = wlan_data->board_ref_clock;
+	wl->tcxo_clock = wlan_data->board_tcxo_clock;
 
 	sdio_set_drvdata(func, wl_test);
 
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index d6e566e..abbb8dc 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -409,6 +409,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	}
 
 	wl->ref_clock = pdata->board_ref_clock;
+	wl->tcxo_clock = pdata->board_tcxo_clock;
 
 	wl->irq = spi->irq;
 	if (wl->irq < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index cc7f01c..ed4be73 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -537,6 +537,7 @@ struct wl1271 {
 	/* wl128x features only */
 	__le32	host_cfg_bitmap;
 	u32	block_size;
+	int     tcxo_clock;
 
 	/*
 	 * AP-mode - links indexed by HLID. The global and broadcast links
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index bebb8ef..cc2a6e1 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -38,6 +38,7 @@ struct wl12xx_platform_data {
 	int irq;
 	bool use_eeprom;
 	int board_ref_clock;
+	int board_tcxo_clock;
 };
 
 #ifdef CONFIG_WL12XX_PLATFORM_DATA
-- 
1.7.0.4

