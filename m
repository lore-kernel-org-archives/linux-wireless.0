Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25549 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431AbZEVRzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 13:55:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/10] iwlcore: Allow skb allocation from tasklet.
Date: Fri, 22 May 2009 11:01:51 -0700
Message-Id: <1243015315-13848-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1243015315-13848-6-git-send-email-reinette.chatre@intel.com>
References: <1243015315-13848-1-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-2-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-3-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-4-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-5-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

If RX queue becomes empty then we need to restock the queue from tasklet to prevent
ucode from starving. A caller to iwl_rx_allocate will decide if allocated buffer should
come from GFP_ATOMIC or GFP_KERNEL.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   15 ++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-core.h |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-rx.c   |   25 +++++++++++++++++++------
 4 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index fa24b01..be1058b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -831,6 +831,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 	unsigned long flags;
 	u8 fill_rx = 0;
 	u32 count = 8;
+	int total_empty;
 
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
@@ -841,7 +842,12 @@ void iwl_rx_handle(struct iwl_priv *priv)
 	if (i == r)
 		IWL_DEBUG_RX(priv, "r = %d, i = %d\n", r, i);
 
-	if (iwl_rx_queue_space(rxq) > (RX_QUEUE_SIZE / 2))
+	/* calculate total frames need to be restock after handling RX */
+	total_empty = r - priv->rxq.write_actual;
+	if (total_empty < 0)
+		total_empty += RX_QUEUE_SIZE;
+
+	if (total_empty > (RX_QUEUE_SIZE / 2))
 		fill_rx = 1;
 
 	while (i != r) {
@@ -918,7 +924,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 			count++;
 			if (count >= 8) {
 				priv->rxq.read = i;
-				iwl_rx_queue_restock(priv);
+				iwl_rx_replenish_now(priv);
 				count = 0;
 			}
 		}
@@ -926,7 +932,10 @@ void iwl_rx_handle(struct iwl_priv *priv)
 
 	/* Backtrack one entry */
 	priv->rxq.read = i;
-	iwl_rx_queue_restock(priv);
+	if (fill_rx)
+		iwl_rx_replenish_now(priv);
+	else
+		iwl_rx_queue_restock(priv);
 }
 
 /* call this function to flush any scheduled tasklet */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index cbd87af..87df1b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -318,10 +318,11 @@ int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl_rx_queue *q);
 void iwl_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 void iwl_rx_replenish(struct iwl_priv *priv);
+void iwl_rx_replenish_now(struct iwl_priv *priv);
 int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwl_rx_queue_restock(struct iwl_priv *priv);
 int iwl_rx_queue_space(const struct iwl_rx_queue *q);
-void iwl_rx_allocate(struct iwl_priv *priv);
+void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority);
 void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
 /* Handlers */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2076742..770cd1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -382,6 +382,7 @@ struct iwl_rx_queue {
 	u32 read;
 	u32 write;
 	u32 free_count;
+	u32 write_actual;
 	struct list_head rx_free;
 	struct list_head rx_used;
 	int need_update;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 7a43282..c845089 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -145,12 +145,14 @@ int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
 			goto exit_unlock;
 		}
 
-		iwl_write_direct32(priv, rx_wrt_ptr_reg, q->write & ~0x7);
+		q->write_actual = (q->write & ~0x7);
+		iwl_write_direct32(priv, rx_wrt_ptr_reg, q->write_actual);
 
 	/* Else device is assumed to be awake */
 	} else {
 		/* Device expects a multiple of 8 */
-		iwl_write32(priv, rx_wrt_ptr_reg, q->write & ~0x7);
+		q->write_actual = (q->write & ~0x7);
+		iwl_write_direct32(priv, rx_wrt_ptr_reg, q->write_actual);
 	}
 
 	q->need_update = 0;
@@ -212,7 +214,7 @@ int iwl_rx_queue_restock(struct iwl_priv *priv)
 
 	/* If we've added more space for the firmware to place data, tell it.
 	 * Increment device's write pointer in multiples of 8. */
-	if (write != (rxq->write & ~0x7)) {
+	if (rxq->write_actual != (rxq->write & ~0x7)) {
 		spin_lock_irqsave(&rxq->lock, flags);
 		rxq->need_update = 1;
 		spin_unlock_irqrestore(&rxq->lock, flags);
@@ -232,7 +234,7 @@ EXPORT_SYMBOL(iwl_rx_queue_restock);
  * Also restock the Rx queue via iwl_rx_queue_restock.
  * This is called as a scheduled work item (except for during initialization)
  */
-void iwl_rx_allocate(struct iwl_priv *priv)
+void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
@@ -254,7 +256,8 @@ void iwl_rx_allocate(struct iwl_priv *priv)
 
 		/* Alloc a new receive buffer */
 		rxb->skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
-				     GFP_KERNEL);
+						priority);
+
 		if (!rxb->skb) {
 			IWL_CRIT(priv, "Can not allocate SKB buffers\n");
 			/* We don't reschedule replenish work here -- we will
@@ -289,7 +292,7 @@ void iwl_rx_replenish(struct iwl_priv *priv)
 {
 	unsigned long flags;
 
-	iwl_rx_allocate(priv);
+	iwl_rx_allocate(priv, GFP_KERNEL);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_rx_queue_restock(priv);
@@ -297,6 +300,14 @@ void iwl_rx_replenish(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_rx_replenish);
 
+void iwl_rx_replenish_now(struct iwl_priv *priv)
+{
+	iwl_rx_allocate(priv, GFP_ATOMIC);
+
+	iwl_rx_queue_restock(priv);
+}
+EXPORT_SYMBOL(iwl_rx_replenish_now);
+
 
 /* Assumes that the skb field of the buffers in 'pool' is kept accurate.
  * If an SKB has been detached, the POOL needs to have its SKB set to NULL
@@ -352,6 +363,7 @@ int iwl_rx_queue_alloc(struct iwl_priv *priv)
 	/* Set us so that we have processed and used all buffers, but have
 	 * not restocked the Rx queue with fresh buffers */
 	rxq->read = rxq->write = 0;
+	rxq->write_actual = 0;
 	rxq->free_count = 0;
 	rxq->need_update = 0;
 	return 0;
@@ -390,6 +402,7 @@ void iwl_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	/* Set us so that we have processed and used all buffers, but have
 	 * not restocked the Rx queue with fresh buffers */
 	rxq->read = rxq->write = 0;
+	rxq->write_actual = 0;
 	rxq->free_count = 0;
 	spin_unlock_irqrestore(&rxq->lock, flags);
 }
-- 
1.5.6.3

