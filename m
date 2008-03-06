Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:39126 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbYCFPgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 10:36:15 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Rename the DMA ring pointers
Date: Thu, 6 Mar 2008 16:32:46 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200803061632.46568.mb@bu3sch.de> (sfid-20080306_153620_410270_0FDE38DE)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename the DMA ring pointers to have more descriptive and standard
names. Also remove the 6th unused TX ring. We can add it back later,
if we need it. The unused TX-status rx-ring is also removed, as that's
only used by legacy devices not supported by this driver anyway.

This is no functional change, except less memory allocation for
the removed rings.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.26


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-03-06 16:15:23.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-03-06 16:15:24.000000000 +0100
@@ -586,21 +586,19 @@ struct b43_phy {
 	bool phy_locked;
 #endif /* B43_DEBUG */
 };
 
 /* Data structures for DMA transmission, per 80211 core. */
 struct b43_dma {
-	struct b43_dmaring *tx_ring0;
-	struct b43_dmaring *tx_ring1;
-	struct b43_dmaring *tx_ring2;
-	struct b43_dmaring *tx_ring3;
-	struct b43_dmaring *tx_ring4;
-	struct b43_dmaring *tx_ring5;
+	struct b43_dmaring *tx_ring_AC_BK; /* Background */
+	struct b43_dmaring *tx_ring_AC_BE; /* Best Effort */
+	struct b43_dmaring *tx_ring_AC_VI; /* Video */
+	struct b43_dmaring *tx_ring_AC_VO; /* Voice */
+	struct b43_dmaring *tx_ring_mcast; /* Multicast */
 
-	struct b43_dmaring *rx_ring0;
-	struct b43_dmaring *rx_ring3;	/* only available on core.rev < 5 */
+	struct b43_dmaring *rx_ring;
 };
 
 /* Context information for a noise calculation (Link Quality). */
 struct b43_noise_calculation {
 	u8 channel_at_start;
 	bool calculation_running;
Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2008-03-06 16:15:23.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2008-03-06 16:30:32.000000000 +0100
@@ -876,60 +876,53 @@ struct b43_dmaring *b43_setup_dmaring(st
 	kfree(ring);
 	ring = NULL;
 	goto out;
 }
 
 /* Main cleanup function. */
-static void b43_destroy_dmaring(struct b43_dmaring *ring)
+static void b43_destroy_dmaring(struct b43_dmaring *ring,
+				const char *ringname)
 {
 	if (!ring)
 		return;
 
-	b43dbg(ring->dev->wl, "DMA-%u 0x%04X (%s) max used slots: %d/%d\n",
-	       (unsigned int)(ring->type),
-	       ring->mmio_base,
-	       (ring->tx) ? "TX" : "RX", ring->max_used_slots, ring->nr_slots);
+	b43dbg(ring->dev->wl, "DMA-%u %s max used slots: %d/%d\n",
+	       (unsigned int)(ring->type), ringname,
+	       ring->max_used_slots, ring->nr_slots);
 	/* Device IRQs are disabled prior entering this function,
 	 * so no need to take care of concurrency with rx handler stuff.
 	 */
 	dmacontroller_cleanup(ring);
 	free_all_descbuffers(ring);
 	free_ringmemory(ring);
 
 	kfree(ring->txhdr_cache);
 	kfree(ring->meta);
 	kfree(ring);
 }
 
+#define destroy_ring(dma, ring) do {				\
+	b43_destroy_dmaring((dma)->ring, __stringify(ring));	\
+	(dma)->ring = NULL;					\
+    } while (0)
+
 void b43_dma_free(struct b43_wldev *dev)
 {
 	struct b43_dma *dma = &dev->dma;
 
-	b43_destroy_dmaring(dma->rx_ring3);
-	dma->rx_ring3 = NULL;
-	b43_destroy_dmaring(dma->rx_ring0);
-	dma->rx_ring0 = NULL;
-
-	b43_destroy_dmaring(dma->tx_ring5);
-	dma->tx_ring5 = NULL;
-	b43_destroy_dmaring(dma->tx_ring4);
-	dma->tx_ring4 = NULL;
-	b43_destroy_dmaring(dma->tx_ring3);
-	dma->tx_ring3 = NULL;
-	b43_destroy_dmaring(dma->tx_ring2);
-	dma->tx_ring2 = NULL;
-	b43_destroy_dmaring(dma->tx_ring1);
-	dma->tx_ring1 = NULL;
-	b43_destroy_dmaring(dma->tx_ring0);
-	dma->tx_ring0 = NULL;
+	destroy_ring(dma, rx_ring);
+	destroy_ring(dma, tx_ring_AC_BK);
+	destroy_ring(dma, tx_ring_AC_BE);
+	destroy_ring(dma, tx_ring_AC_VI);
+	destroy_ring(dma, tx_ring_AC_VO);
+	destroy_ring(dma, tx_ring_mcast);
 }
 
 int b43_dma_init(struct b43_wldev *dev)
 {
 	struct b43_dma *dma = &dev->dma;
-	struct b43_dmaring *ring;
 	int err;
 	u64 dmamask;
 	enum b43_dmatype type;
 
 	dmamask = supported_dma_mask(dev);
 	switch (dmamask) {
@@ -953,122 +946,75 @@ int b43_dma_init(struct b43_wldev *dev)
 		       (unsigned int)(dmamask & 0x00000000FFFFFFFFULL));
 		return -EOPNOTSUPP;
 	}
 
 	err = -ENOMEM;
 	/* setup TX DMA channels. */
-	ring = b43_setup_dmaring(dev, 0, 1, type);
-	if (!ring)
+	dma->tx_ring_AC_BK = b43_setup_dmaring(dev, 0, 1, type);
+	if (!dma->tx_ring_AC_BK)
 		goto out;
-	dma->tx_ring0 = ring;
-
-	ring = b43_setup_dmaring(dev, 1, 1, type);
-	if (!ring)
-		goto err_destroy_tx0;
-	dma->tx_ring1 = ring;
 
-	ring = b43_setup_dmaring(dev, 2, 1, type);
-	if (!ring)
-		goto err_destroy_tx1;
-	dma->tx_ring2 = ring;
+	dma->tx_ring_AC_BE = b43_setup_dmaring(dev, 1, 1, type);
+	if (!dma->tx_ring_AC_BE)
+		goto err_destroy_bk;
+
+	dma->tx_ring_AC_VI = b43_setup_dmaring(dev, 2, 1, type);
+	if (!dma->tx_ring_AC_VI)
+		goto err_destroy_be;
+
+	dma->tx_ring_AC_VO = b43_setup_dmaring(dev, 3, 1, type);
+	if (!dma->tx_ring_AC_VO)
+		goto err_destroy_vi;
+
+	dma->tx_ring_mcast = b43_setup_dmaring(dev, 4, 1, type);
+	if (!dma->tx_ring_mcast)
+		goto err_destroy_vo;
+
+	/* setup RX DMA channel. */
+	dma->rx_ring = b43_setup_dmaring(dev, 0, 0, type);
+	if (!dma->rx_ring)
+		goto err_destroy_mcast;
 
-	ring = b43_setup_dmaring(dev, 3, 1, type);
-	if (!ring)
-		goto err_destroy_tx2;
-	dma->tx_ring3 = ring;
-
-	ring = b43_setup_dmaring(dev, 4, 1, type);
-	if (!ring)
-		goto err_destroy_tx3;
-	dma->tx_ring4 = ring;
-
-	ring = b43_setup_dmaring(dev, 5, 1, type);
-	if (!ring)
-		goto err_destroy_tx4;
-	dma->tx_ring5 = ring;
-
-	/* setup RX DMA channels. */
-	ring = b43_setup_dmaring(dev, 0, 0, type);
-	if (!ring)
-		goto err_destroy_tx5;
-	dma->rx_ring0 = ring;
-
-	if (dev->dev->id.revision < 5) {
-		ring = b43_setup_dmaring(dev, 3, 0, type);
-		if (!ring)
-			goto err_destroy_rx0;
-		dma->rx_ring3 = ring;
-	}
+	/* No support for the TX status DMA ring. */
+	B43_WARN_ON(dev->dev->id.revision < 5);
 
 	b43dbg(dev->wl, "%u-bit DMA initialized\n",
 	       (unsigned int)type);
 	err = 0;
-      out:
+out:
 	return err;
 
-      err_destroy_rx0:
-	b43_destroy_dmaring(dma->rx_ring0);
-	dma->rx_ring0 = NULL;
-      err_destroy_tx5:
-	b43_destroy_dmaring(dma->tx_ring5);
-	dma->tx_ring5 = NULL;
-      err_destroy_tx4:
-	b43_destroy_dmaring(dma->tx_ring4);
-	dma->tx_ring4 = NULL;
-      err_destroy_tx3:
-	b43_destroy_dmaring(dma->tx_ring3);
-	dma->tx_ring3 = NULL;
-      err_destroy_tx2:
-	b43_destroy_dmaring(dma->tx_ring2);
-	dma->tx_ring2 = NULL;
-      err_destroy_tx1:
-	b43_destroy_dmaring(dma->tx_ring1);
-	dma->tx_ring1 = NULL;
-      err_destroy_tx0:
-	b43_destroy_dmaring(dma->tx_ring0);
-	dma->tx_ring0 = NULL;
-	goto out;
+err_destroy_mcast:
+	destroy_ring(dma, tx_ring_mcast);
+err_destroy_vo:
+	destroy_ring(dma, tx_ring_AC_VO);
+err_destroy_vi:
+	destroy_ring(dma, tx_ring_AC_VI);
+err_destroy_be:
+	destroy_ring(dma, tx_ring_AC_BE);
+err_destroy_bk:
+	destroy_ring(dma, tx_ring_AC_BK);
+	return err;
 }
 
 /* Generate a cookie for the TX header. */
 static u16 generate_cookie(struct b43_dmaring *ring, int slot)
 {
-	u16 cookie = 0x1000;
+	u16 cookie;
 
 	/* Use the upper 4 bits of the cookie as
 	 * DMA controller ID and store the slot number
 	 * in the lower 12 bits.
 	 * Note that the cookie must never be 0, as this
 	 * is a special value used in RX path.
 	 * It can also not be 0xFFFF because that is special
 	 * for multicast frames.
 	 */
-	switch (ring->index) {
-	case 0:
-		cookie = 0x1000;
-		break;
-	case 1:
-		cookie = 0x2000;
-		break;
-	case 2:
-		cookie = 0x3000;
-		break;
-	case 3:
-		cookie = 0x4000;
-		break;
-	case 4:
-		cookie = 0x5000;
-		break;
-	case 5:
-		cookie = 0x6000;
-		break;
-	default:
-		B43_WARN_ON(1);
-	}
+	cookie = (((u16)ring->index + 1) << 12);
 	B43_WARN_ON(slot & ~0x0FFF);
-	cookie |= (u16) slot;
+	cookie |= (u16)slot;
 
 	return cookie;
 }
 
 /* Inspect a cookie and find out to which controller/slot it belongs. */
 static
@@ -1076,28 +1022,25 @@ struct b43_dmaring *parse_cookie(struct 
 {
 	struct b43_dma *dma = &dev->dma;
 	struct b43_dmaring *ring = NULL;
 
 	switch (cookie & 0xF000) {
 	case 0x1000:
-		ring = dma->tx_ring0;
+		ring = dma->tx_ring_AC_BK;
 		break;
 	case 0x2000:
-		ring = dma->tx_ring1;
+		ring = dma->tx_ring_AC_BE;
 		break;
 	case 0x3000:
-		ring = dma->tx_ring2;
+		ring = dma->tx_ring_AC_VI;
 		break;
 	case 0x4000:
-		ring = dma->tx_ring3;
+		ring = dma->tx_ring_AC_VO;
 		break;
 	case 0x5000:
-		ring = dma->tx_ring4;
-		break;
-	case 0x6000:
-		ring = dma->tx_ring5;
+		ring = dma->tx_ring_mcast;
 		break;
 	default:
 		B43_WARN_ON(1);
 	}
 	*slot = (cookie & 0x0FFF);
 	B43_WARN_ON(!(ring && *slot >= 0 && *slot < ring->nr_slots));
@@ -1236,26 +1179,26 @@ static struct b43_dmaring * select_ring_
 		/* 0 = highest priority */
 		switch (queue_prio) {
 		default:
 			B43_WARN_ON(1);
 			/* fallthrough */
 		case 0:
-			ring = dev->dma.tx_ring3; /* AC_VO */
+			ring = dev->dma.tx_ring_AC_VO;
 			break;
 		case 1:
-			ring = dev->dma.tx_ring2; /* AC_VI */
+			ring = dev->dma.tx_ring_AC_VI;
 			break;
 		case 2:
-			ring = dev->dma.tx_ring1; /* AC_BE */
+			ring = dev->dma.tx_ring_AC_BE;
 			break;
 		case 3:
-			ring = dev->dma.tx_ring0; /* AC_BK */
+			ring = dev->dma.tx_ring_AC_BK;
 			break;
 		}
 	} else
-		ring = dev->dma.tx_ring1;
+		ring = dev->dma.tx_ring_AC_BE;
 
 	return ring;
 }
 
 int b43_dma_tx(struct b43_wldev *dev,
 	       struct sk_buff *skb, struct ieee80211_tx_control *ctl)
@@ -1270,13 +1213,13 @@ int b43_dma_tx(struct b43_wldev *dev,
 		return -EINVAL;
 	}
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	if (ctl->flags & IEEE80211_TXCTL_SEND_AFTER_DTIM) {
 		/* The multicast ring will be sent after the DTIM */
-		ring = dev->dma.tx_ring4;
+		ring = dev->dma.tx_ring_mcast;
 		/* Set the more-data bit. Ucode will clear it on
 		 * the last frame for us. */
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 	} else {
 		/* Decide by priority where to put this frame. */
 		ring = select_ring_by_priority(dev, ctl->queue);
@@ -1438,31 +1381,12 @@ static void dma_rx(struct b43_dmaring *r
 
 	desc = ops->idx2desc(ring, *slot, &meta);
 
 	sync_descbuffer_for_cpu(ring, meta->dmaaddr, ring->rx_buffersize);
 	skb = meta->skb;
 
-	if (ring->index == 3) {
-		/* We received an xmit status. */
-		struct b43_hwtxstatus *hw = (struct b43_hwtxstatus *)skb->data;
-		int i = 0;
-
-		while (hw->cookie == 0) {
-			if (i > 100)
-				break;
-			i++;
-			udelay(2);
-			barrier();
-		}
-		b43_handle_hwtxstatus(ring->dev, hw);
-		/* recycle the descriptor buffer. */
-		sync_descbuffer_for_device(ring, meta->dmaaddr,
-					   ring->rx_buffersize);
-
-		return;
-	}
 	rxhdr = (struct b43_rxhdr_fw4 *)skb->data;
 	len = le16_to_cpu(rxhdr->frame_len);
 	if (len == 0) {
 		int i = 0;
 
 		do {
@@ -1513,13 +1437,13 @@ static void dma_rx(struct b43_dmaring *r
 
 	unmap_descbuffer(ring, dmaaddr, ring->rx_buffersize, 0);
 	skb_put(skb, len + ring->frameoffset);
 	skb_pull(skb, ring->frameoffset);
 
 	b43_rx(ring->dev, skb, rxhdr);
-      drop:
+drop:
 	return;
 }
 
 void b43_dma_rx(struct b43_dmaring *ring)
 {
 	const struct b43_dma_ops *ops = ring->ops;
@@ -1559,24 +1483,22 @@ static void b43_dma_tx_resume_ring(struc
 	spin_unlock_irqrestore(&ring->lock, flags);
 }
 
 void b43_dma_tx_suspend(struct b43_wldev *dev)
 {
 	b43_power_saving_ctl_bits(dev, B43_PS_AWAKE);
-	b43_dma_tx_suspend_ring(dev->dma.tx_ring0);
-	b43_dma_tx_suspend_ring(dev->dma.tx_ring1);
-	b43_dma_tx_suspend_ring(dev->dma.tx_ring2);
-	b43_dma_tx_suspend_ring(dev->dma.tx_ring3);
-	b43_dma_tx_suspend_ring(dev->dma.tx_ring4);
-	b43_dma_tx_suspend_ring(dev->dma.tx_ring5);
+	b43_dma_tx_suspend_ring(dev->dma.tx_ring_AC_BK);
+	b43_dma_tx_suspend_ring(dev->dma.tx_ring_AC_BE);
+	b43_dma_tx_suspend_ring(dev->dma.tx_ring_AC_VI);
+	b43_dma_tx_suspend_ring(dev->dma.tx_ring_AC_VO);
+	b43_dma_tx_suspend_ring(dev->dma.tx_ring_mcast);
 }
 
 void b43_dma_tx_resume(struct b43_wldev *dev)
 {
-	b43_dma_tx_resume_ring(dev->dma.tx_ring5);
-	b43_dma_tx_resume_ring(dev->dma.tx_ring4);
-	b43_dma_tx_resume_ring(dev->dma.tx_ring3);
-	b43_dma_tx_resume_ring(dev->dma.tx_ring2);
-	b43_dma_tx_resume_ring(dev->dma.tx_ring1);
-	b43_dma_tx_resume_ring(dev->dma.tx_ring0);
+	b43_dma_tx_resume_ring(dev->dma.tx_ring_mcast);
+	b43_dma_tx_resume_ring(dev->dma.tx_ring_AC_VO);
+	b43_dma_tx_resume_ring(dev->dma.tx_ring_AC_VI);
+	b43_dma_tx_resume_ring(dev->dma.tx_ring_AC_BE);
+	b43_dma_tx_resume_ring(dev->dma.tx_ring_AC_BK);
 	b43_power_saving_ctl_bits(dev, 0);
 }
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-03-06 16:15:23.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-03-06 16:15:24.000000000 +0100
@@ -1591,17 +1591,16 @@ static void b43_interrupt_tasklet(struct
 		;/* TODO */
 	if (reason & B43_IRQ_NOISESAMPLE_OK)
 		handle_irq_noise(dev);
 
 	/* Check the DMA reason registers for received data. */
 	if (dma_reason[0] & B43_DMAIRQ_RX_DONE)
-		b43_dma_rx(dev->dma.rx_ring0);
-	if (dma_reason[3] & B43_DMAIRQ_RX_DONE)
-		b43_dma_rx(dev->dma.rx_ring3);
+		b43_dma_rx(dev->dma.rx_ring);
 	B43_WARN_ON(dma_reason[1] & B43_DMAIRQ_RX_DONE);
 	B43_WARN_ON(dma_reason[2] & B43_DMAIRQ_RX_DONE);
+	B43_WARN_ON(dma_reason[3] & B43_DMAIRQ_RX_DONE);
 	B43_WARN_ON(dma_reason[4] & B43_DMAIRQ_RX_DONE);
 	B43_WARN_ON(dma_reason[5] & B43_DMAIRQ_RX_DONE);
 
 	if (reason & B43_IRQ_TX_OK)
 		handle_irq_transmit_status(dev);
 
