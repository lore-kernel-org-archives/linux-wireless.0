Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:33924 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbbLKOIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 09:08:46 -0500
Received: by qgz52 with SMTP id 52so9088677qgz.1
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2015 06:08:45 -0800 (PST)
Date: Fri, 11 Dec 2015 09:08:33 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "fengwei.yin" <fengwei.yin@linaro.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com,
	lking@qti.qualcomm.com
Subject: Re: [PATCH] wcn36xx: handle rx skb allocation failure to avoid
 system crash
Message-ID: <20151211140833.GA22332@localhost> (sfid-20151211_150909_861041_CA7A406D)
References: <1449034051-12536-1-git-send-email-fengwei.yin@linaro.org>
 <566ACC1C.1070304@linaro.org>
 <20151211133730.GA8835@localhost>
 <566AD356.50404@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <566AD356.50404@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 11, 2015 at 09:44:54PM +0800, fengwei.yin wrote:
> >            /* skip this frame if we can't alloc a new rx buffer */
> >            if (ret)
> >                   goto drop;
> This can't work because we need to initialize the DMA for the old skb again.
> Which is done in following
> 	switch (ch->ch_type) {
> block.

Hmm, good point.  You could still move that out to a function like this:

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index f8dfa05..fd447bf 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -467,6 +467,27 @@ out_err:
 
 }
 
+/* or whatever name makes sense... */
+static void wcn36xx_restart_dma(struct wcn36xx *wcn,
+				struct wcn36xx_dxe_ch *ch,
+				struct wcn36xx_dxe_desc *dxe)
+{
+	switch (ch->ch_type) {
+	case WCN36XX_DXE_CH_RX_L:
+		dxe->ctrl = WCN36XX_DXE_CTRL_RX_L;
+		wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR,
+					   WCN36XX_DXE_INT_CH1_MASK);
+		break;
+	case WCN36XX_DXE_CH_RX_H:
+		dxe->ctrl = WCN36XX_DXE_CTRL_RX_H;
+		wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR,
+					   WCN36XX_DXE_INT_CH3_MASK);
+		break;
+	default:
+		wcn36xx_warn("Unknown channel\n");
+	}
+}
+
 static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 				     struct wcn36xx_dxe_ch *ch)
 {
@@ -478,26 +499,18 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 	while (!(dxe->ctrl & WCN36XX_DXE_CTRL_VALID_MASK)) {
 		skb = ctl->skb;
 		dma_addr = dxe->dst_addr_l;
-		wcn36xx_dxe_fill_skb(wcn->dev, ctl);
+		ret = wcn36xx_dxe_fill_skb(wcn->dev, ctl);
 
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
+		/* skip this frame in OOM condition */
+		if (ret)
+			goto drop;
 
 		dma_unmap_single(wcn->dev, dma_addr, WCN36XX_PKT_SIZE,
 				 DMA_FROM_DEVICE);
 		wcn36xx_rx_skb(wcn, skb);
+
+drop:
+		wcn36xx_restart_dma(wcn, ch, dxe);
 		ctl = ctl->next;
 		dxe = ctl->desc;
 	}



...that said, not really sure it's worth it now that the 'goto' is only
skipping two lines.  So, I would be ok with the original patch too.

-- 
Bob Copeland %% http://bobcopeland.com/
