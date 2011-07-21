Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:53799 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab1GUVqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 17:46:17 -0400
Received: by fxd18 with SMTP id 18so4086815fxd.11
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 14:46:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43legacy: dma: cache translation (routing bits)
Date: Fri, 22 Jul 2011 00:25:00 +0200
Message-Id: <1311287100-3888-1-git-send-email-zajec5@gmail.com> (sfid-20110721_234620_239837_87DD6AF4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Ideally this should have been applied before:
ssb: return correct translation bit for 64-bit DMA

This is because mentioned patch added TMSHIGH register read on every
ssb_dma_translation call which affected performance.

If we can live with affected performance between that 2 commits, please
just apply this ASAP.

It affected performance (however I don't expect anything like making it
90% slower) is not acceptable, please revert mentioned patch, apply this
one and then re-apply reverted patches.
---
 drivers/net/wireless/b43legacy/b43legacy.h |    2 ++
 drivers/net/wireless/b43legacy/dma.c       |    7 ++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/b43legacy.h b/drivers/net/wireless/b43legacy/b43legacy.h
index 23583be..17a130d 100644
--- a/drivers/net/wireless/b43legacy/b43legacy.h
+++ b/drivers/net/wireless/b43legacy/b43legacy.h
@@ -532,6 +532,8 @@ struct b43legacy_dma {
 
 	struct b43legacy_dmaring *rx_ring0;
 	struct b43legacy_dmaring *rx_ring3; /* only on core.rev < 5 */
+
+	u32 translation; /* Routing bits */
 };
 
 /* Data structures for PIO transmission, per 80211 core. */
diff --git a/drivers/net/wireless/b43legacy/dma.c b/drivers/net/wireless/b43legacy/dma.c
index c33934a..704ee62 100644
--- a/drivers/net/wireless/b43legacy/dma.c
+++ b/drivers/net/wireless/b43legacy/dma.c
@@ -73,7 +73,7 @@ static void op32_fill_descriptor(struct b43legacy_dmaring *ring,
 	addr = (u32)(dmaaddr & ~SSB_DMA_TRANSLATION_MASK);
 	addrext = (u32)(dmaaddr & SSB_DMA_TRANSLATION_MASK)
 		   >> SSB_DMA_TRANSLATION_SHIFT;
-	addr |= ssb_dma_translation(ring->dev->dev);
+	addr |= ring->dev->dma.translation;
 	ctl = (bufsize - ring->frameoffset)
 	      & B43legacy_DMA32_DCTL_BYTECNT;
 	if (slot == ring->nr_slots - 1)
@@ -175,7 +175,7 @@ static void op64_fill_descriptor(struct b43legacy_dmaring *ring,
 	addrhi = (((u64)dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
 	addrext = (((u64)dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
 		  >> SSB_DMA_TRANSLATION_SHIFT;
-	addrhi |= ssb_dma_translation(ring->dev->dev);
+	addrhi |= ring->dev->dma.translation;
 	if (slot == ring->nr_slots - 1)
 		ctl0 |= B43legacy_DMA64_DCTL0_DTABLEEND;
 	if (start)
@@ -709,7 +709,7 @@ static int dmacontroller_setup(struct b43legacy_dmaring *ring)
 	int err = 0;
 	u32 value;
 	u32 addrext;
-	u32 trans = ssb_dma_translation(ring->dev->dev);
+	u32 trans = ring->dev->dma.translation;
 
 	if (ring->tx) {
 		if (ring->type == B43legacy_DMA_64BIT) {
@@ -1093,6 +1093,7 @@ int b43legacy_dma_init(struct b43legacy_wldev *dev)
 		return -EOPNOTSUPP;
 #endif
 	}
+	dma->translation = ssb_dma_translation(dev->dev);
 
 	err = -ENOMEM;
 	/* setup TX DMA channels. */
-- 
1.7.3.4

