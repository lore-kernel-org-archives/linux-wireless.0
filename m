Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:8633 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752579AbeFDMga (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 08:36:30 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <davem@davemloft.net>, <kvalo@codeaurora.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] ath10k: use dma_zalloc_coherent instead of allocator/memset
Date: Mon, 4 Jun 2018 20:35:42 +0800
Message-ID: <20180604123542.24336-1-yuehaibing@huawei.com> (sfid-20180604_143709_683232_DC0B65E0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use dma_zalloc_coherent instead of dma_alloc_coherent
followed by memset 0.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index f97ab79..72db3bd 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5018,13 +5018,11 @@ static int ath10k_wmi_alloc_chunk(struct ath10k *ar, u32 req_id,
 	void *vaddr;
 
 	pool_size = num_units * round_up(unit_len, 4);
-	vaddr = dma_alloc_coherent(ar->dev, pool_size, &paddr, GFP_KERNEL);
+	vaddr = dma_zalloc_coherent(ar->dev, pool_size, &paddr, GFP_KERNEL);
 
 	if (!vaddr)
 		return -ENOMEM;
 
-	memset(vaddr, 0, pool_size);
-
 	ar->wmi.mem_chunks[idx].vaddr = vaddr;
 	ar->wmi.mem_chunks[idx].paddr = paddr;
 	ar->wmi.mem_chunks[idx].len = pool_size;
-- 
2.7.0
