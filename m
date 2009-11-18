Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57051 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758411AbZKRTyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 14:54:10 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: Enforce DMA descriptor memory constraints
Date: Wed, 18 Nov 2009 20:53:05 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <200911182053.05488.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enforce all device constraints on the descriptor memory region.

There are several constraints on the descriptor memory, as documented
in the specification. The current code does not enforce them and/or
incorrectly enforces them.

Those constraints are:
- The address limitations on 30/32bit engines, that also apply to
  the skbs.
- The 4k alignment requirement on 30/32bit engines.
- The 8k alignment requirement on 64bit engines.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

It's not entirely clear if any 64bit devices exist that _really_ need the 8k
alignment. However, I think it does not hurt much if we enforce it anyway.
The patch removes the always-set-GFP_DMA-on-64bit-devices hack. The combination of
the new enforcements should be enough to keep every device happy, including those
which needed the GFP_DMA hack. The new code will dynamically check if GFP_DMA is
required, instead of statically doing it all the time.
John, please queue for the next feature release. This patch still needs a fair
amount of testing. I think the best way to get it is to simply apply it. If this
causes any regressions, we can (temporary) revert it.

This also is a candidate for a b43legacy backport.


Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2009-11-18 19:09:38.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2009-11-18 19:21:17.000000000 +0100
@@ -383,44 +383,160 @@ static inline
 	}
 }
 
+/* Check if a DMA region fits the device constraints.
+ * Returns true, if the region is OK for usage with this device. */
+static inline bool b43_dma_address_ok(struct b43_dmaring *ring,
+				      dma_addr_t addr, size_t size)
+{
+	switch (ring->type) {
+	case B43_DMA_30BIT:
+		if ((u64)addr + size > (1ULL << 30))
+			return 0;
+		break;
+	case B43_DMA_32BIT:
+		if ((u64)addr + size > (1ULL << 32))
+			return 0;
+		break;
+	case B43_DMA_64BIT:
+		/* Currently we can't have addresses beyond
+		 * 64bit in the kernel. */
+		break;
+	}
+	return 1;
+}
+
+#define is_4k_aligned(addr)	(((u64)(addr) & 0x0FFFull) == 0)
+#define is_8k_aligned(addr)	(((u64)(addr) & 0x1FFFull) == 0)
+
+static void b43_unmap_and_free_ringmem(struct b43_dmaring *ring, void *base,
+				       dma_addr_t dmaaddr, size_t size)
+{
+	ssb_dma_unmap_single(ring->dev->dev, dmaaddr, size, DMA_TO_DEVICE);
+	free_pages((unsigned long)base, get_order(size));
+}
+
+static void * __b43_get_and_map_ringmem(struct b43_dmaring *ring,
+					dma_addr_t *dmaaddr, size_t size,
+					gfp_t gfp_flags)
+{
+	void *base;
+
+	base = (void *)__get_free_pages(gfp_flags, get_order(size));
+	if (!base)
+		return NULL;
+	memset(base, 0, size);
+	*dmaaddr = ssb_dma_map_single(ring->dev->dev, base, size,
+				      DMA_TO_DEVICE);
+	if (ssb_dma_mapping_error(ring->dev->dev, *dmaaddr)) {
+		free_pages((unsigned long)base, get_order(size));
+		return NULL;
+	}
+
+	return base;
+}
+
+static void * b43_get_and_map_ringmem(struct b43_dmaring *ring,
+				      dma_addr_t *dmaaddr, size_t size)
+{
+	void *base;
+
+	base = __b43_get_and_map_ringmem(ring, dmaaddr, size,
+					 GFP_KERNEL);
+	if (!base) {
+		b43err(ring->dev->wl, "Failed to allocate or map pages "
+		       "for DMA ringmemory\n");
+		return NULL;
+	}
+	if (!b43_dma_address_ok(ring, *dmaaddr, size)) {
+		/* The memory does not fit our device constraints.
+		 * Retry with GFP_DMA set to get lower memory. */
+		b43_unmap_and_free_ringmem(ring, base, *dmaaddr, size);
+		base = __b43_get_and_map_ringmem(ring, dmaaddr, size,
+						 GFP_KERNEL | GFP_DMA);
+		if (!base) {
+			b43err(ring->dev->wl, "Failed to allocate or map pages "
+			       "in the GFP_DMA region for DMA ringmemory\n");
+			return NULL;
+		}
+		if (!b43_dma_address_ok(ring, *dmaaddr, size)) {
+			b43_unmap_and_free_ringmem(ring, base, *dmaaddr, size);
+			b43err(ring->dev->wl, "Failed to allocate DMA "
+			       "ringmemory that fits device constraints\n");
+			return NULL;
+		}
+	}
+	/* We expect the memory to be 4k aligned, at least. */
+	if (B43_WARN_ON(!is_4k_aligned(*dmaaddr))) {
+		b43_unmap_and_free_ringmem(ring, base, *dmaaddr, size);
+		return NULL;
+	}
+
+	return base;
+}
+
 static int alloc_ringmemory(struct b43_dmaring *ring)
 {
-	gfp_t flags = GFP_KERNEL;
+	unsigned int required;
+	void *base;
+	dma_addr_t dmaaddr;
 
-	/* The specs call for 4K buffers for 30- and 32-bit DMA with 4K
-	 * alignment and 8K buffers for 64-bit DMA with 8K alignment. Testing
-	 * has shown that 4K is sufficient for the latter as long as the buffer
-	 * does not cross an 8K boundary.
-	 *
-	 * For unknown reasons - possibly a hardware error - the BCM4311 rev
-	 * 02, which uses 64-bit DMA, needs the ring buffer in very low memory,
-	 * which accounts for the GFP_DMA flag below.
-	 *
-	 * The flags here must match the flags in free_ringmemory below!
+	/* There are several requirements to the descriptor ring memory:
+	 * - The memory region needs to fit the address constraints for the
+	 *   device (same as for frame buffers).
+	 * - For 30/32bit DMA devices, the descriptor ring must be 4k aligned.
+	 * - For 64bit DMA devices, the descriptor ring must be 8k aligned.
 	 */
+
 	if (ring->type == B43_DMA_64BIT)
-		flags |= GFP_DMA;
-	ring->descbase = ssb_dma_alloc_consistent(ring->dev->dev,
-						  B43_DMA_RINGMEMSIZE,
-						  &(ring->dmabase), flags);
-	if (!ring->descbase) {
-		b43err(ring->dev->wl, "DMA ringmemory allocation failed\n");
+		required = ring->nr_slots * sizeof(struct b43_dmadesc64);
+	else
+		required = ring->nr_slots * sizeof(struct b43_dmadesc32);
+	if (B43_WARN_ON(required > 0x1000))
 		return -ENOMEM;
-	}
-	memset(ring->descbase, 0, B43_DMA_RINGMEMSIZE);
+
+	ring->alloc_descsize = 0x1000;
+	base = b43_get_and_map_ringmem(ring, &dmaaddr, ring->alloc_descsize);
+	if (!base)
+		return -ENOMEM;
+	ring->alloc_descbase = base;
+	ring->alloc_dmabase = dmaaddr;
+
+	if ((ring->type != B43_DMA_64BIT) || is_8k_aligned(dmaaddr)) {
+		/* We're on <=32bit DMA, or we already got 8k aligned memory.
+		 * That's all we need, so we're fine. */
+		ring->descbase = base;
+		ring->dmabase = dmaaddr;
+		return 0;
+	}
+	b43_unmap_and_free_ringmem(ring, base, dmaaddr, ring->alloc_descsize);
+
+	/* Ok, we failed at the 8k alignment requirement.
+	 * Try to force-align the memory region now. */
+	ring->alloc_descsize = 0x2000;
+	base = b43_get_and_map_ringmem(ring, &dmaaddr, ring->alloc_descsize);
+	if (!base)
+		return -ENOMEM;
+	ring->alloc_descbase = base;
+	ring->alloc_dmabase = dmaaddr;
+
+	if (is_8k_aligned(dmaaddr)) {
+		/* We're already 8k aligned. That Ok, too. */
+		ring->descbase = base;
+		ring->dmabase = dmaaddr;
+		return 0;
+	}
+	/* Force-align it to 8k */
+	ring->descbase = (void *)((u8 *)base + 0x1000);
+	ring->dmabase = dmaaddr + 0x1000;
+	B43_WARN_ON(!is_8k_aligned(ring->dmabase));
 
 	return 0;
 }
 
 static void free_ringmemory(struct b43_dmaring *ring)
 {
-	gfp_t flags = GFP_KERNEL;
-
-	if (ring->type == B43_DMA_64BIT)
-		flags |= GFP_DMA;
-
-	ssb_dma_free_consistent(ring->dev->dev, B43_DMA_RINGMEMSIZE,
-				ring->descbase, ring->dmabase, flags);
+	b43_unmap_and_free_ringmem(ring, ring->alloc_descbase,
+				   ring->alloc_dmabase, ring->alloc_descsize);
 }
 
 /* Reset the RX DMA channel */
@@ -530,29 +646,14 @@ static bool b43_dma_mapping_error(struct
 	if (unlikely(ssb_dma_mapping_error(ring->dev->dev, addr)))
 		return 1;
 
-	switch (ring->type) {
-	case B43_DMA_30BIT:
-		if ((u64)addr + buffersize > (1ULL << 30))
-			goto address_error;
-		break;
-	case B43_DMA_32BIT:
-		if ((u64)addr + buffersize > (1ULL << 32))
-			goto address_error;
-		break;
-	case B43_DMA_64BIT:
-		/* Currently we can't have addresses beyond
-		 * 64bit in the kernel. */
-		break;
+	if (!b43_dma_address_ok(ring, addr, buffersize)) {
+		/* We can't support this address. Unmap it again. */
+		unmap_descbuffer(ring, addr, buffersize, dma_to_device);
+		return 1;
 	}
 
 	/* The address is OK. */
 	return 0;
-
-address_error:
-	/* We can't support this address. Unmap it again. */
-	unmap_descbuffer(ring, addr, buffersize, dma_to_device);
-
-	return 1;
 }
 
 static bool b43_rx_buffer_is_poisoned(struct b43_dmaring *ring, struct sk_buff *skb)
@@ -614,6 +715,9 @@ static int setup_rx_descbuffer(struct b4
 	meta->dmaaddr = dmaaddr;
 	ring->ops->fill_descriptor(ring, desc, dmaaddr,
 				   ring->rx_buffersize, 0, 0, 0);
+	ssb_dma_sync_single_for_device(ring->dev->dev,
+				       ring->alloc_dmabase,
+				       ring->alloc_descsize, DMA_TO_DEVICE);
 
 	return 0;
 }
@@ -1246,6 +1350,9 @@ static int dma_tx_fragment(struct b43_dm
 	}
 	/* Now transfer the whole frame. */
 	wmb();
+	ssb_dma_sync_single_for_device(ring->dev->dev,
+				       ring->alloc_dmabase,
+				       ring->alloc_descsize, DMA_TO_DEVICE);
 	ops->poke_tx(ring, next_slot(ring, slot));
 	return 0;
 
Index: wireless-testing/drivers/net/wireless/b43/dma.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.h	2009-11-18 19:09:38.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.h	2009-11-18 19:29:49.000000000 +0100
@@ -157,7 +157,6 @@ struct b43_dmadesc_generic {
 } __attribute__ ((__packed__));
 
 /* Misc DMA constants */
-#define B43_DMA_RINGMEMSIZE		PAGE_SIZE
 #define B43_DMA0_RX_FRAMEOFFSET		30
 
 /* DMA engine tuning knobs */
@@ -243,6 +242,12 @@ struct b43_dmaring {
 	/* The QOS priority assigned to this ring. Only used for TX rings.
 	 * This is the mac80211 "queue" value. */
 	u8 queue_prio;
+	/* Pointers and size of the originally allocated and mapped memory
+	 * region for the descriptor ring. */
+	void *alloc_descbase;
+	dma_addr_t alloc_dmabase;
+	unsigned int alloc_descsize;
+	/* Pointer to our wireless device. */
 	struct b43_wldev *dev;
 #ifdef CONFIG_B43_DEBUG
 	/* Maximum number of used slots. */

-- 
Greetings, Michael.
