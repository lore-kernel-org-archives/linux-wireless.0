Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51230 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab1GWL5p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 07:57:45 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] b43: read correct register on bcma bus.
Date: Sat, 23 Jul 2011 13:57:33 +0200
Message-Id: <1311422254-7104-1-git-send-email-hauke@hauke-m.de> (sfid-20110723_135804_815737_C178F700)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This causes an databus error on a Broadcom SoC using bcma.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/dma.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 0953ce1..646d6ae 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -795,9 +795,23 @@ static u64 supported_dma_mask(struct b43_wldev *dev)
 	u32 tmp;
 	u16 mmio_base;
 
-	tmp = b43_read32(dev, SSB_TMSHIGH);
-	if (tmp & SSB_TMSHIGH_DMA64)
-		return DMA_BIT_MASK(64);
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		tmp = bcma_aread32(dev->dev->bdev, BCMA_IOST);
+		if (tmp & BCMA_IOST_DMA64)
+			return DMA_BIT_MASK(64);
+		break;
+#endif
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		tmp = ssb_read32(dev->dev->sdev, SSB_TMSHIGH);
+		if (tmp & SSB_TMSHIGH_DMA64)
+			return DMA_BIT_MASK(64);
+		break;
+#endif
+	}
+
 	mmio_base = b43_dmacontroller_base(0, 0);
 	b43_write32(dev, mmio_base + B43_DMA32_TXCTL, B43_DMA32_TXADDREXT_MASK);
 	tmp = b43_read32(dev, mmio_base + B43_DMA32_TXCTL);
-- 
1.7.4.1

