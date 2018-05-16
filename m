Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:35566 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752407AbeEPOIj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 10:08:39 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, loic.poulain@linaro.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH 05/10] wcn36xx: only handle packets when ED or DONE bit is set
Date: Wed, 16 May 2018 16:08:15 +0200
Message-Id: <20180516140820.1636-6-daniel@zonque.org> (sfid-20180516_160843_490268_20C4FC16)
In-Reply-To: <20180516140820.1636-1-daniel@zonque.org>
References: <20180516140820.1636-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On RX and TX interrupts, check for the WCN36XX_CH_STAT_INT_ED_MASK or
WCN36XX_CH_STAT_INT_DONE_MASK in the interrupt reason register, and
only handle packets when it is set. This way, reap_tx_dxes() is only
invoked when needed.

This brings the dequeing logic in line with what the prima downstream
driver is doing.

While at it, also log the interrupt reason.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index d11c9c536627..8c64e05ca3b7 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -430,8 +430,12 @@ static irqreturn_t wcn36xx_irq_tx_complete(int irq, void *dev)
 						   WCN36XX_INT_MASK_CHAN_TX_H);
 		}
 
-		wcn36xx_dbg(WCN36XX_DBG_DXE, "dxe tx ready high\n");
-		reap_tx_dxes(wcn, &wcn->dxe_tx_h_ch);
+		wcn36xx_dbg(WCN36XX_DBG_DXE, "dxe tx ready high, reason %08x\n",
+			    int_reason);
+
+		if (int_reason & (WCN36XX_CH_STAT_INT_DONE_MASK |
+				  WCN36XX_CH_STAT_INT_ED_MASK))
+			reap_tx_dxes(wcn, &wcn->dxe_tx_h_ch);
 	}
 
 	if (int_src & WCN36XX_INT_MASK_CHAN_TX_L) {
@@ -465,8 +469,12 @@ static irqreturn_t wcn36xx_irq_tx_complete(int irq, void *dev)
 						   WCN36XX_INT_MASK_CHAN_TX_L);
 		}
 
-		wcn36xx_dbg(WCN36XX_DBG_DXE, "dxe tx ready low\n");
-		reap_tx_dxes(wcn, &wcn->dxe_tx_l_ch);
+		wcn36xx_dbg(WCN36XX_DBG_DXE, "dxe tx ready low, reason %08x\n",
+			    int_reason);
+
+		if (int_reason & (WCN36XX_CH_STAT_INT_DONE_MASK |
+				  WCN36XX_CH_STAT_INT_ED_MASK))
+			reap_tx_dxes(wcn, &wcn->dxe_tx_l_ch);
 	}
 
 	return IRQ_HANDLED;
@@ -545,6 +553,10 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 					   WCN36XX_DXE_0_INT_ED_CLR,
 					   int_mask);
 
+	if (!(int_reason & (WCN36XX_CH_STAT_INT_DONE_MASK |
+			    WCN36XX_CH_STAT_INT_ED_MASK)))
+		return 0;
+
 	spin_lock(&ch->lock);
 
 	ctl = ch->head_blk_ctl;
-- 
2.14.3
