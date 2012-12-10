Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2LJVtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:49:01 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/10] iwlwifi: silently ignore fw flaws in Tx path
Date: Mon, 10 Dec 2012 22:49:17 +0100
Message-Id: <1355176158-24675-9-git-send-email-johannes@sipsolutions.net> (sfid-20121210_224917_572203_695C9865)
In-Reply-To: <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
References: <1355176087.8083.17.camel@jlt4.sipsolutions.net>
 <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We know that we have issues with the fw in the reclaim path.
This is why iwl_reclaim doesn't complain too loud when it
happens since it is recoverable. Somehow, the caller of
iwl_reclaim however WARNed when it happens. This doesn't
make any sense.

When I digged into the history of that code, I discovered
that this bug occurs only when we receive a BA notification.
So move the W/A in the BA notification handling code where
it was before.

This patch addresses:
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2387

Cc: stable@vger.kernel.org
Reported-by: Florian Reitmeir <florian@reitmeir.org>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/tx.c | 49 +++++++++++++----------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 517562b..da21328 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -1097,29 +1097,6 @@ static void iwl_check_abort_status(struct iwl_priv *priv,
 	}
 }
 
-static int iwl_reclaim(struct iwl_priv *priv, int sta_id, int tid,
-		       int txq_id, int ssn, struct sk_buff_head *skbs)
-{
-	if (unlikely(txq_id >= IWLAGN_FIRST_AMPDU_QUEUE &&
-		     tid != IWL_TID_NON_QOS &&
-		     txq_id != priv->tid_data[sta_id][tid].agg.txq_id)) {
-		/*
-		 * FIXME: this is a uCode bug which need to be addressed,
-		 * log the information and return for now.
-		 * Since it is can possibly happen very often and in order
-		 * not to fill the syslog, don't use IWL_ERR or IWL_WARN
-		 */
-		IWL_DEBUG_TX_QUEUES(priv,
-			"Bad queue mapping txq_id=%d, agg_txq[sta:%d,tid:%d]=%d\n",
-			txq_id, sta_id, tid,
-			priv->tid_data[sta_id][tid].agg.txq_id);
-		return 1;
-	}
-
-	iwl_trans_reclaim(priv->trans, txq_id, ssn, skbs);
-	return 0;
-}
-
 int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			       struct iwl_device_cmd *cmd)
 {
@@ -1181,9 +1158,8 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 						  next_reclaimed);
 		}
 
-		/*we can free until ssn % q.n_bd not inclusive */
-		WARN_ON_ONCE(iwl_reclaim(priv, sta_id, tid,
-					 txq_id, ssn, &skbs));
+		iwl_trans_reclaim(priv->trans, txq_id, ssn, &skbs);
+
 		iwlagn_check_ratid_empty(priv, sta_id, tid);
 		freed = 0;
 
@@ -1308,16 +1284,27 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		return 0;
 	}
 
+	if (unlikely(scd_flow != agg->txq_id)) {
+		/*
+		 * FIXME: this is a uCode bug which need to be addressed,
+		 * log the information and return for now.
+		 * Since it is can possibly happen very often and in order
+		 * not to fill the syslog, don't use IWL_ERR or IWL_WARN
+		 */
+		IWL_DEBUG_TX_QUEUES(priv,
+				    "Bad queue mapping txq_id=%d, agg_txq[sta:%d,tid:%d]=%d\n",
+				    scd_flow, sta_id, tid, agg->txq_id);
+		spin_unlock(&priv->sta_lock);
+		return 0;
+	}
+
 	__skb_queue_head_init(&reclaimed_skbs);
 
 	/* Release all TFDs before the SSN, i.e. all TFDs in front of
 	 * block-ack window (we assume that they've been successfully
 	 * transmitted ... if not, it's too late anyway). */
-	if (iwl_reclaim(priv, sta_id, tid, scd_flow,
-			ba_resp_scd_ssn, &reclaimed_skbs)) {
-		spin_unlock(&priv->sta_lock);
-		return 0;
-	}
+	iwl_trans_reclaim(priv->trans, scd_flow, ba_resp_scd_ssn,
+			  &reclaimed_skbs);
 
 	IWL_DEBUG_TX_REPLY(priv, "REPLY_COMPRESSED_BA [%d] Received from %pM, "
 			   "sta_id = %d\n",
-- 
1.8.0

