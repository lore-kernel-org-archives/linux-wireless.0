Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54751 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab2KIUHk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:07:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 06/13] iwlwifi: use list_first_entry
Date: Fri,  9 Nov 2012 21:08:05 +0100
Message-Id: <1352491692-28994-7-git-send-email-johannes@sipsolutions.net> (sfid-20121109_210755_696194_F20BAF64)
In-Reply-To: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
References: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of open-coding it with a temporary list_head
pointer, just use list_first_entry.

Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 50c9147..25e6f86 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -199,7 +199,6 @@ static void iwl_rx_queue_restock(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
-	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
 	unsigned long flags;
 
@@ -221,9 +220,9 @@ static void iwl_rx_queue_restock(struct iwl_trans *trans)
 		BUG_ON(rxb && rxb->page);
 
 		/* Get next free Rx buffer, remove from free list */
-		element = rxq->rx_free.next;
-		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
-		list_del(element);
+		rxb = list_first_entry(&rxq->rx_free, struct iwl_rx_mem_buffer,
+				       list);
+		list_del(&rxb->list);
 
 		/* Point to Rx buffer via next RBD in circular buffer */
 		rxq->bd[rxq->write] = iwl_dma_addr2rbd_ptr(rxb->page_dma);
@@ -260,7 +259,6 @@ static void iwl_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
-	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
 	struct page *page;
 	unsigned long flags;
@@ -308,10 +306,9 @@ static void iwl_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 			__free_pages(page, trans_pcie->rx_page_order);
 			return;
 		}
-		element = rxq->rx_used.next;
-		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
-		list_del(element);
-
+		rxb = list_first_entry(&rxq->rx_used, struct iwl_rx_mem_buffer,
+				       list);
+		list_del(&rxb->list);
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
 		BUG_ON(rxb->page);
-- 
1.8.0

