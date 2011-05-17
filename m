Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52310 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1EQLWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 07:22:17 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so103261eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 04:22:16 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] b43: dma: cache translation (routing bits)
Date: Tue, 17 May 2011 14:00:02 +0200
Message-Id: <1305633602-4590-3-git-send-email-zajec5@gmail.com> (sfid-20110517_132219_503129_CD54F750)
In-Reply-To: <1305633602-4590-1-git-send-email-zajec5@gmail.com>
References: <1305633602-4590-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h |    2 ++
 drivers/net/wireless/b43/dma.c |    7 ++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index caba5c5..ee4d06f 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -567,6 +567,8 @@ struct b43_dma {
 	struct b43_dmaring *tx_ring_mcast; /* Multicast */
 
 	struct b43_dmaring *rx_ring;
+
+	u32 translation; /* Routing bits */
 };
 
 struct b43_pio_txqueue;
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 10cfba3..47d44bc 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -80,7 +80,7 @@ static void op32_fill_descriptor(struct b43_dmaring *ring,
 	addr = (u32) (dmaaddr & ~SSB_DMA_TRANSLATION_MASK);
 	addrext = (u32) (dmaaddr & SSB_DMA_TRANSLATION_MASK)
 	    >> SSB_DMA_TRANSLATION_SHIFT;
-	addr |= ssb_dma_translation(ring->dev->sdev);
+	addr |= ring->dev->dma.translation;
 	ctl = bufsize & B43_DMA32_DCTL_BYTECNT;
 	if (slot == ring->nr_slots - 1)
 		ctl |= B43_DMA32_DCTL_DTABLEEND;
@@ -174,7 +174,7 @@ static void op64_fill_descriptor(struct b43_dmaring *ring,
 	addrhi = (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
 	addrext = (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
 	    >> SSB_DMA_TRANSLATION_SHIFT;
-	addrhi |= (ssb_dma_translation(ring->dev->sdev) << 1);
+	addrhi |= (ring->dev->dma.translation << 1);
 	if (slot == ring->nr_slots - 1)
 		ctl0 |= B43_DMA64_DCTL0_DTABLEEND;
 	if (start)
@@ -658,7 +658,7 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 	int err = 0;
 	u32 value;
 	u32 addrext;
-	u32 trans = ssb_dma_translation(ring->dev->sdev);
+	u32 trans = ring->dev->dma.translation;
 
 	if (ring->tx) {
 		if (ring->type == B43_DMA_64BIT) {
@@ -1055,6 +1055,7 @@ int b43_dma_init(struct b43_wldev *dev)
 	err = b43_dma_set_mask(dev, dmamask);
 	if (err)
 		return err;
+	dma->translation = ssb_dma_translation(dev->sdev);
 
 	err = -ENOMEM;
 	/* setup TX DMA channels. */
-- 
1.7.3.4

