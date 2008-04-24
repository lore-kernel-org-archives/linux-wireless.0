Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30954 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbYDXAPN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:13 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Guy Cohen <guy.cohen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 05/16] iwlwifi: TLC modifications
Date: Wed, 23 Apr 2008 17:14:57 -0700
Message-Id: <1208996108-15326-6-git-send-email-reinette.chatre@intel.com> (sfid-20080424_021612_789739_7F2F7FDD)
In-Reply-To: <1208996108-15326-5-git-send-email-reinette.chatre@intel.com>
References: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-2-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-3-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-4-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

1. Merge TLC fixes from AP support code
2. Remove struct iwl4965_rate
3. Misc code restructuring

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |  434 +++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   31 +-
 2 files changed, 221 insertions(+), 244 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 31a0451..7c55aa9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -64,10 +64,6 @@ static u8 rs_ht_to_legacy[] = {
 	IWL_RATE_48M_INDEX, IWL_RATE_54M_INDEX
 };
 
-struct iwl4965_rate {
-	u32 rate_n_flags;
-} __attribute__ ((packed));
-
 /**
  * struct iwl4965_rate_scale_data -- tx success history for one rate
  */
@@ -94,7 +90,7 @@ struct iwl4965_scale_tbl_info {
 	u8 is_dup;	/* 1 = duplicated data streams */
 	u8 action;	/* change modulation; IWL_[LEGACY/SISO/MIMO]_SWITCH_* */
 	s32 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
-	struct iwl4965_rate current_rate;  /* rate_n_flags, uCode API format */
+	u32 current_rate;  /* rate_n_flags, uCode API format */
 	struct iwl4965_rate_scale_data win[IWL_RATE_COUNT]; /* rate histories */
 };
 
@@ -144,7 +140,7 @@ struct iwl4965_lq_sta {
 
 	/* The following are bitmaps of rates; IWL_RATE_6M_MASK, etc. */
 	u32 supp_rates;
-	u16 active_rate;
+	u16 active_legacy_rate;
 	u16 active_siso_rate;
 	u16 active_mimo2_rate;
 	u16 active_mimo3_rate;
@@ -162,7 +158,7 @@ struct iwl4965_lq_sta {
 #ifdef CONFIG_IWL4965_HT
 	struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
 #endif
-	struct iwl4965_rate dbg_fixed;
+	u32 dbg_fixed_rate;
 	struct iwl_priv *drv;
 #endif
 };
@@ -173,16 +169,16 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 				   struct sta_info *sta);
 static void rs_fill_link_cmd(const struct iwl_priv *priv,
 			     struct iwl4965_lq_sta *lq_sta,
-			     struct iwl4965_rate *tx_mcs,
+			     u32 rate_n_flags,
 			     struct iwl_link_quality_cmd *tbl);
 
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 static void rs_dbgfs_set_mcs(struct iwl4965_lq_sta *lq_sta,
-				struct iwl4965_rate *mcs, int index);
+					u32 *rate_n_flags, int index);
 #else
 static void rs_dbgfs_set_mcs(struct iwl4965_lq_sta *lq_sta,
-				struct iwl4965_rate *mcs, int index)
+					u32 *rate_n_flags, int index)
 {}
 #endif
 
@@ -232,7 +228,7 @@ static s32 expected_tpt_mimo40MHzSGI[IWL_RATE_COUNT] = {
 	0, 0, 0, 0, 131, 131, 191, 222, 242, 270, 284, 289, 293
 };
 
-static inline u8 iwl4965_rate_get_rate(u32 rate_n_flags)
+static inline u8 rs_extract_rate(u32 rate_n_flags)
 {
 	return (u8)(rate_n_flags & 0xFF);
 }
@@ -376,11 +372,11 @@ static void rs_tl_turn_on_agg(struct iwl_priv *priv, u8 tid,
 
 #endif /* CONFIG_IWLWIFI_HT */
 
-static inline int get_num_of_ant_from_mcs(u32 mcs)
+static inline int get_num_of_ant_from_rate(u32 rate_n_flags)
 {
-	return (!!(mcs & RATE_MCS_ANT_A_MSK) +
-		!!(mcs & RATE_MCS_ANT_B_MSK) +
-		!!(mcs & RATE_MCS_ANT_C_MSK));
+	return (!!(rate_n_flags & RATE_MCS_ANT_A_MSK) +
+		!!(rate_n_flags & RATE_MCS_ANT_B_MSK) +
+		!!(rate_n_flags & RATE_MCS_ANT_C_MSK));
 }
 
 /**
@@ -395,8 +391,7 @@ static int rs_collect_tx_data(struct iwl4965_rate_scale_data *windows,
 			      int successes)
 {
 	struct iwl4965_rate_scale_data *window = NULL;
-	u64 mask;
-	u8 win_size = IWL_RATE_MAX_WINDOW;
+	static const u64 mask = (((u64)1) << (IWL_RATE_MAX_WINDOW - 1));
 	s32 fail_count;
 
 	if (scale_index < 0 || scale_index >= IWL_RATE_COUNT)
@@ -414,14 +409,14 @@ static int rs_collect_tx_data(struct iwl4965_rate_scale_data *windows,
 	 * we keep these bitmaps!).
 	 */
 	while (retries > 0) {
-		if (window->counter >= win_size) {
-			window->counter = win_size - 1;
-			mask = 1;
-			mask = (mask << (win_size - 1));
+		if (window->counter >= IWL_RATE_MAX_WINDOW) {
+
+			/* remove earliest */
+			window->counter = IWL_RATE_MAX_WINDOW - 1;
+
 			if (window->data & mask) {
 				window->data &= ~mask;
-				window->success_counter =
-					window->success_counter - 1;
+				window->success_counter--;
 			}
 		}
 
@@ -431,10 +426,9 @@ static int rs_collect_tx_data(struct iwl4965_rate_scale_data *windows,
 		/* Shift bitmap by one frame (throw away oldest history),
 		 * OR in "1", and increment "success" if this
 		 * frame was successful. */
-		mask = window->data;
-		window->data = (mask << 1);
+		window->data <<= 1;;
 		if (successes > 0) {
-			window->success_counter = window->success_counter + 1;
+			window->success_counter++;
 			window->data |= 0x1;
 			successes--;
 		}
@@ -467,70 +461,72 @@ static int rs_collect_tx_data(struct iwl4965_rate_scale_data *windows,
 /*
  * Fill uCode API rate_n_flags field, based on "search" or "active" table.
  */
-static void rs_mcs_from_tbl(struct iwl4965_rate *mcs_rate,
-			   struct iwl4965_scale_tbl_info *tbl,
-			   int index, u8 use_green)
+/* FIXME:RS:remove this function and put the flags statically in the table */
+static u32 rate_n_flags_from_tbl(struct iwl4965_scale_tbl_info *tbl,
+				       int index, u8 use_green)
 {
+	u32 rate_n_flags = 0;
+
 	if (is_legacy(tbl->lq_type)) {
-		mcs_rate->rate_n_flags = iwl4965_rates[index].plcp;
+		rate_n_flags = iwl4965_rates[index].plcp;
 		if (index >= IWL_FIRST_CCK_RATE && index <= IWL_LAST_CCK_RATE)
-			mcs_rate->rate_n_flags |= RATE_MCS_CCK_MSK;
+			rate_n_flags |= RATE_MCS_CCK_MSK;
 
 	} else if (is_Ht(tbl->lq_type)) {
 		if (index > IWL_LAST_OFDM_RATE) {
 			IWL_ERROR("invalid HT rate index %d\n", index);
 			index = IWL_LAST_OFDM_RATE;
 		}
-		mcs_rate->rate_n_flags = RATE_MCS_HT_MSK;
+		rate_n_flags = RATE_MCS_HT_MSK;
 
 		if (is_siso(tbl->lq_type))
-			mcs_rate->rate_n_flags |=
-					iwl4965_rates[index].plcp_siso;
+			rate_n_flags |=	iwl4965_rates[index].plcp_siso;
 		else if (is_mimo2(tbl->lq_type))
-			mcs_rate->rate_n_flags |=
-					iwl4965_rates[index].plcp_mimo2;
+			rate_n_flags |=	iwl4965_rates[index].plcp_mimo2;
 		else
-			mcs_rate->rate_n_flags |=
-					iwl4965_rates[index].plcp_mimo3;
+			rate_n_flags |=	iwl4965_rates[index].plcp_mimo3;
 	} else {
 		IWL_ERROR("Invalid tbl->lq_type %d\n", tbl->lq_type);
 	}
 
-	mcs_rate->rate_n_flags |= ((tbl->ant_type << RATE_MCS_ANT_POS) &
+	rate_n_flags |= ((tbl->ant_type << RATE_MCS_ANT_POS) &
 						     RATE_MCS_ANT_ABC_MSK);
 
-	if (is_legacy(tbl->lq_type))
-		return;
-
-	if (tbl->is_fat) {
-		if (tbl->is_dup)
-			mcs_rate->rate_n_flags |= RATE_MCS_DUP_MSK;
-		else
-			mcs_rate->rate_n_flags |= RATE_MCS_FAT_MSK;
-	}
-	if (tbl->is_SGI)
-		mcs_rate->rate_n_flags |= RATE_MCS_SGI_MSK;
-
-	if (use_green) {
-		mcs_rate->rate_n_flags |= RATE_MCS_GF_MSK;
-		if (is_siso(tbl->lq_type))
-			mcs_rate->rate_n_flags &= ~RATE_MCS_SGI_MSK;
+	if (is_Ht(tbl->lq_type)) {
+		if (tbl->is_fat) {
+			if (tbl->is_dup)
+				rate_n_flags |= RATE_MCS_DUP_MSK;
+			else
+				rate_n_flags |= RATE_MCS_FAT_MSK;
+		}
+		if (tbl->is_SGI)
+			rate_n_flags |= RATE_MCS_SGI_MSK;
+
+		if (use_green) {
+			rate_n_flags |= RATE_MCS_GF_MSK;
+			if (is_siso(tbl->lq_type) && tbl->is_SGI) {
+				rate_n_flags &= ~RATE_MCS_SGI_MSK;
+				IWL_ERROR("GF was set with SGI:SISO\n");
+			}
+		}
 	}
+	return rate_n_flags;
 }
 
 /*
  * Interpret uCode API's rate_n_flags format,
  * fill "search" or "active" tx mode table.
  */
-static int rs_get_tbl_info_from_mcs(const struct iwl4965_rate *mcs_rate,
+static int rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
 				    enum ieee80211_band band,
 				    struct iwl4965_scale_tbl_info *tbl,
 				    int *rate_idx)
 {
-	u32 ant_msk = (mcs_rate->rate_n_flags & RATE_MCS_ANT_ABC_MSK);
-	u8 num_of_ant = get_num_of_ant_from_mcs(ant_msk);
+	u32 ant_msk = (rate_n_flags & RATE_MCS_ANT_ABC_MSK);
+	u8 num_of_ant = get_num_of_ant_from_rate(rate_n_flags);
+	u8 mcs;
 
-	*rate_idx = iwl4965_hwrate_to_plcp_idx(mcs_rate->rate_n_flags);
+	*rate_idx = iwl4965_hwrate_to_plcp_idx(rate_n_flags);
 
 	if (*rate_idx  == IWL_RATE_INVALID) {
 		*rate_idx = -1;
@@ -543,7 +539,7 @@ static int rs_get_tbl_info_from_mcs(const struct iwl4965_rate *mcs_rate,
 	tbl->lq_type = LQ_NONE;
 
 	/* legacy rate format */
-	if (!(mcs_rate->rate_n_flags & RATE_MCS_HT_MSK)) {
+	if (!(rate_n_flags & RATE_MCS_HT_MSK)) {
 		if (num_of_ant == 1) {
 			if (band == IEEE80211_BAND_5GHZ)
 				tbl->lq_type = LQ_A;
@@ -552,25 +548,24 @@ static int rs_get_tbl_info_from_mcs(const struct iwl4965_rate *mcs_rate,
 		}
 	/* HT rate format */
 	} else {
-		if (mcs_rate->rate_n_flags & RATE_MCS_SGI_MSK)
+		if (rate_n_flags & RATE_MCS_SGI_MSK)
 			tbl->is_SGI = 1;
 
-		if ((mcs_rate->rate_n_flags & RATE_MCS_FAT_MSK) ||
-		    (mcs_rate->rate_n_flags & RATE_MCS_DUP_MSK))
+		if ((rate_n_flags & RATE_MCS_FAT_MSK) ||
+		    (rate_n_flags & RATE_MCS_DUP_MSK))
 			tbl->is_fat = 1;
 
-		if (mcs_rate->rate_n_flags & RATE_MCS_DUP_MSK)
+		if (rate_n_flags & RATE_MCS_DUP_MSK)
 			tbl->is_dup = 1;
 
-		/* SISO */
-		if (iwl4965_rate_get_rate(mcs_rate->rate_n_flags)
-						<= IWL_RATE_SISO_60M_PLCP) {
+		mcs = rs_extract_rate(rate_n_flags);
 
+		/* SISO */
+		if (mcs <= IWL_RATE_SISO_60M_PLCP) {
 			if (num_of_ant == 1)
 				tbl->lq_type = LQ_SISO; /*else NONE*/
 		/* MIMO2 */
-		} else if (iwl4965_rate_get_rate(mcs_rate->rate_n_flags)
-						<= IWL_RATE_MIMO2_60M_PLCP) {
+		} else if (mcs <= IWL_RATE_MIMO2_60M_PLCP) {
 			if (num_of_ant == 2)
 				tbl->lq_type = LQ_MIMO2;
 		/* MIMO3 */
@@ -582,13 +577,14 @@ static int rs_get_tbl_info_from_mcs(const struct iwl4965_rate *mcs_rate,
 	return 0;
 }
 /* FIXME:RS: need to toggle also ANT_C, and also AB,AC,BC */
-static inline void rs_toggle_antenna(struct iwl4965_rate *new_rate,
+static inline void rs_toggle_antenna(u32 *rate_n_flags,
 				     struct iwl4965_scale_tbl_info *tbl)
 {
 	tbl->ant_type ^= ANT_AB;
-	new_rate->rate_n_flags ^= (RATE_MCS_ANT_A_MSK|RATE_MCS_ANT_B_MSK);
+	*rate_n_flags ^= (RATE_MCS_ANT_A_MSK|RATE_MCS_ANT_B_MSK);
 }
 
+/* FIXME:RS: in 4965 we don't use greenfield at all */
 static inline u8 rs_use_green(struct iwl_priv *priv,
 			      struct ieee80211_conf *conf)
 {
@@ -596,8 +592,9 @@ static inline u8 rs_use_green(struct iwl_priv *priv,
 	return ((conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) &&
 		priv->current_ht_config.is_green_field &&
 		!priv->current_ht_config.non_GF_STA_present);
-#endif	/* CONFIG_IWL4965_HT */
+#else
 	return 0;
+#endif	/* CONFIG_IWL4965_HT */
 }
 
 /**
@@ -613,7 +610,7 @@ static void rs_get_supported_rates(struct iwl4965_lq_sta *lq_sta,
 				   u16 *data_rate)
 {
 	if (is_legacy(rate_type))
-		*data_rate = lq_sta->active_rate;
+		*data_rate = lq_sta->active_legacy_rate;
 	else {
 		if (is_siso(rate_type))
 			*data_rate = lq_sta->active_siso_rate;
@@ -684,9 +681,9 @@ static u16 rs_get_adjacent_rate(u8 index, u16 rate_mask, int rate_type)
 	return (high << 8) | low;
 }
 
-static void rs_get_lower_rate(struct iwl4965_lq_sta *lq_sta,
+static u32 rs_get_lower_rate(struct iwl4965_lq_sta *lq_sta,
 			     struct iwl4965_scale_tbl_info *tbl, u8 scale_index,
-			     u8 ht_possible, struct iwl4965_rate *mcs_rate)
+			     u8 ht_possible)
 {
 	s32 low;
 	u16 rate_mask;
@@ -726,17 +723,18 @@ static void rs_get_lower_rate(struct iwl4965_lq_sta *lq_sta,
 
 	/* If we switched from HT to legacy, check current rate */
 	if (switch_to_legacy && (rate_mask & (1 << scale_index))) {
-		rs_mcs_from_tbl(mcs_rate, tbl, scale_index, is_green);
-		return;
+		low = scale_index;
+		goto out;
 	}
 
 	high_low = rs_get_adjacent_rate(scale_index, rate_mask, tbl->lq_type);
 	low = high_low & 0xff;
 
-	if (low != IWL_RATE_INVALID)
-		rs_mcs_from_tbl(mcs_rate, tbl, low, is_green);
-	else
-		rs_mcs_from_tbl(mcs_rate, tbl, scale_index, is_green);
+	if (low == IWL_RATE_INVALID)
+		low = scale_index;
+
+out:
+	return rate_n_flags_from_tbl(tbl, low, is_green);
 }
 
 /*
@@ -758,7 +756,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	struct ieee80211_hw *hw = local_to_hw(local);
 	struct iwl4965_rate_scale_data *window = NULL;
 	struct iwl4965_rate_scale_data *search_win = NULL;
-	struct iwl4965_rate tx_mcs;
+	u32 tx_rate;
 	struct iwl4965_scale_tbl_info tbl_type;
 	struct iwl4965_scale_tbl_info *curr_tbl, *search_tbl;
 	u8 active_index = 0;
@@ -817,8 +815,8 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	 * to check "search" mode, or a prior "search" mode after we've moved
 	 * to a new "search" mode (which might become the new "active" mode).
 	 */
-	tx_mcs.rate_n_flags = le32_to_cpu(table->rs_table[0].rate_n_flags);
-	rs_get_tbl_info_from_mcs(&tx_mcs, priv->band, &tbl_type, &rs_index);
+	tx_rate = le32_to_cpu(table->rs_table[0].rate_n_flags);
+	rs_get_tbl_info_from_mcs(tx_rate, priv->band, &tbl_type, &rs_index);
 	if (priv->band == IEEE80211_BAND_5GHZ)
 		rs_index -= IWL_FIRST_OFDM_RATE;
 
@@ -830,14 +828,13 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	    (tbl_type.is_dup ^
 		!!(tx_resp->control.flags & IEEE80211_TXCTL_DUP_DATA)) ||
 	    (tbl_type.ant_type ^ tx_resp->control.antenna_sel_tx) ||
-	    (!!(tx_mcs.rate_n_flags & RATE_MCS_HT_MSK) ^
+	    (!!(tx_rate & RATE_MCS_HT_MSK) ^
 		!!(tx_resp->control.flags & IEEE80211_TXCTL_OFDM_HT)) ||
-	    (!!(tx_mcs.rate_n_flags & RATE_MCS_GF_MSK) ^
+	    (!!(tx_rate & RATE_MCS_GF_MSK) ^
 		!!(tx_resp->control.flags & IEEE80211_TXCTL_GREEN_FIELD)) ||
 	    (hw->wiphy->bands[priv->band]->bitrates[rs_index].bitrate !=
 		tx_resp->control.tx_rate->bitrate)) {
-		IWL_DEBUG_RATE("initial rate does not match 0x%x\n",
-				tx_mcs.rate_n_flags);
+		IWL_DEBUG_RATE("initial rate does not match 0x%x\n", tx_rate);
 		goto out;
 	}
 
@@ -845,9 +842,8 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	while (retries) {
 		/* Look up the rate and other info used for each tx attempt.
 		 * Each tx attempt steps one entry deeper in the rate table. */
-		tx_mcs.rate_n_flags =
-		    le32_to_cpu(table->rs_table[index].rate_n_flags);
-		rs_get_tbl_info_from_mcs(&tx_mcs, priv->band,
+		tx_rate = le32_to_cpu(table->rs_table[index].rate_n_flags);
+		rs_get_tbl_info_from_mcs(tx_rate, priv->band,
 					  &tbl_type, &rs_index);
 
 		/* If type matches "search" table,
@@ -887,8 +883,8 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	 * if Tx was successful first try, use original rate,
 	 * else look up the rate that was, finally, successful.
 	 */
-	tx_mcs.rate_n_flags = le32_to_cpu(table->rs_table[index].rate_n_flags);
-	rs_get_tbl_info_from_mcs(&tx_mcs, priv->band, &tbl_type, &rs_index);
+	tx_rate = le32_to_cpu(table->rs_table[index].rate_n_flags);
+	rs_get_tbl_info_from_mcs(tx_rate, priv->band, &tbl_type, &rs_index);
 
 	/* Update frame history window with "success" if Tx got ACKed ... */
 	if (tx_resp->flags & IEEE80211_TX_STATUS_ACK)
@@ -1158,11 +1154,6 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	    !sta->ht_info.ht_supported)
 		return -1;
 
-	IWL_DEBUG_HT("LQ: try to switch to MIMO\n");
-	tbl->lq_type = LQ_MIMO2;
-	rs_get_supported_rates(lq_sta, NULL, tbl->lq_type,
-				&rate_mask);
-
 	if (priv->current_ht_config.tx_mimo_ps_mode == IWL_MIMO_PS_STATIC)
 		return -1;
 
@@ -1170,14 +1161,20 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	if (!rs_is_both_ant_supp(priv->hw_params.valid_tx_ant))
 		return -1;
 
+	IWL_DEBUG_HT("LQ: try to switch to MIMO2\n");
+
+	tbl->lq_type = LQ_MIMO2;
 	tbl->is_dup = lq_sta->is_dup;
 	tbl->action = 0;
+	rate_mask = lq_sta->active_mimo2_rate;
+
 	if (priv->current_ht_config.supported_chan_width
-	    == IWL_CHANNEL_WIDTH_40MHZ)
+					== IWL_CHANNEL_WIDTH_40MHZ)
 		tbl->is_fat = 1;
 	else
 		tbl->is_fat = 0;
 
+	/* FIXME: - don't toggle SGI here
 	if (tbl->is_fat) {
 		if (priv->current_ht_config.sgf & HT_SHORT_GI_40MHZ_ONLY)
 			tbl->is_SGI = 1;
@@ -1187,18 +1184,23 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 		tbl->is_SGI = 1;
 	else
 		tbl->is_SGI = 0;
+	*/
 
 	rs_get_expected_tpt_table(lq_sta, tbl);
 
 	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index, index);
 
-	IWL_DEBUG_HT("LQ: MIMO best rate %d mask %X\n", rate, rate_mask);
-	if ((rate == IWL_RATE_INVALID) || !((1 << rate) & rate_mask))
+	IWL_DEBUG_HT("LQ: MIMO2 best rate %d mask %X\n", rate, rate_mask);
+
+	if ((rate == IWL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
+		IWL_DEBUG_HT("Can't switch with index %d rate mask %x\n",
+						rate, rate_mask);
 		return -1;
-	rs_mcs_from_tbl(&tbl->current_rate, tbl, rate, is_green);
+	}
+	tbl->current_rate = rate_n_flags_from_tbl(tbl, rate, is_green);
 
 	IWL_DEBUG_HT("LQ: Switch to new mcs %X index is green %X\n",
-		     tbl->current_rate.rate_n_flags, is_green);
+		     tbl->current_rate, is_green);
 	return 0;
 }
 #else
@@ -1226,16 +1228,16 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	u8 is_green = lq_sta->is_green;
 	s32 rate;
 
-	IWL_DEBUG_HT("LQ: try to switch to SISO\n");
 	if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) ||
 	    !sta->ht_info.ht_supported)
 		return -1;
 
+	IWL_DEBUG_HT("LQ: try to switch to SISO\n");
+
 	tbl->is_dup = lq_sta->is_dup;
 	tbl->lq_type = LQ_SISO;
 	tbl->action = 0;
-	rs_get_supported_rates(lq_sta, NULL, tbl->lq_type,
-				&rate_mask);
+	rate_mask = lq_sta->active_siso_rate;
 
 	if (priv->current_ht_config.supported_chan_width
 	    == IWL_CHANNEL_WIDTH_40MHZ)
@@ -1243,6 +1245,7 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	else
 		tbl->is_fat = 0;
 
+	/* FIXME: - don't toggle SGI here
 	if (tbl->is_fat) {
 		if (priv->current_ht_config.sgf & HT_SHORT_GI_40MHZ_ONLY)
 			tbl->is_SGI = 1;
@@ -1252,9 +1255,10 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 		tbl->is_SGI = 1;
 	else
 		tbl->is_SGI = 0;
+	*/
 
 	if (is_green)
-		tbl->is_SGI = 0;
+		tbl->is_SGI = 0; /*11n spec: no SGI in SISO+Greenfield*/
 
 	rs_get_expected_tpt_table(lq_sta, tbl);
 	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index, index);
@@ -1265,9 +1269,9 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 			     rate, rate_mask);
 		return -1;
 	}
-	rs_mcs_from_tbl(&tbl->current_rate, tbl, rate, is_green);
+	tbl->current_rate = rate_n_flags_from_tbl(tbl, rate, is_green);
 	IWL_DEBUG_HT("LQ: Switch to new mcs %X index is green %X\n",
-		     tbl->current_rate.rate_n_flags, is_green);
+		     tbl->current_rate, is_green);
 	return 0;
 #else
 	return -1;
@@ -1298,12 +1302,13 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	for (; ;) {
 		switch (tbl->action) {
 		case IWL_LEGACY_SWITCH_ANTENNA:
-			IWL_DEBUG_HT("LQ Legacy switch Antenna\n");
+			IWL_DEBUG_HT("LQ Legacy toggle Antenna\n");
 
 			search_tbl->lq_type = LQ_NONE;
 			lq_sta->action_counter++;
 
 			/* Don't change antenna if success has been great */
+			/*FIXME:RS:not sure this is really needed*/
 			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
 				break;
 
@@ -1315,7 +1320,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 			/* Set up search table to try other antenna */
 			memcpy(search_tbl, tbl, sz);
 
-			rs_toggle_antenna(&(search_tbl->current_rate),
+			rs_toggle_antenna(&search_tbl->current_rate,
 					   search_tbl);
 			rs_get_expected_tpt_table(lq_sta, search_tbl);
 			lq_sta->search_better_tbl = 1;
@@ -1326,9 +1331,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 
 			/* Set up search table to try SISO */
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->lq_type = LQ_SISO;
 			search_tbl->is_SGI = 0;
-			search_tbl->is_fat = 0;
 			ret = rs_switch_to_siso(priv, lq_sta, conf, sta,
 						 search_tbl, index);
 			if (!ret) {
@@ -1339,13 +1342,11 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 
 			break;
 		case IWL_LEGACY_SWITCH_MIMO2:
-			IWL_DEBUG_HT("LQ: Legacy switch MIMO\n");
+			IWL_DEBUG_HT("LQ: Legacy switch to MIMO2\n");
 
 			/* Set up search table to try MIMO */
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->lq_type = LQ_MIMO2;
 			search_tbl->is_SGI = 0;
-			search_tbl->is_fat = 0;
 			search_tbl->ant_type = ANT_AB;/*FIXME:RS*/
 				/*FIXME:RS:need to check ant validity*/
 			ret = rs_switch_to_mimo2(priv, lq_sta, conf, sta,
@@ -1400,8 +1401,8 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 		lq_sta->action_counter++;
 		switch (tbl->action) {
 		case IWL_SISO_SWITCH_ANTENNA:
-			IWL_DEBUG_HT("LQ: SISO SWITCH ANTENNA SISO\n");
-			search_tbl->lq_type = LQ_NONE;
+			IWL_DEBUG_HT("LQ: SISO toggle Antenna\n");
+			/*FIXME:RS: is this really needed for SISO?*/
 			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
 				break;
 			if (!rs_is_other_ant_connected(valid_tx_ant,
@@ -1409,19 +1410,16 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 				break;
 
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->action = IWL_SISO_SWITCH_MIMO2;
-			rs_toggle_antenna(&(search_tbl->current_rate),
+			rs_toggle_antenna(&search_tbl->current_rate,
 					   search_tbl);
 			lq_sta->search_better_tbl = 1;
 
 			goto out;
 
 		case IWL_SISO_SWITCH_MIMO2:
-			IWL_DEBUG_HT("LQ: SISO SWITCH TO MIMO2 FROM SISO\n");
+			IWL_DEBUG_HT("LQ: SISO switch to MIMO\n");
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->lq_type = LQ_MIMO2;
 			search_tbl->is_SGI = 0;
-			search_tbl->is_fat = 0;
 			search_tbl->ant_type = ANT_AB; /*FIXME:RS*/
 			ret = rs_switch_to_mimo2(priv, lq_sta, conf, sta,
 						 search_tbl, index);
@@ -1431,29 +1429,25 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 			}
 			break;
 		case IWL_SISO_SWITCH_GI:
-			IWL_DEBUG_HT("LQ: SISO SWITCH TO GI\n");
+			IWL_DEBUG_HT("LQ: SISO toggle SGI/NGI\n");
 
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->action = 0;
-			if (search_tbl->is_SGI)
-				search_tbl->is_SGI = 0;
-			else if (!is_green)
-				search_tbl->is_SGI = 1;
-			else
-				break;
-			lq_sta->search_better_tbl = 1;
-			if ((tbl->lq_type == LQ_SISO) &&
-			    (tbl->is_SGI)) {
-				s32 tpt = lq_sta->last_tpt / 100;
-				if (((!tbl->is_fat) &&
-				     (tpt >= expected_tpt_siso20MHz[index])) ||
-				    ((tbl->is_fat) &&
-				     (tpt >= expected_tpt_siso40MHz[index])))
-					lq_sta->search_better_tbl = 0;
+			if (is_green) {
+				if (!tbl->is_SGI)
+					break;
+				else
+					IWL_ERROR("SGI was set in GF+SISO\n");
 			}
+			search_tbl->is_SGI = !tbl->is_SGI;
 			rs_get_expected_tpt_table(lq_sta, search_tbl);
-			rs_mcs_from_tbl(&search_tbl->current_rate,
-					     search_tbl, index, is_green);
+			if (tbl->is_SGI) {
+				s32 tpt = lq_sta->last_tpt / 100;
+				if (tpt >= search_tbl->expected_tpt[index])
+					break;
+			}
+			search_tbl->current_rate = rate_n_flags_from_tbl(
+						search_tbl, index, is_green);
+			lq_sta->search_better_tbl = 1;
 			goto out;
 		}
 		tbl->action++;
@@ -1496,15 +1490,12 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 		switch (tbl->action) {
 		case IWL_MIMO_SWITCH_ANTENNA_A:
 		case IWL_MIMO_SWITCH_ANTENNA_B:
-			IWL_DEBUG_HT("LQ: MIMO SWITCH TO SISO\n");
-
+			IWL_DEBUG_HT("LQ: MIMO2 switch to SISO\n");
 
 			/* Set up new search table for SISO */
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->lq_type = LQ_SISO;
-			search_tbl->is_SGI = 0;
-			search_tbl->is_fat = 0;
-				/*FIXME:RS:need to check ant validity + C*/
+
+			/*FIXME:RS:need to check ant validity + C*/
 			if (tbl->action == IWL_MIMO_SWITCH_ANTENNA_A)
 				search_tbl->ant_type = ANT_A;
 			else
@@ -1519,35 +1510,26 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 			break;
 
 		case IWL_MIMO_SWITCH_GI:
-			IWL_DEBUG_HT("LQ: MIMO SWITCH TO GI\n");
+			IWL_DEBUG_HT("LQ: MIMO toggle SGI/NGI\n");
 
 			/* Set up new search table for MIMO */
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->action = 0;
-			if (search_tbl->is_SGI)
-				search_tbl->is_SGI = 0;
-			else
-				search_tbl->is_SGI = 1;
-			lq_sta->search_better_tbl = 1;
-
+			search_tbl->is_SGI = !tbl->is_SGI;
+			rs_get_expected_tpt_table(lq_sta, search_tbl);
 			/*
 			 * If active table already uses the fastest possible
 			 * modulation (dual stream with short guard interval),
 			 * and it's working well, there's no need to look
 			 * for a better type of modulation!
 			 */
-			if ((tbl->lq_type == LQ_MIMO2) &&
-			    (tbl->is_SGI)) {
+			if (tbl->is_SGI) {
 				s32 tpt = lq_sta->last_tpt / 100;
-				if (((!tbl->is_fat) &&
-				     (tpt >= expected_tpt_mimo20MHz[index])) ||
-				    ((tbl->is_fat) &&
-				     (tpt >= expected_tpt_mimo40MHz[index])))
-					lq_sta->search_better_tbl = 0;
+				if (tpt >= search_tbl->expected_tpt[index])
+					break;
 			}
-			rs_get_expected_tpt_table(lq_sta, search_tbl);
-			rs_mcs_from_tbl(&search_tbl->current_rate,
-					     search_tbl, index, is_green);
+			search_tbl->current_rate = rate_n_flags_from_tbl(
+						search_tbl, index, is_green);
+			lq_sta->search_better_tbl = 1;
 			goto out;
 
 		}
@@ -1677,7 +1659,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	struct iwl4965_lq_sta *lq_sta;
 	struct iwl4965_scale_tbl_info *tbl, *tbl1;
 	u16 rate_scale_index_msk = 0;
-	struct iwl4965_rate mcs_rate;
+	u32 rate;
 	u8 is_green = 0;
 	u8 active_tbl = 0;
 	u8 done_search = 0;
@@ -1802,8 +1784,8 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 		/* Set up new rate table in uCode, if needed */
 		if (update_lq) {
-			rs_mcs_from_tbl(&mcs_rate, tbl, index, is_green);
-			rs_fill_link_cmd(priv, lq_sta, &mcs_rate, &lq_sta->lq);
+			rate = rate_n_flags_from_tbl(tbl, index, is_green);
+			rs_fill_link_cmd(priv, lq_sta, rate, &lq_sta->lq);
 			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 		}
 		goto out;
@@ -1847,7 +1829,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 			/* Revert to "active" rate and throughput info */
 			index = iwl4965_hwrate_to_plcp_idx(
-				tbl->current_rate.rate_n_flags);
+							tbl->current_rate);
 			current_tpt = lq_sta->last_tpt;
 
 			/* Need to set up a new rate table in uCode */
@@ -1967,8 +1949,8 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
  lq_update:
 	/* Replace uCode's rate table for the destination station. */
 	if (update_lq) {
-		rs_mcs_from_tbl(&mcs_rate, tbl, index, is_green);
-		rs_fill_link_cmd(priv, lq_sta, &mcs_rate, &lq_sta->lq);
+		rate = rate_n_flags_from_tbl(tbl, index, is_green);
+		rs_fill_link_cmd(priv, lq_sta, rate, &lq_sta->lq);
 		iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 	}
 
@@ -2003,11 +1985,11 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 			/* Use new "search" start rate */
 			index = iwl4965_hwrate_to_plcp_idx(
-					tbl->current_rate.rate_n_flags);
+							tbl->current_rate);
 
 			IWL_DEBUG_HT("Switch current  mcs: %X index: %d\n",
-				     tbl->current_rate.rate_n_flags, index);
-			rs_fill_link_cmd(priv, lq_sta, &tbl->current_rate,
+				     tbl->current_rate, index);
+			rs_fill_link_cmd(priv, lq_sta, tbl->current_rate,
 					 &lq_sta->lq);
 			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 		}
@@ -2058,7 +2040,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	}
 
 out:
-	rs_mcs_from_tbl(&tbl->current_rate, tbl, index, is_green);
+	tbl->current_rate = rate_n_flags_from_tbl(tbl, index, is_green);
 	i = index;
 	sta->last_txrate_idx = i;
 
@@ -2084,7 +2066,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 	u8 active_tbl = 0;
 	int rate_idx;
 	u8 use_green = rs_use_green(priv, conf);
-	struct iwl4965_rate mcs_rate;
+	u32 rate;
 
 	if (!sta || !sta->rate_ctrl_priv)
 		goto out;
@@ -2107,22 +2089,22 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 		i = 0;
 
 	/* FIXME:RS: This is also wrong in 4965 */
-	mcs_rate.rate_n_flags = iwl4965_rates[i].plcp ;
-	mcs_rate.rate_n_flags |= RATE_MCS_ANT_B_MSK;
-	mcs_rate.rate_n_flags &= ~RATE_MCS_ANT_A_MSK;
+	rate = iwl4965_rates[i].plcp;
+	rate |= RATE_MCS_ANT_B_MSK;
+	rate &= ~RATE_MCS_ANT_A_MSK;
 
 	if (i >= IWL_FIRST_CCK_RATE && i <= IWL_LAST_CCK_RATE)
-		mcs_rate.rate_n_flags |= RATE_MCS_CCK_MSK;
+		rate |= RATE_MCS_CCK_MSK;
 
 	tbl->ant_type = ANT_B;
-	rs_get_tbl_info_from_mcs(&mcs_rate, priv->band, tbl, &rate_idx);
+	rs_get_tbl_info_from_mcs(rate, priv->band, tbl, &rate_idx);
 	if (!rs_is_ant_connected(priv->hw_params.valid_tx_ant, tbl->ant_type))
-	    rs_toggle_antenna(&mcs_rate, tbl);
+	    rs_toggle_antenna(&rate, tbl);
 
-	rs_mcs_from_tbl(&mcs_rate, tbl, rate_idx, use_green);
-	tbl->current_rate.rate_n_flags = mcs_rate.rate_n_flags;
+	rate = rate_n_flags_from_tbl(tbl, rate_idx, use_green);
+	tbl->current_rate = rate;
 	rs_get_expected_tpt_table(lq_sta, tbl);
-	rs_fill_link_cmd(NULL, lq_sta, &mcs_rate, &lq_sta->lq);
+	rs_fill_link_cmd(NULL, lq_sta, rate, &lq_sta->lq);
 	iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
  out:
 	return;
@@ -2275,8 +2257,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 
 	lq_sta->is_dup = 0;
 	lq_sta->is_green = rs_use_green(priv, conf);
-	lq_sta->active_rate = priv->active_rate;
-	lq_sta->active_rate &= ~(0x1000);
+	lq_sta->active_legacy_rate = priv->active_rate & ~(0x1000);
 	lq_sta->active_rate_basic = priv->active_rate_basic;
 	lq_sta->band = priv->band;
 #ifdef CONFIG_IWL4965_HT
@@ -2326,7 +2307,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 
 static void rs_fill_link_cmd(const struct iwl_priv *priv,
 			     struct iwl4965_lq_sta *lq_sta,
-			     struct iwl4965_rate *tx_mcs,
+			     u32 new_rate,
 			     struct iwl_link_quality_cmd *lq_cmd)
 {
 	int index = 0;
@@ -2334,14 +2315,13 @@ static void rs_fill_link_cmd(const struct iwl_priv *priv,
 	int repeat_rate = 0;
 	u8 ant_toggle_count = 0;
 	u8 use_ht_possible = 1;
-	struct iwl4965_rate new_rate;
 	struct iwl4965_scale_tbl_info tbl_type = { 0 };
 
 	/* Override starting rate (index 0) if needed for debug purposes */
-	rs_dbgfs_set_mcs(lq_sta, tx_mcs, index);
+	rs_dbgfs_set_mcs(lq_sta, &new_rate, index);
 
-	/* Interpret rate_n_flags */
-	rs_get_tbl_info_from_mcs(tx_mcs, lq_sta->band,
+	/* Interpret new_rate (rate_n_flags) */
+	rs_get_tbl_info_from_mcs(new_rate, lq_sta->band,
 				  &tbl_type, &rate_idx);
 
 	/* How many times should we repeat the initial rate? */
@@ -2355,9 +2335,7 @@ static void rs_fill_link_cmd(const struct iwl_priv *priv,
 			is_mimo(tbl_type.lq_type) ? 1 : 0;
 
 	/* Fill 1st table entry (index 0) */
-	lq_cmd->rs_table[index].rate_n_flags =
-			cpu_to_le32(tx_mcs->rate_n_flags);
-	new_rate.rate_n_flags = tx_mcs->rate_n_flags;
+	lq_cmd->rs_table[index].rate_n_flags = cpu_to_le32(new_rate);
 
 	/*FIXME:RS*/
 	if (is_mimo(tbl_type.lq_type) || (tbl_type.ant_type == ANT_A))
@@ -2393,12 +2371,12 @@ static void rs_fill_link_cmd(const struct iwl_priv *priv,
 
 			/* Fill next table entry */
 			lq_cmd->rs_table[index].rate_n_flags =
-					cpu_to_le32(new_rate.rate_n_flags);
+					cpu_to_le32(new_rate);
 			repeat_rate--;
 			index++;
 		}
 
-		rs_get_tbl_info_from_mcs(&new_rate, lq_sta->band, &tbl_type,
+		rs_get_tbl_info_from_mcs(new_rate, lq_sta->band, &tbl_type,
 						&rate_idx);
 
 		/* Indicate to uCode which entries might be MIMO.
@@ -2408,8 +2386,8 @@ static void rs_fill_link_cmd(const struct iwl_priv *priv,
 			lq_cmd->general_params.mimo_delimiter = index;
 
 		/* Get next rate */
-		rs_get_lower_rate(lq_sta, &tbl_type, rate_idx,
-				  use_ht_possible, &new_rate);
+		new_rate = rs_get_lower_rate(lq_sta, &tbl_type, rate_idx,
+					     use_ht_possible);
 
 		/* How many times should we repeat the next rate? */
 		if (is_legacy(tbl_type.lq_type)) {
@@ -2433,8 +2411,7 @@ static void rs_fill_link_cmd(const struct iwl_priv *priv,
 		rs_dbgfs_set_mcs(lq_sta, &new_rate, index);
 
 		/* Fill next table entry */
-		lq_cmd->rs_table[index].rate_n_flags =
-				cpu_to_le32(new_rate.rate_n_flags);
+		lq_cmd->rs_table[index].rate_n_flags = cpu_to_le32(new_rate);
 
 		index++;
 		repeat_rate--;
@@ -2483,25 +2460,21 @@ static int open_file_generic(struct inode *inode, struct file *file)
 	return 0;
 }
 static void rs_dbgfs_set_mcs(struct iwl4965_lq_sta *lq_sta,
-				struct iwl4965_rate *mcs, int index)
+				u32 *rate_n_flags, int index)
 {
-	u32 base_rate;
-
-	if (lq_sta->band == IEEE80211_BAND_5GHZ)
-		base_rate = 0x800D;
-	else
-		base_rate = 0x820A;
-
-	if (lq_sta->dbg_fixed.rate_n_flags) {
-		if (index < 12)
-			mcs->rate_n_flags = lq_sta->dbg_fixed.rate_n_flags;
-		else
-			mcs->rate_n_flags = base_rate;
+	if (lq_sta->dbg_fixed_rate) {
+		if (index < 12) {
+			*rate_n_flags = lq_sta->dbg_fixed_rate;
+		} else {
+			if (lq_sta->band == IEEE80211_BAND_5GHZ)
+				*rate_n_flags = 0x800D;
+			else
+				*rate_n_flags = 0x820A;
+		}
 		IWL_DEBUG_RATE("Fixed rate ON\n");
-		return;
+	} else {
+		IWL_DEBUG_RATE("Fixed rate OFF\n");
 	}
-
-	IWL_DEBUG_RATE("Fixed rate OFF\n");
 }
 
 static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
@@ -2518,20 +2491,21 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 		return -EFAULT;
 
 	if (sscanf(buf, "%x", &parsed_rate) == 1)
-		lq_sta->dbg_fixed.rate_n_flags = parsed_rate;
+		lq_sta->dbg_fixed_rate = parsed_rate;
 	else
-		lq_sta->dbg_fixed.rate_n_flags = 0;
+		lq_sta->dbg_fixed_rate = 0;
 
-	lq_sta->active_rate = 0x0FFF;	/* 1 - 54 MBits, includes CCK */
-	lq_sta->active_siso_rate = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
-	lq_sta->active_mimo2_rate = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
-	lq_sta->active_mimo3_rate = 0x1FD0;     /* 6 - 60 MBits, no 9, no CCK */
+	lq_sta->active_legacy_rate = 0x0FFF;	/* 1 - 54 MBits, includes CCK */
+	lq_sta->active_siso_rate   = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
+	lq_sta->active_mimo2_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
+	lq_sta->active_mimo3_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 
 	IWL_DEBUG_RATE("sta_id %d rate 0x%X\n",
-		lq_sta->lq.sta_id, lq_sta->dbg_fixed.rate_n_flags);
+		lq_sta->lq.sta_id, lq_sta->dbg_fixed_rate);
 
-	if (lq_sta->dbg_fixed.rate_n_flags) {
-		rs_fill_link_cmd(NULL, lq_sta, &lq_sta->dbg_fixed, &lq_sta->lq);
+	if (lq_sta->dbg_fixed_rate) {
+		rs_fill_link_cmd(NULL, lq_sta, lq_sta->dbg_fixed_rate,
+								&lq_sta->lq);
 		iwl_send_lq_cmd(lq_sta->drv, &lq_sta->lq, CMD_ASYNC);
 	}
 
@@ -2550,9 +2524,9 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	desc += sprintf(buff+desc, "sta_id %d\n", lq_sta->lq.sta_id);
 	desc += sprintf(buff+desc, "failed=%d success=%d rate=0%X\n",
 			lq_sta->total_failed, lq_sta->total_success,
-			lq_sta->active_rate);
+			lq_sta->active_legacy_rate);
 	desc += sprintf(buff+desc, "fixed rate 0x%X\n",
-			lq_sta->dbg_fixed.rate_n_flags);
+			lq_sta->dbg_fixed_rate);
 	desc += sprintf(buff+desc, "general:"
 		"flags=0x%X mimo-d=%d s-ant0x%x d-ant=0x%x\n",
 		lq_sta->lq.general_params.flags,
@@ -2602,7 +2576,7 @@ static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 				lq_sta->lq_info[i].is_SGI,
 				lq_sta->lq_info[i].is_fat,
 				lq_sta->lq_info[i].is_dup,
-				lq_sta->lq_info[i].current_rate.rate_n_flags);
+				lq_sta->lq_info[i].current_rate);
 		for (j = 0; j < IWL_RATE_COUNT; j++) {
 			desc += sprintf(buff+desc,
 				"counter=%d success=%d %%=%d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 5299ba3..8403e9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1073,17 +1073,29 @@ unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 	return priv->ibss_beacon->len;
 }
 
-static u8 iwl4965_rate_get_lowest_plcp(int rate_mask)
+static u8 iwl4965_rate_get_lowest_plcp(struct iwl_priv *priv)
 {
-	u8 i;
+	int i;
+	int rate_mask;
+
+	/* Set rate mask*/
+	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
+		rate_mask = priv->active_rate_basic & 0xF;
+	else
+		rate_mask = priv->active_rate_basic & 0xFF0;
 
+	/* Find lowest valid rate */
 	for (i = IWL_RATE_1M_INDEX; i != IWL_RATE_INVALID;
-	     i = iwl4965_rates[i].next_ieee) {
+					i = iwl4965_rates[i].next_ieee) {
 		if (rate_mask & (1 << i))
 			return iwl4965_rates[i].plcp;
 	}
 
-	return IWL_RATE_INVALID;
+	/* No valid rate was found. Assign the lowest one */
+	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
+		return IWL_RATE_1M_PLCP;
+	else
+		return IWL_RATE_6M_PLCP;
 }
 
 static int iwl4965_send_beacon_cmd(struct iwl_priv *priv)
@@ -1101,16 +1113,7 @@ static int iwl4965_send_beacon_cmd(struct iwl_priv *priv)
 		return -ENOMEM;
 	}
 
-	if (!(priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)) {
-		rate = iwl4965_rate_get_lowest_plcp(priv->active_rate_basic &
-						0xFF0);
-		if (rate == IWL_INVALID_RATE)
-			rate = IWL_RATE_6M_PLCP;
-	} else {
-		rate = iwl4965_rate_get_lowest_plcp(priv->active_rate_basic & 0xF);
-		if (rate == IWL_INVALID_RATE)
-			rate = IWL_RATE_1M_PLCP;
-	}
+	rate = iwl4965_rate_get_lowest_plcp(priv);
 
 	frame_size = iwl4965_hw_get_beacon_cmd(priv, frame, rate);
 
-- 
1.5.3.4

