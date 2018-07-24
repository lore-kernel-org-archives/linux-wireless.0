Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:43828 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388254AbeGXM6u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 08:58:50 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <davem@davemloft.net>, <kvalo@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <wcn36xx@lists.infradead.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] wcn36xx: use dma_zalloc_coherent instead of allocator/memset
Date: Tue, 24 Jul 2018 19:52:11 +0800
Message-ID: <20180724115211.19264-1-yuehaibing@huawei.com> (sfid-20180724_135254_705669_715F67BA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use dma_zalloc_coherent instead of dma_alloc_coherent
followed by memset 0.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 06cfe8d..5ab3e31 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -174,13 +174,12 @@ static int wcn36xx_dxe_init_descs(struct device *dev, struct wcn36xx_dxe_ch *wcn
 	int i;
 
 	size = wcn_ch->desc_num * sizeof(struct wcn36xx_dxe_desc);
-	wcn_ch->cpu_addr = dma_alloc_coherent(dev, size, &wcn_ch->dma_addr,
-					      GFP_KERNEL);
+	wcn_ch->cpu_addr = dma_zalloc_coherent(dev, size,
+					       &wcn_ch->dma_addr,
+					       GFP_KERNEL);
 	if (!wcn_ch->cpu_addr)
 		return -ENOMEM;
 
-	memset(wcn_ch->cpu_addr, 0, size);
-
 	cur_dxe = (struct wcn36xx_dxe_desc *)wcn_ch->cpu_addr;
 	cur_ctl = wcn_ch->head_blk_ctl;
 
@@ -628,13 +627,13 @@ int wcn36xx_dxe_allocate_mem_pools(struct wcn36xx *wcn)
 		16 - (WCN36XX_BD_CHUNK_SIZE % 8);
 
 	s = wcn->mgmt_mem_pool.chunk_size * WCN36XX_DXE_CH_DESC_NUMB_TX_H;
-	cpu_addr = dma_alloc_coherent(wcn->dev, s, &wcn->mgmt_mem_pool.phy_addr,
-				      GFP_KERNEL);
+	cpu_addr = dma_zalloc_coherent(wcn->dev, s,
+				       &wcn->mgmt_mem_pool.phy_addr,
+				       GFP_KERNEL);
 	if (!cpu_addr)
 		goto out_err;
 
 	wcn->mgmt_mem_pool.virt_addr = cpu_addr;
-	memset(cpu_addr, 0, s);
 
 	/* Allocate BD headers for DATA frames */
 
@@ -643,13 +642,13 @@ int wcn36xx_dxe_allocate_mem_pools(struct wcn36xx *wcn)
 		16 - (WCN36XX_BD_CHUNK_SIZE % 8);
 
 	s = wcn->data_mem_pool.chunk_size * WCN36XX_DXE_CH_DESC_NUMB_TX_L;
-	cpu_addr = dma_alloc_coherent(wcn->dev, s, &wcn->data_mem_pool.phy_addr,
-				      GFP_KERNEL);
+	cpu_addr = dma_zalloc_coherent(wcn->dev, s,
+				       &wcn->data_mem_pool.phy_addr,
+				       GFP_KERNEL);
 	if (!cpu_addr)
 		goto out_err;
 
 	wcn->data_mem_pool.virt_addr = cpu_addr;
-	memset(cpu_addr, 0, s);
 
 	return 0;
 
-- 
2.7.0
