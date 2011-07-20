Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:61734 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab1GTRNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 13:13:34 -0400
Received: by fxd18 with SMTP id 18so2056296fxd.11
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 10:13:33 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, Pavel Roskin <proski@gnu.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3 V3] ssb: return correct translation bit for 64-bit DMA
Date: Wed, 20 Jul 2011 19:52:14 +0200
Message-Id: <1311184336-3633-1-git-send-email-zajec5@gmail.com> (sfid-20110720_191348_410628_A7FBA01F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove b43's workarounds at the same time. Other users of
ssb_dma_translation do not support any 64-bit DMA devices, so they are
not affected.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/dma.c |    6 +++---
 drivers/ssb/main.c             |    5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index ce572ae..997d3ad 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -174,7 +174,7 @@ static void op64_fill_descriptor(struct b43_dmaring *ring,
 	addrhi = (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
 	addrext = (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
 	    >> SSB_DMA_TRANSLATION_SHIFT;
-	addrhi |= (ring->dev->dma.translation << 1);
+	addrhi |= ring->dev->dma.translation;
 	if (slot == ring->nr_slots - 1)
 		ctl0 |= B43_DMA64_DCTL0_DTABLEEND;
 	if (start)
@@ -675,7 +675,7 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 			b43_dma_write(ring, B43_DMA64_TXRINGHI,
 				      ((ringbase >> 32) &
 				       ~SSB_DMA_TRANSLATION_MASK)
-				      | (trans << 1));
+				      | trans);
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
 
@@ -708,7 +708,7 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 			b43_dma_write(ring, B43_DMA64_RXRINGHI,
 				      ((ringbase >> 32) &
 				       ~SSB_DMA_TRANSLATION_MASK)
-				      | (trans << 1));
+				      | trans);
 			b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
 				      sizeof(struct b43_dmadesc64));
 		} else {
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 57b7b64..6ec6e09 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1266,7 +1266,10 @@ u32 ssb_dma_translation(struct ssb_device *dev)
 	case SSB_BUSTYPE_SSB:
 		return 0;
 	case SSB_BUSTYPE_PCI:
-		return SSB_PCI_DMA;
+		if (ssb_read32(dev, SSB_TMSHIGH) & SSB_TMSHIGH_DMA64)
+			return SSB_PCIE_DMA_H32;
+		else
+			return SSB_PCI_DMA;
 	default:
 		__ssb_dma_not_implemented(dev);
 	}
-- 
1.7.3.4

