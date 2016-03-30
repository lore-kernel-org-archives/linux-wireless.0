Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:59098 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbcC3OFk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:40 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/43] iwlwifi: mvm: Decrease size of the paging download buffer
Date: Wed, 30 Mar 2016 17:04:34 +0300
Message-Id: <1459346715-7954-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160813_155493_1D2B012A)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Currently the driver has 2 buffers for paging:
1. paging db - this contains all of the pages that were in the FW
image, that the driver stores for the FW. This is allocated for each
block separately (not contiguous).
2. download buffer - we need to provide this empty buffer for the
iwl_sdio_load_fw_chunk function to copy the requested pages to the shared
memory. This is one big buffer of contiguous memory whose size is the
size of all the blocks that the fw paging section can contain.

This download buffer size is too big, and causes the allocation to fail
sometimes. Since the driver allocates memory for each block separately,
it is not possible for the FW to request all of the pages in one request
(the FW gives an address and size, so blocks need to be contiguous for
this to happen), therefore the FW is limited to request only one block.

Decrease the size of the paging download buffer to be the size of a
paging block.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 594cd0d..ebbadcf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -410,7 +410,9 @@ static int iwl_trans_get_paging_item(struct iwl_mvm *mvm)
 		goto exit;
 	}
 
-	mvm->trans->paging_download_buf = kzalloc(MAX_PAGING_IMAGE_SIZE,
+	/* Add an extra page for headers */
+	mvm->trans->paging_download_buf = kzalloc(PAGING_BLOCK_SIZE +
+						  FW_PAGING_SIZE,
 						  GFP_KERNEL);
 	if (!mvm->trans->paging_download_buf) {
 		ret = -ENOMEM;
-- 
2.5.0

