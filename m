Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33272 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbbLBFad (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2015 00:30:33 -0500
Received: by pabfh17 with SMTP id fh17so30267843pab.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2015 21:30:33 -0800 (PST)
From: Fengwei Yin <fengwei.yin@linaro.org>
To: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
	me@bobcopeland.com, k.eugene.e@gmail.com,
	bjorn.andersson@sonymobile.com
Cc: lking@qti.qualcomm.com, fengwei.yin@linaro.org
Subject: [PATCH] wcn36xx: handle rx skb allocation failure to avoid system crash
Date: Wed,  2 Dec 2015 13:27:31 +0800
Message-Id: <1449034051-12536-1-git-send-email-fengwei.yin@linaro.org> (sfid-20151202_063037_119357_AA7EB8FF)
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
 drivers/net/wireless/ath/wcn36xx/dxe.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index f8dfa05..8887c0f 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -474,11 +474,20 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 	struct wcn36xx_dxe_desc *dxe = ctl->desc;
 	dma_addr_t  dma_addr;
 	struct sk_buff *skb;
+	int ret = 0;
 
 	while (!(dxe->ctrl & WCN36XX_DXE_CTRL_VALID_MASK)) {
 		skb = ctl->skb;
 		dma_addr = dxe->dst_addr_l;
-		wcn36xx_dxe_fill_skb(wcn->dev, ctl);
+		ret = wcn36xx_dxe_fill_skb(wcn->dev, ctl);
+		if (0 == ret) {
+			/* new skb allocation ok. Use the new one and queue
+			 * the old one to network system.
+			 */
+			dma_unmap_single(wcn->dev, dma_addr, WCN36XX_PKT_SIZE,
+					DMA_FROM_DEVICE);
+			wcn36xx_rx_skb(wcn, skb);
+		}
 
 		switch (ch->ch_type) {
 		case WCN36XX_DXE_CH_RX_L:
@@ -495,9 +504,6 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 			wcn36xx_warn("Unknown channel\n");
 		}
 
-		dma_unmap_single(wcn->dev, dma_addr, WCN36XX_PKT_SIZE,
-				 DMA_FROM_DEVICE);
-		wcn36xx_rx_skb(wcn, skb);
 		ctl = ctl->next;
 		dxe = ctl->desc;
 	}
-- 
2.1.4

