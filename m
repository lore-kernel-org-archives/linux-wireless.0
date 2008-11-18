Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57085 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYKRAsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 19:48:25 -0500
Subject: [PATCH/RFT] iwlagn: fix RX skb alignment
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
Content-Type: text/plain
Date: Tue, 18 Nov 2008 01:47:21 +0100
Message-Id: <1226969241.4014.24.camel@johannes.berg> (sfid-20081118_014839_339263_738F563C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[patch below, sorry for the long list of CCs]

So I dug deeper into the DMA problems I had with iwlagn and a kind soul
helped me in that he said something about pci-e alignment and mentioned
the iwl_rx_allocate function to check for crossing 4KB boundaries. Since
there's 8KB A-MPDU support, crossing 4k boundaries didn't seem like
something the device would fail with, but when I looked into the
function for a minute anyway I stumbled over this little gem:

	BUG_ON(rxb->dma_addr & (~DMA_BIT_MASK(36) & 0xff));

Clearly, that is a totally bogus check, one would hope the compiler
removes it entirely. (Think about it)

After fixing it, I obviously ran into it, nothing guarantees the
alignment the way you want it,  because of the way skbs and their
headroom are allocated. I won't explain that here nor double-check that
I'm right, that goes beyond what most of the CC'ed people care about.

So then I came up with the patch below, and so far my system has
survived minutes with 64K pages, when it would previously fail in
seconds. And I haven't seen a single instance of the TX bug either. But
when you see the patch it'll be pretty obvious to you why.

This should fix the following reported kernel bugs:

http://bugzilla.kernel.org/show_bug.cgi?id=11596
http://bugzilla.kernel.org/show_bug.cgi?id=11393
http://bugzilla.kernel.org/show_bug.cgi?id=11983

I haven't checked if there are any elsewhere, but I suppose RHBZ will
have a few instances too...

I'd like to ask anyone who is CC'ed (those are people I know ran into
the bug) to try this patch.

I am convinced that this patch is correct in spirit, but I haven't
understood why, for example, there are so many unmap calls. I'm not
entirely convinced that this is the only bug leading to the TX reply
errors.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-rx.c  |   19 +++++++++++--------
 3 files changed, 16 insertions(+), 12 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-11-18 00:25:20.467874837 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-11-18 00:48:33.639664984 +0100
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
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-11-18 00:35:58.731046047 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-11-18 00:36:07.097669223 +0100
@@ -89,7 +89,8 @@ extern struct iwl_cfg iwl5100_abg_cfg;
 #define	DEFAULT_LONG_RETRY_LIMIT  4U
 
 struct iwl_rx_mem_buffer {
-	dma_addr_t dma_addr;
+	dma_addr_t real_dma_addr;
+	dma_addr_t aligned_dma_addr;
 	struct sk_buff *skb;
 	struct list_head list;
 };
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-rx.c	2008-11-17 23:52:50.090694856 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c	2008-11-18 01:03:25.503685123 +0100
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
@@ -302,7 +305,7 @@ void iwl_rx_queue_free(struct iwl_priv *
 	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
 		if (rxq->pool[i].skb != NULL) {
 			pci_unmap_single(priv->pci_dev,
-					 rxq->pool[i].dma_addr,
+					 rxq->pool[i].real_dma_addr,
 					 priv->hw_params.rx_buf_size,
 					 PCI_DMA_FROMDEVICE);
 			dev_kfree_skb(rxq->pool[i].skb);
@@ -370,7 +373,7 @@ void iwl_rx_queue_reset(struct iwl_priv 
 		 * to an SKB, so we need to unmap and free potential storage */
 		if (rxq->pool[i].skb != NULL) {
 			pci_unmap_single(priv->pci_dev,
-					 rxq->pool[i].dma_addr,
+					 rxq->pool[i].real_dma_addr,
 					 priv->hw_params.rx_buf_size,
 					 PCI_DMA_FROMDEVICE);
 			priv->alloc_rxb_skb--;


