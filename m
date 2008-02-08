Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:41986 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751751AbYBHFdz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 00:33:55 -0500
Date: Fri, 8 Feb 2008 06:31:53 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Matti Viljanen <viljanen.matti@gmail.com>
Subject: [PATCH 4/4] b43legacy: fix DMA for 30/32-bit DMA engines
Message-ID: <20080208063153.0bfcb572@morte> (sfid-20080208_053358_751605_57D0B7AF)
In-Reply-To: <20080208051650.372197299@polimi.it>
References: <20080208051650.372197299@polimi.it>>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This checks if the DMA address is bigger than what the controller can manage.
It will reallocate the buffers in the GFP_DMA zone in that case.

The patch by Michael Buesch has been ported to b43legacy.
Thanks to Matti Viljanen for reporting this.

Cc: Matti Viljanen <viljanen.matti@gmail.com>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: wireless-2.6/drivers/net/wireless/b43legacy/dma.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/dma.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/dma.c
@@ -354,7 +354,8 @@ return 0;
 }


-u16 b43legacy_dmacontroller_base(int dma64bit, int controller_idx)
+static u16 b43legacy_dmacontroller_base(enum b43legacy_dmatype type,
+					int controller_idx)
 {
 	static const u16 map64[] = {
 		B43legacy_MMIO_DMA64_BASE0,
@@ -373,7 +374,7 @@ u16 b43legacy_dmacontroller_base(int dma
 		B43legacy_MMIO_DMA32_BASE5,
 	};

-	if (dma64bit) {
+	if (type == B43legacy_DMA_64BIT) {
 		B43legacy_WARN_ON(!(controller_idx >= 0 &&
 				  controller_idx < ARRAY_SIZE(map64)));
 		return map64[controller_idx];
@@ -480,8 +481,9 @@ static void free_ringmemory(struct b43le
 }

 /* Reset the RX DMA channel */
-int b43legacy_dmacontroller_rx_reset(struct b43legacy_wldev *dev,
-				     u16 mmio_base, int dma64)
+static int b43legacy_dmacontroller_rx_reset(struct b43legacy_wldev *dev,
+				    	    u16 mmio_base,
+					    enum b43legacy_dmatype type)
 {
 	int i;
 	u32 value;
@@ -489,13 +491,14 @@ int b43legacy_dmacontroller_rx_reset(str

 	might_sleep();

-	offset = dma64 ? B43legacy_DMA64_RXCTL : B43legacy_DMA32_RXCTL;
+	offset = (type == B43legacy_DMA_64BIT) ?
+		 B43legacy_DMA64_RXCTL : B43legacy_DMA32_RXCTL;
 	b43legacy_write32(dev, mmio_base + offset, 0);
 	for (i = 0; i < 10; i++) {
-		offset = dma64 ? B43legacy_DMA64_RXSTATUS :
-			 B43legacy_DMA32_RXSTATUS;
+		offset = (type == B43legacy_DMA_64BIT) ?
+			 B43legacy_DMA64_RXSTATUS : B43legacy_DMA32_RXSTATUS;
 		value = b43legacy_read32(dev, mmio_base + offset);
-		if (dma64) {
+		if (type == B43legacy_DMA_64BIT) {
 			value &= B43legacy_DMA64_RXSTAT;
 			if (value == B43legacy_DMA64_RXSTAT_DISABLED) {
 				i = -1;
@@ -519,8 +522,9 @@ int b43legacy_dmacontroller_rx_reset(str
 }

 /* Reset the RX DMA channel */
-int b43legacy_dmacontroller_tx_reset(struct b43legacy_wldev *dev,
-				     u16 mmio_base, int dma64)
+static int b43legacy_dmacontroller_tx_reset(struct b43legacy_wldev *dev,
+					    u16 mmio_base,
+					    enum b43legacy_dmatype type)
 {
 	int i;
 	u32 value;
@@ -529,10 +533,10 @@ int b43legacy_dmacontroller_tx_reset(str
 	might_sleep();

 	for (i = 0; i < 10; i++) {
-		offset = dma64 ? B43legacy_DMA64_TXSTATUS :
-			 B43legacy_DMA32_TXSTATUS;
+		offset = (type == B43legacy_DMA_64BIT) ?
+			 B43legacy_DMA64_TXSTATUS : B43legacy_DMA32_TXSTATUS;
 		value = b43legacy_read32(dev, mmio_base + offset);
-		if (dma64) {
+		if (type == B43legacy_DMA_64BIT) {
 			value &= B43legacy_DMA64_TXSTAT;
 			if (value == B43legacy_DMA64_TXSTAT_DISABLED ||
 			    value == B43legacy_DMA64_TXSTAT_IDLEWAIT ||
@@ -547,13 +551,14 @@ int b43legacy_dmacontroller_tx_reset(str
 		}
 		msleep(1);
 	}
-	offset = dma64 ? B43legacy_DMA64_TXCTL : B43legacy_DMA32_TXCTL;
+	offset = (type == B43legacy_DMA_64BIT) ? B43legacy_DMA64_TXCTL :
+						 B43legacy_DMA32_TXCTL;
 	b43legacy_write32(dev, mmio_base + offset, 0);
 	for (i = 0; i < 10; i++) {
-		offset = dma64 ? B43legacy_DMA64_TXSTATUS :
-			 B43legacy_DMA32_TXSTATUS;
+		offset = (type == B43legacy_DMA_64BIT) ?
+			 B43legacy_DMA64_TXSTATUS : B43legacy_DMA32_TXSTATUS;
 		value = b43legacy_read32(dev, mmio_base + offset);
-		if (dma64) {
+		if (type == B43legacy_DMA_64BIT) {
 			value &= B43legacy_DMA64_TXSTAT;
 			if (value == B43legacy_DMA64_TXSTAT_DISABLED) {
 				i = -1;
@@ -578,6 +583,32 @@ int b43legacy_dmacontroller_tx_reset(str
 	return 0;
 }

+/* Check if a DMA mapping address is invalid. */
+static bool b43legacy_dma_mapping_error(struct b43legacy_dmaring *ring,
+					dma_addr_t addr,
+					size_t buffersize)
+{
+	if (unlikely(dma_mapping_error(addr)))
+		return 1;
+
+	switch (ring->type) {
+	case B43legacy_DMA_30BIT:
+		if ((u64)addr + buffersize > (1ULL << 30))
+			return 1;
+		break;
+	case B43legacy_DMA_32BIT:
+		if ((u64)addr + buffersize > (1ULL << 32))
+			return 1;
+		break;
+	case B43legacy_DMA_64BIT:
+		/* Currently we can't have addresses beyond 64 bits in the kernel. */
+		break;
+	}
+
+	/* The address is OK. */
+	return 0;
+}
+
 static int setup_rx_descbuffer(struct b43legacy_dmaring *ring,
 			       struct b43legacy_dmadesc_generic *desc,
 			       struct b43legacy_dmadesc_meta *meta,
@@ -595,7 +626,7 @@ static int setup_rx_descbuffer(struct b4
 		return -ENOMEM;
 	dmaaddr = map_descbuffer(ring, skb->data,
 				 ring->rx_buffersize, 0);
-	if (dma_mapping_error(dmaaddr)) {
+	if (b43legacy_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize)) {
 		/* ugh. try to realloc in zone_dma */
 		gfp_flags |= GFP_DMA;

@@ -608,7 +639,7 @@ static int setup_rx_descbuffer(struct b4
 					 ring->rx_buffersize, 0);
 	}

-	if (dma_mapping_error(dmaaddr)) {
+	if (b43legacy_dma_mapping_error(ring, dmaaddr, ring->rx_buffersize)) {
 		dev_kfree_skb_any(skb);
 		return -EIO;
 	}
@@ -674,7 +705,7 @@ static int dmacontroller_setup(struct b4
 	u32 trans = ssb_dma_translation(ring->dev->dev);

 	if (ring->tx) {
-		if (ring->dma64) {
+		if (ring->type == B43legacy_DMA_64BIT) {
 			u64 ringbase = (u64)(ring->dmabase);

 			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
@@ -709,7 +740,7 @@ static int dmacontroller_setup(struct b4
 		err = alloc_initial_descbuffers(ring);
 		if (err)
 			goto out;
-		if (ring->dma64) {
+		if (ring->type == B43legacy_DMA_64BIT) {
 			u64 ringbase = (u64)(ring->dmabase);

 			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
@@ -760,16 +791,16 @@ static void dmacontroller_cleanup(struct
 {
 	if (ring->tx) {
 		b43legacy_dmacontroller_tx_reset(ring->dev, ring->mmio_base,
-						 ring->dma64);
-		if (ring->dma64) {
+						 ring->type);
+		if (ring->type == B43legacy_DMA_64BIT) {
 			b43legacy_dma_write(ring, B43legacy_DMA64_TXRINGLO, 0);
 			b43legacy_dma_write(ring, B43legacy_DMA64_TXRINGHI, 0);
 		} else
 			b43legacy_dma_write(ring, B43legacy_DMA32_TXRING, 0);
 	} else {
 		b43legacy_dmacontroller_rx_reset(ring->dev, ring->mmio_base,
-						 ring->dma64);
-		if (ring->dma64) {
+						 ring->type);
+		if (ring->type == B43legacy_DMA_64BIT) {
 			b43legacy_dma_write(ring, B43legacy_DMA64_RXRINGLO, 0);
 			b43legacy_dma_write(ring, B43legacy_DMA64_RXRINGHI, 0);
 		} else
@@ -824,11 +855,10 @@ static u64 supported_dma_mask(struct b43

 /* Main initialization function. */
 static
-struct b43legacy_dmaring *b43legacy_setup_dmaring(
-					struct b43legacy_wldev *dev,
-					int controller_index,
-					int for_tx,
-					int dma64)
+struct b43legacy_dmaring *b43legacy_setup_dmaring(struct b43legacy_wldev *dev,
+						  int controller_index,
+						  int for_tx,
+						  enum b43legacy_dmatype type)
 {
 	struct b43legacy_dmaring *ring;
 	int err;
@@ -838,6 +868,7 @@ struct b43legacy_dmaring *b43legacy_setu
 	ring = kzalloc(sizeof(*ring), GFP_KERNEL);
 	if (!ring)
 		goto out;
+	ring->type = type;

 	nr_slots = B43legacy_RXRING_SLOTS;
 	if (for_tx)
@@ -855,12 +886,12 @@ struct b43legacy_dmaring *b43legacy_setu
 			goto err_kfree_meta;

 		/* test for ability to dma to txhdr_cache */
-		dma_test = dma_map_single(dev->dev->dev,
-				ring->txhdr_cache,
-				sizeof(struct b43legacy_txhdr_fw3),
-				DMA_TO_DEVICE);
+		dma_test = dma_map_single(dev->dev->dev, ring->txhdr_cache,
+					  sizeof(struct b43legacy_txhdr_fw3),
+					  DMA_TO_DEVICE);

-		if (dma_mapping_error(dma_test)) {
+		if (b43legacy_dma_mapping_error(ring, dma_test,
+					sizeof(struct b43legacy_txhdr_fw3))) {
 			/* ugh realloc */
 			kfree(ring->txhdr_cache);
 			ring->txhdr_cache = kcalloc(nr_slots,
@@ -874,7 +905,8 @@ struct b43legacy_dmaring *b43legacy_setu
 					sizeof(struct b43legacy_txhdr_fw3),
 					DMA_TO_DEVICE);

-			if (dma_mapping_error(dma_test))
+			if (b43legacy_dma_mapping_error(ring, dma_test,
+					sizeof(struct b43legacy_txhdr_fw3)))
 				goto err_kfree_txhdr_cache;
 		}

@@ -885,11 +917,9 @@ struct b43legacy_dmaring *b43legacy_setu

 	ring->dev = dev;
 	ring->nr_slots = nr_slots;
-	ring->mmio_base = b43legacy_dmacontroller_base(dma64,
-						       controller_index);
+	ring->mmio_base = b43legacy_dmacontroller_base(type, controller_index);
 	ring->index = controller_index;
-	ring->dma64 = !!dma64;
-	if (dma64)
+	if (type == B43legacy_DMA_64BIT)
 		ring->ops = &dma64_ops;
 	else
 		ring->ops = &dma32_ops;
@@ -939,10 +969,10 @@ static void b43legacy_destroy_dmaring(st
 	if (!ring)
 		return;

-	b43legacydbg(ring->dev->wl, "DMA-%s 0x%04X (%s) max used slots:"
-		     " %d/%d\n", (ring->dma64) ? "64" : "32", ring->mmio_base,
-		     (ring->tx) ? "TX" : "RX",
-		     ring->max_used_slots, ring->nr_slots);
+	b43legacydbg(ring->dev->wl, "DMA-%u 0x%04X (%s) max used slots:"
+		     " %d/%d\n", (unsigned int)(ring->type), ring->mmio_base,
+		     (ring->tx) ? "TX" : "RX", ring->max_used_slots,
+		     ring->nr_slots);
 	/* Device IRQs are disabled prior entering this function,
 	 * so no need to take care of concurrency with rx handler stuff.
 	 */
@@ -988,11 +1018,22 @@ int b43legacy_dma_init(struct b43legacy_
 	struct b43legacy_dmaring *ring;
 	int err;
 	u64 dmamask;
-	int dma64 = 0;
+	enum b43legacy_dmatype type;

 	dmamask = supported_dma_mask(dev);
-	if (dmamask == DMA_64BIT_MASK)
-		dma64 = 1;
+	switch (dmamask) {
+	default:
+		B43legacy_WARN_ON(1);
+	case DMA_30BIT_MASK:
+		type = B43legacy_DMA_30BIT;
+		break;
+	case DMA_32BIT_MASK:
+		type = B43legacy_DMA_32BIT;
+		break;
+	case DMA_64BIT_MASK:
+		type = B43legacy_DMA_64BIT;
+		break;
+	}

 	err = ssb_dma_set_mask(dev->dev, dmamask);
 	if (err) {
@@ -1010,52 +1051,50 @@ int b43legacy_dma_init(struct b43legacy_

 	err = -ENOMEM;
 	/* setup TX DMA channels. */
-	ring = b43legacy_setup_dmaring(dev, 0, 1, dma64);
+	ring = b43legacy_setup_dmaring(dev, 0, 1, type);
 	if (!ring)
 		goto out;
 	dma->tx_ring0 = ring;

-	ring = b43legacy_setup_dmaring(dev, 1, 1, dma64);
+	ring = b43legacy_setup_dmaring(dev, 1, 1, type);
 	if (!ring)
 		goto err_destroy_tx0;
 	dma->tx_ring1 = ring;

-	ring = b43legacy_setup_dmaring(dev, 2, 1, dma64);
+	ring = b43legacy_setup_dmaring(dev, 2, 1, type);
 	if (!ring)
 		goto err_destroy_tx1;
 	dma->tx_ring2 = ring;

-	ring = b43legacy_setup_dmaring(dev, 3, 1, dma64);
+	ring = b43legacy_setup_dmaring(dev, 3, 1, type);
 	if (!ring)
 		goto err_destroy_tx2;
 	dma->tx_ring3 = ring;

-	ring = b43legacy_setup_dmaring(dev, 4, 1, dma64);
+	ring = b43legacy_setup_dmaring(dev, 4, 1, type);
 	if (!ring)
 		goto err_destroy_tx3;
 	dma->tx_ring4 = ring;

-	ring = b43legacy_setup_dmaring(dev, 5, 1, dma64);
+	ring = b43legacy_setup_dmaring(dev, 5, 1, type);
 	if (!ring)
 		goto err_destroy_tx4;
 	dma->tx_ring5 = ring;

 	/* setup RX DMA channels. */
-	ring = b43legacy_setup_dmaring(dev, 0, 0, dma64);
+	ring = b43legacy_setup_dmaring(dev, 0, 0, type);
 	if (!ring)
 		goto err_destroy_tx5;
 	dma->rx_ring0 = ring;

 	if (dev->dev->id.revision < 5) {
-		ring = b43legacy_setup_dmaring(dev, 3, 0, dma64);
+		ring = b43legacy_setup_dmaring(dev, 3, 0, type);
 		if (!ring)
 			goto err_destroy_rx0;
 		dma->rx_ring3 = ring;
 	}

-	b43legacydbg(dev->wl, "%d-bit DMA initialized\n",
-	       (dmamask == DMA_64BIT_MASK) ? 64 :
-	       (dmamask == DMA_32BIT_MASK) ? 32 : 30);
+	b43legacydbg(dev->wl, "%u-bit DMA initialized\n", (unsigned int)type);
 	err = 0;
 out:
 	return err;
@@ -1194,9 +1233,13 @@ static int dma_tx_fragment(struct b43leg
 	}

 	meta_hdr->dmaaddr = map_descbuffer(ring, (unsigned char *)header,
-				       sizeof(struct b43legacy_txhdr_fw3), 1);
-	if (dma_mapping_error(meta_hdr->dmaaddr))
+					   sizeof(struct b43legacy_txhdr_fw3), 1);
+	if (b43legacy_dma_mapping_error(ring, meta_hdr->dmaaddr,
+					sizeof(struct b43legacy_txhdr_fw3))) {
+		ring->current_slot = old_top_slot;
+		ring->used_slots = old_used_slots;
 		return -EIO;
+	}
 	ops->fill_descriptor(ring, desc, meta_hdr->dmaaddr,
 			     sizeof(struct b43legacy_txhdr_fw3), 1, 0, 0);

@@ -1211,7 +1254,7 @@ static int dma_tx_fragment(struct b43leg

 	meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
 	/* create a bounce buffer in zone_dma on mapping failure. */
-	if (dma_mapping_error(meta->dmaaddr)) {
+	if (b43legacy_dma_mapping_error(ring, meta->dmaaddr, skb->len)) {
 		bounce_skb = __dev_alloc_skb(skb->len, GFP_ATOMIC | GFP_DMA);
 		if (!bounce_skb) {
 			ring->current_slot = old_top_slot;
@@ -1225,7 +1268,7 @@ static int dma_tx_fragment(struct b43leg
 		skb = bounce_skb;
 		meta->skb = skb;
 		meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
-		if (dma_mapping_error(meta->dmaaddr)) {
+		if (b43legacy_dma_mapping_error(ring, meta->dmaaddr, skb->len)) {
 			ring->current_slot = old_top_slot;
 			ring->used_slots = old_used_slots;
 			err = -EIO;
Index: wireless-2.6/drivers/net/wireless/b43legacy/dma.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/dma.h
+++ wireless-2.6/drivers/net/wireless/b43legacy/dma.h
@@ -218,6 +218,12 @@ struct b43legacy_dma_ops {
 	void (*set_current_rxslot)(struct b43legacy_dmaring *ring, int slot);
 };

+enum b43legacy_dmatype {
+	B43legacy_DMA_30BIT = 30,
+	B43legacy_DMA_32BIT = 32,
+	B43legacy_DMA_64BIT = 64,
+};
+
 struct b43legacy_dmaring {
 	/* Lowlevel DMA ops. */
 	const struct b43legacy_dma_ops *ops;
@@ -250,8 +256,8 @@ struct b43legacy_dmaring {
 	int index;
 	/* Boolean. Is this a TX ring? */
 	bool tx;
-	/* Boolean. 64bit DMA if true, 32bit DMA otherwise. */
-	bool dma64;
+	/* The type of DMA engine used. */
+	enum b43legacy_dmatype type;
 	/* Boolean. Is this ring stopped at ieee80211 level? */
 	bool stopped;
 	/* Lock, only used for TX. */
@@ -284,15 +290,6 @@ void b43legacy_dma_write(struct b43legac
 int b43legacy_dma_init(struct b43legacy_wldev *dev);
 void b43legacy_dma_free(struct b43legacy_wldev *dev);

-int b43legacy_dmacontroller_rx_reset(struct b43legacy_wldev *dev,
-				     u16 dmacontroller_mmio_base,
-				     int dma64);
-int b43legacy_dmacontroller_tx_reset(struct b43legacy_wldev *dev,
-				     u16 dmacontroller_mmio_base,
-				     int dma64);
-
-u16 b43legacy_dmacontroller_base(int dma64bit, int dmacontroller_idx);
-
 void b43legacy_dma_tx_suspend(struct b43legacy_wldev *dev);
 void b43legacy_dma_tx_resume(struct b43legacy_wldev *dev);

@@ -320,20 +317,6 @@ void b43legacy_dma_free(struct b43legacy
 {
 }
 static inline
-int b43legacy_dmacontroller_rx_reset(struct b43legacy_wldev *dev,
-				     u16 dmacontroller_mmio_base,
-				     int dma64)
-{
-	return 0;
-}
-static inline
-int b43legacy_dmacontroller_tx_reset(struct b43legacy_wldev *dev,
-				     u16 dmacontroller_mmio_base,
-				     int dma64)
-{
-	return 0;
-}
-static inline
 void b43legacy_dma_get_tx_stats(struct b43legacy_wldev *dev,
 				struct ieee80211_tx_queue_stats *stats)
 {

-- 
Ciao
Stefano
