Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33353 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbbLNKLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 05:11:10 -0500
Received: by pabur14 with SMTP id ur14so102056674pab.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 02:11:09 -0800 (PST)
From: Fengwei Yin <fengwei.yin@linaro.org>
To: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
	me@bobcopeland.com, k.eugene.e@gmail.com,
	bjorn.andersson@sonymobile.com
Cc: fengwei.yin@linaro.org, lking@qti.qualcomm.com
Subject: [PATCH v2] wcn36xx: handle rx skb allocation failure to avoid system crash
Date: Mon, 14 Dec 2015 18:06:50 +0800
Message-Id: <1450087610-32477-1-git-send-email-fengwei.yin@linaro.org> (sfid-20151214_111114_824088_805E4A29)
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
Changes from v1:
 * Move switch block out of while loop.
 * Remove the warning of unknown channel because we didn't deal with it.

 drivers/net/wireless/ath/wcn36xx/dxe.c | 50 ++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index f8dfa05..6b61874 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -467,6 +467,18 @@ out_err:
 
 }
 
+#define	GET_CH_CTRL_VALUE(x)			\
+	({ u32 __v = WCN36XX_DXE_CTRL_RX_H;	\
+	   if ((x) == WCN36XX_DXE_CH_RX_L)	\
+		__v = WCN36XX_DXE_CTRL_RX_L;	\
+	   __v; })
+
+#define	GET_CH_INT_MASK(x)			\
+	({ u32 __v = WCN36XX_DXE_INT_CH3_MASK;	\
+	   if ((x) == WCN36XX_DXE_CH_RX_L)	\
+		__v = WCN36XX_DXE_INT_CH1_MASK;	\
+	   __v; })
+
 static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 				     struct wcn36xx_dxe_ch *ch)
 {
@@ -474,36 +486,34 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 	struct wcn36xx_dxe_desc *dxe = ctl->desc;
 	dma_addr_t  dma_addr;
 	struct sk_buff *skb;
+	int ret = 0, int_mask;
+	u32 value;
+
+	value = GET_CH_CTRL_VALUE(ch->ch_type);
+	int_mask = GET_CH_INT_MASK(ch->ch_type);
 
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
+		} /* else keep rx skb not submitted and use for rx DMA again */
+
+		dxe->ctrl = value;
 		ctl = ctl->next;
 		dxe = ctl->desc;
 	}
 
 	ch->head_blk_ctl = ctl;
 
+	wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR, int_mask);
+
 	return 0;
 }
 
-- 
2.1.4

