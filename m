Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbXJYJWc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:32 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 04/30] iwlwifi: rs-4965 fix return values
Date: Thu, 25 Oct 2007 17:15:25 +0800
Message-Id: <119330375796-git-send-email-yi.zhu@intel.com> (sfid-20071025_102241_719614_92973ED7)
In-Reply-To: <11933037553170-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch cleans up style of 'return' of rate scale 4965 functions.
It renames return name variables rc to ret, change functions to void if no
meaningful value was returned it add return of -EINVAL for checks of wrong
arguments.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |  101 ++++++++++------------------
 1 files changed, 37 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index e80f5e2..015e735 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -202,8 +202,6 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	int i;
 #endif
-	int rc = -1;
-
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_TX_LINK_QUALITY_CMD,
 		.len = sizeof(struct iwl_link_quality_cmd),
@@ -213,7 +211,7 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 
 	if ((lq->sta_id == 0xFF) &&
 	    (priv->iw_mode == IEEE80211_IF_TYPE_IBSS))
-		return rc;
+		return -EINVAL;
 
 	if (lq->sta_id == 0xFF)
 		lq->sta_id = IWL_AP_ID;
@@ -233,12 +231,12 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 
 	if (iwl_is_associated(priv) && priv->assoc_station_added &&
 	    priv->lq_mngr.lq_ready)
-		rc = iwl_send_cmd(priv, &cmd);
+		return  iwl_send_cmd(priv, &cmd);
 
-	return rc;
+	return 0;
 }
 
-static int rs_rate_scale_clear_window(struct iwl_rate_scale_data *window)
+static void rs_rate_scale_clear_window(struct iwl_rate_scale_data *window)
 {
 	window->data = 0;
 	window->success_counter = 0;
@@ -246,24 +244,18 @@ static int rs_rate_scale_clear_window(struct iwl_rate_scale_data *window)
 	window->counter = 0;
 	window->average_tpt = IWL_INVALID_VALUE;
 	window->stamp = 0;
-
-	return 0;
 }
 
 static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
 			      int scale_index, s32 tpt, u32 status)
 {
-	int rc = 0;
 	struct iwl_rate_scale_data *window = NULL;
 	u64 mask;
 	u8 win_size = IWL_RATE_MAX_WINDOW;
 	s32 fail_count;
 
-	if (scale_index < 0)
-		return -1;
-
-	if (scale_index >= IWL_RATE_COUNT)
-		return -1;
+	if (scale_index < 0 || scale_index >= IWL_RATE_COUNT)
+		return -EINVAL;
 
 	window = &(windows[scale_index]);
 
@@ -302,15 +294,13 @@ static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
 
 	window->stamp = jiffies;
 
-	return rc;
+	return 0;
 }
 
-int static rs_mcs_from_tbl(struct iwl_rate *mcs_rate,
+static void rs_mcs_from_tbl(struct iwl_rate *mcs_rate,
 			   struct iwl_scale_tbl_info *tbl,
 			   int index, u8 use_green)
 {
-	int rc = 0;
-
 	if (is_legacy(tbl->lq_type)) {
 		mcs_rate->rate_n_flags = iwl_rates[index].plcp;
 		if (index >= IWL_FIRST_CCK_RATE && index <= IWL_LAST_CCK_RATE)
@@ -343,7 +333,7 @@ int static rs_mcs_from_tbl(struct iwl_rate *mcs_rate,
 	}
 
 	if (is_legacy(tbl->lq_type))
-		return rc;
+		return;
 
 	if (tbl->is_fat) {
 		if (tbl->is_dup)
@@ -359,7 +349,6 @@ int static rs_mcs_from_tbl(struct iwl_rate *mcs_rate,
 		if (is_siso(tbl->lq_type))
 			mcs_rate->rate_n_flags &= ~RATE_MCS_SGI_MSK;
 	}
-	return rc;
 }
 
 static int rs_get_tbl_info_from_mcs(const struct iwl_rate *mcs_rate,
@@ -373,7 +362,7 @@ static int rs_get_tbl_info_from_mcs(const struct iwl_rate *mcs_rate,
 
 	if (index  == IWL_RATE_INVALID) {
 		*rate_idx = -1;
-		return -1;
+		return -EINVAL;
 	}
 	tbl->is_SGI = 0;
 	tbl->is_fat = 0;
@@ -453,18 +442,16 @@ static inline void rs_toggle_antenna(struct iwl_rate *new_rate,
 	}
 }
 
-static inline s8 rs_use_green(struct iwl_priv *priv)
+static inline u8 rs_use_green(struct iwl_priv *priv)
 {
-	s8 rc = 0;
 #ifdef CONFIG_IWLWIFI_HT
 	if (!priv->is_ht_enabled || !priv->current_assoc_ht.is_ht)
 		return 0;
 
-	if ((priv->current_assoc_ht.is_green_field) &&
-	    !(priv->current_assoc_ht.operating_mode & 0x4))
-		rc = 1;
+	return ((priv->current_assoc_ht.is_green_field) &&
+	    !(priv->current_assoc_ht.operating_mode & 0x4));
 #endif	/*CONFIG_IWLWIFI_HT */
-	return rc;
+	return 0;
 }
 
 /**
@@ -548,7 +535,7 @@ static u16 rs_get_adjacent_rate(u8 index, u16 rate_mask, int rate_type)
 	return (high << 8) | low;
 }
 
-static int rs_get_lower_rate(struct iwl_rate_scale_priv *lq_data,
+static void rs_get_lower_rate(struct iwl_rate_scale_priv *lq_data,
 			     struct iwl_scale_tbl_info *tbl, u8 scale_index,
 			     u8 ht_possible, struct iwl_rate *mcs_rate)
 {
@@ -589,10 +576,9 @@ static int rs_get_lower_rate(struct iwl_rate_scale_priv *lq_data,
 	}
 
 	/* if we did switched from HT to legacy check current rate */
-	if ((switch_to_legacy) &&
-	    (rate_mask & (1 << scale_index))) {
+	if (switch_to_legacy && (rate_mask & (1 << scale_index))) {
 		rs_mcs_from_tbl(mcs_rate, tbl, scale_index, is_green);
-		return 0;
+		return;
 	}
 
 	high_low = rs_get_adjacent_rate(scale_index, rate_mask, tbl->lq_type);
@@ -602,8 +588,6 @@ static int rs_get_lower_rate(struct iwl_rate_scale_priv *lq_data,
 		rs_mcs_from_tbl(mcs_rate, tbl, low, is_green);
 	else
 		rs_mcs_from_tbl(mcs_rate, tbl, scale_index, is_green);
-
-	return 0;
 }
 
 static void rs_tx_status(void *priv_rate,
@@ -775,12 +759,8 @@ static u8 rs_is_ant_connected(u8 valid_antenna,
 		return ((valid_antenna & 0x2) ? 1:0);
 	else if (antenna_type == ANT_MAIN)
 		return ((valid_antenna & 0x1) ? 1:0);
-	else if (antenna_type == ANT_BOTH) {
-		if ((valid_antenna & 0x3) == 0x3)
-			return 1;
-		else
-			return 0;
-	}
+	else if (antenna_type == ANT_BOTH)
+		return ((valid_antenna & 0x3) == 0x3);
 
 	return 1;
 }
@@ -789,9 +769,9 @@ static u8 rs_is_other_ant_connected(u8 valid_antenna,
 				    enum iwl_antenna_type antenna_type)
 {
 	if (antenna_type == ANT_AUX)
-		return (rs_is_ant_connected(valid_antenna, ANT_MAIN));
+		return rs_is_ant_connected(valid_antenna, ANT_MAIN);
 	else
-		return (rs_is_ant_connected(valid_antenna, ANT_AUX));
+		return rs_is_ant_connected(valid_antenna, ANT_AUX);
 
 	return 0;
 }
@@ -912,7 +892,6 @@ static int rs_switch_to_mimo(struct iwl_priv *priv,
 			     struct iwl_rate_scale_priv *lq_data,
 			     struct iwl_scale_tbl_info *tbl, int index)
 {
-	int rc = -1;
 #ifdef CONFIG_IWLWIFI_HT
 	u16 rate_mask;
 	s32 rate;
@@ -932,7 +911,6 @@ static int rs_switch_to_mimo(struct iwl_priv *priv,
 	if (!rs_is_both_ant_supp(lq_data->antenna))
 		return -1;
 
-	rc = 0;
 	tbl->is_dup = lq_data->is_dup;
 	tbl->action = 0;
 	if (priv->current_channel_width == IWL_CHANNEL_WIDTH_40MHZ)
@@ -963,14 +941,13 @@ static int rs_switch_to_mimo(struct iwl_priv *priv,
 		     tbl->current_rate.rate_n_flags, is_green);
 
 #endif				/*CONFIG_IWLWIFI_HT */
-	return rc;
+	return 0;
 }
 
 static int rs_switch_to_siso(struct iwl_priv *priv,
 			     struct iwl_rate_scale_priv *lq_data,
 			     struct iwl_scale_tbl_info *tbl, int index)
 {
-	int rc = -1;
 #ifdef CONFIG_IWLWIFI_HT
 	u16 rate_mask;
 	u8 is_green = lq_data->is_green;
@@ -980,7 +957,6 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	if (!priv->is_ht_enabled || !priv->current_assoc_ht.is_ht)
 		return -1;
 
-	rc = 0;
 	tbl->is_dup = lq_data->is_dup;
 	tbl->lq_type = LQ_SISO;
 	tbl->action = 0;
@@ -1019,14 +995,14 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 		     tbl->current_rate.rate_n_flags, is_green);
 
 #endif				/*CONFIG_IWLWIFI_HT */
-	return rc;
+	return 0;
 }
 
 static int rs_move_legacy_other(struct iwl_priv *priv,
 				struct iwl_rate_scale_priv *lq_data,
 				int index)
 {
-	int rc = 0;
+	int ret = 0;
 	struct iwl_scale_tbl_info *tbl =
 	    &(lq_data->lq_info[lq_data->active_tbl]);
 	struct iwl_scale_tbl_info *search_tbl =
@@ -1063,14 +1039,13 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 			search_tbl->lq_type = LQ_SISO;
 			search_tbl->is_SGI = 0;
 			search_tbl->is_fat = 0;
-			rc = rs_switch_to_siso(priv, lq_data, search_tbl,
+			ret = rs_switch_to_siso(priv, lq_data, search_tbl,
 					       index);
-			if (!rc) {
+			if (!ret) {
 				lq_data->search_better_tbl = 1;
 				lq_data->action_counter = 0;
-			}
-			if (!rc)
 				goto out;
+			}
 
 			break;
 		case IWL_LEGACY_SWITCH_MIMO:
@@ -1080,14 +1055,13 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 			search_tbl->is_SGI = 0;
 			search_tbl->is_fat = 0;
 			search_tbl->antenna_type = ANT_BOTH;
-			rc = rs_switch_to_mimo(priv, lq_data, search_tbl,
+			ret = rs_switch_to_mimo(priv, lq_data, search_tbl,
 					       index);
-			if (!rc) {
+			if (!ret) {
 				lq_data->search_better_tbl = 1;
 				lq_data->action_counter = 0;
-			}
-			if (!rc)
 				goto out;
+			}
 			break;
 		}
 		tbl->action++;
@@ -1112,7 +1086,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 				 struct iwl_rate_scale_priv *lq_data,
 				 int index)
 {
-	int rc = -1;
+	int ret;
 	u8 is_green = lq_data->is_green;
 	struct iwl_scale_tbl_info *tbl =
 	    &(lq_data->lq_info[lq_data->active_tbl]);
@@ -1150,13 +1124,12 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 			search_tbl->is_SGI = 0;
 			search_tbl->is_fat = 0;
 			search_tbl->antenna_type = ANT_BOTH;
-			rc = rs_switch_to_mimo(priv, lq_data, search_tbl,
+			ret = rs_switch_to_mimo(priv, lq_data, search_tbl,
 					       index);
-			if (!rc)
+			if (!ret) {
 				lq_data->search_better_tbl = 1;
-
-			if (!rc)
 				goto out;
+			}
 			break;
 		case IWL_SISO_SWITCH_GI:
 			IWL_DEBUG_HT("LQ: SISO SWITCH TO GI\n");
@@ -1203,7 +1176,7 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 				 struct iwl_rate_scale_priv *lq_data,
 				 int index)
 {
-	int rc = -1;
+	int ret;
 	s8 is_green = lq_data->is_green;
 	struct iwl_scale_tbl_info *tbl =
 	    &(lq_data->lq_info[lq_data->active_tbl]);
@@ -1228,9 +1201,9 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 			else
 				search_tbl->antenna_type = ANT_AUX;
 
-			rc = rs_switch_to_siso(priv, lq_data, search_tbl,
+			ret = rs_switch_to_siso(priv, lq_data, search_tbl,
 					       index);
-			if (!rc) {
+			if (!ret) {
 				lq_data->search_better_tbl = 1;
 				goto out;
 			}
-- 
1.5.2
