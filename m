Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:19476 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab1GYVk0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 17:40:26 -0400
Subject: [PATCH] b43legacy: remove 64-bit DMA support
To: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Mon, 25 Jul 2011 17:40:22 -0400
Message-ID: <20110725213832.32510.3753.stgit@mj.roinet.com> (sfid-20110725_234030_183903_DA5D4C67)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Devices supported by b43legacy don't support 64-bit DMA.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
The patch was tested on Broadcom 4306.

 drivers/net/wireless/b43legacy/dma.c |  374 ++++++----------------------------
 drivers/net/wireless/b43legacy/dma.h |  107 ----------
 2 files changed, 71 insertions(+), 410 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/dma.c b/drivers/net/wireless/b43legacy/dma.c
index 704ee62..a23b998 100644
--- a/drivers/net/wireless/b43legacy/dma.c
+++ b/drivers/net/wireless/b43legacy/dma.c
@@ -42,10 +42,9 @@
 
 /* 32bit DMA ops. */
 static
-struct b43legacy_dmadesc_generic *op32_idx2desc(
-					struct b43legacy_dmaring *ring,
-					int slot,
-					struct b43legacy_dmadesc_meta **meta)
+struct b43legacy_dmadesc32 *op32_idx2desc(struct b43legacy_dmaring *ring,
+					  int slot,
+					  struct b43legacy_dmadesc_meta **meta)
 {
 	struct b43legacy_dmadesc32 *desc;
 
@@ -53,11 +52,11 @@ struct b43legacy_dmadesc_generic *op32_idx2desc(
 	desc = ring->descbase;
 	desc = &(desc[slot]);
 
-	return (struct b43legacy_dmadesc_generic *)desc;
+	return (struct b43legacy_dmadesc32 *)desc;
 }
 
 static void op32_fill_descriptor(struct b43legacy_dmaring *ring,
-				 struct b43legacy_dmadesc_generic *desc,
+				 struct b43legacy_dmadesc32 *desc,
 				 dma_addr_t dmaaddr, u16 bufsize,
 				 int start, int end, int irq)
 {
@@ -67,7 +66,7 @@ static void op32_fill_descriptor(struct b43legacy_dmaring *ring,
 	u32 addr;
 	u32 addrext;
 
-	slot = (int)(&(desc->dma32) - descbase);
+	slot = (int)(desc - descbase);
 	B43legacy_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
 
 	addr = (u32)(dmaaddr & ~SSB_DMA_TRANSLATION_MASK);
@@ -87,8 +86,8 @@ static void op32_fill_descriptor(struct b43legacy_dmaring *ring,
 	ctl |= (addrext << B43legacy_DMA32_DCTL_ADDREXT_SHIFT)
 	       & B43legacy_DMA32_DCTL_ADDREXT_MASK;
 
-	desc->dma32.control = cpu_to_le32(ctl);
-	desc->dma32.address = cpu_to_le32(addr);
+	desc->control = cpu_to_le32(ctl);
+	desc->address = cpu_to_le32(addr);
 }
 
 static void op32_poke_tx(struct b43legacy_dmaring *ring, int slot)
@@ -128,121 +127,6 @@ static void op32_set_current_rxslot(struct b43legacy_dmaring *ring,
 			    (u32)(slot * sizeof(struct b43legacy_dmadesc32)));
 }
 
-static const struct b43legacy_dma_ops dma32_ops = {
-	.idx2desc		= op32_idx2desc,
-	.fill_descriptor	= op32_fill_descriptor,
-	.poke_tx		= op32_poke_tx,
-	.tx_suspend		= op32_tx_suspend,
-	.tx_resume		= op32_tx_resume,
-	.get_current_rxslot	= op32_get_current_rxslot,
-	.set_current_rxslot	= op32_set_current_rxslot,
-};
-
-/* 64bit DMA ops. */
-static
-struct b43legacy_dmadesc_generic *op64_idx2desc(
-					struct b43legacy_dmaring *ring,
-					int slot,
-					struct b43legacy_dmadesc_meta
-					**meta)
-{
-	struct b43legacy_dmadesc64 *desc;
-
-	*meta = &(ring->meta[slot]);
-	desc = ring->descbase;
-	desc = &(desc[slot]);
-
-	return (struct b43legacy_dmadesc_generic *)desc;
-}
-
-static void op64_fill_descriptor(struct b43legacy_dmaring *ring,
-				 struct b43legacy_dmadesc_generic *desc,
-				 dma_addr_t dmaaddr, u16 bufsize,
-				 int start, int end, int irq)
-{
-	struct b43legacy_dmadesc64 *descbase = ring->descbase;
-	int slot;
-	u32 ctl0 = 0;
-	u32 ctl1 = 0;
-	u32 addrlo;
-	u32 addrhi;
-	u32 addrext;
-
-	slot = (int)(&(desc->dma64) - descbase);
-	B43legacy_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
-
-	addrlo = (u32)(dmaaddr & 0xFFFFFFFF);
-	addrhi = (((u64)dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
-	addrext = (((u64)dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
-		  >> SSB_DMA_TRANSLATION_SHIFT;
-	addrhi |= ring->dev->dma.translation;
-	if (slot == ring->nr_slots - 1)
-		ctl0 |= B43legacy_DMA64_DCTL0_DTABLEEND;
-	if (start)
-		ctl0 |= B43legacy_DMA64_DCTL0_FRAMESTART;
-	if (end)
-		ctl0 |= B43legacy_DMA64_DCTL0_FRAMEEND;
-	if (irq)
-		ctl0 |= B43legacy_DMA64_DCTL0_IRQ;
-	ctl1 |= (bufsize - ring->frameoffset)
-		& B43legacy_DMA64_DCTL1_BYTECNT;
-	ctl1 |= (addrext << B43legacy_DMA64_DCTL1_ADDREXT_SHIFT)
-		& B43legacy_DMA64_DCTL1_ADDREXT_MASK;
-
-	desc->dma64.control0 = cpu_to_le32(ctl0);
-	desc->dma64.control1 = cpu_to_le32(ctl1);
-	desc->dma64.address_low = cpu_to_le32(addrlo);
-	desc->dma64.address_high = cpu_to_le32(addrhi);
-}
-
-static void op64_poke_tx(struct b43legacy_dmaring *ring, int slot)
-{
-	b43legacy_dma_write(ring, B43legacy_DMA64_TXINDEX,
-			    (u32)(slot * sizeof(struct b43legacy_dmadesc64)));
-}
-
-static void op64_tx_suspend(struct b43legacy_dmaring *ring)
-{
-	b43legacy_dma_write(ring, B43legacy_DMA64_TXCTL,
-			    b43legacy_dma_read(ring, B43legacy_DMA64_TXCTL)
-			    | B43legacy_DMA64_TXSUSPEND);
-}
-
-static void op64_tx_resume(struct b43legacy_dmaring *ring)
-{
-	b43legacy_dma_write(ring, B43legacy_DMA64_TXCTL,
-			    b43legacy_dma_read(ring, B43legacy_DMA64_TXCTL)
-			    & ~B43legacy_DMA64_TXSUSPEND);
-}
-
-static int op64_get_current_rxslot(struct b43legacy_dmaring *ring)
-{
-	u32 val;
-
-	val = b43legacy_dma_read(ring, B43legacy_DMA64_RXSTATUS);
-	val &= B43legacy_DMA64_RXSTATDPTR;
-
-	return (val / sizeof(struct b43legacy_dmadesc64));
-}
-
-static void op64_set_current_rxslot(struct b43legacy_dmaring *ring,
-				    int slot)
-{
-	b43legacy_dma_write(ring, B43legacy_DMA64_RXINDEX,
-			    (u32)(slot * sizeof(struct b43legacy_dmadesc64)));
-}
-
-static const struct b43legacy_dma_ops dma64_ops = {
-	.idx2desc		= op64_idx2desc,
-	.fill_descriptor	= op64_fill_descriptor,
-	.poke_tx		= op64_poke_tx,
-	.tx_suspend		= op64_tx_suspend,
-	.tx_resume		= op64_tx_resume,
-	.get_current_rxslot	= op64_get_current_rxslot,
-	.set_current_rxslot	= op64_set_current_rxslot,
-};
-
-
 static inline int free_slots(struct b43legacy_dmaring *ring)
 {
 	return (ring->nr_slots - ring->used_slots);
@@ -358,14 +242,6 @@ return 0;
 static u16 b43legacy_dmacontroller_base(enum b43legacy_dmatype type,
 					int controller_idx)
 {
-	static const u16 map64[] = {
-		B43legacy_MMIO_DMA64_BASE0,
-		B43legacy_MMIO_DMA64_BASE1,
-		B43legacy_MMIO_DMA64_BASE2,
-		B43legacy_MMIO_DMA64_BASE3,
-		B43legacy_MMIO_DMA64_BASE4,
-		B43legacy_MMIO_DMA64_BASE5,
-	};
 	static const u16 map32[] = {
 		B43legacy_MMIO_DMA32_BASE0,
 		B43legacy_MMIO_DMA32_BASE1,
@@ -375,11 +251,6 @@ static u16 b43legacy_dmacontroller_base(enum b43legacy_dmatype type,
 		B43legacy_MMIO_DMA32_BASE5,
 	};
 
-	if (type == B43legacy_DMA_64BIT) {
-		B43legacy_WARN_ON(!(controller_idx >= 0 &&
-				  controller_idx < ARRAY_SIZE(map64)));
-		return map64[controller_idx];
-	}
 	B43legacy_WARN_ON(!(controller_idx >= 0 &&
 			  controller_idx < ARRAY_SIZE(map32)));
 	return map32[controller_idx];
@@ -491,25 +362,15 @@ static int b43legacy_dmacontroller_rx_reset(struct b43legacy_wldev *dev,
 
 	might_sleep();
 
-	offset = (type == B43legacy_DMA_64BIT) ?
-		 B43legacy_DMA64_RXCTL : B43legacy_DMA32_RXCTL;
+	offset = B43legacy_DMA32_RXCTL;
 	b43legacy_write32(dev, mmio_base + offset, 0);
 	for (i = 0; i < 10; i++) {
-		offset = (type == B43legacy_DMA_64BIT) ?
-			 B43legacy_DMA64_RXSTATUS : B43legacy_DMA32_RXSTATUS;
+		offset = B43legacy_DMA32_RXSTATUS;
 		value = b43legacy_read32(dev, mmio_base + offset);
-		if (type == B43legacy_DMA_64BIT) {
-			value &= B43legacy_DMA64_RXSTAT;
-			if (value == B43legacy_DMA64_RXSTAT_DISABLED) {
-				i = -1;
-				break;
-			}
-		} else {
-			value &= B43legacy_DMA32_RXSTATE;
-			if (value == B43legacy_DMA32_RXSTAT_DISABLED) {
-				i = -1;
-				break;
-			}
+		value &= B43legacy_DMA32_RXSTATE;
+		if (value == B43legacy_DMA32_RXSTAT_DISABLED) {
+			i = -1;
+			break;
 		}
 		msleep(1);
 	}
@@ -533,43 +394,24 @@ static int b43legacy_dmacontroller_tx_reset(struct b43legacy_wldev *dev,
 	might_sleep();
 
 	for (i = 0; i < 10; i++) {
-		offset = (type == B43legacy_DMA_64BIT) ?
-			 B43legacy_DMA64_TXSTATUS : B43legacy_DMA32_TXSTATUS;
+		offset = B43legacy_DMA32_TXSTATUS;
 		value = b43legacy_read32(dev, mmio_base + offset);
-		if (type == B43legacy_DMA_64BIT) {
-			value &= B43legacy_DMA64_TXSTAT;
-			if (value == B43legacy_DMA64_TXSTAT_DISABLED ||
-			    value == B43legacy_DMA64_TXSTAT_IDLEWAIT ||
-			    value == B43legacy_DMA64_TXSTAT_STOPPED)
-				break;
-		} else {
-			value &= B43legacy_DMA32_TXSTATE;
-			if (value == B43legacy_DMA32_TXSTAT_DISABLED ||
-			    value == B43legacy_DMA32_TXSTAT_IDLEWAIT ||
-			    value == B43legacy_DMA32_TXSTAT_STOPPED)
-				break;
-		}
+		value &= B43legacy_DMA32_TXSTATE;
+		if (value == B43legacy_DMA32_TXSTAT_DISABLED ||
+		    value == B43legacy_DMA32_TXSTAT_IDLEWAIT ||
+		    value == B43legacy_DMA32_TXSTAT_STOPPED)
+			break;
 		msleep(1);
 	}
-	offset = (type == B43legacy_DMA_64BIT) ? B43legacy_DMA64_TXCTL :
-						 B43legacy_DMA32_TXCTL;
+	offset = B43legacy_DMA32_TXCTL;
 	b43legacy_write32(dev, mmio_base + offset, 0);
 	for (i = 0; i < 10; i++) {
-		offset = (type == B43legacy_DMA_64BIT) ?
-			 B43legacy_DMA64_TXSTATUS : B43legacy_DMA32_TXSTATUS;
+		offset = B43legacy_DMA32_TXSTATUS;
 		value = b43legacy_read32(dev, mmio_base + offset);
-		if (type == B43legacy_DMA_64BIT) {
-			value &= B43legacy_DMA64_TXSTAT;
-			if (value == B43legacy_DMA64_TXSTAT_DISABLED) {
-				i = -1;
-				break;
-			}
-		} else {
-			value &= B43legacy_DMA32_TXSTATE;
-			if (value == B43legacy_DMA32_TXSTAT_DISABLED) {
-				i = -1;
-				break;
-			}
+		value &= B43legacy_DMA32_TXSTATE;
+		if (value == B43legacy_DMA32_TXSTAT_DISABLED) {
+			i = -1;
+			break;
 		}
 		msleep(1);
 	}
@@ -601,9 +443,6 @@ static bool b43legacy_dma_mapping_error(struct b43legacy_dmaring *ring,
 		if ((u64)addr + buffersize > (1ULL << 32))
 			goto address_error;
 		break;
-	case B43legacy_DMA_64BIT:
-		/* Currently we can't have addresses beyond 64 bits in the kernel. */
-		break;
 	}
 
 	/* The address is OK. */
@@ -617,7 +456,7 @@ address_error:
 }
 
 static int setup_rx_descbuffer(struct b43legacy_dmaring *ring,
-			       struct b43legacy_dmadesc_generic *desc,
+			       struct b43legacy_dmadesc32 *desc,
 			       struct b43legacy_dmadesc_meta *meta,
 			       gfp_t gfp_flags)
 {
@@ -653,8 +492,7 @@ static int setup_rx_descbuffer(struct b43legacy_dmaring *ring,
 
 	meta->skb = skb;
 	meta->dmaaddr = dmaaddr;
-	ring->ops->fill_descriptor(ring, desc, dmaaddr,
-				   ring->rx_buffersize, 0, 0, 0);
+	op32_fill_descriptor(ring, desc, dmaaddr, ring->rx_buffersize, 0, 0, 0);
 
 	rxhdr = (struct b43legacy_rxhdr_fw3 *)(skb->data);
 	rxhdr->frame_len = 0;
@@ -671,11 +509,11 @@ static int alloc_initial_descbuffers(struct b43legacy_dmaring *ring)
 {
 	int i;
 	int err = -ENOMEM;
-	struct b43legacy_dmadesc_generic *desc;
+	struct b43legacy_dmadesc32 *desc;
 	struct b43legacy_dmadesc_meta *meta;
 
 	for (i = 0; i < ring->nr_slots; i++) {
-		desc = ring->ops->idx2desc(ring, i, &meta);
+		desc = op32_idx2desc(ring, i, &meta);
 
 		err = setup_rx_descbuffer(ring, desc, meta, GFP_KERNEL);
 		if (err) {
@@ -692,7 +530,7 @@ out:
 
 err_unwind:
 	for (i--; i >= 0; i--) {
-		desc = ring->ops->idx2desc(ring, i, &meta);
+		desc = op32_idx2desc(ring, i, &meta);
 
 		unmap_descbuffer(ring, meta->dmaaddr, ring->rx_buffersize, 0);
 		dev_kfree_skb(meta->skb);
@@ -710,83 +548,35 @@ static int dmacontroller_setup(struct b43legacy_dmaring *ring)
 	u32 value;
 	u32 addrext;
 	u32 trans = ring->dev->dma.translation;
+	u32 ringbase = (u32)(ring->dmabase);
 
 	if (ring->tx) {
-		if (ring->type == B43legacy_DMA_64BIT) {
-			u64 ringbase = (u64)(ring->dmabase);
-
-			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
-				  >> SSB_DMA_TRANSLATION_SHIFT;
-			value = B43legacy_DMA64_TXENABLE;
-			value |= (addrext << B43legacy_DMA64_TXADDREXT_SHIFT)
-				& B43legacy_DMA64_TXADDREXT_MASK;
-			b43legacy_dma_write(ring, B43legacy_DMA64_TXCTL,
-					    value);
-			b43legacy_dma_write(ring, B43legacy_DMA64_TXRINGLO,
-					    (ringbase & 0xFFFFFFFF));
-			b43legacy_dma_write(ring, B43legacy_DMA64_TXRINGHI,
-					    ((ringbase >> 32)
-					    & ~SSB_DMA_TRANSLATION_MASK)
-					    | trans);
-		} else {
-			u32 ringbase = (u32)(ring->dmabase);
-
-			addrext = (ringbase & SSB_DMA_TRANSLATION_MASK)
-				  >> SSB_DMA_TRANSLATION_SHIFT;
-			value = B43legacy_DMA32_TXENABLE;
-			value |= (addrext << B43legacy_DMA32_TXADDREXT_SHIFT)
-				& B43legacy_DMA32_TXADDREXT_MASK;
-			b43legacy_dma_write(ring, B43legacy_DMA32_TXCTL,
-					    value);
-			b43legacy_dma_write(ring, B43legacy_DMA32_TXRING,
-					    (ringbase &
-					    ~SSB_DMA_TRANSLATION_MASK)
-					    | trans);
-		}
+		addrext = (ringbase & SSB_DMA_TRANSLATION_MASK)
+			  >> SSB_DMA_TRANSLATION_SHIFT;
+		value = B43legacy_DMA32_TXENABLE;
+		value |= (addrext << B43legacy_DMA32_TXADDREXT_SHIFT)
+			& B43legacy_DMA32_TXADDREXT_MASK;
+		b43legacy_dma_write(ring, B43legacy_DMA32_TXCTL, value);
+		b43legacy_dma_write(ring, B43legacy_DMA32_TXRING,
+				    (ringbase & ~SSB_DMA_TRANSLATION_MASK)
+				    | trans);
 	} else {
 		err = alloc_initial_descbuffers(ring);
 		if (err)
 			goto out;
-		if (ring->type == B43legacy_DMA_64BIT) {
-			u64 ringbase = (u64)(ring->dmabase);
-
-			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
-				  >> SSB_DMA_TRANSLATION_SHIFT;
-			value = (ring->frameoffset <<
-				 B43legacy_DMA64_RXFROFF_SHIFT);
-			value |= B43legacy_DMA64_RXENABLE;
-			value |= (addrext << B43legacy_DMA64_RXADDREXT_SHIFT)
-				& B43legacy_DMA64_RXADDREXT_MASK;
-			b43legacy_dma_write(ring, B43legacy_DMA64_RXCTL,
-					    value);
-			b43legacy_dma_write(ring, B43legacy_DMA64_RXRINGLO,
-					    (ringbase & 0xFFFFFFFF));
-			b43legacy_dma_write(ring, B43legacy_DMA64_RXRINGHI,
-					    ((ringbase >> 32) &
-					    ~SSB_DMA_TRANSLATION_MASK) |
-					    trans);
-			b43legacy_dma_write(ring, B43legacy_DMA64_RXINDEX,
-					    200);
-		} else {
-			u32 ringbase = (u32)(ring->dmabase);
-
-			addrext = (ringbase & SSB_DMA_TRANSLATION_MASK)
-				  >> SSB_DMA_TRANSLATION_SHIFT;
-			value = (ring->frameoffset <<
-				 B43legacy_DMA32_RXFROFF_SHIFT);
-			value |= B43legacy_DMA32_RXENABLE;
-			value |= (addrext <<
-				 B43legacy_DMA32_RXADDREXT_SHIFT)
-				 & B43legacy_DMA32_RXADDREXT_MASK;
-			b43legacy_dma_write(ring, B43legacy_DMA32_RXCTL,
-					    value);
-			b43legacy_dma_write(ring, B43legacy_DMA32_RXRING,
-					    (ringbase &
-					    ~SSB_DMA_TRANSLATION_MASK)
-					    | trans);
-			b43legacy_dma_write(ring, B43legacy_DMA32_RXINDEX,
-					    200);
-		}
+
+		addrext = (ringbase & SSB_DMA_TRANSLATION_MASK)
+			  >> SSB_DMA_TRANSLATION_SHIFT;
+		value = (ring->frameoffset <<
+			 B43legacy_DMA32_RXFROFF_SHIFT);
+		value |= B43legacy_DMA32_RXENABLE;
+		value |= (addrext << B43legacy_DMA32_RXADDREXT_SHIFT)
+			 & B43legacy_DMA32_RXADDREXT_MASK;
+		b43legacy_dma_write(ring, B43legacy_DMA32_RXCTL, value);
+		b43legacy_dma_write(ring, B43legacy_DMA32_RXRING,
+				    (ringbase & ~SSB_DMA_TRANSLATION_MASK)
+				    | trans);
+		b43legacy_dma_write(ring, B43legacy_DMA32_RXINDEX, 200);
 	}
 
 out:
@@ -799,19 +589,11 @@ static void dmacontroller_cleanup(struct b43legacy_dmaring *ring)
 	if (ring->tx) {
 		b43legacy_dmacontroller_tx_reset(ring->dev, ring->mmio_base,
 						 ring->type);
-		if (ring->type == B43legacy_DMA_64BIT) {
-			b43legacy_dma_write(ring, B43legacy_DMA64_TXRINGLO, 0);
-			b43legacy_dma_write(ring, B43legacy_DMA64_TXRINGHI, 0);
-		} else
-			b43legacy_dma_write(ring, B43legacy_DMA32_TXRING, 0);
+		b43legacy_dma_write(ring, B43legacy_DMA32_TXRING, 0);
 	} else {
 		b43legacy_dmacontroller_rx_reset(ring->dev, ring->mmio_base,
 						 ring->type);
-		if (ring->type == B43legacy_DMA_64BIT) {
-			b43legacy_dma_write(ring, B43legacy_DMA64_RXRINGLO, 0);
-			b43legacy_dma_write(ring, B43legacy_DMA64_RXRINGHI, 0);
-		} else
-			b43legacy_dma_write(ring, B43legacy_DMA32_RXRING, 0);
+		b43legacy_dma_write(ring, B43legacy_DMA32_RXRING, 0);
 	}
 }
 
@@ -823,7 +605,7 @@ static void free_all_descbuffers(struct b43legacy_dmaring *ring)
 	if (!ring->used_slots)
 		return;
 	for (i = 0; i < ring->nr_slots; i++) {
-		ring->ops->idx2desc(ring, i, &meta);
+		op32_idx2desc(ring, i, &meta);
 
 		if (!meta->skb) {
 			B43legacy_WARN_ON(!ring->tx);
@@ -844,9 +626,6 @@ static u64 supported_dma_mask(struct b43legacy_wldev *dev)
 	u32 tmp;
 	u16 mmio_base;
 
-	tmp = b43legacy_read32(dev, SSB_TMSHIGH);
-	if (tmp & SSB_TMSHIGH_DMA64)
-		return DMA_BIT_MASK(64);
 	mmio_base = b43legacy_dmacontroller_base(0, 0);
 	b43legacy_write32(dev,
 			mmio_base + B43legacy_DMA32_TXCTL,
@@ -865,8 +644,6 @@ static enum b43legacy_dmatype dma_mask_to_engine_type(u64 dmamask)
 		return B43legacy_DMA_30BIT;
 	if (dmamask == DMA_BIT_MASK(32))
 		return B43legacy_DMA_32BIT;
-	if (dmamask == DMA_BIT_MASK(64))
-		return B43legacy_DMA_64BIT;
 	B43legacy_WARN_ON(1);
 	return B43legacy_DMA_30BIT;
 }
@@ -937,10 +714,6 @@ struct b43legacy_dmaring *b43legacy_setup_dmaring(struct b43legacy_wldev *dev,
 	ring->nr_slots = nr_slots;
 	ring->mmio_base = b43legacy_dmacontroller_base(type, controller_index);
 	ring->index = controller_index;
-	if (type == B43legacy_DMA_64BIT)
-		ring->ops = &dma64_ops;
-	else
-		ring->ops = &dma32_ops;
 	if (for_tx) {
 		ring->tx = 1;
 		ring->current_slot = -1;
@@ -1247,12 +1020,11 @@ static int dma_tx_fragment(struct b43legacy_dmaring *ring,
 			    struct sk_buff **in_skb)
 {
 	struct sk_buff *skb = *in_skb;
-	const struct b43legacy_dma_ops *ops = ring->ops;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	u8 *header;
 	int slot, old_top_slot, old_used_slots;
 	int err;
-	struct b43legacy_dmadesc_generic *desc;
+	struct b43legacy_dmadesc32 *desc;
 	struct b43legacy_dmadesc_meta *meta;
 	struct b43legacy_dmadesc_meta *meta_hdr;
 	struct sk_buff *bounce_skb;
@@ -1265,7 +1037,7 @@ static int dma_tx_fragment(struct b43legacy_dmaring *ring,
 
 	/* Get a slot for the header. */
 	slot = request_slot(ring);
-	desc = ops->idx2desc(ring, slot, &meta_hdr);
+	desc = op32_idx2desc(ring, slot, &meta_hdr);
 	memset(meta_hdr, 0, sizeof(*meta_hdr));
 
 	header = &(ring->txhdr_cache[slot * sizeof(
@@ -1287,12 +1059,12 @@ static int dma_tx_fragment(struct b43legacy_dmaring *ring,
 		ring->used_slots = old_used_slots;
 		return -EIO;
 	}
-	ops->fill_descriptor(ring, desc, meta_hdr->dmaaddr,
+	op32_fill_descriptor(ring, desc, meta_hdr->dmaaddr,
 			     sizeof(struct b43legacy_txhdr_fw3), 1, 0, 0);
 
 	/* Get a slot for the payload. */
 	slot = request_slot(ring);
-	desc = ops->idx2desc(ring, slot, &meta);
+	desc = op32_idx2desc(ring, slot, &meta);
 	memset(meta, 0, sizeof(*meta));
 
 	meta->skb = skb;
@@ -1328,12 +1100,12 @@ static int dma_tx_fragment(struct b43legacy_dmaring *ring,
 		}
 	}
 
-	ops->fill_descriptor(ring, desc, meta->dmaaddr,
+	op32_fill_descriptor(ring, desc, meta->dmaaddr,
 			     skb->len, 0, 1, 1);
 
 	wmb();	/* previous stuff MUST be done */
 	/* Now transfer the whole frame. */
-	ops->poke_tx(ring, next_slot(ring, slot));
+	op32_poke_tx(ring, next_slot(ring, slot));
 	return 0;
 
 out_free_bounce:
@@ -1429,7 +1201,6 @@ out_unlock:
 void b43legacy_dma_handle_txstatus(struct b43legacy_wldev *dev,
 				 const struct b43legacy_txstatus *status)
 {
-	const struct b43legacy_dma_ops *ops;
 	struct b43legacy_dmaring *ring;
 	struct b43legacy_dmadesc_meta *meta;
 	int retry_limit;
@@ -1442,10 +1213,9 @@ void b43legacy_dma_handle_txstatus(struct b43legacy_wldev *dev,
 	spin_lock(&ring->lock);
 
 	B43legacy_WARN_ON(!ring->tx);
-	ops = ring->ops;
 	while (1) {
 		B43legacy_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
-		ops->idx2desc(ring, slot, &meta);
+		op32_idx2desc(ring, slot, &meta);
 
 		if (meta->skb)
 			unmap_descbuffer(ring, meta->dmaaddr,
@@ -1528,8 +1298,7 @@ void b43legacy_dma_handle_txstatus(struct b43legacy_wldev *dev,
 static void dma_rx(struct b43legacy_dmaring *ring,
 		   int *slot)
 {
-	const struct b43legacy_dma_ops *ops = ring->ops;
-	struct b43legacy_dmadesc_generic *desc;
+	struct b43legacy_dmadesc32 *desc;
 	struct b43legacy_dmadesc_meta *meta;
 	struct b43legacy_rxhdr_fw3 *rxhdr;
 	struct sk_buff *skb;
@@ -1537,7 +1306,7 @@ static void dma_rx(struct b43legacy_dmaring *ring,
 	int err;
 	dma_addr_t dmaaddr;
 
-	desc = ops->idx2desc(ring, *slot, &meta);
+	desc = op32_idx2desc(ring, *slot, &meta);
 
 	sync_descbuffer_for_cpu(ring, meta->dmaaddr, ring->rx_buffersize);
 	skb = meta->skb;
@@ -1589,7 +1358,7 @@ static void dma_rx(struct b43legacy_dmaring *ring,
 		s32 tmp = len;
 
 		while (1) {
-			desc = ops->idx2desc(ring, *slot, &meta);
+			desc = op32_idx2desc(ring, *slot, &meta);
 			/* recycle the descriptor buffer. */
 			sync_descbuffer_for_device(ring, meta->dmaaddr,
 						   ring->rx_buffersize);
@@ -1626,13 +1395,12 @@ drop:
 
 void b43legacy_dma_rx(struct b43legacy_dmaring *ring)
 {
-	const struct b43legacy_dma_ops *ops = ring->ops;
 	int slot;
 	int current_slot;
 	int used_slots = 0;
 
 	B43legacy_WARN_ON(ring->tx);
-	current_slot = ops->get_current_rxslot(ring);
+	current_slot = op32_get_current_rxslot(ring);
 	B43legacy_WARN_ON(!(current_slot >= 0 && current_slot <
 			   ring->nr_slots));
 
@@ -1641,7 +1409,7 @@ void b43legacy_dma_rx(struct b43legacy_dmaring *ring)
 		dma_rx(ring, &slot);
 		update_max_used_slots(ring, ++used_slots);
 	}
-	ops->set_current_rxslot(ring, slot);
+	op32_set_current_rxslot(ring, slot);
 	ring->current_slot = slot;
 }
 
@@ -1651,7 +1419,7 @@ static void b43legacy_dma_tx_suspend_ring(struct b43legacy_dmaring *ring)
 
 	spin_lock_irqsave(&ring->lock, flags);
 	B43legacy_WARN_ON(!ring->tx);
-	ring->ops->tx_suspend(ring);
+	op32_tx_suspend(ring);
 	spin_unlock_irqrestore(&ring->lock, flags);
 }
 
@@ -1661,7 +1429,7 @@ static void b43legacy_dma_tx_resume_ring(struct b43legacy_dmaring *ring)
 
 	spin_lock_irqsave(&ring->lock, flags);
 	B43legacy_WARN_ON(!ring->tx);
-	ring->ops->tx_resume(ring);
+	op32_tx_resume(ring);
 	spin_unlock_irqrestore(&ring->lock, flags);
 }
 
diff --git a/drivers/net/wireless/b43legacy/dma.h b/drivers/net/wireless/b43legacy/dma.h
index f89c342..04121ff 100644
--- a/drivers/net/wireless/b43legacy/dma.h
+++ b/drivers/net/wireless/b43legacy/dma.h
@@ -82,90 +82,6 @@ struct b43legacy_dmadesc32 {
 #define B43legacy_DMA32_DCTL_FRAMESTART		0x80000000
 
 
-
-/*** 64-bit DMA Engine. ***/
-
-/* 64-bit DMA controller registers. */
-#define B43legacy_DMA64_TXCTL				0x00
-#define		B43legacy_DMA64_TXENABLE		0x00000001
-#define		B43legacy_DMA64_TXSUSPEND		0x00000002
-#define		B43legacy_DMA64_TXLOOPBACK		0x00000004
-#define		B43legacy_DMA64_TXFLUSH			0x00000010
-#define		B43legacy_DMA64_TXADDREXT_MASK		0x00030000
-#define		B43legacy_DMA64_TXADDREXT_SHIFT		16
-#define B43legacy_DMA64_TXINDEX				0x04
-#define B43legacy_DMA64_TXRINGLO			0x08
-#define B43legacy_DMA64_TXRINGHI			0x0C
-#define B43legacy_DMA64_TXSTATUS			0x10
-#define		B43legacy_DMA64_TXSTATDPTR		0x00001FFF
-#define		B43legacy_DMA64_TXSTAT			0xF0000000
-#define			B43legacy_DMA64_TXSTAT_DISABLED	0x00000000
-#define			B43legacy_DMA64_TXSTAT_ACTIVE	0x10000000
-#define			B43legacy_DMA64_TXSTAT_IDLEWAIT	0x20000000
-#define			B43legacy_DMA64_TXSTAT_STOPPED	0x30000000
-#define			B43legacy_DMA64_TXSTAT_SUSP	0x40000000
-#define B43legacy_DMA64_TXERROR				0x14
-#define		B43legacy_DMA64_TXERRDPTR		0x0001FFFF
-#define		B43legacy_DMA64_TXERR			0xF0000000
-#define			B43legacy_DMA64_TXERR_NOERR	0x00000000
-#define			B43legacy_DMA64_TXERR_PROT	0x10000000
-#define			B43legacy_DMA64_TXERR_UNDERRUN	0x20000000
-#define			B43legacy_DMA64_TXERR_TRANSFER	0x30000000
-#define			B43legacy_DMA64_TXERR_DESCREAD	0x40000000
-#define			B43legacy_DMA64_TXERR_CORE	0x50000000
-#define B43legacy_DMA64_RXCTL				0x20
-#define		B43legacy_DMA64_RXENABLE		0x00000001
-#define		B43legacy_DMA64_RXFROFF_MASK		0x000000FE
-#define		B43legacy_DMA64_RXFROFF_SHIFT		1
-#define		B43legacy_DMA64_RXDIRECTFIFO		0x00000100
-#define		B43legacy_DMA64_RXADDREXT_MASK		0x00030000
-#define		B43legacy_DMA64_RXADDREXT_SHIFT		16
-#define B43legacy_DMA64_RXINDEX				0x24
-#define B43legacy_DMA64_RXRINGLO			0x28
-#define B43legacy_DMA64_RXRINGHI			0x2C
-#define B43legacy_DMA64_RXSTATUS			0x30
-#define		B43legacy_DMA64_RXSTATDPTR		0x00001FFF
-#define		B43legacy_DMA64_RXSTAT			0xF0000000
-#define			B43legacy_DMA64_RXSTAT_DISABLED	0x00000000
-#define			B43legacy_DMA64_RXSTAT_ACTIVE	0x10000000
-#define			B43legacy_DMA64_RXSTAT_IDLEWAIT	0x20000000
-#define			B43legacy_DMA64_RXSTAT_STOPPED	0x30000000
-#define			B43legacy_DMA64_RXSTAT_SUSP	0x40000000
-#define B43legacy_DMA64_RXERROR				0x34
-#define		B43legacy_DMA64_RXERRDPTR		0x0001FFFF
-#define		B43legacy_DMA64_RXERR			0xF0000000
-#define			B43legacy_DMA64_RXERR_NOERR	0x00000000
-#define			B43legacy_DMA64_RXERR_PROT	0x10000000
-#define			B43legacy_DMA64_RXERR_UNDERRUN	0x20000000
-#define			B43legacy_DMA64_RXERR_TRANSFER	0x30000000
-#define			B43legacy_DMA64_RXERR_DESCREAD	0x40000000
-#define			B43legacy_DMA64_RXERR_CORE	0x50000000
-
-/* 64-bit DMA descriptor. */
-struct b43legacy_dmadesc64 {
-	__le32 control0;
-	__le32 control1;
-	__le32 address_low;
-	__le32 address_high;
-} __packed;
-#define B43legacy_DMA64_DCTL0_DTABLEEND		0x10000000
-#define B43legacy_DMA64_DCTL0_IRQ		0x20000000
-#define B43legacy_DMA64_DCTL0_FRAMEEND		0x40000000
-#define B43legacy_DMA64_DCTL0_FRAMESTART	0x80000000
-#define B43legacy_DMA64_DCTL1_BYTECNT		0x00001FFF
-#define B43legacy_DMA64_DCTL1_ADDREXT_MASK	0x00030000
-#define B43legacy_DMA64_DCTL1_ADDREXT_SHIFT	16
-
-
-
-struct b43legacy_dmadesc_generic {
-	union {
-		struct b43legacy_dmadesc32 dma32;
-		struct b43legacy_dmadesc64 dma64;
-	} __packed;
-} __packed;
-
-
 /* Misc DMA constants */
 #define B43legacy_DMA_RINGMEMSIZE	PAGE_SIZE
 #define B43legacy_DMA0_RX_FRAMEOFFSET	30
@@ -197,35 +113,12 @@ struct b43legacy_dmadesc_meta {
 	bool is_last_fragment;
 };
 
-struct b43legacy_dmaring;
-
-/* Lowlevel DMA operations that differ between 32bit and 64bit DMA. */
-struct b43legacy_dma_ops {
-	struct b43legacy_dmadesc_generic * (*idx2desc)
-					   (struct b43legacy_dmaring *ring,
-					   int slot,
-					   struct b43legacy_dmadesc_meta
-					   **meta);
-	void (*fill_descriptor)(struct b43legacy_dmaring *ring,
-				struct b43legacy_dmadesc_generic *desc,
-				dma_addr_t dmaaddr, u16 bufsize,
-				int start, int end, int irq);
-	void (*poke_tx)(struct b43legacy_dmaring *ring, int slot);
-	void (*tx_suspend)(struct b43legacy_dmaring *ring);
-	void (*tx_resume)(struct b43legacy_dmaring *ring);
-	int (*get_current_rxslot)(struct b43legacy_dmaring *ring);
-	void (*set_current_rxslot)(struct b43legacy_dmaring *ring, int slot);
-};
-
 enum b43legacy_dmatype {
 	B43legacy_DMA_30BIT = 30,
 	B43legacy_DMA_32BIT = 32,
-	B43legacy_DMA_64BIT = 64,
 };
 
 struct b43legacy_dmaring {
-	/* Lowlevel DMA ops. */
-	const struct b43legacy_dma_ops *ops;
 	/* Kernel virtual base address of the ring memory. */
 	void *descbase;
 	/* Meta data about all descriptors. */
