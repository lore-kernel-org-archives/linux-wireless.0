Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36160 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751545AbdAWWEI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:04:08 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Sara Sharon <sara.sharon@intel.com>
Date: Tue, 24 Jan 2017 00:03:33 +0200
Message-Id: <20170123220350.25305-9-luca@coelho.fi> (sfid-20170123_230421_930950_BB0398F7)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
Subject: [PATCH 08/25] iwlwifi: mvm: simplify paging allocation code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Some of the code there is duplicate while the only change is
the block size. Unifying it shortens the code and make the
difference clearer.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 61 +++++++----------------------
 1 file changed, 15 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 872066317fa5..04fe1051b1e5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -259,9 +259,7 @@ static int iwl_alloc_fw_paging_mem(struct iwl_mvm *mvm,
 {
 	struct page *block;
 	dma_addr_t phys = 0;
-	int blk_idx = 0;
-	int order, num_of_pages;
-	int dma_enabled;
+	int blk_idx, order, num_of_pages, size, dma_enabled;
 
 	if (mvm->fw_paging_db[0].fw_paging_block)
 		return 0;
@@ -274,7 +272,6 @@ static int iwl_alloc_fw_paging_mem(struct iwl_mvm *mvm,
 	num_of_pages = image->paging_mem_size / FW_PAGING_SIZE;
 	mvm->num_of_paging_blk = ((num_of_pages - 1) /
 				    NUM_OF_PAGE_PER_GROUP) + 1;
-
 	mvm->num_of_pages_in_last_blk =
 		num_of_pages -
 		NUM_OF_PAGE_PER_GROUP * (mvm->num_of_paging_blk - 1);
@@ -284,46 +281,13 @@ static int iwl_alloc_fw_paging_mem(struct iwl_mvm *mvm,
 		     mvm->num_of_paging_blk,
 		     mvm->num_of_pages_in_last_blk);
 
-	/* allocate block of 4Kbytes for paging CSS */
-	order = get_order(FW_PAGING_SIZE);
-	block = alloc_pages(GFP_KERNEL, order);
-	if (!block) {
-		/* free all the previous pages since we failed */
-		iwl_free_fw_paging(mvm);
-		return -ENOMEM;
-	}
-
-	mvm->fw_paging_db[blk_idx].fw_paging_block = block;
-	mvm->fw_paging_db[blk_idx].fw_paging_size = FW_PAGING_SIZE;
-
-	if (dma_enabled) {
-		phys = dma_map_page(mvm->trans->dev, block, 0,
-				    PAGE_SIZE << order, DMA_BIDIRECTIONAL);
-		if (dma_mapping_error(mvm->trans->dev, phys)) {
-			/*
-			 * free the previous pages and the current one since
-			 * we failed to map_page.
-			 */
-			iwl_free_fw_paging(mvm);
-			return -ENOMEM;
-		}
-		mvm->fw_paging_db[blk_idx].fw_paging_phys = phys;
-	} else {
-		mvm->fw_paging_db[blk_idx].fw_paging_phys = PAGING_ADDR_SIG |
-			blk_idx << BLOCK_2_EXP_SIZE;
-	}
-
-	IWL_DEBUG_FW(mvm,
-		     "Paging: allocated 4K(CSS) bytes (order %d) for firmware paging.\n",
-		     order);
-
 	/*
-	 * allocate blocks in dram.
-	 * since that CSS allocated in fw_paging_db[0] loop start from index 1
+	 * Allocate CSS and paging blocks in dram.
 	 */
-	for (blk_idx = 1; blk_idx < mvm->num_of_paging_blk + 1; blk_idx++) {
-		/* allocate block of PAGING_BLOCK_SIZE (32K) */
-		order = get_order(PAGING_BLOCK_SIZE);
+	for (blk_idx = 0; blk_idx < mvm->num_of_paging_blk + 1; blk_idx++) {
+		/* For CSS allocate 4KB, for others PAGING_BLOCK_SIZE (32K) */
+		size = blk_idx ? PAGING_BLOCK_SIZE : FW_PAGING_SIZE;
+		order = get_order(size);
 		block = alloc_pages(GFP_KERNEL, order);
 		if (!block) {
 			/* free all the previous pages since we failed */
@@ -332,7 +296,7 @@ static int iwl_alloc_fw_paging_mem(struct iwl_mvm *mvm,
 		}
 
 		mvm->fw_paging_db[blk_idx].fw_paging_block = block;
-		mvm->fw_paging_db[blk_idx].fw_paging_size = PAGING_BLOCK_SIZE;
+		mvm->fw_paging_db[blk_idx].fw_paging_size = size;
 
 		if (dma_enabled) {
 			phys = dma_map_page(mvm->trans->dev, block, 0,
@@ -353,9 +317,14 @@ static int iwl_alloc_fw_paging_mem(struct iwl_mvm *mvm,
 				blk_idx << BLOCK_2_EXP_SIZE;
 		}
 
-		IWL_DEBUG_FW(mvm,
-			     "Paging: allocated 32K bytes (order %d) for firmware paging.\n",
-			     order);
+		if (!blk_idx)
+			IWL_DEBUG_FW(mvm,
+				     "Paging: allocated 4K(CSS) bytes (order %d) for firmware paging.\n",
+				     order);
+		else
+			IWL_DEBUG_FW(mvm,
+				     "Paging: allocated 32K bytes (order %d) for firmware paging.\n",
+				     order);
 	}
 
 	return 0;
-- 
2.11.0
