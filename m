Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61956 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaBWT5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:25 -0500
Received: by mail-wg0-f49.google.com with SMTP id y10so3965706wgg.4
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:24 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/17] iwlwifi: remove iwl_fw_valid_(tx|rx)_ant inlines
Date: Sun, 23 Feb 2014 21:56:59 +0200
Message-Id: <1393185428-8524-8-git-send-email-egrumbach@gmail.com> (sfid-20140223_205732_630442_8D8937E3)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These inlines are pretty pointless now as they just return a
fixed struct value, remove them - the code even gets shorter.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h       |   10 ----------
 drivers/net/wireless/iwlwifi/mvm/debugfs.c  |    2 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c       |    6 +++---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |    2 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c      |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/rs.c       |   18 +++++++++---------
 drivers/net/wireless/iwlwifi/mvm/scan.c     |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/tx.c       |    2 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c    |    2 +-
 10 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 7367107..af6b452 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -296,14 +296,4 @@ struct iwl_fw {
 	struct ieee80211_cipher_scheme cs[IWL_UCODE_MAX_CS];
 };
 
-static inline u8 iwl_fw_valid_tx_ant(const struct iwl_fw *fw)
-{
-	return fw->valid_tx_ant;
-}
-
-static inline u8 iwl_fw_valid_rx_ant(const struct iwl_fw *fw)
-{
-	return fw->valid_rx_ant;
-}
-
 #endif  /* __iwl_fw_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 9b98337..3278b48 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -591,7 +591,7 @@ iwl_dbgfs_scan_ant_rxchain_write(struct iwl_mvm *mvm, char *buf,
 		return -EINVAL;
 	if (scan_rx_ant > ANT_ABC)
 		return -EINVAL;
-	if (scan_rx_ant & ~iwl_fw_valid_rx_ant(mvm->fw))
+	if (scan_rx_ant & ~mvm->fw->valid_rx_ant)
 		return -EINVAL;
 
 	mvm->scan_rx_ant = scan_rx_ant;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index bae75b3..4f398e6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -320,7 +320,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	}
 
 	/* Send TX valid antennas before triggering calibrations */
-	ret = iwl_send_tx_ant_cfg(mvm, iwl_fw_valid_tx_ant(mvm->fw));
+	ret = iwl_send_tx_ant_cfg(mvm, mvm->fw->valid_tx_ant);
 	if (ret)
 		goto error;
 
@@ -422,7 +422,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (ret)
 		IWL_ERR(mvm, "Failed to initialize Smart Fifo\n");
 
-	ret = iwl_send_tx_ant_cfg(mvm, iwl_fw_valid_tx_ant(mvm->fw));
+	ret = iwl_send_tx_ant_cfg(mvm, mvm->fw->valid_tx_ant);
 	if (ret)
 		goto error;
 
@@ -507,7 +507,7 @@ int iwl_mvm_load_d3_fw(struct iwl_mvm *mvm)
 		goto error;
 	}
 
-	ret = iwl_send_tx_ant_cfg(mvm, iwl_fw_valid_tx_ant(mvm->fw));
+	ret = iwl_send_tx_ant_cfg(mvm, mvm->fw->valid_tx_ant);
 	if (ret)
 		goto error;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 5c21aab..9ccec10 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -952,7 +952,7 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 					     TX_CMD_FLG_TSF);
 
 	mvm->mgmt_last_antenna_idx =
-		iwl_mvm_next_antenna(mvm, iwl_fw_valid_tx_ant(mvm->fw),
+		iwl_mvm_next_antenna(mvm, mvm->fw->valid_tx_ant,
 				     mvm->mgmt_last_antenna_idx);
 
 	beacon_cmd.tx.rate_n_flags =
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index e80e81a..cf2d09f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -259,8 +259,8 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 
 	return iwl_parse_nvm_data(mvm->trans->dev, mvm->cfg, hw, sw, calib,
 				  regulatory, mac_override,
-				  iwl_fw_valid_tx_ant(mvm->fw),
-				  iwl_fw_valid_rx_ant(mvm->fw));
+				  mvm->fw->valid_tx_ant,
+				  mvm->fw->valid_rx_ant);
 }
 
 #define MAX_NVM_FILE_LEN	16384
diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index b7268c0..237efe0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -156,13 +156,13 @@ static void iwl_mvm_phy_ctxt_cmd_data(struct iwl_mvm *mvm,
 	idle_cnt = chains_static;
 	active_cnt = chains_dynamic;
 
-	cmd->rxchain_info = cpu_to_le32(iwl_fw_valid_rx_ant(mvm->fw) <<
+	cmd->rxchain_info = cpu_to_le32(mvm->fw->valid_rx_ant <<
 					PHY_RX_CHAIN_VALID_POS);
 	cmd->rxchain_info |= cpu_to_le32(idle_cnt << PHY_RX_CHAIN_CNT_POS);
 	cmd->rxchain_info |= cpu_to_le32(active_cnt <<
 					 PHY_RX_CHAIN_MIMO_CNT_POS);
 
-	cmd->txchain_info = cpu_to_le32(iwl_fw_valid_tx_ant(mvm->fw));
+	cmd->txchain_info = cpu_to_le32(mvm->fw->valid_tx_ant);
 }
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index a6d0ab1..77c6e36 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -166,7 +166,7 @@ static bool rs_mimo_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	if (sta->smps_mode == IEEE80211_SMPS_STATIC)
 		return false;
 
-	if (num_of_ant(iwl_fw_valid_tx_ant(mvm->fw)) < 2)
+	if (num_of_ant(mvm->fw->valid_tx_ant) < 2)
 		return false;
 
 	if (!iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta))
@@ -917,7 +917,7 @@ static void rs_get_lower_rate_down_column(struct iwl_lq_sta *lq_sta,
 
 
 	if (num_of_ant(rate->ant) > 1)
-		rate->ant = first_antenna(iwl_fw_valid_tx_ant(mvm->fw));
+		rate->ant = first_antenna(mvm->fw->valid_tx_ant);
 
 	/* Relevant in both switching to SISO or Legacy */
 	rate->sgi = false;
@@ -1477,7 +1477,7 @@ static enum rs_column rs_get_next_column(struct iwl_mvm *mvm,
 	const struct rs_tx_column *curr_col = &rs_tx_columns[tbl->column];
 	const struct rs_tx_column *next_col;
 	allow_column_func_t allow_func;
-	u8 valid_ants = iwl_fw_valid_tx_ant(mvm->fw);
+	u8 valid_ants = mvm->fw->valid_tx_ant;
 	const u16 *expected_tpt_tbl;
 	s32 tpt, max_expected_tpt;
 
@@ -2089,7 +2089,7 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 
 	i = lq_sta->last_txrate_idx;
 
-	valid_tx_ant = iwl_fw_valid_tx_ant(mvm->fw);
+	valid_tx_ant = mvm->fw->valid_tx_ant;
 
 	if (!lq_sta->search_better_tbl)
 		active_tbl = lq_sta->active_tbl;
@@ -2319,7 +2319,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	/* These values will be overridden later */
 	lq_sta->lq.single_stream_ant_msk =
-		first_antenna(iwl_fw_valid_tx_ant(mvm->fw));
+		first_antenna(mvm->fw->valid_tx_ant);
 	lq_sta->lq.dual_stream_ant_msk = ANT_AB;
 
 	/* as default allow aggregation for all tids */
@@ -2445,7 +2445,7 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 
 	memcpy(&rate, initial_rate, sizeof(rate));
 
-	valid_tx_ant = iwl_fw_valid_tx_ant(mvm->fw);
+	valid_tx_ant = mvm->fw->valid_tx_ant;
 
 	if (is_siso(&rate)) {
 		num_rates = RS_INITIAL_SISO_NUM_RATES;
@@ -2676,9 +2676,9 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	desc += sprintf(buff+desc, "fixed rate 0x%X\n",
 			lq_sta->dbg_fixed_rate);
 	desc += sprintf(buff+desc, "valid_tx_ant %s%s%s\n",
-	    (iwl_fw_valid_tx_ant(mvm->fw) & ANT_A) ? "ANT_A," : "",
-	    (iwl_fw_valid_tx_ant(mvm->fw) & ANT_B) ? "ANT_B," : "",
-	    (iwl_fw_valid_tx_ant(mvm->fw) & ANT_C) ? "ANT_C" : "");
+	    (mvm->fw->valid_tx_ant & ANT_A) ? "ANT_A," : "",
+	    (mvm->fw->valid_tx_ant & ANT_B) ? "ANT_B," : "",
+	    (mvm->fw->valid_tx_ant & ANT_C) ? "ANT_C" : "");
 	desc += sprintf(buff+desc, "lq type %s\n",
 			(is_legacy(rate)) ? "legacy" :
 			is_vht(rate) ? "VHT" : "HT");
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index bf4e773..cea935b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -82,7 +82,7 @@ static inline __le16 iwl_mvm_scan_rx_chain(struct iwl_mvm *mvm)
 	if (mvm->scan_rx_ant != ANT_NONE)
 		rx_ant = mvm->scan_rx_ant;
 	else
-		rx_ant = iwl_fw_valid_rx_ant(mvm->fw);
+		rx_ant = mvm->fw->valid_rx_ant;
 	rx_chain = rx_ant << PHY_RX_CHAIN_VALID_POS;
 	rx_chain |= rx_ant << PHY_RX_CHAIN_FORCE_MIMO_SEL_POS;
 	rx_chain |= rx_ant << PHY_RX_CHAIN_FORCE_SEL_POS;
@@ -124,7 +124,7 @@ iwl_mvm_scan_rate_n_flags(struct iwl_mvm *mvm, enum ieee80211_band band,
 	u32 tx_ant;
 
 	mvm->scan_last_antenna_idx =
-		iwl_mvm_next_antenna(mvm, iwl_fw_valid_tx_ant(mvm->fw),
+		iwl_mvm_next_antenna(mvm, mvm->fw->valid_tx_ant,
 				     mvm->scan_last_antenna_idx);
 	tx_ant = BIT(mvm->scan_last_antenna_idx) << RATE_MCS_ANT_POS;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 852d9d8..b83ef6a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -207,7 +207,7 @@ static void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm,
 	rate_plcp = iwl_mvm_mac80211_idx_to_hwrate(rate_idx);
 
 	mvm->mgmt_last_antenna_idx =
-		iwl_mvm_next_antenna(mvm, iwl_fw_valid_tx_ant(mvm->fw),
+		iwl_mvm_next_antenna(mvm, mvm->fw->valid_tx_ant,
 				     mvm->mgmt_last_antenna_idx);
 	rate_flags = BIT(mvm->mgmt_last_antenna_idx) << RATE_MCS_ANT_POS;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 2021b57..c81a7fb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -587,7 +587,7 @@ void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	lockdep_assert_held(&mvm->mutex);
 
 	/* SMPS is irrelevant for NICs that don't have at least 2 RX antenna */
-	if (num_of_ant(iwl_fw_valid_rx_ant(mvm->fw)) == 1)
+	if (num_of_ant(mvm->fw->valid_rx_ant) == 1)
 		return;
 
 	if (vif->type == NL80211_IFTYPE_AP)
-- 
1.7.9.5

