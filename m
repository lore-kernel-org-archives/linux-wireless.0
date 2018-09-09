Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48046 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726787AbeIIO0l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 10:26:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Erel Geron <erelx.geron@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  9 Sep 2018 12:36:50 +0300
Message-Id: <20180909093656.10194-11-luca@coelho.fi> (sfid-20180909_113737_692282_9049D32E)
In-Reply-To: <20180909093656.10194-1-luca@coelho.fi>
References: <20180909093656.10194-1-luca@coelho.fi>
Subject: [PATCH 10/16] iwlwifi: mvm: TLC support for Coex Schema 2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Erel Geron <erelx.geron@intel.com>

The new coex schema requires setting the non-shared antenna
for the single_stream_ant_msk field in the TLC command.

Signed-off-by: Erel Geron <erelx.geron@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c | 9 +++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   | 5 +++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
index ec3b60cdcf18..730e37744dc0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
@@ -691,6 +691,15 @@ bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
 	return bt_activity >= BT_LOW_TRAFFIC;
 }
 
+u8 iwl_mvm_bt_coex_get_single_ant_msk(struct iwl_mvm *mvm, u8 enabled_ants)
+{
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_COEX_SCHEMA_2) &&
+	    (mvm->cfg->non_shared_ant & enabled_ants))
+		return mvm->cfg->non_shared_ant;
+
+	return first_antenna(enabled_ants);
+}
+
 u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			   struct ieee80211_tx_info *info, u8 ac)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 33f8697740a5..8f71eeed50d9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1819,6 +1819,7 @@ bool iwl_mvm_bt_coex_is_ant_avail(struct iwl_mvm *mvm, u8 ant);
 bool iwl_mvm_bt_coex_is_shared_ant_avail(struct iwl_mvm *mvm);
 bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
 				    enum nl80211_band band);
+u8 iwl_mvm_bt_coex_get_single_ant_msk(struct iwl_mvm *mvm, u8 enabled_ants);
 u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			   struct ieee80211_tx_info *info, u8 ac);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index c3282f1d77ba..2c75f51a04e4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -3213,7 +3213,7 @@ static void rs_drv_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	/* These values will be overridden later */
 	lq_sta->lq.single_stream_ant_msk =
-		first_antenna(iwl_mvm_get_valid_tx_ant(mvm));
+		iwl_mvm_bt_coex_get_single_ant_msk(mvm, iwl_mvm_get_valid_tx_ant(mvm));
 	lq_sta->lq.dual_stream_ant_msk = ANT_AB;
 
 	/* as default allow aggregation for all tids */
@@ -3576,7 +3576,8 @@ static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
 
-	if (num_of_ant(initial_rate->ant) == 1)
+	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_COEX_SCHEMA_2) &&
+	    num_of_ant(initial_rate->ant) == 1)
 		lq_cmd->single_stream_ant_msk = initial_rate->ant;
 
 	lq_cmd->agg_frame_cnt_limit = mvmsta->max_agg_bufsize;
-- 
2.18.0
