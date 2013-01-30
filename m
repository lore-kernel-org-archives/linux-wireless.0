Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab3A3QIM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 11:08:12 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -next] iwlegacy: check for dma mapping errors
Date: Wed, 30 Jan 2013 17:08:03 +0100
Message-Id: <1359562083-2490-1-git-send-email-sgruszka@redhat.com> (sfid-20130130_170816_915164_E1F2C187)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handle pci_map_page() errors. This fixes "DMA-API: device driver failed
to check map error" warning.

Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
Patch is intended to -next, even if it fix a problem, it is very
unlikely that iwlegacy is used on machine with IOMMU (where
pci_map_page can fail). More probable is using CONFIG_DMA_API_DEBUG,
which generate the warning, but that's is not real problem.

 drivers/net/wireless/iwlegacy/3945-mac.c |   39 ++++++++++++++++++--------
 drivers/net/wireless/iwlegacy/4965-mac.c |   43 ++++++++++++++++++-----------
 2 files changed, 54 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 050ce7c..83856d1 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -1001,12 +1001,12 @@ il3945_rx_allocate(struct il_priv *il, gfp_t priority)
 	struct list_head *element;
 	struct il_rx_buf *rxb;
 	struct page *page;
+	dma_addr_t page_dma;
 	unsigned long flags;
 	gfp_t gfp_mask = priority;
 
 	while (1) {
 		spin_lock_irqsave(&rxq->lock, flags);
-
 		if (list_empty(&rxq->rx_used)) {
 			spin_unlock_irqrestore(&rxq->lock, flags);
 			return;
@@ -1035,26 +1035,34 @@ il3945_rx_allocate(struct il_priv *il, gfp_t priority)
 			break;
 		}
 
+		/* Get physical address of RB/SKB */
+		page_dma =
+		    pci_map_page(il->pci_dev, page, 0,
+				 PAGE_SIZE << il->hw_params.rx_page_order,
+				 PCI_DMA_FROMDEVICE);
+
+		if (unlikely(pci_dma_mapping_error(il->pci_dev, page_dma))) {
+			__free_pages(page, il->hw_params.rx_page_order);
+			break;
+		}
+
 		spin_lock_irqsave(&rxq->lock, flags);
+
 		if (list_empty(&rxq->rx_used)) {
 			spin_unlock_irqrestore(&rxq->lock, flags);
+			pci_unmap_page(il->pci_dev, page_dma,
+				       PAGE_SIZE << il->hw_params.rx_page_order,
+				       PCI_DMA_FROMDEVICE);
 			__free_pages(page, il->hw_params.rx_page_order);
 			return;
 		}
+
 		element = rxq->rx_used.next;
 		rxb = list_entry(element, struct il_rx_buf, list);
 		list_del(element);
-		spin_unlock_irqrestore(&rxq->lock, flags);
 
 		rxb->page = page;
-		/* Get physical address of RB/SKB */
-		rxb->page_dma =
-		    pci_map_page(il->pci_dev, page, 0,
-				 PAGE_SIZE << il->hw_params.rx_page_order,
-				 PCI_DMA_FROMDEVICE);
-
-		spin_lock_irqsave(&rxq->lock, flags);
-
+		rxb->page_dma = page_dma;
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
 		il->alloc_rxb_page++;
@@ -1284,8 +1292,15 @@ il3945_rx_handle(struct il_priv *il)
 			    pci_map_page(il->pci_dev, rxb->page, 0,
 					 PAGE_SIZE << il->hw_params.
 					 rx_page_order, PCI_DMA_FROMDEVICE);
-			list_add_tail(&rxb->list, &rxq->rx_free);
-			rxq->free_count++;
+			if (unlikely(pci_dma_mapping_error(il->pci_dev,
+							   rxb->page_dma))) {
+				__il_free_pages(il, rxb->page);
+				rxb->page = NULL;
+				list_add_tail(&rxb->list, &rxq->rx_used);
+			} else {
+				list_add_tail(&rxb->list, &rxq->rx_free);
+				rxq->free_count++;
+			}
 		} else
 			list_add_tail(&rxb->list, &rxq->rx_used);
 
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index f1dc040..38f14c1 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -319,6 +319,7 @@ il4965_rx_allocate(struct il_priv *il, gfp_t priority)
 	struct list_head *element;
 	struct il_rx_buf *rxb;
 	struct page *page;
+	dma_addr_t page_dma;
 	unsigned long flags;
 	gfp_t gfp_mask = priority;
 
@@ -356,33 +357,35 @@ il4965_rx_allocate(struct il_priv *il, gfp_t priority)
 			return;
 		}
 
+		/* Get physical address of the RB */
+		page_dma =
+		    pci_map_page(il->pci_dev, page, 0,
+				 PAGE_SIZE << il->hw_params.rx_page_order,
+				 PCI_DMA_FROMDEVICE);
+		if (unlikely(pci_dma_mapping_error(il->pci_dev, page_dma))) {
+			__free_pages(page, il->hw_params.rx_page_order);
+			break;
+		}
+
 		spin_lock_irqsave(&rxq->lock, flags);
 
 		if (list_empty(&rxq->rx_used)) {
 			spin_unlock_irqrestore(&rxq->lock, flags);
+			pci_unmap_page(il->pci_dev, page_dma,
+				       PAGE_SIZE << il->hw_params.rx_page_order,
+				       PCI_DMA_FROMDEVICE);
 			__free_pages(page, il->hw_params.rx_page_order);
 			return;
 		}
+
 		element = rxq->rx_used.next;
 		rxb = list_entry(element, struct il_rx_buf, list);
 		list_del(element);
 
-		spin_unlock_irqrestore(&rxq->lock, flags);
-
 		BUG_ON(rxb->page);
-		rxb->page = page;
-		/* Get physical address of the RB */
-		rxb->page_dma =
-		    pci_map_page(il->pci_dev, page, 0,
-				 PAGE_SIZE << il->hw_params.rx_page_order,
-				 PCI_DMA_FROMDEVICE);
-		/* dma address must be no more than 36 bits */
-		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
-		/* and also 256 byte aligned! */
-		BUG_ON(rxb->page_dma & DMA_BIT_MASK(8));
-
-		spin_lock_irqsave(&rxq->lock, flags);
 
+		rxb->page = page;
+		rxb->page_dma = page_dma;
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
 		il->alloc_rxb_page++;
@@ -4281,8 +4284,16 @@ il4965_rx_handle(struct il_priv *il)
 			    pci_map_page(il->pci_dev, rxb->page, 0,
 					 PAGE_SIZE << il->hw_params.
 					 rx_page_order, PCI_DMA_FROMDEVICE);
-			list_add_tail(&rxb->list, &rxq->rx_free);
-			rxq->free_count++;
+
+			if (unlikely(pci_dma_mapping_error(il->pci_dev,
+							   rxb->page_dma))) {
+				__il_free_pages(il, rxb->page);
+				rxb->page = NULL;
+				list_add_tail(&rxb->list, &rxq->rx_used);
+			} else {
+				list_add_tail(&rxb->list, &rxq->rx_free);
+				rxq->free_count++;
+			}
 		} else
 			list_add_tail(&rxb->list, &rxq->rx_used);
 
-- 
1.7.1

