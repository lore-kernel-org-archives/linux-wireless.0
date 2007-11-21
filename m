Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50910 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbXKUViO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 16:38:14 -0500
Date: Wed, 21 Nov 2007 15:38:12 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH V2] b43: Changes to enable BCM4311 rev 02 with wireless
 core revision 13
Message-ID: <4744a544.OLz3JRLe85L+V2nd%Larry.Finger@lwfinger.net> (sfid-20071121_213819_126291_E7F42BF0)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The BCM94311MCG rev 02 chip has an 802.11 core with revision 13 and
has not been supported until now. The changes include the following:

(1) Add the 802.11 rev 13 device to the ssb_device_id table to load b43=
=2E
(2) Add PHY revision 9 to the supported list.
(3) Fix 64-bit addressing errors.
(4) Remove some magic numbers in the DMA setup.

The DMA implementation for this chip supports full 64-bit addressing wi=
th
one exception. Whenever the Descriptor Ring Buffer is in high memory, a
fatal DMA error occurs. This problem was not present in 2.6.24-rc2 due
to code to "Bias the placement of kernel pages at lower PFNs". When
commit 44048d70 reverted that code, the DMA error appeared. As a "fix",
use the GFP_DMA flag when allocating the buffer for 64-bit DMA. At pres=
ent,
this problem is thought to arise from a hardware error.

This patch has been tested on my system and by C=C3=A9dric Caumont
<icare40@hotmail.com>.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch is intended for the everything branch of wireless-2.6.

Larry
---

 dma.c  |   50 ++++++++++++++++++++++++++------------------------
 main.c |    3 ++-
 wa.c   |    1 +
 3 files changed, 29 insertions(+), 25 deletions(-)

Index: wireless-2.6/drivers/net/wireless/b43/dma.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-2.6.orig/drivers/net/wireless/b43/dma.c
+++ wireless-2.6/drivers/net/wireless/b43/dma.c
@@ -165,7 +165,7 @@ static void op64_fill_descriptor(struct=20
 	addrhi =3D (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
 	addrext =3D (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
 	    >> SSB_DMA_TRANSLATION_SHIFT;
-	addrhi |=3D ssb_dma_translation(ring->dev->dev);
+	addrhi |=3D (ssb_dma_translation(ring->dev->dev) << 1);
 	if (slot =3D=3D ring->nr_slots - 1)
 		ctl0 |=3D B43_DMA64_DCTL0_DTABLEEND;
 	if (start)
@@ -426,9 +426,21 @@ static inline
 static int alloc_ringmemory(struct b43_dmaring *ring)
 {
 	struct device *dev =3D ring->dev->dev->dev;
+	gfp_t flags =3D GFP_KERNEL;
=20
+	/* The specs call for 4K buffers for 30- and 32-bit DMA with 4K
+	 * alignment and 8K buffers for 64-bit DMA with 8K alignment. Testing
+	 * has shown that 4K is sufficient for the latter as long as the buff=
er
+	 * does not cross an 8K boundary.
+	 *
+	 * For unknown reasons - possibly a hardware error - the BCM4311 rev
+	 * 02, which uses 64-bit DMA, needs the ring buffer in very low memor=
y,
+	 * which accounts for the GFP_DMA flag below.
+	 */
+	if (ring->dma64)
+		flags =3D GFP_DMA;
 	ring->descbase =3D dma_alloc_coherent(dev, B43_DMA_RINGMEMSIZE,
-					    &(ring->dmabase), GFP_KERNEL);
+					    &(ring->dmabase), flags);
 	if (!ring->descbase) {
 		b43err(ring->dev->wl, "DMA ringmemory allocation failed\n");
 		return -ENOMEM;
@@ -483,7 +495,7 @@ int b43_dmacontroller_rx_reset(struct b4
 	return 0;
 }
=20
-/* Reset the RX DMA channel */
+/* Reset the TX DMA channel */
 int b43_dmacontroller_tx_reset(struct b43_wldev *dev, u16 mmio_base, i=
nt dma64)
 {
 	int i;
@@ -636,18 +648,12 @@ static int dmacontroller_setup(struct b4
 		if (ring->dma64) {
 			u64 ringbase =3D (u64) (ring->dmabase);
=20
-			addrext =3D ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
-			    >> SSB_DMA_TRANSLATION_SHIFT;
-			value =3D B43_DMA64_TXENABLE;
-			value |=3D (addrext << B43_DMA64_TXADDREXT_SHIFT)
-			    & B43_DMA64_TXADDREXT_MASK;
-			b43_dma_write(ring, B43_DMA64_TXCTL, value);
+			b43_dma_write(ring, B43_DMA64_TXCTL,
+				      B43_DMA64_TXENABLE);
 			b43_dma_write(ring, B43_DMA64_TXRINGLO,
 				      (ringbase & 0xFFFFFFFF));
 			b43_dma_write(ring, B43_DMA64_TXRINGHI,
-				      ((ringbase >> 32) &
-				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
+				      (ringbase >> 32));
 		} else {
 			u32 ringbase =3D (u32) (ring->dmabase);
=20
@@ -668,20 +674,15 @@ static int dmacontroller_setup(struct b4
 		if (ring->dma64) {
 			u64 ringbase =3D (u64) (ring->dmabase);
=20
-			addrext =3D ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
-			    >> SSB_DMA_TRANSLATION_SHIFT;
-			value =3D (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT);
-			value |=3D B43_DMA64_RXENABLE;
-			value |=3D (addrext << B43_DMA64_RXADDREXT_SHIFT)
-			    & B43_DMA64_RXADDREXT_MASK;
+			value =3D (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT)
+				| B43_DMA64_RXENABLE;
 			b43_dma_write(ring, B43_DMA64_RXCTL, value);
 			b43_dma_write(ring, B43_DMA64_RXRINGLO,
 				      (ringbase & 0xFFFFFFFF));
 			b43_dma_write(ring, B43_DMA64_RXRINGHI,
-				      ((ringbase >> 32) &
-				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
-			b43_dma_write(ring, B43_DMA64_RXINDEX, 200);
+				      (ringbase >> 32));
+			b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
+				      sizeof(struct b43_dmadesc64));
 		} else {
 			u32 ringbase =3D (u32) (ring->dmabase);
=20
@@ -695,11 +696,12 @@ static int dmacontroller_setup(struct b4
 			b43_dma_write(ring, B43_DMA32_RXRING,
 				      (ringbase & ~SSB_DMA_TRANSLATION_MASK)
 				      | trans);
-			b43_dma_write(ring, B43_DMA32_RXINDEX, 200);
+			b43_dma_write(ring, B43_DMA32_RXINDEX, ring->nr_slots *
+				      sizeof(struct b43_dmadesc32));
 		}
 	}
=20
-      out:
+out:
 	return err;
 }
=20
Index: wireless-2.6/drivers/net/wireless/b43/main.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c
+++ wireless-2.6/drivers/net/wireless/b43/main.c
@@ -93,6 +93,7 @@ static const struct ssb_device_id b43_ss
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 7),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
+	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 13),
 	SSB_DEVTABLE_END
 };
=20
@@ -3064,7 +3065,7 @@ static int b43_phy_versioning(struct b43
 			unsupported =3D 1;
 		break;
 	case B43_PHYTYPE_G:
-		if (phy_rev > 8)
+		if (phy_rev > 9)
 			unsupported =3D 1;
 		break;
 	default:
Index: wireless-2.6/drivers/net/wireless/b43/wa.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-2.6.orig/drivers/net/wireless/b43/wa.c
+++ wireless-2.6/drivers/net/wireless/b43/wa.c
@@ -642,6 +642,7 @@ void b43_wa_all(struct b43_wldev *dev)
 		case 6:
 		case 7:
 		case 8:
+		case 9:
 			b43_wa_tr_ltov(dev);
 			b43_wa_crs_ed(dev);
 			b43_wa_rssi_lt(dev);
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
