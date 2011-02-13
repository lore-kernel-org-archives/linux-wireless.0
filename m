Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53137 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab1BMR5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 12:57:31 -0500
Received: by mail-iw0-f174.google.com with SMTP id 9so4086972iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 09:57:31 -0800 (PST)
From: "Nathaniel J. Smith" <njs@pobox.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com, "Nathaniel J. Smith" <njs@pobox.com>
Subject: [PATCH 3/5] iwlwifi: Invert the sense of the queue high_mark
Date: Sun, 13 Feb 2011 09:56:40 -0800
Message-Id: <1297619803-2832-4-git-send-email-njs@pobox.com>
In-Reply-To: <1297619803-2832-1-git-send-email-njs@pobox.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before, the high_mark was the minimum amount of free space allowed in a
queue. Now, it's the maximum number of packets which are allowed to be
in the queue.

No behavioral changes, but this makes the high_mark much easier to reason
about. (You might think it wouldn't make a difference, but in fact the
relationship between the number of packets enqueued and the queue free
space is complicated by the need to distinguish the queue full and queue
empty conditions. Removing this complication makes the next patches
simpler.)

Signed-off-by: Nathaniel J. Smith <njs@pobox.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   19 +++++++++++++------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 7 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 63999ae..f2e9e59 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -294,7 +294,8 @@ static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
 		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
 	}
 
-	if (iwl_queue_space(q) > atomic_read(&q->high_mark) && (txq_id >= 0) &&
+	if (iwl_queue_space_used(q) < atomic_read(&q->high_mark) &&
+			(txq_id >= 0) &&
 			(txq_id != IWL39_CMD_QUEUE_NUM) &&
 			priv->mac80211_registered)
 		iwl_wake_queue(priv, txq);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 548cbe9..6203c45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2230,7 +2230,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 						       tid, freed);
 
 			if (priv->mac80211_registered &&
-			    (iwl_queue_space(&txq->q) > atomic_read(&txq->q.high_mark)) &&
+			    (iwl_queue_space_used(&txq->q) < atomic_read(&txq->q.high_mark)) &&
 			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
 				iwl_wake_queue(priv, txq);
 		}
@@ -2255,7 +2255,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			IWL_DEBUG_TX_REPLY(priv, "Station not known\n");
 
 		if (priv->mac80211_registered &&
-		    (iwl_queue_space(&txq->q) > atomic_read(&txq->q.high_mark)))
+		    (iwl_queue_space_used(&txq->q) < atomic_read(&txq->q.high_mark)))
 			iwl_wake_queue(priv, txq);
 	}
 	if (qc && likely(sta_id != IWL_INVALID_STATION))
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index b2b841f..a84b4a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -445,7 +445,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 			if (priv->mac80211_registered &&
-			    (iwl_queue_space(&txq->q) > atomic_read(&txq->q.high_mark)) &&
+			    (iwl_queue_space_used(&txq->q) < atomic_read(&txq->q.high_mark)) &&
 			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
 				iwl_wake_queue(priv, txq);
 		}
@@ -455,7 +455,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 		if (priv->mac80211_registered &&
-		    (iwl_queue_space(&txq->q) > atomic_read(&txq->q.high_mark)))
+		    (iwl_queue_space_used(&txq->q) < atomic_read(&txq->q.high_mark)))
 			iwl_wake_queue(priv, txq);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 0c808f0..921876d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -638,7 +638,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	txq = &priv->txq[txq_id];
 	q = &txq->q;
 
-	if (unlikely(iwl_queue_space(q) <= atomic_read(&q->high_mark))) {
+	if (unlikely(iwl_queue_space_used(q) >= atomic_read(&q->high_mark))) {
 		spin_unlock(&priv->sta_lock);
 		goto drop_unlock;
 	}
@@ -789,7 +789,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (sta_priv && sta_priv->client && !is_agg)
 		atomic_inc(&sta_priv->pending_frames);
 
-	if ((iwl_queue_space(q) <= atomic_read(&q->high_mark))
+	if ((iwl_queue_space_used(q) >= atomic_read(&q->high_mark))
 	     && priv->mac80211_registered) {
 		if (wait_write_ptr) {
 			spin_lock_irqsave(&priv->lock, flags);
@@ -1433,7 +1433,7 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		int freed = iwlagn_tx_queue_reclaim(priv, scd_flow, index);
 		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
-		if ((iwl_queue_space(&txq->q) > atomic_read(&txq->q.high_mark)) &&
+		if ((iwl_queue_space_used(&txq->q) < atomic_read(&txq->q.high_mark)) &&
 		    priv->mac80211_registered &&
 		    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
 			iwl_wake_queue(priv, txq);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index cf9807c..dc6dd5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -135,8 +135,8 @@ struct iwl_queue {
 	dma_addr_t dma_addr;   /* physical addr for BD's */
 	int n_window;	       /* safe queue window */
 	u32 id;
-	atomic_t high_mark;    /* high watermark, stop queue if free
-				* space less than or equal to this */
+	atomic_t high_mark;    /* high watermark -- don't queue more than this
+				* many entries */
 };
 
 /* One for each TFD */
@@ -729,7 +729,7 @@ extern void iwl_update_chain_flags(struct iwl_priv *priv);
 extern const u8 iwl_bcast_addr[ETH_ALEN];
 extern int iwl_rxq_stop(struct iwl_priv *priv);
 extern void iwl_txq_ctx_stop(struct iwl_priv *priv);
-extern int iwl_queue_space(const struct iwl_queue *q);
+extern int iwl_queue_space_used(const struct iwl_queue *q);
 static inline int iwl_queue_used(const struct iwl_queue *q, int i)
 {
 	return q->write_ptr >= q->read_ptr ?
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 1867f99..ce62981 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -219,7 +219,7 @@ EXPORT_SYMBOL(iwl_cmd_queue_free);
  * See more detailed info in iwl-4965-hw.h.
  ***************************************************/
 
-int iwl_queue_space(const struct iwl_queue *q)
+static int iwl_queue_space_free(const struct iwl_queue *q)
 {
 	int s = q->read_ptr - q->write_ptr;
 
@@ -234,8 +234,15 @@ int iwl_queue_space(const struct iwl_queue *q)
 		s = 0;
 	return s;
 }
-EXPORT_SYMBOL(iwl_queue_space);
 
+int iwl_queue_space_used(const struct iwl_queue *q)
+{
+	int s = q->write_ptr - q->read_ptr;
+	if (s < 0)
+		s += q->n_bd;
+	return s;
+}
+EXPORT_SYMBOL(iwl_queue_space_used);
 
 /**
  * iwl_queue_init - Initialize queue's high-water and read/write indexes
@@ -255,9 +262,9 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 	 * get_cmd_index is broken. */
 	BUG_ON(!is_power_of_2(slots_num));
 
-	atomic_set(&q->high_mark, q->n_window / 8);
-	if (atomic_read(&q->high_mark) < 2)
-		atomic_set(&q->high_mark, 2);
+	atomic_set(&q->high_mark, q->n_window - q->n_window / 8);
+	if (q->n_window - atomic_read(&q->high_mark) < 2)
+		atomic_set(&q->high_mark, q->n_window - 2);
 
 	q->write_ptr = q->read_ptr = 0;
 
@@ -445,7 +452,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		return -EIO;
 	}
 
-	if (iwl_queue_space(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
+	if (iwl_queue_space_free(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
 		IWL_ERR(priv, "No space in command queue\n");
 		if (priv->cfg->ops->lib->tt_ops.ct_kill_check) {
 			is_ct_kill =
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index b3f8f3e..d0aa01c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -537,7 +537,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	txq = &priv->txq[txq_id];
 	q = &txq->q;
 
-	if ((iwl_queue_space(q) <= atomic_read(&q->high_mark)))
+	if ((iwl_queue_space_used(q) >= atomic_read(&q->high_mark)))
 		goto drop;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -647,7 +647,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwl_txq_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if ((iwl_queue_space(q) <= atomic_read(&q->high_mark))
+	if ((iwl_queue_space_used(q) >= atomic_read(&q->high_mark))
 	    && priv->mac80211_registered) {
 		if (wait_write_ptr) {
 			spin_lock_irqsave(&priv->lock, flags);
-- 
1.7.1

