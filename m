Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65313 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422784AbbEUTxe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 15:53:34 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Haim Dreyfuss <haim.dreyfuss@intel.com>, stable@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/10] iwlwifi: mvm: Free fw_status after use to avoid memory leak
Date: Thu, 21 May 2015 22:53:05 +0300
Message-Id: <1432237990-5890-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150521_215348_618259_F4DA64FF)
In-Reply-To: <1432237819.26813.4.camel@intel.com>
References: <1432237819.26813.4.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

fw_status is the only pointer pointing to a block of memory
allocated above and should be freed after use.
Note: this come from Klockwork static analyzer.

Cc: stable@vger.kernel.org [3.19+]
Fixes: 2021a89d7b8a ("iwlwifi: mvm: treat netdetect wake up separately")
Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 1b1b2bf..42dadaf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1750,8 +1750,10 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 	int i, j, n_matches, ret;
 
 	fw_status = iwl_mvm_get_wakeup_status(mvm, vif);
-	if (!IS_ERR_OR_NULL(fw_status))
+	if (!IS_ERR_OR_NULL(fw_status)) {
 		reasons = le32_to_cpu(fw_status->wakeup_reasons);
+		kfree(fw_status);
+	}
 
 	if (reasons & IWL_WOWLAN_WAKEUP_BY_RFKILL_DEASSERTED)
 		wakeup.rfkill_release = true;
-- 
2.1.4

