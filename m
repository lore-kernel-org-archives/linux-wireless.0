Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:35542 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752407AbeEPOIf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 10:08:35 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, loic.poulain@linaro.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH 03/10] wcn36xx: don't disable RX IRQ from handler
Date: Wed, 16 May 2018 16:08:13 +0200
Message-Id: <20180516140820.1636-4-daniel@zonque.org> (sfid-20180516_160842_282736_4602B544)
In-Reply-To: <20180516140820.1636-1-daniel@zonque.org>
References: <20180516140820.1636-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no need to disable the IRQ from inside its handler.
Instead just grab the spinlock of the channel that is being processed.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 3d1cf7dd1f8e..d6dd47b211ba 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -476,9 +476,8 @@ static irqreturn_t wcn36xx_irq_rx_ready(int irq, void *dev)
 {
 	struct wcn36xx *wcn = (struct wcn36xx *)dev;
 
-	disable_irq_nosync(wcn->rx_irq);
 	wcn36xx_dxe_rx_frame(wcn);
-	enable_irq(wcn->rx_irq);
+
 	return IRQ_HANDLED;
 }
 
@@ -514,8 +513,8 @@ static int wcn36xx_dxe_request_irqs(struct wcn36xx *wcn)
 static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 				     struct wcn36xx_dxe_ch *ch)
 {
-	struct wcn36xx_dxe_ctl *ctl = ch->head_blk_ctl;
-	struct wcn36xx_dxe_desc *dxe = ctl->desc;
+	struct wcn36xx_dxe_desc *dxe;
+	struct wcn36xx_dxe_ctl *ctl;
 	dma_addr_t  dma_addr;
 	struct sk_buff *skb;
 	int ret = 0, int_mask;
@@ -529,6 +528,11 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 		int_mask = WCN36XX_DXE_INT_CH3_MASK;
 	}
 
+	spin_lock(&ch->lock);
+
+	ctl = ch->head_blk_ctl;
+	dxe = ctl->desc;
+
 	while (!(READ_ONCE(dxe->ctrl) & WCN36xx_DXE_CTRL_VLD)) {
 		skb = ctl->skb;
 		dma_addr = dxe->dst_addr_l;
@@ -549,6 +553,9 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 	wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR, int_mask);
 
 	ch->head_blk_ctl = ctl;
+
+	spin_unlock(&ch->lock);
+
 	return 0;
 }
 
-- 
2.14.3
