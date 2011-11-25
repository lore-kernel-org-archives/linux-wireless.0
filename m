Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19787 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab1KYUIS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 15:08:18 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/7] iwlagn: remove calibration knowledge
Date: Fri, 25 Nov 2011 11:11:43 -0800
Message-Id: <1322248308-5113-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111125_210833_137571_B94E8964)
In-Reply-To: <1322248308-5113-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322248308-5113-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The init microcode knows very well which calibrations
are required and sends us results for those that are.
Consequently, we can just send all of those to the RT
uCode again.

The problem with having the driver know about this is
that it is a uCode feature, not a hardware feature so
the config is completely unsuitable.

The only thing we need to check is whether the device
needs crystal calibration or not, add a new parameter
to the configuration for that.

This makes new uCode work on 6000 series devices.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    9 --------
 drivers/net/wireless/iwlwifi/iwl-2000.c      |   14 -------------
 drivers/net/wireless/iwlwifi/iwl-5000.c      |   16 +-------------
 drivers/net/wireless/iwlwifi/iwl-6000.c      |   15 -------------
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |   28 ++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    8 ++++--
 drivers/net/wireless/iwlwifi/iwl-core.h      |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-shared.h    |    2 -
 8 files changed, 22 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index e12b48c..bc9bbbb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -147,16 +147,7 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 	iwl1000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
-	/* Set initial calibration set */
 	hw_params(priv).sens = &iwl1000_sensitivity;
-	hw_params(priv).calib_init_cfg =
-			BIT(IWL_CALIB_XTAL)		|
-			BIT(IWL_CALIB_LO)		|
-			BIT(IWL_CALIB_TX_IQ) 		|
-			BIT(IWL_CALIB_TX_IQ_PERD)	|
-			BIT(IWL_CALIB_BASE_BAND);
-	if (priv->cfg->need_dc_calib)
-		hw_params(priv).calib_init_cfg |= BIT(IWL_CALIB_DC);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index b319357..0c4688d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -143,17 +143,7 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 	iwl2000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
-	/* Set initial calibration set */
 	hw_params(priv).sens = &iwl2000_sensitivity;
-	hw_params(priv).calib_init_cfg =
-		BIT(IWL_CALIB_XTAL)             |
-		BIT(IWL_CALIB_LO)               |
-		BIT(IWL_CALIB_TX_IQ)            |
-		BIT(IWL_CALIB_BASE_BAND);
-	if (priv->cfg->need_dc_calib)
-		hw_params(priv).calib_rt_cfg |= IWL_CALIB_CFG_DC_IDX;
-	if (priv->cfg->need_temp_offset_calib)
-		hw_params(priv).calib_init_cfg |= BIT(IWL_CALIB_TEMP_OFFSET);
 
 	return 0;
 }
@@ -258,7 +248,6 @@ static struct iwl_bt_params iwl2030_bt_params = {
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.lib = &iwl2000_lib,					\
 	.base_params = &iwl2000_base_params,			\
-	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
 	.temp_offset_v2 = true,					\
 	.led_mode = IWL_LED_RF_STATE,				\
@@ -286,7 +275,6 @@ struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.lib = &iwl2030_lib,					\
 	.base_params = &iwl2030_base_params,			\
 	.bt_params = &iwl2030_bt_params,			\
-	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
 	.temp_offset_v2 = true,					\
 	.led_mode = IWL_LED_RF_STATE,				\
@@ -308,7 +296,6 @@ struct iwl_cfg iwl2030_2bgn_cfg = {
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.lib = &iwl2000_lib,					\
 	.base_params = &iwl2000_base_params,			\
-	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
 	.temp_offset_v2 = true,					\
 	.led_mode = IWL_LED_RF_STATE,				\
@@ -338,7 +325,6 @@ struct iwl_cfg iwl105_bgn_d_cfg = {
 	.lib = &iwl2030_lib,					\
 	.base_params = &iwl2030_base_params,			\
 	.bt_params = &iwl2030_bt_params,			\
-	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
 	.temp_offset_v2 = true,					\
 	.led_mode = IWL_LED_RF_STATE,				\
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c511c98..3a3f830 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -186,14 +186,7 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	iwl5000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
-	/* Set initial calibration set */
 	hw_params(priv).sens = &iwl5000_sensitivity;
-	hw_params(priv).calib_init_cfg =
-		BIT(IWL_CALIB_XTAL)		|
-		BIT(IWL_CALIB_LO)		|
-		BIT(IWL_CALIB_TX_IQ)		|
-		BIT(IWL_CALIB_TX_IQ_PERD)	|
-		BIT(IWL_CALIB_BASE_BAND);
 
 	return 0;
 }
@@ -222,14 +215,7 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 	iwl5150_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
-	/* Set initial calibration set */
 	hw_params(priv).sens = &iwl5150_sensitivity;
-	hw_params(priv).calib_init_cfg =
-		BIT(IWL_CALIB_LO)		|
-		BIT(IWL_CALIB_TX_IQ)		|
-		BIT(IWL_CALIB_BASE_BAND);
-	if (priv->cfg->need_dc_calib)
-		hw_params(priv).calib_init_cfg |= BIT(IWL_CALIB_DC);
 
 	return 0;
 }
@@ -433,7 +419,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,	\
 	.lib = &iwl5150_lib,					\
 	.base_params = &iwl5000_base_params,			\
-	.need_dc_calib = true,					\
+	.no_xtal_calib = true,					\
 	.led_mode = IWL_LED_BLINK,				\
 	.internal_wimax_coex = true
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index ee3363f..09f0378 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -164,17 +164,7 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 	iwl6000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
-	/* Set initial calibration set */
 	hw_params(priv).sens = &iwl6000_sensitivity;
-	hw_params(priv).calib_init_cfg =
-		BIT(IWL_CALIB_XTAL)		|
-		BIT(IWL_CALIB_LO)		|
-		BIT(IWL_CALIB_TX_IQ)		|
-		BIT(IWL_CALIB_BASE_BAND);
-	if (priv->cfg->need_dc_calib)
-		hw_params(priv).calib_rt_cfg |= IWL_CALIB_CFG_DC_IDX;
-	if (priv->cfg->need_temp_offset_calib)
-		hw_params(priv).calib_init_cfg |= BIT(IWL_CALIB_TEMP_OFFSET);
 
 	return 0;
 }
@@ -364,7 +354,6 @@ static struct iwl_bt_params iwl6000_bt_params = {
 	.eeprom_calib_ver = EEPROM_6005_TX_POWER_VERSION,	\
 	.lib = &iwl6000_lib,					\
 	.base_params = &iwl6000_g2_base_params,			\
-	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
 	.led_mode = IWL_LED_RF_STATE
 
@@ -406,7 +395,6 @@ struct iwl_cfg iwl6005_2agn_d_cfg = {
 	.lib = &iwl6030_lib,					\
 	.base_params = &iwl6000_g2_base_params,			\
 	.bt_params = &iwl6000_bt_params,			\
-	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.adv_pm = true						\
@@ -506,7 +494,6 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,	\
 	.base_params = &iwl6050_base_params,			\
-	.need_dc_calib = true,					\
 	.led_mode = IWL_LED_BLINK,				\
 	.internal_wimax_coex = true
 
@@ -530,7 +517,6 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.eeprom_ver = EEPROM_6150_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6150_TX_POWER_VERSION,	\
 	.base_params = &iwl6050_base_params,			\
-	.need_dc_calib = true,					\
 	.led_mode = IWL_LED_BLINK,				\
 	.internal_wimax_coex = true
 
@@ -555,7 +541,6 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.lib = &iwl6000_lib,
 	.base_params = &iwl6000_base_params,
 	.ht_params = &iwl6000_ht_params,
-	.need_dc_calib = true,
 	.led_mode = IWL_LED_BLINK,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 03bac48..c7bcafa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -84,30 +84,28 @@ struct statistics_general_data {
 
 int iwl_send_calib_results(struct iwl_priv *priv)
 {
-	int ret = 0;
-	int i = 0;
-
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_PHY_CALIBRATION_CMD,
 		.flags = CMD_SYNC,
 	};
+	int i = 0;
 
 	for (i = 0; i < IWL_CALIB_MAX; i++) {
-		if ((BIT(i) & hw_params(priv).calib_init_cfg) &&
-		    priv->calib_results[i].buf) {
-			hcmd.len[0] = priv->calib_results[i].buf_len;
-			hcmd.data[0] = priv->calib_results[i].buf;
-			hcmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
-			ret = iwl_trans_send_cmd(trans(priv), &hcmd);
-			if (ret) {
-				IWL_ERR(priv, "Error %d iteration %d\n",
-					ret, i);
-				break;
-			}
+		int ret;
+
+		if (!priv->calib_results[i].buf)
+			continue;
+		hcmd.len[0] = priv->calib_results[i].buf_len;
+		hcmd.data[0] = priv->calib_results[i].buf;
+		hcmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
+		ret = iwl_trans_send_cmd(trans(priv), &hcmd);
+		if (ret) {
+			IWL_ERR(priv, "Error %d iteration %d\n", ret, i);
+			return ret;
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 int iwl_calib_set(struct iwl_calib_result *res, const u8 *buf, int len)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 9ec315b..7043fdb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -477,9 +477,11 @@ static int iwlagn_alive_notify(struct iwl_priv *priv)
 	if (ret)
 		return ret;
 
-	ret = iwlagn_set_Xtal_calib(priv);
-	if (ret)
-		return ret;
+	if (!priv->cfg->no_xtal_calib) {
+		ret = iwlagn_set_Xtal_calib(priv);
+		if (ret)
+			return ret;
+	}
 
 	return iwl_send_calib_results(priv);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index fa47f75..f1d9d0c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -184,8 +184,9 @@ struct iwl_ht_params {
  * @ht_params: point to ht patameters
  * @bt_params: pointer to bt parameters
  * @pa_type: used by 6000 series only to identify the type of Power Amplifier
- * @need_dc_calib: need to perform init dc calibration
  * @need_temp_offset_calib: need to perform temperature offset calibration
+ * @no_xtal_calib: some devices do not need crystal calibration data,
+ *	don't send it to those
  * @scan_antennas: available antenna for scan operation
  * @led_mode: 0=blinking, 1=On(RF On)/Off(RF Off)
  * @adv_pm: advance power management
@@ -222,8 +223,8 @@ struct iwl_cfg {
 	struct iwl_ht_params *ht_params;
 	struct iwl_bt_params *bt_params;
 	enum iwl_pa_type pa_type;	  /* if used set to IWL_PA_SYSTEM */
-	const bool need_dc_calib;	  /* if used set to true */
 	const bool need_temp_offset_calib; /* if used set to true */
+	const bool no_xtal_calib;
 	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
 	enum iwl_led_mode led_mode;
 	const bool adv_pm;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 1f7a93c..47be77a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -174,7 +174,6 @@ struct iwl_mod_params {
  * @ct_kill_exit_threshold: when to reeable the device - in hw dependent unit
  *	relevant for 1000, 6000 and up
  * @wd_timeout: TX queues watchdog timeout
- * @calib_init_cfg: setup initial calibrations for the hw
  * @calib_rt_cfg: setup runtime calibrations for the hw
  * @struct iwl_sensitivity_ranges: range of sensitivity values
  */
@@ -195,7 +194,6 @@ struct iwl_hw_params {
 	u32 ct_kill_exit_threshold;
 	unsigned int wd_timeout;
 
-	u32 calib_init_cfg;
 	u32 calib_rt_cfg;
 	const struct iwl_sensitivity_ranges *sens;
 };
-- 
1.7.0.4

