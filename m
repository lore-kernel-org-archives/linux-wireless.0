Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45413 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937AbZBSXKZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 18:10:25 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add slot count compiletime assertion
Date: Fri, 20 Feb 2009 00:09:42 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200902200009.42967.mb@bu3sch.de> (sfid-20090220_001029_537724_4F474F11)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a compiletime assertion for a recently introduced
assumption on the slot counts.
The tx header cache handling code assumes that the TX slot count
can be divided evenly by the number of TX slots per frame.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Please queue on top of the DMA optimizations.


Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2009-02-19 23:34:25.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2009-02-20 00:03:30.000000000 +0100
@@ -839,12 +839,16 @@ struct b43_dmaring *b43_setup_dmaring(st
 	spin_lock_init(&ring->lock);
 #ifdef CONFIG_B43_DEBUG
 	ring->last_injected_overflow = jiffies;
 #endif
 
 	if (for_tx) {
+		/* Assumption: B43_TXRING_SLOTS can be divided by TX_SLOTS_PER_FRAME */
+		BUILD_BUG_ON((B43_TXRING_SLOTS * 1000000) / TX_SLOTS_PER_FRAME !=
+			     (B43_TXRING_SLOTS / TX_SLOTS_PER_FRAME) * 1000000);
+
 		ring->txhdr_cache = kcalloc(ring->nr_slots / TX_SLOTS_PER_FRAME,
 					    b43_txhdr_size(dev),
 					    GFP_KERNEL);
 		if (!ring->txhdr_cache)
 			goto err_kfree_meta;
 

-- 
Greetings, Michael.
