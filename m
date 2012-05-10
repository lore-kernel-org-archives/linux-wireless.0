Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215Ab2EJJPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:54 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:53 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 38/78] wlcore/wl12xx: move ref_clock and tcxo_clock elements to wl12xx
Date: Thu, 10 May 2012 12:13:43 +0300
Message-Id: <1336641263-5761-39-git-send-email-arik@wizery.com> (sfid-20120510_112147_015138_AE779923)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Only wl12xx needs to get the ref_clock anc tcxo_clock values from the
platform data.  Move these elements from the wl1271 structure to
wl12xx's private data.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/cmd.c     |    8 ++-
 drivers/net/wireless/ti/wl12xx/main.c    |   88 +++++++++++++++++++++++++-----
 drivers/net/wireless/ti/wl12xx/wl12xx.h  |    3 +
 drivers/net/wireless/ti/wlcore/debugfs.c |    3 +-
 drivers/net/wireless/ti/wlcore/main.c    |    2 -
 drivers/net/wireless/ti/wlcore/wlcore.h  |    3 -
 6 files changed, 82 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/cmd.c b/drivers/net/wireless/ti/wl12xx/cmd.c
index 8ffaeb5..50ba748 100644
--- a/drivers/net/wireless/ti/wl12xx/cmd.c
+++ b/drivers/net/wireless/ti/wl12xx/cmd.c
@@ -65,6 +65,7 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 	struct wl1271_general_parms_cmd *gen_parms;
 	struct wl1271_ini_general_params *gp =
 		&((struct wl1271_nvs_file *)wl->nvs)->general_params;
+	struct wl12xx_priv *priv = wl->priv;
 	bool answer = false;
 	int ret;
 
@@ -88,7 +89,7 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 		answer = true;
 
 	/* Override the REF CLK from the NVS with the one from platform data */
-	gen_parms->general_params.ref_clock = wl->ref_clock;
+	gen_parms->general_params.ref_clock = priv->ref_clock;
 
 	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), answer);
 	if (ret < 0) {
@@ -118,6 +119,7 @@ int wl128x_cmd_general_parms(struct wl1271 *wl)
 	struct wl128x_general_parms_cmd *gen_parms;
 	struct wl128x_ini_general_params *gp =
 		&((struct wl128x_nvs_file *)wl->nvs)->general_params;
+	struct wl12xx_priv *priv = wl->priv;
 	bool answer = false;
 	int ret;
 
@@ -141,8 +143,8 @@ int wl128x_cmd_general_parms(struct wl1271 *wl)
 		answer = true;
 
 	/* Replace REF and TCXO CLKs with the ones from platform data */
-	gen_parms->general_params.ref_clock = wl->ref_clock;
-	gen_parms->general_params.tcxo_ref_clock = wl->tcxo_clock;
+	gen_parms->general_params.ref_clock = priv->ref_clock;
+	gen_parms->general_params.tcxo_ref_clock = priv->tcxo_clock;
 
 	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), answer);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index ad760a3..962d85d 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -40,6 +40,9 @@
 #include "cmd.h"
 #include "acx.h"
 
+static char *fref_param;
+static char *tcxo_param;
+
 static struct wlcore_conf wl12xx_conf = {
 	.sg = {
 		.params = {
@@ -773,6 +776,7 @@ static int wl128x_configure_mcs_pll(struct wl1271 *wl, int clk)
 	u16 spare_reg;
 	u16 pll_config;
 	u8 input_freq;
+	struct wl12xx_priv *priv = wl->priv;
 
 	/* Mask bits [3:1] in the sys_clk_cfg register */
 	spare_reg = wl12xx_top_reg_read(wl, WL_SPARE_REG);
@@ -782,8 +786,8 @@ static int wl128x_configure_mcs_pll(struct wl1271 *wl, int clk)
 	wl12xx_top_reg_write(wl, WL_SPARE_REG, spare_reg);
 
 	/* Handle special cases of the TCXO clock */
-	if (wl->tcxo_clock == WL12XX_TCXOCLOCK_16_8 ||
-	    wl->tcxo_clock == WL12XX_TCXOCLOCK_33_6)
+	if (priv->tcxo_clock == WL12XX_TCXOCLOCK_16_8 ||
+	    priv->tcxo_clock == WL12XX_TCXOCLOCK_33_6)
 		return wl128x_manually_configure_mcs_pll(wl);
 
 	/* Set the input frequency according to the selected clock source */
@@ -808,11 +812,12 @@ static int wl128x_configure_mcs_pll(struct wl1271 *wl, int clk)
  */
 static int wl128x_boot_clk(struct wl1271 *wl, int *selected_clock)
 {
+	struct wl12xx_priv *priv = wl->priv;
 	u16 sys_clk_cfg;
 
 	/* For XTAL-only modes, FREF will be used after switching from TCXO */
-	if (wl->ref_clock == WL12XX_REFCLOCK_26_XTAL ||
-	    wl->ref_clock == WL12XX_REFCLOCK_38_XTAL) {
+	if (priv->ref_clock == WL12XX_REFCLOCK_26_XTAL ||
+	    priv->ref_clock == WL12XX_REFCLOCK_38_XTAL) {
 		if (!wl128x_switch_tcxo_to_fref(wl))
 			return -EINVAL;
 		goto fref_clk;
@@ -826,8 +831,8 @@ static int wl128x_boot_clk(struct wl1271 *wl, int *selected_clock)
 		goto fref_clk;
 
 	/* If TCXO is either 32.736MHz or 16.368MHz, switch to FREF */
-	if (wl->tcxo_clock == WL12XX_TCXOCLOCK_16_368 ||
-	    wl->tcxo_clock == WL12XX_TCXOCLOCK_32_736) {
+	if (priv->tcxo_clock == WL12XX_TCXOCLOCK_16_368 ||
+	    priv->tcxo_clock == WL12XX_TCXOCLOCK_32_736) {
 		if (!wl128x_switch_tcxo_to_fref(wl))
 			return -EINVAL;
 		goto fref_clk;
@@ -836,14 +841,14 @@ static int wl128x_boot_clk(struct wl1271 *wl, int *selected_clock)
 	/* TCXO clock is selected */
 	if (!wl128x_is_tcxo_valid(wl))
 		return -EINVAL;
-	*selected_clock = wl->tcxo_clock;
+	*selected_clock = priv->tcxo_clock;
 	goto config_mcs_pll;
 
 fref_clk:
 	/* FREF clock is selected */
 	if (!wl128x_is_fref_valid(wl))
 		return -EINVAL;
-	*selected_clock = wl->ref_clock;
+	*selected_clock = priv->ref_clock;
 
 config_mcs_pll:
 	return wl128x_configure_mcs_pll(wl, *selected_clock);
@@ -851,25 +856,26 @@ config_mcs_pll:
 
 static int wl127x_boot_clk(struct wl1271 *wl)
 {
+	struct wl12xx_priv *priv = wl->priv;
 	u32 pause;
 	u32 clk;
 
 	if (WL127X_PG_GET_MAJOR(wl->hw_pg_ver) < 3)
 		wl->quirks |= WLCORE_QUIRK_END_OF_TRANSACTION;
 
-	if (wl->ref_clock == CONF_REF_CLK_19_2_E ||
-	    wl->ref_clock == CONF_REF_CLK_38_4_E ||
-	    wl->ref_clock == CONF_REF_CLK_38_4_M_XTAL)
+	if (priv->ref_clock == CONF_REF_CLK_19_2_E ||
+	    priv->ref_clock == CONF_REF_CLK_38_4_E ||
+	    priv->ref_clock == CONF_REF_CLK_38_4_M_XTAL)
 		/* ref clk: 19.2/38.4/38.4-XTAL */
 		clk = 0x3;
-	else if (wl->ref_clock == CONF_REF_CLK_26_E ||
-		 wl->ref_clock == CONF_REF_CLK_52_E)
+	else if (priv->ref_clock == CONF_REF_CLK_26_E ||
+		 priv->ref_clock == CONF_REF_CLK_52_E)
 		/* ref clk: 26/52 */
 		clk = 0x5;
 	else
 		return -EINVAL;
 
-	if (wl->ref_clock != CONF_REF_CLK_19_2_E) {
+	if (priv->ref_clock != CONF_REF_CLK_19_2_E) {
 		u16 val;
 		/* Set clock type (open drain) */
 		val = wl12xx_top_reg_read(wl, OCP_REG_CLK_TYPE);
@@ -939,6 +945,7 @@ static int wl1271_boot_soft_reset(struct wl1271 *wl)
 
 static int wl12xx_pre_boot(struct wl1271 *wl)
 {
+	struct wl12xx_priv *priv = wl->priv;
 	int ret = 0;
 	u32 clk;
 	int selected_clock = -1;
@@ -970,7 +977,7 @@ static int wl12xx_pre_boot(struct wl1271 *wl)
 	if (wl->chip.id == CHIP_ID_1283_PG20)
 		clk |= ((selected_clock & 0x3) << 1) << 4;
 	else
-		clk |= (wl->ref_clock << 1) << 4;
+		clk |= (priv->ref_clock << 1) << 4;
 
 	wl1271_write32(wl, WL12XX_DRPW_SCRATCH_START, clk);
 
@@ -1333,6 +1340,7 @@ static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
 
 static int __devinit wl12xx_probe(struct platform_device *pdev)
 {
+	struct wl12xx_platform_data *pdata = pdev->dev.platform_data;
 	struct wl1271 *wl;
 	struct ieee80211_hw *hw;
 	struct wl12xx_priv *priv;
@@ -1344,6 +1352,7 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	}
 
 	wl = hw->priv;
+	priv = wl->priv;
 	wl->ops = &wl12xx_ops;
 	wl->ptable = wl12xx_ptable;
 	wl->rtable = wl12xx_rtable;
@@ -1357,6 +1366,48 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	memcpy(&wl->ht_cap, &wl12xx_ht_cap, sizeof(wl12xx_ht_cap));
 	wl12xx_conf_init(wl);
 
+	if (!fref_param) {
+		priv->ref_clock = pdata->board_ref_clock;
+	} else {
+		if (!strcmp(fref_param, "19.2"))
+			priv->ref_clock = WL12XX_REFCLOCK_19;
+		else if (!strcmp(fref_param, "26"))
+			priv->ref_clock = WL12XX_REFCLOCK_26;
+		else if (!strcmp(fref_param, "26x"))
+			priv->ref_clock = WL12XX_REFCLOCK_26_XTAL;
+		else if (!strcmp(fref_param, "38.4"))
+			priv->ref_clock = WL12XX_REFCLOCK_38;
+		else if (!strcmp(fref_param, "38.4x"))
+			priv->ref_clock = WL12XX_REFCLOCK_38_XTAL;
+		else if (!strcmp(fref_param, "52"))
+			priv->ref_clock = WL12XX_REFCLOCK_52;
+		else
+			wl1271_error("Invalid fref parameter %s", fref_param);
+	}
+
+	if (!tcxo_param) {
+		priv->tcxo_clock = pdata->board_tcxo_clock;
+	} else {
+		if (!strcmp(tcxo_param, "19.2"))
+			priv->tcxo_clock = WL12XX_TCXOCLOCK_19_2;
+		else if (!strcmp(tcxo_param, "26"))
+			priv->tcxo_clock = WL12XX_TCXOCLOCK_26;
+		else if (!strcmp(tcxo_param, "38.4"))
+			priv->tcxo_clock = WL12XX_TCXOCLOCK_38_4;
+		else if (!strcmp(tcxo_param, "52"))
+			priv->tcxo_clock = WL12XX_TCXOCLOCK_52;
+		else if (!strcmp(tcxo_param, "16.368"))
+			priv->tcxo_clock = WL12XX_TCXOCLOCK_16_368;
+		else if (!strcmp(tcxo_param, "32.736"))
+			priv->tcxo_clock = WL12XX_TCXOCLOCK_32_736;
+		else if (!strcmp(tcxo_param, "16.8"))
+			priv->tcxo_clock = WL12XX_TCXOCLOCK_16_8;
+		else if (!strcmp(tcxo_param, "33.6"))
+			priv->tcxo_clock = WL12XX_TCXOCLOCK_33_6;
+		else
+			wl1271_error("Invalid tcxo parameter %s", tcxo_param);
+	}
+
 	return wlcore_probe(wl, pdev);
 }
 
@@ -1388,6 +1439,13 @@ static void __exit wl12xx_exit(void)
 }
 module_exit(wl12xx_exit);
 
+module_param_named(fref, fref_param, charp, 0);
+MODULE_PARM_DESC(fref, "FREF clock: 19.2, 26, 26x, 38.4, 38.4x, 52");
+
+module_param_named(tcxo, tcxo_param, charp, 0);
+MODULE_PARM_DESC(tcxo,
+		 "TCXO clock: 19.2, 26, 38.4, 52, 16.368, 32.736, 16.8, 33.6");
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_FIRMWARE(WL127X_FW_NAME_SINGLE);
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index 74cd332..0d81c1e 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -26,6 +26,9 @@
 
 struct wl12xx_priv {
 	struct wl12xx_priv_conf conf;
+
+	int ref_clock;
+	int tcxo_clock;
 };
 
 #endif /* __WL12XX_PRIV_H__ */
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index d5aea1f..d377519 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -535,8 +535,7 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_LHEX(ap_ps_map);
 	DRIVER_STATE_PRINT_HEX(quirks);
 	DRIVER_STATE_PRINT_HEX(irq);
-	DRIVER_STATE_PRINT_HEX(ref_clock);
-	DRIVER_STATE_PRINT_HEX(tcxo_clock);
+	/* TODO: ref_clock and tcxo_clock were moved to wl12xx priv */
 	DRIVER_STATE_PRINT_HEX(hw_pg_ver);
 	DRIVER_STATE_PRINT_HEX(platform_quirks);
 	DRIVER_STATE_PRINT_HEX(chip.id);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index cbe94ed..414ffa8 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5294,8 +5294,6 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 	wlcore_adjust_conf(wl);
 
 	wl->irq = platform_get_irq(pdev, 0);
-	wl->ref_clock = pdata->board_ref_clock;
-	wl->tcxo_clock = pdata->board_tcxo_clock;
 	wl->platform_quirks = pdata->platform_quirks;
 	wl->set_power = pdata->set_power;
 	wl->dev = &pdev->dev;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 8f724da..89abbce 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -130,7 +130,6 @@ struct wl1271 {
 
 	void (*set_power)(bool enable);
 	int irq;
-	int ref_clock;
 
 	spinlock_t wl_lock;
 
@@ -288,8 +287,6 @@ struct wl1271 {
 	/* bands supported by this instance of wl12xx */
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
-	int tcxo_clock;
-
 	/*
 	 * wowlan trigger was configured during suspend.
 	 * (currently, only "ANY" trigger is supported)
-- 
1.7.9.5

