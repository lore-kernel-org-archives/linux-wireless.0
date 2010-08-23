Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27344 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab0HWOxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/26] iwlagn: let bluetooth traffic load impact rate scale
Date: Mon, 23 Aug 2010 07:56:58 -0700
Message-Id: <1282575437-23270-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Depending on the amount of bluetooth traffic,
using the shared antenna (antenna B) will have
adverse impact on both bluetooth and wireless
traffic. Add controls to improve the situation
by making rate scaling depend on the BT load.

When there's high bluetooth traffic load, there's
little point in trying to aggregate as BT traffic
would disrupt the aggregated frames all the time,
so simply don't start sessions then.

When BT traffic returns to lower levels, the rate
scaling will come here again automatically when
wifi traffic is high enough, and then it will be
able to successfully enable aggregation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |  113 ++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |    2 +
 2 files changed, 114 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index a456338..f8eed92 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -301,7 +301,19 @@ static int rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 				      struct ieee80211_sta *sta)
 {
 	int ret = -EAGAIN;
-	u32 load = rs_tl_get_load(lq_data, tid);
+	u32 load;
+
+	/*
+	 * Don't create TX aggregation sessions when in high
+	 * BT traffic, as they would just be disrupted by BT.
+	 */
+	if (priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH) {
+		IWL_ERR(priv, "BT traffic (%d), no aggregation allowed\n",
+			priv->bt_traffic_load);
+		return ret;
+	}
+
+	load = rs_tl_get_load(lq_data, tid);
 
 	if (load > IWL_AGG_LOAD_THRESHOLD) {
 		IWL_DEBUG_HT(priv, "Starting Tx agg: STA: %pM tid: %d\n",
@@ -1286,6 +1298,27 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	int ret = 0;
 	u8 update_search_tbl_counter = 0;
 
+	switch (priv->bt_traffic_load) {
+	case IWL_BT_COEX_TRAFFIC_LOAD_NONE:
+		/* nothing */
+		break;
+	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
+		/* avoid antenna B unless MIMO */
+		if (tbl->action == IWL_LEGACY_SWITCH_ANTENNA2)
+			tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
+		break;
+	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
+	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
+		/* avoid antenna B and MIMO */
+		if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2 &&
+		    tbl->action != IWL_LEGACY_SWITCH_SISO)
+			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
+		break;
+	default:
+		IWL_ERR(priv, "Invalid BT load %d", priv->bt_traffic_load);
+		break;
+	}
+
 	if (!iwl_ht_enabled(priv))
 		/* stay in Legacy */
 		tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
@@ -1425,6 +1458,27 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	u8 update_search_tbl_counter = 0;
 	int ret;
 
+	switch (priv->bt_traffic_load) {
+	case IWL_BT_COEX_TRAFFIC_LOAD_NONE:
+		/* nothing */
+		break;
+	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
+		/* avoid antenna B unless MIMO */
+		if (tbl->action == IWL_SISO_SWITCH_ANTENNA2)
+			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
+		break;
+	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
+	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
+		/* avoid antenna B and MIMO */
+		if (tbl->action >= IWL_SISO_SWITCH_ANTENNA2 &&
+		    tbl->action != IWL_SISO_SWITCH_GI)
+			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
+		break;
+	default:
+		IWL_ERR(priv, "Invalid BT load %d", priv->bt_traffic_load);
+		break;
+	}
+
 	if (iwl_tx_ant_restriction(priv) == IWL_ANT_OK_SINGLE &&
 	    tbl->action > IWL_SISO_SWITCH_ANTENNA2) {
 		/* stay in SISO */
@@ -1564,6 +1618,27 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 	u8 update_search_tbl_counter = 0;
 	int ret;
 
+	switch (priv->bt_traffic_load) {
+	case IWL_BT_COEX_TRAFFIC_LOAD_NONE:
+		/* nothing */
+		break;
+	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
+	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
+		/* avoid antenna B and MIMO */
+		if (tbl->action == IWL_MIMO2_SWITCH_MIMO3_ABC)
+			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
+	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
+		/* avoid antenna B unless MIMO */
+		if (tbl->action == IWL_MIMO2_SWITCH_ANTENNA2)
+			tbl->action = IWL_MIMO2_SWITCH_ANTENNA1;
+		else if (tbl->action == IWL_MIMO2_SWITCH_SISO_B)
+			tbl->action = IWL_MIMO2_SWITCH_SISO_A;
+		break;
+	default:
+		IWL_ERR(priv, "Invalid BT load %d", priv->bt_traffic_load);
+		break;
+	}
+
 	if ((iwl_tx_ant_restriction(priv) == IWL_ANT_OK_SINGLE) &&
 	    (tbl->action < IWL_MIMO2_SWITCH_SISO_A ||
 	     tbl->action > IWL_MIMO2_SWITCH_SISO_C)) {
@@ -1706,6 +1781,29 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 	int ret;
 	u8 update_search_tbl_counter = 0;
 
+	switch (priv->bt_traffic_load) {
+	case IWL_BT_COEX_TRAFFIC_LOAD_NONE:
+		/* nothing */
+		break;
+	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
+	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
+		/* avoid antenna B and MIMO */
+		if (tbl->action == IWL_MIMO3_SWITCH_MIMO2_AB ||
+		    tbl->action == IWL_MIMO3_SWITCH_MIMO2_AC ||
+		    tbl->action == IWL_MIMO3_SWITCH_MIMO2_BC)
+			tbl->action = IWL_MIMO3_SWITCH_SISO_A;
+	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
+		/* avoid antenna B unless MIMO */
+		if (tbl->action == IWL_MIMO3_SWITCH_SISO_B)
+			tbl->action = IWL_MIMO3_SWITCH_SISO_A;
+		else if (tbl->action == IWL_MIMO3_SWITCH_ANTENNA2)
+			tbl->action = IWL_MIMO3_SWITCH_ANTENNA1;
+		break;
+	default:
+		IWL_ERR(priv, "Invalid BT load %d", priv->bt_traffic_load);
+		break;
+	}
+
 	if ((iwl_tx_ant_restriction(priv) == IWL_ANT_OK_SINGLE) &&
 	    (tbl->action < IWL_MIMO3_SWITCH_SISO_A ||
 	     tbl->action > IWL_MIMO3_SWITCH_SISO_C)) {
@@ -2234,6 +2332,19 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	if (iwl_tx_ant_restriction(priv) != IWL_ANT_OK_MULTI &&
 		(is_mimo2(tbl->lq_type) || is_mimo3(tbl->lq_type)))
 		scale_action = -1;
+
+	if (lq_sta->last_bt_traffic > priv->bt_traffic_load) {
+		lq_sta->last_bt_traffic = priv->bt_traffic_load;
+		/*
+		 * don't set scale_action, don't want to scale up if
+		 * the rate scale doesn't otherwise think that is a
+		 * good idea.
+		 */
+	} else if (lq_sta->last_bt_traffic < priv->bt_traffic_load) {
+		lq_sta->last_bt_traffic = priv->bt_traffic_load;
+		scale_action = -1;
+	}
+
 	switch (scale_action) {
 	case -1:
 		/* Decrease starting rate, update uCode's rate table */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 8292f6d..3970ab1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -432,6 +432,8 @@ struct iwl_lq_sta {
 	u32 last_rate_n_flags;
 	/* packets destined for this STA are aggregated */
 	u8 is_agg;
+	/* BT traffic this sta was last updated in */
+	u8 last_bt_traffic;
 };
 
 static inline u8 num_of_ant(u8 mask)
-- 
1.7.0.4

