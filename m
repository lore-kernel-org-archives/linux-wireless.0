Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4763 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbYJNTfU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 15:35:20 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/9] iwlwifi: unify tx antenna toggling
Date: Tue, 14 Oct 2008 12:32:45 -0700
Message-Id: <1224012769-8920-6-git-send-email-reinette.chatre@intel.com> (sfid-20081014_213527_803798_76115B81)
In-Reply-To: <1224012769-8920-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1224012769-8920-1-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-2-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-3-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-4-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

TX antenna toggling is requested for management frames in tx and
scanning. I addition toggling in scanning was incorrect;

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   14 ++++---
 drivers/net/wireless/iwlwifi/iwl-core.c     |   13 +++++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    9 ++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   57 ++++++++-------------------
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   14 ++-----
 6 files changed, 51 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index ba54613..67680a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -283,18 +283,20 @@ struct iwl_cmd_header {
 #define RATE_MCS_SGI_MSK 0x2000
 
 /**
- * rate_n_flags Tx antenna masks (4965 has 2 transmitters):
- * bit14:15 01 B inactive, A active
- *          10 B active, A inactive
- *          11 Both active
+ * rate_n_flags Tx antenna masks
+ * 4965 has 2 transmitters
+ * 5100 has 1 transmitter B
+ * 5150 has 1 transmitter A
+ * 5300 has 3 transmitters
+ * 5350 has 3 transmitters
+ * bit14:16
  */
 #define RATE_MCS_ANT_POS      14
 #define RATE_MCS_ANT_A_MSK    0x04000
 #define RATE_MCS_ANT_B_MSK    0x08000
 #define RATE_MCS_ANT_C_MSK    0x10000
 #define RATE_MCS_ANT_ABC_MSK  0x1C000
-
-#define RATE_MCS_ANT_INIT_IND   1
+#define RATE_ANT_NUM 3
 
 #define POWER_TABLE_NUM_ENTRIES			33
 #define POWER_TABLE_NUM_HT_OFDM_ENTRIES		32
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1082448..62c3936 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -140,7 +140,17 @@ int iwl_hwrate_to_plcp_idx(u32 rate_n_flags)
 }
 EXPORT_SYMBOL(iwl_hwrate_to_plcp_idx);
 
-
+u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant)
+{
+	int i;
+	u8 ind = ant;
+	for (i = 0; i < RATE_ANT_NUM - 1; i++) {
+		ind = (ind + 1) < RATE_ANT_NUM ?  ind + 1 : 0;
+		if (priv->hw_params.valid_tx_ant & BIT(ind))
+			return ind;
+	}
+	return ant;
+}
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 EXPORT_SYMBOL(iwl_bcast_addr);
@@ -946,7 +956,6 @@ int iwl_init_drv(struct iwl_priv *priv)
 
 	priv->iw_mode = NL80211_IFTYPE_STATION;
 
-	priv->use_ant_b_for_management_frame = 1; /* start with ant B */
 	priv->current_ht_config.sm_ps = WLAN_HT_CAP_SM_PS_DISABLED;
 
 	/* Choose which receivers/antennas to use */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 1a3ad8b..a2d8afe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -237,7 +237,6 @@ int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn);
 int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid);
 int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id);
-
 /*****************************************************
  * TX power
  ****************************************************/
@@ -259,6 +258,13 @@ void iwl_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 			      struct ieee80211_tx_info *info);
 int iwl_hwrate_to_plcp_idx(u32 rate_n_flags);
 
+u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx);
+
+static inline u32 iwl_ant_idx_to_flags(u8 ant_idx)
+{
+	return BIT(ant_idx) << RATE_MCS_ANT_POS;
+}
+
 static inline u8 iwl_hw_get_rate(__le32 rate_n_flags)
 {
 	return le32_to_cpu(rate_n_flags) & 0xFF;
@@ -313,6 +319,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 void iwl_dump_nic_error_log(struct iwl_priv *priv);
 void iwl_dump_nic_event_log(struct iwl_priv *priv);
 
+
 /*************** DRIVER STATUS FUNCTIONS   *****/
 
 #define STATUS_HCMD_ACTIVE	0	/* host command in progress */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9c93f9b..bdca174 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -811,12 +811,13 @@ struct iwl_priv {
 	unsigned long scan_start;
 	unsigned long scan_pass_start;
 	unsigned long scan_start_tsf;
+	struct iwl_scan_cmd *scan;
 	int scan_bands;
 	int one_direct_scan;
 	u8 direct_ssid_len;
 	u8 direct_ssid[IW_ESSID_MAX_SIZE];
-	struct iwl_scan_cmd *scan;
-	u32 scan_tx_ant[IEEE80211_NUM_BANDS];
+	u8 scan_tx_ant[IEEE80211_NUM_BANDS];
+	u8 mgmt_tx_ant;
 
 	/* spinlock */
 	spinlock_t lock;	/* protect general shared data */
@@ -875,7 +876,6 @@ struct iwl_priv {
 	u16 active_rate_basic;
 
 	u8 assoc_station_added;
-	u8 use_ant_b_for_management_frame;	/* Tx antenna selection */
 	u8 start_calib;
 	struct iwl_sensitivity_data sensitivity_data;
 	struct iwl_chain_noise_data chain_noise_data;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 78d16bd..86b7457 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -64,12 +64,6 @@
 #define IWL_SCAN_PROBE_MASK(n) 	cpu_to_le32((BIT(n) | (BIT(n) - BIT(1))))
 
 
-static int scan_tx_ant[3] = {
-	RATE_MCS_ANT_A_MSK, RATE_MCS_ANT_B_MSK, RATE_MCS_ANT_C_MSK
-};
-
-
-
 static int iwl_is_empty_essid(const char *essid, int essid_len)
 {
 	/* Single white space is for Linksys APs */
@@ -455,10 +449,11 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 
 void iwl_init_scan_params(struct iwl_priv *priv)
 {
+	u8 ant_idx = fls(priv->hw_params.valid_tx_ant) - 1;
 	if (!priv->scan_tx_ant[IEEE80211_BAND_5GHZ])
-		priv->scan_tx_ant[IEEE80211_BAND_5GHZ] = RATE_MCS_ANT_INIT_IND;
+		priv->scan_tx_ant[IEEE80211_BAND_5GHZ] = ant_idx;
 	if (!priv->scan_tx_ant[IEEE80211_BAND_2GHZ])
-		priv->scan_tx_ant[IEEE80211_BAND_2GHZ] = RATE_MCS_ANT_INIT_IND;
+		priv->scan_tx_ant[IEEE80211_BAND_2GHZ] = ant_idx;
 }
 
 int iwl_scan_initiate(struct iwl_priv *priv)
@@ -670,23 +665,6 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 	return (u16)len;
 }
 
-static u32 iwl_scan_tx_ant(struct iwl_priv *priv, enum ieee80211_band band)
-{
-	int i, ind;
-
-	ind = priv->scan_tx_ant[band];
-	for (i = 0; i < priv->hw_params.tx_chains_num; i++) {
-		ind = (ind+1) >= priv->hw_params.tx_chains_num ? 0 : ind+1;
-		if (priv->hw_params.valid_tx_ant & (1 << ind)) {
-			priv->scan_tx_ant[band] = ind;
-			break;
-		}
-	}
-	IWL_DEBUG_SCAN("select TX ANT = %c\n", 'A' + ind);
-	return scan_tx_ant[ind];
-}
-
-
 static void iwl_bg_request_scan(struct work_struct *data)
 {
 	struct iwl_priv *priv =
@@ -699,11 +677,12 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	struct iwl_scan_cmd *scan;
 	struct ieee80211_conf *conf = NULL;
 	int ret = 0;
-	u32 tx_ant;
+	u32 rate_flags = 0;
 	u16 cmd_len;
 	enum ieee80211_band band;
 	u8 n_probes = 2;
 	u8 rx_chain = priv->hw_params.valid_rx_ant;
+	u8 rate;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -822,23 +801,16 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	if (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ)) {
 		band = IEEE80211_BAND_2GHZ;
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
-		tx_ant = iwl_scan_tx_ant(priv, band);
-		if (priv->active_rxon.flags & RXON_FLG_CHANNEL_MODE_PURE_40_MSK)
-			scan->tx_cmd.rate_n_flags =
-				iwl_hw_set_rate_n_flags(IWL_RATE_6M_PLCP,
-							tx_ant);
-		else
-			scan->tx_cmd.rate_n_flags =
-				iwl_hw_set_rate_n_flags(IWL_RATE_1M_PLCP,
-							tx_ant |
-							RATE_MCS_CCK_MSK);
+		if (priv->active_rxon.flags & RXON_FLG_CHANNEL_MODE_PURE_40_MSK) {
+			rate = IWL_RATE_6M_PLCP;
+		} else {
+			rate = IWL_RATE_1M_PLCP;
+			rate_flags = RATE_MCS_CCK_MSK;
+		}
 		scan->good_CRC_th = 0;
 	} else if (priv->scan_bands & BIT(IEEE80211_BAND_5GHZ)) {
 		band = IEEE80211_BAND_5GHZ;
-		tx_ant = iwl_scan_tx_ant(priv, band);
-		scan->tx_cmd.rate_n_flags =
-				iwl_hw_set_rate_n_flags(IWL_RATE_6M_PLCP,
-							tx_ant);
+		rate = IWL_RATE_6M_PLCP;
 		scan->good_CRC_th = IWL_GOOD_CRC_TH;
 
 		/* Force use of chains B and C (0x6) for scan Rx for 4965
@@ -851,6 +823,11 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		goto done;
 	}
 
+	priv->scan_tx_ant[band] =
+			 iwl_toggle_tx_ant(priv, priv->scan_tx_ant[band]);
+	rate_flags |= iwl_ant_idx_to_flags(priv->scan_tx_ant[band]);
+	scan->tx_cmd.rate_n_flags = iwl_hw_set_rate_n_flags(rate, rate_flags);
+
 	/* MIMO is not used here, but value is required */
 	scan->rx_chain = RXON_RX_CHAIN_DRIVER_FORCE_MSK |
 				cpu_to_le16((0x7 << RXON_RX_CHAIN_VALID_POS) |
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 77e5e65..9ee2897 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -674,11 +674,11 @@ static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
 			      __le16 fc, int sta_id,
 			      int is_hcca)
 {
+	u32 rate_flags = 0;
+	int rate_idx;
 	u8 rts_retry_limit = 0;
 	u8 data_retry_limit = 0;
 	u8 rate_plcp;
-	u16 rate_flags = 0;
-	int rate_idx;
 
 	rate_idx = min(ieee80211_get_tx_rate(priv->hw, info)->hw_value & 0xffff,
 			IWL_RATE_COUNT - 1);
@@ -721,14 +721,8 @@ static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
 			break;
 		}
 
-		/* Alternate between antenna A and B for successive frames */
-		if (priv->use_ant_b_for_management_frame) {
-			priv->use_ant_b_for_management_frame = 0;
-			rate_flags |= RATE_MCS_ANT_B_MSK;
-		} else {
-			priv->use_ant_b_for_management_frame = 1;
-			rate_flags |= RATE_MCS_ANT_A_MSK;
-		}
+		priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant);
+		rate_flags |= iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
 	}
 
 	tx_cmd->rts_retry_limit = rts_retry_limit;
-- 
1.5.4.3

