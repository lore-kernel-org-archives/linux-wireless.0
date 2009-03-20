Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20685 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbZCTUrw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 16:47:52 -0400
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	Samuel Ortiz <samuel@sortiz.org>,
	Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <c4d76b3b0903191822l5494f268h395acc4a14608239@mail.gmail.com>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <1236312734.19328.37.camel@rainbow> <1236317982.12430.9.camel@rc-desk>
	 <1236649234.6685.9.camel@rainbow> <1236661466.15923.53.camel@rc-desk>
	 <1236742805.6267.9.camel@rainbow>
	 <c4d76b3b0903122031o7baea17ay5704df428ea2fced@mail.gmail.com>
	 <c4d76b3b0903160510i5afc6cd6t856b63383a275fca@mail.gmail.com>
	 <1237254243.13077.33.camel@rainbow> <1237427568.6943.13.camel@rainbow>
	 <c4d76b3b0903191822l5494f268h395acc4a14608239@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-Cw+ZmpUu3KQcECgrmlp4"
Date: Fri, 20 Mar 2009 13:39:24 -0700
Message-Id: <1237581564.21165.5.camel@abhi-desktop> (sfid-20090320_214755_793627_547B6895)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Cw+ZmpUu3KQcECgrmlp4
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Can you try this patch?

Thanks
Abhijeet

On Thu, 2009-03-19 at 18:22 -0700, Jason Andryuk wrote:

> There is a bug related to the use of DMA.  Using wireless-testing
> 2.6.29-rc7 from ~3/15, and booting with "iommu=off mem=2G" gives me a
> working iwl3945.  I also confirmed
> 78bb4a96d0d4ab2860df5f0fdfde58cd7a3ad642 "iwl3945: use iwl3945_tx_cmd
> instead of iwl_tx_cmd" plus previously posted "rb_stts and BUG to
> WARN" patch as working when iommu is disabled.
> 
> So swiotlb exposes iwl3945 dma breakage.
> 
> From 78bb4a96d0d4ab2860df5f0fdfde58cd7a3ad642 "iwl3945: use
> iwl3945_tx_cmd instead of iwl_tx_cmd" the most obvious problem is the
> change to pci_map_single from pci_alloc_consistent.
> 
> As previously noted, problems brought along by that include the
> modification of data to be DMAed after the _map_single call.  The lack
> of associated un-mapping of memory may also be a problem.
> 
> For testing, swiotlb use can be forced with "swiotlb=force" which
> should reproduce the error.
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-Cw+ZmpUu3KQcECgrmlp4
Content-Disposition: attachment; filename=0001-iwl3945-fix-alignment-for-x64.patch
Content-Type: application/mbox; name=0001-iwl3945-fix-alignment-for-x64.patch
Content-Transfer-Encoding: 7bit

>From 03290380a01698e5991d68f340920eb2bde0a807 Mon Sep 17 00:00:00 2001
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Date: Fri, 20 Mar 2009 13:37:28 -0700
Subject: [PATCH] iwl3945: fix alignment for x64

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 279d10c..eb991d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1580,7 +1580,7 @@ static int iwl3945_rx_queue_restock(struct iwl_priv *priv)
 		list_del(element);
 
 		/* Point to Rx buffer via next RBD in circular buffer */
-		rxq->bd[rxq->write] = iwl3945_dma_addr2rbd_ptr(priv, rxb->real_dma_addr);
+		rxq->bd[rxq->write] = iwl3945_dma_addr2rbd_ptr(priv, rxb->aligned_dma_addr);
 		rxq->queue[rxq->write] = rxb;
 		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
 		rxq->free_count--;
@@ -1628,7 +1628,7 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv)
 
 		/* Alloc a new receive buffer */
 		rxb->skb =
-		    alloc_skb(priv->hw_params.rx_buf_size,
+		    alloc_skb(priv->hw_params.rx_buf_size + 256,
 				__GFP_NOWARN | GFP_ATOMIC);
 		if (!rxb->skb) {
 			if (net_ratelimit())
@@ -1645,16 +1645,16 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv)
 		 * headroom of the physical head should be enough for the
 		 * radiotap head that iwl3945 supported. See iwl3945_rt.
 		 */
-		skb_reserve(rxb->skb, 4);
-
 		priv->alloc_rxb_skb++;
 		list_del(element);
 
 		/* Get physical address of RB/SKB */
 		rxb->real_dma_addr = pci_map_single(priv->pci_dev,
 						rxb->skb->data,
-						priv->hw_params.rx_buf_size,
+						priv->hw_params.rx_buf_size + 256,
 						PCI_DMA_FROMDEVICE);
+		rxb->aligned_dma_addr = ALIGN(rxb->real_dma_addr, 256);
+		skb_reserve(rxb->skb, rxb->aligned_dma_addr - rxb->real_dma_addr);
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
 	}
@@ -1802,9 +1802,11 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 
 		rxq->queue[i] = NULL;
 
-		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->real_dma_addr,
-					    priv->hw_params.rx_buf_size,
-					    PCI_DMA_FROMDEVICE);
+		dma_sync_single_range_for_cpu(
+				&priv->pci_dev->dev, rxb->real_dma_addr,
+				rxb->aligned_dma_addr - rxb->real_dma_addr,
+				priv->hw_params.rx_buf_size,
+				PCI_DMA_FROMDEVICE);
 		pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
 		/* Reclaim a command buffer only if this packet is a response
@@ -1853,7 +1855,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 		}
 
 		pci_unmap_single(priv->pci_dev, rxb->real_dma_addr,
-				priv->hw_params.rx_buf_size,
+				priv->hw_params.rx_buf_size + 256,
 				PCI_DMA_FROMDEVICE);
 		spin_lock_irqsave(&rxq->lock, flags);
 		list_add_tail(&rxb->list, &priv->rxq.rx_used);
-- 
1.5.4.3


--=-Cw+ZmpUu3KQcECgrmlp4--

