Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44288 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbXKOFzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 00:55:45 -0500
Date: Wed, 14 Nov 2007 23:55:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: seandarcy2@gmail.com, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [RFC/T] b43: Implement the BCM94311MCG rev 02 card with a rev 13
 802.11 core
Message-ID: <473bdf5e.LS8yn+6u1JmDiT9C%Larry.Finger@lwfinger.net> (sfid-20071115_055550_070575_84120727)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch file will enable the usage of the b43 driver with the
BCM94311MCG wlan mini-PCI (rev 02), which has not been supported.
This PCIe card uses 64-bit DMA. Most of the changes were needed
to implement this mode. It has been tested on the x86_64 architecture,
but should work on all platforms. FYI, full 64-bit DMA addressing
is implemented and the driver should work with a full 2^(64) bytes
of RAM. No, I have not tested that feature!

This patch is intended to be applied to the everything branch of
the wireless-2.6 git tree. For it to work, the set of 6 patches to
modify the SPROM handling code of ssb that I recently submitted must
be applied as well.

There is one anomaly with the code. When it initializes the DMA, and
enables interrupts for the first time, a single "PHY TX Error" is
generated. I have code to suppress that error message; however, it was
in the bottom-half interrupt handler, and I'm still trying to fix it
in less critical code.

The commitment text is shown below:

Larry
==================================================================

The BCM94311MCG rev 02 chip has an 802.11 core with revision 13 and
has not been supported until now. The changes include the following:

(1) Adding the 802.11 rev 13 device to the ssb_device_id table to load b43.
(2) Change the descriptor ring buffers allocation to 8K to force alignment
    on 8K boundary.
(3) Added PHY revision 9 to the supported list.
(4) Fixed 64-bit addressing errors.
(5) Removed some magic numbers in the DMA setup.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 dma.c  |   39 ++++++++++++++++-----------------------
 dma.h  |    7 +++++++
 main.c |    3 ++-
 3 files changed, 25 insertions(+), 24 deletions(-)

Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c
+++ wireless-2.6/drivers/net/wireless/b43/main.c
@@ -93,6 +93,7 @@ static const struct ssb_device_id b43_ss
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 7),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
+	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 13),
 	SSB_DEVTABLE_END
 };
 
@@ -3061,7 +3062,7 @@ static int b43_phy_versioning(struct b43
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_G:
-		if (phy_rev > 8)
+		if (phy_rev > 9)
 			unsupported = 1;
 		break;
 	default:
Index: wireless-2.6/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/dma.c
+++ wireless-2.6/drivers/net/wireless/b43/dma.c
@@ -165,7 +165,7 @@ static void op64_fill_descriptor(struct 
 	addrhi = (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
 	addrext = (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
 	    >> SSB_DMA_TRANSLATION_SHIFT;
-	addrhi |= ssb_dma_translation(ring->dev->dev);
+	addrhi |= (ssb_dma_translation(ring->dev->dev) << 1);
 	if (slot == ring->nr_slots - 1)
 		ctl0 |= B43_DMA64_DCTL0_DTABLEEND;
 	if (start)
@@ -426,14 +426,15 @@ static inline
 static int alloc_ringmemory(struct b43_dmaring *ring)
 {
 	struct device *dev = ring->dev->dev->dev;
+	int size = (ring->dma64) ? 8192 : B43_DMA_RINGMEMSIZE;
 
-	ring->descbase = dma_alloc_coherent(dev, B43_DMA_RINGMEMSIZE,
+	ring->descbase = dma_alloc_coherent(dev, size,
 					    &(ring->dmabase), GFP_KERNEL);
 	if (!ring->descbase) {
 		b43err(ring->dev->wl, "DMA ringmemory allocation failed\n");
 		return -ENOMEM;
 	}
-	memset(ring->descbase, 0, B43_DMA_RINGMEMSIZE);
+	memset(ring->descbase, 0, size);
 
 	return 0;
 }
@@ -483,7 +484,7 @@ int b43_dmacontroller_rx_reset(struct b4
 	return 0;
 }
 
-/* Reset the RX DMA channel */
+/* Reset the TX DMA channel */
 int b43_dmacontroller_tx_reset(struct b43_wldev *dev, u16 mmio_base, int dma64)
 {
 	int i;
@@ -636,18 +637,13 @@ static int dmacontroller_setup(struct b4
 		if (ring->dma64) {
 			u64 ringbase = (u64) (ring->dmabase);
 
-			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
-			    >> SSB_DMA_TRANSLATION_SHIFT;
-			value = B43_DMA64_TXENABLE;
-			value |= (addrext << B43_DMA64_TXADDREXT_SHIFT)
-			    & B43_DMA64_TXADDREXT_MASK;
-			b43_dma_write(ring, B43_DMA64_TXCTL, value);
+			b43_dma_write(ring, B43_DMA64_TXCTL,
+				      B43_DMA64_TXENABLE);
 			b43_dma_write(ring, B43_DMA64_TXRINGLO,
 				      (ringbase & 0xFFFFFFFF));
 			b43_dma_write(ring, B43_DMA64_TXRINGHI,
 				      ((ringbase >> 32) &
-				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
+				       0xFFFFFFFF));
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
 
@@ -668,20 +664,16 @@ static int dmacontroller_setup(struct b4
 		if (ring->dma64) {
 			u64 ringbase = (u64) (ring->dmabase);
 
-			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
-			    >> SSB_DMA_TRANSLATION_SHIFT;
-			value = (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT);
-			value |= B43_DMA64_RXENABLE;
-			value |= (addrext << B43_DMA64_RXADDREXT_SHIFT)
-			    & B43_DMA64_RXADDREXT_MASK;
+			value = (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT)
+				| B43_DMA64_RXENABLE;
 			b43_dma_write(ring, B43_DMA64_RXCTL, value);
 			b43_dma_write(ring, B43_DMA64_RXRINGLO,
 				      (ringbase & 0xFFFFFFFF));
 			b43_dma_write(ring, B43_DMA64_RXRINGHI,
 				      ((ringbase >> 32) &
-				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
-			b43_dma_write(ring, B43_DMA64_RXINDEX, 200);
+				       0xFFFFFFFF));
+			b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
+				      sizeof(struct b43_dmadesc64));
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
 
@@ -695,11 +687,12 @@ static int dmacontroller_setup(struct b4
 			b43_dma_write(ring, B43_DMA32_RXRING,
 				      (ringbase & ~SSB_DMA_TRANSLATION_MASK)
 				      | trans);
-			b43_dma_write(ring, B43_DMA32_RXINDEX, 200);
+			b43_dma_write(ring, B43_DMA32_RXINDEX, ring->nr_slots *
+				      sizeof(struct b43_dmadesc32));
 		}
 	}
 
-      out:
+out:
 	return err;
 }
 
Index: wireless-2.6/drivers/net/wireless/b43/dma.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/dma.h
+++ wireless-2.6/drivers/net/wireless/b43/dma.h
@@ -260,6 +260,13 @@ static inline u32 b43_dma_read(struct b4
 static inline
     void b43_dma_write(struct b43_dmaring *ring, u16 offset, u32 value)
 {
+	/* temporary debugging code */
+	if (((offset == 8) || (offset == 0x28)) && ring->dma64 &&
+	     ((value & 0x1FFF) != 0)) {
+		printk(KERN_ERR "b43: bad desc ring address for 64-bit DMA"
+		       " - offset, value: 0x%.2X 0x%.4X\n", offset, value);
+		dump_stack();
+	}
 	b43_write32(ring->dev, ring->mmio_base + offset, value);
 }
 
