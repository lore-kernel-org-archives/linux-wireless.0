Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab2IJROz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 13:14:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/6] iwlwifi: some clean up in transport layer
Date: Mon, 10 Sep 2012 19:15:28 +0200
Message-Id: <1347297330-23338-5-git-send-email-johannes@sipsolutions.net> (sfid-20120910_191501_052973_9784430A)
In-Reply-To: <1347297330-23338-1-git-send-email-johannes@sipsolutions.net>
References: <1347297330-23338-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Remove outdated iwlagn prefix to a few functions and fix comments
that were not accurate.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |    2 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c       |   54 +++++++++++++++-----------
 drivers/net/wireless/iwlwifi/pcie/trans.c    |    2 +-
 3 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 3ef8d5a..fa102b8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -311,7 +311,7 @@ void iwl_trans_pcie_free(struct iwl_trans *trans);
 ******************************************************/
 void iwl_bg_rx_replenish(struct work_struct *data);
 void iwl_irq_tasklet(struct iwl_trans *trans);
-void iwlagn_rx_replenish(struct iwl_trans *trans);
+void iwl_rx_replenish(struct iwl_trans *trans);
 void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 				   struct iwl_rx_queue *q);
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 7b2ac67..7fc3821 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -177,15 +177,15 @@ void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 }
 
 /**
- * iwlagn_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
+ * iwl_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
  */
-static inline __le32 iwlagn_dma_addr2rbd_ptr(dma_addr_t dma_addr)
+static inline __le32 iwl_dma_addr2rbd_ptr(dma_addr_t dma_addr)
 {
 	return cpu_to_le32((u32)(dma_addr >> 8));
 }
 
 /**
- * iwlagn_rx_queue_restock - refill RX queue from pre-allocated pool
+ * iwl_rx_queue_restock - refill RX queue from pre-allocated pool
  *
  * If there are slots in the RX queue that need to be restocked,
  * and we have free pre-allocated buffers, fill the ranks as much
@@ -195,7 +195,7 @@ static inline __le32 iwlagn_dma_addr2rbd_ptr(dma_addr_t dma_addr)
  * also updates the memory address in the firmware to reference the new
  * target buffer.
  */
-static void iwlagn_rx_queue_restock(struct iwl_trans *trans)
+static void iwl_rx_queue_restock(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
@@ -215,7 +215,7 @@ static void iwlagn_rx_queue_restock(struct iwl_trans *trans)
 		list_del(element);
 
 		/* Point to Rx buffer via next RBD in circular buffer */
-		rxq->bd[rxq->write] = iwlagn_dma_addr2rbd_ptr(rxb->page_dma);
+		rxq->bd[rxq->write] = iwl_dma_addr2rbd_ptr(rxb->page_dma);
 		rxq->queue[rxq->write] = rxb;
 		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
 		rxq->free_count--;
@@ -226,7 +226,6 @@ static void iwlagn_rx_queue_restock(struct iwl_trans *trans)
 	if (rxq->free_count <= RX_LOW_WATERMARK)
 		schedule_work(&trans_pcie->rx_replenish);
 
-
 	/* If we've added more space for the firmware to place data, tell it.
 	 * Increment device's write pointer in multiples of 8. */
 	if (rxq->write_actual != (rxq->write & ~0x7)) {
@@ -237,15 +236,16 @@ static void iwlagn_rx_queue_restock(struct iwl_trans *trans)
 	}
 }
 
-/**
- * iwlagn_rx_replenish - Move all used packet from rx_used to rx_free
- *
- * When moving to rx_free an SKB is allocated for the slot.
+/*
+ * iwl_rx_allocate - allocate a page for each used RBD
  *
- * Also restock the Rx queue via iwl_rx_queue_restock.
- * This is called as a scheduled work item (except for during initialization)
+ * A used RBD is an Rx buffer that has been given to the stack. To use it again
+ * a page must be allocated and the RBD must point to the page. This function
+ * doesn't change the HW pointer but handles the list of pages that is used by
+ * iwl_rx_queue_restock. The latter function will update the HW to use the newly
+ * allocated buffers.
  */
-static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
+static void iwl_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
@@ -324,23 +324,31 @@ static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 	}
 }
 
-void iwlagn_rx_replenish(struct iwl_trans *trans)
+/*
+ * iwl_rx_replenish - Move all used buffers from rx_used to rx_free
+ *
+ * When moving to rx_free an page is allocated for the slot.
+ *
+ * Also restock the Rx queue via iwl_rx_queue_restock.
+ * This is called as a scheduled work item (except for during initialization)
+ */
+void iwl_rx_replenish(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	unsigned long flags;
 
-	iwlagn_rx_allocate(trans, GFP_KERNEL);
+	iwl_rx_allocate(trans, GFP_KERNEL);
 
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
-	iwlagn_rx_queue_restock(trans);
+	iwl_rx_queue_restock(trans);
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 }
 
-static void iwlagn_rx_replenish_now(struct iwl_trans *trans)
+static void iwl_rx_replenish_now(struct iwl_trans *trans)
 {
-	iwlagn_rx_allocate(trans, GFP_ATOMIC);
+	iwl_rx_allocate(trans, GFP_ATOMIC);
 
-	iwlagn_rx_queue_restock(trans);
+	iwl_rx_queue_restock(trans);
 }
 
 void iwl_bg_rx_replenish(struct work_struct *data)
@@ -348,7 +356,7 @@ void iwl_bg_rx_replenish(struct work_struct *data)
 	struct iwl_trans_pcie *trans_pcie =
 	    container_of(data, struct iwl_trans_pcie, rx_replenish);
 
-	iwlagn_rx_replenish(trans_pcie->trans);
+	iwl_rx_replenish(trans_pcie->trans);
 }
 
 static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
@@ -526,7 +534,7 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 			count++;
 			if (count >= 8) {
 				rxq->read = i;
-				iwlagn_rx_replenish_now(trans);
+				iwl_rx_replenish_now(trans);
 				count = 0;
 			}
 		}
@@ -535,9 +543,9 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 	/* Backtrack one entry */
 	rxq->read = i;
 	if (fill_rx)
-		iwlagn_rx_replenish_now(trans);
+		iwl_rx_replenish_now(trans);
 	else
-		iwlagn_rx_queue_restock(trans);
+		iwl_rx_queue_restock(trans);
 }
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 3f11b17..d44fa2a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -216,7 +216,7 @@ static int iwl_rx_init(struct iwl_trans *trans)
 	rxq->free_count = 0;
 	spin_unlock_irqrestore(&rxq->lock, flags);
 
-	iwlagn_rx_replenish(trans);
+	iwl_rx_replenish(trans);
 
 	iwl_trans_rx_hw_init(trans, rxq);
 
-- 
1.7.10.4

