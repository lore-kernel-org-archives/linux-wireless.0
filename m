Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:39628 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbXHBPx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 11:53:56 -0400
Date: Thu, 02 Aug 2007 10:53:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC 3/10] Port of bcm43xx from softmac to mac80211
Message-ID: <46b1fdf3.3PHik8B2qcQ78kAQ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This if file 3 of 10 of the port of the bcm43xx driver from softmac
to mac80211.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_dma.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_dma.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_dma.c
@@ -4,7 +4,7 @@
 
   DMA ringbuffer and descriptor allocation/management
 
-  Copyright (c) 2005, 2006 Michael Buesch <mbuesch@freenet.de>
+  Copyright (c) 2005, 2006 Michael Buesch <mb@bu3sch.de>
 
   Some code in this file is derived from the b44.c driver
   Copyright (C) 2002 David S. Miller
@@ -31,13 +31,213 @@
 #include "bcm43xx_dma.h"
 #include "bcm43xx_main.h"
 #include "bcm43xx_debugfs.h"
-#include "bcm43xx_power.h"
 #include "bcm43xx_xmit.h"
 
 #include <linux/dma-mapping.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/skbuff.h>
+#include <net/dst.h>
+
+/* 32bit DMA ops. */
+static
+struct bcm43xx_dmadesc_generic *op32_idx2desc(struct bcm43xx_dmaring *ring,
+					     int slot,
+					     struct bcm43xx_dmadesc_meta **meta)
+{
+	struct bcm43xx_dmadesc32 *desc;
+
+	*meta = &(ring->meta[slot]);
+	desc = ring->descbase;
+	desc = &(desc[slot]);
+
+	return (struct bcm43xx_dmadesc_generic *)desc;
+}
+
+static void op32_fill_descriptor(struct bcm43xx_dmaring *ring,
+				 struct bcm43xx_dmadesc_generic *desc,
+				 dma_addr_t dmaaddr, u16 bufsize,
+				 int start, int end, int irq)
+{
+	struct bcm43xx_dmadesc32 *descbase = ring->descbase;
+	int slot;
+	u32 ctl;
+	u32 addr;
+	u32 addrext;
+
+	slot = (int)(&(desc->dma32) - descbase);
+	BCM43xx_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
+
+	addr = (u32)(dmaaddr & ~SSB_DMA_TRANSLATION_MASK);
+	addrext = (u32)(dmaaddr & SSB_DMA_TRANSLATION_MASK)
+		   >> SSB_DMA_TRANSLATION_SHIFT;
+	addr |= ssb_dma_translation(ring->dev->dev);
+	ctl = (bufsize - ring->frameoffset)
+	      & BCM43xx_DMA32_DCTL_BYTECNT;
+	if (slot == ring->nr_slots - 1)
+		ctl |= BCM43xx_DMA32_DCTL_DTABLEEND;
+	if (start)
+		ctl |= BCM43xx_DMA32_DCTL_FRAMESTART;
+	if (end)
+		ctl |= BCM43xx_DMA32_DCTL_FRAMEEND;
+	if (irq)
+		ctl |= BCM43xx_DMA32_DCTL_IRQ;
+	ctl |= (addrext << BCM43xx_DMA32_DCTL_ADDREXT_SHIFT)
+	       & BCM43xx_DMA32_DCTL_ADDREXT_MASK;
+
+	desc->dma32.control = cpu_to_le32(ctl);
+	desc->dma32.address = cpu_to_le32(addr);
+}
+
+static void op32_poke_tx(struct bcm43xx_dmaring *ring, int slot)
+{
+	bcm43xx_dma_write(ring, BCM43xx_DMA32_TXINDEX,
+			  (u32)(slot * sizeof(struct bcm43xx_dmadesc32)));
+}
+
+static void op32_tx_suspend(struct bcm43xx_dmaring *ring)
+{
+	bcm43xx_dma_write(ring, BCM43xx_DMA32_TXCTL,
+			  bcm43xx_dma_read(ring, BCM43xx_DMA32_TXCTL)
+			  | BCM43xx_DMA32_TXSUSPEND);
+}
+
+static void op32_tx_resume(struct bcm43xx_dmaring *ring)
+{
+	bcm43xx_dma_write(ring, BCM43xx_DMA32_TXCTL,
+			  bcm43xx_dma_read(ring, BCM43xx_DMA32_TXCTL)
+			  & ~BCM43xx_DMA32_TXSUSPEND);
+}
+
+static int op32_get_current_rxslot(struct bcm43xx_dmaring *ring)
+{
+	u32 val;
+
+	val = bcm43xx_dma_read(ring, BCM43xx_DMA32_RXSTATUS);
+	val &= BCM43xx_DMA32_RXDPTR;
+
+	return (val / sizeof(struct bcm43xx_dmadesc32));
+}
+
+static void op32_set_current_rxslot(struct bcm43xx_dmaring *ring,
+				    int slot)
+{
+	bcm43xx_dma_write(ring, BCM43xx_DMA32_RXINDEX,
+			  (u32)(slot * sizeof(struct bcm43xx_dmadesc32)));
+}
+
+static const struct bcm43xx_dma_ops dma32_ops = {
+	.idx2desc		= op32_idx2desc,
+	.fill_descriptor	= op32_fill_descriptor,
+	.poke_tx		= op32_poke_tx,
+	.tx_suspend		= op32_tx_suspend,
+	.tx_resume		= op32_tx_resume,
+	.get_current_rxslot	= op32_get_current_rxslot,
+	.set_current_rxslot	= op32_set_current_rxslot,
+};
+
+/* 64bit DMA ops. */
+static
+struct bcm43xx_dmadesc_generic *op64_idx2desc(struct bcm43xx_dmaring *ring,
+					       int slot,
+					       struct bcm43xx_dmadesc_meta
+					       **meta)
+{
+	struct bcm43xx_dmadesc64 *desc;
+
+	*meta = &(ring->meta[slot]);
+	desc = ring->descbase;
+	desc = &(desc[slot]);
+
+	return (struct bcm43xx_dmadesc_generic *)desc;
+}
+
+static void op64_fill_descriptor(struct bcm43xx_dmaring *ring,
+				 struct bcm43xx_dmadesc_generic *desc,
+				 dma_addr_t dmaaddr, u16 bufsize,
+				 int start, int end, int irq)
+{
+	struct bcm43xx_dmadesc64 *descbase = ring->descbase;
+	int slot;
+	u32 ctl0 = 0i;
+	u32 ctl1 = 0;
+	u32 addrlo;
+	u32 addrhi;
+	u32 addrext;
+
+	slot = (int)(&(desc->dma64) - descbase);
+	BCM43xx_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
+
+	addrlo = (u32)(dmaaddr & 0xFFFFFFFF);
+	addrhi = (((u64)dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
+	addrext = (((u64)dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
+		  >> SSB_DMA_TRANSLATION_SHIFT;
+	addrhi |= ssb_dma_translation(ring->dev->dev);
+	if (slot == ring->nr_slots - 1)
+		ctl0 |= BCM43xx_DMA64_DCTL0_DTABLEEND;
+	if (start)
+		ctl0 |= BCM43xx_DMA64_DCTL0_FRAMESTART;
+	if (end)
+		ctl0 |= BCM43xx_DMA64_DCTL0_FRAMEEND;
+	if (irq)
+		ctl0 |= BCM43xx_DMA64_DCTL0_IRQ;
+	ctl1 |= (bufsize - ring->frameoffset)
+		& BCM43xx_DMA64_DCTL1_BYTECNT;
+	ctl1 |= (addrext << BCM43xx_DMA64_DCTL1_ADDREXT_SHIFT)
+		& BCM43xx_DMA64_DCTL1_ADDREXT_MASK;
+
+	desc->dma64.control0 = cpu_to_le32(ctl0);
+	desc->dma64.control1 = cpu_to_le32(ctl1);
+	desc->dma64.address_low = cpu_to_le32(addrlo);
+	desc->dma64.address_high = cpu_to_le32(addrhi);
+}
+
+static void op64_poke_tx(struct bcm43xx_dmaring *ring, int slot)
+{
+	bcm43xx_dma_write(ring, BCM43xx_DMA64_TXINDEX,
+			  (u32)(slot * sizeof(struct bcm43xx_dmadesc64)));
+}
+
+static void op64_tx_suspend(struct bcm43xx_dmaring *ring)
+{
+	bcm43xx_dma_write(ring, BCM43xx_DMA64_TXCTL,
+			  bcm43xx_dma_read(ring, BCM43xx_DMA64_TXCTL)
+			  | BCM43xx_DMA64_TXSUSPEND);
+}
+
+static void op64_tx_resume(struct bcm43xx_dmaring *ring)
+{
+	bcm43xx_dma_write(ring, BCM43xx_DMA64_TXCTL,
+			  bcm43xx_dma_read(ring, BCM43xx_DMA64_TXCTL)
+			  & ~BCM43xx_DMA64_TXSUSPEND);
+}
+
+static int op64_get_current_rxslot(struct bcm43xx_dmaring *ring)
+{
+	u32 val;
+
+	val = bcm43xx_dma_read(ring, BCM43xx_DMA64_RXSTATUS);
+	val &= BCM43xx_DMA64_RXSTATDPTR;
+
+	return (val / sizeof(struct bcm43xx_dmadesc64));
+}
+
+static void op64_set_current_rxslot(struct bcm43xx_dmaring *ring,
+				    int slot)
+{
+	bcm43xx_dma_write(ring, BCM43xx_DMA64_RXINDEX,
+			  (u32)(slot * sizeof(struct bcm43xx_dmadesc64)));
+}
+
+static const struct bcm43xx_dma_ops dma64_ops = {
+	.idx2desc		= op64_idx2desc,
+	.fill_descriptor	= op64_fill_descriptor,
+	.poke_tx		= op64_poke_tx,
+	.tx_suspend		= op64_tx_suspend,
+	.tx_resume		= op64_tx_resume,
+	.get_current_rxslot	= op64_get_current_rxslot,
+	.set_current_rxslot	= op64_set_current_rxslot,
+};
 
 
 static inline int free_slots(struct bcm43xx_dmaring *ring)
@@ -47,7 +247,7 @@ static inline int free_slots(struct bcm4
 
 static inline int next_slot(struct bcm43xx_dmaring *ring, int slot)
 {
-	assert(slot >= -1 && slot <= ring->nr_slots - 1);
+	BCM43xx_WARN_ON(!(slot >= -1 && slot <= ring->nr_slots - 1));
 	if (slot == ring->nr_slots - 1)
 		return 0;
 	return slot + 1;
@@ -55,60 +255,102 @@ static inline int next_slot(struct bcm43
 
 static inline int prev_slot(struct bcm43xx_dmaring *ring, int slot)
 {
-	assert(slot >= 0 && slot <= ring->nr_slots - 1);
+	BCM43xx_WARN_ON(!(slot >= 0 && slot <= ring->nr_slots - 1));
 	if (slot == 0)
 		return ring->nr_slots - 1;
 	return slot - 1;
 }
 
+#ifdef CONFIG_BCM43XX_DEBUG
+static void update_max_used_slots(struct bcm43xx_dmaring *ring,
+				  int current_used_slots)
+{
+	if (current_used_slots <= ring->max_used_slots)
+		return;
+	ring->max_used_slots = current_used_slots;
+	if (bcm43xx_debug(ring->dev, BCM43xx_DBG_DMAVERBOSE))
+		bcmdbg(ring->dev->wl,
+		       "max_used_slots increased to %d on %s ring %d\n",
+		       ring->max_used_slots,
+		       ring->tx ? "TX" : "RX",
+		       ring->index);
+}
+#else
+static inline
+void update_max_used_slots(struct bcm43xx_dmaring *ring,
+			   int current_used_slots)
+{ }
+#endif /* DEBUG */
+
 /* Request a slot for usage. */
 static inline
 int request_slot(struct bcm43xx_dmaring *ring)
 {
 	int slot;
 
-	assert(ring->tx);
-	assert(!ring->suspended);
-	assert(free_slots(ring) != 0);
+	BCM43xx_WARN_ON(!ring->tx);
+	BCM43xx_WARN_ON(ring->stopped);
+	BCM43xx_WARN_ON(free_slots(ring) == 0);
 
 	slot = next_slot(ring, ring->current_slot);
 	ring->current_slot = slot;
 	ring->used_slots++;
 
-	/* Check the number of available slots and suspend TX,
-	 * if we are running low on free slots.
-	 */
-	if (unlikely(free_slots(ring) < ring->suspend_mark)) {
-		netif_stop_queue(ring->bcm->net_dev);
-		ring->suspended = 1;
-	}
-#ifdef CONFIG_BCM43XX_DEBUG
-	if (ring->used_slots > ring->max_used_slots)
-		ring->max_used_slots = ring->used_slots;
-#endif /* CONFIG_BCM43XX_DEBUG*/
+	update_max_used_slots(ring, ring->used_slots);
 
 	return slot;
 }
 
-/* Return a slot to the free slots. */
-static inline
-void return_slot(struct bcm43xx_dmaring *ring, int slot)
+/* Mac80211-queue to bcm43xx-ring mapping */
+static struct bcm43xx_dmaring *priority_to_txring(struct bcm43xx_wldev *dev,
+						   int queue_priority)
 {
-	assert(ring->tx);
+	struct bcm43xx_dmaring *ring;
 
-	ring->used_slots--;
+/*FIXME: For now we always run on TX-ring-1 */
+return dev->dma.tx_ring1;
 
-	/* Check if TX is suspended and check if we have
-	 * enough free slots to resume it again.
-	 */
-	if (unlikely(ring->suspended)) {
-		if (free_slots(ring) >= ring->resume_mark) {
-			ring->suspended = 0;
-			netif_wake_queue(ring->bcm->net_dev);
-		}
+	/* 0 = highest priority */
+	switch (queue_priority) {
+	default:
+		BCM43xx_WARN_ON(1);
+		/* fallthrough */
+	case 0:
+		ring = dev->dma.tx_ring3;
+		break;
+	case 1:
+		ring = dev->dma.tx_ring2;
+		break;
+	case 2:
+		ring = dev->dma.tx_ring1;
+		break;
+	case 3:
+		ring = dev->dma.tx_ring0;
+		break;
+	case 4:
+		ring = dev->dma.tx_ring4;
+		break;
+	case 5:
+		ring = dev->dma.tx_ring5;
+		break;
 	}
+
+	return ring;
 }
 
+/* Bcm4301-ring to mac80211-queue mapping */
+static inline int txring_to_priority(struct bcm43xx_dmaring *ring)
+{
+	static const u8 idx_to_prio[] =
+		{ 3, 2, 1, 0, 4, 5, };
+
+/*FIXME: have only one queue, for now */
+return 0;
+
+	return idx_to_prio[ring->index];
+}
+
+
 u16 bcm43xx_dmacontroller_base(int dma64bit, int controller_idx)
 {
 	static const u16 map64[] = {
@@ -129,12 +371,12 @@ u16 bcm43xx_dmacontroller_base(int dma64
 	};
 
 	if (dma64bit) {
-		assert(controller_idx >= 0 &&
-		       controller_idx < ARRAY_SIZE(map64));
+		BCM43xx_WARN_ON(!(controller_idx >= 0 &&
+		       controller_idx < ARRAY_SIZE(map64)));
 		return map64[controller_idx];
 	}
-	assert(controller_idx >= 0 &&
-	       controller_idx < ARRAY_SIZE(map32));
+	BCM43xx_WARN_ON(!(controller_idx >= 0 &&
+	       controller_idx < ARRAY_SIZE(map32)));
 	return map32[controller_idx];
 }
 
@@ -145,14 +387,15 @@ dma_addr_t map_descbuffer(struct bcm43xx
 			  int tx)
 {
 	dma_addr_t dmaaddr;
-	int direction = PCI_DMA_FROMDEVICE;
 
 	if (tx)
-		direction = PCI_DMA_TODEVICE;
-
-	dmaaddr = pci_map_single(ring->bcm->pci_dev,
+		dmaaddr = dma_map_single(ring->dev->dev->dev,
+					 buf, len,
+					 DMA_TO_DEVICE);
+	else
+		dmaaddr = dma_map_single(ring->dev->dev->dev,
 					 buf, len,
-					 direction);
+					 DMA_FROM_DEVICE);
 
 	return dmaaddr;
 }
@@ -164,13 +407,13 @@ void unmap_descbuffer(struct bcm43xx_dma
 		      int tx)
 {
 	if (tx) {
-		pci_unmap_single(ring->bcm->pci_dev,
+		dma_unmap_single(ring->dev->dev->dev,
 				 addr, len,
-				 PCI_DMA_TODEVICE);
+				 DMA_TO_DEVICE);
 	} else {
-		pci_unmap_single(ring->bcm->pci_dev,
+		dma_unmap_single(ring->dev->dev->dev,
 				 addr, len,
-				 PCI_DMA_FROMDEVICE);
+				 DMA_FROM_DEVICE);
 	}
 }
 
@@ -179,10 +422,10 @@ void sync_descbuffer_for_cpu(struct bcm4
 			     dma_addr_t addr,
 			     size_t len)
 {
-	assert(!ring->tx);
+	BCM43xx_WARN_ON(ring->tx);
 
-	pci_dma_sync_single_for_cpu(ring->bcm->pci_dev,
-				    addr, len, PCI_DMA_FROMDEVICE);
+	dma_sync_single_for_cpu(ring->dev->dev->dev,
+				addr, len, DMA_FROM_DEVICE);
 }
 
 static inline
@@ -190,98 +433,64 @@ void sync_descbuffer_for_device(struct b
 				dma_addr_t addr,
 				size_t len)
 {
-	assert(!ring->tx);
+	BCM43xx_WARN_ON(ring->tx);
 
-	pci_dma_sync_single_for_cpu(ring->bcm->pci_dev,
-				    addr, len, PCI_DMA_TODEVICE);
+	dma_sync_single_for_device(ring->dev->dev->dev,
+				   addr, len, DMA_FROM_DEVICE);
 }
 
-/* Unmap and free a descriptor buffer. */
 static inline
 void free_descriptor_buffer(struct bcm43xx_dmaring *ring,
 			    struct bcm43xx_dmadesc_meta *meta,
 			    int irq_context)
 {
-	assert(meta->skb);
-	if (irq_context)
-		dev_kfree_skb_irq(meta->skb);
-	else
-		dev_kfree_skb(meta->skb);
-	meta->skb = NULL;
+	if (meta->skb) {
+		if (irq_context)
+			dev_kfree_skb_irq(meta->skb);
+		else
+			dev_kfree_skb(meta->skb);
+		meta->skb = NULL;
+	}
 }
 
 static int alloc_ringmemory(struct bcm43xx_dmaring *ring)
 {
-	ring->descbase = pci_alloc_consistent(ring->bcm->pci_dev, BCM43xx_DMA_RINGMEMSIZE,
-					    &(ring->dmabase));
-	if (!ring->descbase) {
-		/* Allocation may have failed due to pci_alloc_consistent
-		   insisting on use of GFP_DMA, which is more restrictive
-		   than necessary...  */
-		struct dma_desc *rx_ring;
-		dma_addr_t rx_ring_dma;
-
-		rx_ring = kzalloc(BCM43xx_DMA_RINGMEMSIZE, GFP_KERNEL);
-		if (!rx_ring)
-			goto out_err;
-
-		rx_ring_dma = pci_map_single(ring->bcm->pci_dev, rx_ring,
-					     BCM43xx_DMA_RINGMEMSIZE,
-					     PCI_DMA_BIDIRECTIONAL);
-
-		if (pci_dma_mapping_error(rx_ring_dma) ||
-		    rx_ring_dma + BCM43xx_DMA_RINGMEMSIZE > ring->bcm->dma_mask) {
-			/* Sigh... */
-			if (!pci_dma_mapping_error(rx_ring_dma))
-				pci_unmap_single(ring->bcm->pci_dev,
-						 rx_ring_dma, BCM43xx_DMA_RINGMEMSIZE,
-						 PCI_DMA_BIDIRECTIONAL);
-			rx_ring_dma = pci_map_single(ring->bcm->pci_dev,
-						 rx_ring, BCM43xx_DMA_RINGMEMSIZE,
-						 PCI_DMA_BIDIRECTIONAL);
-			if (pci_dma_mapping_error(rx_ring_dma) ||
-			    rx_ring_dma + BCM43xx_DMA_RINGMEMSIZE > ring->bcm->dma_mask) {
-				assert(0);
-				if (!pci_dma_mapping_error(rx_ring_dma))
-					pci_unmap_single(ring->bcm->pci_dev,
-							 rx_ring_dma, BCM43xx_DMA_RINGMEMSIZE,
-							 PCI_DMA_BIDIRECTIONAL);
-				goto out_err;
-			}
-                }
+	struct device *dev = ring->dev->dev->dev;
 
-                ring->descbase = rx_ring;
-                ring->dmabase = rx_ring_dma;
+	ring->descbase = dma_alloc_coherent(dev, BCM43xx_DMA_RINGMEMSIZE,
+					    &(ring->dmabase), GFP_KERNEL);
+	if (!ring->descbase) {
+		bcmerr(ring->dev->wl, "DMA ringmemory allocation failed\n");
+		return -ENOMEM;
 	}
 	memset(ring->descbase, 0, BCM43xx_DMA_RINGMEMSIZE);
 
 	return 0;
-out_err:
-	printk(KERN_ERR PFX "DMA ringmemory allocation failed\n");
-	return -ENOMEM;
 }
 
 static void free_ringmemory(struct bcm43xx_dmaring *ring)
 {
-	struct device *dev = &(ring->bcm->pci_dev->dev);
+	struct device *dev = ring->dev->dev->dev;
 
 	dma_free_coherent(dev, BCM43xx_DMA_RINGMEMSIZE,
 			  ring->descbase, ring->dmabase);
 }
 
 /* Reset the RX DMA channel */
-int bcm43xx_dmacontroller_rx_reset(struct bcm43xx_private *bcm,
+int bcm43xx_dmacontroller_rx_reset(struct bcm43xx_wldev *dev,
 				   u16 mmio_base, int dma64)
 {
 	int i;
 	u32 value;
 	u16 offset;
 
+	might_sleep();
+
 	offset = dma64 ? BCM43xx_DMA64_RXCTL : BCM43xx_DMA32_RXCTL;
-	bcm43xx_write32(bcm, mmio_base + offset, 0);
-	for (i = 0; i < 1000; i++) {
+	bcm43xx_write32(dev, mmio_base + offset, 0);
+	for (i = 0; i < 10; i++) {
 		offset = dma64 ? BCM43xx_DMA64_RXSTATUS : BCM43xx_DMA32_RXSTATUS;
-		value = bcm43xx_read32(bcm, mmio_base + offset);
+		value = bcm43xx_read32(dev, mmio_base + offset);
 		if (dma64) {
 			value &= BCM43xx_DMA64_RXSTAT;
 			if (value == BCM43xx_DMA64_RXSTAT_DISABLED) {
@@ -295,10 +504,10 @@ int bcm43xx_dmacontroller_rx_reset(struc
 				break;
 			}
 		}
-		udelay(10);
+		msleep(1);
 	}
 	if (i != -1) {
-		printk(KERN_ERR PFX "Error: Wait on DMA RX status timed out.\n");
+		bcmerr(dev->wl, "DMA RX reset timed out\n");
 		return -ENODEV;
 	}
 
@@ -306,16 +515,18 @@ int bcm43xx_dmacontroller_rx_reset(struc
 }
 
 /* Reset the RX DMA channel */
-int bcm43xx_dmacontroller_tx_reset(struct bcm43xx_private *bcm,
+int bcm43xx_dmacontroller_tx_reset(struct bcm43xx_wldev *dev,
 				   u16 mmio_base, int dma64)
 {
 	int i;
 	u32 value;
 	u16 offset;
 
-	for (i = 0; i < 1000; i++) {
+	might_sleep();
+
+	for (i = 0; i < 10; i++) {
 		offset = dma64 ? BCM43xx_DMA64_TXSTATUS : BCM43xx_DMA32_TXSTATUS;
-		value = bcm43xx_read32(bcm, mmio_base + offset);
+		value = bcm43xx_read32(dev, mmio_base + offset);
 		if (dma64) {
 			value &= BCM43xx_DMA64_TXSTAT;
 			if (value == BCM43xx_DMA64_TXSTAT_DISABLED ||
@@ -329,13 +540,13 @@ int bcm43xx_dmacontroller_tx_reset(struc
 			    value == BCM43xx_DMA32_TXSTAT_STOPPED)
 				break;
 		}
-		udelay(10);
+		msleep(1);
 	}
 	offset = dma64 ? BCM43xx_DMA64_TXCTL : BCM43xx_DMA32_TXCTL;
-	bcm43xx_write32(bcm, mmio_base + offset, 0);
-	for (i = 0; i < 1000; i++) {
+	bcm43xx_write32(dev, mmio_base + offset, 0);
+	for (i = 0; i < 10; i++) {
 		offset = dma64 ? BCM43xx_DMA64_TXSTATUS : BCM43xx_DMA32_TXSTATUS;
-		value = bcm43xx_read32(bcm, mmio_base + offset);
+		value = bcm43xx_read32(dev, mmio_base + offset);
 		if (dma64) {
 			value &= BCM43xx_DMA64_TXSTAT;
 			if (value == BCM43xx_DMA64_TXSTAT_DISABLED) {
@@ -349,133 +560,62 @@ int bcm43xx_dmacontroller_tx_reset(struc
 				break;
 			}
 		}
-		udelay(10);
+		msleep(1);
 	}
 	if (i != -1) {
-		printk(KERN_ERR PFX "Error: Wait on DMA TX status timed out.\n");
+		bcmerr(dev->wl, "DMA TX reset timed out\n");
 		return -ENODEV;
 	}
 	/* ensure the reset is completed. */
-	udelay(300);
+	msleep(1);
 
 	return 0;
 }
 
-static void fill_descriptor(struct bcm43xx_dmaring *ring,
-			    struct bcm43xx_dmadesc_generic *desc,
-			    dma_addr_t dmaaddr,
-			    u16 bufsize,
-			    int start, int end, int irq)
-{
-	int slot;
-
-	slot = bcm43xx_dma_desc2idx(ring, desc);
-	assert(slot >= 0 && slot < ring->nr_slots);
-
-	if (ring->dma64) {
-		u32 ctl0 = 0, ctl1 = 0;
-		u32 addrlo, addrhi;
-		u32 addrext;
-
-		addrlo = (u32)(dmaaddr & 0xFFFFFFFF);
-		addrhi = (((u64)dmaaddr >> 32) & ~BCM43xx_DMA64_ROUTING);
-		addrext = (((u64)dmaaddr >> 32) >> BCM43xx_DMA64_ROUTING_SHIFT);
-		addrhi |= ring->routing;
-		if (slot == ring->nr_slots - 1)
-			ctl0 |= BCM43xx_DMA64_DCTL0_DTABLEEND;
-		if (start)
-			ctl0 |= BCM43xx_DMA64_DCTL0_FRAMESTART;
-		if (end)
-			ctl0 |= BCM43xx_DMA64_DCTL0_FRAMEEND;
-		if (irq)
-			ctl0 |= BCM43xx_DMA64_DCTL0_IRQ;
-		ctl1 |= (bufsize - ring->frameoffset)
-			& BCM43xx_DMA64_DCTL1_BYTECNT;
-		ctl1 |= (addrext << BCM43xx_DMA64_DCTL1_ADDREXT_SHIFT)
-			& BCM43xx_DMA64_DCTL1_ADDREXT_MASK;
-
-		desc->dma64.control0 = cpu_to_le32(ctl0);
-		desc->dma64.control1 = cpu_to_le32(ctl1);
-		desc->dma64.address_low = cpu_to_le32(addrlo);
-		desc->dma64.address_high = cpu_to_le32(addrhi);
-	} else {
-		u32 ctl;
-		u32 addr;
-		u32 addrext;
-
-		addr = (u32)(dmaaddr & ~BCM43xx_DMA32_ROUTING);
-		addrext = (u32)(dmaaddr & BCM43xx_DMA32_ROUTING)
-			   >> BCM43xx_DMA32_ROUTING_SHIFT;
-		addr |= ring->routing;
-		ctl = (bufsize - ring->frameoffset)
-		      & BCM43xx_DMA32_DCTL_BYTECNT;
-		if (slot == ring->nr_slots - 1)
-			ctl |= BCM43xx_DMA32_DCTL_DTABLEEND;
-		if (start)
-			ctl |= BCM43xx_DMA32_DCTL_FRAMESTART;
-		if (end)
-			ctl |= BCM43xx_DMA32_DCTL_FRAMEEND;
-		if (irq)
-			ctl |= BCM43xx_DMA32_DCTL_IRQ;
-		ctl |= (addrext << BCM43xx_DMA32_DCTL_ADDREXT_SHIFT)
-		       & BCM43xx_DMA32_DCTL_ADDREXT_MASK;
-
-		desc->dma32.control = cpu_to_le32(ctl);
-		desc->dma32.address = cpu_to_le32(addr);
-	}
-}
-
 static int setup_rx_descbuffer(struct bcm43xx_dmaring *ring,
 			       struct bcm43xx_dmadesc_generic *desc,
 			       struct bcm43xx_dmadesc_meta *meta,
 			       gfp_t gfp_flags)
 {
-	struct bcm43xx_rxhdr *rxhdr;
-	struct bcm43xx_hwxmitstatus *xmitstat;
+	struct bcm43xx_rxhdr_fw3 *rxhdr;
+	struct bcm43xx_hwtxstatus *txstat;
 	dma_addr_t dmaaddr;
 	struct sk_buff *skb;
 
-	assert(!ring->tx);
+	BCM43xx_WARN_ON(ring->tx);
 
 	skb = __dev_alloc_skb(ring->rx_buffersize, gfp_flags);
 	if (unlikely(!skb))
 		return -ENOMEM;
-	dmaaddr = map_descbuffer(ring, skb->data, ring->rx_buffersize, 0);
-	/* This hardware bug work-around adapted from the b44 driver.
-	   The chip may be unable to do PCI DMA to/from anything above 1GB */
-	if (pci_dma_mapping_error(dmaaddr) ||
-	    dmaaddr + ring->rx_buffersize > ring->bcm->dma_mask) {
-		/* This one has 30-bit addressing... */
-		if (!pci_dma_mapping_error(dmaaddr))
-			pci_unmap_single(ring->bcm->pci_dev,
-					 dmaaddr, ring->rx_buffersize,
-					 PCI_DMA_FROMDEVICE);
+	dmaaddr = map_descbuffer(ring, skb->data,
+				 ring->rx_buffersize, 0);
+	if (dma_mapping_error(dmaaddr)) {
+		/* ugh. try to realloc in zone_dma */
+		gfp_flags |= GFP_DMA;
+
 		dev_kfree_skb_any(skb);
-		skb = __dev_alloc_skb(ring->rx_buffersize,GFP_DMA);
-		if (skb == NULL)
-			return -ENOMEM;
-		dmaaddr = pci_map_single(ring->bcm->pci_dev,
-					 skb->data, ring->rx_buffersize,
-					 PCI_DMA_FROMDEVICE);
-		if (pci_dma_mapping_error(dmaaddr) ||
-		    dmaaddr + ring->rx_buffersize > ring->bcm->dma_mask) {
-			assert(0);
-			dev_kfree_skb_any(skb);
+
+		skb = __dev_alloc_skb(ring->rx_buffersize, gfp_flags);
+		if (unlikely(!skb))
 			return -ENOMEM;
-		}
+		dmaaddr = map_descbuffer(ring, skb->data,
+					 ring->rx_buffersize, 0);
 	}
+
+	if (dma_mapping_error(dmaaddr)) {
+		dev_kfree_skb_any(skb);
+		return -EIO;
+	}
+
 	meta->skb = skb;
 	meta->dmaaddr = dmaaddr;
-	skb->dev = ring->bcm->net_dev;
+	ring->ops->fill_descriptor(ring, desc, dmaaddr,
+				   ring->rx_buffersize, 0, 0, 0);
 
-	fill_descriptor(ring, desc, dmaaddr,
-			ring->rx_buffersize, 0, 0, 0);
-
-	rxhdr = (struct bcm43xx_rxhdr *)(skb->data);
-	rxhdr->frame_length = 0;
-	rxhdr->flags1 = 0;
-	xmitstat = (struct bcm43xx_hwxmitstatus *)(skb->data);
-	xmitstat->cookie = 0;
+	rxhdr = (struct bcm43xx_rxhdr_fw3 *)(skb->data);
+	rxhdr->frame_len = 0;
+	txstat = (struct bcm43xx_hwtxstatus *)(skb->data);
+	txstat->cookie = 0;
 
 	return 0;
 }
@@ -490,11 +630,14 @@ static int alloc_initial_descbuffers(str
 	struct bcm43xx_dmadesc_meta *meta;
 
 	for (i = 0; i < ring->nr_slots; i++) {
-		desc = bcm43xx_dma_idx2desc(ring, i, &meta);
+		desc = ring->ops->idx2desc(ring, i, &meta);
 
 		err = setup_rx_descbuffer(ring, desc, meta, GFP_KERNEL);
-		if (err)
+		if (err) {
+			bcmerr(ring->dev->wl,
+			       "Failed to allocate initial descbuffers\n");
 			goto err_unwind;
+		}
 	}
 	mb();
 	ring->used_slots = ring->nr_slots;
@@ -504,7 +647,7 @@ out:
 
 err_unwind:
 	for (i--; i >= 0; i--) {
-		desc = bcm43xx_dma_idx2desc(ring, i, &meta);
+		desc = ring->ops->idx2desc(ring, i, &meta);
 
 		unmap_descbuffer(ring, meta->dmaaddr, ring->rx_buffersize, 0);
 		dev_kfree_skb(meta->skb);
@@ -521,12 +664,14 @@ static int dmacontroller_setup(struct bc
 	int err = 0;
 	u32 value;
 	u32 addrext;
+	u32 trans = ssb_dma_translation(ring->dev->dev);
 
 	if (ring->tx) {
 		if (ring->dma64) {
 			u64 ringbase = (u64)(ring->dmabase);
 
-			addrext = ((ringbase >> 32) >> BCM43xx_DMA64_ROUTING_SHIFT);
+			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
+				  >> SSB_DMA_TRANSLATION_SHIFT;
 			value = BCM43xx_DMA64_TXENABLE;
 			value |= (addrext << BCM43xx_DMA64_TXADDREXT_SHIFT)
 				& BCM43xx_DMA64_TXADDREXT_MASK;
@@ -534,19 +679,21 @@ static int dmacontroller_setup(struct bc
 			bcm43xx_dma_write(ring, BCM43xx_DMA64_TXRINGLO,
 					(ringbase & 0xFFFFFFFF));
 			bcm43xx_dma_write(ring, BCM43xx_DMA64_TXRINGHI,
-					((ringbase >> 32) & ~BCM43xx_DMA64_ROUTING)
-					| ring->routing);
+					((ringbase >> 32)
+					& ~SSB_DMA_TRANSLATION_MASK)
+					| trans);
 		} else {
 			u32 ringbase = (u32)(ring->dmabase);
 
-			addrext = (ringbase >> BCM43xx_DMA32_ROUTING_SHIFT);
+			addrext = (ringbase & SSB_DMA_TRANSLATION_MASK)
+				  >> SSB_DMA_TRANSLATION_SHIFT;
 			value = BCM43xx_DMA32_TXENABLE;
 			value |= (addrext << BCM43xx_DMA32_TXADDREXT_SHIFT)
 				& BCM43xx_DMA32_TXADDREXT_MASK;
 			bcm43xx_dma_write(ring, BCM43xx_DMA32_TXCTL, value);
 			bcm43xx_dma_write(ring, BCM43xx_DMA32_TXRING,
-					(ringbase & ~BCM43xx_DMA32_ROUTING)
-					| ring->routing);
+					(ringbase & ~SSB_DMA_TRANSLATION_MASK)
+					| trans);
 		}
 	} else {
 		err = alloc_initial_descbuffers(ring);
@@ -555,7 +702,8 @@ static int dmacontroller_setup(struct bc
 		if (ring->dma64) {
 			u64 ringbase = (u64)(ring->dmabase);
 
-			addrext = ((ringbase >> 32) >> BCM43xx_DMA64_ROUTING_SHIFT);
+			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
+				  >> SSB_DMA_TRANSLATION_SHIFT;
 			value = (ring->frameoffset << BCM43xx_DMA64_RXFROFF_SHIFT);
 			value |= BCM43xx_DMA64_RXENABLE;
 			value |= (addrext << BCM43xx_DMA64_RXADDREXT_SHIFT)
@@ -564,21 +712,22 @@ static int dmacontroller_setup(struct bc
 			bcm43xx_dma_write(ring, BCM43xx_DMA64_RXRINGLO,
 					(ringbase & 0xFFFFFFFF));
 			bcm43xx_dma_write(ring, BCM43xx_DMA64_RXRINGHI,
-					((ringbase >> 32) & ~BCM43xx_DMA64_ROUTING)
-					| ring->routing);
+					((ringbase >> 32) &
+					~SSB_DMA_TRANSLATION_MASK) | trans);
 			bcm43xx_dma_write(ring, BCM43xx_DMA64_RXINDEX, 200);
 		} else {
 			u32 ringbase = (u32)(ring->dmabase);
 
-			addrext = (ringbase >> BCM43xx_DMA32_ROUTING_SHIFT);
+			addrext = (ringbase & SSB_DMA_TRANSLATION_MASK)
+				  >> SSB_DMA_TRANSLATION_SHIFT;
 			value = (ring->frameoffset << BCM43xx_DMA32_RXFROFF_SHIFT);
 			value |= BCM43xx_DMA32_RXENABLE;
 			value |= (addrext << BCM43xx_DMA32_RXADDREXT_SHIFT)
 				& BCM43xx_DMA32_RXADDREXT_MASK;
 			bcm43xx_dma_write(ring, BCM43xx_DMA32_RXCTL, value);
 			bcm43xx_dma_write(ring, BCM43xx_DMA32_RXRING,
-					(ringbase & ~BCM43xx_DMA32_ROUTING)
-					| ring->routing);
+					(ringbase & ~SSB_DMA_TRANSLATION_MASK)
+					| trans);
 			bcm43xx_dma_write(ring, BCM43xx_DMA32_RXINDEX, 200);
 		}
 	}
@@ -591,19 +740,23 @@ out:
 static void dmacontroller_cleanup(struct bcm43xx_dmaring *ring)
 {
 	if (ring->tx) {
-		bcm43xx_dmacontroller_tx_reset(ring->bcm, ring->mmio_base, ring->dma64);
+		bcm43xx_dmacontroller_tx_reset(ring->dev, ring->mmio_base,
+					       ring->dma64);
 		if (ring->dma64) {
 			bcm43xx_dma_write(ring, BCM43xx_DMA64_TXRINGLO, 0);
 			bcm43xx_dma_write(ring, BCM43xx_DMA64_TXRINGHI, 0);
-		} else
+		} else {
 			bcm43xx_dma_write(ring, BCM43xx_DMA32_TXRING, 0);
+		}
 	} else {
-		bcm43xx_dmacontroller_rx_reset(ring->bcm, ring->mmio_base, ring->dma64);
+		bcm43xx_dmacontroller_rx_reset(ring->dev, ring->mmio_base,
+					       ring->dma64);
 		if (ring->dma64) {
 			bcm43xx_dma_write(ring, BCM43xx_DMA64_RXRINGLO, 0);
 			bcm43xx_dma_write(ring, BCM43xx_DMA64_RXRINGHI, 0);
-		} else
+		} else {
 			bcm43xx_dma_write(ring, BCM43xx_DMA32_RXRING, 0);
+		}
 	}
 }
 
@@ -616,10 +769,10 @@ static void free_all_descbuffers(struct 
 	if (!ring->used_slots)
 		return;
 	for (i = 0; i < ring->nr_slots; i++) {
-		desc = bcm43xx_dma_idx2desc(ring, i, &meta);
+		desc = ring->ops->idx2desc(ring, i, &meta);
 
 		if (!meta->skb) {
-			assert(ring->tx);
+			BCM43xx_WARN_ON(!ring->tx);
 			continue;
 		}
 		if (ring->tx) {
@@ -633,9 +786,29 @@ static void free_all_descbuffers(struct 
 	}
 }
 
+static u64 supported_dma_mask(struct bcm43xx_wldev *dev)
+{
+	u32 tmp;
+	u16 mmio_base;
+
+	tmp = bcm43xx_read32(dev, SSB_TMSHIGH);
+	if (tmp & SSB_TMSHIGH_DMA64)
+		return DMA_64BIT_MASK;
+	mmio_base = bcm43xx_dmacontroller_base(0, 0);
+	bcm43xx_write32(dev,
+			mmio_base + BCM43xx_DMA32_TXCTL,
+			BCM43xx_DMA32_TXADDREXT_MASK);
+	tmp = bcm43xx_read32(dev,
+			     mmio_base + BCM43xx_DMA32_TXCTL);
+	if (tmp & BCM43xx_DMA32_TXADDREXT_MASK)
+		return DMA_32BIT_MASK;
+
+	return DMA_30BIT_MASK;
+}
+
 /* Main initialization function. */
 static
-struct bcm43xx_dmaring * bcm43xx_setup_dmaring(struct bcm43xx_private *bcm,
+struct bcm43xx_dmaring *bcm43xx_setup_dmaring(struct bcm43xx_wldev *dev,
 					       int controller_index,
 					       int for_tx,
 					       int dma64)
@@ -643,6 +816,7 @@ struct bcm43xx_dmaring * bcm43xx_setup_d
 	struct bcm43xx_dmaring *ring;
 	int err;
 	int nr_slots;
+	dma_addr_t dma_test;
 
 	ring = kzalloc(sizeof(*ring), GFP_KERNEL);
 	if (!ring)
@@ -656,19 +830,51 @@ struct bcm43xx_dmaring * bcm43xx_setup_d
 			     GFP_KERNEL);
 	if (!ring->meta)
 		goto err_kfree_ring;
+	if (for_tx) {
+		ring->txhdr_cache = kcalloc(nr_slots,
+					    sizeof(struct bcm43xx_txhdr_fw3),
+					    GFP_KERNEL);
+		if (!ring->txhdr_cache)
+			goto err_kfree_meta;
+
+		/* test for ability to dma to txhdr_cache */
+		dma_test = dma_map_single(dev->dev->dev,
+				ring->txhdr_cache,
+				sizeof(struct bcm43xx_txhdr_fw3),
+				DMA_TO_DEVICE);
+
+		if (dma_mapping_error(dma_test)) {
+			/* ugh realloc */
+			kfree(ring->txhdr_cache);
+			ring->txhdr_cache = kcalloc(nr_slots,
+					sizeof(struct bcm43xx_txhdr_fw3),
+					GFP_KERNEL | GFP_DMA);
+			if (!ring->txhdr_cache)
+				goto err_kfree_meta;
+
+			dma_test = dma_map_single(dev->dev->dev,
+					ring->txhdr_cache,
+					sizeof(struct bcm43xx_txhdr_fw3),
+					DMA_TO_DEVICE);
 
-	ring->routing = BCM43xx_DMA32_CLIENTTRANS;
-	if (dma64)
-		ring->routing = BCM43xx_DMA64_CLIENTTRANS;
+			if (dma_mapping_error(dma_test))
+				goto err_kfree_txhdr_cache;
+		}
 
-	ring->bcm = bcm;
+		dma_unmap_single(dev->dev->dev,
+				dma_test, sizeof(struct bcm43xx_txhdr_fw3),
+				DMA_TO_DEVICE);
+	}
+
+	ring->dev = dev;
 	ring->nr_slots = nr_slots;
-	ring->suspend_mark = ring->nr_slots * BCM43xx_TXSUSPEND_PERCENT / 100;
-	ring->resume_mark = ring->nr_slots * BCM43xx_TXRESUME_PERCENT / 100;
-	assert(ring->suspend_mark < ring->resume_mark);
 	ring->mmio_base = bcm43xx_dmacontroller_base(dma64, controller_index);
 	ring->index = controller_index;
 	ring->dma64 = !!dma64;
+	if (dma64)
+		ring->ops = &dma64_ops;
+	else
+		ring->ops = &dma32_ops;
 	if (for_tx) {
 		ring->tx = 1;
 		ring->current_slot = -1;
@@ -679,24 +885,29 @@ struct bcm43xx_dmaring * bcm43xx_setup_d
 		} else if (ring->index == 3) {
 			ring->rx_buffersize = BCM43xx_DMA3_RX_BUFFERSIZE;
 			ring->frameoffset = BCM43xx_DMA3_RX_FRAMEOFFSET;
-		} else
-			assert(0);
+		} else {
+			BCM43xx_WARN_ON(1);
+		}
 	}
+	spin_lock_init(&ring->lock);
+#ifdef CONFIG_BCM43XX_DEBUG
+	ring->last_injected_overflow = jiffies;
+#endif
 
 	err = alloc_ringmemory(ring);
 	if (err)
-		goto err_kfree_meta;
+		goto err_kfree_txhdr_cache;
 	err = dmacontroller_setup(ring);
 	if (err)
 		goto err_free_ringmemory;
-	return ring;
 
 out:
-	printk(KERN_ERR PFX "Error in bcm43xx_setup_dmaring\n");
 	return ring;
 
 err_free_ringmemory:
 	free_ringmemory(ring);
+err_kfree_txhdr_cache:
+	kfree(ring->txhdr_cache);
 err_kfree_meta:
 	kfree(ring->meta);
 err_kfree_ring:
@@ -711,11 +922,11 @@ static void bcm43xx_destroy_dmaring(stru
 	if (!ring)
 		return;
 
-	dprintk(KERN_INFO PFX "DMA-%s 0x%04X (%s) max used slots: %d/%d\n",
-		(ring->dma64) ? "64" : "32",
-		ring->mmio_base,
-		(ring->tx) ? "TX" : "RX",
-		ring->max_used_slots, ring->nr_slots);
+	bcmdbg(ring->dev->wl, "DMA-%s 0x%04X (%s) max used slots: %d/%d\n",
+	       (ring->dma64) ? "64" : "32",
+	       ring->mmio_base,
+	       (ring->tx) ? "TX" : "RX",
+	       ring->max_used_slots, ring->nr_slots);
 	/* Device IRQs are disabled prior entering this function,
 	 * so no need to take care of concurrency with rx handler stuff.
 	 */
@@ -723,17 +934,18 @@ static void bcm43xx_destroy_dmaring(stru
 	free_all_descbuffers(ring);
 	free_ringmemory(ring);
 
+	kfree(ring->txhdr_cache);
 	kfree(ring->meta);
 	kfree(ring);
 }
 
-void bcm43xx_dma_free(struct bcm43xx_private *bcm)
+void bcm43xx_dma_free(struct bcm43xx_wldev *dev)
 {
 	struct bcm43xx_dma *dma;
 
-	if (bcm43xx_using_pio(bcm))
+	if (bcm43xx_using_pio(dev))
 		return;
-	dma = bcm43xx_current_dma(bcm);
+	dma = &dev->dma;
 
 	bcm43xx_destroy_dmaring(dma->rx_ring3);
 	dma->rx_ring3 = NULL;
@@ -754,70 +966,80 @@ void bcm43xx_dma_free(struct bcm43xx_pri
 	dma->tx_ring0 = NULL;
 }
 
-int bcm43xx_dma_init(struct bcm43xx_private *bcm)
+int bcm43xx_dma_init(struct bcm43xx_wldev *dev)
 {
-	struct bcm43xx_dma *dma = bcm43xx_current_dma(bcm);
+	struct bcm43xx_dma *dma = &dev->dma;
 	struct bcm43xx_dmaring *ring;
-	int err = -ENOMEM;
+	int err;
+	u64 dmamask;
 	int dma64 = 0;
 
-	bcm->dma_mask = bcm43xx_get_supported_dma_mask(bcm);
-	if (bcm->dma_mask == DMA_64BIT_MASK)
+	dmamask = supported_dma_mask(dev);
+	if (dmamask == DMA_64BIT_MASK)
 		dma64 = 1;
-	err = pci_set_dma_mask(bcm->pci_dev, bcm->dma_mask);
-	if (err)
-		goto no_dma;
-	err = pci_set_consistent_dma_mask(bcm->pci_dev, bcm->dma_mask);
-	if (err)
-		goto no_dma;
 
+	err = ssb_dma_set_mask(dev->dev, dmamask);
+	if (err) {
+#ifdef BCM43XX_PIO
+		bcmwarn(dev->wl, "DMA for this device not supported. "
+			"Falling back to PIO\n");
+		dev->__using_pio = 1;
+		return -EAGAIN;
+#else
+		bcmerr(dev->wl, "DMA for this device not supported and "
+		       "no PIO support compiled in\n");
+		return -EOPNOTSUPP;
+#endif
+	}
+
+	err = -ENOMEM;
 	/* setup TX DMA channels. */
-	ring = bcm43xx_setup_dmaring(bcm, 0, 1, dma64);
+	ring = bcm43xx_setup_dmaring(dev, 0, 1, dma64);
 	if (!ring)
 		goto out;
 	dma->tx_ring0 = ring;
 
-	ring = bcm43xx_setup_dmaring(bcm, 1, 1, dma64);
+	ring = bcm43xx_setup_dmaring(dev, 1, 1, dma64);
 	if (!ring)
 		goto err_destroy_tx0;
 	dma->tx_ring1 = ring;
 
-	ring = bcm43xx_setup_dmaring(bcm, 2, 1, dma64);
+	ring = bcm43xx_setup_dmaring(dev, 2, 1, dma64);
 	if (!ring)
 		goto err_destroy_tx1;
 	dma->tx_ring2 = ring;
 
-	ring = bcm43xx_setup_dmaring(bcm, 3, 1, dma64);
+	ring = bcm43xx_setup_dmaring(dev, 3, 1, dma64);
 	if (!ring)
 		goto err_destroy_tx2;
 	dma->tx_ring3 = ring;
 
-	ring = bcm43xx_setup_dmaring(bcm, 4, 1, dma64);
+	ring = bcm43xx_setup_dmaring(dev, 4, 1, dma64);
 	if (!ring)
 		goto err_destroy_tx3;
 	dma->tx_ring4 = ring;
 
-	ring = bcm43xx_setup_dmaring(bcm, 5, 1, dma64);
+	ring = bcm43xx_setup_dmaring(dev, 5, 1, dma64);
 	if (!ring)
 		goto err_destroy_tx4;
 	dma->tx_ring5 = ring;
 
 	/* setup RX DMA channels. */
-	ring = bcm43xx_setup_dmaring(bcm, 0, 0, dma64);
+	ring = bcm43xx_setup_dmaring(dev, 0, 0, dma64);
 	if (!ring)
 		goto err_destroy_tx5;
 	dma->rx_ring0 = ring;
 
-	if (bcm->current_core->rev < 5) {
-		ring = bcm43xx_setup_dmaring(bcm, 3, 0, dma64);
+	if (dev->dev->id.revision < 5) {
+		ring = bcm43xx_setup_dmaring(dev, 3, 0, dma64);
 		if (!ring)
 			goto err_destroy_rx0;
 		dma->rx_ring3 = ring;
 	}
 
-	dprintk(KERN_INFO PFX "%d-bit DMA initialized\n",
-		(bcm->dma_mask == DMA_64BIT_MASK) ? 64 :
-		(bcm->dma_mask == DMA_32BIT_MASK) ? 32 : 30);
+	bcmdbg(dev->wl, "%d-bit DMA initialized\n",
+	       (dmamask == DMA_64BIT_MASK) ? 64 :
+	       (dmamask == DMA_32BIT_MASK) ? 32 : 30);
 	err = 0;
 out:
 	return err;
@@ -843,17 +1065,7 @@ err_destroy_tx1:
 err_destroy_tx0:
 	bcm43xx_destroy_dmaring(dma->tx_ring0);
 	dma->tx_ring0 = NULL;
-no_dma:
-#ifdef CONFIG_BCM43XX_PIO
-	printk(KERN_WARNING PFX "DMA not supported on this device."
-				" Falling back to PIO.\n");
-	bcm->__using_pio = 1;
-	return -ENOSYS;
-#else
-	printk(KERN_ERR PFX "FATAL: DMA not supported and PIO not configured. "
-			    "Please recompile the driver with PIO support.\n");
-	return -ENODEV;
-#endif /* CONFIG_BCM43XX_PIO */
+	goto out;
 }
 
 /* Generate a cookie for the TX header. */
@@ -888,7 +1100,7 @@ static u16 generate_cookie(struct bcm43x
 		cookie = 0xF000;
 		break;
 	}
-	assert(((u16)slot & 0xF000) == 0x0000);
+	BCM43xx_WARN_ON(!(((u16)slot & 0xF000) == 0x0000));
 	cookie |= (u16)slot;
 
 	return cookie;
@@ -896,10 +1108,10 @@ static u16 generate_cookie(struct bcm43x
 
 /* Inspect a cookie and find out to which controller/slot it belongs. */
 static
-struct bcm43xx_dmaring * parse_cookie(struct bcm43xx_private *bcm,
+struct bcm43xx_dmaring *parse_cookie(struct bcm43xx_wldev *dev,
 				      u16 cookie, int *slot)
 {
-	struct bcm43xx_dma *dma = bcm43xx_current_dma(bcm);
+	struct bcm43xx_dma *dma = &dev->dma;
 	struct bcm43xx_dmaring *ring = NULL;
 
 	switch (cookie & 0xF000) {
@@ -922,219 +1134,300 @@ struct bcm43xx_dmaring * parse_cookie(st
 		ring = dma->tx_ring5;
 		break;
 	default:
-		assert(0);
+		BCM43xx_WARN_ON(1);
 	}
 	*slot = (cookie & 0x0FFF);
-	assert(*slot >= 0 && *slot < ring->nr_slots);
+	BCM43xx_WARN_ON(!(ring && *slot >= 0 && *slot < ring->nr_slots));
 
 	return ring;
 }
 
-static void dmacontroller_poke_tx(struct bcm43xx_dmaring *ring,
-				  int slot)
-{
-	u16 offset;
-	int descsize;
-
-	/* Everything is ready to start. Buffers are DMA mapped and
-	 * associated with slots.
-	 * "slot" is the last slot of the new frame we want to transmit.
-	 * Close your seat belts now, please.
-	 */
-	wmb();
-	slot = next_slot(ring, slot);
-	offset = (ring->dma64) ? BCM43xx_DMA64_TXINDEX : BCM43xx_DMA32_TXINDEX;
-	descsize = (ring->dma64) ? sizeof(struct bcm43xx_dmadesc64)
-		: sizeof(struct bcm43xx_dmadesc32);
-	bcm43xx_dma_write(ring, offset,
-			(u32)(slot * descsize));
-}
-
-static void dma_tx_fragment(struct bcm43xx_dmaring *ring,
+static int dma_tx_fragment(struct bcm43xx_dmaring *ring,
 			    struct sk_buff *skb,
-			    u8 cur_frag)
+			    struct ieee80211_tx_control *ctl)
 {
+	const struct bcm43xx_dma_ops *ops = ring->ops;
+	u8 *header;
 	int slot;
+	int err;
 	struct bcm43xx_dmadesc_generic *desc;
 	struct bcm43xx_dmadesc_meta *meta;
-	dma_addr_t dmaaddr;
+	struct bcm43xx_dmadesc_meta *meta_hdr;
 	struct sk_buff *bounce_skb;
 
-	assert(skb_shinfo(skb)->nr_frags == 0);
+#define SLOTS_PER_PACKET  2
+	BCM43xx_WARN_ON(skb_shinfo(skb)->nr_frags != 0);
 
+	/* Get a slot for the header. */
 	slot = request_slot(ring);
-	desc = bcm43xx_dma_idx2desc(ring, slot, &meta);
+	desc = ops->idx2desc(ring, slot, &meta_hdr);
+	memset(meta_hdr, 0, sizeof(*meta_hdr));
 
-	/* Add a device specific TX header. */
-	assert(skb_headroom(skb) >= sizeof(struct bcm43xx_txhdr));
-	/* Reserve enough headroom for the device tx header. */
-	__skb_push(skb, sizeof(struct bcm43xx_txhdr));
-	/* Now calculate and add the tx header.
-	 * The tx header includes the PLCP header.
-	 */
-	bcm43xx_generate_txhdr(ring->bcm,
-			       (struct bcm43xx_txhdr *)skb->data,
-			       skb->data + sizeof(struct bcm43xx_txhdr),
-			       skb->len - sizeof(struct bcm43xx_txhdr),
-			       (cur_frag == 0),
+	header = &(ring->txhdr_cache[slot * sizeof(struct bcm43xx_txhdr_fw3)]);
+	bcm43xx_generate_txhdr(ring->dev, header,
+			       skb->data, skb->len, ctl,
 			       generate_cookie(ring, slot));
-	dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
-	if (dma_mapping_error(dmaaddr) || dmaaddr + skb->len > ring->bcm->dma_mask) {
-		/* chip cannot handle DMA to/from > 1GB, use bounce buffer (copied from b44 driver) */
-		if (!dma_mapping_error(dmaaddr))
-			unmap_descbuffer(ring, dmaaddr, skb->len, 1);
-		bounce_skb = __dev_alloc_skb(skb->len, GFP_ATOMIC|GFP_DMA);
-		if (!bounce_skb)
-			return;
-		dmaaddr = map_descbuffer(ring, bounce_skb->data, bounce_skb->len, 1);
-		if (dma_mapping_error(dmaaddr) || dmaaddr + skb->len > ring->bcm->dma_mask) {
-			if (!dma_mapping_error(dmaaddr))
-				unmap_descbuffer(ring, dmaaddr, skb->len, 1);
-			dev_kfree_skb_any(bounce_skb);
-			assert(0);
-			return;
+
+	meta_hdr->dmaaddr = map_descbuffer(ring, (unsigned char *)header,
+				       sizeof(struct bcm43xx_txhdr_fw3), 1);
+	if (dma_mapping_error(meta_hdr->dmaaddr))
+		return -EIO;
+	ops->fill_descriptor(ring, desc, meta_hdr->dmaaddr,
+			     sizeof(struct bcm43xx_txhdr_fw3), 1, 0, 0);
+
+	/* Get a slot for the payload. */
+	slot = request_slot(ring);
+	desc = ops->idx2desc(ring, slot, &meta);
+	memset(meta, 0, sizeof(*meta));
+
+	memcpy(&meta->txstat.control, ctl, sizeof(*ctl));
+	meta->skb = skb;
+	meta->is_last_fragment = 1;
+
+	meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
+	/* create a bounce buffer in zone_dma on mapping failure. */
+	if (dma_mapping_error(meta->dmaaddr)) {
+		bounce_skb = __dev_alloc_skb(skb->len, GFP_ATOMIC | GFP_DMA);
+		if (!bounce_skb) {
+			err = -ENOMEM;
+			goto out_unmap_hdr;
 		}
-		skb_copy_from_linear_data(skb, skb_put(bounce_skb, skb->len),
-					  skb->len);
+
+		memcpy(skb_put(bounce_skb, skb->len), skb->data, skb->len);
 		dev_kfree_skb_any(skb);
 		skb = bounce_skb;
+		meta->skb = skb;
+		meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
+		if (dma_mapping_error(meta->dmaaddr)) {
+			err = -EIO;
+			goto out_free_bounce;
+		}
 	}
 
-	meta->skb = skb;
-	meta->dmaaddr = dmaaddr;
-
-	fill_descriptor(ring, desc, dmaaddr,
-			skb->len, 1, 1, 1);
+	ops->fill_descriptor(ring, desc, meta->dmaaddr,
+			     skb->len, 0, 1, 1);
 
+	wmb();	/* previous stuff MUST be done */
 	/* Now transfer the whole frame. */
-	dmacontroller_poke_tx(ring, slot);
+	ops->poke_tx(ring, next_slot(ring, slot));
+	return 0;
+
+out_free_bounce:
+	dev_kfree_skb_any(skb);
+out_unmap_hdr:
+	unmap_descbuffer(ring, meta_hdr->dmaaddr,
+			sizeof(struct bcm43xx_txhdr_fw3), 1);
+	return err;
 }
 
-int bcm43xx_dma_tx(struct bcm43xx_private *bcm,
-		   struct ieee80211_txb *txb)
+static inline
+int should_inject_overflow(struct bcm43xx_dmaring *ring)
 {
-	/* We just received a packet from the kernel network subsystem.
-	 * Add headers and DMA map the memory. Poke
-	 * the device to send the stuff.
-	 * Note that this is called from atomic context.
-	 */
-	struct bcm43xx_dmaring *ring = bcm43xx_current_dma(bcm)->tx_ring1;
-	u8 i;
-	struct sk_buff *skb;
-
-	assert(ring->tx);
-	if (unlikely(free_slots(ring) < txb->nr_frags)) {
-		/* The queue should be stopped,
-		 * if we are low on free slots.
-		 * If this ever triggers, we have to lower the suspend_mark.
-		 */
-		dprintkl(KERN_ERR PFX "Out of DMA descriptor slots!\n");
-		return -ENOMEM;
+#ifdef CONFIG_BCM43XX_DEBUG
+	if (unlikely(bcm43xx_debug(ring->dev, BCM43xx_DBG_DMAOVERFLOW))) {
+		/* Check if we should inject another ringbuffer overflow
+		 * to test handling of this situation in the stack. */
+		unsigned long next_overflow;
+
+		next_overflow = ring->last_injected_overflow + HZ;
+		if (time_after(jiffies, next_overflow)) {
+			ring->last_injected_overflow = jiffies;
+			bcmdbg(ring->dev->wl,
+			       "Injecting TX ring overflow on "
+			       "DMA controller %d\n", ring->index);
+			return 1;
+		}
 	}
+#endif /* CONFIG_BCM43XX_DEBUG */
+	return 0;
+}
+
+int bcm43xx_dma_tx(struct bcm43xx_wldev *dev,
+		   struct sk_buff *skb,
+		   struct ieee80211_tx_control *ctl)
+{
+	struct bcm43xx_dmaring *ring;
+	int err = 0;
+	unsigned long flags;
+
+	ring = priority_to_txring(dev, ctl->queue);
+	spin_lock_irqsave(&ring->lock, flags);
+	BCM43xx_WARN_ON(!ring->tx);
+	if (unlikely(free_slots(ring) < SLOTS_PER_PACKET)) {
+		bcmwarn(dev->wl, "DMA queue overflow\n");
+		err = -ENOSPC;
+		goto out_unlock;
+	}
+	/* Check if the queue was stopped in mac80211,
+	 * but we got called nevertheless.
+	 * That would be a mac80211 bug. */
+	BCM43xx_BUG_ON(ring->stopped);
 
-	for (i = 0; i < txb->nr_frags; i++) {
-		skb = txb->fragments[i];
-		/* Take skb from ieee80211_txb_free */
-		txb->fragments[i] = NULL;
-		dma_tx_fragment(ring, skb, i);
+	err = dma_tx_fragment(ring, skb, ctl);
+	if (unlikely(err)) {
+		bcmerr(dev->wl, "DMA tx mapping failure\n");
+		goto out_unlock;
+	}
+	ring->nr_tx_packets++;
+	if ((free_slots(ring) < SLOTS_PER_PACKET) ||
+	    should_inject_overflow(ring)) {
+		/* This TX ring is full. */
+		ieee80211_stop_queue(dev->wl->hw, txring_to_priority(ring));
+		ring->stopped = 1;
+		if (bcm43xx_debug(dev, BCM43xx_DBG_DMAVERBOSE))
+			bcmdbg(dev->wl, "Stopped TX ring %d\n",
+			       ring->index);
 	}
-	ieee80211_txb_free(txb);
+out_unlock:
+	spin_unlock_irqrestore(&ring->lock, flags);
 
-	return 0;
+	return err;
 }
 
-void bcm43xx_dma_handle_xmitstatus(struct bcm43xx_private *bcm,
-				   struct bcm43xx_xmitstatus *status)
+void bcm43xx_dma_handle_txstatus(struct bcm43xx_wldev *dev,
+				 const struct bcm43xx_txstatus *status)
 {
+	const struct bcm43xx_dma_ops *ops;
 	struct bcm43xx_dmaring *ring;
 	struct bcm43xx_dmadesc_generic *desc;
 	struct bcm43xx_dmadesc_meta *meta;
-	int is_last_fragment;
 	int slot;
-	u32 tmp;
 
-	ring = parse_cookie(bcm, status->cookie, &slot);
-	assert(ring);
-	assert(ring->tx);
+	ring = parse_cookie(dev, status->cookie, &slot);
+	if (unlikely(!ring))
+		return;
+	BCM43xx_WARN_ON(!irqs_disabled());
+	spin_lock(&ring->lock);
+
+	BCM43xx_WARN_ON(!ring->tx);
+	ops = ring->ops;
 	while (1) {
-		assert(slot >= 0 && slot < ring->nr_slots);
-		desc = bcm43xx_dma_idx2desc(ring, slot, &meta);
+		BCM43xx_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
+		desc = ops->idx2desc(ring, slot, &meta);
 
-		if (ring->dma64) {
-			tmp = le32_to_cpu(desc->dma64.control0);
-			is_last_fragment = !!(tmp & BCM43xx_DMA64_DCTL0_FRAMEEND);
+		if (meta->skb)
+			unmap_descbuffer(ring, meta->dmaaddr,
+					 meta->skb->len, 1);
+		else
+			unmap_descbuffer(ring, meta->dmaaddr,
+					 sizeof(struct bcm43xx_txhdr_fw3), 1);
+
+		if (meta->is_last_fragment) {
+			BCM43xx_WARN_ON(!meta->skb);
+			/* Call back to inform the ieee80211 subsystem about the
+			 * status of the transmission.
+			 * Some fields of txstat are already filled in dma_tx().
+			 */
+			if (status->acked)
+				meta->txstat.flags |= IEEE80211_TX_STATUS_ACK;
+			else
+				if (dev->short_preamble) {
+					if (status->frame_count >=
+					    dev->short_retry_limit)
+						meta->txstat.excessive_retries = 1;
+				} else {
+					if (status->frame_count >=
+					    dev->long_retry_limit)
+						meta->txstat.excessive_retries = 1;
+				}
+			meta->txstat.retry_count = status->frame_count - 1;
+			ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb,
+						    &(meta->txstat));
+			/* skb is freed by ieee80211_tx_status_irqsafe() */
+			meta->skb = NULL;
 		} else {
-			tmp = le32_to_cpu(desc->dma32.control);
-			is_last_fragment = !!(tmp & BCM43xx_DMA32_DCTL_FRAMEEND);
+			/* No need to call free_descriptor_buffer here, as
+			 * this is only the txhdr, which is not allocated.
+			 */
+			BCM43xx_WARN_ON(meta->skb != NULL);
 		}
-		unmap_descbuffer(ring, meta->dmaaddr, meta->skb->len, 1);
-		free_descriptor_buffer(ring, meta, 1);
-		/* Everything belonging to the slot is unmapped
-		 * and freed, so we can return it.
-		 */
-		return_slot(ring, slot);
 
-		if (is_last_fragment)
+		/* Everything unmapped and free'd. So it's not used anymore. */
+		ring->used_slots--;
+
+		if (meta->is_last_fragment)
 			break;
 		slot = next_slot(ring, slot);
 	}
-	bcm->stats.last_tx = jiffies;
+	dev->stats.last_tx = jiffies;
+	if (ring->stopped) {
+		BCM43xx_WARN_ON(free_slots(ring) < SLOTS_PER_PACKET);
+		ieee80211_wake_queue(dev->wl->hw, txring_to_priority(ring));
+		ring->stopped = 0;
+		if (bcm43xx_debug(dev, BCM43xx_DBG_DMAVERBOSE))
+			bcmdbg(dev->wl, "Woke up TX ring %d\n",
+			       ring->index);
+	}
+
+	spin_unlock(&ring->lock);
+}
+
+void bcm43xx_dma_get_tx_stats(struct bcm43xx_wldev *dev,
+			      struct ieee80211_tx_queue_stats *stats)
+{
+	const int nr_queues = dev->wl->hw->queues;
+	struct bcm43xx_dmaring *ring;
+	struct ieee80211_tx_queue_stats_data *data;
+	unsigned long flags;
+	int i;
+
+	for (i = 0; i < nr_queues; i++) {
+		data = &(stats->data[i]);
+		ring = priority_to_txring(dev, i);
+
+		spin_lock_irqsave(&ring->lock, flags);
+		data->len = ring->used_slots / SLOTS_PER_PACKET;
+		data->limit = ring->nr_slots / SLOTS_PER_PACKET;
+		data->count = ring->nr_tx_packets;
+		spin_unlock_irqrestore(&ring->lock, flags);
+	}
 }
 
 static void dma_rx(struct bcm43xx_dmaring *ring,
 		   int *slot)
 {
+	const struct bcm43xx_dma_ops *ops = ring->ops;
 	struct bcm43xx_dmadesc_generic *desc;
 	struct bcm43xx_dmadesc_meta *meta;
-	struct bcm43xx_rxhdr *rxhdr;
+	struct bcm43xx_rxhdr_fw3 *rxhdr;
 	struct sk_buff *skb;
 	u16 len;
 	int err;
 	dma_addr_t dmaaddr;
 
-	desc = bcm43xx_dma_idx2desc(ring, *slot, &meta);
+	desc = ops->idx2desc(ring, *slot, &meta);
 
 	sync_descbuffer_for_cpu(ring, meta->dmaaddr, ring->rx_buffersize);
 	skb = meta->skb;
 
 	if (ring->index == 3) {
 		/* We received an xmit status. */
-		struct bcm43xx_hwxmitstatus *hw = (struct bcm43xx_hwxmitstatus *)skb->data;
-		struct bcm43xx_xmitstatus stat;
+		struct bcm43xx_hwtxstatus *hw =
+				(struct bcm43xx_hwtxstatus *)skb->data;
 		int i = 0;
 
-		stat.cookie = le16_to_cpu(hw->cookie);
-		while (stat.cookie == 0) {
-			if (unlikely(++i >= 10000)) {
-				assert(0);
+		while (hw->cookie == 0) {
+			if (i > 100)
 				break;
-			}
+			i++;
 			udelay(2);
 			barrier();
-			stat.cookie = le16_to_cpu(hw->cookie);
 		}
-		stat.flags = hw->flags;
-		stat.cnt1 = hw->cnt1;
-		stat.cnt2 = hw->cnt2;
-		stat.seq = le16_to_cpu(hw->seq);
-		stat.unknown = le16_to_cpu(hw->unknown);
-
-		bcm43xx_debugfs_log_txstat(ring->bcm, &stat);
-		bcm43xx_dma_handle_xmitstatus(ring->bcm, &stat);
+		bcm43xx_handle_hwtxstatus(ring->dev, hw);
 		/* recycle the descriptor buffer. */
 		sync_descbuffer_for_device(ring, meta->dmaaddr, ring->rx_buffersize);
 
 		return;
 	}
-	rxhdr = (struct bcm43xx_rxhdr *)skb->data;
-	len = le16_to_cpu(rxhdr->frame_length);
+	rxhdr = (struct bcm43xx_rxhdr_fw3 *)skb->data;
+	len = le16_to_cpu(rxhdr->frame_len);
 	if (len == 0) {
 		int i = 0;
 
 		do {
 			udelay(2);
 			barrier();
-			len = le16_to_cpu(rxhdr->frame_length);
+			len = le16_to_cpu(rxhdr->frame_len);
 		} while (len == 0 && i++ < 5);
 		if (unlikely(len == 0)) {
 			/* recycle the descriptor buffer. */
@@ -1153,7 +1446,7 @@ static void dma_rx(struct bcm43xx_dmarin
 		s32 tmp = len;
 
 		while (1) {
-			desc = bcm43xx_dma_idx2desc(ring, *slot, &meta);
+			desc = ops->idx2desc(ring, *slot, &meta);
 			/* recycle the descriptor buffer. */
 			sync_descbuffer_for_device(ring, meta->dmaaddr,
 						   ring->rx_buffersize);
@@ -1163,17 +1456,16 @@ static void dma_rx(struct bcm43xx_dmarin
 			if (tmp <= 0)
 				break;
 		}
-		printkl(KERN_ERR PFX "DMA RX buffer too small "
-			"(len: %u, buffer: %u, nr-dropped: %d)\n",
-			len, ring->rx_buffersize, cnt);
+		bcmerr(ring->dev->wl, "DMA RX buffer too small "
+		       "(len: %u, buffer: %u, nr-dropped: %d)\n",
+		       len, ring->rx_buffersize, cnt);
 		goto drop;
 	}
-	len -= IEEE80211_FCS_LEN;
 
 	dmaaddr = meta->dmaaddr;
 	err = setup_rx_descbuffer(ring, desc, meta, GFP_ATOMIC);
 	if (unlikely(err)) {
-		dprintkl(KERN_ERR PFX "DMA RX: setup_rx_descbuffer() failed\n");
+		bcmdbg(ring->dev->wl, "DMA RX: setup_rx_descbuffer() failed\n");
 		sync_descbuffer_for_device(ring, dmaaddr,
 					   ring->rx_buffersize);
 		goto drop;
@@ -1183,81 +1475,68 @@ static void dma_rx(struct bcm43xx_dmarin
 	skb_put(skb, len + ring->frameoffset);
 	skb_pull(skb, ring->frameoffset);
 
-	err = bcm43xx_rx(ring->bcm, skb, rxhdr);
-	if (err) {
-		dev_kfree_skb_irq(skb);
-		goto drop;
-	}
-
+	bcm43xx_rx(ring->dev, skb, rxhdr);
 drop:
 	return;
 }
 
 void bcm43xx_dma_rx(struct bcm43xx_dmaring *ring)
 {
-	u32 status;
-	u16 descptr;
+	const struct bcm43xx_dma_ops *ops = ring->ops;
 	int slot, current_slot;
-#ifdef CONFIG_BCM43XX_DEBUG
 	int used_slots = 0;
-#endif
 
-	assert(!ring->tx);
-	if (ring->dma64) {
-		status = bcm43xx_dma_read(ring, BCM43xx_DMA64_RXSTATUS);
-		descptr = (status & BCM43xx_DMA64_RXSTATDPTR);
-		current_slot = descptr / sizeof(struct bcm43xx_dmadesc64);
-	} else {
-		status = bcm43xx_dma_read(ring, BCM43xx_DMA32_RXSTATUS);
-		descptr = (status & BCM43xx_DMA32_RXDPTR);
-		current_slot = descptr / sizeof(struct bcm43xx_dmadesc32);
-	}
-	assert(current_slot >= 0 && current_slot < ring->nr_slots);
+	BCM43xx_WARN_ON(ring->tx);
+	current_slot = ops->get_current_rxslot(ring);
+	BCM43xx_WARN_ON(!(current_slot >= 0 && current_slot < ring->nr_slots));
 
 	slot = ring->current_slot;
 	for ( ; slot != current_slot; slot = next_slot(ring, slot)) {
 		dma_rx(ring, &slot);
-#ifdef CONFIG_BCM43XX_DEBUG
-		if (++used_slots > ring->max_used_slots)
-			ring->max_used_slots = used_slots;
-#endif
-	}
-	if (ring->dma64) {
-		bcm43xx_dma_write(ring, BCM43xx_DMA64_RXINDEX,
-				(u32)(slot * sizeof(struct bcm43xx_dmadesc64)));
-	} else {
-		bcm43xx_dma_write(ring, BCM43xx_DMA32_RXINDEX,
-				(u32)(slot * sizeof(struct bcm43xx_dmadesc32)));
+		update_max_used_slots(ring, ++used_slots);
 	}
+	ops->set_current_rxslot(ring, slot);
 	ring->current_slot = slot;
 }
 
-void bcm43xx_dma_tx_suspend(struct bcm43xx_dmaring *ring)
+static void bcm43xx_dma_tx_suspend_ring(struct bcm43xx_dmaring *ring)
 {
-	assert(ring->tx);
-	bcm43xx_power_saving_ctl_bits(ring->bcm, -1, 1);
-	if (ring->dma64) {
-		bcm43xx_dma_write(ring, BCM43xx_DMA64_TXCTL,
-				bcm43xx_dma_read(ring, BCM43xx_DMA64_TXCTL)
-				| BCM43xx_DMA64_TXSUSPEND);
-	} else {
-		bcm43xx_dma_write(ring, BCM43xx_DMA32_TXCTL,
-				bcm43xx_dma_read(ring, BCM43xx_DMA32_TXCTL)
-				| BCM43xx_DMA32_TXSUSPEND);
-	}
+	unsigned long flags;
+
+	spin_lock_irqsave(&ring->lock, flags);
+	BCM43xx_WARN_ON(!ring->tx);
+	ring->ops->tx_suspend(ring);
+	spin_unlock_irqrestore(&ring->lock, flags);
 }
 
-void bcm43xx_dma_tx_resume(struct bcm43xx_dmaring *ring)
+static void bcm43xx_dma_tx_resume_ring(struct bcm43xx_dmaring *ring)
 {
-	assert(ring->tx);
-	if (ring->dma64) {
-		bcm43xx_dma_write(ring, BCM43xx_DMA64_TXCTL,
-				bcm43xx_dma_read(ring, BCM43xx_DMA64_TXCTL)
-				& ~BCM43xx_DMA64_TXSUSPEND);
-	} else {
-		bcm43xx_dma_write(ring, BCM43xx_DMA32_TXCTL,
-				bcm43xx_dma_read(ring, BCM43xx_DMA32_TXCTL)
-				& ~BCM43xx_DMA32_TXSUSPEND);
-	}
-	bcm43xx_power_saving_ctl_bits(ring->bcm, -1, -1);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ring->lock, flags);
+	BCM43xx_WARN_ON(!ring->tx);
+	ring->ops->tx_resume(ring);
+	spin_unlock_irqrestore(&ring->lock, flags);
+}
+
+void bcm43xx_dma_tx_suspend(struct bcm43xx_wldev *dev)
+{
+	bcm43xx_power_saving_ctl_bits(dev, -1, 1);
+	bcm43xx_dma_tx_suspend_ring(dev->dma.tx_ring0);
+	bcm43xx_dma_tx_suspend_ring(dev->dma.tx_ring1);
+	bcm43xx_dma_tx_suspend_ring(dev->dma.tx_ring2);
+	bcm43xx_dma_tx_suspend_ring(dev->dma.tx_ring3);
+	bcm43xx_dma_tx_suspend_ring(dev->dma.tx_ring4);
+	bcm43xx_dma_tx_suspend_ring(dev->dma.tx_ring5);
+}
+
+void bcm43xx_dma_tx_resume(struct bcm43xx_wldev *dev)
+{
+	bcm43xx_dma_tx_resume_ring(dev->dma.tx_ring5);
+	bcm43xx_dma_tx_resume_ring(dev->dma.tx_ring4);
+	bcm43xx_dma_tx_resume_ring(dev->dma.tx_ring3);
+	bcm43xx_dma_tx_resume_ring(dev->dma.tx_ring2);
+	bcm43xx_dma_tx_resume_ring(dev->dma.tx_ring1);
+	bcm43xx_dma_tx_resume_ring(dev->dma.tx_ring0);
+	bcm43xx_power_saving_ctl_bits(dev, -1, -1);
 }
Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_dma.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_dma.h
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_dma.h
@@ -4,10 +4,11 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
-#include <linux/dma-mapping.h>
 #include <linux/linkage.h>
 #include <asm/atomic.h>
 
+#include "bcm43xx.h"
+
 
 /* DMA-Interrupt reasons. */
 #define BCM43xx_DMAIRQ_FATALMASK	((1 << 10) | (1 << 11) | (1 << 12) \
@@ -80,12 +81,6 @@ struct bcm43xx_dmadesc32 {
 #define BCM43xx_DMA32_DCTL_FRAMEEND		0x40000000
 #define BCM43xx_DMA32_DCTL_FRAMESTART		0x80000000
 
-/* Address field Routing value. */
-#define BCM43xx_DMA32_ROUTING			0xC0000000
-#define BCM43xx_DMA32_ROUTING_SHIFT		30
-#define		BCM43xx_DMA32_NOTRANS		0x00000000
-#define		BCM43xx_DMA32_CLIENTTRANS	0x40000000
-
 
 
 /*** 64-bit DMA Engine. ***/
@@ -161,12 +156,6 @@ struct bcm43xx_dmadesc64 {
 #define BCM43xx_DMA64_DCTL1_ADDREXT_MASK	0x00030000
 #define BCM43xx_DMA64_DCTL1_ADDREXT_SHIFT	16
 
-/* Address field Routing value. */
-#define BCM43xx_DMA64_ROUTING			0xC0000000
-#define BCM43xx_DMA64_ROUTING_SHIFT		30
-#define		BCM43xx_DMA64_NOTRANS		0x00000000
-#define		BCM43xx_DMA64_CLIENTTRANS	0x80000000
-
 
 
 struct bcm43xx_dmadesc_generic {
@@ -184,14 +173,10 @@ struct bcm43xx_dmadesc_generic {
 
 
 /* DMA engine tuning knobs */
-#define BCM43xx_TXRING_SLOTS		512
+#define BCM43xx_TXRING_SLOTS		128
 #define BCM43xx_RXRING_SLOTS		64
 #define BCM43xx_DMA0_RX_BUFFERSIZE	(2304 + 100)
 #define BCM43xx_DMA3_RX_BUFFERSIZE	16
-/* Suspend the tx queue, if less than this percent slots are free. */
-#define BCM43xx_TXSUSPEND_PERCENT	20
-/* Resume the tx queue, if more than this percent slots are free. */
-#define BCM43xx_TXRESUME_PERCENT	50
 
 
 
@@ -200,7 +185,7 @@ struct bcm43xx_dmadesc_generic {
 
 struct sk_buff;
 struct bcm43xx_private;
-struct bcm43xx_xmitstatus;
+struct bcm43xx_txstatus;
 
 
 struct bcm43xx_dmadesc_meta {
@@ -208,15 +193,42 @@ struct bcm43xx_dmadesc_meta {
 	struct sk_buff *skb;
 	/* DMA base bus-address of the descriptor buffer. */
 	dma_addr_t dmaaddr;
+	/* ieee80211 TX status. Only used once per 802.11 frag. */
+	bool is_last_fragment;
+	struct ieee80211_tx_status txstat;
+};
+
+struct bcm43xx_dmaring;
+
+/* Lowlevel DMA operations that differ between 32bit and 64bit DMA. */
+struct bcm43xx_dma_ops {
+	struct bcm43xx_dmadesc_generic * (*idx2desc)
+					 (struct bcm43xx_dmaring *ring,
+					 int slot,
+					 struct bcm43xx_dmadesc_meta **meta);
+	void (*fill_descriptor)(struct bcm43xx_dmaring *ring,
+				struct bcm43xx_dmadesc_generic *desc,
+				dma_addr_t dmaaddr, u16 bufsize,
+				int start, int end, int irq);
+	void (*poke_tx)(struct bcm43xx_dmaring *ring, int slot);
+	void (*tx_suspend)(struct bcm43xx_dmaring *ring);
+	void (*tx_resume)(struct bcm43xx_dmaring *ring);
+	int (*get_current_rxslot)(struct bcm43xx_dmaring *ring);
+	void (*set_current_rxslot)(struct bcm43xx_dmaring *ring, int slot);
 };
 
 struct bcm43xx_dmaring {
+	/* Lowlevel DMA ops. */
+	const struct bcm43xx_dma_ops *ops;
 	/* Kernel virtual base address of the ring memory. */
 	void *descbase;
 	/* Meta data about all descriptors. */
 	struct bcm43xx_dmadesc_meta *meta;
-	/* DMA Routing value. */
-	u32 routing;
+	/* Cache of TX headers for each slot.
+	 * This is to avoid an allocation on each TX.
+	 * This is NULL for an RX ring.
+	 */
+	u8 *txhdr_cache;
 	/* (Unadjusted) DMA base bus-address of the ring memory. */
 	dma_addr_t dmabase;
 	/* Number of descriptor slots in the ring. */
@@ -225,9 +237,8 @@ struct bcm43xx_dmaring {
 	int used_slots;
 	/* Currently used slot in the ring. */
 	int current_slot;
-	/* Marks to suspend/resume the queue. */
-	int suspend_mark;
-	int resume_mark;
+	/* Total number of packets sent. Statistics only. */
+	unsigned int nr_tx_packets;
 	/* Frameoffset in octets. */
 	u32 frameoffset;
 	/* Descriptor buffer size. */
@@ -237,136 +248,105 @@ struct bcm43xx_dmaring {
 	/* DMA controller index number (0-5). */
 	int index;
 	/* Boolean. Is this a TX ring? */
-	u8 tx;
+	bool tx;
 	/* Boolean. 64bit DMA if true, 32bit DMA otherwise. */
-	u8 dma64;
-	/* Boolean. Are transfers suspended on this ring? */
-	u8 suspended;
-	struct bcm43xx_private *bcm;
+	bool dma64;
+	/* Boolean. Is this ring stopped at ieee80211 level? */
+	bool stopped;
+	/* Lock, only used for TX. */
+	spinlock_t lock;
+	struct bcm43xx_wldev *dev;
 #ifdef CONFIG_BCM43XX_DEBUG
 	/* Maximum number of used slots. */
 	int max_used_slots;
+	/* Last time we injected a ring overflow. */
+	unsigned long last_injected_overflow;
 #endif /* CONFIG_BCM43XX_DEBUG*/
 };
 
 
 static inline
-int bcm43xx_dma_desc2idx(struct bcm43xx_dmaring *ring,
-			 struct bcm43xx_dmadesc_generic *desc)
-{
-	if (ring->dma64) {
-		struct bcm43xx_dmadesc64 *dd64 = ring->descbase;
-		return (int)(&(desc->dma64) - dd64);
-	} else {
-		struct bcm43xx_dmadesc32 *dd32 = ring->descbase;
-		return (int)(&(desc->dma32) - dd32);
-	}
-}
-
-static inline
-struct bcm43xx_dmadesc_generic * bcm43xx_dma_idx2desc(struct bcm43xx_dmaring *ring,
-						      int slot,
-						      struct bcm43xx_dmadesc_meta **meta)
-{
-	*meta = &(ring->meta[slot]);
-	if (ring->dma64) {
-		struct bcm43xx_dmadesc64 *dd64 = ring->descbase;
-		return (struct bcm43xx_dmadesc_generic *)(&(dd64[slot]));
-	} else {
-		struct bcm43xx_dmadesc32 *dd32 = ring->descbase;
-		return (struct bcm43xx_dmadesc_generic *)(&(dd32[slot]));
-	}
-}
-
-static inline
 u32 bcm43xx_dma_read(struct bcm43xx_dmaring *ring,
 		     u16 offset)
 {
-	return bcm43xx_read32(ring->bcm, ring->mmio_base + offset);
+	return bcm43xx_read32(ring->dev, ring->mmio_base + offset);
 }
 
 static inline
 void bcm43xx_dma_write(struct bcm43xx_dmaring *ring,
 		       u16 offset, u32 value)
 {
-	bcm43xx_write32(ring->bcm, ring->mmio_base + offset, value);
+	bcm43xx_write32(ring->dev, ring->mmio_base + offset, value);
 }
 
 
-int bcm43xx_dma_init(struct bcm43xx_private *bcm);
-void bcm43xx_dma_free(struct bcm43xx_private *bcm);
+int bcm43xx_dma_init(struct bcm43xx_wldev *dev);
+void bcm43xx_dma_free(struct bcm43xx_wldev *dev);
 
-int bcm43xx_dmacontroller_rx_reset(struct bcm43xx_private *bcm,
+int bcm43xx_dmacontroller_rx_reset(struct bcm43xx_wldev *dev,
 				   u16 dmacontroller_mmio_base,
 				   int dma64);
-int bcm43xx_dmacontroller_tx_reset(struct bcm43xx_private *bcm,
+int bcm43xx_dmacontroller_tx_reset(struct bcm43xx_wldev *dev,
 				   u16 dmacontroller_mmio_base,
 				   int dma64);
 
 u16 bcm43xx_dmacontroller_base(int dma64bit, int dmacontroller_idx);
 
-void bcm43xx_dma_tx_suspend(struct bcm43xx_dmaring *ring);
-void bcm43xx_dma_tx_resume(struct bcm43xx_dmaring *ring);
+void bcm43xx_dma_tx_suspend(struct bcm43xx_wldev *dev);
+void bcm43xx_dma_tx_resume(struct bcm43xx_wldev *dev);
 
-void bcm43xx_dma_handle_xmitstatus(struct bcm43xx_private *bcm,
-				   struct bcm43xx_xmitstatus *status);
+void bcm43xx_dma_get_tx_stats(struct bcm43xx_wldev *dev,
+			      struct ieee80211_tx_queue_stats *stats);
 
-int bcm43xx_dma_tx(struct bcm43xx_private *bcm,
-		   struct ieee80211_txb *txb);
-void bcm43xx_dma_rx(struct bcm43xx_dmaring *ring);
+int bcm43xx_dma_tx(struct bcm43xx_wldev *dev,
+		   struct sk_buff *skb,
+		   struct ieee80211_tx_control *ctl);
+void bcm43xx_dma_handle_txstatus(struct bcm43xx_wldev *dev,
+				 const struct bcm43xx_txstatus *status);
 
-/* Helper function that returns the dma mask for this device. */
-static inline
-u64 bcm43xx_get_supported_dma_mask(struct bcm43xx_private *bcm)
-{
-	int dma64 = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATEHIGH) &
-				   BCM43xx_SBTMSTATEHIGH_DMA64BIT;
-	u16 mmio_base = bcm43xx_dmacontroller_base(dma64, 0);
-	u32 mask = BCM43xx_DMA32_TXADDREXT_MASK;
-
-	if (dma64)
-		return DMA_64BIT_MASK;
-	bcm43xx_write32(bcm, mmio_base + BCM43xx_DMA32_TXCTL, mask);
-	if (bcm43xx_read32(bcm, mmio_base + BCM43xx_DMA32_TXCTL) & mask)
-		return DMA_32BIT_MASK;
-	return DMA_30BIT_MASK;
-}
+void bcm43xx_dma_rx(struct bcm43xx_dmaring *ring);
 
 #else /* CONFIG_BCM43XX_DMA */
 
 
 static inline
-int bcm43xx_dma_init(struct bcm43xx_private *bcm)
+int bcm43xx_dma_init(struct bcm43xx_wldev *dev)
 {
 	return 0;
 }
 static inline
-void bcm43xx_dma_free(struct bcm43xx_private *bcm)
+void bcm43xx_dma_free(struct bcm43xx_wldev *dev)
 {
 }
 static inline
-int bcm43xx_dmacontroller_rx_reset(struct bcm43xx_private *bcm,
+int bcm43xx_dmacontroller_rx_reset(struct bcm43xx_wldev *dev,
 				   u16 dmacontroller_mmio_base,
 				   int dma64)
 {
 	return 0;
 }
 static inline
-int bcm43xx_dmacontroller_tx_reset(struct bcm43xx_private *bcm,
+int bcm43xx_dmacontroller_tx_reset(struct bcm43xx_wldev *dev,
 				   u16 dmacontroller_mmio_base,
 				   int dma64)
 {
 	return 0;
 }
 static inline
-int bcm43xx_dma_tx(struct bcm43xx_private *bcm,
-		   struct ieee80211_txb *txb)
+void bcm43xx_dma_get_tx_stats(struct bcm43xx_wldev *dev,
+			      struct ieee80211_tx_queue_stats *stats)
+{
+}
+static inline
+int bcm43xx_dma_tx(struct bcm43xx_wldev *dev,
+		   struct sk_buff *skb,
+		   struct ieee80211_tx_control *ctl)
 {
 	return 0;
 }
 static inline
-void bcm43xx_dma_handle_xmitstatus(struct bcm43xx_private *bcm,
-				   struct bcm43xx_xmitstatus *status)
+void bcm43xx_dma_handle_txstatus(struct bcm43xx_wldev *dev,
+				 const struct bcm43xx_txstatus *status)
 {
 }
 static inline
@@ -374,11 +354,11 @@ void bcm43xx_dma_rx(struct bcm43xx_dmari
 {
 }
 static inline
-void bcm43xx_dma_tx_suspend(struct bcm43xx_dmaring *ring)
+void bcm43xx_dma_tx_suspend(struct bcm43xx_wldev *dev)
 {
 }
 static inline
-void bcm43xx_dma_tx_resume(struct bcm43xx_dmaring *ring)
+void bcm43xx_dma_tx_resume(struct bcm43xx_wldev *dev)
 {
 }
 

