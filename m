Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:35554 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752411AbeEPOIh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 10:08:37 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, loic.poulain@linaro.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH 04/10] wcn36xx: clear all masks in RX interrupt
Date: Wed, 16 May 2018 16:08:14 +0200
Message-Id: <20180516140820.1636-5-daniel@zonque.org> (sfid-20180516_160842_868633_4BDE63F6)
In-Reply-To: <20180516140820.1636-1-daniel@zonque.org>
References: <20180516140820.1636-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Like on the TX side, check for the interrupt reason when the RX interrupt
is latched and clear the ERR, DONE and ED masks.

This seems to help with connection timeouts and network stream
starvatations. And FWIW, the downstream driver does the same thing.

Note that in analogy to the TX side, WCN36XX_DXE_0_INT_CLR should be set to
WCN36XX_INT_MASK_CHAN_RX_{L,H} rather than WCN36XX_DXE_INT_CH{1,3}_MASK. It
did the right thing however, as the defines happen to have identical values.

Also, instead of determining register addresses and values inside
wcn36xx_rx_handle_packets(), pass them as arguments.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 62 ++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index d6dd47b211ba..d11c9c536627 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -511,23 +511,40 @@ static int wcn36xx_dxe_request_irqs(struct wcn36xx *wcn)
 }
 
 static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
-				     struct wcn36xx_dxe_ch *ch)
+				     struct wcn36xx_dxe_ch *ch,
+				     u32 ctrl,
+				     u32 en_mask,
+				     u32 int_mask,
+				     u32 status_reg)
 {
 	struct wcn36xx_dxe_desc *dxe;
 	struct wcn36xx_dxe_ctl *ctl;
 	dma_addr_t  dma_addr;
 	struct sk_buff *skb;
-	int ret = 0, int_mask;
-	u32 value;
+	u32 int_reason;
+	int ret;
 
-	if (ch->ch_type == WCN36XX_DXE_CH_RX_L) {
-		value = WCN36XX_DXE_CTRL_RX_L;
-		int_mask = WCN36XX_DXE_INT_CH1_MASK;
-	} else {
-		value = WCN36XX_DXE_CTRL_RX_H;
-		int_mask = WCN36XX_DXE_INT_CH3_MASK;
+	wcn36xx_dxe_read_register(wcn, status_reg, &int_reason);
+	wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_0_INT_CLR, int_mask);
+
+	if (int_reason & WCN36XX_CH_STAT_INT_ERR_MASK) {
+		wcn36xx_dxe_write_register(wcn,
+					   WCN36XX_DXE_0_INT_ERR_CLR,
+					   int_mask);
+
+		wcn36xx_err("DXE IRQ reported error on RX channel\n");
 	}
 
+	if (int_reason & WCN36XX_CH_STAT_INT_DONE_MASK)
+		wcn36xx_dxe_write_register(wcn,
+					   WCN36XX_DXE_0_INT_DONE_CLR,
+					   int_mask);
+
+	if (int_reason & WCN36XX_CH_STAT_INT_ED_MASK)
+		wcn36xx_dxe_write_register(wcn,
+					   WCN36XX_DXE_0_INT_ED_CLR,
+					   int_mask);
+
 	spin_lock(&ch->lock);
 
 	ctl = ch->head_blk_ctl;
@@ -546,11 +563,11 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 			wcn36xx_rx_skb(wcn, skb);
 		} /* else keep old skb not submitted and use it for rx DMA */
 
-		dxe->ctrl = value;
+		dxe->ctrl = ctrl;
 		ctl = ctl->next;
 		dxe = ctl->desc;
 	}
-	wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR, int_mask);
+	wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR, en_mask);
 
 	ch->head_blk_ctl = ctl;
 
@@ -566,19 +583,20 @@ void wcn36xx_dxe_rx_frame(struct wcn36xx *wcn)
 	wcn36xx_dxe_read_register(wcn, WCN36XX_DXE_INT_SRC_RAW_REG, &int_src);
 
 	/* RX_LOW_PRI */
-	if (int_src & WCN36XX_DXE_INT_CH1_MASK) {
-		wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_0_INT_CLR,
-					   WCN36XX_DXE_INT_CH1_MASK);
-		wcn36xx_rx_handle_packets(wcn, &(wcn->dxe_rx_l_ch));
-	}
+	if (int_src & WCN36XX_DXE_INT_CH1_MASK)
+		wcn36xx_rx_handle_packets(wcn, &wcn->dxe_rx_l_ch,
+					  WCN36XX_DXE_CTRL_RX_L,
+					  WCN36XX_DXE_INT_CH1_MASK,
+					  WCN36XX_INT_MASK_CHAN_RX_L,
+					  WCN36XX_DXE_CH_STATUS_REG_ADDR_RX_L);
 
 	/* RX_HIGH_PRI */
-	if (int_src & WCN36XX_DXE_INT_CH3_MASK) {
-		/* Clean up all the INT within this channel */
-		wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_0_INT_CLR,
-					   WCN36XX_DXE_INT_CH3_MASK);
-		wcn36xx_rx_handle_packets(wcn, &(wcn->dxe_rx_h_ch));
-	}
+	if (int_src & WCN36XX_DXE_INT_CH3_MASK)
+		wcn36xx_rx_handle_packets(wcn, &wcn->dxe_rx_h_ch,
+					  WCN36XX_DXE_CTRL_RX_H,
+					  WCN36XX_DXE_INT_CH3_MASK,
+					  WCN36XX_INT_MASK_CHAN_RX_H,
+					  WCN36XX_DXE_CH_STATUS_REG_ADDR_RX_H);
 
 	if (!int_src)
 		wcn36xx_warn("No DXE interrupt pending\n");
-- 
2.14.3
