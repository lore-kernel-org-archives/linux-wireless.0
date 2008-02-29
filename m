Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:55638 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbYB2L5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 06:57:04 -0500
From: Michael Buesch <mb@bu3sch.de>
To: stable@kernel.org
Subject: [PATCH stable] b43: Backport bcm4311 fix
Date: Fri, 29 Feb 2008 12:55:41 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	"Alexey Zaytsev" <alexey.zaytsev@gmail.com>,
	"Greg KH" <greg@kroah.com>
MIME-Version: 1.0
Message-Id: <200802291255.41906.mb@bu3sch.de> (sfid-20080229_115710_128837_1D4C1D56)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

    The changes include the following:
    
    (1) Add the 802.11 rev 13 device to the ssb_device_id table to load b43.
    (2) Add PHY revision 9 to the supported list.
    (3) Change the 2-bit routing code for address extensions to 0b10 rather
        than the 0b01 used for the 32-bit case.
    (4) Remove some magic numbers in the DMA setup.
    
    The DMA implementation for this chip supports full 64-bit addressing with
    one exception. Whenever the Descriptor Ring Buffer is in high memory, a
    fatal DMA error occurs. This problem was not present in 2.6.24-rc2 due
    to code to "Bias the placement of kernel pages at lower PFNs". When
    commit 44048d70 reverted that code, the DMA error appeared. As a "fix",
    use the GFP_DMA flag when allocating the buffer for 64-bit DMA. At present,
    this problem is thought to arise from a hardware error.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: linux-2.6.24.3/drivers/net/wireless/b43/dma.c
===================================================================
--- linux-2.6.24.3.orig/drivers/net/wireless/b43/dma.c	2008-02-29 12:41:06.000000000 +0100
+++ linux-2.6.24.3/drivers/net/wireless/b43/dma.c	2008-02-29 12:41:58.000000000 +0100
@@ -162,13 +162,13 @@ static void op64_fill_descriptor(struct 
 	B43_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
 
 	addrlo = (u32) (dmaaddr & 0xFFFFFFFF);
 	addrhi = (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
 	addrext = (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
 	    >> SSB_DMA_TRANSLATION_SHIFT;
-	addrhi |= ssb_dma_translation(ring->dev->dev);
+	addrhi |= (ssb_dma_translation(ring->dev->dev) << 1);
 	if (slot == ring->nr_slots - 1)
 		ctl0 |= B43_DMA64_DCTL0_DTABLEEND;
 	if (start)
 		ctl0 |= B43_DMA64_DCTL0_FRAMESTART;
 	if (end)
 		ctl0 |= B43_DMA64_DCTL0_FRAMEEND;
@@ -423,15 +423,27 @@ static inline
 	}
 }
 
 static int alloc_ringmemory(struct b43_dmaring *ring)
 {
 	struct device *dev = ring->dev->dev->dev;
+	gfp_t flags = GFP_KERNEL;
 
+	/* The specs call for 4K buffers for 30- and 32-bit DMA with 4K
+	 * alignment and 8K buffers for 64-bit DMA with 8K alignment. Testing
+	 * has shown that 4K is sufficient for the latter as long as the buffer
+	 * does not cross an 8K boundary.
+	 *
+	 * For unknown reasons - possibly a hardware error - the BCM4311 rev
+	 * 02, which uses 64-bit DMA, needs the ring buffer in very low memory,
+	 * which accounts for the GFP_DMA flag below.
+	 */
+	if (ring->dma64)
+		flags |= GFP_DMA;
 	ring->descbase = dma_alloc_coherent(dev, B43_DMA_RINGMEMSIZE,
-					    &(ring->dmabase), GFP_KERNEL);
+					    &(ring->dmabase), flags);
 	if (!ring->descbase) {
 		b43err(ring->dev->wl, "DMA ringmemory allocation failed\n");
 		return -ENOMEM;
 	}
 	memset(ring->descbase, 0, B43_DMA_RINGMEMSIZE);
 
@@ -480,13 +492,13 @@ int b43_dmacontroller_rx_reset(struct b4
 		return -ENODEV;
 	}
 
 	return 0;
 }
 
-/* Reset the RX DMA channel */
+/* Reset the TX DMA channel */
 int b43_dmacontroller_tx_reset(struct b43_wldev *dev, u16 mmio_base, int dma64)
 {
 	int i;
 	u32 value;
 	u16 offset;
 
@@ -644,13 +656,13 @@ static int dmacontroller_setup(struct b4
 			b43_dma_write(ring, B43_DMA64_TXCTL, value);
 			b43_dma_write(ring, B43_DMA64_TXRINGLO,
 				      (ringbase & 0xFFFFFFFF));
 			b43_dma_write(ring, B43_DMA64_TXRINGHI,
 				      ((ringbase >> 32) &
 				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
+				      | (trans << 1));
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
 
 			addrext = (ringbase & SSB_DMA_TRANSLATION_MASK)
 			    >> SSB_DMA_TRANSLATION_SHIFT;
 			value = B43_DMA32_TXENABLE;
@@ -677,14 +689,15 @@ static int dmacontroller_setup(struct b4
 			b43_dma_write(ring, B43_DMA64_RXCTL, value);
 			b43_dma_write(ring, B43_DMA64_RXRINGLO,
 				      (ringbase & 0xFFFFFFFF));
 			b43_dma_write(ring, B43_DMA64_RXRINGHI,
 				      ((ringbase >> 32) &
 				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
-			b43_dma_write(ring, B43_DMA64_RXINDEX, 200);
+				      | (trans << 1));
+			b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
+				      sizeof(struct b43_dmadesc64));
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
 
 			addrext = (ringbase & SSB_DMA_TRANSLATION_MASK)
 			    >> SSB_DMA_TRANSLATION_SHIFT;
 			value = (ring->frameoffset << B43_DMA32_RXFROFF_SHIFT);
@@ -692,17 +705,18 @@ static int dmacontroller_setup(struct b4
 			value |= (addrext << B43_DMA32_RXADDREXT_SHIFT)
 			    & B43_DMA32_RXADDREXT_MASK;
 			b43_dma_write(ring, B43_DMA32_RXCTL, value);
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
 
 /* Shutdown the DMA controller. */
 static void dmacontroller_cleanup(struct b43_dmaring *ring)
 {
Index: linux-2.6.24.3/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.24.3.orig/drivers/net/wireless/b43/main.c	2008-02-29 12:41:06.000000000 +0100
+++ linux-2.6.24.3/drivers/net/wireless/b43/main.c	2008-02-29 12:41:58.000000000 +0100
@@ -98,12 +98,13 @@ MODULE_PARM_DESC(nohwcrypt, "Disable har
 static const struct ssb_device_id b43_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 5),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 6),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 7),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
+	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 13),
 	SSB_DEVTABLE_END
 };
 
 MODULE_DEVICE_TABLE(ssb, b43_ssb_tbl);
 
 /* Channel and ratetables are shared for all devices.
@@ -3076,13 +3077,13 @@ static int b43_phy_versioning(struct b43
 	case B43_PHYTYPE_B:
 		if (phy_rev != 2 && phy_rev != 4 && phy_rev != 6
 		    && phy_rev != 7)
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_G:
-		if (phy_rev > 8)
+		if (phy_rev > 9)
 			unsupported = 1;
 		break;
 	default:
 		unsupported = 1;
 	};
 	if (unsupported) {
