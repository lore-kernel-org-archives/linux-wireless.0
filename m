Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47089 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbbBOMDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 07:03:05 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 4/9] wil6210: branch prediction hints
Date: Sun, 15 Feb 2015 14:02:33 +0200
Message-Id: <1424001758-29529-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150215_130319_242056_A3FC18A5)
In-Reply-To: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mark expected branches using likely()/unlikely().
Do it on high performance route - data path and interrupts

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 25 ++++++++---------
 drivers/net/wireless/ath/wil6210/txrx.c      | 40 ++++++++++++++--------------
 2 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index d5a651b..28ffc18 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -226,7 +226,7 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 	trace_wil6210_irq_rx(isr);
 	wil_dbg_irq(wil, "ISR RX 0x%08x\n", isr);
 
-	if (!isr) {
+	if (unlikely(!isr)) {
 		wil_err(wil, "spurious IRQ: RX\n");
 		return IRQ_NONE;
 	}
@@ -239,17 +239,18 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 	 * action is always the same - should empty the accumulated
 	 * packets from the RX ring.
 	 */
-	if (isr & (BIT_DMA_EP_RX_ICR_RX_DONE | BIT_DMA_EP_RX_ICR_RX_HTRSH)) {
+	if (likely(isr & (BIT_DMA_EP_RX_ICR_RX_DONE |
+			  BIT_DMA_EP_RX_ICR_RX_HTRSH))) {
 		wil_dbg_irq(wil, "RX done\n");
 
-		if (isr & BIT_DMA_EP_RX_ICR_RX_HTRSH)
+		if (unlikely(isr & BIT_DMA_EP_RX_ICR_RX_HTRSH))
 			wil_err_ratelimited(wil,
 					    "Received \"Rx buffer is in risk of overflow\" interrupt\n");
 
 		isr &= ~(BIT_DMA_EP_RX_ICR_RX_DONE |
 			 BIT_DMA_EP_RX_ICR_RX_HTRSH);
-		if (test_bit(wil_status_reset_done, wil->status)) {
-			if (test_bit(wil_status_napi_en, wil->status)) {
+		if (likely(test_bit(wil_status_reset_done, wil->status))) {
+			if (likely(test_bit(wil_status_napi_en, wil->status))) {
 				wil_dbg_txrx(wil, "NAPI(Rx) schedule\n");
 				need_unmask = false;
 				napi_schedule(&wil->napi_rx);
@@ -262,7 +263,7 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 		}
 	}
 
-	if (isr)
+	if (unlikely(isr))
 		wil_err(wil, "un-handled RX ISR bits 0x%08x\n", isr);
 
 	/* Rx IRQ will be enabled when NAPI processing finished */
@@ -286,19 +287,19 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 	trace_wil6210_irq_tx(isr);
 	wil_dbg_irq(wil, "ISR TX 0x%08x\n", isr);
 
-	if (!isr) {
+	if (unlikely(!isr)) {
 		wil_err(wil, "spurious IRQ: TX\n");
 		return IRQ_NONE;
 	}
 
 	wil6210_mask_irq_tx(wil);
 
-	if (isr & BIT_DMA_EP_TX_ICR_TX_DONE) {
+	if (likely(isr & BIT_DMA_EP_TX_ICR_TX_DONE)) {
 		wil_dbg_irq(wil, "TX done\n");
 		isr &= ~BIT_DMA_EP_TX_ICR_TX_DONE;
 		/* clear also all VRING interrupts */
 		isr &= ~(BIT(25) - 1UL);
-		if (test_bit(wil_status_reset_done, wil->status)) {
+		if (likely(test_bit(wil_status_reset_done, wil->status))) {
 			wil_dbg_txrx(wil, "NAPI(Tx) schedule\n");
 			need_unmask = false;
 			napi_schedule(&wil->napi_tx);
@@ -307,7 +308,7 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 		}
 	}
 
-	if (isr)
+	if (unlikely(isr))
 		wil_err(wil, "un-handled TX ISR bits 0x%08x\n", isr);
 
 	/* Tx IRQ will be enabled when NAPI processing finished */
@@ -496,11 +497,11 @@ static irqreturn_t wil6210_hardirq(int irq, void *cookie)
 	/**
 	 * pseudo_cause is Clear-On-Read, no need to ACK
 	 */
-	if ((pseudo_cause == 0) || ((pseudo_cause & 0xff) == 0xff))
+	if (unlikely((pseudo_cause == 0) || ((pseudo_cause & 0xff) == 0xff)))
 		return IRQ_NONE;
 
 	/* FIXME: IRQ mask debug */
-	if (wil6210_debug_irq_mask(wil, pseudo_cause))
+	if (unlikely(wil6210_debug_irq_mask(wil, pseudo_cause)))
 		return IRQ_NONE;
 
 	trace_wil6210_irq_pseudo(pseudo_cause);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 779d836..7e119d0 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -370,11 +370,11 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 
 	BUILD_BUG_ON(sizeof(struct vring_rx_desc) > sizeof(skb->cb));
 
-	if (wil_vring_is_empty(vring))
+	if (unlikely(wil_vring_is_empty(vring)))
 		return NULL;
 
 	_d = &vring->va[vring->swhead].rx;
-	if (!(_d->dma.status & RX_DMA_STATUS_DU)) {
+	if (unlikely(!(_d->dma.status & RX_DMA_STATUS_DU))) {
 		/* it is not error, we just reached end of Rx done area */
 		return NULL;
 	}
@@ -394,7 +394,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	wil_hex_dump_txrx("Rx ", DUMP_PREFIX_NONE, 32, 4,
 			  (const void *)d, sizeof(*d), false);
 
-	if (dmalen > sz) {
+	if (unlikely(dmalen > sz)) {
 		wil_err(wil, "Rx size too large: %d bytes!\n", dmalen);
 		kfree_skb(skb);
 		return NULL;
@@ -423,14 +423,14 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	 * in Rx descriptor. If type is not data, it is 802.11 frame as is
 	 */
 	ftype = wil_rxdesc_ftype(d) << 2;
-	if (ftype != IEEE80211_FTYPE_DATA) {
+	if (unlikely(ftype != IEEE80211_FTYPE_DATA)) {
 		wil_dbg_txrx(wil, "Non-data frame ftype 0x%08x\n", ftype);
 		/* TODO: process it */
 		kfree_skb(skb);
 		return NULL;
 	}
 
-	if (skb->len < ETH_HLEN) {
+	if (unlikely(skb->len < ETH_HLEN)) {
 		wil_err(wil, "Short frame, len = %d\n", skb->len);
 		/* TODO: process it (i.e. BAR) */
 		kfree_skb(skb);
@@ -441,9 +441,9 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	 * and in case of error drop the packet
 	 * higher stack layers will handle retransmission (if required)
 	 */
-	if (d->dma.status & RX_DMA_STATUS_L4I) {
+	if (likely(d->dma.status & RX_DMA_STATUS_L4I)) {
 		/* L4 protocol identified, csum calculated */
-		if ((d->dma.error & RX_DMA_ERROR_L4_ERR) == 0)
+		if (likely((d->dma.error & RX_DMA_ERROR_L4_ERR) == 0))
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 		/* If HW reports bad checksum, let IP stack re-check it
 		 * For example, HW don't understand Microsoft IP stack that
@@ -472,7 +472,7 @@ static int wil_rx_refill(struct wil6210_priv *wil, int count)
 			(next_tail != v->swhead) && (count-- > 0);
 			v->swtail = next_tail) {
 		rc = wil_vring_alloc_skb(wil, v, v->swtail, headroom);
-		if (rc) {
+		if (unlikely(rc)) {
 			wil_err(wil, "Error %d in wil_rx_refill[%d]\n",
 				rc, v->swtail);
 			break;
@@ -534,7 +534,7 @@ void wil_rx_handle(struct wil6210_priv *wil, int *quota)
 	struct vring *v = &wil->vring_rx;
 	struct sk_buff *skb;
 
-	if (!v->va) {
+	if (unlikely(!v->va)) {
 		wil_err(wil, "Rx IRQ while Rx not yet initialized\n");
 		return;
 	}
@@ -927,7 +927,7 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	if (unlikely(!txdata->enabled))
 		return -EINVAL;
 
-	if (avail < 1 + nr_frags) {
+	if (unlikely(avail < 1 + nr_frags)) {
 		wil_err_ratelimited(wil,
 				    "Tx ring[%2d] full. No space for %d fragments\n",
 				    vring_index, 1 + nr_frags);
@@ -948,7 +948,7 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	/* 1-st segment */
 	wil_tx_desc_map(d, pa, skb_headlen(skb), vring_index);
 	/* Process TCP/UDP checksum offloading */
-	if (wil_tx_desc_offload_cksum_set(wil, d, skb)) {
+	if (unlikely(wil_tx_desc_offload_cksum_set(wil, d, skb))) {
 		wil_err(wil, "Tx[%2d] Failed to set cksum, drop packet\n",
 			vring_index);
 		goto dma_error;
@@ -1051,18 +1051,18 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	int rc;
 
 	wil_dbg_txrx(wil, "%s()\n", __func__);
-	if (!test_bit(wil_status_fwready, wil->status)) {
+	if (unlikely(!test_bit(wil_status_fwready, wil->status))) {
 		if (!pr_once_fw) {
 			wil_err(wil, "FW not ready\n");
 			pr_once_fw = true;
 		}
 		goto drop;
 	}
-	if (!test_bit(wil_status_fwconnected, wil->status)) {
+	if (unlikely(!test_bit(wil_status_fwconnected, wil->status))) {
 		wil_err(wil, "FW not connected\n");
 		goto drop;
 	}
-	if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR) {
+	if (unlikely(wil->wdev->iftype == NL80211_IFTYPE_MONITOR)) {
 		wil_err(wil, "Xmit in monitor mode not supported\n");
 		goto drop;
 	}
@@ -1078,7 +1078,7 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		else
 			vring = wil_tx_bcast(wil, skb);
 	}
-	if (!vring) {
+	if (unlikely(!vring)) {
 		wil_dbg_txrx(wil, "No Tx VRING found for %pM\n", eth->h_dest);
 		goto drop;
 	}
@@ -1086,7 +1086,7 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	rc = wil_tx_vring(wil, vring, skb);
 
 	/* do we still have enough room in the vring? */
-	if (wil_vring_avail_tx(vring) < wil_vring_wmark_low(vring)) {
+	if (unlikely(wil_vring_avail_tx(vring) < wil_vring_wmark_low(vring))) {
 		netif_tx_stop_all_queues(wil_to_ndev(wil));
 		wil_dbg_txrx(wil, "netif_tx_stop : ring full\n");
 	}
@@ -1142,12 +1142,12 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 	struct wil_net_stats *stats = &wil->sta[cid].stats;
 	volatile struct vring_tx_desc *_d;
 
-	if (!vring->va) {
+	if (unlikely(!vring->va)) {
 		wil_err(wil, "Tx irq[%d]: vring not initialized\n", ringid);
 		return 0;
 	}
 
-	if (!txdata->enabled) {
+	if (unlikely(!txdata->enabled)) {
 		wil_info(wil, "Tx irq[%d]: vring disabled\n", ringid);
 		return 0;
 	}
@@ -1165,7 +1165,7 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		/* TODO: check we are not past head */
 
 		_d = &vring->va[lf].tx;
-		if (!(_d->dma.status & TX_DMA_STATUS_DU))
+		if (unlikely(!(_d->dma.status & TX_DMA_STATUS_DU)))
 			break;
 
 		new_swtail = (lf + 1) % vring->size;
@@ -1193,7 +1193,7 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 			wil_txdesc_unmap(dev, d, ctx);
 
 			if (skb) {
-				if (d->dma.error == 0) {
+				if (likely(d->dma.error == 0)) {
 					ndev->stats.tx_packets++;
 					stats->tx_packets++;
 					ndev->stats.tx_bytes += skb->len;
-- 
2.1.0

