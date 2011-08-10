Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58979 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab1HJQSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 12:18:10 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so1024245fxh.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 09:18:10 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: fix DMA on some bugged hardware
Date: Wed, 10 Aug 2011 18:11:28 +0200
Message-Id: <1312992688-6976-2-git-send-email-zajec5@gmail.com> (sfid-20110810_181814_979713_F19C6863)
In-Reply-To: <1312992688-6976-1-git-send-email-zajec5@gmail.com>
References: <1312992688-6976-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some hardware with 64-bit DMA uses lower address word for setting
routing (translation) bit. Add workaround for such boards.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h |    1 +
 drivers/net/wireless/b43/dma.c |   52 ++++++++++++++++++++++++++++++----------
 2 files changed, 40 insertions(+), 13 deletions(-)

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
index 0953ce1..9a2b678 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -174,7 +174,10 @@ static void op64_fill_descriptor(struct b43_dmaring *ring,
 	addrhi = (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
 	addrext = (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
 	    >> SSB_DMA_TRANSLATION_SHIFT;
-	addrhi |= ring->dev->dma.translation;
+	if (ring->dev->dma.translation_in_low)
+		addrlo |= ring->dev->dma.translation;
+	else
+		addrhi |= ring->dev->dma.translation;
 	if (slot == ring->nr_slots - 1)
 		ctl0 |= B43_DMA64_DCTL0_DTABLEEND;
 	if (start)
@@ -656,10 +659,12 @@ static int alloc_initial_descbuffers(struct b43_dmaring *ring)
 static int dmacontroller_setup(struct b43_dmaring *ring)
 {
 	int err = 0;
+	int tmp;
 	u32 value;
 	u32 addrext;
 	u32 trans = ring->dev->dma.translation;
 	bool parity = ring->dev->dma.parity;
+	u32 addrs[2];
 
 	if (ring->tx) {
 		if (ring->type == B43_DMA_64BIT) {
@@ -673,12 +678,14 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 			if (!parity)
 				value |= B43_DMA64_TXPARITYDISABLE;
 			b43_dma_write(ring, B43_DMA64_TXCTL, value);
-			b43_dma_write(ring, B43_DMA64_TXRINGLO,
-				      (ringbase & 0xFFFFFFFF));
-			b43_dma_write(ring, B43_DMA64_TXRINGHI,
-				      ((ringbase >> 32) &
-				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
+
+			addrs[0] = ringbase & 0xFFFFFFFF;
+			addrs[1] = ringbase >> 32;
+			tmp = ring->dev->dma.translation_in_low ? 0 : 1;
+			addrs[tmp] &= ~SSB_DMA_TRANSLATION_MASK;
+			addrs[tmp] |= trans;
+			b43_dma_write(ring, B43_DMA64_TXRINGLO, addrs[0]);
+			b43_dma_write(ring, B43_DMA64_TXRINGHI, addrs[1]);
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
 
@@ -710,12 +717,15 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 			if (!parity)
 				value |= B43_DMA64_RXPARITYDISABLE;
 			b43_dma_write(ring, B43_DMA64_RXCTL, value);
-			b43_dma_write(ring, B43_DMA64_RXRINGLO,
-				      (ringbase & 0xFFFFFFFF));
-			b43_dma_write(ring, B43_DMA64_RXRINGHI,
-				      ((ringbase >> 32) &
-				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
+
+			addrs[0] = ringbase & 0xFFFFFFFF;
+			addrs[1] = ringbase >> 32;
+			tmp = ring->dev->dma.translation_in_low ? 0 : 1;
+			addrs[tmp] &= ~SSB_DMA_TRANSLATION_MASK;
+			addrs[tmp] |= trans;
+			b43_dma_write(ring, B43_DMA64_RXRINGLO, addrs[0]);
+			b43_dma_write(ring, B43_DMA64_RXRINGHI, addrs[1]);
+
 			b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
 				      sizeof(struct b43_dmadesc64));
 		} else {
@@ -1052,6 +1062,21 @@ static int b43_dma_set_mask(struct b43_wldev *dev, u64 mask)
 	return 0;
 }
 
+/* Some hardware with 64-bit DMA seems to be bugged and looks for translation
+ * bit in low address word instead of high one.
+ */
+static bool b43_dma_translation_in_low_word(struct b43_wldev *dev)
+{
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
@@ -1077,6 +1102,7 @@ int b43_dma_init(struct b43_wldev *dev)
 		break;
 #endif
 	}
+	dma->translation_in_low = b43_dma_translation_in_low_word(dev);
 
 	dma->parity = true;
 #ifdef CONFIG_B43_BCMA
-- 
1.7.1

