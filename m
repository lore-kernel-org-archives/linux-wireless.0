Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52687 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbaL3OTr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:47 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Moshe Harel <moshe.harel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/33] iwlwifi: mvm: support LnP 1x1 antenna configuration
Date: Tue, 30 Dec 2014 16:18:39 +0200
Message-Id: <1419949148-24046-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_151952_771905_9A10BFDC)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Moshe Harel <moshe.harel@intel.com>

The antenna configuration has to be read also from OTP
Currently read only from FW image
Guideline: An antenna exists only if appears both in FW image & NVM

Signed-off-by: Moshe Harel <moshe.harel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |  6 ++++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c   |  2 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c        |  8 ++++----
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c  |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h       | 27 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c       | 15 ++++++++-------
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c  |  2 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c        | 22 +++++++++++-----------
 drivers/net/wireless/iwlwifi/mvm/scan.c      |  6 +++---
 drivers/net/wireless/iwlwifi/mvm/tx.c        |  2 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c     |  4 ++--
 11 files changed, 65 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 06e02fc..c74f1a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -468,6 +468,8 @@ static void iwl_set_radio_cfg(const struct iwl_cfg *cfg,
 	data->radio_cfg_step = NVM_RF_CFG_STEP_MSK_FAMILY_8000(radio_cfg);
 	data->radio_cfg_dash = NVM_RF_CFG_DASH_MSK_FAMILY_8000(radio_cfg);
 	data->radio_cfg_pnum = NVM_RF_CFG_FLAVOR_MSK_FAMILY_8000(radio_cfg);
+	data->valid_tx_ant = NVM_RF_CFG_TX_ANT_MSK_FAMILY_8000(radio_cfg);
+	data->valid_rx_ant = NVM_RF_CFG_RX_ANT_MSK_FAMILY_8000(radio_cfg);
 }
 
 static void iwl_set_hw_address(const struct iwl_cfg *cfg,
@@ -592,6 +594,10 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 
 	radio_cfg = iwl_get_radio_cfg(cfg, nvm_sw);
 	iwl_set_radio_cfg(cfg, data, radio_cfg);
+	if (data->valid_tx_ant)
+		tx_chains &= data->valid_tx_ant;
+	if (data->valid_rx_ant)
+		rx_chains &= data->valid_rx_ant;
 
 	sku = iwl_get_sku(cfg, nvm_sw);
 	data->sku_cap_band_24GHz_enable = sku & NVM_SKU_CAP_BAND_24GHZ;
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 33bf915..0507647 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -933,7 +933,7 @@ iwl_dbgfs_scan_ant_rxchain_write(struct iwl_mvm *mvm, char *buf,
 		return -EINVAL;
 	if (scan_rx_ant > ANT_ABC)
 		return -EINVAL;
-	if (scan_rx_ant & ~mvm->fw->valid_rx_ant)
+	if (scan_rx_ant & ~(iwl_mvm_get_valid_rx_ant(mvm)))
 		return -EINVAL;
 
 	if (mvm->scan_rx_ant != scan_rx_ant) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index d0fa6e9..60d0c9f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -269,7 +269,7 @@ static int iwl_send_phy_cfg_cmd(struct iwl_mvm *mvm)
 	enum iwl_ucode_type ucode_type = mvm->cur_ucode;
 
 	/* Set parameters */
-	phy_cfg_cmd.phy_cfg = cpu_to_le32(mvm->fw->phy_config);
+	phy_cfg_cmd.phy_cfg = cpu_to_le32(iwl_mvm_get_phy_config(mvm));
 	phy_cfg_cmd.calib_control.event_trigger =
 		mvm->fw->default_calib[ucode_type].event_trigger;
 	phy_cfg_cmd.calib_control.flow_trigger =
@@ -346,7 +346,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	mvm->calibrating = true;
 
 	/* Send TX valid antennas before triggering calibrations */
-	ret = iwl_send_tx_ant_cfg(mvm, mvm->fw->valid_tx_ant);
+	ret = iwl_send_tx_ant_cfg(mvm, iwl_mvm_get_valid_tx_ant(mvm));
 	if (ret)
 		goto error;
 
@@ -489,7 +489,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	mvm->fw_dbg_conf = FW_DBG_INVALID;
 	iwl_mvm_start_fw_dbg_conf(mvm, FW_DBG_CUSTOM);
 
-	ret = iwl_send_tx_ant_cfg(mvm, mvm->fw->valid_tx_ant);
+	ret = iwl_send_tx_ant_cfg(mvm, iwl_mvm_get_valid_tx_ant(mvm));
 	if (ret)
 		goto error;
 
@@ -584,7 +584,7 @@ int iwl_mvm_load_d3_fw(struct iwl_mvm *mvm)
 		goto error;
 	}
 
-	ret = iwl_send_tx_ant_cfg(mvm, mvm->fw->valid_tx_ant);
+	ret = iwl_send_tx_ant_cfg(mvm, iwl_mvm_get_valid_tx_ant(mvm));
 	if (ret)
 		goto error;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index f6d86cc..7196b4d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -975,7 +975,7 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 	beacon_cmd.tx.tx_flags = cpu_to_le32(tx_flags);
 
 	mvm->mgmt_last_antenna_idx =
-		iwl_mvm_next_antenna(mvm, mvm->fw->valid_tx_ant,
+		iwl_mvm_next_antenna(mvm, iwl_mvm_get_valid_tx_ant(mvm),
 				     mvm->mgmt_last_antenna_idx);
 
 	beacon_cmd.tx.rate_n_flags =
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index d24660f..f3cb089 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -937,6 +937,33 @@ int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
 int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic);
 int iwl_mvm_load_nvm_to_nic(struct iwl_mvm *mvm);
 
+static inline u8 iwl_mvm_get_valid_tx_ant(struct iwl_mvm *mvm)
+{
+	return mvm->nvm_data && mvm->nvm_data->valid_tx_ant ?
+	       mvm->fw->valid_tx_ant & mvm->nvm_data->valid_tx_ant :
+	       mvm->fw->valid_tx_ant;
+}
+
+static inline u8 iwl_mvm_get_valid_rx_ant(struct iwl_mvm *mvm)
+{
+	return mvm->nvm_data && mvm->nvm_data->valid_rx_ant ?
+	       mvm->fw->valid_rx_ant & mvm->nvm_data->valid_rx_ant :
+	       mvm->fw->valid_rx_ant;
+}
+
+static inline u32 iwl_mvm_get_phy_config(struct iwl_mvm *mvm)
+{
+	u32 phy_config = ~(FW_PHY_CFG_TX_CHAIN |
+			   FW_PHY_CFG_RX_CHAIN);
+	u32 valid_rx_ant = iwl_mvm_get_valid_rx_ant(mvm);
+	u32 valid_tx_ant = iwl_mvm_get_valid_tx_ant(mvm);
+
+	phy_config |= valid_tx_ant << FW_PHY_CFG_TX_CHAIN_POS |
+		      valid_rx_ant << FW_PHY_CFG_RX_CHAIN_POS;
+
+	return mvm->fw->phy_config & phy_config;
+}
+
 int iwl_mvm_up(struct iwl_mvm *mvm);
 int iwl_mvm_load_d3_fw(struct iwl_mvm *mvm);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 552a776..146554c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -139,13 +139,14 @@ static void iwl_mvm_nic_config(struct iwl_op_mode *op_mode)
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	u8 radio_cfg_type, radio_cfg_step, radio_cfg_dash;
 	u32 reg_val = 0;
-
-	radio_cfg_type = (mvm->fw->phy_config & FW_PHY_CFG_RADIO_TYPE) >>
-			  FW_PHY_CFG_RADIO_TYPE_POS;
-	radio_cfg_step = (mvm->fw->phy_config & FW_PHY_CFG_RADIO_STEP) >>
-			  FW_PHY_CFG_RADIO_STEP_POS;
-	radio_cfg_dash = (mvm->fw->phy_config & FW_PHY_CFG_RADIO_DASH) >>
-			  FW_PHY_CFG_RADIO_DASH_POS;
+	u32 phy_config = iwl_mvm_get_phy_config(mvm);
+
+	radio_cfg_type = (phy_config & FW_PHY_CFG_RADIO_TYPE) >>
+			 FW_PHY_CFG_RADIO_TYPE_POS;
+	radio_cfg_step = (phy_config & FW_PHY_CFG_RADIO_STEP) >>
+			 FW_PHY_CFG_RADIO_STEP_POS;
+	radio_cfg_dash = (phy_config & FW_PHY_CFG_RADIO_DASH) >>
+			 FW_PHY_CFG_RADIO_DASH_POS;
 
 	/* SKU control */
 	reg_val |= CSR_HW_REV_STEP(mvm->trans->hw_rev) <<
diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index 1c0d4a4..540c36b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -176,7 +176,7 @@ static void iwl_mvm_phy_ctxt_cmd_data(struct iwl_mvm *mvm,
 	cmd->rxchain_info |= cpu_to_le32(active_cnt <<
 					 PHY_RX_CHAIN_MIMO_CNT_POS);
 
-	cmd->txchain_info = cpu_to_le32(mvm->fw->valid_tx_ant);
+	cmd->txchain_info = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
 }
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 30ceb67..b9682d7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -173,7 +173,7 @@ static bool rs_mimo_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	if (sta->smps_mode == IEEE80211_SMPS_STATIC)
 		return false;
 
-	if (num_of_ant(mvm->fw->valid_tx_ant) < 2)
+	if (num_of_ant(iwl_mvm_get_valid_tx_ant(mvm)) < 2)
 		return false;
 
 	if (!iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta))
@@ -1004,7 +1004,7 @@ static void rs_get_lower_rate_down_column(struct iwl_lq_sta *lq_sta,
 	}
 
 	if (num_of_ant(rate->ant) > 1)
-		rate->ant = first_antenna(mvm->fw->valid_tx_ant);
+		rate->ant = first_antenna(iwl_mvm_get_valid_tx_ant(mvm));
 
 	/* Relevant in both switching to SISO or Legacy */
 	rate->sgi = false;
@@ -1567,7 +1567,7 @@ static enum rs_column rs_get_next_column(struct iwl_mvm *mvm,
 	const struct rs_tx_column *curr_col = &rs_tx_columns[tbl->column];
 	const struct rs_tx_column *next_col;
 	allow_column_func_t allow_func;
-	u8 valid_ants = mvm->fw->valid_tx_ant;
+	u8 valid_ants = iwl_mvm_get_valid_tx_ant(mvm);
 	const u16 *expected_tpt_tbl;
 	u16 tpt, max_expected_tpt;
 
@@ -2385,7 +2385,7 @@ static void rs_get_initial_rate(struct iwl_mvm *mvm,
 	int i, nentries;
 	s8 best_rssi = S8_MIN;
 	u8 best_ant = ANT_NONE;
-	u8 valid_tx_ant = mvm->fw->valid_tx_ant;
+	u8 valid_tx_ant = iwl_mvm_get_valid_tx_ant(mvm);
 	const struct rs_init_rate_info *initial_rates;
 
 	for (i = 0; i < ARRAY_SIZE(lq_sta->pers.chain_signal); i++) {
@@ -2745,7 +2745,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			lq_sta->ldpc = true;
 
 		if (mvm->cfg->ht_params->stbc &&
-		    (num_of_ant(mvm->fw->valid_tx_ant) > 1) &&
+		    (num_of_ant(iwl_mvm_get_valid_tx_ant(mvm)) > 1) &&
 		    (ht_cap->cap & IEEE80211_HT_CAP_RX_STBC))
 			lq_sta->stbc = true;
 	} else {
@@ -2757,7 +2757,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			lq_sta->ldpc = true;
 
 		if (mvm->cfg->ht_params->stbc &&
-		    (num_of_ant(mvm->fw->valid_tx_ant) > 1) &&
+		    (num_of_ant(iwl_mvm_get_valid_tx_ant(mvm)) > 1) &&
 		    (vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK))
 			lq_sta->stbc = true;
 	}
@@ -2785,7 +2785,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	/* These values will be overridden later */
 	lq_sta->lq.single_stream_ant_msk =
-		first_antenna(mvm->fw->valid_tx_ant);
+		first_antenna(iwl_mvm_get_valid_tx_ant(mvm));
 	lq_sta->lq.dual_stream_ant_msk = ANT_AB;
 
 	/* as default allow aggregation for all tids */
@@ -2913,7 +2913,7 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 
 	memcpy(&rate, initial_rate, sizeof(rate));
 
-	valid_tx_ant = mvm->fw->valid_tx_ant;
+	valid_tx_ant = iwl_mvm_get_valid_tx_ant(mvm);
 	rate.stbc = rs_stbc_allow(mvm, sta, lq_sta);
 
 	if (is_siso(&rate)) {
@@ -3167,9 +3167,9 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	desc += sprintf(buff+desc, "fixed rate 0x%X\n",
 			lq_sta->pers.dbg_fixed_rate);
 	desc += sprintf(buff+desc, "valid_tx_ant %s%s%s\n",
-	    (mvm->fw->valid_tx_ant & ANT_A) ? "ANT_A," : "",
-	    (mvm->fw->valid_tx_ant & ANT_B) ? "ANT_B," : "",
-	    (mvm->fw->valid_tx_ant & ANT_C) ? "ANT_C" : "");
+	    (iwl_mvm_get_valid_tx_ant(mvm) & ANT_A) ? "ANT_A," : "",
+	    (iwl_mvm_get_valid_tx_ant(mvm) & ANT_B) ? "ANT_B," : "",
+	    (iwl_mvm_get_valid_tx_ant(mvm) & ANT_C) ? "ANT_C" : "");
 	desc += sprintf(buff+desc, "lq type %s\n",
 			(is_legacy(rate)) ? "legacy" :
 			is_vht(rate) ? "VHT" : "HT");
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index e5294d0..2433676 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -97,7 +97,7 @@ static u8 iwl_mvm_scan_rx_ant(struct iwl_mvm *mvm)
 {
 	if (mvm->scan_rx_ant != ANT_NONE)
 		return mvm->scan_rx_ant;
-	return mvm->fw->valid_rx_ant;
+	return iwl_mvm_get_valid_rx_ant(mvm);
 }
 
 static inline __le16 iwl_mvm_scan_rx_chain(struct iwl_mvm *mvm)
@@ -128,7 +128,7 @@ iwl_mvm_scan_rate_n_flags(struct iwl_mvm *mvm, enum ieee80211_band band,
 	u32 tx_ant;
 
 	mvm->scan_last_antenna_idx =
-		iwl_mvm_next_antenna(mvm, mvm->fw->valid_tx_ant,
+		iwl_mvm_next_antenna(mvm, iwl_mvm_get_valid_tx_ant(mvm),
 				     mvm->scan_last_antenna_idx);
 	tx_ant = BIT(mvm->scan_last_antenna_idx) << RATE_MCS_ANT_POS;
 
@@ -1603,7 +1603,7 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 					 SCAN_CONFIG_FLAG_SET_MAC_ADDR |
 					 SCAN_CONFIG_FLAG_SET_CHANNEL_FLAGS|
 					 SCAN_CONFIG_N_CHANNELS(num_channels));
-	scan_config->tx_chains = cpu_to_le32(mvm->fw->valid_tx_ant);
+	scan_config->tx_chains = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
 	scan_config->rx_chains = cpu_to_le32(iwl_mvm_scan_rx_ant(mvm));
 	scan_config->legacy_rates = iwl_mvm_scan_config_rates(mvm);
 	scan_config->out_of_channel_time = cpu_to_le32(170);
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 4f15d9d..d6cdb77 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -209,7 +209,7 @@ void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
 	rate_plcp = iwl_mvm_mac80211_idx_to_hwrate(rate_idx);
 
 	mvm->mgmt_last_antenna_idx =
-		iwl_mvm_next_antenna(mvm, mvm->fw->valid_tx_ant,
+		iwl_mvm_next_antenna(mvm, iwl_mvm_get_valid_tx_ant(mvm),
 				     mvm->mgmt_last_antenna_idx);
 
 	if (info->band == IEEE80211_BAND_2GHZ &&
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index e56e77e..f0a1141 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -620,7 +620,7 @@ void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	lockdep_assert_held(&mvm->mutex);
 
 	/* SMPS is irrelevant for NICs that don't have at least 2 RX antenna */
-	if (num_of_ant(mvm->fw->valid_rx_ant) == 1)
+	if (num_of_ant(iwl_mvm_get_valid_rx_ant(mvm)) == 1)
 		return;
 
 	if (vif->type == NL80211_IFTYPE_AP)
@@ -662,7 +662,7 @@ bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (num_of_ant(mvm->fw->valid_rx_ant) == 1)
+	if (num_of_ant(iwl_mvm_get_valid_rx_ant(mvm)) == 1)
 		return false;
 
 	if (!mvm->cfg->rx_with_siso_diversity)
-- 
1.9.1

