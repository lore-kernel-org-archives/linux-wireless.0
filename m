Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10630 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbYIIC7H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 22:59:07 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Guy Cohen <guy.cohen@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 3/3] iwlwifi: Added support for 3 antennas
Date: Tue,  9 Sep 2008 10:54:54 +0800
Message-Id: <1220928894-17998-4-git-send-email-yi.zhu@intel.com> (sfid-20080909_045920_039223_89E5AB4C)
In-Reply-To: <1220928894-17998-3-git-send-email-yi.zhu@intel.com>
References: <1220928894-17998-1-git-send-email-yi.zhu@intel.com>
 <1220928894-17998-2-git-send-email-yi.zhu@intel.com>
 <1220928894-17998-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

Added support for 3 antennas for Legacy, SISO and MIMO2.
MIMO3 is still not supported yet.

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |  156 +++++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |   29 ++++--
 2 files changed, 122 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index de00be1..c293e5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1282,15 +1282,23 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action = tbl->action;
 	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
+	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	int ret = 0;
 
 	for (; ;) {
 		switch (tbl->action) {
-		case IWL_LEGACY_SWITCH_ANTENNA:
+		case IWL_LEGACY_SWITCH_ANTENNA1:
+		case IWL_LEGACY_SWITCH_ANTENNA2:
 			IWL_DEBUG_RATE("LQ: Legacy toggle Antenna\n");
 
 			lq_sta->action_counter++;
 
+			if ((tbl->action == IWL_LEGACY_SWITCH_ANTENNA1 &&
+							tx_chains_num <= 1) ||
+			    (tbl->action == IWL_LEGACY_SWITCH_ANTENNA2 &&
+							tx_chains_num <= 2))
+				break;
+
 			/* Don't change antenna if success has been great */
 			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
 				break;
@@ -1300,7 +1308,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 
 			if (rs_toggle_antenna(valid_tx_ant,
 				&search_tbl->current_rate, search_tbl)) {
-				lq_sta->search_better_tbl = 1;
+				rs_set_expected_tpt_table(lq_sta, search_tbl);
 				goto out;
 			}
 			break;
@@ -1313,43 +1321,54 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 			ret = rs_switch_to_siso(priv, lq_sta, conf, sta,
 						 search_tbl, index);
 			if (!ret) {
-				lq_sta->search_better_tbl = 1;
 				lq_sta->action_counter = 0;
 				goto out;
 			}
 
 			break;
-		case IWL_LEGACY_SWITCH_MIMO2:
+		case IWL_LEGACY_SWITCH_MIMO2_AB:
+		case IWL_LEGACY_SWITCH_MIMO2_AC:
+		case IWL_LEGACY_SWITCH_MIMO2_BC:
 			IWL_DEBUG_RATE("LQ: Legacy switch to MIMO2\n");
 
 			/* Set up search table to try MIMO */
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->is_SGI = 0;
-			search_tbl->ant_type = ANT_AB;/*FIXME:RS*/
-				/*FIXME:RS:need to check ant validity*/
+
+			if (tbl->action == IWL_LEGACY_SWITCH_MIMO2_AB)
+				search_tbl->ant_type = ANT_AB;
+			else if (tbl->action == IWL_LEGACY_SWITCH_MIMO2_AC)
+				search_tbl->ant_type = ANT_AC;
+			else
+				search_tbl->ant_type = ANT_BC;
+
+			if (!rs_is_valid_ant(valid_tx_ant, search_tbl->ant_type))
+				break;
+
 			ret = rs_switch_to_mimo2(priv, lq_sta, conf, sta,
 						 search_tbl, index);
 			if (!ret) {
-				lq_sta->search_better_tbl = 1;
 				lq_sta->action_counter = 0;
 				goto out;
 			}
 			break;
 		}
 		tbl->action++;
-		if (tbl->action > IWL_LEGACY_SWITCH_MIMO2)
-			tbl->action = IWL_LEGACY_SWITCH_ANTENNA;
+		if (tbl->action > IWL_LEGACY_SWITCH_MIMO2_BC)
+			tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
 
 		if (tbl->action == start_action)
 			break;
 
 	}
+	search_tbl->lq_type = LQ_NONE;
 	return 0;
 
- out:
+out:
+	lq_sta->search_better_tbl = 1;
 	tbl->action++;
-	if (tbl->action > IWL_LEGACY_SWITCH_MIMO2)
-		tbl->action = IWL_LEGACY_SWITCH_ANTENNA;
+	if (tbl->action > IWL_LEGACY_SWITCH_MIMO2_BC)
+		tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
 	return 0;
 
 }
@@ -1371,34 +1390,51 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action = tbl->action;
 	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
+	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	int ret;
 
 	for (;;) {
 		lq_sta->action_counter++;
 		switch (tbl->action) {
-		case IWL_SISO_SWITCH_ANTENNA:
+		case IWL_SISO_SWITCH_ANTENNA1:
+		case IWL_SISO_SWITCH_ANTENNA2:
 			IWL_DEBUG_RATE("LQ: SISO toggle Antenna\n");
+
+			if ((tbl->action == IWL_SISO_SWITCH_ANTENNA1 &&
+							tx_chains_num <= 1) ||
+			    (tbl->action == IWL_SISO_SWITCH_ANTENNA2 &&
+							tx_chains_num <= 2))
+				break;
+
 			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
 				break;
 
 			memcpy(search_tbl, tbl, sz);
 			if (rs_toggle_antenna(valid_tx_ant,
-				       &search_tbl->current_rate, search_tbl)) {
-				lq_sta->search_better_tbl = 1;
+				       &search_tbl->current_rate, search_tbl))
 				goto out;
-			}
 			break;
-		case IWL_SISO_SWITCH_MIMO2:
+		case IWL_SISO_SWITCH_MIMO2_AB:
+		case IWL_SISO_SWITCH_MIMO2_AC:
+		case IWL_SISO_SWITCH_MIMO2_BC:
 			IWL_DEBUG_RATE("LQ: SISO switch to MIMO2\n");
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->is_SGI = 0;
-			search_tbl->ant_type = ANT_AB; /*FIXME:RS*/
+
+			if (tbl->action == IWL_SISO_SWITCH_MIMO2_AB)
+				search_tbl->ant_type = ANT_AB;
+			else if (tbl->action == IWL_SISO_SWITCH_MIMO2_AC)
+				search_tbl->ant_type = ANT_AC;
+			else
+				search_tbl->ant_type = ANT_BC;
+
+			if (!rs_is_valid_ant(valid_tx_ant, search_tbl->ant_type))
+				break;
+
 			ret = rs_switch_to_mimo2(priv, lq_sta, conf, sta,
 						 search_tbl, index);
-			if (!ret) {
-				lq_sta->search_better_tbl = 1;
+			if (!ret)
 				goto out;
-			}
 			break;
 		case IWL_SISO_SWITCH_GI:
 			if (!tbl->is_fat &&
@@ -1428,22 +1464,23 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 			}
 			search_tbl->current_rate = rate_n_flags_from_tbl(
 						search_tbl, index, is_green);
-			lq_sta->search_better_tbl = 1;
 			goto out;
 		}
 		tbl->action++;
 		if (tbl->action > IWL_SISO_SWITCH_GI)
-			tbl->action = IWL_SISO_SWITCH_ANTENNA;
+			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 
 		if (tbl->action == start_action)
 			break;
 	}
+	search_tbl->lq_type = LQ_NONE;
 	return 0;
 
  out:
+	lq_sta->search_better_tbl = 1;
 	tbl->action++;
 	if (tbl->action > IWL_SISO_SWITCH_GI)
-		tbl->action = IWL_SISO_SWITCH_ANTENNA;
+		tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 	return 0;
 }
 
@@ -1459,37 +1496,58 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct iwl_scale_tbl_info *search_tbl =
 				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
+	struct iwl_rate_scale_data *window = &(tbl->win[index]);
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action = tbl->action;
-	/*u8 valid_tx_ant = priv->hw_params.valid_tx_ant;*/
+	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
+	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	int ret;
 
 	for (;;) {
 		lq_sta->action_counter++;
 		switch (tbl->action) {
-		case IWL_MIMO_SWITCH_ANTENNA_A:
-		case IWL_MIMO_SWITCH_ANTENNA_B:
+		case IWL_MIMO2_SWITCH_ANTENNA1:
+		case IWL_MIMO2_SWITCH_ANTENNA2:
+			IWL_DEBUG_RATE("LQ: MIMO toggle Antennas\n");
+
+			if (tx_chains_num <= 2)
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
+		case IWL_MIMO2_SWITCH_SISO_A:
+		case IWL_MIMO2_SWITCH_SISO_B:
+		case IWL_MIMO2_SWITCH_SISO_C:
 			IWL_DEBUG_RATE("LQ: MIMO2 switch to SISO\n");
 
 			/* Set up new search table for SISO */
 			memcpy(search_tbl, tbl, sz);
 
-			/*FIXME:RS:need to check ant validity + C*/
-			if (tbl->action == IWL_MIMO_SWITCH_ANTENNA_A)
+			if (tbl->action == IWL_MIMO2_SWITCH_SISO_A)
 				search_tbl->ant_type = ANT_A;
-			else
+			else if (tbl->action == IWL_MIMO2_SWITCH_SISO_B)
 				search_tbl->ant_type = ANT_B;
+			else
+				search_tbl->ant_type = ANT_C;
+
+			if (!rs_is_valid_ant(valid_tx_ant, search_tbl->ant_type))
+				break;
 
 			ret = rs_switch_to_siso(priv, lq_sta, conf, sta,
 						 search_tbl, index);
-			if (!ret) {
-				lq_sta->search_better_tbl = 1;
+			if (!ret)
 				goto out;
-			}
+
 			break;
 
-		case IWL_MIMO_SWITCH_GI:
+		case IWL_MIMO2_SWITCH_GI:
 			if (!tbl->is_fat &&
 				!(priv->current_ht_config.sgf &
 						HT_SHORT_GI_20MHZ))
@@ -1518,23 +1576,23 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 			}
 			search_tbl->current_rate = rate_n_flags_from_tbl(
 						search_tbl, index, is_green);
-			lq_sta->search_better_tbl = 1;
 			goto out;
 
 		}
 		tbl->action++;
-		if (tbl->action > IWL_MIMO_SWITCH_GI)
-			tbl->action = IWL_MIMO_SWITCH_ANTENNA_A;
+		if (tbl->action > IWL_MIMO2_SWITCH_GI)
+			tbl->action = IWL_MIMO2_SWITCH_ANTENNA1;
 
 		if (tbl->action == start_action)
 			break;
 	}
-
+	search_tbl->lq_type = LQ_NONE;
 	return 0;
  out:
+	lq_sta->search_better_tbl = 1;
 	tbl->action++;
-	if (tbl->action > IWL_MIMO_SWITCH_GI)
-		tbl->action = IWL_MIMO_SWITCH_ANTENNA_A;
+	if (tbl->action > IWL_MIMO2_SWITCH_GI)
+		tbl->action = IWL_MIMO2_SWITCH_ANTENNA1;
 	return 0;
 
 }
@@ -1749,19 +1807,13 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		rs_stay_in_table(lq_sta);
 
 		goto out;
+	}
 
 	/* Else we have enough samples; calculate estimate of
 	 * actual average throughput */
-	} else {
-		/*FIXME:RS remove this else if we don't get this error*/
-		if (window->average_tpt != ((window->success_ratio *
-				tbl->expected_tpt[index] + 64) / 128)) {
-			IWL_ERROR("expected_tpt should have been calculated"
-								" by now\n");
-			window->average_tpt = ((window->success_ratio *
-					tbl->expected_tpt[index] + 64) / 128);
-		}
-	}
+
+	BUG_ON(window->average_tpt != ((window->success_ratio *
+			tbl->expected_tpt[index] + 64) / 128));
 
 	/* If we are searching for better modulation mode, check success. */
 	if (lq_sta->search_better_tbl) {
@@ -1771,7 +1823,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		 * continuing to use the setup that we've been trying. */
 		if (window->average_tpt > lq_sta->last_tpt) {
 
-			IWL_DEBUG_RATE("LQ: SWITCHING TO CURRENT TABLE "
+			IWL_DEBUG_RATE("LQ: SWITCHING TO NEW TABLE "
 					"suc=%d cur-tpt=%d old-tpt=%d\n",
 					window->success_ratio,
 					window->average_tpt,
@@ -2184,7 +2236,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 		for (i = 0; i < IWL_RATE_COUNT; i++)
 			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
 
-	IWL_DEBUG_RATE("LQ: *** rate scale global init ***\n");
+	IWL_DEBUG_RATE("LQ: *** rate scale station global init ***\n");
 	/* TODO: what is a good starting rate for STA? About middle? Maybe not
 	 * the lowest or the highest rate.. Could consider using RSSI from
 	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 84d4d1e..d148d73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -206,21 +206,28 @@ enum {
 #define IWL_RATE_DECREASE_TH		1920	/*  15% */
 
 /* possible actions when in legacy mode */
-#define IWL_LEGACY_SWITCH_ANTENNA	0
-#define IWL_LEGACY_SWITCH_SISO		1
-#define IWL_LEGACY_SWITCH_MIMO2		2
+#define IWL_LEGACY_SWITCH_ANTENNA1      0
+#define IWL_LEGACY_SWITCH_ANTENNA2      1
+#define IWL_LEGACY_SWITCH_SISO          2
+#define IWL_LEGACY_SWITCH_MIMO2_AB      3
+#define IWL_LEGACY_SWITCH_MIMO2_AC      4
+#define IWL_LEGACY_SWITCH_MIMO2_BC      5
 
 /* possible actions when in siso mode */
-#define IWL_SISO_SWITCH_ANTENNA		0
-#define IWL_SISO_SWITCH_MIMO2		1
-#define IWL_SISO_SWITCH_GI		2
+#define IWL_SISO_SWITCH_ANTENNA1        0
+#define IWL_SISO_SWITCH_ANTENNA2        1
+#define IWL_SISO_SWITCH_MIMO2_AB        2
+#define IWL_SISO_SWITCH_MIMO2_AC        3
+#define IWL_SISO_SWITCH_MIMO2_BC        4
+#define IWL_SISO_SWITCH_GI              5
 
 /* possible actions when in mimo mode */
-#define IWL_MIMO_SWITCH_ANTENNA_A	0
-#define IWL_MIMO_SWITCH_ANTENNA_B	1
-#define IWL_MIMO_SWITCH_GI		2
-
-/*FIXME:RS:separate MIMO2/3 transitions*/
+#define IWL_MIMO2_SWITCH_ANTENNA1       0
+#define IWL_MIMO2_SWITCH_ANTENNA2       1
+#define IWL_MIMO2_SWITCH_SISO_A         2
+#define IWL_MIMO2_SWITCH_SISO_B         3
+#define IWL_MIMO2_SWITCH_SISO_C         4
+#define IWL_MIMO2_SWITCH_GI             5
 
 /*FIXME:RS:add posible acctions for MIMO3*/
 
-- 
1.5.3.6

