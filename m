Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33500 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753772AbcGFKpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:45:00 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:34 +0300
Message-Id: <1467801651-1816-39-git-send-email-luca@coelho.fi> (sfid-20160706_124506_985254_E62E733C)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 39/56] iwlwifi: mvm: unmap the paging memory before freeing it
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This led to a DMA splat.

Fixes: a6c4fb4441f4 ("iwlwifi: mvm: Add FW paging mechanism for the UMAC on PCI")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 4db1d84..4c16fa7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -160,17 +160,21 @@ void iwl_free_fw_paging(struct iwl_mvm *mvm)
 		return;
 
 	for (i = 0; i < NUM_OF_FW_PAGING_BLOCKS; i++) {
-		if (!mvm->fw_paging_db[i].fw_paging_block) {
+		struct iwl_fw_paging *paging = &mvm->fw_paging_db[i];
+
+		if (!paging->fw_paging_block) {
 			IWL_DEBUG_FW(mvm,
 				     "Paging: block %d already freed, continue to next page\n",
 				     i);
 
 			continue;
 		}
+		dma_unmap_page(mvm->trans->dev, paging->fw_paging_phys,
+			       paging->fw_paging_size, DMA_BIDIRECTIONAL);
 
-		__free_pages(mvm->fw_paging_db[i].fw_paging_block,
-			     get_order(mvm->fw_paging_db[i].fw_paging_size));
-		mvm->fw_paging_db[i].fw_paging_block = NULL;
+		__free_pages(paging->fw_paging_block,
+			     get_order(paging->fw_paging_size));
+		paging->fw_paging_block = NULL;
 	}
 	kfree(mvm->trans->paging_download_buf);
 	mvm->trans->paging_download_buf = NULL;
-- 
2.8.1

