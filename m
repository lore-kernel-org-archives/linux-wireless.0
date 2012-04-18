Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39112 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab2DROpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:45:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/15] iwlwifi: split between AGG_ON and AGG_STARTING
Date: Wed, 18 Apr 2012 07:41:15 -0700
Message-Id: <1334760077-5714-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120418_164601_132382_83741C81)
In-Reply-To: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This allows not to notify the transport about aggregation stopped
while aggregation haven't been started.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   20 +++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    2 ++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 76fea8f..b77a079 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -522,6 +522,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 {
 	struct iwl_tid_data *tid_data;
 	int sta_id, txq_id;
+	enum iwl_agg_state agg_state;
 
 	sta_id = iwl_sta_id(sta);
 
@@ -545,6 +546,13 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		*/
 		IWL_DEBUG_HT(priv, "AGG stop before setup done\n");
 		goto turn_off;
+	case IWL_AGG_STARTING:
+		/*
+		 * This can happen when the session is stopped before
+		 * we receive ADDBA response
+		 */
+		IWL_DEBUG_HT(priv, "AGG stop before AGG became operational\n");
+		goto turn_off;
 	case IWL_AGG_ON:
 		break;
 	default:
@@ -576,12 +584,17 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	IWL_DEBUG_TX_QUEUES(priv, "Can proceed: ssn = next_recl = %d\n",
 			    tid_data->agg.ssn);
 turn_off:
+	agg_state = priv->tid_data[sta_id][tid].agg.state;
 	priv->tid_data[sta_id][tid].agg.state = IWL_AGG_OFF;
 
 	spin_unlock_bh(&priv->sta_lock);
 
 	if (test_bit(txq_id, priv->agg_q_alloc)) {
-		iwl_trans_tx_agg_disable(priv->trans, txq_id);
+		/* If the transport didn't know that we wanted to start
+		 * agreggation, don't tell it that we want to stop them
+		 */
+		if (agg_state != IWL_AGG_STARTING)
+			iwl_trans_tx_agg_disable(priv->trans, txq_id);
 		iwlagn_dealloc_agg_txq(priv, txq_id);
 	}
 
@@ -634,7 +647,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	if (*ssn == tid_data->next_reclaimed) {
 		IWL_DEBUG_TX_QUEUES(priv, "Can proceed: ssn = next_recl = %d\n",
 				    tid_data->agg.ssn);
-		tid_data->agg.state = IWL_AGG_ON;
+		tid_data->agg.state = IWL_AGG_STARTING;
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 	} else {
 		IWL_DEBUG_TX_QUEUES(priv, "Can't proceed: ssn %d, "
@@ -661,6 +674,7 @@ int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	spin_lock_bh(&priv->sta_lock);
 	ssn = priv->tid_data[sta_priv->sta_id][tid].agg.ssn;
 	q = priv->tid_data[sta_priv->sta_id][tid].agg.txq_id;
+	priv->tid_data[sta_priv->sta_id][tid].agg.state = IWL_AGG_ON;
 	spin_unlock_bh(&priv->sta_lock);
 
 	fifo = ctx->ac_to_fifo[tid_to_ac[tid]];
@@ -745,7 +759,7 @@ static void iwlagn_check_ratid_empty(struct iwl_priv *priv, int sta_id, u8 tid)
 			IWL_DEBUG_TX_QUEUES(priv,
 				"Can continue ADDBA flow ssn = next_recl ="
 				" %d", tid_data->next_reclaimed);
-			tid_data->agg.state = IWL_AGG_ON;
+			tid_data->agg.state = IWL_AGG_STARTING;
 			ieee80211_start_tx_ba_cb_irqsafe(vif, addr, tid);
 		}
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f3eccf6..3816429 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -194,6 +194,7 @@ struct iwl_qos_info {
  * These states relate to a specific RA / TID.
  *
  * @IWL_AGG_OFF: aggregation is not used
+ * @IWL_AGG_STARTING: aggregation are starting (between start and oper)
  * @IWL_AGG_ON: aggregation session is up
  * @IWL_EMPTYING_HW_QUEUE_ADDBA: establishing a BA session - waiting for the
  *	HW queue to be empty from packets for this RA /TID.
@@ -202,6 +203,7 @@ struct iwl_qos_info {
  */
 enum iwl_agg_state {
 	IWL_AGG_OFF = 0,
+	IWL_AGG_STARTING,
 	IWL_AGG_ON,
 	IWL_EMPTYING_HW_QUEUE_ADDBA,
 	IWL_EMPTYING_HW_QUEUE_DELBA,
-- 
1.7.0.4

