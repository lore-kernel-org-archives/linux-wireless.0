Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:58168 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3DWTpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 15:45:21 -0400
Received: by mail-la0-f51.google.com with SMTP id fh20so889668lab.24
        for <linux-wireless@vger.kernel.org>; Tue, 23 Apr 2013 12:45:19 -0700 (PDT)
Date: Tue, 23 Apr 2013 21:45:11 +0200 (CEST)
From: Thommy Jakobsson <thommyj@gmail.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	m@bues.ch, piotras@gmail.com, Larry.Finger@lwfinger.net
Subject: [PATCH] B43: Handle DMA RX descriptor underrun
Message-ID: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net> (sfid-20130423_235839_935399_84D79866)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thommy Jakobsson <thommyj@gmail.com>

Add handling of rx descriptor underflow. This fixes a fault that could
happen on slow machines, where data is received faster than the CPU can
handle. In such a case the device will use up all rx descriptors and
refuse to send any more data before confirming that it is ok. This
patch enables necessary interrupt to discover such a situation and will
handle them by dropping everything in the ring buffer.

Reviewed-by: Michael Buesch <m@bues.ch>
Signed-off-by: Thommy Jakobsson <thommyj@gmail.com>
Cc: stable <stable@vger.kernel.org>
---
Hi John,

patch for fixing problems seen on slow hardware and b43. Discussed at b43 
mailinglist and openwrt ticket system 
(https://dev.openwrt.org/ticket/7552)

BR,
Thommy Jakobsson
---
 drivers/net/wireless/b43/dma.c  |   19 +++++++++++++++++
 drivers/net/wireless/b43/dma.h  |    4 +++-
 drivers/net/wireless/b43/main.c |   43 ++++++++++++++++-----------------------
 3 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 1221469..ee3d640 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1733,6 +1733,25 @@ drop_recycle_buffer:
 	sync_descbuffer_for_device(ring, dmaaddr, ring->rx_buffersize);
 }
 
+void b43_dma_handle_rx_overflow(struct b43_dmaring *ring)
+{
+	int current_slot, previous_slot;
+
+	B43_WARN_ON(ring->tx);
+
+	/* Device has filled all buffers, drop all packets and let TCP
+	 * decrease speed.
+	 * Decrement RX index by one will let the device to see all slots
+	 * as free again
+	 */
+	/*
+	*TODO: How to increase rx_drop in mac80211?
+	*/
+	current_slot = ring->ops->get_current_rxslot(ring);
+	previous_slot = prev_slot(ring, current_slot);
+	ring->ops->set_current_rxslot(ring, previous_slot);
+}
+
 void b43_dma_rx(struct b43_dmaring *ring)
 {
 	const struct b43_dma_ops *ops = ring->ops;
diff --git a/drivers/net/wireless/b43/dma.h b/drivers/net/wireless/b43/dma.h
index 9fdd198..df8c8cd 100644
--- a/drivers/net/wireless/b43/dma.h
+++ b/drivers/net/wireless/b43/dma.h
@@ -9,7 +9,7 @@
 /* DMA-Interrupt reasons. */
 #define B43_DMAIRQ_FATALMASK	((1 << 10) | (1 << 11) | (1 << 12) \
 					 | (1 << 14) | (1 << 15))
-#define B43_DMAIRQ_NONFATALMASK	(1 << 13)
+#define B43_DMAIRQ_RDESC_UFLOW		(1 << 13)
 #define B43_DMAIRQ_RX_DONE		(1 << 16)
 
 /*** 32-bit DMA Engine. ***/
@@ -295,6 +295,8 @@ int b43_dma_tx(struct b43_wldev *dev,
 void b43_dma_handle_txstatus(struct b43_wldev *dev,
 			     const struct b43_txstatus *status);
 
+void b43_dma_handle_rx_overflow(struct b43_dmaring *ring);
+
 void b43_dma_rx(struct b43_dmaring *ring);
 
 void b43_dma_direct_fifo_rx(struct b43_wldev *dev,
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index d377f77..6dd07e2 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1902,30 +1902,18 @@ static void b43_do_interrupt_thread(struct b43_wldev *dev)
 		}
 	}
 
-	if (unlikely(merged_dma_reason & (B43_DMAIRQ_FATALMASK |
-					  B43_DMAIRQ_NONFATALMASK))) {
-		if (merged_dma_reason & B43_DMAIRQ_FATALMASK) {
-			b43err(dev->wl, "Fatal DMA error: "
-			       "0x%08X, 0x%08X, 0x%08X, "
-			       "0x%08X, 0x%08X, 0x%08X\n",
-			       dma_reason[0], dma_reason[1],
-			       dma_reason[2], dma_reason[3],
-			       dma_reason[4], dma_reason[5]);
-			b43err(dev->wl, "This device does not support DMA "
+	if (unlikely(merged_dma_reason & (B43_DMAIRQ_FATALMASK))) {
+		b43err(dev->wl,
+			"Fatal DMA error: 0x%08X, 0x%08X, 0x%08X, 0x%08X, 0x%08X, 0x%08X\n",
+			dma_reason[0], dma_reason[1],
+			dma_reason[2], dma_reason[3],
+			dma_reason[4], dma_reason[5]);
+		b43err(dev->wl, "This device does not support DMA "
 			       "on your system. It will now be switched to PIO.\n");
-			/* Fall back to PIO transfers if we get fatal DMA errors! */
-			dev->use_pio = true;
-			b43_controller_restart(dev, "DMA error");
-			return;
-		}
-		if (merged_dma_reason & B43_DMAIRQ_NONFATALMASK) {
-			b43err(dev->wl, "DMA error: "
-			       "0x%08X, 0x%08X, 0x%08X, "
-			       "0x%08X, 0x%08X, 0x%08X\n",
-			       dma_reason[0], dma_reason[1],
-			       dma_reason[2], dma_reason[3],
-			       dma_reason[4], dma_reason[5]);
-		}
+		/* Fall back to PIO transfers if we get fatal DMA errors! */
+		dev->use_pio = true;
+		b43_controller_restart(dev, "DMA error");
+		return;
 	}
 
 	if (unlikely(reason & B43_IRQ_UCODE_DEBUG))
@@ -1944,6 +1932,11 @@ static void b43_do_interrupt_thread(struct b43_wldev *dev)
 		handle_irq_noise(dev);
 
 	/* Check the DMA reason registers for received data. */
+	if (dma_reason[0] & B43_DMAIRQ_RDESC_UFLOW) {
+		if (B43_DEBUG)
+			b43warn(dev->wl, "RX descriptor underrun\n");
+		b43_dma_handle_rx_overflow(dev->dma.rx_ring);
+	}
 	if (dma_reason[0] & B43_DMAIRQ_RX_DONE) {
 		if (b43_using_pio_transfers(dev))
 			b43_pio_rx(dev->pio.rx_queue);
@@ -2001,7 +1994,7 @@ static irqreturn_t b43_do_interrupt(struct b43_wldev *dev)
 		return IRQ_NONE;
 
 	dev->dma_reason[0] = b43_read32(dev, B43_MMIO_DMA0_REASON)
-	    & 0x0001DC00;
+	    & 0x0001FC00;
 	dev->dma_reason[1] = b43_read32(dev, B43_MMIO_DMA1_REASON)
 	    & 0x0000DC00;
 	dev->dma_reason[2] = b43_read32(dev, B43_MMIO_DMA2_REASON)
@@ -3130,7 +3123,7 @@ static int b43_chip_init(struct b43_wldev *dev)
 		b43_write32(dev, 0x018C, 0x02000000);
 	}
 	b43_write32(dev, B43_MMIO_GEN_IRQ_REASON, 0x00004000);
-	b43_write32(dev, B43_MMIO_DMA0_IRQ_MASK, 0x0001DC00);
+	b43_write32(dev, B43_MMIO_DMA0_IRQ_MASK, 0x0001FC00);
 	b43_write32(dev, B43_MMIO_DMA1_IRQ_MASK, 0x0000DC00);
 	b43_write32(dev, B43_MMIO_DMA2_IRQ_MASK, 0x0000DC00);
 	b43_write32(dev, B43_MMIO_DMA3_IRQ_MASK, 0x0001DC00);
-- 
1.7.9.5

