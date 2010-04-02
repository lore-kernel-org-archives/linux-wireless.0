Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37744 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab0DBUi7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 16:38:59 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/7] iwlwifi: clear rxq->queue in queue reset
Date: Fri,  2 Apr 2010 13:38:50 -0700
Message-Id: <1270240734-12825-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270240734-12825-1-git-send-email-reinette.chatre@intel.com>
References: <1270240734-12825-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

In iwl_rx_queue_reset(), we didn't clear the rxq->queue[]. This might
cause the same rxb appears on multiple places in rxq->queue. Although
this won't cause any problem because of the read and write pointers
protection in rxq, we'd better clear it to avoid misleading.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 1d2e84c..6fe1d93 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -403,6 +403,9 @@ void iwlagn_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
 	}
 
+	for (i = 0; i < RX_QUEUE_SIZE; i++)
+		rxq->queue[i] = NULL;
+
 	/* Set us so that we have processed and used all buffers, but have
 	 * not restocked the Rx queue with fresh buffers */
 	rxq->read = rxq->write = 0;
@@ -538,11 +541,13 @@ void iwlagn_rx_queue_restock(struct iwl_priv *priv)
 	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
 	unsigned long flags;
-	int write;
 
 	spin_lock_irqsave(&rxq->lock, flags);
-	write = rxq->write & ~0x7;
 	while ((iwl_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
+		/* The overwritten rxb must be a used one */
+		rxb = rxq->queue[rxq->write];
+		BUG_ON(rxb && rxb->page);
+
 		/* Get next free Rx buffer, remove from free list */
 		element = rxq->rx_free.next;
 		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
@@ -635,6 +640,7 @@ void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
+		BUG_ON(rxb->page);
 		rxb->page = page;
 		/* Get physical address of the RB */
 		rxb->page_dma = pci_map_page(priv->pci_dev, page, 0,
-- 
1.6.3.3

