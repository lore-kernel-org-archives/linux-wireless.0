Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57556 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbZKSV0b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 16:26:31 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: Rewrite DMA Tx status handling sanity checks
Date: Thu, 19 Nov 2009 22:24:29 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200911192224.29491.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This rewrites the error handling policies in the TX status handler.
It tries to be error-tolerant as in "try hard to not crash the machine".
It won't recover from errors (that are bugs in the firmware or driver),
because that's impossible. However, it will return a more or less useful
error message and bail out. It also tries hard to use rate-limited messages
to not flood the syslog in case of a failure.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This patch also adds the skb pointer poisoning. I think it's not
strictly needed to catch firmware bugs anymore, because those should
be caught by the in-order check. However, we love defensive coding, so
we try to make the code as robust as possible.

I did not try with openfirmware, but I guess it blows up in the
in-order check there pretty quickly.
Would be cool if somebody could stress this on openfirmware.

Note that if the ordering sanity check fails that can mean three things:
- Either the report ordering on one engine is wrong.
- We missed one report on the engine.
- Or we reported the status to the wrong engine.


Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2009-11-18 19:21:17.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2009-11-19 21:40:45.000000000 +0100
@@ -874,7 +874,7 @@ static void free_all_descbuffers(struct 
 	for (i = 0; i < ring->nr_slots; i++) {
 		desc = ring->ops->idx2desc(ring, i, &meta);
 
-		if (!meta->skb) {
+		if (!meta->skb || b43_dma_ptr_is_poisoned(meta->skb)) {
 			B43_WARN_ON(!ring->tx);
 			continue;
 		}
@@ -926,7 +926,7 @@ struct b43_dmaring *b43_setup_dmaring(st
 				      enum b43_dmatype type)
 {
 	struct b43_dmaring *ring;
-	int err;
+	int i, err;
 	dma_addr_t dma_test;
 
 	ring = kzalloc(sizeof(*ring), GFP_KERNEL);
@@ -941,6 +941,8 @@ struct b43_dmaring *b43_setup_dmaring(st
 			     GFP_KERNEL);
 	if (!ring->meta)
 		goto err_kfree_ring;
+	for (i = 0; i < ring->nr_slots; i++)
+		ring->meta->skb = B43_DMA_PTR_POISON;
 
 	ring->type = type;
 	ring->dev = dev;
@@ -1251,11 +1253,13 @@ struct b43_dmaring *parse_cookie(struct 
 	case 0x5000:
 		ring = dma->tx_ring_mcast;
 		break;
-	default:
-		B43_WARN_ON(1);
 	}
 	*slot = (cookie & 0x0FFF);
-	B43_WARN_ON(!(ring && *slot >= 0 && *slot < ring->nr_slots));
+	if (unlikely(!ring || *slot < 0 || *slot >= ring->nr_slots)) {
+		b43dbg(dev->wl, "TX-status contains "
+		       "invalid cookie: 0x%04X\n", cookie);
+		return NULL;
+	}
 
 	return ring;
 }
@@ -1494,19 +1498,40 @@ void b43_dma_handle_txstatus(struct b43_
 	struct b43_dmaring *ring;
 	struct b43_dmadesc_generic *desc;
 	struct b43_dmadesc_meta *meta;
-	int slot;
+	int slot, firstused;
 	bool frame_succeed;
 
 	ring = parse_cookie(dev, status->cookie, &slot);
 	if (unlikely(!ring))
 		return;
-
 	B43_WARN_ON(!ring->tx);
+
+	/* Sanity check: TX packets are processed in-order on one ring.
+	 * Check if the slot deduced from the cookie really is the first
+	 * used slot. */
+	firstused = ring->current_slot - ring->used_slots + 1;
+	if (firstused < 0)
+		firstused = ring->nr_slots + firstused;
+	if (unlikely(slot != firstused)) {
+		/* This possibly is a firmware bug and will result in
+		 * malfunction, memory leaks and/or stall of DMA functionality. */
+		b43dbg(dev->wl, "Out of order TX status report on DMA ring %d. "
+		       "Expected %d, but got %d\n",
+		       ring->index, firstused, slot);
+		return;
+	}
+
 	ops = ring->ops;
 	while (1) {
-		B43_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
+		B43_WARN_ON(slot < 0 || slot >= ring->nr_slots);
 		desc = ops->idx2desc(ring, slot, &meta);
 
+		if (b43_dma_ptr_is_poisoned(meta->skb)) {
+			b43dbg(dev->wl, "Poisoned TX slot %d (first=%d) "
+			       "on ring %d\n",
+			       slot, firstused, ring->index);
+			break;
+		}
 		if (meta->skb) {
 			struct b43_private_tx_info *priv_info =
 				b43_get_priv_tx_info(IEEE80211_SKB_CB(meta->skb));
@@ -1522,7 +1547,14 @@ void b43_dma_handle_txstatus(struct b43_
 		if (meta->is_last_fragment) {
 			struct ieee80211_tx_info *info;
 
-			BUG_ON(!meta->skb);
+			if (unlikely(!meta->skb)) {
+				/* This is a scatter-gather fragment of a frame, so
+				 * the skb pointer must not be NULL. */
+				b43dbg(dev->wl, "TX status unexpected NULL skb "
+				       "at slot %d (first=%d) on ring %d\n",
+				       slot, firstused, ring->index);
+				break;
+			}
 
 			info = IEEE80211_SKB_CB(meta->skb);
 
@@ -1540,20 +1572,29 @@ void b43_dma_handle_txstatus(struct b43_
 #endif /* DEBUG */
 			ieee80211_tx_status(dev->wl->hw, meta->skb);
 
-			/* skb is freed by ieee80211_tx_status() */
-			meta->skb = NULL;
+			/* skb will be freed by ieee80211_tx_status().
+			 * Poison our pointer. */
+			meta->skb = B43_DMA_PTR_POISON;
 		} else {
 			/* No need to call free_descriptor_buffer here, as
 			 * this is only the txhdr, which is not allocated.
 			 */
-			B43_WARN_ON(meta->skb);
+			if (unlikely(meta->skb)) {
+				b43dbg(dev->wl, "TX status unexpected non-NULL skb "
+				       "at slot %d (first=%d) on ring %d\n",
+				       slot, firstused, ring->index);
+				break;
+			}
 		}
 
 		/* Everything unmapped and free'd. So it's not used anymore. */
 		ring->used_slots--;
 
-		if (meta->is_last_fragment)
+		if (meta->is_last_fragment) {
+			/* This is the last scatter-gather
+			 * fragment of the frame. We are done. */
 			break;
+		}
 		slot = next_slot(ring, slot);
 	}
 	if (ring->stopped) {
Index: wireless-testing/drivers/net/wireless/b43/dma.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.h	2009-11-18 19:29:49.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.h	2009-11-19 21:16:54.000000000 +0100
@@ -1,7 +1,7 @@
 #ifndef B43_DMA_H_
 #define B43_DMA_H_
 
-#include <linux/ieee80211.h>
+#include <linux/err.h>
 
 #include "b43.h"
 
@@ -164,6 +164,10 @@ struct b43_dmadesc_generic {
 #define B43_RXRING_SLOTS		64
 #define B43_DMA0_RX_BUFFERSIZE		IEEE80211_MAX_FRAME_LEN
 
+/* Pointer poison */
+#define B43_DMA_PTR_POISON		((void *)ERR_PTR(-ENOMEM))
+#define b43_dma_ptr_is_poisoned(ptr)	(unlikely((ptr) == B43_DMA_PTR_POISON))
+
 
 struct sk_buff;
 struct b43_private;

-- 
Greetings, Michael.
