Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbXI0DfA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 23:35:00 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: add supp_rates to rate scale sta private data
Date: Thu, 27 Sep 2007 11:27:40 +0800
Message-Id: <1190863679136-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11908636781043-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
 <11908636662994-git-send-email-yi.zhu@intel.com>
 <11908636683204-git-send-email-yi.zhu@intel.com>
 <11908636692415-git-send-email-yi.zhu@intel.com>
 <119086367088-git-send-email-yi.zhu@intel.com>
 <11908636712746-git-send-email-yi.zhu@intel.com>
 <11908636732679-git-send-email-yi.zhu@intel.com>
 <11908636743625-git-send-email-yi.zhu@intel.com>
 <11908636753775-git-send-email-yi.zhu@intel.com>
 <11908636772860-git-send-email-yi.zhu@intel.com>
 <11908636781043-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds supp_rate bit mask to rate scale sta private data structre
and thus removes sta from the argument list in helper functions.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   31 +++++++++++++--------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index b9d7ad8..bad7466 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -115,6 +115,7 @@ struct iwl_rate_scale_priv {
 	u8 is_dup;
 	u8 phymode;
 	u8 ibss_sta_added;
+	u32 supp_rates;
 	u16 active_rate;
 	u16 active_siso_rate;
 	u16 active_mimo_rate;
@@ -132,8 +133,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 				   struct sta_info *sta);
 static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 			     struct iwl_rate *tx_mcs,
-			     struct iwl_link_quality_cmd *tbl,
-			     struct sta_info *sta);
+			     struct iwl_link_quality_cmd *tbl);
 
 
 static s32 expected_tpt_A[IWL_RATE_COUNT] = {
@@ -542,14 +542,13 @@ static u16 rs_get_adjacent_rate(u8 index, u16 rate_mask, int rate_type)
 
 static int rs_get_lower_rate(struct iwl_rate_scale_priv *lq_data,
 			     struct iwl_scale_tbl_info *tbl, u8 scale_index,
-			     u8 ht_possible, struct iwl_rate *mcs_rate,
-			     struct sta_info *sta)
+			     u8 ht_possible, struct iwl_rate *mcs_rate)
 {
-	u8 is_green = lq_data->is_green;
 	s32 low;
 	u16 rate_mask;
 	u16 high_low;
 	u8 switch_to_legacy = 0;
+	u8 is_green = lq_data->is_green;
 
 	/* check if we need to switch from HT to legacy rates.
 	 * assumption is that mandatory rates (1Mbps or 6Mbps)
@@ -576,9 +575,9 @@ static int rs_get_lower_rate(struct iwl_rate_scale_priv *lq_data,
 	if (is_legacy(tbl->lq_type)) {
 		if (lq_data->phymode == (u8) MODE_IEEE80211A)
 			rate_mask  = (u16)(rate_mask &
-			   (sta->supp_rates << IWL_FIRST_OFDM_RATE));
+			   (lq_data->supp_rates << IWL_FIRST_OFDM_RATE));
 		else
-			rate_mask = (u16)(rate_mask & sta->supp_rates);
+			rate_mask = (u16)(rate_mask & lq_data->supp_rates);
 	}
 
 	/* if we did switched from HT to legacy check current rate */
@@ -1391,10 +1390,10 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	if (is_legacy(tbl->lq_type)) {
 		if (lq_data->phymode == (u8) MODE_IEEE80211A)
 			rate_scale_index_msk = (u16) (rate_mask &
-				(sta->supp_rates << IWL_FIRST_OFDM_RATE));
+				(lq_data->supp_rates << IWL_FIRST_OFDM_RATE));
 		else
 			rate_scale_index_msk = (u16) (rate_mask &
-						      sta->supp_rates);
+						      lq_data->supp_rates);
 
 	} else
 		rate_scale_index_msk = rate_mask;
@@ -1434,7 +1433,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		rs_stay_in_table(lq_data);
 		if (update_lq) {
 			rs_mcs_from_tbl(&mcs_rate, tbl, index, is_green);
-			rs_fill_link_cmd(lq_data, &mcs_rate, &lq_data->lq, sta);
+			rs_fill_link_cmd(lq_data, &mcs_rate, &lq_data->lq);
 			rs_send_lq_cmd(priv, &lq_data->lq, CMD_ASYNC);
 		}
 		goto out;
@@ -1558,7 +1557,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
  lq_update:
 	if (update_lq) {
 		rs_mcs_from_tbl(&mcs_rate, tbl, index, is_green);
-		rs_fill_link_cmd(lq_data, &mcs_rate, &lq_data->lq, sta);
+		rs_fill_link_cmd(lq_data, &mcs_rate, &lq_data->lq);
 		rs_send_lq_cmd(priv, &lq_data->lq, CMD_ASYNC);
 	}
 	rs_stay_in_table(lq_data);
@@ -1584,7 +1583,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 			IWL_DEBUG_HT("Switch current  mcs: %X index: %d\n",
 				     tbl->current_rate.rate_n_flags, index);
 			rs_fill_link_cmd(lq_data, &tbl->current_rate,
-					 &(lq_data->lq), sta);
+					 &lq_data->lq);
 			rs_send_lq_cmd(priv, &lq_data->lq, CMD_ASYNC);
 		}
 		tbl1 = &(lq_data->lq_info[lq_data->active_tbl]);
@@ -1680,7 +1679,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 	rs_mcs_from_tbl(&mcs_rate, tbl, rate_idx, use_green);
 	tbl->current_rate.rate_n_flags = mcs_rate.rate_n_flags;
 	rs_get_expected_tpt_table(lq, tbl);
-	rs_fill_link_cmd(lq, &mcs_rate, &(lq->lq), sta);
+	rs_fill_link_cmd(lq, &mcs_rate, &lq->lq);
 	rs_send_lq_cmd(priv, &lq->lq, CMD_ASYNC);
  out:
 	return;
@@ -1799,6 +1798,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	struct iwl_rate_scale_priv *crl = priv_sta;
 
 	crl->flush_timer = 0;
+	crl->supp_rates = sta->supp_rates;
 	sta->txrate = 3;
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IWL_RATE_COUNT; i++)
@@ -1875,8 +1875,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 
 static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 			    struct iwl_rate *tx_mcs,
-			    struct iwl_link_quality_cmd *lq_cmd,
-			    struct sta_info *sta)
+			    struct iwl_link_quality_cmd *lq_cmd)
 {
 	int index = 0;
 	int rc = 0;
@@ -1934,7 +1933,7 @@ static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 			lq_cmd->general_params.mimo_delimiter = index;
 
 		rs_get_lower_rate(lq_data, &tbl_type, rate_idx,
-				  use_ht_possible, &new_rate, sta);
+				  use_ht_possible, &new_rate);
 
 		if (is_legacy(tbl_type.lq_type)) {
 			if (ant_toggle_count < NUM_TRY_BEFORE_ANTENNA_TOGGLE)
-- 
1.5.1
