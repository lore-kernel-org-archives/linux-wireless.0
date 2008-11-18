Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46328 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYKRKxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 05:53:32 -0500
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	reinette chatre <reinette.chatre@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matt Mackall <mpm@selenic.com>,
	Christophe Dumez <dchris@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
	Jan =?UTF-8?Q?V=C4=8Del=C3=A1k?= <vcelak.jan@seznam.cz>,
	Thomas Witt <witt_th@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andres Freund <andres@anarazel.de>
In-Reply-To: <1226969241.4014.24.camel@johannes.berg> (sfid-20081118_014839_339263_738F563C)
References: <1226969241.4014.24.camel@johannes.berg>
	 (sfid-20081118_014839_339263_738F563C)
Content-Type: text/plain
Date: Tue, 18 Nov 2008 11:52:37 +0100
Message-Id: <1227005557.4014.47.camel@johannes.berg> (sfid-20081118_115335_763774_81140FFA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I'd like to ask anyone who is CC'ed (those are people I know ran into
> the bug) to try this patch.

Here's an updated version fixing the two errors pointed out by Zhu Yi.

---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-rx.c  |   23 +++++++++++++----------
 3 files changed, 18 insertions(+), 14 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-11-17 23:35:34.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-11-18 11:45:11.000000000 +0100
@@ -1229,7 +1229,7 @@ void iwl_rx_handle(struct iwl_priv *priv
 
 		rxq->queue[i] = NULL;
 
-		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->dma_addr,
+		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->aligned_dma_addr,
 					    priv->hw_params.rx_buf_size,
 					    PCI_DMA_FROMDEVICE);
 		pkt = (struct iwl_rx_packet *)rxb->skb->data;
@@ -1282,8 +1282,8 @@ void iwl_rx_handle(struct iwl_priv *priv
 			rxb->skb = NULL;
 		}
 
-		pci_unmap_single(priv->pci_dev, rxb->dma_addr,
-				 priv->hw_params.rx_buf_size,
+		pci_unmap_single(priv->pci_dev, rxb->real_dma_addr,
+				 priv->hw_params.rx_buf_size + 256,
 				 PCI_DMA_FROMDEVICE);
 		spin_lock_irqsave(&rxq->lock, flags);
 		list_add_tail(&rxb->list, &priv->rxq.rx_used);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-11-11 01:00:58.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-11-18 11:45:11.000000000 +0100
@@ -89,7 +89,8 @@ extern struct iwl_cfg iwl5100_abg_cfg;
 #define	DEFAULT_LONG_RETRY_LIMIT  4U
 
 struct iwl_rx_mem_buffer {
-	dma_addr_t dma_addr;
+	dma_addr_t real_dma_addr;
+	dma_addr_t aligned_dma_addr;
 	struct sk_buff *skb;
 	struct list_head list;
 };
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-rx.c	2008-11-18 01:50:05.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-rx.c	2008-11-18 11:46:05.000000000 +0100
@@ -204,7 +204,7 @@ int iwl_rx_queue_restock(struct iwl_priv
 		list_del(element);
 
 		/* Point to Rx buffer via next RBD in circular buffer */
-		rxq->bd[rxq->write] = iwl_dma_addr2rbd_ptr(priv, rxb->dma_addr);
+		rxq->bd[rxq->write] = iwl_dma_addr2rbd_ptr(priv, rxb->aligned_dma_addr);
 		rxq->queue[rxq->write] = rxb;
 		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
 		rxq->free_count--;
@@ -250,7 +250,7 @@ void iwl_rx_allocate(struct iwl_priv *pr
 		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
 
 		/* Alloc a new receive buffer */
-		rxb->skb = alloc_skb(priv->hw_params.rx_buf_size,
+		rxb->skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
 				__GFP_NOWARN | GFP_ATOMIC);
 		if (!rxb->skb) {
 			if (net_ratelimit())
@@ -265,11 +265,14 @@ void iwl_rx_allocate(struct iwl_priv *pr
 		list_del(element);
 
 		/* Get physical address of RB/SKB */
-		rxb->dma_addr = pci_map_single(priv->pci_dev, rxb->skb->data,
-			   priv->hw_params.rx_buf_size, PCI_DMA_FROMDEVICE);
+		rxb->real_dma_addr = pci_map_single(priv->pci_dev, rxb->skb->data,
+			   priv->hw_params.rx_buf_size + 256, PCI_DMA_FROMDEVICE);
 
-		/* RBD must be 256 bytes aligned and no more than 36 bits */
-		BUG_ON(rxb->dma_addr & (~DMA_BIT_MASK(36) & 0xff));
+		/* dma address must be no more than 36 bits */
+		BUG_ON(rxb->real_dma_addr & ~DMA_BIT_MASK(36));
+		/* and also 256 byte aligned! */
+		rxb->aligned_dma_addr = ALIGN(rxb->real_dma_addr, 256);
+		skb_reserve(rxb->skb, rxb->aligned_dma_addr - rxb->real_dma_addr);
 
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
@@ -302,8 +305,8 @@ void iwl_rx_queue_free(struct iwl_priv *
 	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
 		if (rxq->pool[i].skb != NULL) {
 			pci_unmap_single(priv->pci_dev,
-					 rxq->pool[i].dma_addr,
-					 priv->hw_params.rx_buf_size,
+					 rxq->pool[i].real_dma_addr,
+					 priv->hw_params.rx_buf_size + 256,
 					 PCI_DMA_FROMDEVICE);
 			dev_kfree_skb(rxq->pool[i].skb);
 		}
@@ -370,8 +373,8 @@ void iwl_rx_queue_reset(struct iwl_priv 
 		 * to an SKB, so we need to unmap and free potential storage */
 		if (rxq->pool[i].skb != NULL) {
 			pci_unmap_single(priv->pci_dev,
-					 rxq->pool[i].dma_addr,
-					 priv->hw_params.rx_buf_size,
+					 rxq->pool[i].real_dma_addr,
+					 priv->hw_params.rx_buf_size + 256,
 					 PCI_DMA_FROMDEVICE);
 			priv->alloc_rxb_skb--;
 			dev_kfree_skb(rxq->pool[i].skb);


