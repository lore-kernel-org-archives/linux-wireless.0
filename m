Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6991 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983Ab0FUSGq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 14:06:46 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/9] iwlagn: use mutex for aggregation
Date: Mon, 21 Jun 2010 11:06:32 -0700
Message-Id: <1277143600-32554-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277143600-32554-1-git-send-email-reinette.chatre@intel.com>
References: <1277143600-32554-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Now that the ampdu_action callback can sleep,
we can use the mutex to properly protect the
aggregation data, and return useful errors if
they should happen.

Also, add some sleep and mutex debugging so
we won't call any of the functions that now
require being able to sleep and/or the mutex
to be held in an invalid context.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c   |    5 +++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    5 +++-
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   29 +++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-sta.c    |   31 ++++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-sta.h    |    2 +-
 5 files changed, 45 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 83e6a42..fee276b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1785,6 +1785,7 @@ static int iwl4965_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 {
 	unsigned long flags;
 	u16 ra_tid;
+	int ret;
 
 	if ((IWL49_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWL49_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
@@ -1800,7 +1801,9 @@ static int iwl4965_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	ra_tid = BUILD_RAxTID(sta_id, tid);
 
 	/* Modify device's station table to Tx this TID */
-	iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
+	ret = iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
+	if (ret)
+		return ret;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 84df7fc..2573234 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -233,6 +233,7 @@ int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 {
 	unsigned long flags;
 	u16 ra_tid;
+	int ret;
 
 	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWLAGN_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
@@ -248,7 +249,9 @@ int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	ra_tid = BUILD_RAxTID(sta_id, tid);
 
 	/* Modify device's station table to Tx this TID */
-	iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
+	ret = iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
+	if (ret)
+		return ret;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d857f84..294b7ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3374,7 +3374,7 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 				struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
 	struct iwl_priv *priv = hw->priv;
-	int ret;
+	int ret = -EINVAL;
 
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
 		     sta->addr, tid);
@@ -3382,17 +3382,19 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 	if (!(priv->cfg->sku & IWL_SKU_N))
 		return -EACCES;
 
+	mutex_lock(&priv->mutex);
+
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		IWL_DEBUG_HT(priv, "start Rx\n");
-		return iwl_sta_rx_agg_start(priv, sta, tid, *ssn);
+		ret = iwl_sta_rx_agg_start(priv, sta, tid, *ssn);
+		break;
 	case IEEE80211_AMPDU_RX_STOP:
 		IWL_DEBUG_HT(priv, "stop Rx\n");
 		ret = iwl_sta_rx_agg_stop(priv, sta, tid);
 		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-			return 0;
-		else
-			return ret;
+			ret = 0;
+		break;
 	case IEEE80211_AMPDU_TX_START:
 		IWL_DEBUG_HT(priv, "start Tx\n");
 		ret = iwlagn_tx_agg_start(priv, vif, sta, tid, ssn);
@@ -3401,7 +3403,7 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 			IWL_DEBUG_HT(priv, "priv->_agn.agg_tids_count = %u\n",
 				     priv->_agn.agg_tids_count);
 		}
-		return ret;
+		break;
 	case IEEE80211_AMPDU_TX_STOP:
 		IWL_DEBUG_HT(priv, "stop Tx\n");
 		ret = iwlagn_tx_agg_stop(priv, vif, sta, tid);
@@ -3411,18 +3413,15 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 				     priv->_agn.agg_tids_count);
 		}
 		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-			return 0;
-		else
-			return ret;
+			ret = 0;
+		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		/* do nothing */
-		return -EOPNOTSUPP;
-	default:
-		IWL_DEBUG_HT(priv, "unknown\n");
-		return -EINVAL;
+		/* do nothing, return value ignored */
 		break;
 	}
-	return 0;
+	mutex_unlock(&priv->mutex);
+
+	return ret;
 }
 
 static void iwl_mac_sta_notify(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index d57df6c..a62a032 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -30,6 +30,7 @@
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <linux/sched.h>
+#include <linux/lockdep.h>
 
 #include "iwl-dev.h"
 #include "iwl-core.h"
@@ -145,8 +146,10 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 
 	if (flags & CMD_ASYNC)
 		cmd.callback = iwl_add_sta_callback;
-	else
+	else {
 		cmd.flags |= CMD_WANT_SKB;
+		might_sleep();
+	}
 
 	cmd.len = priv->cfg->ops->utils->build_addsta_hcmd(sta, data);
 	ret = iwl_send_cmd(priv, &cmd);
@@ -1268,17 +1271,22 @@ EXPORT_SYMBOL_GPL(iwl_dealloc_bcast_station);
 /**
  * iwl_sta_tx_modify_enable_tid - Enable Tx for this TID in station table
  */
-void iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid)
+int iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid)
 {
 	unsigned long flags;
+	struct iwl_addsta_cmd sta_cmd;
+
+	lockdep_assert_held(&priv->mutex);
 
 	/* Remove "disable" flag, to enable Tx for this TID */
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_TID_DISABLE_TX;
 	priv->stations[sta_id].sta.tid_disable_tx &= cpu_to_le16(~(1 << tid));
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
 EXPORT_SYMBOL(iwl_sta_tx_modify_enable_tid);
 
@@ -1287,6 +1295,9 @@ int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
 {
 	unsigned long flags;
 	int sta_id;
+	struct iwl_addsta_cmd sta_cmd;
+
+	lockdep_assert_held(&priv->mutex);
 
 	sta_id = iwl_sta_id(sta);
 	if (sta_id == IWL_INVALID_STATION)
@@ -1298,10 +1309,10 @@ int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
 	priv->stations[sta_id].sta.add_immediate_ba_tid = (u8)tid;
 	priv->stations[sta_id].sta.add_immediate_ba_ssn = cpu_to_le16(ssn);
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta,
-				CMD_ASYNC);
+	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
 EXPORT_SYMBOL(iwl_sta_rx_agg_start);
 
@@ -1309,7 +1320,10 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 			int tid)
 {
 	unsigned long flags;
-	int sta_id, ret;
+	int sta_id;
+	struct iwl_addsta_cmd sta_cmd;
+
+	lockdep_assert_held(&priv->mutex);
 
 	sta_id = iwl_sta_id(sta);
 	if (sta_id == IWL_INVALID_STATION) {
@@ -1322,11 +1336,10 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_DELBA_TID_MSK;
 	priv->stations[sta_id].sta.remove_immediate_ba_tid = (u8)tid;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	ret = iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	return ret;
-
+	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
 EXPORT_SYMBOL(iwl_sta_rx_agg_stop);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 5b1b1e4..619bb99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -73,7 +73,7 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 		       const u8 *addr);
 int iwl_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
-void iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid);
+int iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid);
 int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
 			 int tid, u16 ssn);
 int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
-- 
1.7.0.4

