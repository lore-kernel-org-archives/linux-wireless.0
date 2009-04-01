Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46260 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765119AbZDAV1s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 17:27:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/3] iwlwifi: adding MIMO3 support in rate scaling
Date: Wed,  1 Apr 2009 14:33:24 -0700
Message-Id: <1238621605-14846-3-git-send-email-reinette.chatre@intel.com> (sfid-20090401_232755_672531_F5152EEF)
In-Reply-To: <1238621605-14846-2-git-send-email-reinette.chatre@intel.com>
References: <1238621605-14846-1-git-send-email-reinette.chatre@intel.com>
 <1238621605-14846-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Separated the MIMO tpt matrix into MIMO2 and MIMO3, adding MIMO3 support
in rate scaling algorithm. If the device support 3x3, then utilize all
three antenna (A/B/C) for tx to improve throughput.

Adding rs_switch_to_mimo3() function to allow switch to mimo3 modulation
mode from other modes(legacy/siso/mimo2). Adding rs_move_mimo3_to_other()
function to allow switch from mimo3 modulation mode to either siso or mimo2;
also support toggle between SGI and NGI.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |  331 ++++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |   18 ++
 2 files changed, 325 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index cab7842..7cdbcfe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -191,7 +191,7 @@ static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
  * 1, 2, 5.5, 11, 6, 9, 12, 18, 24, 36, 48, 54, 60 MBits
  * "G" is the only table that supports CCK (the first 4 rates).
  */
-/*FIXME:RS:need to separate tables for MIMO2/MIMO3*/
+
 static s32 expected_tpt_A[IWL_RATE_COUNT] = {
 	0, 0, 0, 0, 40, 57, 72, 98, 121, 154, 177, 186, 186
 };
@@ -208,11 +208,11 @@ static s32 expected_tpt_siso20MHzSGI[IWL_RATE_COUNT] = {
 	0, 0, 0, 0, 46, 46, 82, 110, 132, 168, 192, 202, 211
 };
 
-static s32 expected_tpt_mimo20MHz[IWL_RATE_COUNT] = {
+static s32 expected_tpt_mimo2_20MHz[IWL_RATE_COUNT] = {
 	0, 0, 0, 0, 74, 74, 123, 155, 179, 214, 236, 244, 251
 };
 
-static s32 expected_tpt_mimo20MHzSGI[IWL_RATE_COUNT] = {
+static s32 expected_tpt_mimo2_20MHzSGI[IWL_RATE_COUNT] = {
 	0, 0, 0, 0, 81, 81, 131, 164, 188, 222, 243, 251, 257
 };
 
@@ -224,14 +224,31 @@ static s32 expected_tpt_siso40MHzSGI[IWL_RATE_COUNT] = {
 	0, 0, 0, 0, 83, 83, 135, 169, 193, 229, 250, 257, 264
 };
 
-static s32 expected_tpt_mimo40MHz[IWL_RATE_COUNT] = {
+static s32 expected_tpt_mimo2_40MHz[IWL_RATE_COUNT] = {
 	0, 0, 0, 0, 123, 123, 182, 214, 235, 264, 279, 285, 289
 };
 
-static s32 expected_tpt_mimo40MHzSGI[IWL_RATE_COUNT] = {
+static s32 expected_tpt_mimo2_40MHzSGI[IWL_RATE_COUNT] = {
 	0, 0, 0, 0, 131, 131, 191, 222, 242, 270, 284, 289, 293
 };
 
+/* Expected throughput metric MIMO3 */
+static s32 expected_tpt_mimo3_20MHz[IWL_RATE_COUNT] = {
+	0, 0, 0, 0, 99, 99, 153, 186, 208, 239, 256, 263, 268
+};
+
+static s32 expected_tpt_mimo3_20MHzSGI[IWL_RATE_COUNT] = {
+	0, 0, 0, 0, 106, 106, 162, 194, 215, 246, 262, 268, 273
+};
+
+static s32 expected_tpt_mimo3_40MHz[IWL_RATE_COUNT] = {
+	0, 0, 0, 0, 152, 152, 211, 239, 255, 279, 290, 294, 297
+};
+
+static s32 expected_tpt_mimo3_40MHzSGI[IWL_RATE_COUNT] = {
+	0, 0, 0, 0, 160, 160, 219, 245, 261, 284, 294, 297, 300
+};
+
 static inline u8 rs_extract_rate(u32 rate_n_flags)
 {
 	return (u8)(rate_n_flags & 0xFF);
@@ -1011,17 +1028,26 @@ static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 			tbl->expected_tpt = expected_tpt_siso20MHzSGI;
 		else
 			tbl->expected_tpt = expected_tpt_siso20MHz;
-
-	} else if (is_mimo(tbl->lq_type)) { /* FIXME:need to separate mimo2/3 */
+	} else if (is_mimo2(tbl->lq_type)) {
+		if (tbl->is_fat && !lq_sta->is_dup)
+			if (tbl->is_SGI)
+				tbl->expected_tpt = expected_tpt_mimo2_40MHzSGI;
+			else
+				tbl->expected_tpt = expected_tpt_mimo2_40MHz;
+		else if (tbl->is_SGI)
+			tbl->expected_tpt = expected_tpt_mimo2_20MHzSGI;
+		else
+			tbl->expected_tpt = expected_tpt_mimo2_20MHz;
+	} else if (is_mimo3(tbl->lq_type)) {
 		if (tbl->is_fat && !lq_sta->is_dup)
 			if (tbl->is_SGI)
-				tbl->expected_tpt = expected_tpt_mimo40MHzSGI;
+				tbl->expected_tpt = expected_tpt_mimo3_40MHzSGI;
 			else
-				tbl->expected_tpt = expected_tpt_mimo40MHz;
+				tbl->expected_tpt = expected_tpt_mimo3_40MHz;
 		else if (tbl->is_SGI)
-			tbl->expected_tpt = expected_tpt_mimo20MHzSGI;
+			tbl->expected_tpt = expected_tpt_mimo3_20MHzSGI;
 		else
-			tbl->expected_tpt = expected_tpt_mimo20MHz;
+			tbl->expected_tpt = expected_tpt_mimo3_20MHz;
 	} else
 		tbl->expected_tpt = expected_tpt_G;
 }
@@ -1130,7 +1156,7 @@ static s32 rs_get_best_rate(struct iwl_priv *priv,
 }
 
 /*
- * Set up search table for MIMO
+ * Set up search table for MIMO2
  */
 static int rs_switch_to_mimo2(struct iwl_priv *priv,
 			     struct iwl_lq_sta *lq_sta,
@@ -1183,7 +1209,73 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index);
 
 	IWL_DEBUG_RATE(priv, "LQ: MIMO2 best rate %d mask %X\n", rate, rate_mask);
+	if ((rate == IWL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
+		IWL_DEBUG_RATE(priv, "Can't switch with index %d rate mask %x\n",
+						rate, rate_mask);
+		return -1;
+	}
+	tbl->current_rate = rate_n_flags_from_tbl(priv, tbl, rate, is_green);
+
+	IWL_DEBUG_RATE(priv, "LQ: Switch to new mcs %X index is green %X\n",
+		     tbl->current_rate, is_green);
+	return 0;
+}
+
+/*
+ * Set up search table for MIMO3
+ */
+static int rs_switch_to_mimo3(struct iwl_priv *priv,
+			     struct iwl_lq_sta *lq_sta,
+			     struct ieee80211_conf *conf,
+			     struct ieee80211_sta *sta,
+			     struct iwl_scale_tbl_info *tbl, int index)
+{
+	u16 rate_mask;
+	s32 rate;
+	s8 is_green = lq_sta->is_green;
+
+	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
+		return -1;
+
+	if (((sta->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
+						== WLAN_HT_CAP_SM_PS_STATIC)
+		return -1;
+
+	/* Need both Tx chains/antennas to support MIMO */
+	if (priv->hw_params.tx_chains_num < 3)
+		return -1;
+
+	IWL_DEBUG_RATE(priv, "LQ: try to switch to MIMO3\n");
+
+	tbl->lq_type = LQ_MIMO3;
+	tbl->is_dup = lq_sta->is_dup;
+	tbl->action = 0;
+	rate_mask = lq_sta->active_mimo3_rate;
+
+	if (priv->current_ht_config.supported_chan_width
+					== IWL_CHANNEL_WIDTH_40MHZ)
+		tbl->is_fat = 1;
+	else
+		tbl->is_fat = 0;
 
+	/* FIXME: - don't toggle SGI here
+	if (tbl->is_fat) {
+		if (priv->current_ht_config.sgf & HT_SHORT_GI_40MHZ_ONLY)
+			tbl->is_SGI = 1;
+		else
+			tbl->is_SGI = 0;
+	} else if (priv->current_ht_config.sgf & HT_SHORT_GI_20MHZ_ONLY)
+		tbl->is_SGI = 1;
+	else
+		tbl->is_SGI = 0;
+	*/
+
+	rs_set_expected_tpt_table(lq_sta, tbl);
+
+	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index);
+
+	IWL_DEBUG_RATE(priv, "LQ: MIMO3 best rate %d mask %X\n",
+		rate, rate_mask);
 	if ((rate == IWL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
 		IWL_DEBUG_RATE(priv, "Can't switch with index %d rate mask %x\n",
 						rate, rate_mask);
@@ -1342,9 +1434,29 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 				goto out;
 			}
 			break;
+
+		case IWL_LEGACY_SWITCH_MIMO3_ABC:
+			IWL_DEBUG_RATE(priv, "LQ: Legacy switch to MIMO3\n");
+
+			/* Set up search table to try MIMO3 */
+			memcpy(search_tbl, tbl, sz);
+			search_tbl->is_SGI = 0;
+
+			search_tbl->ant_type = ANT_ABC;
+
+			if (!rs_is_valid_ant(valid_tx_ant, search_tbl->ant_type))
+				break;
+
+			ret = rs_switch_to_mimo3(priv, lq_sta, conf, sta,
+						 search_tbl, index);
+			if (!ret) {
+				lq_sta->action_counter = 0;
+				goto out;
+			}
+			break;
 		}
 		tbl->action++;
-		if (tbl->action > IWL_LEGACY_SWITCH_MIMO2_BC)
+		if (tbl->action > IWL_LEGACY_SWITCH_MIMO3_ABC)
 			tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
 
 		if (tbl->action == start_action)
@@ -1357,7 +1469,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 out:
 	lq_sta->search_better_tbl = 1;
 	tbl->action++;
-	if (tbl->action > IWL_LEGACY_SWITCH_MIMO2_BC)
+	if (tbl->action > IWL_LEGACY_SWITCH_MIMO3_ABC)
 		tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
 	return 0;
 
@@ -1457,9 +1569,23 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 				rate_n_flags_from_tbl(priv, search_tbl,
 						      index, is_green);
 			goto out;
+		case IWL_SISO_SWITCH_MIMO3_ABC:
+			IWL_DEBUG_RATE(priv, "LQ: SISO switch to MIMO3\n");
+			memcpy(search_tbl, tbl, sz);
+			search_tbl->is_SGI = 0;
+			search_tbl->ant_type = ANT_ABC;
+
+			if (!rs_is_valid_ant(valid_tx_ant, search_tbl->ant_type))
+				break;
+
+			ret = rs_switch_to_mimo3(priv, lq_sta, conf, sta,
+						 search_tbl, index);
+			if (!ret)
+				goto out;
+			break;
 		}
 		tbl->action++;
-		if (tbl->action > IWL_SISO_SWITCH_GI)
+		if (tbl->action > IWL_LEGACY_SWITCH_MIMO3_ABC)
 			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 
 		if (tbl->action == start_action)
@@ -1471,15 +1597,15 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
  out:
 	lq_sta->search_better_tbl = 1;
 	tbl->action++;
-	if (tbl->action > IWL_SISO_SWITCH_GI)
+	if (tbl->action > IWL_SISO_SWITCH_MIMO3_ABC)
 		tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 	return 0;
 }
 
 /*
- * Try to switch to new modulation mode from MIMO
+ * Try to switch to new modulation mode from MIMO2
  */
-static int rs_move_mimo_to_other(struct iwl_priv *priv,
+static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 				 struct iwl_lq_sta *lq_sta,
 				 struct ieee80211_conf *conf,
 				 struct ieee80211_sta *sta, int index)
@@ -1501,7 +1627,7 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 		switch (tbl->action) {
 		case IWL_MIMO2_SWITCH_ANTENNA1:
 		case IWL_MIMO2_SWITCH_ANTENNA2:
-			IWL_DEBUG_RATE(priv, "LQ: MIMO toggle Antennas\n");
+			IWL_DEBUG_RATE(priv, "LQ: MIMO2 toggle Antennas\n");
 
 			if (tx_chains_num <= 2)
 				break;
@@ -1549,9 +1675,9 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 						HT_SHORT_GI_40MHZ))
 				break;
 
-			IWL_DEBUG_RATE(priv, "LQ: MIMO toggle SGI/NGI\n");
+			IWL_DEBUG_RATE(priv, "LQ: MIMO2 toggle SGI/NGI\n");
 
-			/* Set up new search table for MIMO */
+			/* Set up new search table for MIMO2 */
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->is_SGI = !tbl->is_SGI;
 			rs_set_expected_tpt_table(lq_sta, search_tbl);
@@ -1571,9 +1697,24 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 						      index, is_green);
 			goto out;
 
+		case IWL_MIMO2_SWITCH_MIMO3_ABC:
+			IWL_DEBUG_RATE(priv, "LQ: MIMO2 switch to MIMO3\n");
+			memcpy(search_tbl, tbl, sz);
+			search_tbl->is_SGI = 0;
+			search_tbl->ant_type = ANT_ABC;
+
+			if (!rs_is_valid_ant(valid_tx_ant, search_tbl->ant_type))
+				break;
+
+			ret = rs_switch_to_mimo3(priv, lq_sta, conf, sta,
+						 search_tbl, index);
+			if (!ret)
+				goto out;
+
+			break;
 		}
 		tbl->action++;
-		if (tbl->action > IWL_MIMO2_SWITCH_GI)
+		if (tbl->action > IWL_MIMO2_SWITCH_MIMO3_ABC)
 			tbl->action = IWL_MIMO2_SWITCH_ANTENNA1;
 
 		if (tbl->action == start_action)
@@ -1584,13 +1725,150 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
  out:
 	lq_sta->search_better_tbl = 1;
 	tbl->action++;
-	if (tbl->action > IWL_MIMO2_SWITCH_GI)
+	if (tbl->action > IWL_MIMO2_SWITCH_MIMO3_ABC)
 		tbl->action = IWL_MIMO2_SWITCH_ANTENNA1;
 	return 0;
 
 }
 
 /*
+ * Try to switch to new modulation mode from MIMO3
+ */
+static int rs_move_mimo3_to_other(struct iwl_priv *priv,
+				 struct iwl_lq_sta *lq_sta,
+				 struct ieee80211_conf *conf,
+				 struct ieee80211_sta *sta, int index)
+{
+	s8 is_green = lq_sta->is_green;
+	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
+	struct iwl_scale_tbl_info *search_tbl =
+				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
+	struct iwl_rate_scale_data *window = &(tbl->win[index]);
+	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
+		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
+	u8 start_action = tbl->action;
+	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
+	u8 tx_chains_num = priv->hw_params.tx_chains_num;
+	int ret;
+
+	for (;;) {
+		lq_sta->action_counter++;
+		switch (tbl->action) {
+		case IWL_MIMO3_SWITCH_ANTENNA1:
+		case IWL_MIMO3_SWITCH_ANTENNA2:
+			IWL_DEBUG_RATE(priv, "LQ: MIMO3 toggle Antennas\n");
+
+			if (tx_chains_num <= 3)
+				break;
+
+			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
+				break;
+
+			memcpy(search_tbl, tbl, sz);
+			if (rs_toggle_antenna(valid_tx_ant,
+				       &search_tbl->current_rate, search_tbl))
+				goto out;
+			break;
+		case IWL_MIMO3_SWITCH_SISO_A:
+		case IWL_MIMO3_SWITCH_SISO_B:
+		case IWL_MIMO3_SWITCH_SISO_C:
+			IWL_DEBUG_RATE(priv, "LQ: MIMO3 switch to SISO\n");
+
+			/* Set up new search table for SISO */
+			memcpy(search_tbl, tbl, sz);
+
+			if (tbl->action == IWL_MIMO3_SWITCH_SISO_A)
+				search_tbl->ant_type = ANT_A;
+			else if (tbl->action == IWL_MIMO3_SWITCH_SISO_B)
+				search_tbl->ant_type = ANT_B;
+			else
+				search_tbl->ant_type = ANT_C;
+
+			if (!rs_is_valid_ant(valid_tx_ant, search_tbl->ant_type))
+				break;
+
+			ret = rs_switch_to_siso(priv, lq_sta, conf, sta,
+						 search_tbl, index);
+			if (!ret)
+				goto out;
+
+			break;
+
+		case IWL_MIMO3_SWITCH_MIMO2_AB:
+		case IWL_MIMO3_SWITCH_MIMO2_AC:
+		case IWL_MIMO3_SWITCH_MIMO2_BC:
+			IWL_DEBUG_RATE(priv, "LQ: MIMO3 switch to MIMO2\n");
+
+			memcpy(search_tbl, tbl, sz);
+			search_tbl->is_SGI = 0;
+			if (tbl->action == IWL_MIMO3_SWITCH_MIMO2_AB)
+				search_tbl->ant_type = ANT_AB;
+			else if (tbl->action == IWL_MIMO3_SWITCH_MIMO2_AC)
+				search_tbl->ant_type = ANT_AC;
+			else
+				search_tbl->ant_type = ANT_BC;
+
+			if (!rs_is_valid_ant(valid_tx_ant, search_tbl->ant_type))
+				break;
+
+			ret = rs_switch_to_mimo2(priv, lq_sta, conf, sta,
+						 search_tbl, index);
+			if (!ret)
+				goto out;
+
+			break;
+
+		case IWL_MIMO3_SWITCH_GI:
+			if (!tbl->is_fat &&
+				!(priv->current_ht_config.sgf &
+						HT_SHORT_GI_20MHZ))
+				break;
+			if (tbl->is_fat &&
+				!(priv->current_ht_config.sgf &
+						HT_SHORT_GI_40MHZ))
+				break;
+
+			IWL_DEBUG_RATE(priv, "LQ: MIMO3 toggle SGI/NGI\n");
+
+			/* Set up new search table for MIMO */
+			memcpy(search_tbl, tbl, sz);
+			search_tbl->is_SGI = !tbl->is_SGI;
+			rs_set_expected_tpt_table(lq_sta, search_tbl);
+			/*
+			 * If active table already uses the fastest possible
+			 * modulation (dual stream with short guard interval),
+			 * and it's working well, there's no need to look
+			 * for a better type of modulation!
+			 */
+			if (tbl->is_SGI) {
+				s32 tpt = lq_sta->last_tpt / 100;
+				if (tpt >= search_tbl->expected_tpt[index])
+					break;
+			}
+			search_tbl->current_rate =
+				rate_n_flags_from_tbl(priv, search_tbl,
+						      index, is_green);
+			goto out;
+		}
+		tbl->action++;
+		if (tbl->action > IWL_MIMO3_SWITCH_GI)
+			tbl->action = IWL_MIMO3_SWITCH_ANTENNA1;
+
+		if (tbl->action == start_action)
+			break;
+	}
+	search_tbl->lq_type = LQ_NONE;
+	return 0;
+ out:
+	lq_sta->search_better_tbl = 1;
+	tbl->action++;
+	if (tbl->action > IWL_MIMO3_SWITCH_GI)
+		tbl->action = IWL_MIMO3_SWITCH_ANTENNA1;
+	return 0;
+
+}
+
+/*
  * Check whether we should continue using same modulation mode, or
  * begin search for a new mode, based on:
  * 1) # tx successes or failures while using this mode
@@ -1997,8 +2275,10 @@ lq_update:
 			rs_move_legacy_other(priv, lq_sta, conf, sta, index);
 		else if (is_siso(tbl->lq_type))
 			rs_move_siso_to_other(priv, lq_sta, conf, sta, index);
+		else if (is_mimo2(tbl->lq_type))
+			rs_move_mimo2_to_other(priv, lq_sta, conf, sta, index);
 		else
-			rs_move_mimo_to_other(priv, lq_sta, conf, sta, index);
+			rs_move_mimo3_to_other(priv, lq_sta, conf, sta, index);
 
 		/* If new "search" mode was selected, set up in uCode table */
 		if (lq_sta->search_better_tbl) {
@@ -2362,6 +2642,9 @@ static void rs_fill_link_cmd(const struct iwl_priv *priv,
 	} else if (num_of_ant(tbl_type.ant_type) == 2) {
 		lq_cmd->general_params.dual_stream_ant_msk =
 						tbl_type.ant_type;
+	} else if (num_of_ant(tbl_type.ant_type) == 3) {
+		lq_cmd->general_params.dual_stream_ant_msk =
+						tbl_type.ant_type;
 	} /* otherwise we don't modify the existing value */
 
 	index++;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index ab59acc..9cd90ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -241,6 +241,7 @@ enum {
 #define IWL_LEGACY_SWITCH_MIMO2_AB      3
 #define IWL_LEGACY_SWITCH_MIMO2_AC      4
 #define IWL_LEGACY_SWITCH_MIMO2_BC      5
+#define IWL_LEGACY_SWITCH_MIMO3_ABC     6
 
 /* possible actions when in siso mode */
 #define IWL_SISO_SWITCH_ANTENNA1        0
@@ -249,6 +250,8 @@ enum {
 #define IWL_SISO_SWITCH_MIMO2_AC        3
 #define IWL_SISO_SWITCH_MIMO2_BC        4
 #define IWL_SISO_SWITCH_GI              5
+#define IWL_SISO_SWITCH_MIMO3_ABC       6
+
 
 /* possible actions when in mimo mode */
 #define IWL_MIMO2_SWITCH_ANTENNA1       0
@@ -257,6 +260,21 @@ enum {
 #define IWL_MIMO2_SWITCH_SISO_B         3
 #define IWL_MIMO2_SWITCH_SISO_C         4
 #define IWL_MIMO2_SWITCH_GI             5
+#define IWL_MIMO2_SWITCH_MIMO3_ABC      6
+
+
+/* possible actions when in mimo3 mode */
+#define IWL_MIMO3_SWITCH_ANTENNA1       0
+#define IWL_MIMO3_SWITCH_ANTENNA2       1
+#define IWL_MIMO3_SWITCH_SISO_A         2
+#define IWL_MIMO3_SWITCH_SISO_B         3
+#define IWL_MIMO3_SWITCH_SISO_C         4
+#define IWL_MIMO3_SWITCH_MIMO2_AB       5
+#define IWL_MIMO3_SWITCH_MIMO2_AC       6
+#define IWL_MIMO3_SWITCH_MIMO2_BC       7
+#define IWL_MIMO3_SWITCH_GI             8
+
+
 
 /*FIXME:RS:add possible actions for MIMO3*/
 
-- 
1.5.6.3

