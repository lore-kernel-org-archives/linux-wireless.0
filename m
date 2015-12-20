Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:36858 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbbLTNZz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 08:25:55 -0500
Received: by mail-pf0-f177.google.com with SMTP id o64so74234804pfb.3
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2015 05:25:55 -0800 (PST)
From: Fengwei Yin <fengwei.yin@linaro.org>
To: julian.calaby@gmail.com, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com
Cc: fengwei.yin@linaro.org, lking@qti.qualcomm.com
Subject: [PATCH v3 2/2] wcn36xx: split DMA mask register writing.
Date: Sun, 20 Dec 2015 21:20:41 +0800
Message-Id: <1450617641-29531-3-git-send-email-fengwei.yin@linaro.org> (sfid-20151220_142558_747323_38AC8546)
In-Reply-To: <1450617641-29531-1-git-send-email-fengwei.yin@linaro.org>
References: <1450617641-29531-1-git-send-email-fengwei.yin@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Per comments from Bjorn Andersson <bjorn.andersson@sonymobile.com>,
split DMA mask register writing as seperate patch in case we need
bi-sect in the furture.

Signed-off-by: Fengwei Yin <fengwei.yin@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 473381f..8643801 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -498,11 +498,11 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 			wcn36xx_rx_skb(wcn, skb);
 		} /* else keep old skb not submitted and use it for rx DMA */
 
-		wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR, int_mask);
 		dxe->ctrl = value;
 		ctl = ctl->next;
 		dxe = ctl->desc;
 	}
+	wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR, int_mask);
 
 	ch->head_blk_ctl = ctl;
 	return 0;
-- 
2.1.4

