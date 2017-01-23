Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35093 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750742AbdAWPFX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 10:05:23 -0500
Received: by mail-wm0-f46.google.com with SMTP id r126so137250487wmr.0
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jan 2017 07:04:47 -0800 (PST)
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 2/3] ath10k: use dma_zalloc_coherent()
Date: Mon, 23 Jan 2017 15:04:35 +0000
Message-Id: <1485183876-27080-2-git-send-email-srinivas.kandagatla@linaro.org> (sfid-20170123_160632_702002_6441C8F2)
In-Reply-To: <1485183876-27080-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1485183876-27080-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use dma_zalloc_coherent() instead of dma_alloc_coherent and memset().

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/net/wireless/ath/ath10k/ce.c  | 9 +--------
 drivers/net/wireless/ath/ath10k/pci.c | 3 +--
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 0b4d796..c2b388f 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -958,7 +958,7 @@ ath10k_ce_alloc_dest_ring(struct ath10k *ar, unsigned int ce_id,
 	 * coherent DMA are unsupported
 	 */
 	dest_ring->base_addr_owner_space_unaligned =
-		dma_alloc_coherent(ar->dev,
+		dma_zalloc_coherent(ar->dev,
 				   (nentries * sizeof(struct ce_desc) +
 				    CE_DESC_RING_ALIGN),
 				   &base_addr, GFP_KERNEL);
@@ -969,13 +969,6 @@ ath10k_ce_alloc_dest_ring(struct ath10k *ar, unsigned int ce_id,
 
 	dest_ring->base_addr_ce_space_unaligned = base_addr;
 
-	/*
-	 * Correctly initialize memory to 0 to prevent garbage
-	 * data crashing system when download firmware
-	 */
-	memset(dest_ring->base_addr_owner_space_unaligned, 0,
-	       nentries * sizeof(struct ce_desc) + CE_DESC_RING_ALIGN);
-
 	dest_ring->base_addr_owner_space = PTR_ALIGN(
 			dest_ring->base_addr_owner_space_unaligned,
 			CE_DESC_RING_ALIGN);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index b541a1c..855e3de 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -896,7 +896,7 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 	 */
 	alloc_nbytes = min_t(unsigned int, nbytes, DIAG_TRANSFER_LIMIT);
 
-	data_buf = (unsigned char *)dma_alloc_coherent(ar->dev,
+	data_buf = (unsigned char *)dma_zalloc_coherent(ar->dev,
 						       alloc_nbytes,
 						       &ce_data_base,
 						       GFP_ATOMIC);
@@ -905,7 +905,6 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		ret = -ENOMEM;
 		goto done;
 	}
-	memset(data_buf, 0, alloc_nbytes);
 
 	remaining_bytes = nbytes;
 	ce_data = ce_data_base;
-- 
2.10.1
