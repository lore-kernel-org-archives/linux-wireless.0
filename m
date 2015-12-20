Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34599 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbbLTNZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 08:25:52 -0500
Received: by mail-pa0-f44.google.com with SMTP id wq6so85376720pac.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2015 05:25:52 -0800 (PST)
From: Fengwei Yin <fengwei.yin@linaro.org>
To: julian.calaby@gmail.com, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com
Cc: fengwei.yin@linaro.org, lking@qti.qualcomm.com
Subject: [PATCH v3 1/2] wcn36xx: handle rx skb allocation failure to avoid system crash
Date: Sun, 20 Dec 2015 21:20:40 +0800
Message-Id: <1450617641-29531-2-git-send-email-fengwei.yin@linaro.org> (sfid-20151220_142555_767778_74F992FC)
In-Reply-To: <1450617641-29531-1-git-send-email-fengwei.yin@linaro.org>
References: <1450617641-29531-1-git-send-email-fengwei.yin@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lawrence reported that git clone could make system crash on a
Qualcomm ARM soc based device (DragonBoard, 1G memory without
swap) running 64bit Debian.

It's turned out the crash is related with rx skb allocation
failure. git could consume more than 600MB anonymous memory.
And system is in extremely memory shortage case.

But driver didn't handle the rx allocation failure case. This patch
doesn't submit skb to upper layer if rx skb allocation fails.
Instead, it reuse the old skb for rx DMA again. It's more like
drop the packets if system is in memory shortage case.

With this change, git clone is OOMed instead of system crash.

Reported-by: King, Lawrence <lking@qti.qualcomm.com>
Signed-off-by: Fengwei Yin <fengwei.yin@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 43 +++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index f8dfa05..473381f 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -474,36 +474,37 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 	struct wcn36xx_dxe_desc *dxe = ctl->desc;
 	dma_addr_t  dma_addr;
 	struct sk_buff *skb;
+	int ret = 0, int_mask;
+	u32 value;
+
+	if (ch->ch_type == WCN36XX_DXE_CH_RX_L) {
+		value = WCN36XX_DXE_CTRL_RX_L;
+		int_mask = WCN36XX_DXE_INT_CH1_MASK;
+	} else {
+		value = WCN36XX_DXE_CTRL_RX_H;
+		int_mask = WCN36XX_DXE_INT_CH3_MASK;
+	}
 
 	while (!(dxe->ctrl & WCN36XX_DXE_CTRL_VALID_MASK)) {
 		skb = ctl->skb;
 		dma_addr = dxe->dst_addr_l;
-		wcn36xx_dxe_fill_skb(wcn->dev, ctl);
-
-		switch (ch->ch_type) {
-		case WCN36XX_DXE_CH_RX_L:
-			dxe->ctrl = WCN36XX_DXE_CTRL_RX_L;
-			wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR,
-						   WCN36XX_DXE_INT_CH1_MASK);
-			break;
-		case WCN36XX_DXE_CH_RX_H:
-			dxe->ctrl = WCN36XX_DXE_CTRL_RX_H;
-			wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR,
-						   WCN36XX_DXE_INT_CH3_MASK);
-			break;
-		default:
-			wcn36xx_warn("Unknown channel\n");
-		}
-
-		dma_unmap_single(wcn->dev, dma_addr, WCN36XX_PKT_SIZE,
-				 DMA_FROM_DEVICE);
-		wcn36xx_rx_skb(wcn, skb);
+		ret = wcn36xx_dxe_fill_skb(wcn->dev, ctl);
+		if (0 == ret) {
+			/* new skb allocation ok. Use the new one and queue
+			 * the old one to network system.
+			 */
+			dma_unmap_single(wcn->dev, dma_addr, WCN36XX_PKT_SIZE,
+					DMA_FROM_DEVICE);
+			wcn36xx_rx_skb(wcn, skb);
+		} /* else keep old skb not submitted and use it for rx DMA */
+
+		wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR, int_mask);
+		dxe->ctrl = value;
 		ctl = ctl->next;
 		dxe = ctl->desc;
 	}
 
 	ch->head_blk_ctl = ctl;
-
 	return 0;
 }
 
-- 
2.1.4

