Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51976 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758823Ab3LBU7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 15:59:52 -0500
Received: by mail-wi0-f172.google.com with SMTP id en1so5504768wid.11
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 12:59:51 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/13] iwlwifi: mvm: rs: refactor to use rs_rate
Date: Mon,  2 Dec 2013 22:59:19 +0200
Message-Id: <1386017965-13641-7-git-send-email-egrumbach@gmail.com> (sfid-20131202_220009_628479_4F512CBA)
In-Reply-To: <529CF2D6.1080008@gmail.com>
References: <529CF2D6.1080008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Introduce rs_rate which represents a rate. Use this structure
instead of iwl_scale_tbl_info where we're dealing with a single
rate.
This avoids allocating the big iwl_scale_tbl_info structure
on the stack in several cases like converting to ucode rate
format or from ucode rate format.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |  568 +++++++++++++++++----------------
 drivers/net/wireless/iwlwifi/mvm/rs.h |   60 ++--
 2 files changed, 331 insertions(+), 297 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 0598f26..3af9062 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -175,6 +175,7 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 			     struct iwl_lq_sta *lq_sta, u32 rate_n_flags);
 static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search);
 static const char *rs_pretty_lq_type(enum iwl_table_type type);
+static const char *rs_pretty_ant(u8 ant);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
@@ -264,6 +265,15 @@ static const struct iwl_rate_mcs_info iwl_rate_mcs[IWL_RATE_COUNT] = {
 
 #define MCS_INDEX_PER_STREAM	(8)
 
+static inline void rs_dump_rate(struct iwl_mvm *mvm, const struct rs_rate *rate,
+				const char *prefix)
+{
+	IWL_DEBUG_RATE(mvm, "%s: (%s: %d) ANT: %s BW: %d SGI: %d\n",
+		       prefix, rs_pretty_lq_type(rate->type),
+		       rate->index, rs_pretty_ant(rate->ant),
+		       rate->bw, rate->sgi);
+}
+
 static void rs_rate_scale_clear_window(struct iwl_rate_scale_data *window)
 {
 	window->data = 0;
@@ -430,167 +440,160 @@ static int rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
 	return 0;
 }
 
-/*
- * Fill uCode API rate_n_flags field, based on "search" or "active" table.
- */
-/* FIXME:RS:remove this function and put the flags statically in the table */
-static u32 rate_n_flags_from_tbl(struct iwl_mvm *mvm,
-				 struct iwl_scale_tbl_info *tbl, int index)
+/* Convert rs_rate object into ucode rate bitmask */
+static u32 ucode_rate_from_rs_rate(struct iwl_mvm *mvm,
+				   struct rs_rate *rate)
 {
-	u32 rate_n_flags = 0;
+	u32 ucode_rate = 0;
+	int index = rate->index;
 
-	rate_n_flags |= ((tbl->ant_type << RATE_MCS_ANT_POS) &
+	ucode_rate |= ((rate->ant << RATE_MCS_ANT_POS) &
 			 RATE_MCS_ANT_ABC_MSK);
 
-	if (is_legacy(tbl->lq_type)) {
-		rate_n_flags |= iwl_rates[index].plcp;
+	if (is_legacy(rate)) {
+		ucode_rate |= iwl_rates[index].plcp;
 		if (index >= IWL_FIRST_CCK_RATE && index <= IWL_LAST_CCK_RATE)
-			rate_n_flags |= RATE_MCS_CCK_MSK;
-		return rate_n_flags;
+			ucode_rate |= RATE_MCS_CCK_MSK;
+		return ucode_rate;
 	}
 
-	if (is_ht(tbl->lq_type)) {
+	if (is_ht(rate)) {
 		if (index < IWL_FIRST_HT_RATE || index > IWL_LAST_HT_RATE) {
 			IWL_ERR(mvm, "Invalid HT rate index %d\n", index);
 			index = IWL_LAST_HT_RATE;
 		}
-		rate_n_flags |= RATE_MCS_HT_MSK;
+		ucode_rate |= RATE_MCS_HT_MSK;
 
-		if (is_ht_siso(tbl->lq_type))
-			rate_n_flags |=	iwl_rates[index].plcp_ht_siso;
-		else if (is_ht_mimo2(tbl->lq_type))
-			rate_n_flags |=	iwl_rates[index].plcp_ht_mimo2;
+		if (is_ht_siso(rate))
+			ucode_rate |= iwl_rates[index].plcp_ht_siso;
+		else if (is_ht_mimo2(rate))
+			ucode_rate |= iwl_rates[index].plcp_ht_mimo2;
 		else
 			WARN_ON_ONCE(1);
-	} else if (is_vht(tbl->lq_type)) {
+	} else if (is_vht(rate)) {
 		if (index < IWL_FIRST_VHT_RATE || index > IWL_LAST_VHT_RATE) {
 			IWL_ERR(mvm, "Invalid VHT rate index %d\n", index);
 			index = IWL_LAST_VHT_RATE;
 		}
-		rate_n_flags |= RATE_MCS_VHT_MSK;
-		if (is_vht_siso(tbl->lq_type))
-			rate_n_flags |=	iwl_rates[index].plcp_vht_siso;
-		else if (is_vht_mimo2(tbl->lq_type))
-			rate_n_flags |=	iwl_rates[index].plcp_vht_mimo2;
+		ucode_rate |= RATE_MCS_VHT_MSK;
+		if (is_vht_siso(rate))
+			ucode_rate |= iwl_rates[index].plcp_vht_siso;
+		else if (is_vht_mimo2(rate))
+			ucode_rate |= iwl_rates[index].plcp_vht_mimo2;
 		else
 			WARN_ON_ONCE(1);
 
 	} else {
-		IWL_ERR(mvm, "Invalid tbl->lq_type %d\n", tbl->lq_type);
+		IWL_ERR(mvm, "Invalid rate->type %d\n", rate->type);
 	}
 
-	rate_n_flags |= tbl->bw;
-	if (tbl->is_SGI)
-		rate_n_flags |= RATE_MCS_SGI_MSK;
+	ucode_rate |= rate->bw;
+	if (rate->sgi)
+		ucode_rate |= RATE_MCS_SGI_MSK;
 
-	return rate_n_flags;
+	return ucode_rate;
 }
 
-/*
- * Interpret uCode API's rate_n_flags format,
- * fill "search" or "active" tx mode table.
- */
-static int rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
-				    enum ieee80211_band band,
-				    struct iwl_scale_tbl_info *tbl,
-				    int *rate_idx)
+/* Convert a ucode rate into an rs_rate object */
+static int rs_rate_from_ucode_rate(const u32 ucode_rate,
+				   enum ieee80211_band band,
+				   struct rs_rate *rate)
 {
-	u32 ant_msk = (rate_n_flags & RATE_MCS_ANT_ABC_MSK);
-	u8 num_of_ant = get_num_of_ant_from_rate(rate_n_flags);
+	u32 ant_msk = ucode_rate & RATE_MCS_ANT_ABC_MSK;
+	u8 num_of_ant = get_num_of_ant_from_rate(ucode_rate);
 	u8 nss;
 
-	memset(tbl, 0, offsetof(struct iwl_scale_tbl_info, win));
-	*rate_idx = iwl_hwrate_to_plcp_idx(rate_n_flags);
+	memset(rate, 0, sizeof(struct rs_rate));
+	rate->index = iwl_hwrate_to_plcp_idx(ucode_rate);
 
-	if (*rate_idx  == IWL_RATE_INVALID) {
-		*rate_idx = -1;
+	if (rate->index == IWL_RATE_INVALID) {
+		rate->index = -1;
 		return -EINVAL;
 	}
-	tbl->is_SGI = 0;	/* default legacy setup */
-	tbl->bw = 0;
-	tbl->ant_type = (ant_msk >> RATE_MCS_ANT_POS);
-	tbl->lq_type = LQ_NONE;
-	tbl->max_search = IWL_MAX_SEARCH;
+
+	rate->ant = (ant_msk >> RATE_MCS_ANT_POS);
 
 	/* Legacy */
-	if (!(rate_n_flags & RATE_MCS_HT_MSK) &&
-	    !(rate_n_flags & RATE_MCS_VHT_MSK)) {
+	if (!(ucode_rate & RATE_MCS_HT_MSK) &&
+	    !(ucode_rate & RATE_MCS_VHT_MSK)) {
 		if (num_of_ant == 1) {
 			if (band == IEEE80211_BAND_5GHZ)
-				tbl->lq_type = LQ_LEGACY_A;
+				rate->type = LQ_LEGACY_A;
 			else
-				tbl->lq_type = LQ_LEGACY_G;
+				rate->type = LQ_LEGACY_G;
 		}
 
 		return 0;
 	}
 
 	/* HT or VHT */
-	if (rate_n_flags & RATE_MCS_SGI_MSK)
-		tbl->is_SGI = 1;
+	if (ucode_rate & RATE_MCS_SGI_MSK)
+		rate->sgi = true;
 
-	tbl->bw = rate_n_flags & RATE_MCS_CHAN_WIDTH_MSK;
+	rate->bw = ucode_rate & RATE_MCS_CHAN_WIDTH_MSK;
 
-	if (rate_n_flags & RATE_MCS_HT_MSK) {
-		nss = ((rate_n_flags & RATE_HT_MCS_NSS_MSK) >>
+	if (ucode_rate & RATE_MCS_HT_MSK) {
+		nss = ((ucode_rate & RATE_HT_MCS_NSS_MSK) >>
 		       RATE_HT_MCS_NSS_POS) + 1;
 
 		if (nss == 1) {
-			tbl->lq_type = LQ_HT_SISO;
+			rate->type = LQ_HT_SISO;
 			WARN_ON_ONCE(num_of_ant != 1);
 		} else if (nss == 2) {
-			tbl->lq_type = LQ_HT_MIMO2;
+			rate->type = LQ_HT_MIMO2;
 			WARN_ON_ONCE(num_of_ant != 2);
 		} else {
 			WARN_ON_ONCE(1);
 		}
-	} else if (rate_n_flags & RATE_MCS_VHT_MSK) {
-		nss = ((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
+	} else if (ucode_rate & RATE_MCS_VHT_MSK) {
+		nss = ((ucode_rate & RATE_VHT_MCS_NSS_MSK) >>
 		       RATE_VHT_MCS_NSS_POS) + 1;
 
 		if (nss == 1) {
-			tbl->lq_type = LQ_VHT_SISO;
+			rate->type = LQ_VHT_SISO;
 			WARN_ON_ONCE(num_of_ant != 1);
 		} else if (nss == 2) {
-			tbl->lq_type = LQ_VHT_MIMO2;
+			rate->type = LQ_VHT_MIMO2;
 			WARN_ON_ONCE(num_of_ant != 2);
 		} else {
 			WARN_ON_ONCE(1);
 		}
 	}
 
-	WARN_ON_ONCE(tbl->bw == RATE_MCS_CHAN_WIDTH_160);
-	WARN_ON_ONCE(tbl->bw == RATE_MCS_CHAN_WIDTH_80 &&
-		     !is_vht(tbl->lq_type));
+	WARN_ON_ONCE(rate->bw == RATE_MCS_CHAN_WIDTH_160);
+	WARN_ON_ONCE(rate->bw == RATE_MCS_CHAN_WIDTH_80 &&
+		     !is_vht(rate));
 
 	return 0;
 }
 
 /* switch to another antenna/antennas and return 1 */
 /* if no other valid antenna found, return 0 */
-static int rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
-			     struct iwl_scale_tbl_info *tbl)
+static int rs_toggle_antenna(u32 valid_ant, u32 *ucode_rate,
+			     struct rs_rate *rate)
 {
 	u8 new_ant_type;
 
-	if (!tbl->ant_type || tbl->ant_type > ANT_ABC)
+	if (!rate->ant || rate->ant > ANT_ABC)
 		return 0;
 
-	if (!rs_is_valid_ant(valid_ant, tbl->ant_type))
+	if (!rs_is_valid_ant(valid_ant, rate->ant))
 		return 0;
 
-	new_ant_type = ant_toggle_lookup[tbl->ant_type];
+	new_ant_type = ant_toggle_lookup[rate->ant];
 
-	while ((new_ant_type != tbl->ant_type) &&
+	while ((new_ant_type != rate->ant) &&
 	       !rs_is_valid_ant(valid_ant, new_ant_type))
 		new_ant_type = ant_toggle_lookup[new_ant_type];
 
-	if (new_ant_type == tbl->ant_type)
+	if (new_ant_type == rate->ant)
 		return 0;
 
-	tbl->ant_type = new_ant_type;
-	*rate_n_flags &= ~RATE_MCS_ANT_ABC_MSK;
-	*rate_n_flags |= new_ant_type << RATE_MCS_ANT_POS;
+	rate->ant = new_ant_type;
+
+	/* TODO: get rid of ucode_rate here. This should handle only rs_rate */
+	*ucode_rate &= ~RATE_MCS_ANT_ABC_MSK;
+	*ucode_rate |= new_ant_type << RATE_MCS_ANT_POS;
 	return 1;
 }
 
@@ -603,13 +606,13 @@ static int rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
  */
 static u16 rs_get_supported_rates(struct iwl_lq_sta *lq_sta,
 				  struct ieee80211_hdr *hdr,
-				  enum iwl_table_type rate_type)
+				  struct rs_rate *rate)
 {
-	if (is_legacy(rate_type))
+	if (is_legacy(rate))
 		return lq_sta->active_legacy_rate;
-	else if (is_siso(rate_type))
+	else if (is_siso(rate))
 		return lq_sta->active_siso_rate;
-	else if (is_mimo2(rate_type))
+	else if (is_mimo2(rate))
 		return lq_sta->active_mimo2_rate;
 
 	WARN_ON_ONCE(1);
@@ -624,7 +627,7 @@ static u16 rs_get_adjacent_rate(struct iwl_mvm *mvm, u8 index, u16 rate_mask,
 
 	/* 802.11A or ht walks to the next literal adjacent rate in
 	 * the rate table */
-	if (is_a_band(rate_type) || !is_legacy(rate_type)) {
+	if (is_type_a_band(rate_type) || !is_type_legacy(rate_type)) {
 		int i;
 		u32 mask;
 
@@ -673,7 +676,7 @@ static u16 rs_get_adjacent_rate(struct iwl_mvm *mvm, u8 index, u16 rate_mask,
 }
 
 static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
-			     struct iwl_scale_tbl_info *tbl,
+			     struct rs_rate *rate,
 			     u8 scale_index, u8 ht_possible)
 {
 	s32 low;
@@ -685,30 +688,29 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 	/* check if we need to switch from HT to legacy rates.
 	 * assumption is that mandatory rates (1Mbps or 6Mbps)
 	 * are always supported (spec demand) */
-	if (!is_legacy(tbl->lq_type) && (!ht_possible || !scale_index)) {
+	if (!is_legacy(rate) && (!ht_possible || !scale_index)) {
 		switch_to_legacy = 1;
 		scale_index = rs_ht_to_legacy[scale_index];
 		if (lq_sta->band == IEEE80211_BAND_5GHZ)
-			tbl->lq_type = LQ_LEGACY_A;
+			rate->type = LQ_LEGACY_A;
 		else
-			tbl->lq_type = LQ_LEGACY_G;
+			rate->type = LQ_LEGACY_G;
 
-		if (num_of_ant(tbl->ant_type) > 1)
-			tbl->ant_type =
+		if (num_of_ant(rate->ant) > 1)
+			rate->ant =
 			    first_antenna(iwl_fw_valid_tx_ant(mvm->fw));
 
-		tbl->bw = 0;
-		tbl->is_SGI = 0;
-		tbl->max_search = IWL_MAX_SEARCH;
+		rate->bw = 0;
+		rate->sgi = false;
 	}
 
-	rate_mask = rs_get_supported_rates(lq_sta, NULL, tbl->lq_type);
+	rate_mask = rs_get_supported_rates(lq_sta, NULL, rate);
 
 	/* Mask with station rate restriction */
-	if (is_legacy(tbl->lq_type)) {
+	if (is_legacy(rate)) {
 		/* supp_rates has no CCK bits in A mode */
 		if (lq_sta->band == IEEE80211_BAND_5GHZ)
-			rate_mask  = (u16)(rate_mask &
+			rate_mask = (u16)(rate_mask &
 			   (lq_sta->supp_rates << IWL_FIRST_OFDM_RATE));
 		else
 			rate_mask = (u16)(rate_mask & lq_sta->supp_rates);
@@ -721,24 +723,22 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 	}
 
 	high_low = rs_get_adjacent_rate(lq_sta->drv, scale_index, rate_mask,
-					tbl->lq_type);
+					rate->type);
 	low = high_low & 0xff;
 
 	if (low == IWL_RATE_INVALID)
 		low = scale_index;
 
 out:
-	return rate_n_flags_from_tbl(lq_sta->drv, tbl, low);
+	rate->index = low;
+	return ucode_rate_from_rs_rate(lq_sta->drv, rate);
 }
 
-/*
- * Simple function to compare two rate scale table types
- */
-static bool table_type_matches(struct iwl_scale_tbl_info *a,
-			       struct iwl_scale_tbl_info *b)
+/* Simple function to compare two rate scale table types */
+static inline bool rs_rate_match(struct rs_rate *a,
+				 struct rs_rate *b)
 {
-	return (a->lq_type == b->lq_type) && (a->ant_type == b->ant_type) &&
-		(a->is_SGI == b->is_SGI);
+	return (a->type == b->type) && (a->ant == b->ant) && (a->sgi == b->sgi);
 }
 
 static u32 rs_ch_width_from_mac_flags(enum mac80211_rate_control_flags flags)
@@ -762,7 +762,7 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 {
 	int legacy_success;
 	int retries;
-	int rs_index, mac_index, i;
+	int mac_index, i;
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	struct iwl_lq_cmd *table;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -770,8 +770,8 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	enum mac80211_rate_control_flags mac_flags;
-	u32 tx_rate;
-	struct iwl_scale_tbl_info tbl_type;
+	u32 ucode_rate;
+	struct rs_rate rate;
 	struct iwl_scale_tbl_info *curr_tbl, *other_tbl, *tmp_tbl;
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
@@ -801,10 +801,10 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 	 * to a new "search" mode (which might become the new "active" mode).
 	 */
 	table = &lq_sta->lq;
-	tx_rate = le32_to_cpu(table->rs_table[0]);
-	rs_get_tbl_info_from_mcs(tx_rate, info->band, &tbl_type, &rs_index);
+	ucode_rate = le32_to_cpu(table->rs_table[0]);
+	rs_rate_from_ucode_rate(ucode_rate, info->band, &rate);
 	if (info->band == IEEE80211_BAND_5GHZ)
-		rs_index -= IWL_FIRST_OFDM_RATE;
+		rate.index -= IWL_FIRST_OFDM_RATE;
 	mac_flags = info->status.rates[0].flags;
 	mac_index = info->status.rates[0].idx;
 	/* For HT packets, map MCS to PLCP */
@@ -827,19 +827,19 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 
 	/* Here we actually compare this rate to the latest LQ command */
 	if ((mac_index < 0) ||
-	    (tbl_type.is_SGI != !!(mac_flags & IEEE80211_TX_RC_SHORT_GI)) ||
-	    (tbl_type.bw != rs_ch_width_from_mac_flags(mac_flags)) ||
-	    (tbl_type.ant_type != info->status.antenna) ||
-	    (!!(tx_rate & RATE_MCS_HT_MSK) !=
+	    (rate.sgi != !!(mac_flags & IEEE80211_TX_RC_SHORT_GI)) ||
+	    (rate.bw != rs_ch_width_from_mac_flags(mac_flags)) ||
+	    (rate.ant != info->status.antenna) ||
+	    (!!(ucode_rate & RATE_MCS_HT_MSK) !=
 	     !!(mac_flags & IEEE80211_TX_RC_MCS)) ||
-	    (!!(tx_rate & RATE_MCS_VHT_MSK) !=
+	    (!!(ucode_rate & RATE_MCS_VHT_MSK) !=
 	     !!(mac_flags & IEEE80211_TX_RC_VHT_MCS)) ||
-	    (!!(tx_rate & RATE_HT_MCS_GF_MSK) !=
+	    (!!(ucode_rate & RATE_HT_MCS_GF_MSK) !=
 	     !!(mac_flags & IEEE80211_TX_RC_GREEN_FIELD)) ||
-	    (rs_index != mac_index)) {
+	    (rate.index != mac_index)) {
 		IWL_DEBUG_RATE(mvm,
 			       "initial rate %d does not match %d (0x%x)\n",
-			       mac_index, rs_index, tx_rate);
+			       mac_index, rate.index, ucode_rate);
 		/*
 		 * Since rates mis-match, the last LQ command may have failed.
 		 * After IWL_MISSED_RATE_MAX mis-matches, resync the uCode with
@@ -857,28 +857,23 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 		lq_sta->missed_rate_counter = 0;
 
 	/* Figure out if rate scale algorithm is in active or search table */
-	if (table_type_matches(&tbl_type,
-			       &(lq_sta->lq_info[lq_sta->active_tbl]))) {
+	if (rs_rate_match(&rate,
+			  &(lq_sta->lq_info[lq_sta->active_tbl].rate))) {
 		curr_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 		other_tbl = &(lq_sta->lq_info[1 - lq_sta->active_tbl]);
-	} else if (table_type_matches(
-			&tbl_type, &lq_sta->lq_info[1 - lq_sta->active_tbl])) {
+	} else if (rs_rate_match(&rate,
+			 &lq_sta->lq_info[1 - lq_sta->active_tbl].rate)) {
 		curr_tbl = &(lq_sta->lq_info[1 - lq_sta->active_tbl]);
 		other_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	} else {
 		IWL_DEBUG_RATE(mvm,
 			       "Neither active nor search matches tx rate\n");
 		tmp_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
-		IWL_DEBUG_RATE(mvm, "active- lq:%x, ant:%x, SGI:%d\n",
-			       tmp_tbl->lq_type, tmp_tbl->ant_type,
-			       tmp_tbl->is_SGI);
+		rs_dump_rate(mvm, &tmp_tbl->rate, "ACTIVE");
 		tmp_tbl = &(lq_sta->lq_info[1 - lq_sta->active_tbl]);
-		IWL_DEBUG_RATE(mvm, "search- lq:%x, ant:%x, SGI:%d\n",
-			       tmp_tbl->lq_type, tmp_tbl->ant_type,
-			       tmp_tbl->is_SGI);
-		IWL_DEBUG_RATE(mvm, "actual- lq:%x, ant:%x, SGI:%d\n",
-			       tbl_type.lq_type, tbl_type.ant_type,
-			       tbl_type.is_SGI);
+		rs_dump_rate(mvm, &tmp_tbl->rate, "SEARCH");
+		rs_dump_rate(mvm, &rate, "ACTUAL");
+
 		/*
 		 * no matching table found, let's by-pass the data collection
 		 * and continue to perform rate scale to find the rate table
@@ -895,10 +890,9 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 	 * first index into rate scale table.
 	 */
 	if (info->flags & IEEE80211_TX_STAT_AMPDU) {
-		tx_rate = le32_to_cpu(table->rs_table[0]);
-		rs_get_tbl_info_from_mcs(tx_rate, info->band, &tbl_type,
-					 &rs_index);
-		rs_collect_tx_data(curr_tbl, rs_index,
+		ucode_rate = le32_to_cpu(table->rs_table[0]);
+		rs_rate_from_ucode_rate(ucode_rate, info->band, &rate);
+		rs_collect_tx_data(curr_tbl, rate.index,
 				   info->status.ampdu_len,
 				   info->status.ampdu_ack_len);
 
@@ -920,20 +914,19 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 		legacy_success = !!(info->flags & IEEE80211_TX_STAT_ACK);
 		/* Collect data for each rate used during failed TX attempts */
 		for (i = 0; i <= retries; ++i) {
-			tx_rate = le32_to_cpu(table->rs_table[i]);
-			rs_get_tbl_info_from_mcs(tx_rate, info->band,
-						 &tbl_type, &rs_index);
+			ucode_rate = le32_to_cpu(table->rs_table[i]);
+			rs_rate_from_ucode_rate(ucode_rate, info->band, &rate);
 			/*
 			 * Only collect stats if retried rate is in the same RS
 			 * table as active/search.
 			 */
-			if (table_type_matches(&tbl_type, curr_tbl))
+			if (rs_rate_match(&rate, &curr_tbl->rate))
 				tmp_tbl = curr_tbl;
-			else if (table_type_matches(&tbl_type, other_tbl))
+			else if (rs_rate_match(&rate, &other_tbl->rate))
 				tmp_tbl = other_tbl;
 			else
 				continue;
-			rs_collect_tx_data(tmp_tbl, rs_index, 1,
+			rs_collect_tx_data(tmp_tbl, rate.index, 1,
 					   i < retries ? 0 : legacy_success);
 		}
 
@@ -944,7 +937,7 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 		}
 	}
 	/* The last TX rate is cached in lq_sta; it's set in if/else above */
-	lq_sta->last_rate_n_flags = tx_rate;
+	lq_sta->last_rate_n_flags = ucode_rate;
 done:
 	/* See if there's a better rate or modulation mode to try. */
 	if (sta && sta->supp_rates[sband->band])
@@ -988,16 +981,17 @@ static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 {
 	/* Used to choose among HT tables */
 	s32 (*ht_tbl_pointer)[IWL_RATE_COUNT];
+	struct rs_rate *rate = &tbl->rate;
 
 	/* Check for invalid LQ type */
-	if (WARN_ON_ONCE(!is_legacy(tbl->lq_type) && !is_ht(tbl->lq_type) &&
-			 !(is_vht(tbl->lq_type)))) {
+	if (WARN_ON_ONCE(!is_legacy(rate) && !is_ht(rate) &&
+			 !(is_vht(rate)))) {
 		tbl->expected_tpt = expected_tpt_legacy;
 		return;
 	}
 
 	/* Legacy rates have only one table */
-	if (is_legacy(tbl->lq_type)) {
+	if (is_legacy(rate)) {
 		tbl->expected_tpt = expected_tpt_legacy;
 		return;
 	}
@@ -1006,8 +1000,8 @@ static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 	/* Choose among many HT tables depending on number of streams
 	 * (SISO/MIMO2), channel width (20/40/80), SGI, and aggregation
 	 * status */
-	if (is_siso(tbl->lq_type)) {
-		switch (tbl->bw) {
+	if (is_siso(rate)) {
+		switch (rate->bw) {
 		case RATE_MCS_CHAN_WIDTH_20:
 			ht_tbl_pointer = expected_tpt_siso_20MHz;
 			break;
@@ -1020,8 +1014,8 @@ static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 		default:
 			WARN_ON_ONCE(1);
 		}
-	} else if (is_mimo2(tbl->lq_type)) {
-		switch (tbl->bw) {
+	} else if (is_mimo2(rate)) {
+		switch (rate->bw) {
 		case RATE_MCS_CHAN_WIDTH_20:
 			ht_tbl_pointer = expected_tpt_mimo2_20MHz;
 			break;
@@ -1038,11 +1032,11 @@ static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 		WARN_ON_ONCE(1);
 	}
 
-	if (!tbl->is_SGI && !lq_sta->is_agg)		/* Normal */
+	if (!rate->sgi && !lq_sta->is_agg)		/* Normal */
 		tbl->expected_tpt = ht_tbl_pointer[0];
-	else if (tbl->is_SGI && !lq_sta->is_agg)	/* SGI */
+	else if (rate->sgi && !lq_sta->is_agg)	        /* SGI */
 		tbl->expected_tpt = ht_tbl_pointer[1];
-	else if (!tbl->is_SGI && lq_sta->is_agg)	/* AGG */
+	else if (!rate->sgi && lq_sta->is_agg)	        /* AGG */
 		tbl->expected_tpt = ht_tbl_pointer[2];
 	else						/* AGG+SGI */
 		tbl->expected_tpt = ht_tbl_pointer[3];
@@ -1082,7 +1076,7 @@ static s32 rs_get_best_rate(struct iwl_mvm *mvm,
 
 	while (1) {
 		high_low = rs_get_adjacent_rate(mvm, rate, rate_mask,
-						tbl->lq_type);
+						tbl->rate.type);
 
 		low = high_low & 0xff;
 		high = (high_low >> 8) & 0xff;
@@ -1163,30 +1157,29 @@ static inline void rs_move_next_action(struct iwl_scale_tbl_info *tbl,
 	tbl->action = (tbl->action + 1) % (last_action + 1);
 }
 
-static void rs_set_bw_from_sta(struct iwl_scale_tbl_info *tbl,
-			       struct ieee80211_sta *sta)
+static u32 rs_bw_from_sta_bw(struct ieee80211_sta *sta)
 {
 	if (sta->bandwidth >= IEEE80211_STA_RX_BW_80)
-		tbl->bw = RATE_MCS_CHAN_WIDTH_80;
+		return RATE_MCS_CHAN_WIDTH_80;
 	else if (sta->bandwidth >= IEEE80211_STA_RX_BW_40)
-		tbl->bw = RATE_MCS_CHAN_WIDTH_40;
-	else
-		tbl->bw = RATE_MCS_CHAN_WIDTH_20;
+		return RATE_MCS_CHAN_WIDTH_40;
+
+	return RATE_MCS_CHAN_WIDTH_20;
 }
 
-static bool rs_sgi_allowed(struct iwl_scale_tbl_info *tbl,
+static bool rs_sgi_allowed(struct rs_rate *rate,
 			   struct ieee80211_sta *sta)
 {
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
 
-	if (is_ht20(tbl) && (ht_cap->cap &
+	if (is_ht20(rate) && (ht_cap->cap &
 			     IEEE80211_HT_CAP_SGI_20))
 		return true;
-	if (is_ht40(tbl) && (ht_cap->cap &
+	if (is_ht40(rate) && (ht_cap->cap &
 			     IEEE80211_HT_CAP_SGI_40))
 		return true;
-	if (is_ht80(tbl) && (vht_cap->cap &
+	if (is_ht80(rate) && (vht_cap->cap &
 			     IEEE80211_VHT_CAP_SHORT_GI_80))
 		return true;
 
@@ -1202,7 +1195,7 @@ static int rs_switch_to_mimo2(struct iwl_mvm *mvm,
 			     struct iwl_scale_tbl_info *tbl, int index)
 {
 	u16 rate_mask;
-	s32 rate;
+	s32 rate_idx;
 
 	if (!sta->ht_cap.ht_supported)
 		return -1;
@@ -1216,24 +1209,26 @@ static int rs_switch_to_mimo2(struct iwl_mvm *mvm,
 
 	IWL_DEBUG_RATE(mvm, "LQ: try to switch to MIMO2\n");
 
-	tbl->lq_type = lq_sta->is_vht ? LQ_VHT_MIMO2 : LQ_HT_MIMO2;
+	tbl->rate.type = lq_sta->is_vht ? LQ_VHT_MIMO2 : LQ_HT_MIMO2;
 	tbl->action = 0;
 	tbl->max_search = IWL_MAX_SEARCH;
 	rate_mask = lq_sta->active_mimo2_rate;
 
-	rs_set_bw_from_sta(tbl, sta);
+	tbl->rate.bw = rs_bw_from_sta_bw(sta);
 	rs_set_expected_tpt_table(lq_sta, tbl);
 
-	rate = rs_get_best_rate(mvm, lq_sta, tbl, rate_mask, index);
+	rate_idx = rs_get_best_rate(mvm, lq_sta, tbl, rate_mask, index);
 
 	IWL_DEBUG_RATE(mvm, "LQ: MIMO2 best rate %d mask %X\n",
-		       rate, rate_mask);
-	if ((rate == IWL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
+		       rate_idx, rate_mask);
+	if ((rate_idx == IWL_RATE_INVALID) || !((1 << rate_idx) & rate_mask)) {
 		IWL_DEBUG_RATE(mvm, "Can't switch with index %d rate mask %x\n",
-			       rate, rate_mask);
+			       rate_idx, rate_mask);
 		return -1;
 	}
-	tbl->current_rate = rate_n_flags_from_tbl(mvm, tbl, rate);
+
+	tbl->rate.index = rate_idx;
+	tbl->current_rate = ucode_rate_from_rs_rate(mvm, &tbl->rate);
 
 	IWL_DEBUG_RATE(mvm, "LQ: Switch to new mcs %X index\n",
 		       tbl->current_rate);
@@ -1249,30 +1244,34 @@ static int rs_switch_to_siso(struct iwl_mvm *mvm,
 			     struct iwl_scale_tbl_info *tbl, int index)
 {
 	u16 rate_mask;
-	s32 rate;
+	s32 rate_idx;
 
 	if (!sta->ht_cap.ht_supported)
 		return -1;
 
 	IWL_DEBUG_RATE(mvm, "LQ: try to switch to SISO\n");
 
-	tbl->lq_type = lq_sta->is_vht ? LQ_VHT_SISO : LQ_HT_SISO;
+	tbl->rate.type = lq_sta->is_vht ? LQ_VHT_SISO : LQ_HT_SISO;
 	tbl->action = 0;
 	tbl->max_search = IWL_MAX_SEARCH;
 	rate_mask = lq_sta->active_siso_rate;
 
-	rs_set_bw_from_sta(tbl, sta);
+	tbl->rate.bw = rs_bw_from_sta_bw(sta);
 	rs_set_expected_tpt_table(lq_sta, tbl);
-	rate = rs_get_best_rate(mvm, lq_sta, tbl, rate_mask, index);
+	rate_idx = rs_get_best_rate(mvm, lq_sta, tbl, rate_mask, index);
 
-	IWL_DEBUG_RATE(mvm, "LQ: get best rate %d mask %X\n", rate, rate_mask);
-	if ((rate == IWL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
+	IWL_DEBUG_RATE(mvm, "LQ: get best rate %d mask %X\n",
+		       rate_idx, rate_mask);
+	if ((rate_idx == IWL_RATE_INVALID) || !((1 << rate_idx) & rate_mask)) {
 		IWL_DEBUG_RATE(mvm,
 			       "can not switch with index %d rate mask %x\n",
-			       rate, rate_mask);
+			       rate_idx, rate_mask);
 		return -1;
 	}
-	tbl->current_rate = rate_n_flags_from_tbl(mvm, tbl, rate);
+
+	tbl->rate.index = rate_idx;
+	tbl->current_rate = ucode_rate_from_rs_rate(mvm, &tbl->rate);
+
 	IWL_DEBUG_RATE(mvm, "LQ: Switch to new mcs %X index\n",
 		       tbl->current_rate);
 	return 0;
@@ -1289,6 +1288,7 @@ static int rs_move_legacy_other(struct iwl_mvm *mvm,
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct iwl_scale_tbl_info *search_tbl =
 				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
+	struct rs_rate *rate = &search_tbl->rate;
 	struct iwl_rate_scale_data *window = &(tbl->win[index]);
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
@@ -1317,7 +1317,7 @@ static int rs_move_legacy_other(struct iwl_mvm *mvm,
 
 			if (rs_toggle_antenna(valid_tx_ant,
 					      &search_tbl->current_rate,
-					      search_tbl)) {
+					      &search_tbl->rate)) {
 				update_search_tbl_counter = 1;
 				rs_set_expected_tpt_table(lq_sta, search_tbl);
 				goto out;
@@ -1328,7 +1328,7 @@ static int rs_move_legacy_other(struct iwl_mvm *mvm,
 
 			/* Set up search table to try SISO */
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->is_SGI = 0;
+			rate->sgi = false;
 			ret = rs_switch_to_siso(mvm, lq_sta, sta,
 						 search_tbl, index);
 			if (!ret) {
@@ -1342,12 +1342,11 @@ static int rs_move_legacy_other(struct iwl_mvm *mvm,
 
 			/* Set up search table to try MIMO */
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->is_SGI = 0;
-
-			search_tbl->ant_type = ANT_AB;
+			rate->sgi = false;
+			rate->ant = ANT_AB;
 
 			if (!rs_is_valid_ant(valid_tx_ant,
-					     search_tbl->ant_type))
+					     rate->ant))
 				break;
 
 			ret = rs_switch_to_mimo2(mvm, lq_sta, sta,
@@ -1365,7 +1364,7 @@ static int rs_move_legacy_other(struct iwl_mvm *mvm,
 		if (tbl->action == start_action)
 			break;
 	}
-	search_tbl->lq_type = LQ_NONE;
+	rate->type = LQ_NONE;
 	return 0;
 
 out:
@@ -1386,6 +1385,7 @@ static int rs_move_siso_to_other(struct iwl_mvm *mvm,
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct iwl_scale_tbl_info *search_tbl =
 				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
+	struct rs_rate *rate = &search_tbl->rate;
 	struct iwl_rate_scale_data *window = &(tbl->win[index]);
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
@@ -1416,7 +1416,7 @@ static int rs_move_siso_to_other(struct iwl_mvm *mvm,
 			memcpy(search_tbl, tbl, sz);
 			if (rs_toggle_antenna(valid_tx_ant,
 					      &search_tbl->current_rate,
-					      search_tbl)) {
+					      rate)) {
 				update_search_tbl_counter = 1;
 				goto out;
 			}
@@ -1424,12 +1424,11 @@ static int rs_move_siso_to_other(struct iwl_mvm *mvm,
 		case IWL_SISO_SWITCH_MIMO2:
 			IWL_DEBUG_RATE(mvm, "LQ: SISO switch to MIMO2\n");
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->is_SGI = 0;
-
-			search_tbl->ant_type = ANT_AB;
+			rate->sgi = false;
+			rate->ant = ANT_AB;
 
 			if (!rs_is_valid_ant(valid_tx_ant,
-					     search_tbl->ant_type))
+					     rate->ant))
 				break;
 
 			ret = rs_switch_to_mimo2(mvm, lq_sta, sta,
@@ -1438,21 +1437,22 @@ static int rs_move_siso_to_other(struct iwl_mvm *mvm,
 				goto out;
 			break;
 		case IWL_SISO_SWITCH_GI:
-			if (!rs_sgi_allowed(tbl, sta))
+			if (!rs_sgi_allowed(rate, sta))
 				break;
 
 			IWL_DEBUG_RATE(mvm, "LQ: SISO toggle SGI/NGI\n");
 
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->is_SGI = !tbl->is_SGI;
+			rate->sgi = !tbl->rate.sgi;
 			rs_set_expected_tpt_table(lq_sta, search_tbl);
-			if (tbl->is_SGI) {
+			if (tbl->rate.sgi) {
 				s32 tpt = lq_sta->last_tpt / 100;
 				if (tpt >= search_tbl->expected_tpt[index])
 					break;
 			}
+			rate->index = index;
 			search_tbl->current_rate =
-				rate_n_flags_from_tbl(mvm, search_tbl, index);
+				ucode_rate_from_rs_rate(mvm, rate);
 			update_search_tbl_counter = 1;
 			goto out;
 		default:
@@ -1463,7 +1463,7 @@ static int rs_move_siso_to_other(struct iwl_mvm *mvm,
 		if (tbl->action == start_action)
 			break;
 	}
-	search_tbl->lq_type = LQ_NONE;
+	rate->type = LQ_NONE;
 	return 0;
 
  out:
@@ -1485,6 +1485,7 @@ static int rs_move_mimo2_to_other(struct iwl_mvm *mvm,
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct iwl_scale_tbl_info *search_tbl =
 				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
+	struct rs_rate *rate = &search_tbl->rate;
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
@@ -1509,12 +1510,12 @@ static int rs_move_mimo2_to_other(struct iwl_mvm *mvm,
 			memcpy(search_tbl, tbl, sz);
 
 			if (tbl->action == IWL_MIMO2_SWITCH_SISO_A)
-				search_tbl->ant_type = ANT_A;
+				rate->ant = ANT_A;
 			else /* tbl->action == IWL_MIMO2_SWITCH_SISO_B */
-				search_tbl->ant_type = ANT_B;
+				rate->ant = ANT_B;
 
 			if (!rs_is_valid_ant(valid_tx_ant,
-					     search_tbl->ant_type))
+					     rate->ant))
 				break;
 
 			ret = rs_switch_to_siso(mvm, lq_sta, sta,
@@ -1525,14 +1526,14 @@ static int rs_move_mimo2_to_other(struct iwl_mvm *mvm,
 			break;
 
 		case IWL_MIMO2_SWITCH_GI:
-			if (!rs_sgi_allowed(tbl, sta))
+			if (!rs_sgi_allowed(rate, sta))
 				break;
 
 			IWL_DEBUG_RATE(mvm, "LQ: MIMO2 toggle SGI/NGI\n");
 
 			/* Set up new search table for MIMO2 */
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->is_SGI = !tbl->is_SGI;
+			rate->sgi = !tbl->rate.sgi;
 			rs_set_expected_tpt_table(lq_sta, search_tbl);
 			/*
 			 * If active table already uses the fastest possible
@@ -1540,13 +1541,14 @@ static int rs_move_mimo2_to_other(struct iwl_mvm *mvm,
 			 * and it's working well, there's no need to look
 			 * for a better type of modulation!
 			 */
-			if (tbl->is_SGI) {
+			if (tbl->rate.sgi) {
 				s32 tpt = lq_sta->last_tpt / 100;
 				if (tpt >= search_tbl->expected_tpt[index])
 					break;
 			}
+			rate->index = index;
 			search_tbl->current_rate =
-				rate_n_flags_from_tbl(mvm, search_tbl, index);
+				ucode_rate_from_rs_rate(mvm, rate);
 			update_search_tbl_counter = 1;
 			goto out;
 		default:
@@ -1557,7 +1559,7 @@ static int rs_move_mimo2_to_other(struct iwl_mvm *mvm,
 		if (tbl->action == start_action)
 			break;
 	}
-	search_tbl->lq_type = LQ_NONE;
+	rate->type = LQ_NONE;
 	return 0;
  out:
 	lq_sta->search_better_tbl = 1;
@@ -1657,14 +1659,12 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 static void rs_update_rate_tbl(struct iwl_mvm *mvm,
 			       struct ieee80211_sta *sta,
 			       struct iwl_lq_sta *lq_sta,
-			       struct iwl_scale_tbl_info *tbl,
-			       int index)
+			       struct rs_rate *rate)
 {
-	u32 rate;
+	u32 ucode_rate;
 
-	/* Update uCode's rate table. */
-	rate = rate_n_flags_from_tbl(mvm, tbl, index);
-	rs_fill_link_cmd(mvm, sta, lq_sta, rate);
+	ucode_rate = ucode_rate_from_rs_rate(mvm, rate);
+	rs_fill_link_cmd(mvm, sta, lq_sta, ucode_rate);
 	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
 }
 
@@ -1716,6 +1716,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	u8 prev_agg = lq_sta->is_agg;
 	struct iwl_mvm_sta *sta_priv = (void *)sta->drv_priv;
 	struct iwl_mvm_tid_data *tid_data;
+	struct rs_rate *rate;
 
 	/* Send management frames and NO_ACK data using lowest rate. */
 	/* TODO: this could probably be improved.. */
@@ -1748,6 +1749,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		active_tbl = 1 - lq_sta->active_tbl;
 
 	tbl = &(lq_sta->lq_info[active_tbl]);
+	rate = &tbl->rate;
 
 	if (prev_agg != lq_sta->is_agg) {
 		IWL_DEBUG_RATE(mvm,
@@ -1760,10 +1762,10 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	index = lq_sta->last_txrate_idx;
 
 	/* rates available for this association, and for modulation mode */
-	rate_mask = rs_get_supported_rates(lq_sta, hdr, tbl->lq_type);
+	rate_mask = rs_get_supported_rates(lq_sta, hdr, rate);
 
 	/* mask with station rate restriction */
-	if (is_legacy(tbl->lq_type)) {
+	if (is_legacy(rate)) {
 		if (lq_sta->band == IEEE80211_BAND_5GHZ)
 			/* supp_rates has no CCK bits in A mode */
 			rate_scale_index_msk = (u16) (rate_mask &
@@ -1783,12 +1785,13 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		IWL_ERR(mvm, "Current Rate is not valid\n");
 		if (lq_sta->search_better_tbl) {
 			/* revert to active table if search table is not valid*/
-			tbl->lq_type = LQ_NONE;
+			rate->type = LQ_NONE;
 			lq_sta->search_better_tbl = 0;
 			tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 			/* get "active" rate info */
 			index = iwl_hwrate_to_plcp_idx(tbl->current_rate);
-			rs_update_rate_tbl(mvm, sta, lq_sta, tbl, index);
+			tbl->rate.index = index;
+			rs_update_rate_tbl(mvm, sta, lq_sta, &tbl->rate);
 		}
 		return;
 	}
@@ -1825,7 +1828,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	    (window->success_counter < IWL_RATE_MIN_SUCCESS_TH)) {
 		IWL_DEBUG_RATE(mvm,
 			       "(%s: %d): Test Window: succ %d total %d\n",
-			       rs_pretty_lq_type(tbl->lq_type),
+			       rs_pretty_lq_type(rate->type),
 			       index, window->success_counter, window->counter);
 
 		/* Can't calculate this yet; not enough history */
@@ -1858,7 +1861,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 				       window->average_tpt,
 				       lq_sta->last_tpt);
 
-			if (!is_legacy(tbl->lq_type))
+			if (!is_legacy(rate))
 				lq_sta->enable_counter = 1;
 
 			/* Swap tables; "search" becomes "active" */
@@ -1874,7 +1877,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 				       lq_sta->last_tpt);
 
 			/* Nullify "search" table */
-			tbl->lq_type = LQ_NONE;
+			rate->type = LQ_NONE;
 
 			/* Revert to "active" table */
 			active_tbl = lq_sta->active_tbl;
@@ -1898,7 +1901,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	/* (Else) not in search of better modulation mode, try for better
 	 * starting rate, while staying in this mode. */
 	high_low = rs_get_adjacent_rate(mvm, index, rate_scale_index_msk,
-					tbl->lq_type);
+					rate->type);
 	low = high_low & 0xff;
 	high = (high_low >> 8) & 0xff;
 
@@ -1918,8 +1921,8 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 
 	IWL_DEBUG_RATE(mvm,
 		       "(%s: %d): cur_tpt %d SR %d low %d high %d low_tpt %d high_tpt %d\n",
-		       rs_pretty_lq_type(tbl->lq_type), index, current_tpt,
-		       sr, low, high, low_tpt, high_tpt);
+		       rs_pretty_lq_type(rate->type), index, current_tpt, sr,
+		       low, high, low_tpt, high_tpt);
 
 	scale_action = 0;
 
@@ -2002,7 +2005,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	}
 
 	/* Force a search in case BT doesn't like us being in MIMO */
-	if (is_mimo(tbl->lq_type) &&
+	if (is_mimo(rate) &&
 	    !iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta)) {
 		IWL_DEBUG_RATE(mvm,
 			       "BT Coex forbids MIMO. Search for new config\n");
@@ -2041,8 +2044,10 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 
 lq_update:
 	/* Replace uCode's rate table for the destination station. */
-	if (update_lq)
-		rs_update_rate_tbl(mvm, sta, lq_sta, tbl, index);
+	if (update_lq) {
+		tbl->rate.index = index;
+		rs_update_rate_tbl(mvm, sta, lq_sta, &tbl->rate);
+	}
 
 	rs_stay_in_table(lq_sta, false);
 
@@ -2063,11 +2068,11 @@ lq_update:
 			       window->counter);
 		/* Select a new "search" modulation mode to try.
 		 * If one is found, set up the new "search" table. */
-		if (is_legacy(tbl->lq_type))
+		if (is_legacy(&tbl->rate))
 			rs_move_legacy_other(mvm, lq_sta, sta, index);
-		else if (is_siso(tbl->lq_type))
+		else if (is_siso(&tbl->rate))
 			rs_move_siso_to_other(mvm, lq_sta, sta, index);
-		else if (is_mimo2(tbl->lq_type))
+		else if (is_mimo2(&tbl->rate))
 			rs_move_mimo2_to_other(mvm, lq_sta, sta, index);
 		else
 			WARN_ON_ONCE(1);
@@ -2086,7 +2091,7 @@ lq_update:
 				       "Switch to SEARCH TABLE: "
 				       "mcs %X (%s: %d)\n",
 				       tbl->current_rate,
-				       rs_pretty_lq_type(tbl->lq_type),
+				       rs_pretty_lq_type(tbl->rate.type),
 				       index);
 			rs_fill_link_cmd(mvm, sta, lq_sta, tbl->current_rate);
 			iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
@@ -2102,7 +2107,7 @@ lq_update:
 		 * stay with best antenna legacy modulation for a while
 		 * before next round of mode comparisons. */
 		tbl1 = &(lq_sta->lq_info[lq_sta->active_tbl]);
-		if (is_legacy(tbl1->lq_type) && !sta->ht_cap.ht_supported &&
+		if (is_legacy(&tbl1->rate) && !sta->ht_cap.ht_supported &&
 		    lq_sta->action_counter > tbl1->max_search) {
 			IWL_DEBUG_RATE(mvm, "LQ: STAY in legacy table\n");
 			rs_set_stay_in_table(mvm, 1, lq_sta);
@@ -2130,7 +2135,8 @@ lq_update:
 	}
 
 out:
-	tbl->current_rate = rate_n_flags_from_tbl(mvm, tbl, index);
+	tbl->rate.index = index;
+	tbl->current_rate = ucode_rate_from_rs_rate(mvm, &tbl->rate);
 	lq_sta->last_txrate_idx = index;
 }
 
@@ -2155,9 +2161,9 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 			     bool init)
 {
 	struct iwl_scale_tbl_info *tbl;
-	int rate_idx;
+	struct rs_rate *rate;
 	int i;
-	u32 rate;
+	u32 ucode_rate;
 	u8 active_tbl = 0;
 	u8 valid_tx_ant;
 
@@ -2174,25 +2180,26 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 		active_tbl = 1 - lq_sta->active_tbl;
 
 	tbl = &(lq_sta->lq_info[active_tbl]);
+	rate = &tbl->rate;
 
 	if ((i < 0) || (i >= IWL_RATE_COUNT))
 		i = 0;
 
-	rate = iwl_rates[i].plcp;
-	tbl->ant_type = first_antenna(valid_tx_ant);
-	rate |= tbl->ant_type << RATE_MCS_ANT_POS;
+	ucode_rate = iwl_rates[i].plcp;
+	rate->ant = first_antenna(valid_tx_ant);
+	ucode_rate |= rate->ant << RATE_MCS_ANT_POS;
 
 	if (i >= IWL_FIRST_CCK_RATE && i <= IWL_LAST_CCK_RATE)
-		rate |= RATE_MCS_CCK_MSK;
+		ucode_rate |= RATE_MCS_CCK_MSK;
 
-	rs_get_tbl_info_from_mcs(rate, band, tbl, &rate_idx);
-	if (!rs_is_valid_ant(valid_tx_ant, tbl->ant_type))
-		rs_toggle_antenna(valid_tx_ant, &rate, tbl);
+	rs_rate_from_ucode_rate(ucode_rate, band, rate);
+	if (!rs_is_valid_ant(valid_tx_ant, rate->ant))
+		rs_toggle_antenna(valid_tx_ant, &ucode_rate, rate);
 
-	rate = rate_n_flags_from_tbl(mvm, tbl, rate_idx);
-	tbl->current_rate = rate;
+	ucode_rate = ucode_rate_from_rs_rate(mvm, rate);
+	tbl->current_rate = ucode_rate;
 	rs_set_expected_tpt_table(lq_sta, tbl);
-	rs_fill_link_cmd(NULL, NULL, lq_sta, rate);
+	rs_fill_link_cmd(NULL, NULL, lq_sta, ucode_rate);
 	/* TODO restore station should remember the lq cmd */
 	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, init);
 }
@@ -2435,9 +2442,8 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 			     struct ieee80211_sta *sta,
 			     struct iwl_lq_sta *lq_sta, u32 new_rate)
 {
-	struct iwl_scale_tbl_info tbl_type;
+	struct rs_rate rate;
 	int index = 0;
-	int rate_idx;
 	int repeat_rate = 0;
 	u8 ant_toggle_cnt = 0;
 	u8 use_ht_possible = 1;
@@ -2447,12 +2453,10 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 	/* Override starting rate (index 0) if needed for debug purposes */
 	rs_dbgfs_set_mcs(lq_sta, &new_rate);
 
-	/* Interpret new_rate (rate_n_flags) */
-	rs_get_tbl_info_from_mcs(new_rate, lq_sta->band,
-				 &tbl_type, &rate_idx);
+	rs_rate_from_ucode_rate(new_rate, lq_sta->band, &rate);
 
 	/* How many times should we repeat the initial rate? */
-	if (is_legacy(tbl_type.lq_type)) {
+	if (is_legacy(&rate)) {
 		ant_toggle_cnt = 1;
 		repeat_rate = IWL_NUMBER_TRY;
 	} else {
@@ -2460,15 +2464,15 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 				  LINK_QUAL_AGG_DISABLE_START_DEF - 1);
 	}
 
-	lq_cmd->mimo_delim = is_mimo(tbl_type.lq_type) ? 1 : 0;
+	lq_cmd->mimo_delim = is_mimo(&rate) ? 1 : 0;
 
 	/* Fill 1st table entry (index 0) */
 	lq_cmd->rs_table[index] = cpu_to_le32(new_rate);
 
-	if (num_of_ant(tbl_type.ant_type) == 1)
-		lq_cmd->single_stream_ant_msk = tbl_type.ant_type;
-	else if (num_of_ant(tbl_type.ant_type) == 2)
-		lq_cmd->dual_stream_ant_msk = tbl_type.ant_type;
+	if (num_of_ant(rate.ant) == 1)
+		lq_cmd->single_stream_ant_msk = rate.ant;
+	else if (num_of_ant(rate.ant) == 2)
+		lq_cmd->dual_stream_ant_msk = rate.ant;
 	/* otherwise we don't modify the existing value */
 
 	index++;
@@ -2482,12 +2486,12 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 		 * For legacy IWL_NUMBER_TRY == 1, this loop will not execute.
 		 * For HT IWL_HT_NUMBER_TRY == 3, this executes twice. */
 		while (repeat_rate > 0 && (index < LINK_QUAL_MAX_RETRY_NUM)) {
-			if (is_legacy(tbl_type.lq_type)) {
+			if (is_legacy(&rate)) {
 				if (ant_toggle_cnt < NUM_TRY_BEFORE_ANT_TOGGLE)
 					ant_toggle_cnt++;
 				else if (mvm &&
 					 rs_toggle_antenna(valid_tx_ant,
-							&new_rate, &tbl_type))
+							&new_rate, &rate))
 					ant_toggle_cnt = 1;
 			}
 
@@ -2501,26 +2505,25 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 			index++;
 		}
 
-		rs_get_tbl_info_from_mcs(new_rate, lq_sta->band, &tbl_type,
-					 &rate_idx);
+		rs_rate_from_ucode_rate(new_rate, lq_sta->band, &rate);
 
 		/* Indicate to uCode which entries might be MIMO.
 		 * If initial rate was MIMO, this will finally end up
 		 * as (IWL_HT_NUMBER_TRY * 2), after 2nd pass, otherwise 0. */
-		if (is_mimo(tbl_type.lq_type))
+		if (is_mimo(&rate))
 			lq_cmd->mimo_delim = index;
 
 		/* Get next rate */
-		new_rate = rs_get_lower_rate(lq_sta, &tbl_type, rate_idx,
+		new_rate = rs_get_lower_rate(lq_sta, &rate, rate.index,
 					     use_ht_possible);
 
 		/* How many times should we repeat the next rate? */
-		if (is_legacy(tbl_type.lq_type)) {
+		if (is_legacy(&rate)) {
 			if (ant_toggle_cnt < NUM_TRY_BEFORE_ANT_TOGGLE)
 				ant_toggle_cnt++;
 			else if (mvm &&
 				 rs_toggle_antenna(valid_tx_ant,
-						   &new_rate, &tbl_type))
+						   &new_rate, &rate))
 				ant_toggle_cnt = 1;
 
 			repeat_rate = IWL_NUMBER_TRY;
@@ -2629,7 +2632,7 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 
 static const char *rs_pretty_lq_type(enum iwl_table_type type)
 {
-	static const char * const lq_type[] = {
+	static const char * const lq_types[] = {
 		[LQ_NONE] = "NONE",
 		[LQ_LEGACY_A] = "LEGACY_A",
 		[LQ_LEGACY_G] = "LEGACY_G",
@@ -2642,10 +2645,10 @@ static const char *rs_pretty_lq_type(enum iwl_table_type type)
 	if (type < LQ_NONE || type >= LQ_MAX)
 		return "UNKNOWN";
 
-	return lq_type[type];
+	return lq_types[type];
 }
 
-static int rs_pretty_print_rate(char *buf, const u32 rate)
+static const char *rs_pretty_ant(u8 ant)
 {
 	static const char * const ant_name[] = {
 		[ANT_NONE] = "None",
@@ -2658,6 +2661,15 @@ static int rs_pretty_print_rate(char *buf, const u32 rate)
 		[ANT_ABC]  = "ABC",
 	};
 
+	if (ant > ANT_ABC)
+		return "UNKNOWN";
+
+	return ant_name[ant];
+}
+
+static int rs_pretty_print_rate(char *buf, const u32 rate)
+{
+
 	char *type, *bw;
 	u8 mcs = 0, nss = 0;
 	u8 ant = (rate & RATE_MCS_ANT_ABC_MSK) >> RATE_MCS_ANT_POS;
@@ -2667,7 +2679,7 @@ static int rs_pretty_print_rate(char *buf, const u32 rate)
 		int index = iwl_hwrate_to_plcp_idx(rate);
 
 		return sprintf(buf, "Legacy | ANT: %s Rate: %s Mbps\n",
-			       ant_name[ant], iwl_rate_mcs[index].mbps);
+			       rs_pretty_ant(ant), iwl_rate_mcs[index].mbps);
 	}
 
 	if (rate & RATE_MCS_VHT_MSK) {
@@ -2700,7 +2712,7 @@ static int rs_pretty_print_rate(char *buf, const u32 rate)
 	}
 
 	return sprintf(buf, "%s | ANT: %s BW: %s MCS: %d NSS: %d %s%s%s%s%s\n",
-		       type, ant_name[ant], bw, mcs, nss,
+		       type, rs_pretty_ant(ant), bw, mcs, nss,
 		       (rate & RATE_MCS_SGI_MSK) ? "SGI " : "NGI ",
 		       (rate & RATE_MCS_STBC_MSK) ? "STBC " : "",
 		       (rate & RATE_MCS_LDPC_MSK) ? "LDPC " : "",
@@ -2719,7 +2731,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	struct iwl_lq_sta *lq_sta = file->private_data;
 	struct iwl_mvm *mvm;
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
-
+	struct rs_rate *rate = &tbl->rate;
 	mvm = lq_sta->drv;
 	buff = kmalloc(2048, GFP_KERNEL);
 	if (!buff)
@@ -2736,17 +2748,17 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	    (iwl_fw_valid_tx_ant(mvm->fw) & ANT_B) ? "ANT_B," : "",
 	    (iwl_fw_valid_tx_ant(mvm->fw) & ANT_C) ? "ANT_C" : "");
 	desc += sprintf(buff+desc, "lq type %s\n",
-			(is_legacy(tbl->lq_type)) ? "legacy" :
-			is_vht(tbl->lq_type) ? "VHT" : "HT");
-	if (!is_legacy(tbl->lq_type)) {
+			(is_legacy(rate)) ? "legacy" :
+			is_vht(rate) ? "VHT" : "HT");
+	if (!is_legacy(rate)) {
 		desc += sprintf(buff+desc, " %s",
-		   (is_siso(tbl->lq_type)) ? "SISO" : "MIMO2");
+		   (is_siso(rate)) ? "SISO" : "MIMO2");
 		   desc += sprintf(buff+desc, " %s",
-				   (is_ht20(tbl)) ? "20MHz" :
-				   (is_ht40(tbl)) ? "40MHz" :
-				   (is_ht80(tbl)) ? "80Mhz" : "BAD BW");
+				   (is_ht20(rate)) ? "20MHz" :
+				   (is_ht40(rate)) ? "40MHz" :
+				   (is_ht80(rate)) ? "80Mhz" : "BAD BW");
 		   desc += sprintf(buff+desc, " %s %s\n",
-				   (tbl->is_SGI) ? "SGI" : "NGI",
+				   (rate->sgi) ? "SGI" : "NGI",
 				   (lq_sta->is_agg) ? "AGG on" : "");
 	}
 	desc += sprintf(buff+desc, "last tx rate=0x%X\n",
@@ -2799,6 +2811,7 @@ static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 	int i, j;
 	ssize_t ret;
 	struct iwl_scale_tbl_info *tbl;
+	struct rs_rate *rate;
 	struct iwl_lq_sta *lq_sta = file->private_data;
 
 	buff = kmalloc(1024, GFP_KERNEL);
@@ -2807,15 +2820,16 @@ static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 
 	for (i = 0; i < LQ_SIZE; i++) {
 		tbl = &(lq_sta->lq_info[i]);
+		rate = &tbl->rate;
 		desc += sprintf(buff+desc,
 				"%s type=%d SGI=%d BW=%s DUP=0\n"
 				"rate=0x%X\n",
 				lq_sta->active_tbl == i ? "*" : "x",
-				tbl->lq_type,
-				tbl->is_SGI,
-				is_ht20(tbl) ? "20Mhz" :
-				is_ht40(tbl) ? "40Mhz" :
-				is_ht80(tbl) ? "80Mhz" : "ERR",
+				rate->type,
+				rate->sgi,
+				is_ht20(rate) ? "20Mhz" :
+				is_ht40(rate) ? "40Mhz" :
+				is_ht80(rate) ? "80Mhz" : "ERR",
 				tbl->current_rate);
 		for (j = 0; j < IWL_RATE_COUNT; j++) {
 			desc += sprintf(buff+desc,
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index ae983bc..8fa26af 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -224,22 +224,45 @@ enum iwl_table_type {
 	LQ_MAX,
 };
 
-#define is_legacy(tbl) (((tbl) == LQ_LEGACY_G) || ((tbl) == LQ_LEGACY_A))
-#define is_ht_siso(tbl) ((tbl) == LQ_HT_SISO)
-#define is_ht_mimo2(tbl) ((tbl) == LQ_HT_MIMO2)
-#define is_vht_siso(tbl) ((tbl) == LQ_VHT_SISO)
-#define is_vht_mimo2(tbl) ((tbl) == LQ_VHT_MIMO2)
-#define is_siso(tbl) (is_ht_siso(tbl) || is_vht_siso(tbl))
-#define is_mimo2(tbl) (is_ht_mimo2(tbl) || is_vht_mimo2(tbl))
-#define is_mimo(tbl) (is_mimo2(tbl))
-#define is_ht(tbl) (is_ht_siso(tbl) || is_ht_mimo2(tbl))
-#define is_vht(tbl) (is_vht_siso(tbl) || is_vht_mimo2(tbl))
-#define is_a_band(tbl) ((tbl) == LQ_LEGACY_A)
-#define is_g_band(tbl) ((tbl) == LQ_LEGACY_G)
-
-#define is_ht20(tbl) (tbl->bw == RATE_MCS_CHAN_WIDTH_20)
-#define is_ht40(tbl) (tbl->bw == RATE_MCS_CHAN_WIDTH_40)
-#define is_ht80(tbl) (tbl->bw == RATE_MCS_CHAN_WIDTH_80)
+struct rs_rate {
+	int index;
+	enum iwl_table_type type;
+	u8 ant;
+	u32 bw;
+	bool sgi;
+};
+
+
+#define is_type_legacy(type) (((type) == LQ_LEGACY_G) || \
+			      ((type) == LQ_LEGACY_A))
+#define is_type_ht_siso(type) ((type) == LQ_HT_SISO)
+#define is_type_ht_mimo2(type) ((type) == LQ_HT_MIMO2)
+#define is_type_vht_siso(type) ((type) == LQ_VHT_SISO)
+#define is_type_vht_mimo2(type) ((type) == LQ_VHT_MIMO2)
+#define is_type_siso(type) (is_type_ht_siso(type) || is_type_vht_siso(type))
+#define is_type_mimo2(type) (is_type_ht_mimo2(type) || is_type_vht_mimo2(type))
+#define is_type_mimo(type) (is_type_mimo2(type))
+#define is_type_ht(type) (is_type_ht_siso(type) || is_type_ht_mimo2(type))
+#define is_type_vht(type) (is_type_vht_siso(type) || is_type_vht_mimo2(type))
+#define is_type_a_band(type) ((type) == LQ_LEGACY_A)
+#define is_type_g_band(type) ((type) == LQ_LEGACY_G)
+
+#define is_legacy(rate)       is_type_legacy((rate)->type)
+#define is_ht_siso(rate)      is_type_ht_siso((rate)->type)
+#define is_ht_mimo2(rate)     is_type_ht_mimo2((rate)->type)
+#define is_vht_siso(rate)     is_type_vht_siso((rate)->type)
+#define is_vht_mimo2(rate)    is_type_vht_mimo2((rate)->type)
+#define is_siso(rate)         is_type_siso((rate)->type)
+#define is_mimo2(rate)        is_type_mimo2((rate)->type)
+#define is_mimo(rate)         is_type_mimo((rate)->type)
+#define is_ht(rate)           is_type_ht((rate)->type)
+#define is_vht(rate)          is_type_vht((rate)->type)
+#define is_a_band(rate)       is_type_a_band((rate)->type)
+#define is_g_band(rate)       is_type_g_band((rate)->type)
+
+#define is_ht20(rate)         ((rate)->bw == RATE_MCS_CHAN_WIDTH_20)
+#define is_ht40(rate)         ((rate)->bw == RATE_MCS_CHAN_WIDTH_40)
+#define is_ht80(rate)         ((rate)->bw == RATE_MCS_CHAN_WIDTH_80)
 
 #define IWL_MAX_MCS_DISPLAY_SIZE	12
 
@@ -266,10 +289,7 @@ struct iwl_rate_scale_data {
  * one for "active", and one for "search".
  */
 struct iwl_scale_tbl_info {
-	enum iwl_table_type lq_type;
-	u8 ant_type;
-	u8 is_SGI;	/* 1 = short guard interval */
-	u32 bw;	        /* channel bandwidth; RATE_MCS_CHAN_WIDTH_XX */
+	struct rs_rate rate;
 	u8 action;	/* change modulation; IWL_[LEGACY/SISO/MIMO]_SWITCH_* */
 	u8 max_search;	/* maximun number of tables we can search */
 	s32 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
-- 
1.7.9.5

