Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59302 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbYDUWmM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 18:42:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 03/11] iwlwifi: expanding HW parameters control
Date: Mon, 21 Apr 2008 15:41:53 -0700
Message-Id: <1208817721-11333-4-git-send-email-reinette.chatre@intel.com> (sfid-20080422_004302_158452_ACF985E2)
In-Reply-To: <1208817721-11333-3-git-send-email-reinette.chatre@intel.com>
References: <1208817721-11333-1-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-2-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch adds several parameters to priv.hw_params, for better control
over HW capabilities variants

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   15 ++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-4965.h     |   25 +++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   14 +++++++-------
 4 files changed, 42 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 855a006..0c132b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -134,10 +134,8 @@
 #define RTC_DATA_LOWER_BOUND			(0x800000)
 #define IWL49_RTC_DATA_UPPER_BOUND		(0x80A000)
 
-#define IWL49_RTC_INST_SIZE	\
-			(IWL49_RTC_INST_UPPER_BOUND - RTC_INST_LOWER_BOUND)
-#define IWL49_RTC_DATA_SIZE	\
-			(IWL49_RTC_DATA_UPPER_BOUND - RTC_DATA_LOWER_BOUND)
+#define IWL49_RTC_INST_SIZE  (IWL49_RTC_INST_UPPER_BOUND - RTC_INST_LOWER_BOUND)
+#define IWL49_RTC_DATA_SIZE  (IWL49_RTC_DATA_UPPER_BOUND - RTC_DATA_LOWER_BOUND)
 
 #define IWL_MAX_INST_SIZE IWL49_RTC_INST_SIZE
 #define IWL_MAX_DATA_SIZE IWL49_RTC_DATA_SIZE
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 7886596..9b3a745 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -999,7 +999,8 @@ void iwl4965_rf_kill_ct_config(struct iwl_priv *priv)
 	temp_th = CELSIUS_TO_KELVIN(TM_CT_KILL_THRESHOLD);
 
 	crit_temperature = ((temp_th * (R3-R1))/CT_LIMIT_CONST) + R2;
-	cmd.critical_temperature_R =  cpu_to_le32(crit_temperature);
+	cmd.critical_temperature_R =
+			cpu_to_le32(priv->hw_params.ct_kill_threshold);
 	ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
 			       sizeof(cmd), &cmd);
 	if (ret)
@@ -1340,6 +1341,7 @@ int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	}
 
 	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
+	priv->hw_params.sw_crypto = priv->cfg->mod_params->sw_crypto;
 	priv->hw_params.tx_cmd_len = sizeof(struct iwl4965_tx_cmd);
 	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
@@ -1351,10 +1353,17 @@ int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_stations = IWL4965_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL4965_BROADCAST_ID;
 
+	priv->hw_params.max_data_size = IWL49_RTC_DATA_SIZE;
+	priv->hw_params.max_inst_size = IWL49_RTC_INST_SIZE;
+	priv->hw_params.max_bsm_size = BSM_SRAM_SIZE;
+	priv->hw_params.fat_channel = BIT(IEEE80211_BAND_5GHZ);
+
 	priv->hw_params.tx_chains_num = 2;
 	priv->hw_params.rx_chains_num = 2;
 	priv->hw_params.valid_tx_ant = (IWL_ANTENNA_MAIN | IWL_ANTENNA_AUX);
 	priv->hw_params.valid_rx_ant = (IWL_ANTENNA_MAIN | IWL_ANTENNA_AUX);
+	priv->hw_params.ct_kill_threshold = CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD);
+
 #ifdef CONFIG_IWL4965_RUN_TIME_CALIB
 	priv->hw_params.sens = &iwl4965_sensitivity;
 #endif
@@ -3064,7 +3073,7 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	hdr = (struct ieee80211_hdr *)rxb->skb->data;
 
 	/*  in case of HW accelerated crypto and bad decryption, drop */
-	if (!priv->cfg->mod_params->sw_crypto &&
+	if (!priv->hw_params.sw_crypto &&
 	    iwl4965_set_decrypted_flag(priv, hdr, ampdu_status, stats))
 		return;
 
@@ -3122,7 +3131,7 @@ void iwl4965_init_ht_hw_capab(struct iwl_priv *priv,
 
 	ht_info->ht_supported = 1;
 
-	if (band == IEEE80211_BAND_5GHZ) {
+	if (priv->hw_params.fat_channel & BIT(band)) {
 		ht_info->cap |= (u16)IEEE80211_HT_CAP_SUP_WIDTH;
 		ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_40;
 		ht_info->supp_mcs_set[4] = 0x01;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 754ed37..86de144 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -55,6 +55,8 @@ extern struct iwl_cfg iwl4965_agn_cfg;
  * This number will also appear in << 8 position of 1st dword of uCode file */
 #define IWL4965_UCODE_API "-1"
 
+/* CT-KILL constants */
+#define CT_KILL_THRESHOLD	110 /* in Celsius */
 
 /* Default noise level to report when noise measurement is not available.
  *   This may be because we're:
@@ -570,16 +572,25 @@ struct iwl_sensitivity_ranges {
 	u16 auto_corr_min_cck_mrc;
 };
 
+
+#define IWL_FAT_CHANNEL_52 BIT(IEEE80211_BAND_5GHZ)
+
 /**
  * struct iwl_hw_params
  * @max_txq_num: Max # Tx queues supported
  * @tx_cmd_len: Size of Tx command (but not including frame itself)
- * @tx_ant_num: Number of TX antennas
+ * @tx/rx_chains_num: Number of TX/RX chains
+ * @valid_tx/rx_ant: usable antennas
  * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
- * @rx_buffer_size:
  * @max_rxq_log: Log-base-2 of max_rxq_size
+ * @rx_buf_size: Rx buffer size
  * @max_stations:
  * @bcast_sta_id:
+ * @fat_channel: is 40MHz width possible in band 2.4
+ * BIT(IEEE80211_BAND_5GHZ) BIT(IEEE80211_BAND_5GHZ)
+ * @sw_crypto: 0 for hw, 1 for sw
+ * @max_xxx_size: for ucode uses
+ * @ct_kill_threshold: temperature threshold
  * @struct iwl_sensitivity_ranges: range of sensitivity values
  */
 struct iwl_hw_params {
@@ -595,13 +606,19 @@ struct iwl_hw_params {
 	u32 max_pkt_size;
 	u8  max_stations;
 	u8  bcast_sta_id;
+	u8 fat_channel;
+	u8 sw_crypto;
+	u32 max_inst_size;
+	u32 max_data_size;
+	u32 max_bsm_size;
+	u32 ct_kill_threshold; /* value in hw-dependent units */
 #ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 	const struct iwl_sensitivity_ranges *sens;
 #endif
 };
 
-#define HT_SHORT_GI_20MHZ_ONLY          (1 << 0)
-#define HT_SHORT_GI_40MHZ_ONLY          (1 << 1)
+#define HT_SHORT_GI_20MHZ_ONLY	(1 << 0)
+#define HT_SHORT_GI_40MHZ_ONLY	(1 << 1)
 
 
 #define IWL_RX_HDR(x) ((struct iwl4965_rx_frame_hdr *)(\
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 17b1858..2e706be 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -828,7 +828,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		       le16_to_cpu(priv->staging_rxon.channel),
 		       print_mac(mac, priv->staging_rxon.bssid_addr));
 
-	iwl4965_set_rxon_hwcrypto(priv, !priv->cfg->mod_params->sw_crypto);
+	iwl4965_set_rxon_hwcrypto(priv, !priv->hw_params.sw_crypto);
 	/* Apply the new configuration */
 	rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
 			      sizeof(struct iwl4965_rxon_cmd), &priv->staging_rxon);
@@ -4866,34 +4866,34 @@ static int iwl4965_read_ucode(struct iwl_priv *priv)
 	}
 
 	/* Verify that uCode images will fit in card's SRAM */
-	if (inst_size > IWL_MAX_INST_SIZE) {
+	if (inst_size > priv->hw_params.max_inst_size) {
 		IWL_DEBUG_INFO("uCode instr len %d too large to fit in\n",
 			       inst_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 
-	if (data_size > IWL_MAX_DATA_SIZE) {
+	if (data_size > priv->hw_params.max_data_size) {
 		IWL_DEBUG_INFO("uCode data len %d too large to fit in\n",
 				data_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
-	if (init_size > IWL_MAX_INST_SIZE) {
+	if (init_size > priv->hw_params.max_inst_size) {
 		IWL_DEBUG_INFO
 		    ("uCode init instr len %d too large to fit in\n",
 		      init_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
-	if (init_data_size > IWL_MAX_DATA_SIZE) {
+	if (init_data_size > priv->hw_params.max_data_size) {
 		IWL_DEBUG_INFO
 		    ("uCode init data len %d too large to fit in\n",
 		      init_data_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
-	if (boot_size > IWL_MAX_BSM_SIZE) {
+	if (boot_size > priv->hw_params.max_bsm_size) {
 		IWL_DEBUG_INFO
 		    ("uCode boot instr len %d too large to fit in\n",
 		      boot_size);
@@ -6618,7 +6618,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (priv->cfg->mod_params->sw_crypto) {
+	if (priv->hw_params.sw_crypto) {
 		IWL_DEBUG_MAC80211("leave - hwcrypto disabled\n");
 		return -EOPNOTSUPP;
 	}
-- 
1.5.3.4

