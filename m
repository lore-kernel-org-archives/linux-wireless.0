Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab2KITtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 14:49:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] iwlwifi: handle DMA mapping failures
Date: Fri,  9 Nov 2012 20:49:42 +0100
Message-Id: <1352490583-28609-1-git-send-email-johannes@sipsolutions.net> (sfid-20121109_204915_152301_43A79040)
In-Reply-To: <1352490162.9238.23.camel@jlt4.sipsolutions.net>
References: <1352490162.9238.23.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The RX replenish code doesn't handle DMA mapping failures,
which will cause issues if there actually is a failure. This
was reported by Shuah Khan who found a DMA mapping framework
warning ("device driver failed to check map error").

Cc: stable@vger.kernel.org
Reported-by: Shuah Khan <shuah.khan@hp.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 17c8e5d..bb69f8f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -321,6 +321,14 @@ static void iwl_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 			dma_map_page(trans->dev, page, 0,
 				     PAGE_SIZE << trans_pcie->rx_page_order,
 				     DMA_FROM_DEVICE);
+		if (dma_mapping_error(trans->dev, rxb->page_dma)) {
+			rxb->page = NULL;
+			spin_lock_irqsave(&rxq->lock, flags);
+			list_add(&rxb->list, &rxq->rx_used);
+			spin_unlock_irqrestore(&rxq->lock, flags);
+			__free_pages(page, trans_pcie->rx_page_order);
+			return;
+		}
 		/* dma address must be no more than 36 bits */
 		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
 		/* and also 256 byte aligned! */
@@ -488,8 +496,19 @@ static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
 			dma_map_page(trans->dev, rxb->page, 0,
 				     PAGE_SIZE << trans_pcie->rx_page_order,
 				     DMA_FROM_DEVICE);
-		list_add_tail(&rxb->list, &rxq->rx_free);
-		rxq->free_count++;
+		if (dma_mapping_error(trans->dev, rxb->page_dma)) {
+			/*
+			 * free the page(s) as well to not break
+			 * the invariant that the items on the used
+			 * list have no page(s)
+			 */
+			__free_pages(rxb->page, trans_pcie->rx_page_order);
+			rxb->page = NULL;
+			list_add_tail(&rxb->list, &rxq->rx_used);
+		} else {
+			list_add_tail(&rxb->list, &rxq->rx_free);
+			rxq->free_count++;
+		}
 	} else
 		list_add_tail(&rxb->list, &rxq->rx_used);
 	spin_unlock_irqrestore(&rxq->lock, flags);
-- 
1.8.0

