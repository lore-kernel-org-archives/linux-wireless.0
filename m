Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab0KPQGm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:42 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/18] iwlwifi: change default led mode for different devices
Date: Tue, 16 Nov 2010 08:01:38 -0800
Message-Id: <1289923311-14920-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the default led mode for different devices.

For the newer devices such as 6000g2a, 6000g2b and newer,
the default led mode is On/Off instead of blinking.

The led_mode still can be control through module parameter
  0: system default
  1: On/Off
  2: blinking

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-3945.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-4965.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-6000.c |   18 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 ++
 drivers/net/wireless/iwlwifi/iwl-led.c  |   10 ++++++----
 drivers/net/wireless/iwlwifi/iwl-led.h  |    6 ++++--
 8 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 068f1e1..e881b08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -287,6 +287,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl1000_base_params,
 	.ht_params = &iwl1000_ht_params,
+	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl1000_bg_cfg = {
@@ -302,6 +303,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.ops = &iwl1000_ops,
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl1000_base_params,
+	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl100_bgn_cfg = {
@@ -318,6 +320,7 @@ struct iwl_cfg iwl100_bgn_cfg = {
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl1000_base_params,
 	.ht_params = &iwl1000_ht_params,
+	.led_mode = IWL_LED_RF_STATE,
 };
 
 struct iwl_cfg iwl100_bg_cfg = {
@@ -333,6 +336,7 @@ struct iwl_cfg iwl100_bg_cfg = {
 	.ops = &iwl1000_ops,
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl1000_base_params,
+	.led_mode = IWL_LED_RF_STATE,
 };
 
 MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index ebac04b..4503245 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2788,6 +2788,7 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.ops = &iwl3945_ops,
 	.mod_params = &iwl3945_mod_params,
 	.base_params = &iwl3945_base_params,
+	.led_mode = IWL_LED_BLINK,
 };
 
 static struct iwl_cfg iwl3945_abg_cfg = {
@@ -2800,6 +2801,7 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.ops = &iwl3945_ops,
 	.mod_params = &iwl3945_mod_params,
 	.base_params = &iwl3945_base_params,
+	.led_mode = IWL_LED_BLINK,
 };
 
 DEFINE_PCI_DEVICE_TABLE(iwl3945_hw_card_ids) = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a172bd1..19da3e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2636,6 +2636,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.ops = &iwl4965_ops,
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl4965_base_params,
+	.led_mode = IWL_LED_BLINK,
 	/*
 	 * Force use of chains B and C for scan RX on 5 GHz band
 	 * because the device has off-channel reception on chain A.
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ad43f0f..b147580 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -536,6 +536,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl5000_base_params,
 	.ht_params = &iwl5000_ht_params,
+	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl5100_bgn_cfg = {
@@ -552,6 +553,7 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl5000_base_params,
 	.ht_params = &iwl5000_ht_params,
+	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl5100_abg_cfg = {
@@ -567,6 +569,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.ops = &iwl5000_ops,
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl5000_base_params,
+	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl5100_agn_cfg = {
@@ -583,6 +586,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl5000_base_params,
 	.ht_params = &iwl5000_ht_params,
+	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -599,6 +603,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl5000_base_params,
 	.ht_params = &iwl5000_ht_params,
+	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -616,6 +621,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.base_params = &iwl5000_base_params,
 	.ht_params = &iwl5000_ht_params,
 	.need_dc_calib = true,
+	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl5150_abg_cfg = {
@@ -632,6 +638,7 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl5000_base_params,
 	.need_dc_calib = true,
+	.led_mode = IWL_LED_BLINK,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index d8f9df6..9f835ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -567,6 +567,7 @@ struct iwl_cfg iwl6000g2a_2agn_cfg = {
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
+	.led_mode = IWL_LED_RF_STATE,
 };
 
 struct iwl_cfg iwl6000g2a_2abg_cfg = {
@@ -584,6 +585,7 @@ struct iwl_cfg iwl6000g2a_2abg_cfg = {
 	.base_params = &iwl6000_base_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
+	.led_mode = IWL_LED_RF_STATE,
 };
 
 struct iwl_cfg iwl6000g2a_2bg_cfg = {
@@ -601,6 +603,7 @@ struct iwl_cfg iwl6000g2a_2bg_cfg = {
 	.base_params = &iwl6000_base_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
+	.led_mode = IWL_LED_RF_STATE,
 };
 
 struct iwl_cfg iwl6000g2b_2agn_cfg = {
@@ -620,6 +623,7 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
+	.led_mode = IWL_LED_RF_STATE,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -640,6 +644,7 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
+	.led_mode = IWL_LED_RF_STATE,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -661,6 +666,7 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
+	.led_mode = IWL_LED_RF_STATE,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -681,6 +687,7 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
+	.led_mode = IWL_LED_RF_STATE,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -702,6 +709,7 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
+	.led_mode = IWL_LED_RF_STATE,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -722,6 +730,7 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
+	.led_mode = IWL_LED_RF_STATE,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -744,6 +753,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.base_params = &iwl6000_base_params,
 	.ht_params = &iwl6000_ht_params,
 	.pa_type = IWL_PA_INTERNAL,
+	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
@@ -760,6 +770,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl6000_base_params,
 	.pa_type = IWL_PA_INTERNAL,
+	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl6000i_2bg_cfg = {
@@ -776,6 +787,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl6000_base_params,
 	.pa_type = IWL_PA_INTERNAL,
+	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -793,6 +805,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.base_params = &iwl6050_base_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
+	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl6050g2_bgn_cfg = {
@@ -810,6 +823,7 @@ struct iwl_cfg iwl6050g2_bgn_cfg = {
 	.base_params = &iwl6050_base_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
+	.led_mode = IWL_LED_RF_STATE,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -826,6 +840,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl6050_base_params,
 	.need_dc_calib = true,
+	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -843,6 +858,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.base_params = &iwl6000_base_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
+	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl130_bgn_cfg = {
@@ -861,6 +877,7 @@ struct iwl_cfg iwl130_bgn_cfg = {
 	.bt_params = &iwl6000_bt_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
+	.led_mode = IWL_LED_RF_STATE,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -880,6 +897,7 @@ struct iwl_cfg iwl130_bg_cfg = {
 	.base_params = &iwl6000_coex_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
+	.led_mode = IWL_LED_RF_STATE,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 98b79f6..9035cd8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -363,6 +363,7 @@ struct iwl_ht_params {
  * @need_dc_calib: need to perform init dc calibration
  * @need_temp_offset_calib: need to perform temperature offset calibration
  * @scan_antennas: available antenna for scan operation
+ * @led_mode: 0=blinking, 1=On(RF On)/Off(RF Off)
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -409,6 +410,7 @@ struct iwl_cfg {
 	const bool need_temp_offset_calib; /* if used set to true */
 	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
 	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
+	enum iwl_led_mode led_mode;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 5a91292..516e557 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -45,9 +45,8 @@
 /* default: IWL_LED_BLINK(0) using blinking index table */
 static int led_mode;
 module_param(led_mode, int, S_IRUGO);
-MODULE_PARM_DESC(led_mode, "led mode: 0=blinking, 1=On(RF On)/Off(RF Off), "
-			   "(default 0)");
-
+MODULE_PARM_DESC(led_mode, "led mode: 0=system default, "
+		"1=On(RF On)/Off(RF Off), 2=blinking");
 
 static const struct {
 	u16 tpt;	/* Mb/s */
@@ -128,7 +127,7 @@ EXPORT_SYMBOL(iwl_led_start);
 int iwl_led_associate(struct iwl_priv *priv)
 {
 	IWL_DEBUG_LED(priv, "Associated\n");
-	if (led_mode == IWL_LED_BLINK)
+	if (priv->cfg->led_mode == IWL_LED_BLINK)
 		priv->allow_blinking = 1;
 	priv->last_blink_time = jiffies;
 
@@ -223,5 +222,8 @@ void iwl_leds_init(struct iwl_priv *priv)
 	priv->last_blink_rate = 0;
 	priv->last_blink_time = 0;
 	priv->allow_blinking = 0;
+	if (led_mode != IWL_LED_DEFAULT &&
+	    led_mode != priv->cfg->led_mode)
+		priv->cfg->led_mode = led_mode;
 }
 EXPORT_SYMBOL(iwl_leds_init);
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index 49a70ba..9079b33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -47,14 +47,16 @@ enum led_type {
 
 /*
  * LED mode
- *    IWL_LED_BLINK:    adjust led blink rate based on blink table
+ *    IWL_LED_DEFAULT:  use system default
  *    IWL_LED_RF_STATE: turn LED on/off based on RF state
  *			LED ON  = RF ON
  *			LED OFF = RF OFF
+ *    IWL_LED_BLINK:    adjust led blink rate based on blink table
  */
 enum iwl_led_mode {
-	IWL_LED_BLINK,
+	IWL_LED_DEFAULT,
 	IWL_LED_RF_STATE,
+	IWL_LED_BLINK,
 };
 
 void iwl_leds_init(struct iwl_priv *priv);
-- 
1.7.0.4

