Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27344 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab0HWOx2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/26] iwlagn: implement advance BT config command
Date: Mon, 23 Aug 2010 07:56:55 -0700
Message-Id: <1282575437-23270-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

6000g2b hardware implements advance bluetooth coexist command,
implement base on the new API command strucutre.

Also increment the API 5 to support the advance BT/WIfi coex.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c     |  140 +++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-commands.h |   62 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    5 +
 4 files changed, 203 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 9e390f6..fc2eeb0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -52,7 +52,7 @@
 /* Highest firmware API version supported */
 #define IWL6000_UCODE_API_MAX 4
 #define IWL6050_UCODE_API_MAX 4
-#define IWL6000G2_UCODE_API_MAX 4
+#define IWL6000G2_UCODE_API_MAX 5
 
 /* Lowest firmware API version supported */
 #define IWL6000_UCODE_API_MIN 4
@@ -122,6 +122,120 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 		priv->cfg->ops->lib->temp_ops.set_calib_version(priv);
 }
 
+/*
+ * Macros to access the lookup table.
+ *
+ * The lookup table has 7 inputs: bt3_prio, bt3_txrx, bt_rf_act, wifi_req,
+ * wifi_prio, wifi_txrx and wifi_sh_ant_req.
+ *
+ * It has three outputs: WLAN_ACTIVE, WLAN_KILL and ANT_SWITCH
+ *
+ * The format is that "registers" 8 through 11 contain the WLAN_ACTIVE bits
+ * one after another in 32-bit registers, and "registers" 0 through 7 contain
+ * the WLAN_KILL and ANT_SWITCH bits interleaved (in that order).
+ *
+ * These macros encode that format.
+ */
+#define LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, wifi_req, wifi_prio, \
+	wifi_txrx, wifi_sh_ant_req) \
+	(bt3_prio | (bt3_txrx << 1) | (bt_rf_act << 2) | (wifi_req << 3) | \
+	(wifi_prio << 4) | (wifi_txrx << 5) | (wifi_sh_ant_req << 6))
+
+#define LUT_PTA_WLAN_ACTIVE_OP(lut, op, val) \
+	lut[8 + ((val) >> 5)] op (cpu_to_le32(BIT((val) & 0x1f)))
+#define LUT_TEST_PTA_WLAN_ACTIVE(lut, bt3_prio, bt3_txrx, bt_rf_act, \
+	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	(!!(LUT_PTA_WLAN_ACTIVE_OP(lut, &, LUT_VALUE(bt3_prio, bt3_txrx,\
+	bt_rf_act, wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))))
+#define LUT_SET_PTA_WLAN_ACTIVE(lut, bt3_prio, bt3_txrx, bt_rf_act, \
+	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	LUT_PTA_WLAN_ACTIVE_OP(lut, |=, LUT_VALUE(bt3_prio, bt3_txrx, \
+	bt_rf_act, wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
+#define LUT_CLEAR_PTA_WLAN_ACTIVE(lut, bt3_prio, bt3_txrx, bt_rf_act, \
+	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	LUT_PTA_WLAN_ACTIVE_OP(lut, &= ~, LUT_VALUE(bt3_prio, bt3_txrx, \
+	bt_rf_act, wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
+
+#define LUT_WLAN_KILL_OP(lut, op, val) \
+	lut[(val) >> 4] op (cpu_to_le32(BIT(((val) << 1) & 0x1e)))
+#define LUT_TEST_WLAN_KILL(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
+	wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	(!!(LUT_WLAN_KILL_OP(lut, &, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
+	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))))
+#define LUT_SET_WLAN_KILL(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
+	wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	LUT_WLAN_KILL_OP(lut, |=, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
+	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
+#define LUT_CLEAR_WLAN_KILL(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
+	wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	LUT_WLAN_KILL_OP(lut, &= ~, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
+	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
+
+#define LUT_ANT_SWITCH_OP(lut, op, val) \
+	lut[(val) >> 4] op (cpu_to_le32(BIT((((val) << 1) & 0x1e) + 1)))
+#define LUT_TEST_ANT_SWITCH(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
+	wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	(!!(LUT_ANT_SWITCH_OP(lut, &, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
+	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))))
+#define LUT_SET_ANT_SWITCH(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
+	wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	LUT_ANT_SWITCH_OP(lut, |=, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
+	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
+#define LUT_CLEAR_ANT_SWITCH(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
+	wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	LUT_ANT_SWITCH_OP(lut, &= ~, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
+	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
+
+static const __le32 iwl6000g2b_def_3w_lookup[12] = {
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaeaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xcc00ff28),
+	cpu_to_le32(0x0000aaaa),
+	cpu_to_le32(0xcc00aaaa),
+	cpu_to_le32(0x0000aaaa),
+	cpu_to_le32(0xc0004000),
+	cpu_to_le32(0x00004000),
+	cpu_to_le32(0xf0005000),
+	cpu_to_le32(0xf0004000),
+};
+
+static void iwl6000g2b_send_bt_config(struct iwl_priv *priv)
+{
+	struct iwl6000g2b_bt_cmd bt_cmd = {
+		.prio_boost = IWL6000G2B_BT_PRIO_BOOST_DEFAULT,
+		.max_kill = IWL6000G2B_BT_MAX_KILL_DEFAULT,
+		.bt3_timer_t7_value = IWL6000G2B_BT3_T7_DEFAULT,
+		.kill_ack_mask = IWL6000G2B_BT_KILL_ACK_MASK_DEFAULT,
+		.kill_cts_mask = IWL6000G2B_BT_KILL_CTS_MASK_DEFAULT,
+		.bt3_prio_sample_time = IWL6000G2B_BT3_PRIO_SAMPLE_DEFAULT,
+		.bt3_timer_t2_value = IWL6000G2B_BT3_T2_DEFAULT,
+		.valid = IWL6000G2B_BT_VALID_ENABLE_FLAGS,
+	};
+
+	BUILD_BUG_ON(sizeof(iwl6000g2b_def_3w_lookup) !=
+			sizeof(bt_cmd.bt3_lookup_table));
+
+	if (!bt_coex_active) {
+		bt_cmd.flags = 0;
+	} else {
+		bt_cmd.flags = IWL6000G2B_BT_FLAG_CHANNEL_INHIBITION |
+				IWL6000G2B_BT_FLAG_COEX_MODE_3W <<
+					IWL6000G2B_BT_FLAG_COEX_MODE_SHIFT;
+		bt_cmd.valid |= IWL6000G2B_BT_ALL_VALID_MSK;
+	}
+
+	memcpy(bt_cmd.bt3_lookup_table, iwl6000g2b_def_3w_lookup,
+		sizeof(iwl6000g2b_def_3w_lookup));
+
+	IWL_DEBUG_INFO(priv, "BT coex %s\n",
+		       bt_cmd.flags ? "active" : "disabled");
+
+	if (iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG, sizeof(bt_cmd), &bt_cmd))
+		IWL_ERR(priv, "failed to send BT Coex Config\n");
+}
+
 static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
 	.min_nrg_cck = 97,
 	.max_nrg_cck = 0, /* not used, set to 0 */
@@ -344,16 +458,12 @@ static const struct iwl_ops iwl6000_ops = {
 	.led = &iwlagn_led_ops,
 };
 
-static void do_not_send_bt_config(struct iwl_priv *priv)
-{
-}
-
 static struct iwl_hcmd_ops iwl6000g2b_hcmd = {
 	.rxon_assoc = iwlagn_send_rxon_assoc,
 	.commit_rxon = iwl_commit_rxon,
 	.set_rxon_chain = iwl_set_rxon_chain,
 	.set_tx_ant = iwlagn_send_tx_ant_config,
-	.send_bt_config = do_not_send_bt_config,
+	.send_bt_config = iwl6000g2b_send_bt_config,
 };
 
 static const struct iwl_ops iwl6000g2b_ops = {
@@ -507,6 +617,9 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
 	.bt_statistics = true,
+	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
+	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	.advanced_bt_coexist = true,
 };
 
 struct iwl_cfg iwl6000g2b_2abg_cfg = {
@@ -543,6 +656,9 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
 	.bt_statistics = true,
+	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
+	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	.advanced_bt_coexist = true,
 };
 
 struct iwl_cfg iwl6000g2b_2bgn_cfg = {
@@ -581,6 +697,9 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
 	.bt_statistics = true,
+	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
+	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	.advanced_bt_coexist = true,
 };
 
 struct iwl_cfg iwl6000g2b_2bg_cfg = {
@@ -617,6 +736,9 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
 	.bt_statistics = true,
+	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
+	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	.advanced_bt_coexist = true,
 };
 
 struct iwl_cfg iwl6000g2b_bgn_cfg = {
@@ -655,6 +777,9 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
 	.bt_statistics = true,
+	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
+	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	.advanced_bt_coexist = true,
 };
 
 struct iwl_cfg iwl6000g2b_bg_cfg = {
@@ -691,6 +816,9 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
 	.bt_statistics = true,
+	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
+	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	.advanced_bt_coexist = true,
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 78086ad..69fc774 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2394,6 +2394,68 @@ struct iwl_bt_cmd {
 	__le32 kill_cts_mask;
 } __packed;
 
+#define IWL6000G2B_BT_FLAG_CHANNEL_INHIBITION	BIT(0)
+
+#define IWL6000G2B_BT_FLAG_COEX_MODE_MASK	(BIT(3)|BIT(4)|BIT(5))
+#define IWL6000G2B_BT_FLAG_COEX_MODE_SHIFT	3
+#define IWL6000G2B_BT_FLAG_COEX_MODE_DISABLED	0
+#define IWL6000G2B_BT_FLAG_COEX_MODE_LEGACY_2W	1
+#define IWL6000G2B_BT_FLAG_COEX_MODE_3W		2
+#define IWL6000G2B_BT_FLAG_COEX_MODE_4W		3
+
+#define IWL6000G2B_BT_FLAG_UCODE_DEFAULT	BIT(6)
+#define IWL6000G2B_BT_FLAG_NOCOEX_NOTIF		BIT(7)
+
+#define IWL6000G2B_BT_PRIO_BOOST_MAX		0xFF
+#define IWL6000G2B_BT_PRIO_BOOST_MIN		0x00
+#define IWL6000G2B_BT_PRIO_BOOST_DEFAULT	0x00
+
+#define IWL6000G2B_BT_MAX_KILL_DEFAULT		5
+
+#define IWL6000G2B_BT3_T7_DEFAULT		1
+
+#define IWL6000G2B_BT_KILL_ACK_MASK_DEFAULT	cpu_to_le32(0xffffffff)
+#define IWL6000G2B_BT_KILL_CTS_MASK_DEFAULT	cpu_to_le32(0xffffffff)
+
+#define IWL6000G2B_BT3_PRIO_SAMPLE_DEFAULT	2
+
+#define IWL6000G2B_BT3_T2_DEFAULT		0xc
+
+#define IWL6000G2B_BT_VALID_ENABLE_FLAGS	cpu_to_le16(BIT(0))
+#define IWL6000G2B_BT_VALID_BOOST		cpu_to_le16(BIT(1))
+#define IWL6000G2B_BT_VALID_MAX_KILL		cpu_to_le16(BIT(2))
+#define IWL6000G2B_BT_VALID_3W_TIMERS		cpu_to_le16(BIT(3))
+#define IWL6000G2B_BT_VALID_KILL_ACK_MASK	cpu_to_le16(BIT(4))
+#define IWL6000G2B_BT_VALID_KILL_CTS_MASK	cpu_to_le16(BIT(5))
+#define IWL6000G2B_BT_VALID_BT4_TIMES		cpu_to_le16(BIT(6))
+#define IWL6000G2B_BT_VALID_3W_LUT		cpu_to_le16(BIT(7))
+
+#define IWL6000G2B_BT_ALL_VALID_MSK	(IWL6000G2B_BT_VALID_ENABLE_FLAGS | \
+					IWL6000G2B_BT_VALID_BOOST | \
+					IWL6000G2B_BT_VALID_MAX_KILL | \
+					IWL6000G2B_BT_VALID_3W_TIMERS | \
+					IWL6000G2B_BT_VALID_KILL_ACK_MASK | \
+					IWL6000G2B_BT_VALID_KILL_CTS_MASK | \
+					IWL6000G2B_BT_VALID_BT4_TIMES | \
+					IWL6000G2B_BT_VALID_3W_LUT)
+
+struct iwl6000g2b_bt_cmd {
+	u8 flags;
+	u8 ledtime; /* unused */
+	u8 max_kill;
+	u8 bt3_timer_t7_value;
+	__le32 kill_ack_mask;
+	__le32 kill_cts_mask;
+	u8 bt3_prio_sample_time;
+	u8 bt3_timer_t2_value;
+	__le16 bt4_reaction_time; /* unused */
+	__le32 bt3_lookup_table[12];
+	__le16 bt4_decision_time; /* unused */
+	__le16 valid;
+	u8 prio_boost;
+	u8 reserved[3];
+};
+
 /******************************************************************************
  * (6)
  * Spectrum Management (802.11h) Commands, Responses, Notifications:
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 3d9443b..4beddad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -64,7 +64,8 @@ MODULE_LICENSE("GPL");
  *
  * default: bt_coex_active = true (BT_COEX_ENABLE)
  */
-static bool bt_coex_active = true;
+bool bt_coex_active = true;
+EXPORT_SYMBOL_GPL(bt_coex_active);
 module_param(bt_coex_active, bool, S_IRUGO);
 MODULE_PARM_DESC(bt_coex_active, "enable wifi/bluetooth co-exist");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7b1e832..d773379 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -278,6 +278,7 @@ struct iwl_mod_params {
  * @chain_noise_calib_by_driver: driver has the capability to perform
  *	chain noise calibration operation
  * @scan_antennas: available antenna for scan operation
+ * @advanced_bt_coexist: support advanced bt coexist
  * @need_dc_calib: need to perform init dc calibration
  * @bt_statistics: use BT version of statistics notification
  * @agg_time_limit: maximum number of uSec in aggregation
@@ -351,6 +352,7 @@ struct iwl_cfg {
 	const bool chain_noise_calib_by_driver;
 	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
 	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
+	bool advanced_bt_coexist;
 	const bool need_dc_calib;
 	const bool bt_statistics;
 	u16 agg_time_limit;
@@ -732,4 +734,7 @@ static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
 {
 	return priv->hw->wiphy->bands[band];
 }
+
+extern bool bt_coex_active;
+
 #endif /* __iwl_core_h__ */
-- 
1.7.0.4

