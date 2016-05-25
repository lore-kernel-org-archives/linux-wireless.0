Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60477 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbcEYOkl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2016 10:40:41 -0400
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <arnagara@codeaurora.org>,
	"Ashok Raj Nagarajan" <arnagara@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix diag_read to collect data for larger memory
Date: Wed, 25 May 2016 20:09:14 +0530
Message-ID: <1464187154-26687-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20160525_164044_886570_F63DCC8B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

diag_read uses dma_alloc_coherent to allocate memory requested by the
caller. If this memory requested is larger, more than DIAG_TRANSFER_LIMIT
(2K), then it is likely that we may not get the requested memory and we
would fail.

To solve this, request dma_alloc_coherent for only DIAG_TRANSFER_LIMIT, and
reuse this buffer multiple times as needed to copy the data requested in
smaller chunks of size not more than DIAG_TRANSFER_LIMIT. Previously we
were reading into the caller's only after getting the complete requested
data.

Fixes: 68c03249f388 ('ath10k: convert pci_alloc_consistent() to dma_alloc_coherent()')
Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 8133d7b..8663a3b 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -864,7 +864,7 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret = 0;
 	u32 *buf;
-	unsigned int completed_nbytes, orig_nbytes, remaining_bytes;
+	unsigned int completed_nbytes, alloc_nbytes, remaining_bytes;
 	struct ath10k_ce_pipe *ce_diag;
 	/* Host buffer address in CE space */
 	u32 ce_data;
@@ -882,9 +882,10 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 	 *   1) 4-byte alignment
 	 *   2) Buffer in DMA-able space
 	 */
-	orig_nbytes = nbytes;
+	alloc_nbytes = min_t(unsigned int, nbytes, DIAG_TRANSFER_LIMIT);
+
 	data_buf = (unsigned char *)dma_alloc_coherent(ar->dev,
-						       orig_nbytes,
+						       alloc_nbytes,
 						       &ce_data_base,
 						       GFP_ATOMIC);
 
@@ -892,9 +893,9 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		ret = -ENOMEM;
 		goto done;
 	}
-	memset(data_buf, 0, orig_nbytes);
+	memset(data_buf, 0, alloc_nbytes);
 
-	remaining_bytes = orig_nbytes;
+	remaining_bytes = nbytes;
 	ce_data = ce_data_base;
 	while (remaining_bytes) {
 		nbytes = min_t(unsigned int, remaining_bytes,
@@ -954,19 +955,22 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		}
 
 		remaining_bytes -= nbytes;
+
+		if (ret) {
+			ath10k_warn(ar, "failed to read diag value at 0x%x: %d\n",
+				    address, ret);
+			break;
+		}
+		memcpy(data, data_buf, nbytes);
+
 		address += nbytes;
-		ce_data += nbytes;
+		data += nbytes;
 	}
 
 done:
-	if (ret == 0)
-		memcpy(data, data_buf, orig_nbytes);
-	else
-		ath10k_warn(ar, "failed to read diag value at 0x%x: %d\n",
-			    address, ret);
 
 	if (data_buf)
-		dma_free_coherent(ar->dev, orig_nbytes, data_buf,
+		dma_free_coherent(ar->dev, alloc_nbytes, data_buf,
 				  ce_data_base);
 
 	spin_unlock_bh(&ar_pci->ce_lock);
-- 
1.9.1

