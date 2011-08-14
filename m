Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36694 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1HNRAk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 13:00:40 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so3189617fxh.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 10:00:40 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 3.2 2/2] b43: fix DMA on some bugged hardware
Date: Sun, 14 Aug 2011 19:39:41 +0200
Message-Id: <1313343581-4395-2-git-send-email-zajec5@gmail.com> (sfid-20110814_190044_340396_2D7C2671)
In-Reply-To: <1313343581-4395-1-git-send-email-zajec5@gmail.com>
References: <1313343581-4395-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some hardware with 64-bit DMA uses lower address word for setting
routing (translation) bit. Add workaround for such boards.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: use (u64) to fix compilation on 32-bit systems

Larry: could you give it a try?

John: we gave it a change, I failed. Please take it for 3.2, don't
want to risk more problems.
---
 drivers/net/wireless/b43/b43.h |    1 +
 drivers/net/wireless/b43/dma.c |  113 +++++++++++++++++++++++++++-------------
 drivers/net/wireless/b43/dma.h |    6 ++
 3 files changed, 84 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index c818b0b..3aee322 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -594,6 +594,7 @@ struct b43_dma {
 	struct b43_dmaring *rx_ring;
 
 	u32 translation; /* Routing bits */
+	bool translation_in_low; /* Should translation bit go into low addr? */
 	bool parity; /* Check for parity */
 };
 
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 481e534..276eb0e 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -47,6 +47,38 @@
  * into separate slots. */
 #define TX_SLOTS_PER_FRAME	2
 
+static u32 b43_dma_address(struct b43_dma *dma, dma_addr_t dmaaddr,
+			   enum b43_addrtype addrtype)
+{
+	u32 uninitialized_var(addr);
+
+	switch (addrtype) {
+	case B43_DMA_ADDR_LOW:
+		addr = dmaaddr & 0xFFFFFFFF;
+		if (dma->translation_in_low) {
+			addr &= ~SSB_DMA_TRANSLATION_MASK;
+			addr |= dma->translation;
+		}
+		break;
+	case B43_DMA_ADDR_HIGH:
+		addr = (u64) dmaaddr >> 32;
+		if (!dma->translation_in_low) {
+			addr &= ~SSB_DMA_TRANSLATION_MASK;
+			addr |= dma->translation;
+		}
+		break;
+	case B43_DMA_ADDR_EXT:
+		if (dma->translation_in_low)
+			addr = dmaaddr & 0xFFFFFFFF;
+		else
+			addr = (u64) dmaaddr >> 32;
+		addr &= SSB_DMA_TRANSLATION_MASK;
+		addr >>= SSB_DMA_TRANSLATION_SHIFT;
+		break;
+	}
+
+	return addr;
+}
 
 /* 32bit DMA ops. */
 static
@@ -77,10 +109,9 @@ static void op32_fill_descriptor(struct b43_dmaring *ring,
 	slot = (int)(&(desc->dma32) - descbase);
 	B43_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
 
-	addr = (u32) (dmaaddr & ~SSB_DMA_TRANSLATION_MASK);
-	addrext = (u32) (dmaaddr & SSB_DMA_TRANSLATION_MASK)
-	    >> SSB_DMA_TRANSLATION_SHIFT;
-	addr |= ring->dev->dma.translation;
+	addr = b43_dma_address(&ring->dev->dma, dmaaddr, B43_DMA_ADDR_LOW);
+	addrext = b43_dma_address(&ring->dev->dma, dmaaddr, B43_DMA_ADDR_EXT);
+
 	ctl = bufsize & B43_DMA32_DCTL_BYTECNT;
 	if (slot == ring->nr_slots - 1)
 		ctl |= B43_DMA32_DCTL_DTABLEEND;
@@ -170,11 +201,10 @@ static void op64_fill_descriptor(struct b43_dmaring *ring,
 	slot = (int)(&(desc->dma64) - descbase);
 	B43_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
 
-	addrlo = (u32) (dmaaddr & 0xFFFFFFFF);
-	addrhi = (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
-	addrext = (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
-	    >> SSB_DMA_TRANSLATION_SHIFT;
-	addrhi |= ring->dev->dma.translation;
+	addrlo = b43_dma_address(&ring->dev->dma, dmaaddr, B43_DMA_ADDR_LOW);
+	addrhi = b43_dma_address(&ring->dev->dma, dmaaddr, B43_DMA_ADDR_HIGH);
+	addrext = b43_dma_address(&ring->dev->dma, dmaaddr, B43_DMA_ADDR_EXT);
+
 	if (slot == ring->nr_slots - 1)
 		ctl0 |= B43_DMA64_DCTL0_DTABLEEND;
 	if (start)
@@ -658,41 +688,37 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 	int err = 0;
 	u32 value;
 	u32 addrext;
-	u32 trans = ring->dev->dma.translation;
 	bool parity = ring->dev->dma.parity;
+	u32 addrlo;
+	u32 addrhi;
 
 	if (ring->tx) {
 		if (ring->type == B43_DMA_64BIT) {
 			u64 ringbase = (u64) (ring->dmabase);
+			addrext = b43_dma_address(&ring->dev->dma, ringbase, B43_DMA_ADDR_EXT);
+			addrlo = b43_dma_address(&ring->dev->dma, ringbase, B43_DMA_ADDR_LOW);
+			addrhi = b43_dma_address(&ring->dev->dma, ringbase, B43_DMA_ADDR_HIGH);
 
-			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
-			    >> SSB_DMA_TRANSLATION_SHIFT;
 			value = B43_DMA64_TXENABLE;
 			value |= (addrext << B43_DMA64_TXADDREXT_SHIFT)
 			    & B43_DMA64_TXADDREXT_MASK;
 			if (!parity)
 				value |= B43_DMA64_TXPARITYDISABLE;
 			b43_dma_write(ring, B43_DMA64_TXCTL, value);
-			b43_dma_write(ring, B43_DMA64_TXRINGLO,
-				      (ringbase & 0xFFFFFFFF));
-			b43_dma_write(ring, B43_DMA64_TXRINGHI,
-				      ((ringbase >> 32) &
-				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
+			b43_dma_write(ring, B43_DMA64_TXRINGLO, addrlo);
+			b43_dma_write(ring, B43_DMA64_TXRINGHI, addrhi);
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
+			addrext = b43_dma_address(&ring->dev->dma, ringbase, B43_DMA_ADDR_EXT);
+			addrlo = b43_dma_address(&ring->dev->dma, ringbase, B43_DMA_ADDR_LOW);
 
-			addrext = (ringbase & SSB_DMA_TRANSLATION_MASK)
-			    >> SSB_DMA_TRANSLATION_SHIFT;
 			value = B43_DMA32_TXENABLE;
 			value |= (addrext << B43_DMA32_TXADDREXT_SHIFT)
 			    & B43_DMA32_TXADDREXT_MASK;
 			if (!parity)
 				value |= B43_DMA32_TXPARITYDISABLE;
 			b43_dma_write(ring, B43_DMA32_TXCTL, value);
-			b43_dma_write(ring, B43_DMA32_TXRING,
-				      (ringbase & ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
+			b43_dma_write(ring, B43_DMA32_TXRING, addrlo);
 		}
 	} else {
 		err = alloc_initial_descbuffers(ring);
@@ -700,9 +726,10 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 			goto out;
 		if (ring->type == B43_DMA_64BIT) {
 			u64 ringbase = (u64) (ring->dmabase);
+			addrext = b43_dma_address(&ring->dev->dma, ringbase, B43_DMA_ADDR_EXT);
+			addrlo = b43_dma_address(&ring->dev->dma, ringbase, B43_DMA_ADDR_LOW);
+			addrhi = b43_dma_address(&ring->dev->dma, ringbase, B43_DMA_ADDR_HIGH);
 
-			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
-			    >> SSB_DMA_TRANSLATION_SHIFT;
 			value = (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT);
 			value |= B43_DMA64_RXENABLE;
 			value |= (addrext << B43_DMA64_RXADDREXT_SHIFT)
@@ -710,19 +737,15 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 			if (!parity)
 				value |= B43_DMA64_RXPARITYDISABLE;
 			b43_dma_write(ring, B43_DMA64_RXCTL, value);
-			b43_dma_write(ring, B43_DMA64_RXRINGLO,
-				      (ringbase & 0xFFFFFFFF));
-			b43_dma_write(ring, B43_DMA64_RXRINGHI,
-				      ((ringbase >> 32) &
-				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
+			b43_dma_write(ring, B43_DMA64_RXRINGLO, addrlo);
+			b43_dma_write(ring, B43_DMA64_RXRINGHI, addrhi);
 			b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
 				      sizeof(struct b43_dmadesc64));
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
+			addrext = b43_dma_address(&ring->dev->dma, ringbase, B43_DMA_ADDR_EXT);
+			addrlo = b43_dma_address(&ring->dev->dma, ringbase, B43_DMA_ADDR_LOW);
 
-			addrext = (ringbase & SSB_DMA_TRANSLATION_MASK)
-			    >> SSB_DMA_TRANSLATION_SHIFT;
 			value = (ring->frameoffset << B43_DMA32_RXFROFF_SHIFT);
 			value |= B43_DMA32_RXENABLE;
 			value |= (addrext << B43_DMA32_RXADDREXT_SHIFT)
@@ -730,9 +753,7 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 			if (!parity)
 				value |= B43_DMA32_RXPARITYDISABLE;
 			b43_dma_write(ring, B43_DMA32_RXCTL, value);
-			b43_dma_write(ring, B43_DMA32_RXRING,
-				      (ringbase & ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
+			b43_dma_write(ring, B43_DMA32_RXRING, addrlo);
 			b43_dma_write(ring, B43_DMA32_RXINDEX, ring->nr_slots *
 				      sizeof(struct b43_dmadesc32));
 		}
@@ -1066,6 +1087,25 @@ static int b43_dma_set_mask(struct b43_wldev *dev, u64 mask)
 	return 0;
 }
 
+/* Some hardware with 64-bit DMA seems to be bugged and looks for translation
+ * bit in low address word instead of high one.
+ */
+static bool b43_dma_translation_in_low_word(struct b43_wldev *dev,
+					    enum b43_dmatype type)
+{
+	if (type != B43_DMA_64BIT)
+		return 1;
+
+#ifdef CONFIG_B43_SSB
+	if (dev->dev->bus_type == B43_BUS_SSB &&
+	    dev->dev->sdev->bus->bustype == SSB_BUSTYPE_PCI &&
+	    !(dev->dev->sdev->bus->host_pci->is_pcie &&
+	      ssb_read32(dev->dev->sdev, SSB_TMSHIGH) & SSB_TMSHIGH_DMA64))
+			return 1;
+#endif
+	return 0;
+}
+
 int b43_dma_init(struct b43_wldev *dev)
 {
 	struct b43_dma *dma = &dev->dma;
@@ -1091,6 +1131,7 @@ int b43_dma_init(struct b43_wldev *dev)
 		break;
 #endif
 	}
+	dma->translation_in_low = b43_dma_translation_in_low_word(dev, type);
 
 	dma->parity = true;
 #ifdef CONFIG_B43_BCMA
diff --git a/drivers/net/wireless/b43/dma.h b/drivers/net/wireless/b43/dma.h
index cdf8709..1a5313d 100644
--- a/drivers/net/wireless/b43/dma.h
+++ b/drivers/net/wireless/b43/dma.h
@@ -212,6 +212,12 @@ enum b43_dmatype {
 	B43_DMA_64BIT	= 64,
 };
 
+enum b43_addrtype {
+	B43_DMA_ADDR_LOW,
+	B43_DMA_ADDR_HIGH,
+	B43_DMA_ADDR_EXT,
+};
+
 struct b43_dmaring {
 	/* Lowlevel DMA ops. */
 	const struct b43_dma_ops *ops;
-- 
1.7.3.4

