Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728139AbeIFNyA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:00 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 11/42] mt76x0: disable usb rx bulk aggregation
Date: Thu,  6 Sep 2018 11:18:27 +0200
Message-Id: <1536225538-16454-12-git-send-email-sgruszka@redhat.com> (sfid-20180906_111942_192597_BCAB2113)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

In order to use zero-copying, disable usb rx bulk aggregation

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index ddbb52b4e5ac..b28ea45a7282 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -110,17 +110,17 @@ static void mt76x0_reset_csr_bbp(struct mt76x0_dev *dev)
 
 static void mt76x0_init_usb_dma(struct mt76x0_dev *dev)
 {
-	struct mt76_usb *usb = &dev->mt76.usb;
 	u32 val;
 
 	val = mt76_rr(dev, MT_USB_DMA_CFG);
 
-	val |= FIELD_PREP(MT_USB_DMA_CFG_RX_BULK_AGG_TOUT, MT_USB_AGGR_TIMEOUT) |
-	       FIELD_PREP(MT_USB_DMA_CFG_RX_BULK_AGG_LMT, MT_USB_AGGR_SIZE_LIMIT) |
-	       MT_USB_DMA_CFG_RX_BULK_EN |
+	val |= MT_USB_DMA_CFG_RX_BULK_EN |
 	       MT_USB_DMA_CFG_TX_BULK_EN;
-	if (usb->in_max_packet == 512)
-		val |= MT_USB_DMA_CFG_RX_BULK_AGG_EN;
+
+	/* disable AGGR_BULK_RX in order to receive one
+	 * frame in each rx urb and avoid copies
+	 */
+	val &= ~MT_USB_DMA_CFG_RX_BULK_AGG_EN;
 	mt76_wr(dev, MT_USB_DMA_CFG, val);
 
 	val = mt76_rr(dev, MT_COM_REG0);
-- 
2.7.5
