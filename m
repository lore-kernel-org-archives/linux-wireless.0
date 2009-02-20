Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35862 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbZBTLZn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 06:25:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH v2] b43: Add slot count compiletime assertion
Date: Fri, 20 Feb 2009 12:24:52 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200902201224.52705.mb@bu3sch.de> (sfid-20090220_122551_616527_D9CD8013)
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

Coded with a brown paper bad on the head.
Please queue on top of the DMA optimizations.


Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2009-02-19 23:34:25.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2009-02-20 12:20:37.000000000 +0100
@@ -839,12 +839,15 @@ struct b43_dmaring *b43_setup_dmaring(st
 	spin_lock_init(&ring->lock);
 #ifdef CONFIG_B43_DEBUG
 	ring->last_injected_overflow = jiffies;
 #endif
 
 	if (for_tx) {
+		/* Assumption: B43_TXRING_SLOTS can be divided by TX_SLOTS_PER_FRAME */
+		BUILD_BUG_ON(B43_TXRING_SLOTS % TX_SLOTS_PER_FRAME != 0);
+
 		ring->txhdr_cache = kcalloc(ring->nr_slots / TX_SLOTS_PER_FRAME,
 					    b43_txhdr_size(dev),
 					    GFP_KERNEL);
 		if (!ring->txhdr_cache)
 			goto err_kfree_meta;
 


-- 
Greetings, Michael.
