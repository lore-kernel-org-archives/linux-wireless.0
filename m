Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbYEECYe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:34 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 25/25] iwlwifi: map A-MPDU HW queue to mac80211 A-MPDU SW queue
Date: Mon,  5 May 2008 10:22:52 +0800
Message-Id: <1209954172-3092-26-git-send-email-yi.zhu@intel.com> (sfid-20080505_044418_370130_EF6E85A6)
In-Reply-To: <1209954172-3092-25-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-14-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-15-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-16-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-17-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-19-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-22-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-23-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-24-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-25-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch maps A-MPDU HW queue to mac80211 SW queue scheme (as introduced
in patch "mac80211: QoS related cleanups"), when trying to perform
ieee80211_wake_queue.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   23 +++++++++++------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 554b0d6..0b44138 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3330,13 +3330,16 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
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
index 3b091fc..45bbce7 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2357,12 +2357,6 @@ int iwl4965_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
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
 
@@ -2586,7 +2580,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		}
 
 		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
-			int freed;
+			int freed, ampdu_q;
 			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
 			IWL_DEBUG_TX_REPLY("Retry scheduler reclaim scd_ssn "
 					   "%d index %d\n", scd_ssn , index);
@@ -2595,9 +2589,15 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 
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
@@ -2622,8 +2622,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
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
1.5.3.6

