Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28831 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbYEDLsX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 07:48:23 -0400
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] iwlwifi: map A-MPDU HW queue to mac80211 A-MPDU SW queue
Date: Sun,  4 May 2008 14:48:18 +0300
Message-Id: <1209901698-10370-1-git-send-email-ron.rindjunsky@intel.com> (sfid-20080504_134757_697381_88E4B6FB)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch maps A-MPDU HW queue to mac80211 SW queue scheme (as introduced
in patch "mac80211: QoS related cleanups"), when trying to perform
ieee80211_wake_queue.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   23 +++++++++++------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9546582..70c0455 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3547,13 +3547,16 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 	 * block-ack window (we assume that they've been successfully
 	 * transmitted ... if not, it's too late anyway). */
 	if (txq->q.read_ptr != (ba_resp_scd_ssn & 0xff)) {
+		/* calculate mac80211 ampdu sw queue to wake */
+		int ampdu_q =
+		   scd_flow - IWL_BACK_QUEUE_FIRST_ID + priv->hw->queues;
 		int freed = iwl4965_tx_queue_reclaim(priv, scd_flow, index);
 		priv->stations[ba_resp->sta_id].
 			tid[ba_resp->tid].tfds_in_queue -= freed;
 		if (iwl4965_queue_space(&txq->q) > txq->q.low_mark &&
 			priv->mac80211_registered &&
 			agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)
-			ieee80211_wake_queue(priv->hw, scd_flow);
+			ieee80211_wake_queue(priv->hw, ampdu_q);
 		iwl4965_check_empty_hw_queue(priv, ba_resp->sta_id,
 			ba_resp->tid, scd_flow);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 4406fc7..5453427 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2568,12 +2568,6 @@ int iwl4965_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 		nfreed++;
 	}
 
-/*	if (iwl4965_queue_space(q) > q->low_mark && (txq_id >= 0) &&
-			(txq_id != IWL_CMD_QUEUE_NUM) &&
-			priv->mac80211_registered)
-		ieee80211_wake_queue(priv->hw, txq_id); */
-
-
 	return nfreed;
 }
 
@@ -2797,7 +2791,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		}
 
 		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
-			int freed;
+			int freed, ampdu_q;
 			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
 			IWL_DEBUG_TX_REPLY("Retry scheduler reclaim scd_ssn "
 					   "%d index %d\n", scd_ssn , index);
@@ -2806,9 +2800,15 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 
 			if (iwl4965_queue_space(&txq->q) > txq->q.low_mark &&
 			    txq_id >= 0 && priv->mac80211_registered &&
-			    agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)
-				ieee80211_wake_queue(priv->hw, txq_id);
-
+			    agg->state != IWL_EMPTYING_HW_QUEUE_DELBA) {
+				/* calculate mac80211 ampdu sw queue to wake */
+				ampdu_q = txq_id - IWL_BACK_QUEUE_FIRST_ID +
+					  priv->hw->queues;
+				if (agg->state == IWL_AGG_OFF)
+					ieee80211_wake_queue(priv->hw, txq_id);
+				else
+					ieee80211_wake_queue(priv->hw, ampdu_q);
+			}
 			iwl4965_check_empty_hw_queue(priv, sta_id, tid, txq_id);
 		}
 	} else {
@@ -2833,8 +2833,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		if (tid != MAX_TID_COUNT)
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 		if (iwl4965_queue_space(&txq->q) > txq->q.low_mark &&
-			(txq_id >= 0) &&
-			priv->mac80211_registered)
+			(txq_id >= 0) && priv->mac80211_registered)
 			ieee80211_wake_queue(priv->hw, txq_id);
 		if (tid != MAX_TID_COUNT)
 			iwl4965_check_empty_hw_queue(priv, sta_id, tid, txq_id);
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

