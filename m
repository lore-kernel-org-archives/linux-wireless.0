Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40864 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750791AbeDVI2C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Apr 2018 04:28:02 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 22 Apr 2018 11:27:41 +0300
Message-Id: <20180422082745.9743-9-luca@coelho.fi> (sfid-20180422_102806_663851_F8388E6D)
In-Reply-To: <20180422082745.9743-1-luca@coelho.fi>
References: <20180422082745.9743-1-luca@coelho.fi>
Subject: [PATCH 08/12] iwlwifi: fw: combine loading of last page block into main copy loop
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Now that we check and copy only the actual size of the page block,
there is no need to treat the last block separately.  Remove the
mostly duplicate code and make the main copy loop handle also the last
block.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/paging.c    | 69 +++++++------------
 1 file changed, 26 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/paging.c b/drivers/net/wireless/intel/iwlwifi/fw/paging.c
index 6afcfd1f0eec..9b8dd7fe7112 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/paging.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/paging.c
@@ -221,25 +221,39 @@ static int iwl_fill_paging_mem(struct iwl_fw_runtime *fwrt,
 	sec_idx++;
 
 	/*
-	 * copy the paging blocks to the dram
-	 * loop index start from 1 since that CSS block already copied to dram
-	 * and CSS index is 0.
-	 * loop stop at num_of_paging_blk since that last block is not full.
+	 * Copy the paging blocks to the dram.  The loop index starts
+	 * from 1 since the CSS block (index 0) was already copied to
+	 * dram.  We use num_of_paging_blk + 1 to account for that.
 	 */
-	for (idx = 1; idx < fwrt->num_of_paging_blk; idx++) {
+	for (idx = 1; idx < fwrt->num_of_paging_blk + 1; idx++) {
 		struct iwl_fw_paging *block = &fwrt->fw_paging_db[idx];
-
-		if (block->fw_paging_size > image->sec[sec_idx].len - offset) {
+		int remaining = image->sec[sec_idx].len - offset;
+		int len = block->fw_paging_size;
+
+		/*
+		 * For the last block, we copy all that is remaining,
+		 * for all other blocks, we copy fw_paging_size at a
+		 * time. */
+		if (idx == fwrt->num_of_paging_blk) {
+			len = remaining;
+			if (remaining !=
+			    fwrt->num_of_pages_in_last_blk * FW_PAGING_SIZE) {
+				IWL_ERR(fwrt,
+					"Paging: last block contains more data than expected %d\n",
+					remaining);
+				ret = -EINVAL;
+				goto err;
+			}
+		} else if (block->fw_paging_size > remaining) {
 			IWL_ERR(fwrt,
-				"Paging: paging size is larger than remaining data in block %d\n",
-				idx);
+				"Paging: not enough data in other in block %d (%d)\n",
+				idx, remaining);
 			ret = -EINVAL;
 			goto err;
 		}
 
 		memcpy(page_address(block->fw_paging_block),
-		       image->sec[sec_idx].data + offset,
-		       block->fw_paging_size);
+		       image->sec[sec_idx].data + offset, len);
 		dma_sync_single_for_device(fwrt->trans->dev,
 					   block->fw_paging_phys,
 					   block->fw_paging_size,
@@ -247,40 +261,9 @@ static int iwl_fill_paging_mem(struct iwl_fw_runtime *fwrt,
 
 		IWL_DEBUG_FW(fwrt,
 			     "Paging: copied %d paging bytes to block %d\n",
-			     block->fw_paging_size, idx);
+			     len, idx);
 
 		offset += block->fw_paging_size;
-
-		if (offset > image->sec[sec_idx].len) {
-			IWL_ERR(fwrt,
-				"Paging: offset goes over section size\n");
-			ret = -EINVAL;
-			goto err;
-		}
-	}
-
-	/* copy the last paging block */
-	if (fwrt->num_of_pages_in_last_blk > 0) {
-		struct iwl_fw_paging *block = &fwrt->fw_paging_db[idx];
-
-		if (image->sec[sec_idx].len - offset > block->fw_paging_size) {
-			IWL_ERR(fwrt,
-				"Paging: last block is larger than paging size\n");
-			ret = -EINVAL;
-			goto err;
-		}
-
-		memcpy(page_address(block->fw_paging_block),
-		       image->sec[sec_idx].data + offset,
-		       image->sec[sec_idx].len - offset);
-		dma_sync_single_for_device(fwrt->trans->dev,
-					   block->fw_paging_phys,
-					   block->fw_paging_size,
-					   DMA_BIDIRECTIONAL);
-
-		IWL_DEBUG_FW(fwrt,
-			     "Paging: copied %d pages in the last block %d\n",
-			     fwrt->num_of_pages_in_last_blk, idx);
 	}
 
 	return 0;
-- 
2.17.0
