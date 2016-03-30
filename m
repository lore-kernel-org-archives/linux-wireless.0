Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:59098 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbcC3OFl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:41 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/43] iwlwifi: mvm: make sure FW contains the right amount of paging sections
Date: Wed, 30 Mar 2016 17:04:35 +0300
Message-Id: <1459346715-7954-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160544_094937_334278A2)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Paging contains 3 sections in the fw. The first for the paging separator,
The second for the CSS block, the third with the paging data.

Currently if the driver finds the paging separator, and there is only
section left (CSS), once reading the CSS section, the driver will
attempt to read the paging data and will go out of the arrays bounds.

Make sure that the FW image contains the right amount of sections for
paging.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index ebbadcf..766c262 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -174,8 +174,12 @@ static int iwl_fill_paging_mem(struct iwl_mvm *mvm, const struct fw_img *image)
 		}
 	}
 
-	if (sec_idx >= IWL_UCODE_SECTION_MAX) {
-		IWL_ERR(mvm, "driver didn't find paging image\n");
+	/*
+	 * If paging is enabled there should be at least 2 more sections left
+	 * (one for CSS and one for Paging data)
+	 */
+	if (sec_idx >= ARRAY_SIZE(image->sec) - 1) {
+		IWL_ERR(mvm, "Paging: Missing CSS and/or paging sections\n");
 		iwl_free_fw_paging(mvm);
 		return -EINVAL;
 	}
-- 
2.5.0

