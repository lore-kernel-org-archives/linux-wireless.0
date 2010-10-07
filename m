Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59929 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab0JGXIx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/22] iwlagn: add temperature offset calib for 6000g2
Date: Thu,  7 Oct 2010 16:08:01 -0700
Message-Id: <1286492881-15743-23-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

6000g2 devices need to have temperature offset calibration. The runtime
uCode needs to receive the calibration results just like BB and LO
calibration. To do this, driver reads the offset value from NVM and send
it to uCode after runtime uCode is alive.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c      |   11 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   27 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h  |   10 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    1 +
 5 files changed, 50 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a45929e..4810258 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -204,6 +204,8 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 		BIT(IWL_CALIB_BASE_BAND);
 	if (priv->cfg->need_dc_calib)
 		priv->hw_params.calib_rt_cfg |= BIT(IWL_CALIB_CFG_DC_IDX);
+	if (priv->cfg->need_temp_offset_calib)
+		priv->hw_params.calib_init_cfg |= BIT(IWL_CALIB_TEMP_OFFSET);
 
 	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
 
@@ -536,6 +538,7 @@ struct iwl_cfg iwl6000g2a_2agn_cfg = {
 	.base_params = &iwl6000_base_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
+	.need_temp_offset_calib = true,
 };
 
 struct iwl_cfg iwl6000g2a_2abg_cfg = {
@@ -552,6 +555,7 @@ struct iwl_cfg iwl6000g2a_2abg_cfg = {
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl6000_base_params,
 	.need_dc_calib = true,
+	.need_temp_offset_calib = true,
 };
 
 struct iwl_cfg iwl6000g2a_2bg_cfg = {
@@ -568,6 +572,7 @@ struct iwl_cfg iwl6000g2a_2bg_cfg = {
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl6000_base_params,
 	.need_dc_calib = true,
+	.need_temp_offset_calib = true,
 };
 
 struct iwl_cfg iwl6000g2b_2agn_cfg = {
@@ -586,6 +591,7 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.bt_params = &iwl6000_bt_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
+	.need_temp_offset_calib = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -605,6 +611,7 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.base_params = &iwl6000_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
+	.need_temp_offset_calib = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -625,6 +632,7 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.bt_params = &iwl6000_bt_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
+	.need_temp_offset_calib = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -644,6 +652,7 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.base_params = &iwl6000_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
+	.need_temp_offset_calib = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -664,6 +673,7 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.bt_params = &iwl6000_bt_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
+	.need_temp_offset_calib = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -683,6 +693,7 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.base_params = &iwl6000_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
+	.need_temp_offset_calib = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 3a95379..7036211 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -215,6 +215,25 @@ static int iwlagn_set_Xtal_calib(struct iwl_priv *priv)
 			     (u8 *)&cmd, sizeof(cmd));
 }
 
+static int iwlagn_set_temperature_offset_calib(struct iwl_priv *priv)
+{
+	struct iwl_calib_temperature_offset_cmd cmd;
+	__le16 *offset_calib =
+		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_TEMPERATURE);
+	cmd.hdr.op_code = IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD;
+	cmd.hdr.first_group = 0;
+	cmd.hdr.groups_num = 1;
+	cmd.hdr.data_valid = 1;
+	cmd.radio_sensor_offset = le16_to_cpu(offset_calib[1]);
+	if (!(cmd.radio_sensor_offset))
+		cmd.radio_sensor_offset = DEFAULT_RADIO_SENSOR_OFFSET;
+	cmd.reserved = 0;
+	IWL_DEBUG_CALIB(priv, "Radio sensor offset: %d\n",
+			cmd.radio_sensor_offset);
+	return iwl_calib_set(&priv->calib_results[IWL_CALIB_TEMP_OFFSET],
+			     (u8 *)&cmd, sizeof(cmd));
+}
+
 static int iwlagn_send_calib_cfg(struct iwl_priv *priv)
 {
 	struct iwl_calib_cfg_cmd calib_cfg_cmd;
@@ -321,6 +340,14 @@ void iwlagn_init_alive_start(struct iwl_priv *priv)
 
 	}
 	iwlagn_send_calib_cfg(priv);
+
+	/**
+	 * temperature offset calibration is only needed for runtime ucode,
+	 * so prepare the value now.
+	 */
+	if (priv->cfg->need_temp_offset_calib)
+		iwlagn_set_temperature_offset_calib(priv);
+
 	return;
 
 restart:
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 74b78d8..424801a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3794,7 +3794,8 @@ enum {
 	IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD	= 15,
 	IWL_PHY_CALIBRATE_BASE_BAND_CMD		= 16,
 	IWL_PHY_CALIBRATE_TX_IQ_PERD_CMD	= 17,
-	IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE	= 18,
+	IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD	= 18,
+	IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE	= 19,
 };
 
 #define IWL_MAX_PHY_CALIBRATE_TBL_SIZE		(253)
@@ -3864,6 +3865,13 @@ struct iwl_calib_xtal_freq_cmd {
 	u8 pad[2];
 } __packed;
 
+#define DEFAULT_RADIO_SENSOR_OFFSET    2700
+struct iwl_calib_temperature_offset_cmd {
+	struct iwl_calib_hdr hdr;
+	s16 radio_sensor_offset;
+	s16 reserved;
+} __packed;
+
 /* IWL_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD */
 struct iwl_calib_chain_noise_reset_cmd {
 	struct iwl_calib_hdr hdr;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a5e12b7..64527de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -342,6 +342,7 @@ struct iwl_ht_params {
  * @ucode_api_min: Lowest version of uCode API supported by driver.
  * @pa_type: used by 6000 series only to identify the type of Power Amplifier
  * @need_dc_calib: need to perform init dc calibration
+ * @need_temp_offset_calib: need to perform temperature offset calibration
  * @scan_antennas: available antenna for scan operation
  *
  * We enable the driver to be backward compatible wrt API version. The
@@ -386,6 +387,7 @@ struct iwl_cfg {
 	struct iwl_bt_params *bt_params;
 	enum iwl_pa_type pa_type;	  /* if used set to IWL_PA_SYSTEM */
 	const bool need_dc_calib;	  /* if used set to true */
+	const bool need_temp_offset_calib; /* if used set to true */
 	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
 	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2c57dbd..de43e13 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -835,6 +835,7 @@ enum iwl_calib {
 	IWL_CALIB_TX_IQ,
 	IWL_CALIB_TX_IQ_PERD,
 	IWL_CALIB_BASE_BAND,
+	IWL_CALIB_TEMP_OFFSET,
 	IWL_CALIB_MAX
 };
 
-- 
1.7.0.4

