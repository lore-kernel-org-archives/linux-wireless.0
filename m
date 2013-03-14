Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28438 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3CNSqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 14:46:23 -0400
Date: Thu, 14 Mar 2013 13:46:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>, zajec5@gmail.com
Cc: isedev@gmail.com, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [RFC/RFT] b43: A fix for DMA transmission sequence errors
Message-ID: <51421afb.xUa3KbaBuvmUk4RG%Larry.Finger@lwfinger.net> (sfid-20130314_194628_637559_17FA717E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Iestyn C. Elfick <isedev@gmail.com>

Intermittently, b43 will report "Out of order TX status report on DMA ring".
When this happens, the driver must be reset before communication can resume.
The cause of the problem is believed to be an error in the closed-source
firmware; however, all versions of the firmware are affected.

This change uses the observation that the expected status is always 2 less
than the observed value, and supplies a fake status report to skip one
header/data pair.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

Although this is a hack, it seems to work for the OP. It should not cause any
ill effects on any device that does not have the problem.

It does need a lot more testing, particularly on systems prone to the out-of-order
status report problem.

If anyone can think of a cleaner, less intrusive solution, please let us know.

Thanks,

Larry
---

Index: wireless-testing-rebased/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing-rebased.orig/drivers/net/wireless/b43/dma.c
+++ wireless-testing-rebased/drivers/net/wireless/b43/dma.c
@@ -1487,8 +1487,11 @@ void b43_dma_handle_txstatus(struct b43_
 	const struct b43_dma_ops *ops;
 	struct b43_dmaring *ring;
 	struct b43_dmadesc_meta *meta;
+	static const struct b43_txstatus fake; /* filled with 0 */
+	const struct b43_txstatus *txstat;
 	int slot, firstused;
 	bool frame_succeed;
+	int skip;
 
 	ring = parse_cookie(dev, status->cookie, &slot);
 	if (unlikely(!ring))
@@ -1501,13 +1504,26 @@ void b43_dma_handle_txstatus(struct b43_
 	firstused = ring->current_slot - ring->used_slots + 1;
 	if (firstused < 0)
 		firstused = ring->nr_slots + firstused;
+
+	skip = 0;
 	if (unlikely(slot != firstused)) {
 		/* This possibly is a firmware bug and will result in
-		 * malfunction, memory leaks and/or stall of DMA functionality. */
+		 * malfunction, memory leaks and/or stall of DMA functionality.
+		 */
 		b43dbg(dev->wl, "Out of order TX status report on DMA ring %d. "
 		       "Expected %d, but got %d\n",
 		       ring->index, firstused, slot);
-		return;
+		if (slot == firstused + 2) {
+			/* If a single header/data pair was missed, skip over
+			 * the first two slots in an attempt to recover.
+			 */
+			slot = firstused;
+			skip = 2;
+			b43dbg(dev->wl, "Skip on DMA ring %d slot %d.\n",
+			       ring->index, slot);
+		} else {
+			return;
+		}
 	}
 
 	ops = ring->ops;
@@ -1522,11 +1538,13 @@ void b43_dma_handle_txstatus(struct b43_
 			       slot, firstused, ring->index);
 			break;
 		}
+
 		if (meta->skb) {
 			struct b43_private_tx_info *priv_info =
-				b43_get_priv_tx_info(IEEE80211_SKB_CB(meta->skb));
+			     b43_get_priv_tx_info(IEEE80211_SKB_CB(meta->skb));
 
-			unmap_descbuffer(ring, meta->dmaaddr, meta->skb->len, 1);
+			unmap_descbuffer(ring, meta->dmaaddr,
+					 meta->skb->len, 1);
 			kfree(priv_info->bouncebuffer);
 			priv_info->bouncebuffer = NULL;
 		} else {
@@ -1538,8 +1556,9 @@ void b43_dma_handle_txstatus(struct b43_
 			struct ieee80211_tx_info *info;
 
 			if (unlikely(!meta->skb)) {
-				/* This is a scatter-gather fragment of a frame, so
-				 * the skb pointer must not be NULL. */
+				/* This is a scatter-gather fragment of a frame,
+				 * so the skb pointer must not be NULL.
+				 */
 				b43dbg(dev->wl, "TX status unexpected NULL skb "
 				       "at slot %d (first=%d) on ring %d\n",
 				       slot, firstused, ring->index);
@@ -1550,9 +1569,18 @@ void b43_dma_handle_txstatus(struct b43_
 
 			/*
 			 * Call back to inform the ieee80211 subsystem about
-			 * the status of the transmission.
+			 * the status of the transmission. When skipping over
+			 * a missed TX status report, use a status structure
+			 * filled with zeros to indicate that the frame was not
+			 * sent (frame_count 0) and not acknowledged
 			 */
-			frame_succeed = b43_fill_txstatus_report(dev, info, status);
+			if (unlikely(!skip))
+				txstat = status;
+			else
+				txstat = &fake;
+
+			frame_succeed = b43_fill_txstatus_report(dev, info,
+								 txstat);
 #ifdef CONFIG_B43_DEBUG
 			if (frame_succeed)
 				ring->nr_succeed_tx_packets++;
@@ -1580,12 +1608,14 @@ void b43_dma_handle_txstatus(struct b43_
 		/* Everything unmapped and free'd. So it's not used anymore. */
 		ring->used_slots--;
 
-		if (meta->is_last_fragment) {
+		if (meta->is_last_fragment && !skip) {
 			/* This is the last scatter-gather
 			 * fragment of the frame. We are done. */
 			break;
 		}
 		slot = next_slot(ring, slot);
+		if (skip > 0)
+			--skip;
 	}
 	if (ring->stopped) {
 		B43_WARN_ON(free_slots(ring) < TX_SLOTS_PER_FRAME);
