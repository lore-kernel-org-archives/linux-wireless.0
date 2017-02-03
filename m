Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38010 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752721AbdBCOkQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:40:16 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:37:58 +0200
Message-Id: <20170203143812.7525-12-luca@coelho.fi> (sfid-20170203_154033_786525_91FE9949)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 11/25] iwlwifi: mvm: synchronize firmware DMA paging memory
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When driver needs to access the contents of a streaming DMA buffer
without unmapping it it should call dma_sync_single_for_cpu().
Once the call has been made, the CPU "owns" the DMA buffer and can
work with it as needed.
Before the device accesses the buffer, however, ownership should be
transferred back to it with dma_sync_single_for_device().
Both calls weren't performed by the driver, resulting with odd paging
errors on some platforms. Fix it.

Fixes: a6c4fb4441f4 ("iwlwifi: mvm: Add FW paging mechanism for the UMAC on PCI")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c |  4 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c     | 23 ++++++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index e7b3b712d778..a027b11bbdb3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -811,12 +811,16 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 			struct iwl_fw_error_dump_paging *paging;
 			struct page *pages =
 				mvm->fw_paging_db[i].fw_paging_block;
+			dma_addr_t addr = mvm->fw_paging_db[i].fw_paging_phys;
 
 			dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PAGING);
 			dump_data->len = cpu_to_le32(sizeof(*paging) +
 						     PAGING_BLOCK_SIZE);
 			paging = (void *)dump_data->data;
 			paging->index = cpu_to_le32(i);
+			dma_sync_single_for_cpu(mvm->trans->dev, addr,
+						PAGING_BLOCK_SIZE,
+						DMA_BIDIRECTIONAL);
 			memcpy(paging->data, page_address(pages),
 			       PAGING_BLOCK_SIZE);
 			dump_data = iwl_fw_error_next_data(dump_data);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 8fd3c2b12ea2..c42ef8681b75 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -214,6 +214,10 @@ static int iwl_fill_paging_mem(struct iwl_mvm *mvm, const struct fw_img *image)
 	memcpy(page_address(mvm->fw_paging_db[0].fw_paging_block),
 	       image->sec[sec_idx].data,
 	       mvm->fw_paging_db[0].fw_paging_size);
+	dma_sync_single_for_device(mvm->trans->dev,
+				   mvm->fw_paging_db[0].fw_paging_phys,
+				   mvm->fw_paging_db[0].fw_paging_size,
+				   DMA_BIDIRECTIONAL);
 
 	IWL_DEBUG_FW(mvm,
 		     "Paging: copied %d CSS bytes to first block\n",
@@ -228,9 +232,16 @@ static int iwl_fill_paging_mem(struct iwl_mvm *mvm, const struct fw_img *image)
 	 * loop stop at num_of_paging_blk since that last block is not full.
 	 */
 	for (idx = 1; idx < mvm->num_of_paging_blk; idx++) {
-		memcpy(page_address(mvm->fw_paging_db[idx].fw_paging_block),
+		struct iwl_fw_paging *block = &mvm->fw_paging_db[idx];
+
+		memcpy(page_address(block->fw_paging_block),
 		       image->sec[sec_idx].data + offset,
-		       mvm->fw_paging_db[idx].fw_paging_size);
+		       block->fw_paging_size);
+		dma_sync_single_for_device(mvm->trans->dev,
+					   block->fw_paging_phys,
+					   block->fw_paging_size,
+					   DMA_BIDIRECTIONAL);
+
 
 		IWL_DEBUG_FW(mvm,
 			     "Paging: copied %d paging bytes to block %d\n",
@@ -242,9 +253,15 @@ static int iwl_fill_paging_mem(struct iwl_mvm *mvm, const struct fw_img *image)
 
 	/* copy the last paging block */
 	if (mvm->num_of_pages_in_last_blk > 0) {
-		memcpy(page_address(mvm->fw_paging_db[idx].fw_paging_block),
+		struct iwl_fw_paging *block = &mvm->fw_paging_db[idx];
+
+		memcpy(page_address(block->fw_paging_block),
 		       image->sec[sec_idx].data + offset,
 		       FW_PAGING_SIZE * mvm->num_of_pages_in_last_blk);
+		dma_sync_single_for_device(mvm->trans->dev,
+					   block->fw_paging_phys,
+					   block->fw_paging_size,
+					   DMA_BIDIRECTIONAL);
 
 		IWL_DEBUG_FW(mvm,
 			     "Paging: copied %d pages in the last block %d\n",
-- 
2.11.0
