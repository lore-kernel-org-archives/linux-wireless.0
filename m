Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:44780 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751414AbeDCQwC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 12:52:02 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        loic.poulain@linaro.org, rfried@codeaurora.org,
        bjorn.andersson@linaro.org, Daniel Mack <daniel@zonque.org>
Subject: [PATCH 1/3] wcn36xx: check for DMA mapping errors in wcn36xx_dxe_tx_frame()
Date: Tue,  3 Apr 2018 18:51:52 +0200
Message-Id: <20180403165154.18775-1-daniel@zonque.org> (sfid-20180403_185209_819181_D93AF25A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bail out if the mapping fails. Even though this hasn't occured during
tests, this unlikely case should still be handled.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 6e9a3583c447..e8ad8f989ccd 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -707,6 +707,11 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
 					  ctl->skb->data,
 					  ctl->skb->len,
 					  DMA_TO_DEVICE);
+	if (dma_mapping_error(wcn->dev, desc->src_addr_l)) {
+		dev_err(wcn->dev, "unable to DMA map src_addr_l\n");
+		ret = -ENOMEM;
+		goto unlock;
+	}
 
 	desc->dst_addr_l = ch->dxe_wq;
 	desc->fr_len = ctl->skb->len;
-- 
2.14.3
