Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:39511 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab0FYWnK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 18:43:10 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/8] iwlwifi: turn on RTS/CTS after aggregation become operational
Date: Fri, 25 Jun 2010 15:42:59 -0700
Message-Id: <1277505781-25268-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
References: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

If RTS/CTS protection is needed for HT, wait until get operational
notification from mac80211, then inform uCode to switch to RTS/CTS
through RXON command.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   17 +++++------------
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   28 +++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-scan.c   |    9 +++++++++
 3 files changed, 41 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 40933a5..35c86d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -324,18 +324,11 @@ static void rs_tl_turn_on_agg(struct iwl_priv *priv, u8 tid,
 			      struct iwl_lq_sta *lq_data,
 			      struct ieee80211_sta *sta)
 {
-	if ((tid < TID_MAX_LOAD_COUNT) &&
-	    !rs_tl_turn_on_agg_for_tid(priv, lq_data, tid, sta)) {
-		if (priv->cfg->use_rts_for_ht) {
-			/*
-			 * switch to RTS/CTS if it is the prefer protection
-			 * method for HT traffic
-			 */
-			IWL_DEBUG_HT(priv, "use RTS/CTS protection for HT\n");
-			priv->staging_rxon.flags &= ~RXON_FLG_SELF_CTS_EN;
-			iwlcore_commit_rxon(priv);
-		}
-	}
+	if (tid < TID_MAX_LOAD_COUNT)
+		rs_tl_turn_on_agg_for_tid(priv, lq_data, tid, sta);
+	else
+		IWL_ERR(priv, "tid exceeds max load count: %d/%d\n",
+			tid, TID_MAX_LOAD_COUNT);
 }
 
 static inline int get_num_of_ant_from_rate(u32 rate_n_flags)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7488a68..3368cfd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3368,6 +3368,25 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
+/*
+ * switch to RTS/CTS for TX
+ */
+static void iwl_enable_rts_cts(struct iwl_priv *priv)
+{
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	priv->staging_rxon.flags &= ~RXON_FLG_SELF_CTS_EN;
+	if (!test_bit(STATUS_SCANNING, &priv->status)) {
+		IWL_DEBUG_INFO(priv, "use RTS/CTS protection\n");
+		iwlcore_commit_rxon(priv);
+	} else {
+		/* scanning, defer the request until scan completed */
+		IWL_DEBUG_INFO(priv, "defer setting RTS/CTS protection\n");
+	}
+}
+
 static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				enum ieee80211_ampdu_mlme_action action,
@@ -3416,7 +3435,14 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 			ret = 0;
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		/* do nothing, return value ignored */
+		if (priv->cfg->use_rts_for_ht) {
+			/*
+			 * switch to RTS/CTS if it is the prefer protection
+			 * method for HT traffic
+			 */
+			iwl_enable_rts_cts(priv);
+		}
+		ret = 0;
 		break;
 	}
 	mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 798f93e..2a7c399 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -537,6 +537,15 @@ void iwl_bg_scan_completed(struct work_struct *work)
 	/* Since setting the TXPOWER may have been deferred while
 	 * performing the scan, fire one off */
 	iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
+
+	/*
+	 * Since setting the RXON may have been deferred while
+	 * performing the scan, fire one off if needed
+	 */
+	if (memcmp(&priv->active_rxon,
+		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
+		iwlcore_commit_rxon(priv);
+
  out:
 	mutex_unlock(&priv->mutex);
 
-- 
1.7.0.4

