Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:38930 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYBELxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 06:53:55 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix DMA for 30/32-bit DMA engines
Date: Tue, 5 Feb 2008 12:50:41 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Matti Viljanen <viljanen.matti@gmail.com>
MIME-Version: 1.0
Message-Id: <200802051250.42295.mb@bu3sch.de> (sfid-20080205_115408_402150_8042A550)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This checks if the DMA address is bigger than what the controller can manage.
It will reallocate the buffers in the GFP_DMA zone in that case.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is a fix for 2.6.25.
Stefano, this has to be ported to b43legacy.

Index: wireless-2.6/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/dma.c	2008-01-25 00:39:08.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/dma.c	2008-02-05 12:43:42.000000000 +0100
@@ -334,13 +334,13 @@ static inline int txring_to_priority(str
 	index = ring->index;
 	if (B43_WARN_ON(index >= ARRAY_SIZE(idx_to_prio)))
 		index = 0;
 	return idx_to_prio[index];
 }
 
-u16 b43_dmacontroller_base(int dma64bit, int controller_idx)
+static u16 b43_dmacontroller_base(enum b43_dmatype type, int controller_idx)
 {
 	static const u16 map64[] = {
 		B43_MMIO_DMA64_BASE0,
 		B43_MMIO_DMA64_BASE1,
 		B43_MMIO_DMA64_BASE2,
 		B43_MMIO_DMA64_BASE3,
@@ -353,13 +353,13 @@ u16 b43_dmacontroller_base(int dma64bit,
 		B43_MMIO_DMA32_BASE2,
 		B43_MMIO_DMA32_BASE3,
 		B43_MMIO_DMA32_BASE4,
 		B43_MMIO_DMA32_BASE5,
 	};
 
-	if (dma64bit) {
+	if (type == B43_DMA_64BIT) {
 		B43_WARN_ON(!(controller_idx >= 0 &&
 			      controller_idx < ARRAY_SIZE(map64)));
 		return map64[controller_idx];
 	}
 	B43_WARN_ON(!(controller_idx >= 0 &&
 		      controller_idx < ARRAY_SIZE(map32)));
@@ -434,13 +434,13 @@ static int alloc_ringmemory(struct b43_d
 	 * does not cross an 8K boundary.
 	 *
 	 * For unknown reasons - possibly a hardware error - the BCM4311 rev
 	 * 02, which uses 64-bit DMA, needs the ring buffer in very low memory,
 	 * which accounts for the GFP_DMA flag below.
 	 */
-	if (ring->dma64)
+	if (ring->type == B43_DMA_64BIT)
 		flags |= GFP_DMA;
 	ring->descbase = dma_alloc_coherent(dev, B43_DMA_RINGMEMSIZE,
 					    &(ring->dmabase), flags);
 	if (!ring->descbase) {
 		b43err(ring->dev->wl, "DMA ringmemory allocation failed\n");
 		return -ENOMEM;
@@ -456,26 +456,28 @@ static void free_ringmemory(struct b43_d
 
 	dma_free_coherent(dev, B43_DMA_RINGMEMSIZE,
 			  ring->descbase, ring->dmabase);
 }
 
 /* Reset the RX DMA channel */
-int b43_dmacontroller_rx_reset(struct b43_wldev *dev, u16 mmio_base, int dma64)
+static int b43_dmacontroller_rx_reset(struct b43_wldev *dev, u16 mmio_base,
+				      enum b43_dmatype type)
 {
 	int i;
 	u32 value;
 	u16 offset;
 
 	might_sleep();
 
-	offset = dma64 ? B43_DMA64_RXCTL : B43_DMA32_RXCTL;
+	offset = (type == B43_DMA_64BIT) ? B43_DMA64_RXCTL : B43_DMA32_RXCTL;
 	b43_write32(dev, mmio_base + offset, 0);
 	for (i = 0; i < 10; i++) {
-		offset = dma64 ? B43_DMA64_RXSTATUS : B43_DMA32_RXSTATUS;
+		offset = (type == B43_DMA_64BIT) ? B43_DMA64_RXSTATUS :
+						   B43_DMA32_RXSTATUS;
 		value = b43_read32(dev, mmio_base + offset);
-		if (dma64) {
+		if (type == B43_DMA_64BIT) {
 			value &= B43_DMA64_RXSTAT;
 			if (value == B43_DMA64_RXSTAT_DISABLED) {
 				i = -1;
 				break;
 			}
 		} else {
@@ -493,24 +495,26 @@ int b43_dmacontroller_rx_reset(struct b4
 	}
 
 	return 0;
 }
 
 /* Reset the TX DMA channel */
-int b43_dmacontroller_tx_reset(struct b43_wldev *dev, u16 mmio_base, int dma64)
+static int b43_dmacontroller_tx_reset(struct b43_wldev *dev, u16 mmio_base,
+				      enum b43_dmatype type)
 {
 	int i;
 	u32 value;
 	u16 offset;
 
 	might_sleep();
 
 	for (i = 0; i < 10; i++) {
-		offset = dma64 ? B43_DMA64_TXSTATUS : B43_DMA32_TXSTATUS;
+		offset = (type == B43_DMA_64BIT) ? B43_DMA64_TXSTATUS :
+						   B43_DMA32_TXSTATUS;
 		value = b43_read32(dev, mmio_base + offset);
-		if (dma64) {
+		if (type == B43_DMA_64BIT) {
 			value &= B43_DMA64_TXSTAT;
 			if (value == B43_DMA64_TXSTAT_DISABLED ||
 			    value == B43_DMA64_TXSTAT_IDLEWAIT ||
 			    value == B43_DMA64_TXSTAT_STOPPED)
 				break;
 		} else {
@@ -519,18 +523,19 @@ int b43_dmacontroller_tx_reset(struct b4
 			    value == B43_DMA32_TXSTAT_IDLEWAIT ||
 			    value == B43_DMA32_TXSTAT_STOPPED)
 				break;
 		}
 		msleep(1);
 	}
-	offset = dma64 ? B43_DMA64_TXCTL : B43_DMA32_TXCTL;
+	offset = (type == B43_DMA_64BIT) ? B43_DMA64_TXCTL : B43_DMA32_TXCTL;
 	b43_write32(dev, mmio_base + offset, 0);
 	for (i = 0; i < 10; i++) {
-		offset = dma64 ? B43_DMA64_TXSTATUS : B43_DMA32_TXSTATUS;
+		offset = (type == B43_DMA_64BIT) ? B43_DMA64_TXSTATUS :
+						   B43_DMA32_TXSTATUS;
 		value = b43_read32(dev, mmio_base + offset);
-		if (dma64) {
+		if (type == B43_DMA_64BIT) {
 			value &= B43_DMA64_TXSTAT;
 			if (value == B43_DMA64_TXSTAT_DISABLED) {
 				i = -1;
 				break;
 			}
 		} else {
@@ -549,12 +554,39 @@ int b43_dmacontroller_tx_reset(struct b4
 	/* ensure the reset is completed. */
 	msleep(1);
 
 	return 0;
 }
 
+/* Check if a DMA mapping address is invalid. */
+static bool b43_dma_mapping_error(struct b43_dmaring *ring,
+				  dma_addr_t addr,
+				  size_t buffersize)
+{
+	if (unlikely(dma_mapping_error(addr)))
+		return 1;
+
+	switch (ring->type) {
+	case B43_DMA_30BIT:
+		if ((u64)addr + buffersize > (1ULL << 30))
+			return 1;
+		break;
+	case B43_DMA_32BIT:
+		if ((u64)addr + buffersize > (1ULL << 32))
+			return 1;
+		break;
+	case B43_DMA_64BIT:
+		/* Currently we can't have addresses beyond
+		 * 64bit in the kernel. */
+		break;
+	}
+
+	/* The address is OK. */
+	return 0;
+}
+
 static int setup_rx_descbuffer(struct b43_dmaring *ring,
 			       struct b43_dmadesc_generic *desc,
 			       struct b43_dmadesc_meta *meta, gfp_t gfp_flags)
 {
 	struct b43_rxhdr_fw4 *rxhdr;
 	struct b43_hwtxstatus *txstat;
@@ -564,26 +596,26 @@ static int setup_rx_descbuffer(struct b4
 	B43_WARN_ON(ring->tx);
 
 	skb = __dev_alloc_skb(ring->rx_buffersize, gfp_flags);
 	if (unlikely(!skb))
 		return -ENOMEM;
 	dmaaddr = map_descbuffer(ring, skb->data, ring->rx_buffersize, 0);
-	if (dma_mapping_error(dmaaddr)) {
+	if (b43_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize)) {
 		/* ugh. try to realloc in zone_dma */
 		gfp_flags |= GFP_DMA;
 
 		dev_kfree_skb_any(skb);
 
 		skb = __dev_alloc_skb(ring->rx_buffersize, gfp_flags);
 		if (unlikely(!skb))
 			return -ENOMEM;
 		dmaaddr = map_descbuffer(ring, skb->data,
 					 ring->rx_buffersize, 0);
 	}
 
-	if (dma_mapping_error(dmaaddr)) {
+	if (b43_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize)) {
 		dev_kfree_skb_any(skb);
 		return -EIO;
 	}
 
 	meta->skb = skb;
 	meta->dmaaddr = dmaaddr;
@@ -642,13 +674,13 @@ static int dmacontroller_setup(struct b4
 	int err = 0;
 	u32 value;
 	u32 addrext;
 	u32 trans = ssb_dma_translation(ring->dev->dev);
 
 	if (ring->tx) {
-		if (ring->dma64) {
+		if (ring->type == B43_DMA_64BIT) {
 			u64 ringbase = (u64) (ring->dmabase);
 
 			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
 			    >> SSB_DMA_TRANSLATION_SHIFT;
 			value = B43_DMA64_TXENABLE;
 			value |= (addrext << B43_DMA64_TXADDREXT_SHIFT)
@@ -674,13 +706,13 @@ static int dmacontroller_setup(struct b4
 				      | trans);
 		}
 	} else {
 		err = alloc_initial_descbuffers(ring);
 		if (err)
 			goto out;
-		if (ring->dma64) {
+		if (ring->type == B43_DMA_64BIT) {
 			u64 ringbase = (u64) (ring->dmabase);
 
 			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
 			    >> SSB_DMA_TRANSLATION_SHIFT;
 			value = (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT);
 			value |= B43_DMA64_RXENABLE;
@@ -719,22 +751,22 @@ out:
 
 /* Shutdown the DMA controller. */
 static void dmacontroller_cleanup(struct b43_dmaring *ring)
 {
 	if (ring->tx) {
 		b43_dmacontroller_tx_reset(ring->dev, ring->mmio_base,
-					   ring->dma64);
-		if (ring->dma64) {
+					   ring->type);
+		if (ring->type == B43_DMA_64BIT) {
 			b43_dma_write(ring, B43_DMA64_TXRINGLO, 0);
 			b43_dma_write(ring, B43_DMA64_TXRINGHI, 0);
 		} else
 			b43_dma_write(ring, B43_DMA32_TXRING, 0);
 	} else {
 		b43_dmacontroller_rx_reset(ring->dev, ring->mmio_base,
-					   ring->dma64);
-		if (ring->dma64) {
+					   ring->type);
+		if (ring->type == B43_DMA_64BIT) {
 			b43_dma_write(ring, B43_DMA64_RXRINGLO, 0);
 			b43_dma_write(ring, B43_DMA64_RXRINGHI, 0);
 		} else
 			b43_dma_write(ring, B43_DMA32_RXRING, 0);
 	}
 }
@@ -783,22 +815,24 @@ static u64 supported_dma_mask(struct b43
 }
 
 /* Main initialization function. */
 static
 struct b43_dmaring *b43_setup_dmaring(struct b43_wldev *dev,
 				      int controller_index,
-				      int for_tx, int dma64)
+				      int for_tx,
+				      enum b43_dmatype type)
 {
 	struct b43_dmaring *ring;
 	int err;
 	int nr_slots;
 	dma_addr_t dma_test;
 
 	ring = kzalloc(sizeof(*ring), GFP_KERNEL);
 	if (!ring)
 		goto out;
+	ring->type = type;
 
 	nr_slots = B43_RXRING_SLOTS;
 	if (for_tx)
 		nr_slots = B43_TXRING_SLOTS;
 
 	ring->meta = kcalloc(nr_slots, sizeof(struct b43_dmadesc_meta),
@@ -815,13 +849,13 @@ struct b43_dmaring *b43_setup_dmaring(st
 		/* test for ability to dma to txhdr_cache */
 		dma_test = dma_map_single(dev->dev->dev,
 					  ring->txhdr_cache,
 					  b43_txhdr_size(dev),
 					  DMA_TO_DEVICE);
 
-		if (dma_mapping_error(dma_test)) {
+		if (b43_dma_mapping_error(ring, dma_test, b43_txhdr_size(dev))) {
 			/* ugh realloc */
 			kfree(ring->txhdr_cache);
 			ring->txhdr_cache = kcalloc(nr_slots,
 						    b43_txhdr_size(dev),
 						    GFP_KERNEL | GFP_DMA);
 			if (!ring->txhdr_cache)
@@ -829,27 +863,27 @@ struct b43_dmaring *b43_setup_dmaring(st
 
 			dma_test = dma_map_single(dev->dev->dev,
 						  ring->txhdr_cache,
 						  b43_txhdr_size(dev),
 						  DMA_TO_DEVICE);
 
-			if (dma_mapping_error(dma_test))
+			if (b43_dma_mapping_error(ring, dma_test,
+						  b43_txhdr_size(dev)))
 				goto err_kfree_txhdr_cache;
 		}
 
 		dma_unmap_single(dev->dev->dev,
 				 dma_test, b43_txhdr_size(dev),
 				 DMA_TO_DEVICE);
 	}
 
 	ring->dev = dev;
 	ring->nr_slots = nr_slots;
-	ring->mmio_base = b43_dmacontroller_base(dma64, controller_index);
+	ring->mmio_base = b43_dmacontroller_base(type, controller_index);
 	ring->index = controller_index;
-	ring->dma64 = !!dma64;
-	if (dma64)
+	if (type == B43_DMA_64BIT)
 		ring->ops = &dma64_ops;
 	else
 		ring->ops = &dma32_ops;
 	if (for_tx) {
 		ring->tx = 1;
 		ring->current_slot = -1;
@@ -893,14 +927,14 @@ struct b43_dmaring *b43_setup_dmaring(st
 /* Main cleanup function. */
 static void b43_destroy_dmaring(struct b43_dmaring *ring)
 {
 	if (!ring)
 		return;
 
-	b43dbg(ring->dev->wl, "DMA-%s 0x%04X (%s) max used slots: %d/%d\n",
-	       (ring->dma64) ? "64" : "32",
+	b43dbg(ring->dev->wl, "DMA-%u 0x%04X (%s) max used slots: %d/%d\n",
+	       (unsigned int)(ring->type),
 	       ring->mmio_base,
 	       (ring->tx) ? "TX" : "RX", ring->max_used_slots, ring->nr_slots);
 	/* Device IRQs are disabled prior entering this function,
 	 * so no need to take care of concurrency with rx handler stuff.
 	 */
 	dmacontroller_cleanup(ring);
@@ -938,75 +972,84 @@ void b43_dma_free(struct b43_wldev *dev)
 int b43_dma_init(struct b43_wldev *dev)
 {
 	struct b43_dma *dma = &dev->dma;
 	struct b43_dmaring *ring;
 	int err;
 	u64 dmamask;
-	int dma64 = 0;
+	enum b43_dmatype type;
 
 	dmamask = supported_dma_mask(dev);
-	if (dmamask == DMA_64BIT_MASK)
-		dma64 = 1;
-
+	switch (dmamask) {
+	default:
+		B43_WARN_ON(1);
+	case DMA_30BIT_MASK:
+		type = B43_DMA_30BIT;
+		break;
+	case DMA_32BIT_MASK:
+		type = B43_DMA_32BIT;
+		break;
+	case DMA_64BIT_MASK:
+		type = B43_DMA_64BIT;
+		break;
+	}
 	err = ssb_dma_set_mask(dev->dev, dmamask);
 	if (err) {
 		b43err(dev->wl, "The machine/kernel does not support "
 		       "the required DMA mask (0x%08X%08X)\n",
 		       (unsigned int)((dmamask & 0xFFFFFFFF00000000ULL) >> 32),
 		       (unsigned int)(dmamask & 0x00000000FFFFFFFFULL));
 		return -EOPNOTSUPP;
 	}
 
 	err = -ENOMEM;
 	/* setup TX DMA channels. */
-	ring = b43_setup_dmaring(dev, 0, 1, dma64);
+	ring = b43_setup_dmaring(dev, 0, 1, type);
 	if (!ring)
 		goto out;
 	dma->tx_ring0 = ring;
 
-	ring = b43_setup_dmaring(dev, 1, 1, dma64);
+	ring = b43_setup_dmaring(dev, 1, 1, type);
 	if (!ring)
 		goto err_destroy_tx0;
 	dma->tx_ring1 = ring;
 
-	ring = b43_setup_dmaring(dev, 2, 1, dma64);
+	ring = b43_setup_dmaring(dev, 2, 1, type);
 	if (!ring)
 		goto err_destroy_tx1;
 	dma->tx_ring2 = ring;
 
-	ring = b43_setup_dmaring(dev, 3, 1, dma64);
+	ring = b43_setup_dmaring(dev, 3, 1, type);
 	if (!ring)
 		goto err_destroy_tx2;
 	dma->tx_ring3 = ring;
 
-	ring = b43_setup_dmaring(dev, 4, 1, dma64);
+	ring = b43_setup_dmaring(dev, 4, 1, type);
 	if (!ring)
 		goto err_destroy_tx3;
 	dma->tx_ring4 = ring;
 
-	ring = b43_setup_dmaring(dev, 5, 1, dma64);
+	ring = b43_setup_dmaring(dev, 5, 1, type);
 	if (!ring)
 		goto err_destroy_tx4;
 	dma->tx_ring5 = ring;
 
 	/* setup RX DMA channels. */
-	ring = b43_setup_dmaring(dev, 0, 0, dma64);
+	ring = b43_setup_dmaring(dev, 0, 0, type);
 	if (!ring)
 		goto err_destroy_tx5;
 	dma->rx_ring0 = ring;
 
 	if (dev->dev->id.revision < 5) {
-		ring = b43_setup_dmaring(dev, 3, 0, dma64);
+		ring = b43_setup_dmaring(dev, 3, 0, type);
 		if (!ring)
 			goto err_destroy_rx0;
 		dma->rx_ring3 = ring;
 	}
 
-	b43dbg(dev->wl, "%d-bit DMA initialized\n",
-	       (dmamask == DMA_64BIT_MASK) ? 64 :
-	       (dmamask == DMA_32BIT_MASK) ? 32 : 30);
+	b43dbg(dev->wl, "%u-bit DMA initialized\n",
+	       (unsigned int)type);
 	err = 0;
       out:
 	return err;
 
       err_destroy_rx0:
 	b43_destroy_dmaring(dma->rx_ring0);
@@ -1143,13 +1186,13 @@ static int dma_tx_fragment(struct b43_dm
 		ring->used_slots = old_used_slots;
 		return err;
 	}
 
 	meta_hdr->dmaaddr = map_descbuffer(ring, (unsigned char *)header,
 					   hdrsize, 1);
-	if (dma_mapping_error(meta_hdr->dmaaddr)) {
+	if (b43_dma_mapping_error(ring, meta_hdr->dmaaddr, hdrsize)) {
 		ring->current_slot = old_top_slot;
 		ring->used_slots = old_used_slots;
 		return -EIO;
 	}
 	ops->fill_descriptor(ring, desc, meta_hdr->dmaaddr,
 			     hdrsize, 1, 0, 0);
@@ -1162,13 +1205,13 @@ static int dma_tx_fragment(struct b43_dm
 	memcpy(&meta->txstat.control, ctl, sizeof(*ctl));
 	meta->skb = skb;
 	meta->is_last_fragment = 1;
 
 	meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
 	/* create a bounce buffer in zone_dma on mapping failure. */
-	if (dma_mapping_error(meta->dmaaddr)) {
+	if (b43_dma_mapping_error(ring, meta->dmaaddr, skb->len)) {
 		bounce_skb = __dev_alloc_skb(skb->len, GFP_ATOMIC | GFP_DMA);
 		if (!bounce_skb) {
 			ring->current_slot = old_top_slot;
 			ring->used_slots = old_used_slots;
 			err = -ENOMEM;
 			goto out_unmap_hdr;
@@ -1176,13 +1219,13 @@ static int dma_tx_fragment(struct b43_dm
 
 		memcpy(skb_put(bounce_skb, skb->len), skb->data, skb->len);
 		dev_kfree_skb_any(skb);
 		skb = bounce_skb;
 		meta->skb = skb;
 		meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
-		if (dma_mapping_error(meta->dmaaddr)) {
+		if (b43_dma_mapping_error(ring, meta->dmaaddr, skb->len)) {
 			ring->current_slot = old_top_slot;
 			ring->used_slots = old_used_slots;
 			err = -EIO;
 			goto out_free_bounce;
 		}
 	}
Index: wireless-2.6/drivers/net/wireless/b43/dma.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/dma.h	2008-01-09 16:59:33.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/dma.h	2008-02-04 19:19:21.000000000 +0100
@@ -200,12 +200,18 @@ struct b43_dma_ops {
 	void (*tx_suspend) (struct b43_dmaring * ring);
 	void (*tx_resume) (struct b43_dmaring * ring);
 	int (*get_current_rxslot) (struct b43_dmaring * ring);
 	void (*set_current_rxslot) (struct b43_dmaring * ring, int slot);
 };
 
+enum b43_dmatype {
+	B43_DMA_30BIT	= 30,
+	B43_DMA_32BIT	= 32,
+	B43_DMA_64BIT	= 64,
+};
+
 struct b43_dmaring {
 	/* Lowlevel DMA ops. */
 	const struct b43_dma_ops *ops;
 	/* Kernel virtual base address of the ring memory. */
 	void *descbase;
 	/* Meta data about all descriptors. */
@@ -232,14 +238,14 @@ struct b43_dmaring {
 	/* The MMIO base register of the DMA controller. */
 	u16 mmio_base;
 	/* DMA controller index number (0-5). */
 	int index;
 	/* Boolean. Is this a TX ring? */
 	bool tx;
-	/* Boolean. 64bit DMA if true, 32bit DMA otherwise. */
-	bool dma64;
+	/* The type of DMA engine used. */
+	enum b43_dmatype type;
 	/* Boolean. Is this ring stopped at ieee80211 level? */
 	bool stopped;
 	/* Lock, only used for TX. */
 	spinlock_t lock;
 	struct b43_wldev *dev;
 #ifdef CONFIG_B43_DEBUG
@@ -252,28 +258,20 @@ struct b43_dmaring {
 
 static inline u32 b43_dma_read(struct b43_dmaring *ring, u16 offset)
 {
 	return b43_read32(ring->dev, ring->mmio_base + offset);
 }
 
-static inline
-    void b43_dma_write(struct b43_dmaring *ring, u16 offset, u32 value)
+static inline void b43_dma_write(struct b43_dmaring *ring, u16 offset, u32 value)
 {
 	b43_write32(ring->dev, ring->mmio_base + offset, value);
 }
 
 int b43_dma_init(struct b43_wldev *dev);
 void b43_dma_free(struct b43_wldev *dev);
 
-int b43_dmacontroller_rx_reset(struct b43_wldev *dev,
-			       u16 dmacontroller_mmio_base, int dma64);
-int b43_dmacontroller_tx_reset(struct b43_wldev *dev,
-			       u16 dmacontroller_mmio_base, int dma64);
-
-u16 b43_dmacontroller_base(int dma64bit, int dmacontroller_idx);
-
 void b43_dma_tx_suspend(struct b43_wldev *dev);
 void b43_dma_tx_resume(struct b43_wldev *dev);
 
 void b43_dma_get_tx_stats(struct b43_wldev *dev,
 			  struct ieee80211_tx_queue_stats *stats);
 
