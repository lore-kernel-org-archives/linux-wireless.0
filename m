Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:9395 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757272AbcAaLGk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:40 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/31] iwlwifi: mvm: remove shadowing variable
Date: Sun, 31 Jan 2016 13:06:08 +0200
Message-Id: <1454238386-27032-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_120643_926063_5F782FCC)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The outer scope has a perfectly suitable 'i' variable,
use it instead of adding a shadowing one in the inner
scope.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 94ec3f0..4856eac 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -644,8 +644,6 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 
 	/* Dump fw's virtual image */
 	if (mvm->fw->img[mvm->cur_ucode].paging_mem_size) {
-		u32 i;
-
 		for (i = 1; i < mvm->num_of_paging_blk + 1; i++) {
 			struct iwl_fw_error_dump_paging *paging;
 			struct page *pages =
-- 
2.5.0

