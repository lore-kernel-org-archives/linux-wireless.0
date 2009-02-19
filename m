Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40603 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbZBSWki (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 17:40:38 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix DMA buffer size handling
Date: Thu, 19 Feb 2009 23:39:26 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200902192339.27295.mb@bu3sch.de> (sfid-20090219_234043_165053_2C60161E)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes hidden bugs in the size handling of the DMA buffers.
This sets the RX buffer size to the theoretical max packet size and
fixes passing of the size values to the device (must not subtract the header offset).

These bugs are hidden and don't actually trigger due to the magic +100
offset for the buffer size.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, no need to push this as bugfix. Just push it with the next round of
features. This bug has always been there and it's hidden. So it doesn't
trigger for anybody.


Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2009-01-25 15:29:55.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2009-02-19 22:30:16.000000000 +0100
@@ -71,14 +71,13 @@ static void op32_fill_descriptor(struct 
 	B43_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
 
 	addr = (u32) (dmaaddr & ~SSB_DMA_TRANSLATION_MASK);
 	addrext = (u32) (dmaaddr & SSB_DMA_TRANSLATION_MASK)
 	    >> SSB_DMA_TRANSLATION_SHIFT;
 	addr |= ssb_dma_translation(ring->dev->dev);
-	ctl = (bufsize - ring->frameoffset)
-	    & B43_DMA32_DCTL_BYTECNT;
+	ctl = bufsize & B43_DMA32_DCTL_BYTECNT;
 	if (slot == ring->nr_slots - 1)
 		ctl |= B43_DMA32_DCTL_DTABLEEND;
 	if (start)
 		ctl |= B43_DMA32_DCTL_FRAMESTART;
 	if (end)
 		ctl |= B43_DMA32_DCTL_FRAMEEND;
@@ -174,14 +173,13 @@ static void op64_fill_descriptor(struct 
 	if (start)
 		ctl0 |= B43_DMA64_DCTL0_FRAMESTART;
 	if (end)
 		ctl0 |= B43_DMA64_DCTL0_FRAMEEND;
 	if (irq)
 		ctl0 |= B43_DMA64_DCTL0_IRQ;
-	ctl1 |= (bufsize - ring->frameoffset)
-	    & B43_DMA64_DCTL1_BYTECNT;
+	ctl1 |= bufsize & B43_DMA64_DCTL1_BYTECNT;
 	ctl1 |= (addrext << B43_DMA64_DCTL1_ADDREXT_SHIFT)
 	    & B43_DMA64_DCTL1_ADDREXT_MASK;
 
 	desc->dma64.control0 = cpu_to_le32(ctl0);
 	desc->dma64.control1 = cpu_to_le32(ctl1);
 	desc->dma64.address_low = cpu_to_le32(addrlo);
@@ -827,15 +825,12 @@ struct b43_dmaring *b43_setup_dmaring(st
 		ring->tx = 1;
 		ring->current_slot = -1;
 	} else {
 		if (ring->index == 0) {
 			ring->rx_buffersize = B43_DMA0_RX_BUFFERSIZE;
 			ring->frameoffset = B43_DMA0_RX_FRAMEOFFSET;
-		} else if (ring->index == 3) {
-			ring->rx_buffersize = B43_DMA3_RX_BUFFERSIZE;
-			ring->frameoffset = B43_DMA3_RX_FRAMEOFFSET;
 		} else
 			B43_WARN_ON(1);
 	}
 	spin_lock_init(&ring->lock);
 #ifdef CONFIG_B43_DEBUG
 	ring->last_injected_overflow = jiffies;
Index: wireless-testing/drivers/net/wireless/b43/dma.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.h	2008-05-23 23:41:06.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/dma.h	2009-02-19 22:32:21.000000000 +0100
@@ -1,17 +1,15 @@
 #ifndef B43_DMA_H_
 #define B43_DMA_H_
 
-#include <linux/list.h>
+#include <linux/ieee80211.h>
 #include <linux/spinlock.h>
-#include <linux/workqueue.h>
-#include <linux/linkage.h>
-#include <asm/atomic.h>
 
 #include "b43.h"
 
+
 /* DMA-Interrupt reasons. */
 #define B43_DMAIRQ_FATALMASK	((1 << 10) | (1 << 11) | (1 << 12) \
 					 | (1 << 14) | (1 << 15))
 #define B43_DMAIRQ_NONFATALMASK	(1 << 13)
 #define B43_DMAIRQ_RX_DONE		(1 << 16)
 
@@ -158,20 +156,19 @@ struct b43_dmadesc_generic {
 		struct b43_dmadesc64 dma64;
 	} __attribute__ ((__packed__));
 } __attribute__ ((__packed__));
 
 /* Misc DMA constants */
 #define B43_DMA_RINGMEMSIZE		PAGE_SIZE
-#define B43_DMA0_RX_FRAMEOFFSET	30
-#define B43_DMA3_RX_FRAMEOFFSET	0
+#define B43_DMA0_RX_FRAMEOFFSET		30
 
 /* DMA engine tuning knobs */
 #define B43_TXRING_SLOTS		128
 #define B43_RXRING_SLOTS		64
-#define B43_DMA0_RX_BUFFERSIZE	(2304 + 100)
-#define B43_DMA3_RX_BUFFERSIZE	16
+#define B43_DMA0_RX_BUFFERSIZE		IEEE80211_MAX_FRAME_LEN
+
 
 struct sk_buff;
 struct b43_private;
 struct b43_txstatus;
 
 struct b43_dmadesc_meta {

-- 
Greetings, Michael.
