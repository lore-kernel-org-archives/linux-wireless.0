Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3HPLH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:07:56 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>
Subject: [PATCH 13/20] iwlwifi: mvm: remove MIMO3 from rate scale code
Date: Fri, 16 Aug 2013 13:07:03 +0200
Message-Id: <1376651230-1060-13-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130800_459060_7348D04F)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Current and future chips supported by mvm will only have a maximum
of 2 antennas so all the MIMO3 related code and states can be dropped.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 393 ++++------------------------------
 drivers/net/wireless/iwlwifi/mvm/rs.h |  41 +---
 2 files changed, 45 insertions(+), 389 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index a587b21..5cb3132 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -86,7 +86,6 @@ static const u8 ant_toggle_lookup[] = {
 	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,      \
 				    IWL_RATE_SISO_##s##M_PLCP, \
 				    IWL_RATE_MIMO2_##s##M_PLCP,\
-				    IWL_RATE_MIMO3_##s##M_PLCP,\
 				    IWL_RATE_##rp##M_INDEX,    \
 				    IWL_RATE_##rn##M_INDEX }
 
@@ -129,9 +128,8 @@ static int iwl_hwrate_to_plcp_idx(u32 rate_n_flags)
 	if (rate_n_flags & RATE_MCS_HT_MSK) {
 		idx = rs_extract_rate(rate_n_flags);
 
-		if (idx >= IWL_RATE_MIMO3_6M_PLCP)
-			idx = idx - IWL_RATE_MIMO3_6M_PLCP;
-		else if (idx >= IWL_RATE_MIMO2_6M_PLCP)
+		WARN_ON_ONCE(idx >= IWL_RATE_MIMO3_6M_PLCP);
+		if (idx >= IWL_RATE_MIMO2_6M_PLCP)
 			idx = idx - IWL_RATE_MIMO2_6M_PLCP;
 
 		idx += IWL_FIRST_OFDM_RATE;
@@ -213,20 +211,6 @@ static s32 expected_tpt_mimo2_40MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0, 186, 0, 329, 439, 527, 667, 764, 803, 838}, /* AGG+SGI */
 };
 
-static s32 expected_tpt_mimo3_20MHz[4][IWL_RATE_COUNT] = {
-	{0, 0, 0, 0,  99, 0, 153, 186, 208, 239, 256, 263, 268}, /* Norm */
-	{0, 0, 0, 0, 106, 0, 162, 194, 215, 246, 262, 268, 273}, /* SGI */
-	{0, 0, 0, 0, 134, 0, 249, 346, 431, 574, 685, 732, 775}, /* AGG */
-	{0, 0, 0, 0, 148, 0, 272, 376, 465, 614, 727, 775, 818}, /* AGG+SGI */
-};
-
-static s32 expected_tpt_mimo3_40MHz[4][IWL_RATE_COUNT] = {
-	{0, 0, 0, 0, 152, 0, 211, 239, 255, 279,  290,  294,  297}, /* Norm */
-	{0, 0, 0, 0, 160, 0, 219, 245, 261, 284,  294,  297,  300}, /* SGI */
-	{0, 0, 0, 0, 254, 0, 443, 584, 695, 868,  984, 1030, 1070}, /* AGG */
-	{0, 0, 0, 0, 277, 0, 478, 624, 737, 911, 1026, 1070, 1109}, /* AGG+SGI */
-};
-
 /* mbps, mcs */
 static const struct iwl_rate_mcs_info iwl_rate_mcs[IWL_RATE_COUNT] = {
 	{  "1", "BPSK DSSS"},
@@ -274,7 +258,6 @@ static void rs_program_fix_rate(struct iwl_mvm *mvm,
 	lq_sta->active_legacy_rate = 0x0FFF;	/* 1 - 54 MBits, includes CCK */
 	lq_sta->active_siso_rate   = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 	lq_sta->active_mimo2_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
-	lq_sta->active_mimo3_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 
 	IWL_DEBUG_RATE(mvm, "sta_id %d rate 0x%X\n",
 		       lq_sta->lq.sta_id, lq_sta->dbg_fixed_rate);
@@ -454,7 +437,7 @@ static u32 rate_n_flags_from_tbl(struct iwl_mvm *mvm,
 		else if (is_mimo2(tbl->lq_type))
 			rate_n_flags |=	iwl_rates[index].plcp_mimo2;
 		else
-			rate_n_flags |=	iwl_rates[index].plcp_mimo3;
+			WARN_ON_ONCE(1);
 	} else {
 		IWL_ERR(mvm, "Invalid tbl->lq_type %d\n", tbl->lq_type);
 	}
@@ -531,12 +514,8 @@ static int rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
 		} else if (mcs <= IWL_RATE_MIMO2_60M_PLCP) {
 			if (num_of_ant == 2)
 				tbl->lq_type = LQ_MIMO2;
-		/* MIMO3 */
 		} else {
-			if (num_of_ant == 3) {
-				tbl->max_search = IWL_MAX_11N_MIMO3_SEARCH;
-				tbl->lq_type = LQ_MIMO3;
-			}
+			WARN_ON_ONCE(num_of_ant == 3);
 		}
 	}
 	return 0;
@@ -602,10 +581,10 @@ static u16 rs_get_supported_rates(struct iwl_lq_sta *lq_sta,
 	} else {
 		if (is_siso(rate_type))
 			return lq_sta->active_siso_rate;
-		else if (is_mimo2(rate_type))
+		else {
+			WARN_ON_ONCE(!is_mimo2(rate_type));
 			return lq_sta->active_mimo2_rate;
-		else
-			return lq_sta->active_mimo3_rate;
+		}
 	}
 }
 
@@ -980,7 +959,7 @@ static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 	}
 
 	/* Choose among many HT tables depending on number of streams
-	 * (SISO/MIMO2/MIMO3), channel width (20/40), SGI, and aggregation
+	 * (SISO/MIMO2), channel width (20/40), SGI, and aggregation
 	 * status */
 	if (is_siso(tbl->lq_type) && !tbl->is_ht40)
 		ht_tbl_pointer = expected_tpt_siso20MHz;
@@ -988,12 +967,10 @@ static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 		ht_tbl_pointer = expected_tpt_siso40MHz;
 	else if (is_mimo2(tbl->lq_type) && !tbl->is_ht40)
 		ht_tbl_pointer = expected_tpt_mimo2_20MHz;
-	else if (is_mimo2(tbl->lq_type))
+	else {
+		WARN_ON_ONCE(!is_mimo2(tbl->lq_type));
 		ht_tbl_pointer = expected_tpt_mimo2_40MHz;
-	else if (is_mimo3(tbl->lq_type) && !tbl->is_ht40)
-		ht_tbl_pointer = expected_tpt_mimo3_20MHz;
-	else /* if (is_mimo3(tbl->lq_type)) <-- must be true */
-		ht_tbl_pointer = expected_tpt_mimo3_40MHz;
+	}
 
 	if (!tbl->is_SGI && !lq_sta->is_agg)		/* Normal */
 		tbl->expected_tpt = ht_tbl_pointer[0];
@@ -1165,58 +1142,6 @@ static int rs_switch_to_mimo2(struct iwl_mvm *mvm,
 }
 
 /*
- * Set up search table for MIMO3
- */
-static int rs_switch_to_mimo3(struct iwl_mvm *mvm,
-			     struct iwl_lq_sta *lq_sta,
-			     struct ieee80211_sta *sta,
-			     struct iwl_scale_tbl_info *tbl, int index)
-{
-	u16 rate_mask;
-	s32 rate;
-	s8 is_green = lq_sta->is_green;
-
-	if (!sta->ht_cap.ht_supported)
-		return -1;
-
-	if (sta->smps_mode == IEEE80211_SMPS_STATIC)
-		return -1;
-
-	/* Need both Tx chains/antennas to support MIMO */
-	if (num_of_ant(iwl_fw_valid_tx_ant(mvm->fw)) < 3)
-		return -1;
-
-	IWL_DEBUG_RATE(mvm, "LQ: try to switch to MIMO3\n");
-
-	tbl->lq_type = LQ_MIMO3;
-	tbl->action = 0;
-	tbl->max_search = IWL_MAX_11N_MIMO3_SEARCH;
-	rate_mask = lq_sta->active_mimo3_rate;
-
-	if (iwl_is_ht40_tx_allowed(sta))
-		tbl->is_ht40 = 1;
-	else
-		tbl->is_ht40 = 0;
-
-	rs_set_expected_tpt_table(lq_sta, tbl);
-
-	rate = rs_get_best_rate(mvm, lq_sta, tbl, rate_mask, index);
-
-	IWL_DEBUG_RATE(mvm, "LQ: MIMO3 best rate %d mask %X\n",
-		       rate, rate_mask);
-	if ((rate == IWL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
-		IWL_DEBUG_RATE(mvm, "Can't switch with index %d rate mask %x\n",
-			       rate, rate_mask);
-		return -1;
-	}
-	tbl->current_rate = rate_n_flags_from_tbl(mvm, tbl, rate, is_green);
-
-	IWL_DEBUG_RATE(mvm, "LQ: Switch to new mcs %X index is green %X\n",
-		       tbl->current_rate, is_green);
-	return 0;
-}
-
-/*
  * Set up search table for SISO
  */
 static int rs_switch_to_siso(struct iwl_mvm *mvm,
@@ -1325,21 +1250,14 @@ static int rs_move_legacy_other(struct iwl_mvm *mvm,
 			}
 
 			break;
-		case IWL_LEGACY_SWITCH_MIMO2_AB:
-		case IWL_LEGACY_SWITCH_MIMO2_AC:
-		case IWL_LEGACY_SWITCH_MIMO2_BC:
+		case IWL_LEGACY_SWITCH_MIMO2:
 			IWL_DEBUG_RATE(mvm, "LQ: Legacy switch to MIMO2\n");
 
 			/* Set up search table to try MIMO */
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->is_SGI = 0;
 
-			if (tbl->action == IWL_LEGACY_SWITCH_MIMO2_AB)
-				search_tbl->ant_type = ANT_AB;
-			else if (tbl->action == IWL_LEGACY_SWITCH_MIMO2_AC)
-				search_tbl->ant_type = ANT_AC;
-			else
-				search_tbl->ant_type = ANT_BC;
+			search_tbl->ant_type = ANT_AB;
 
 			if (!rs_is_valid_ant(valid_tx_ant,
 					     search_tbl->ant_type))
@@ -1352,30 +1270,11 @@ static int rs_move_legacy_other(struct iwl_mvm *mvm,
 				goto out;
 			}
 			break;
-
-		case IWL_LEGACY_SWITCH_MIMO3_ABC:
-			IWL_DEBUG_RATE(mvm, "LQ: Legacy switch to MIMO3\n");
-
-			/* Set up search table to try MIMO3 */
-			memcpy(search_tbl, tbl, sz);
-			search_tbl->is_SGI = 0;
-
-			search_tbl->ant_type = ANT_ABC;
-
-			if (!rs_is_valid_ant(valid_tx_ant,
-					     search_tbl->ant_type))
-				break;
-
-			ret = rs_switch_to_mimo3(mvm, lq_sta, sta,
-						 search_tbl, index);
-			if (!ret) {
-				lq_sta->action_counter = 0;
-				goto out;
-			}
-			break;
+		default:
+			WARN_ON_ONCE(1);
 		}
 		tbl->action++;
-		if (tbl->action > IWL_LEGACY_SWITCH_MIMO3_ABC)
+		if (tbl->action > IWL_LEGACY_SWITCH_MIMO2)
 			tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
 
 		if (tbl->action == start_action)
@@ -1387,7 +1286,7 @@ static int rs_move_legacy_other(struct iwl_mvm *mvm,
 out:
 	lq_sta->search_better_tbl = 1;
 	tbl->action++;
-	if (tbl->action > IWL_LEGACY_SWITCH_MIMO3_ABC)
+	if (tbl->action > IWL_LEGACY_SWITCH_MIMO2)
 		tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
 	if (update_search_tbl_counter)
 		search_tbl->action = tbl->action;
@@ -1422,7 +1321,7 @@ static int rs_move_siso_to_other(struct iwl_mvm *mvm,
 	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
 		/* avoid antenna B unless MIMO */
 		if (tbl->action == IWL_SISO_SWITCH_ANTENNA2)
-			tbl->action = IWL_SISO_SWITCH_MIMO2_AB;
+			tbl->action = IWL_SISO_SWITCH_MIMO2;
 		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
 	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
@@ -1464,19 +1363,12 @@ static int rs_move_siso_to_other(struct iwl_mvm *mvm,
 				goto out;
 			}
 			break;
-		case IWL_SISO_SWITCH_MIMO2_AB:
-		case IWL_SISO_SWITCH_MIMO2_AC:
-		case IWL_SISO_SWITCH_MIMO2_BC:
+		case IWL_SISO_SWITCH_MIMO2:
 			IWL_DEBUG_RATE(mvm, "LQ: SISO switch to MIMO2\n");
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->is_SGI = 0;
 
-			if (tbl->action == IWL_SISO_SWITCH_MIMO2_AB)
-				search_tbl->ant_type = ANT_AB;
-			else if (tbl->action == IWL_SISO_SWITCH_MIMO2_AC)
-				search_tbl->ant_type = ANT_AC;
-			else
-				search_tbl->ant_type = ANT_BC;
+			search_tbl->ant_type = ANT_AB;
 
 			if (!rs_is_valid_ant(valid_tx_ant,
 					     search_tbl->ant_type))
@@ -1517,24 +1409,11 @@ static int rs_move_siso_to_other(struct iwl_mvm *mvm,
 						      index, is_green);
 			update_search_tbl_counter = 1;
 			goto out;
-		case IWL_SISO_SWITCH_MIMO3_ABC:
-			IWL_DEBUG_RATE(mvm, "LQ: SISO switch to MIMO3\n");
-			memcpy(search_tbl, tbl, sz);
-			search_tbl->is_SGI = 0;
-			search_tbl->ant_type = ANT_ABC;
-
-			if (!rs_is_valid_ant(valid_tx_ant,
-					     search_tbl->ant_type))
-				break;
-
-			ret = rs_switch_to_mimo3(mvm, lq_sta, sta,
-						 search_tbl, index);
-			if (!ret)
-				goto out;
-			break;
+		default:
+			WARN_ON_ONCE(1);
 		}
 		tbl->action++;
-		if (tbl->action > IWL_LEGACY_SWITCH_MIMO3_ABC)
+		if (tbl->action > IWL_SISO_SWITCH_GI)
 			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 
 		if (tbl->action == start_action)
@@ -1546,7 +1425,7 @@ static int rs_move_siso_to_other(struct iwl_mvm *mvm,
  out:
 	lq_sta->search_better_tbl = 1;
 	tbl->action++;
-	if (tbl->action > IWL_SISO_SWITCH_MIMO3_ABC)
+	if (tbl->action > IWL_SISO_SWITCH_GI)
 		tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 	if (update_search_tbl_counter)
 		search_tbl->action = tbl->action;
@@ -1587,8 +1466,7 @@ static int rs_move_mimo2_to_other(struct iwl_mvm *mvm,
 		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
 		/* avoid antenna B unless MIMO */
-		if (tbl->action == IWL_MIMO2_SWITCH_SISO_B ||
-		    tbl->action == IWL_MIMO2_SWITCH_SISO_C)
+		if (tbl->action == IWL_MIMO2_SWITCH_SISO_B)
 			tbl->action = IWL_MIMO2_SWITCH_SISO_A;
 		break;
 	default:
@@ -1621,7 +1499,6 @@ static int rs_move_mimo2_to_other(struct iwl_mvm *mvm,
 			break;
 		case IWL_MIMO2_SWITCH_SISO_A:
 		case IWL_MIMO2_SWITCH_SISO_B:
-		case IWL_MIMO2_SWITCH_SISO_C:
 			IWL_DEBUG_RATE(mvm, "LQ: MIMO2 switch to SISO\n");
 
 			/* Set up new search table for SISO */
@@ -1629,10 +1506,8 @@ static int rs_move_mimo2_to_other(struct iwl_mvm *mvm,
 
 			if (tbl->action == IWL_MIMO2_SWITCH_SISO_A)
 				search_tbl->ant_type = ANT_A;
-			else if (tbl->action == IWL_MIMO2_SWITCH_SISO_B)
+			else /* tbl->action == IWL_MIMO2_SWITCH_SISO_B */
 				search_tbl->ant_type = ANT_B;
-			else
-				search_tbl->ant_type = ANT_C;
 
 			if (!rs_is_valid_ant(valid_tx_ant,
 					     search_tbl->ant_type))
@@ -1675,26 +1550,11 @@ static int rs_move_mimo2_to_other(struct iwl_mvm *mvm,
 						      index, is_green);
 			update_search_tbl_counter = 1;
 			goto out;
-
-		case IWL_MIMO2_SWITCH_MIMO3_ABC:
-			IWL_DEBUG_RATE(mvm, "LQ: MIMO2 switch to MIMO3\n");
-			memcpy(search_tbl, tbl, sz);
-			search_tbl->is_SGI = 0;
-			search_tbl->ant_type = ANT_ABC;
-
-			if (!rs_is_valid_ant(valid_tx_ant,
-					     search_tbl->ant_type))
-				break;
-
-			ret = rs_switch_to_mimo3(mvm, lq_sta, sta,
-						 search_tbl, index);
-			if (!ret)
-				goto out;
-
-			break;
+		default:
+			WARN_ON_ONCE(1);
 		}
 		tbl->action++;
-		if (tbl->action > IWL_MIMO2_SWITCH_MIMO3_ABC)
+		if (tbl->action > IWL_MIMO2_SWITCH_GI)
 			tbl->action = IWL_MIMO2_SWITCH_ANTENNA1;
 
 		if (tbl->action == start_action)
@@ -1705,7 +1565,7 @@ static int rs_move_mimo2_to_other(struct iwl_mvm *mvm,
  out:
 	lq_sta->search_better_tbl = 1;
 	tbl->action++;
-	if (tbl->action > IWL_MIMO2_SWITCH_MIMO3_ABC)
+	if (tbl->action > IWL_MIMO2_SWITCH_GI)
 		tbl->action = IWL_MIMO2_SWITCH_ANTENNA1;
 	if (update_search_tbl_counter)
 		search_tbl->action = tbl->action;
@@ -1714,171 +1574,6 @@ static int rs_move_mimo2_to_other(struct iwl_mvm *mvm,
 }
 
 /*
- * Try to switch to new modulation mode from MIMO3
- */
-static int rs_move_mimo3_to_other(struct iwl_mvm *mvm,
-				 struct iwl_lq_sta *lq_sta,
-				 struct ieee80211_sta *sta, int index)
-{
-	s8 is_green = lq_sta->is_green;
-	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
-	struct iwl_scale_tbl_info *search_tbl =
-				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
-	struct iwl_rate_scale_data *window = &(tbl->win[index]);
-	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
-	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
-		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
-	u8 start_action;
-	u8 valid_tx_ant = iwl_fw_valid_tx_ant(mvm->fw);
-	u8 tx_chains_num = num_of_ant(valid_tx_ant);
-	int ret;
-	u8 update_search_tbl_counter = 0;
-
-	switch (BT_MBOX_MSG(&mvm->last_bt_notif, 3, TRAFFIC_LOAD)) {
-	case IWL_BT_COEX_TRAFFIC_LOAD_NONE:
-		/* nothing */
-		break;
-	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
-	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
-		/* avoid antenna B and MIMO */
-		if (tbl->action != IWL_MIMO3_SWITCH_SISO_A)
-			tbl->action = IWL_MIMO3_SWITCH_SISO_A;
-		break;
-	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
-		/* avoid antenna B unless MIMO */
-		if (tbl->action == IWL_MIMO3_SWITCH_SISO_B ||
-		    tbl->action == IWL_MIMO3_SWITCH_SISO_C)
-			tbl->action = IWL_MIMO3_SWITCH_SISO_A;
-		break;
-	default:
-		IWL_ERR(mvm, "Invalid BT load %d",
-			BT_MBOX_MSG(&mvm->last_bt_notif, 3, TRAFFIC_LOAD));
-		break;
-	}
-
-	start_action = tbl->action;
-	while (1) {
-		lq_sta->action_counter++;
-		switch (tbl->action) {
-		case IWL_MIMO3_SWITCH_ANTENNA1:
-		case IWL_MIMO3_SWITCH_ANTENNA2:
-			IWL_DEBUG_RATE(mvm, "LQ: MIMO3 toggle Antennas\n");
-
-			if (tx_chains_num <= 3)
-				break;
-
-			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
-				break;
-
-			memcpy(search_tbl, tbl, sz);
-			if (rs_toggle_antenna(valid_tx_ant,
-					      &search_tbl->current_rate,
-					      search_tbl))
-				goto out;
-			break;
-		case IWL_MIMO3_SWITCH_SISO_A:
-		case IWL_MIMO3_SWITCH_SISO_B:
-		case IWL_MIMO3_SWITCH_SISO_C:
-			IWL_DEBUG_RATE(mvm, "LQ: MIMO3 switch to SISO\n");
-
-			/* Set up new search table for SISO */
-			memcpy(search_tbl, tbl, sz);
-
-			if (tbl->action == IWL_MIMO3_SWITCH_SISO_A)
-				search_tbl->ant_type = ANT_A;
-			else if (tbl->action == IWL_MIMO3_SWITCH_SISO_B)
-				search_tbl->ant_type = ANT_B;
-			else
-				search_tbl->ant_type = ANT_C;
-
-			if (!rs_is_valid_ant(valid_tx_ant,
-					     search_tbl->ant_type))
-				break;
-
-			ret = rs_switch_to_siso(mvm, lq_sta, sta,
-						search_tbl, index);
-			if (!ret)
-				goto out;
-
-			break;
-
-		case IWL_MIMO3_SWITCH_MIMO2_AB:
-		case IWL_MIMO3_SWITCH_MIMO2_AC:
-		case IWL_MIMO3_SWITCH_MIMO2_BC:
-			IWL_DEBUG_RATE(mvm, "LQ: MIMO3 switch to MIMO2\n");
-
-			memcpy(search_tbl, tbl, sz);
-			search_tbl->is_SGI = 0;
-			if (tbl->action == IWL_MIMO3_SWITCH_MIMO2_AB)
-				search_tbl->ant_type = ANT_AB;
-			else if (tbl->action == IWL_MIMO3_SWITCH_MIMO2_AC)
-				search_tbl->ant_type = ANT_AC;
-			else
-				search_tbl->ant_type = ANT_BC;
-
-			if (!rs_is_valid_ant(valid_tx_ant,
-					     search_tbl->ant_type))
-				break;
-
-			ret = rs_switch_to_mimo2(mvm, lq_sta, sta,
-						 search_tbl, index);
-			if (!ret)
-				goto out;
-
-			break;
-
-		case IWL_MIMO3_SWITCH_GI:
-			if (!tbl->is_ht40 && !(ht_cap->cap &
-						IEEE80211_HT_CAP_SGI_20))
-				break;
-			if (tbl->is_ht40 && !(ht_cap->cap &
-						IEEE80211_HT_CAP_SGI_40))
-				break;
-
-			IWL_DEBUG_RATE(mvm, "LQ: MIMO3 toggle SGI/NGI\n");
-
-			/* Set up new search table for MIMO */
-			memcpy(search_tbl, tbl, sz);
-			search_tbl->is_SGI = !tbl->is_SGI;
-			rs_set_expected_tpt_table(lq_sta, search_tbl);
-			/*
-			 * If active table already uses the fastest possible
-			 * modulation (dual stream with short guard interval),
-			 * and it's working well, there's no need to look
-			 * for a better type of modulation!
-			 */
-			if (tbl->is_SGI) {
-				s32 tpt = lq_sta->last_tpt / 100;
-				if (tpt >= search_tbl->expected_tpt[index])
-					break;
-			}
-			search_tbl->current_rate =
-				rate_n_flags_from_tbl(mvm, search_tbl,
-						      index, is_green);
-			update_search_tbl_counter = 1;
-			goto out;
-		}
-		tbl->action++;
-		if (tbl->action > IWL_MIMO3_SWITCH_GI)
-			tbl->action = IWL_MIMO3_SWITCH_ANTENNA1;
-
-		if (tbl->action == start_action)
-			break;
-	}
-	search_tbl->lq_type = LQ_NONE;
-	return 0;
- out:
-	lq_sta->search_better_tbl = 1;
-	tbl->action++;
-	if (tbl->action > IWL_MIMO3_SWITCH_GI)
-		tbl->action = IWL_MIMO3_SWITCH_ANTENNA1;
-	if (update_search_tbl_counter)
-		search_tbl->action = tbl->action;
-
-	return 0;
-}
-
-/*
  * Check whether we should continue using same modulation mode, or
  * begin search for a new mode, based on:
  * 1) # tx successes or failures while using this mode
@@ -2284,8 +1979,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		scale_action = 0;
 
 	if ((BT_MBOX_MSG(&mvm->last_bt_notif, 3, TRAFFIC_LOAD) >=
-	     IWL_BT_COEX_TRAFFIC_LOAD_HIGH) &&
-	     (is_mimo2(tbl->lq_type) || is_mimo3(tbl->lq_type))) {
+	     IWL_BT_COEX_TRAFFIC_LOAD_HIGH) && (is_mimo(tbl->lq_type))) {
 		if (lq_sta->last_bt_traffic >
 		    BT_MBOX_MSG(&mvm->last_bt_notif, 3, TRAFFIC_LOAD)) {
 			/*
@@ -2302,8 +1996,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		BT_MBOX_MSG(&mvm->last_bt_notif, 3, TRAFFIC_LOAD);
 
 	if ((BT_MBOX_MSG(&mvm->last_bt_notif, 3, TRAFFIC_LOAD) >=
-	     IWL_BT_COEX_TRAFFIC_LOAD_HIGH) &&
-	     (is_mimo2(tbl->lq_type) || is_mimo3(tbl->lq_type))) {
+	     IWL_BT_COEX_TRAFFIC_LOAD_HIGH) && is_mimo(tbl->lq_type)) {
 		/* search for a new modulation */
 		rs_stay_in_table(lq_sta, true);
 		goto lq_update;
@@ -2363,7 +2056,7 @@ lq_update:
 		else if (is_mimo2(tbl->lq_type))
 			rs_move_mimo2_to_other(mvm, lq_sta, sta, index);
 		else
-			rs_move_mimo3_to_other(mvm, lq_sta, sta, index);
+			WARN_ON_ONCE(1);
 
 		/* If new "search" mode was selected, set up in uCode table */
 		if (lq_sta->search_better_tbl) {
@@ -2528,11 +2221,10 @@ static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
 		rate_idx -= IWL_FIRST_OFDM_RATE;
 		/* 6M and 9M shared same MCS index */
 		rate_idx = (rate_idx > 0) ? (rate_idx - 1) : 0;
+		WARN_ON_ONCE(rs_extract_rate(lq_sta->last_rate_n_flags) >=
+			     IWL_RATE_MIMO3_6M_PLCP);
 		if (rs_extract_rate(lq_sta->last_rate_n_flags) >=
-		    IWL_RATE_MIMO3_6M_PLCP)
-			rate_idx = rate_idx + (2 * MCS_INDEX_PER_STREAM);
-		else if (rs_extract_rate(lq_sta->last_rate_n_flags) >=
-			 IWL_RATE_MIMO2_6M_PLCP)
+		    IWL_RATE_MIMO2_6M_PLCP)
 			rate_idx = rate_idx + MCS_INDEX_PER_STREAM;
 		info->control.rates[0].flags = IEEE80211_TX_RC_MCS;
 		if (lq_sta->last_rate_n_flags & RATE_MCS_SGI_MSK)
@@ -2631,16 +2323,10 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	lq_sta->active_mimo2_rate &= ~((u16)0x2);
 	lq_sta->active_mimo2_rate <<= IWL_FIRST_OFDM_RATE;
 
-	lq_sta->active_mimo3_rate = ht_cap->mcs.rx_mask[2] << 1;
-	lq_sta->active_mimo3_rate |= ht_cap->mcs.rx_mask[2] & 0x1;
-	lq_sta->active_mimo3_rate &= ~((u16)0x2);
-	lq_sta->active_mimo3_rate <<= IWL_FIRST_OFDM_RATE;
-
 	IWL_DEBUG_RATE(mvm,
-		       "SISO-RATE=%X MIMO2-RATE=%X MIMO3-RATE=%X\n",
+		       "SISO-RATE=%X MIMO2-RATE=%X\n",
 		       lq_sta->active_siso_rate,
-		       lq_sta->active_mimo2_rate,
-		       lq_sta->active_mimo3_rate);
+		       lq_sta->active_mimo2_rate);
 
 	/* These values will be overridden later */
 	lq_sta->lq.single_stream_ant_msk =
@@ -2903,8 +2589,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	   (is_legacy(tbl->lq_type)) ? "legacy" : "HT");
 	if (is_Ht(tbl->lq_type)) {
 		desc += sprintf(buff+desc, " %s",
-		   (is_siso(tbl->lq_type)) ? "SISO" :
-		   ((is_mimo2(tbl->lq_type)) ? "MIMO2" : "MIMO3"));
+		   (is_siso(tbl->lq_type)) ? "SISO" : "MIMO2");
 		   desc += sprintf(buff+desc, " %s",
 		   (tbl->is_ht40) ? "40MHz" : "20MHz");
 		   desc += sprintf(buff+desc, " %s %s %s\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 9ac7c0b..335cf16 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -38,7 +38,6 @@ struct iwl_rs_rate_info {
 	u8 plcp;	/* uCode API:  IWL_RATE_6M_PLCP, etc. */
 	u8 plcp_siso;	/* uCode API:  IWL_RATE_SISO_6M_PLCP, etc. */
 	u8 plcp_mimo2;	/* uCode API:  IWL_RATE_MIMO2_6M_PLCP, etc. */
-	u8 plcp_mimo3;  /* uCode API:  IWL_RATE_MIMO3_6M_PLCP, etc. */
 	u8 prev_rs;      /* previous rate used in rs algo */
 	u8 next_rs;      /* next rate used in rs algo */
 };
@@ -143,47 +142,22 @@ enum {
 #define IWL_LEGACY_SWITCH_ANTENNA1      0
 #define IWL_LEGACY_SWITCH_ANTENNA2      1
 #define IWL_LEGACY_SWITCH_SISO          2
-#define IWL_LEGACY_SWITCH_MIMO2_AB      3
-#define IWL_LEGACY_SWITCH_MIMO2_AC      4
-#define IWL_LEGACY_SWITCH_MIMO2_BC      5
-#define IWL_LEGACY_SWITCH_MIMO3_ABC     6
+#define IWL_LEGACY_SWITCH_MIMO2         3
 
 /* possible actions when in siso mode */
 #define IWL_SISO_SWITCH_ANTENNA1        0
 #define IWL_SISO_SWITCH_ANTENNA2        1
-#define IWL_SISO_SWITCH_MIMO2_AB        2
-#define IWL_SISO_SWITCH_MIMO2_AC        3
-#define IWL_SISO_SWITCH_MIMO2_BC        4
-#define IWL_SISO_SWITCH_GI              5
-#define IWL_SISO_SWITCH_MIMO3_ABC       6
-
+#define IWL_SISO_SWITCH_MIMO2           2
+#define IWL_SISO_SWITCH_GI              3
 
 /* possible actions when in mimo mode */
 #define IWL_MIMO2_SWITCH_ANTENNA1       0
 #define IWL_MIMO2_SWITCH_ANTENNA2       1
 #define IWL_MIMO2_SWITCH_SISO_A         2
 #define IWL_MIMO2_SWITCH_SISO_B         3
-#define IWL_MIMO2_SWITCH_SISO_C         4
-#define IWL_MIMO2_SWITCH_GI             5
-#define IWL_MIMO2_SWITCH_MIMO3_ABC      6
-
-
-/* possible actions when in mimo3 mode */
-#define IWL_MIMO3_SWITCH_ANTENNA1       0
-#define IWL_MIMO3_SWITCH_ANTENNA2       1
-#define IWL_MIMO3_SWITCH_SISO_A         2
-#define IWL_MIMO3_SWITCH_SISO_B         3
-#define IWL_MIMO3_SWITCH_SISO_C         4
-#define IWL_MIMO3_SWITCH_MIMO2_AB       5
-#define IWL_MIMO3_SWITCH_MIMO2_AC       6
-#define IWL_MIMO3_SWITCH_MIMO2_BC       7
-#define IWL_MIMO3_SWITCH_GI             8
-
-
-#define IWL_MAX_11N_MIMO3_SEARCH IWL_MIMO3_SWITCH_GI
-#define IWL_MAX_SEARCH IWL_MIMO2_SWITCH_MIMO3_ABC
+#define IWL_MIMO2_SWITCH_GI             4
 
-/*FIXME:RS:add possible actions for MIMO3*/
+#define IWL_MAX_SEARCH IWL_MIMO2_SWITCH_GI
 
 #define IWL_ACTION_LIMIT		3	/* # possible actions */
 
@@ -218,15 +192,13 @@ enum iwl_table_type {
 	LQ_A,
 	LQ_SISO,	/* high-throughput types */
 	LQ_MIMO2,
-	LQ_MIMO3,
 	LQ_MAX,
 };
 
 #define is_legacy(tbl) (((tbl) == LQ_G) || ((tbl) == LQ_A))
 #define is_siso(tbl) ((tbl) == LQ_SISO)
 #define is_mimo2(tbl) ((tbl) == LQ_MIMO2)
-#define is_mimo3(tbl) ((tbl) == LQ_MIMO3)
-#define is_mimo(tbl) (is_mimo2(tbl) || is_mimo3(tbl))
+#define is_mimo(tbl) is_mimo2(tbl)
 #define is_Ht(tbl) (is_siso(tbl) || is_mimo(tbl))
 #define is_a_band(tbl) ((tbl) == LQ_A)
 #define is_g_and(tbl) ((tbl) == LQ_G)
@@ -298,7 +270,6 @@ struct iwl_lq_sta {
 	u16 active_legacy_rate;
 	u16 active_siso_rate;
 	u16 active_mimo2_rate;
-	u16 active_mimo3_rate;
 	s8 max_rate_idx;     /* Max rate set by user */
 	u8 missed_rate_counter;
 
-- 
1.8.4.rc2

