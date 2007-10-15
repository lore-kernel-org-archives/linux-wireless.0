Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10240 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757932AbXJOMpK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 08:45:10 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] iwlwifi: rs-4965 fix return values
Date: Mon, 15 Oct 2007 14:44:44 +0200
Message-Id: <11924522843231-git-send-email-tomas.winkler@intel.com> (sfid-20071015_134515_841158_7F34AF08)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleans up style of 'return' in rate scale 4965 functions.
It renames return name variables rc to ret, change functions to void if no
meaningful value was returned and adds return of -EINVAL for checks of
invalid arguments.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |  101 ++++++++++------------------
 1 files changed, 37 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 635661f..403a253 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -205,8 +205,6 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	int i;
 #endif
-	int rc = -1;
-
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_TX_LINK_QUALITY_CMD,
 		.len = sizeof(struct iwl_link_quality_cmd),
@@ -216,7 +214,7 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 
 	if ((lq->sta_id == 0xFF) &&
 	    (priv->iw_mode == IEEE80211_IF_TYPE_IBSS))
-		return rc;
+		return -EINVAL;
 
 	if (lq->sta_id == 0xFF)
 		lq->sta_id = IWL_AP_ID;
@@ -236,12 +234,12 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 
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
@@ -249,24 +247,18 @@ static int rs_rate_scale_clear_window(struct iwl_rate_scale_data *window)
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
 
@@ -305,15 +297,13 @@ static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
 
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
@@ -346,7 +336,7 @@ int static rs_mcs_from_tbl(struct iwl_rate *mcs_rate,
 	}
 
 	if (is_legacy(tbl->lq_type))
-		return rc;
+		return;
 
 	if (tbl->is_fat) {
 		if (tbl->is_dup)
@@ -362,7 +352,6 @@ int static rs_mcs_from_tbl(struct iwl_rate *mcs_rate,
 		if (is_siso(tbl->lq_type))
 			mcs_rate->rate_n_flags &= ~RATE_MCS_SGI_MSK;
 	}
-	return rc;
 }
 
 static int rs_get_tbl_info_from_mcs(const struct iwl_rate *mcs_rate,
@@ -376,7 +365,7 @@ static int rs_get_tbl_info_from_mcs(const struct iwl_rate *mcs_rate,
 
 	if (index  == IWL_RATE_INVALID) {
 		*rate_idx = -1;
-		return -1;
+		return -EINVAL;
 	}
 	tbl->is_SGI = 0;
 	tbl->is_fat = 0;
@@ -456,18 +445,16 @@ static inline void rs_toggle_antenna(struct iwl_rate *new_rate,
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
@@ -551,7 +538,7 @@ static u16 rs_get_adjacent_rate(u8 index, u16 rate_mask, int rate_type)
 	return (high << 8) | low;
 }
 
-static int rs_get_lower_rate(struct iwl_rate_scale_priv *lq_data,
+static void rs_get_lower_rate(struct iwl_rate_scale_priv *lq_data,
 			     struct iwl_scale_tbl_info *tbl, u8 scale_index,
 			     u8 ht_possible, struct iwl_rate *mcs_rate)
 {
@@ -592,10 +579,9 @@ static int rs_get_lower_rate(struct iwl_rate_scale_priv *lq_data,
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
@@ -605,8 +591,6 @@ static int rs_get_lower_rate(struct iwl_rate_scale_priv *lq_data,
 		rs_mcs_from_tbl(mcs_rate, tbl, low, is_green);
 	else
 		rs_mcs_from_tbl(mcs_rate, tbl, scale_index, is_green);
-
-	return 0;
 }
 
 static void rs_tx_status(void *priv_rate,
@@ -778,12 +762,8 @@ static u8 rs_is_ant_connected(u8 valid_antenna,
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
@@ -792,9 +772,9 @@ static u8 rs_is_other_ant_connected(u8 valid_antenna,
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
@@ -915,7 +895,6 @@ static int rs_switch_to_mimo(struct iwl_priv *priv,
 			     struct iwl_rate_scale_priv *lq_data,
 			     struct iwl_scale_tbl_info *tbl, int index)
 {
-	int rc = -1;
 #ifdef CONFIG_IWLWIFI_HT
 	u16 rate_mask;
 	s32 rate;
@@ -935,7 +914,6 @@ static int rs_switch_to_mimo(struct iwl_priv *priv,
 	if (!rs_is_both_ant_supp(lq_data->antenna))
 		return -1;
 
-	rc = 0;
 	tbl->is_dup = lq_data->is_dup;
 	tbl->action = 0;
 	if (priv->current_channel_width == IWL_CHANNEL_WIDTH_40MHZ)
@@ -966,14 +944,13 @@ static int rs_switch_to_mimo(struct iwl_priv *priv,
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
@@ -983,7 +960,6 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	if (!priv->is_ht_enabled || !priv->current_assoc_ht.is_ht)
 		return -1;
 
-	rc = 0;
 	tbl->is_dup = lq_data->is_dup;
 	tbl->lq_type = LQ_SISO;
 	tbl->action = 0;
@@ -1022,14 +998,14 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
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
@@ -1066,14 +1042,13 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
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
@@ -1083,14 +1058,13 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
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
@@ -1115,7 +1089,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 				 struct iwl_rate_scale_priv *lq_data,
 				 int index)
 {
-	int rc = -1;
+	int ret;
 	u8 is_green = lq_data->is_green;
 	struct iwl_scale_tbl_info *tbl =
 	    &(lq_data->lq_info[lq_data->active_tbl]);
@@ -1153,13 +1127,12 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
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
@@ -1206,7 +1179,7 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 				 struct iwl_rate_scale_priv *lq_data,
 				 int index)
 {
-	int rc = -1;
+	int ret;
 	s8 is_green = lq_data->is_green;
 	struct iwl_scale_tbl_info *tbl =
 	    &(lq_data->lq_info[lq_data->active_tbl]);
@@ -1231,9 +1204,9 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
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
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
