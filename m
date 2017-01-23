Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36184 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751693AbdAWWEQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:04:16 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Sara Sharon <sara.sharon@intel.com>
Date: Tue, 24 Jan 2017 00:03:34 +0200
Message-Id: <20170123220350.25305-10-luca@coelho.fi> (sfid-20170123_230418_253742_A673640B)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
Subject: [PATCH 09/25] iwlwifi: mvm: replace the number of blocks calculation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The logic in the paging calculations is a bit hard to
follow. Replace it with a kernel define.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 04fe1051b1e5..606b3fc18d46 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -270,8 +270,8 @@ static int iwl_alloc_fw_paging_mem(struct iwl_mvm *mvm,
 	BUILD_BUG_ON(BIT(BLOCK_2_EXP_SIZE) != PAGING_BLOCK_SIZE);
 
 	num_of_pages = image->paging_mem_size / FW_PAGING_SIZE;
-	mvm->num_of_paging_blk = ((num_of_pages - 1) /
-				    NUM_OF_PAGE_PER_GROUP) + 1;
+	mvm->num_of_paging_blk =
+		DIV_ROUND_UP(num_of_pages, NUM_OF_PAGE_PER_GROUP);
 	mvm->num_of_pages_in_last_blk =
 		num_of_pages -
 		NUM_OF_PAGE_PER_GROUP * (mvm->num_of_paging_blk - 1);
-- 
2.11.0
