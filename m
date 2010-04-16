Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583Ab0DPVwo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/21] iwlwifi: sanity check for turn on aggregation tid
Date: Fri, 16 Apr 2010 14:52:32 -0700
Message-Id: <1271454758-14351-16-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Perform sanity check for turn on aggregation tid. Also remove the
option for turn on all the aggregation tids at once since it is
deprecated function and not being used.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   34 ++++++++++++++--------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 5bc406c..8f8d5e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -294,11 +294,11 @@ static u32 rs_tl_get_load(struct iwl_lq_sta *lq_data, u8 tid)
 	return tl->total;
 }
 
-static void rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
+static int rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 				      struct iwl_lq_sta *lq_data, u8 tid,
 				      struct ieee80211_sta *sta)
 {
-	int ret;
+	int ret = -EAGAIN;
 
 	if (rs_tl_get_load(lq_data, tid) > IWL_AGG_LOAD_THRESHOLD) {
 		IWL_DEBUG_HT(priv, "Starting Tx agg: STA: %pM tid: %d\n",
@@ -312,29 +312,29 @@ static void rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 			 */
 			IWL_DEBUG_HT(priv, "Fail start Tx agg on tid: %d\n",
 				tid);
-			ret = ieee80211_stop_tx_ba_session(sta, tid,
+			ieee80211_stop_tx_ba_session(sta, tid,
 						WLAN_BACK_INITIATOR);
 		}
-	}
+	} else
+		IWL_ERR(priv, "Fail finding valid aggregation tid: %d\n", tid);
+	return ret;
 }
 
 static void rs_tl_turn_on_agg(struct iwl_priv *priv, u8 tid,
 			      struct iwl_lq_sta *lq_data,
 			      struct ieee80211_sta *sta)
 {
-	if ((tid < TID_MAX_LOAD_COUNT))
-		rs_tl_turn_on_agg_for_tid(priv, lq_data, tid, sta);
-	else if (tid == IWL_AGG_ALL_TID)
-		for (tid = 0; tid < TID_MAX_LOAD_COUNT; tid++)
-			rs_tl_turn_on_agg_for_tid(priv, lq_data, tid, sta);
-	if (priv->cfg->use_rts_for_ht) {
-		/*
-		 * switch to RTS/CTS if it is the prefer protection method
-		 * for HT traffic
-		 */
-		IWL_DEBUG_HT(priv, "use RTS/CTS protection for HT\n");
-		priv->staging_rxon.flags &= ~RXON_FLG_SELF_CTS_EN;
-		iwlcore_commit_rxon(priv);
+	if ((tid < TID_MAX_LOAD_COUNT) &&
+	    !rs_tl_turn_on_agg_for_tid(priv, lq_data, tid, sta)) {
+		if (priv->cfg->use_rts_for_ht) {
+			/*
+			 * switch to RTS/CTS if it is the prefer protection
+			 * method for HT traffic
+			 */
+			IWL_DEBUG_HT(priv, "use RTS/CTS protection for HT\n");
+			priv->staging_rxon.flags &= ~RXON_FLG_SELF_CTS_EN;
+			iwlcore_commit_rxon(priv);
+		}
 	}
 }
 
-- 
1.6.3.3

