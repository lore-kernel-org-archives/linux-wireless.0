Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17738 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbZD3UuQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 16:50:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/5] iwl3945: fix lock dependency
Date: Thu, 30 Apr 2009 13:56:26 -0700
Message-Id: <1241124991-12492-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241124991-12492-1-git-send-email-reinette.chatre@intel.com>
References: <1241124991-12492-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch seperates rx_used and rx_free into two
different atomic contexts. We can now avoid using GFP_ATOMIC
for skb allocation and use GFP_KERNEL.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   37 ++++++++++++--------------
 1 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5cd4321..dc0359c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1344,15 +1344,24 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv)
 	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
 	unsigned long flags;
-	spin_lock_irqsave(&rxq->lock, flags);
-	while (!list_empty(&rxq->rx_used)) {
+
+	while (1) {
+		spin_lock_irqsave(&rxq->lock, flags);
+
+		if (list_empty(&rxq->rx_used)) {
+			spin_unlock_irqrestore(&rxq->lock, flags);
+			return;
+		}
+
 		element = rxq->rx_used.next;
 		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
+		list_del(element);
+		spin_unlock_irqrestore(&rxq->lock, flags);
 
 		/* Alloc a new receive buffer */
 		rxb->skb =
 		    alloc_skb(priv->hw_params.rx_buf_size,
-				__GFP_NOWARN | GFP_ATOMIC);
+				GFP_KERNEL);
 		if (!rxb->skb) {
 			if (net_ratelimit())
 				IWL_CRIT(priv, ": Can not allocate SKB buffers\n");
@@ -1370,18 +1379,18 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv)
 		 */
 		skb_reserve(rxb->skb, 4);
 
-		priv->alloc_rxb_skb++;
-		list_del(element);
-
 		/* Get physical address of RB/SKB */
 		rxb->real_dma_addr = pci_map_single(priv->pci_dev,
 						rxb->skb->data,
 						priv->hw_params.rx_buf_size,
 						PCI_DMA_FROMDEVICE);
+
+		spin_lock_irqsave(&rxq->lock, flags);
 		list_add_tail(&rxb->list, &rxq->rx_free);
+		priv->alloc_rxb_skb++;
 		rxq->free_count++;
+		spin_unlock_irqrestore(&rxq->lock, flags);
 	}
-	spin_unlock_irqrestore(&rxq->lock, flags);
 }
 
 void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
@@ -1414,18 +1423,6 @@ void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	spin_unlock_irqrestore(&rxq->lock, flags);
 }
 
-/*
- * this should be called while priv->lock is locked
- */
-static void __iwl3945_rx_replenish(void *data)
-{
-	struct iwl_priv *priv = data;
-
-	iwl3945_rx_allocate(priv);
-	iwl3945_rx_queue_restock(priv);
-}
-
-
 void iwl3945_rx_replenish(void *data)
 {
 	struct iwl_priv *priv = data;
@@ -1644,7 +1641,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 			count++;
 			if (count >= 8) {
 				priv->rxq.read = i;
-				__iwl3945_rx_replenish(priv);
+				iwl3945_rx_queue_restock(priv);
 				count = 0;
 			}
 		}
-- 
1.5.6.3

