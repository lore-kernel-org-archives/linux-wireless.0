Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch3vs01.rockwellcollins.com ([205.175.226.27]:64191 "EHLO
        ch3vs01.rockwellcollins.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755836AbeDTPte (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 11:49:34 -0400
From: Jared Bents <jared.bents@rockwellcollins.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Jared Bents <jared.bents@rockwellcollins.com>
Subject: [PATCH v1 1/1] ath10k: convert kmemdup to dma_alloc_coherent
Date: Fri, 20 Apr 2018 10:39:53 -0500
Message-Id: <1524238793-24481-1-git-send-email-jared.bents@rockwellcollins.com> (sfid-20180420_174943_437333_A0233C6C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update to convert the use of kmemdup to dma_alloc_coherent as
dma_alloc_coherent will consider DMA region limits such as
those seen with CONFIG_FSL_PCI && CONFIG_ZONE_DMA32 whereas
kmemdup does not take those limitations into account.

Signed-off-by: Jared Bents <jared.bents@rockwellcollins.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 36 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 3c4c800..8637bfe 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1372,28 +1372,16 @@ static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
 	if (resp && resp_len && *resp_len == 0)
 		return -EINVAL;
 
-	treq = kmemdup(req, req_len, GFP_KERNEL);
-	if (!treq)
-		return -ENOMEM;
-
-	req_paddr = dma_map_single(ar->dev, treq, req_len, DMA_TO_DEVICE);
-	ret = dma_mapping_error(ar->dev, req_paddr);
-	if (ret) {
+	treq = dma_alloc_coherent(ar->dev, req_len, &req_paddr, GFP_KERNEL);
+	if (!treq) {
 		ret = -EIO;
 		goto err_dma;
 	}
+	memcpy(treq, req, req_len);
 
 	if (resp && resp_len) {
-		tresp = kzalloc(*resp_len, GFP_KERNEL);
+		tresp = dma_alloc_coherent(ar->dev, *resp_len, &resp_paddr, GFP_KERNEL);
 		if (!tresp) {
-			ret = -ENOMEM;
-			goto err_req;
-		}
-
-		resp_paddr = dma_map_single(ar->dev, tresp, *resp_len,
-					    DMA_FROM_DEVICE);
-		ret = dma_mapping_error(ar->dev, resp_paddr);
-		if (ret) {
 			ret = EIO;
 			goto err_req;
 		}
@@ -1422,23 +1410,19 @@ static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
 	}
 
 err_resp:
+	if (ret == 0 && resp_len) {
+		*resp_len = min(*resp_len, xfer.resp_len);
+		memcpy(resp, tresp, xfer.resp_len);
+	}
 	if (resp) {
 		u32 unused_buffer;
 
 		ath10k_ce_revoke_recv_next(ce_rx, NULL, &unused_buffer);
-		dma_unmap_single(ar->dev, resp_paddr,
-				 *resp_len, DMA_FROM_DEVICE);
+		dma_free_coherent(ar->dev, *resp_len, tresp, resp_paddr);
 	}
 err_req:
-	dma_unmap_single(ar->dev, req_paddr, req_len, DMA_TO_DEVICE);
-
-	if (ret == 0 && resp_len) {
-		*resp_len = min(*resp_len, xfer.resp_len);
-		memcpy(resp, tresp, xfer.resp_len);
-	}
+	dma_free_coherent(ar->dev, req_len, treq, req_paddr);
 err_dma:
-	kfree(treq);
-	kfree(tresp);
 
 	return ret;
 }
-- 
1.9.1
