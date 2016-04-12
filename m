Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30229 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932549AbcDLIQ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 04:16:59 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/4] iwlwifi: mvm: fix accessing Null pointer during fw dump collection
Date: Tue, 12 Apr 2016 11:16:51 +0300
Message-Id: <1460449011-8417-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160412_101704_432640_118573D9)
In-Reply-To: <1460448889.2630.12.camel@intel.com>
References: <1460448889.2630.12.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

The firwmare file can come with data that is relevant for paging. This
data is availablet to the firmware upon request, but it stored in the
host's memory. During the firmware init flow, the driver configures the
firmware so that the firwmare knows where is the data.
When paging is used, the variable paging_mem_size is the number of bytes
that are available through paging. This variable is not zeror-ed if the
driver fails to configure the paging in the firmware, but the memory is
freed which is inconsistent.
This inconsistency led to a NULL pointer dereference in the code that
collects the debug data.

Fix this by zero-ing the paging_mem_size variable and NULLify the
relevant pointers, so that the code that collects the debug data will
know that the paging data is not available.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 6 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c     | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 4856eac..6938cd3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -526,7 +526,8 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		file_len += sizeof(*dump_data) + sizeof(*dump_mem) + sram2_len;
 
 	/* Make room for fw's virtual image pages, if it exists */
-	if (mvm->fw->img[mvm->cur_ucode].paging_mem_size)
+	if (mvm->fw->img[mvm->cur_ucode].paging_mem_size &&
+	    mvm->fw_paging_db[0].fw_paging_block)
 		file_len += mvm->num_of_paging_blk *
 			(sizeof(*dump_data) +
 			 sizeof(struct iwl_fw_error_dump_paging) +
@@ -643,7 +644,8 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	}
 
 	/* Dump fw's virtual image */
-	if (mvm->fw->img[mvm->cur_ucode].paging_mem_size) {
+	if (mvm->fw->img[mvm->cur_ucode].paging_mem_size &&
+	    mvm->fw_paging_db[0].fw_paging_block) {
 		for (i = 1; i < mvm->num_of_paging_blk + 1; i++) {
 			struct iwl_fw_error_dump_paging *paging;
 			struct page *pages =
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 594cd0d..09d895f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -144,9 +144,11 @@ void iwl_free_fw_paging(struct iwl_mvm *mvm)
 
 		__free_pages(mvm->fw_paging_db[i].fw_paging_block,
 			     get_order(mvm->fw_paging_db[i].fw_paging_size));
+		mvm->fw_paging_db[i].fw_paging_block = NULL;
 	}
 	kfree(mvm->trans->paging_download_buf);
 	mvm->trans->paging_download_buf = NULL;
+	mvm->trans->paging_db = NULL;
 
 	memset(mvm->fw_paging_db, 0, sizeof(mvm->fw_paging_db));
 }
-- 
2.5.0

