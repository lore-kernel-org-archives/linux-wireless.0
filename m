Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24351 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbZJWUmr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:47 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/18] iwlwifi: reuse page for notification packets
Date: Fri, 23 Oct 2009 13:42:32 -0700
Message-Id: <1256330556-20997-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

For notification packets and SKBs that fail to rx correctly, add
them back into the rx_free list so that the pages can be reused
later. This avoids allocating new rx pages unnecessarily.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   27 +++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   27 +++++++++++++++------------
 2 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0d38865..ea1b931 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -769,7 +769,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 		IWL_DEBUG_RX(priv, "r = %d, i = %d\n", r, i);
 
 	/* calculate total frames need to be restock after handling RX */
-	total_empty = r - priv->rxq.write_actual;
+	total_empty = r - rxq->write_actual;
 	if (total_empty < 0)
 		total_empty += RX_QUEUE_SIZE;
 
@@ -841,25 +841,28 @@ void iwl_rx_handle(struct iwl_priv *priv)
 				IWL_WARN(priv, "Claim null rxb?\n");
 		}
 
-		/* For now we just don't re-use anything.  We can tweak this
-		 * later to try and re-use notification packets and SKBs that
-		 * fail to Rx correctly */
+		/* Reuse the page if possible. For notification packets and
+		 * SKBs that fail to Rx correctly, add them back into the
+		 * rx_free list for reuse later. */
+		spin_lock_irqsave(&rxq->lock, flags);
 		if (rxb->page != NULL) {
-			priv->alloc_rxb_page--;
-			__free_pages(rxb->page, priv->hw_params.rx_page_order);
-			rxb->page = NULL;
-		}
+			rxb->page_dma = pci_map_page(priv->pci_dev, rxb->page,
+				0, PAGE_SIZE << priv->hw_params.rx_page_order,
+				PCI_DMA_FROMDEVICE);
+			list_add_tail(&rxb->list, &rxq->rx_free);
+			rxq->free_count++;
+		} else
+			list_add_tail(&rxb->list, &rxq->rx_used);
 
-		spin_lock_irqsave(&rxq->lock, flags);
-		list_add_tail(&rxb->list, &priv->rxq.rx_used);
 		spin_unlock_irqrestore(&rxq->lock, flags);
+
 		i = (i + 1) & RX_QUEUE_MASK;
 		/* If there are a lot of unused frames,
 		 * restock the Rx queue so ucode wont assert. */
 		if (fill_rx) {
 			count++;
 			if (count >= 8) {
-				priv->rxq.read = i;
+				rxq->read = i;
 				iwl_rx_replenish_now(priv);
 				count = 0;
 			}
@@ -867,7 +870,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 	}
 
 	/* Backtrack one entry */
-	priv->rxq.read = i;
+	rxq->read = i;
 	if (fill_rx)
 		iwl_rx_replenish_now(priv);
 	else
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8b08bdc..9a430ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1367,7 +1367,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 	i = rxq->read;
 
 	/* calculate total frames need to be restock after handling RX */
-	total_empty = r - priv->rxq.write_actual;
+	total_empty = r - rxq->write_actual;
 	if (total_empty < 0)
 		total_empty += RX_QUEUE_SIZE;
 
@@ -1438,25 +1438,28 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 				IWL_WARN(priv, "Claim null rxb?\n");
 		}
 
-		/* For now we just don't re-use anything.  We can tweak this
-		 * later to try and re-use notification packets and SKBs that
-		 * fail to Rx correctly */
+		/* Reuse the page if possible. For notification packets and
+		 * SKBs that fail to Rx correctly, add them back into the
+		 * rx_free list for reuse later. */
+		spin_lock_irqsave(&rxq->lock, flags);
 		if (rxb->page != NULL) {
-			priv->alloc_rxb_page--;
-			__free_pages(rxb->page, priv->hw_params.rx_page_order);
-			rxb->page = NULL;
-		}
+			rxb->page_dma = pci_map_page(priv->pci_dev, rxb->page,
+				0, PAGE_SIZE << priv->hw_params.rx_page_order,
+				PCI_DMA_FROMDEVICE);
+			list_add_tail(&rxb->list, &rxq->rx_free);
+			rxq->free_count++;
+		} else
+			list_add_tail(&rxb->list, &rxq->rx_used);
 
-		spin_lock_irqsave(&rxq->lock, flags);
-		list_add_tail(&rxb->list, &priv->rxq.rx_used);
 		spin_unlock_irqrestore(&rxq->lock, flags);
+
 		i = (i + 1) & RX_QUEUE_MASK;
 		/* If there are a lot of unused frames,
 		 * restock the Rx queue so ucode won't assert. */
 		if (fill_rx) {
 			count++;
 			if (count >= 8) {
-				priv->rxq.read = i;
+				rxq->read = i;
 				iwl3945_rx_replenish_now(priv);
 				count = 0;
 			}
@@ -1464,7 +1467,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 	}
 
 	/* Backtrack one entry */
-	priv->rxq.read = i;
+	rxq->read = i;
 	if (fill_rx)
 		iwl3945_rx_replenish_now(priv);
 	else
-- 
1.5.6.3

