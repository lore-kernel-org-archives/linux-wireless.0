Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44502 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751759AbdHRPti (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:49:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:49:07 +0300
Message-Id: <20170818154922.2904-10-luca@coelho.fi> (sfid-20170818_174946_943766_8433BAC0)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
Subject: [PATCH 09/24] iwlwifi: mvm: use mvmsta consistently in rs.c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We use mvmsta for the sta->drv_priv in mvm, but in rs.c we have a
bunch of instances using sta_priv, which is probably due to it being
copied from dvm.  Change all occurrences to mvmsta for consistency
with the rest of the driver

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 30 ++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 65beca3a457a..cdf10ce9dbea 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -1673,14 +1673,14 @@ static void rs_set_amsdu_len(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			     struct iwl_scale_tbl_info *tbl,
 			     enum rs_action scale_action)
 {
-	struct iwl_mvm_sta *sta_priv = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
 	if ((!is_vht(&tbl->rate) && !is_ht(&tbl->rate)) ||
 	    tbl->rate.index < IWL_RATE_MCS_5_INDEX ||
 	    scale_action == RS_ACTION_DOWNSCALE)
-		sta_priv->tlc_amsdu = false;
+		mvmsta->tlc_amsdu = false;
 	else
-		sta_priv->tlc_amsdu = true;
+		mvmsta->tlc_amsdu = true;
 }
 
 /*
@@ -2228,11 +2228,11 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	u16 high_low;
 	s32 sr;
 	u8 prev_agg = lq_sta->is_agg;
-	struct iwl_mvm_sta *sta_priv = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data;
 	struct rs_rate *rate;
 
-	lq_sta->is_agg = !!sta_priv->agg_tids;
+	lq_sta->is_agg = !!mvmsta->agg_tids;
 
 	/*
 	 * Select rate-scale / modulation-mode table to work with in
@@ -2491,7 +2491,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 			IWL_DEBUG_RATE(mvm, "LQ: STAY in legacy table\n");
 
 			if (tid != IWL_MAX_TID_COUNT) {
-				tid_data = &sta_priv->tid_data[tid];
+				tid_data = &mvmsta->tid_data[tid];
 				if (tid_data->state != IWL_AGG_OFF) {
 					IWL_DEBUG_RATE(mvm,
 						       "Stop aggregation on tid %d\n",
@@ -2507,7 +2507,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 			if ((lq_sta->last_tpt > IWL_AGG_TPT_THREHOLD) &&
 			    (lq_sta->tx_agg_tid_en & (1 << tid)) &&
 			    (tid != IWL_MAX_TID_COUNT)) {
-				tid_data = &sta_priv->tid_data[tid];
+				tid_data = &mvmsta->tid_data[tid];
 				if (tid_data->state == IWL_AGG_OFF && !ndp) {
 					IWL_DEBUG_RATE(mvm,
 						       "try to aggregate tid %d\n",
@@ -2900,10 +2900,10 @@ static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
 static void *rs_alloc_sta(void *mvm_rate, struct ieee80211_sta *sta,
 			  gfp_t gfp)
 {
-	struct iwl_mvm_sta *sta_priv = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_op_mode *op_mode = (struct iwl_op_mode *)mvm_rate;
 	struct iwl_mvm *mvm  = IWL_OP_MODE_GET_MVM(op_mode);
-	struct iwl_lq_sta *lq_sta = &sta_priv->lq_sta;
+	struct iwl_lq_sta *lq_sta = &mvmsta->lq_sta;
 
 	IWL_DEBUG_RATE(mvm, "create station rate scale window\n");
 
@@ -2917,7 +2917,7 @@ static void *rs_alloc_sta(void *mvm_rate, struct ieee80211_sta *sta,
 	memset(lq_sta->pers.chain_signal, 0, sizeof(lq_sta->pers.chain_signal));
 	lq_sta->pers.last_rssi = S8_MIN;
 
-	return &sta_priv->lq_sta;
+	return &mvmsta->lq_sta;
 }
 
 static int rs_vht_highest_rx_mcs_index(struct ieee80211_sta_vht_cap *vht_cap,
@@ -3109,8 +3109,8 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	struct ieee80211_hw *hw = mvm->hw;
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
-	struct iwl_mvm_sta *sta_priv = iwl_mvm_sta_from_mac80211(sta);
-	struct iwl_lq_sta *lq_sta = &sta_priv->lq_sta;
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_lq_sta *lq_sta = &mvmsta->lq_sta;
 	struct ieee80211_supported_band *sband;
 	unsigned long supp; /* must be unsigned long for for_each_set_bit */
 
@@ -3119,8 +3119,8 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	sband = hw->wiphy->bands[band];
 
-	lq_sta->lq.sta_id = sta_priv->sta_id;
-	sta_priv->tlc_amsdu = false;
+	lq_sta->lq.sta_id = mvmsta->sta_id;
+	mvmsta->tlc_amsdu = false;
 
 	for (j = 0; j < LQ_SIZE; j++)
 		rs_rate_scale_clear_tbl_windows(mvm, &lq_sta->lq_info[j]);
@@ -3130,7 +3130,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	IWL_DEBUG_RATE(mvm,
 		       "LQ: *** rate scale station global init for station %d ***\n",
-		       sta_priv->sta_id);
+		       mvmsta->sta_id);
 	/* TODO: what is a good starting rate for STA? About middle? Maybe not
 	 * the lowest or the highest rate.. Could consider using RSSI from
 	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
-- 
2.14.1
