Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54948 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbeHXUtr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 16:49:47 -0400
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wcn36xx: replace dma_alloc_coherent + memset with dma_zalloc_coherent
Date: Fri, 24 Aug 2018 18:14:10 +0100
Message-Id: <20180824171410.22539-1-colin.king@canonical.com> (sfid-20180824_191427_240536_D16FC418)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

It is preferable to use dma_zalloc_coherent rather than dam_alloc_coherent
and memset, so use it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 06cfe8d311f3..e66ddaa39523 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -174,13 +174,11 @@ static int wcn36xx_dxe_init_descs(struct device *dev, struct wcn36xx_dxe_ch *wcn
 	int i;
 
 	size = wcn_ch->desc_num * sizeof(struct wcn36xx_dxe_desc);
-	wcn_ch->cpu_addr = dma_alloc_coherent(dev, size, &wcn_ch->dma_addr,
-					      GFP_KERNEL);
+	wcn_ch->cpu_addr = dma_zalloc_coherent(dev, size, &wcn_ch->dma_addr,
+					       GFP_KERNEL);
 	if (!wcn_ch->cpu_addr)
 		return -ENOMEM;
 
-	memset(wcn_ch->cpu_addr, 0, size);
-
 	cur_dxe = (struct wcn36xx_dxe_desc *)wcn_ch->cpu_addr;
 	cur_ctl = wcn_ch->head_blk_ctl;
 
-- 
2.17.1
