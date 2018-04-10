Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:34498 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751504AbeDJRgW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 13:36:22 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH] wcn36xx: use READ_ONCE() to access desc->ctrl
Date: Tue, 10 Apr 2018 19:35:58 +0200
Message-Id: <20180410173558.32425-1-daniel@zonque.org> (sfid-20180410_193628_094566_6F340BC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When accessing shared memory to check for the stat of submitted
descriptors, make sure to use READ_ONCE(). This will guarantee the
compiler treats these memory locations as volatile and doesn't apply
any caching.

While this doesn't fix any particular problem I ran into, it's best
practice to do it this way.

Note that this patch also removes the superflous extra condition check
in the do-while loop in reap_tx_dxes(), as the loop will break
instantly anyway in that case.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 26e6c42f886a..c52f1c21ece9 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -363,7 +363,7 @@ static void reap_tx_dxes(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *ch)
 	spin_lock_irqsave(&ch->lock, flags);
 	ctl = ch->tail_blk_ctl;
 	do {
-		if (ctl->desc->ctrl & WCN36xx_DXE_CTRL_VLD)
+		if (READ_ONCE(ctl->desc->ctrl) & WCN36xx_DXE_CTRL_VLD)
 			break;
 		if (ctl->skb) {
 			dma_unmap_single(wcn->dev, ctl->desc->src_addr_l,
@@ -382,8 +382,7 @@ static void reap_tx_dxes(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *ch)
 			ctl->skb = NULL;
 		}
 		ctl = ctl->next;
-	} while (ctl != ch->head_blk_ctl &&
-	       !(ctl->desc->ctrl & WCN36xx_DXE_CTRL_VLD));
+	} while (ctl != ch->head_blk_ctl);
 
 	ch->tail_blk_ctl = ctl;
 	spin_unlock_irqrestore(&ch->lock, flags);
@@ -525,7 +524,7 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 		int_mask = WCN36XX_DXE_INT_CH3_MASK;
 	}
 
-	while (!(dxe->ctrl & WCN36xx_DXE_CTRL_VLD)) {
+	while (!(READ_ONCE(dxe->ctrl) & WCN36xx_DXE_CTRL_VLD)) {
 		skb = ctl->skb;
 		dma_addr = dxe->dst_addr_l;
 		ret = wcn36xx_dxe_fill_skb(wcn->dev, ctl, GFP_ATOMIC);
-- 
2.14.3
