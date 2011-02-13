Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36663 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab1BMR5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 12:57:25 -0500
Received: by iyj8 with SMTP id 8so4089435iyj.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 09:57:24 -0800 (PST)
From: "Nathaniel J. Smith" <njs@pobox.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com, "Nathaniel J. Smith" <njs@pobox.com>
Subject: [PATCH 1/5] iwlwifi: Simplify tx queue management
Date: Sun, 13 Feb 2011 09:56:38 -0800
Message-Id: <1297619803-2832-2-git-send-email-njs@pobox.com>
In-Reply-To: <1297619803-2832-1-git-send-email-njs@pobox.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, the iwlwifi driver filled its transmit queue until it
reached a high-water mark, and then stopped until it had fallen to a
low-water mark. This basic logic makes sense for interrupt mitigation
-- you might not want to wake up the CPU after every packet, but
instead wait until a batch of packets has been sent -- except the
iwlwifi driver doesn't actually do any interrupt mitigation; the CPU
wakes up after every packet transmitted anyway. So we simplify the
code to maintain only a single limit on total queue length, and
whenever we drop below that limit we allow more packets in.

This patch should have no user-visible effect.

Signed-off-by: Nathaniel J. Smith <njs@pobox.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 --
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   18 +++++++-----------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 7 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 5b6932c..6d2fb06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -274,7 +274,7 @@ int iwl3945_rs_next_rate(struct iwl_priv *priv, int rate)
  *
  * When FW advances 'R' index, all entries between old and new 'R' index
  * need to be reclaimed. As result, some free space forms. If there is
- * enough free space (> low mark), wake the stack that feeds us.
+ * enough free space (> high mark), wake the stack that feeds us.
  */
 static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
 				     int txq_id, int index)
@@ -294,7 +294,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
 		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
 	}
 
-	if (iwl_queue_space(q) > q->low_mark && (txq_id >= 0) &&
+	if (iwl_queue_space(q) > q->high_mark && (txq_id >= 0) &&
 			(txq_id != IWL39_CMD_QUEUE_NUM) &&
 			priv->mac80211_registered)
 		iwl_wake_queue(priv, txq);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 8998ed1..b8955d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2230,7 +2230,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 						       tid, freed);
 
 			if (priv->mac80211_registered &&
-			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
+			    (iwl_queue_space(&txq->q) > txq->q.high_mark) &&
 			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
 				iwl_wake_queue(priv, txq);
 		}
@@ -2255,7 +2255,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			IWL_DEBUG_TX_REPLY(priv, "Station not known\n");
 
 		if (priv->mac80211_registered &&
-		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
+		    (iwl_queue_space(&txq->q) > txq->q.high_mark))
 			iwl_wake_queue(priv, txq);
 	}
 	if (qc && likely(sta_id != IWL_INVALID_STATION))
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3aa4864..f229543 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -445,7 +445,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 			if (priv->mac80211_registered &&
-			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
+			    (iwl_queue_space(&txq->q) > txq->q.high_mark) &&
 			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
 				iwl_wake_queue(priv, txq);
 		}
@@ -455,7 +455,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 		if (priv->mac80211_registered &&
-		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
+		    (iwl_queue_space(&txq->q) > txq->q.high_mark))
 			iwl_wake_queue(priv, txq);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 266490d..bffba7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -637,7 +637,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	txq = &priv->txq[txq_id];
 	q = &txq->q;
 
-	if (unlikely(iwl_queue_space(q) < q->high_mark)) {
+	if (unlikely(iwl_queue_space(q) <= q->high_mark)) {
 		spin_unlock(&priv->sta_lock);
 		goto drop_unlock;
 	}
@@ -788,7 +788,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (sta_priv && sta_priv->client && !is_agg)
 		atomic_inc(&sta_priv->pending_frames);
 
-	if ((iwl_queue_space(q) < q->high_mark) && priv->mac80211_registered) {
+	if ((iwl_queue_space(q) <= q->high_mark) && priv->mac80211_registered) {
 		if (wait_write_ptr) {
 			spin_lock_irqsave(&priv->lock, flags);
 			txq->need_update = 1;
@@ -1431,7 +1431,7 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		int freed = iwlagn_tx_queue_reclaim(priv, scd_flow, index);
 		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
-		if ((iwl_queue_space(&txq->q) > txq->q.low_mark) &&
+		if ((iwl_queue_space(&txq->q) > txq->q.high_mark) &&
 		    priv->mac80211_registered &&
 		    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
 			iwl_wake_queue(priv, txq);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ecfbef4..eb6586d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -134,8 +134,6 @@ struct iwl_queue {
 	dma_addr_t dma_addr;   /* physical addr for BD's */
 	int n_window;	       /* safe queue window */
 	u32 id;
-	int low_mark;	       /* low watermark, resume queue if free
-				* space more than this */
 	int high_mark;         /* high watermark, stop queue if free
 				* space less than this */
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 073b6ce..78a9896 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -210,10 +210,10 @@ EXPORT_SYMBOL(iwl_cmd_queue_free);
  * The device reads or writes the data in the queues via the device's several
  * DMA/FIFO channels.  Each queue is mapped to a single DMA channel.
  *
- * For Tx queue, there are low mark and high mark limits. If, after queuing
- * the packet for Tx, free space become < low mark, Tx queue stopped. When
- * reclaiming packets (on 'tx done IRQ), if free space become > high mark,
- * Tx queue resumed.
+ * For Tx queue, there is a high mark limit. If, after queuing the packet for
+ * Tx, free space becomes <= high mark, Tx queue stopped. When reclaiming
+ * packets (on 'tx done IRQ), if free space become > high mark, Tx queue
+ * resumed.
  *
  * See more detailed info in iwl-4965-hw.h.
  ***************************************************/
@@ -237,7 +237,7 @@ EXPORT_SYMBOL(iwl_queue_space);
 
 
 /**
- * iwl_queue_init - Initialize queue's high/low-water and read/write indexes
+ * iwl_queue_init - Initialize queue's high-water and read/write indexes
  */
 static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 			  int count, int slots_num, u32 id)
@@ -254,10 +254,6 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 	 * get_cmd_index is broken. */
 	BUG_ON(!is_power_of_2(slots_num));
 
-	q->low_mark = q->n_window / 4;
-	if (q->low_mark < 4)
-		q->low_mark = 4;
-
 	q->high_mark = q->n_window / 8;
 	if (q->high_mark < 2)
 		q->high_mark = 2;
@@ -368,7 +364,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
 	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
 
-	/* Initialize queue's high/low-water marks, and head/tail indexes */
+	/* Initialize queue's high-water mark, and head/tail indexes */
 	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
 
 	/* Tell device where to find queue */
@@ -547,7 +543,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
  *
  * When FW advances 'R' index, all entries between old and new 'R' index
  * need to be reclaimed. As result, some free space forms.  If there is
- * enough free space (> low mark), wake the stack that feeds us.
+ * enough free space (> high mark), wake the stack that feeds us.
  */
 static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id,
 				   int idx, int cmd_idx)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index adcef73..e0d4c83 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -536,7 +536,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	txq = &priv->txq[txq_id];
 	q = &txq->q;
 
-	if ((iwl_queue_space(q) < q->high_mark))
+	if ((iwl_queue_space(q) <= q->high_mark))
 		goto drop;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -646,7 +646,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwl_txq_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if ((iwl_queue_space(q) < q->high_mark)
+	if ((iwl_queue_space(q) <= q->high_mark)
 	    && priv->mac80211_registered) {
 		if (wait_write_ptr) {
 			spin_lock_irqsave(&priv->lock, flags);
-- 
1.7.1

