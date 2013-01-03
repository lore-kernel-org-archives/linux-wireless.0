Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48375 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3ACOpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:45:51 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/12] iwlwifi: clean up code in AGG
Date: Thu,  3 Jan 2013 15:46:06 +0100
Message-Id: <1357224376-27803-2-git-send-email-johannes@sipsolutions.net> (sfid-20130103_154558_912725_1EA202C2)
In-Reply-To: <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
References: <1357224324.9741.20.camel@jlt4.sipsolutions.net>
 <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

If we take a pointer to the tid_data, then use it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/tx.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index da21328..df76881 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -541,9 +541,9 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	spin_lock_bh(&priv->sta_lock);
 
 	tid_data = &priv->tid_data[sta_id][tid];
-	txq_id = priv->tid_data[sta_id][tid].agg.txq_id;
+	txq_id = tid_data->agg.txq_id;
 
-	switch (priv->tid_data[sta_id][tid].agg.state) {
+	switch (tid_data->agg.state) {
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
 		/*
 		* This can happen if the peer stops aggregation
@@ -563,9 +563,9 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	case IWL_AGG_ON:
 		break;
 	default:
-		IWL_WARN(priv, "Stopping AGG while state not ON "
-			 "or starting for %d on %d (%d)\n", sta_id, tid,
-			 priv->tid_data[sta_id][tid].agg.state);
+		IWL_WARN(priv,
+			 "Stopping AGG while state not ON or starting for %d on %d (%d)\n",
+			 sta_id, tid, tid_data->agg.state);
 		spin_unlock_bh(&priv->sta_lock);
 		return 0;
 	}
@@ -578,12 +578,11 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			"stopping AGG on STA/TID %d/%d but hwq %d not used\n",
 			sta_id, tid, txq_id);
 	} else if (tid_data->agg.ssn != tid_data->next_reclaimed) {
-		IWL_DEBUG_TX_QUEUES(priv, "Can't proceed: ssn %d, "
-				    "next_recl = %d\n",
+		IWL_DEBUG_TX_QUEUES(priv,
+				    "Can't proceed: ssn %d, next_recl = %d\n",
 				    tid_data->agg.ssn,
 				    tid_data->next_reclaimed);
-		priv->tid_data[sta_id][tid].agg.state =
-			IWL_EMPTYING_HW_QUEUE_DELBA;
+		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_DELBA;
 		spin_unlock_bh(&priv->sta_lock);
 		return 0;
 	}
@@ -591,8 +590,8 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	IWL_DEBUG_TX_QUEUES(priv, "Can proceed: ssn = next_recl = %d\n",
 			    tid_data->agg.ssn);
 turn_off:
-	agg_state = priv->tid_data[sta_id][tid].agg.state;
-	priv->tid_data[sta_id][tid].agg.state = IWL_AGG_OFF;
+	agg_state = tid_data->agg.state;
+	tid_data->agg.state = IWL_AGG_OFF;
 
 	spin_unlock_bh(&priv->sta_lock);
 
-- 
1.8.0

