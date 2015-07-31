Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1095 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbbGaEnT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 00:43:19 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/3] iwlwifi: mvm: Fix regular scan priority
Date: Fri, 31 Jul 2015 07:43:12 +0300
Message-Id: <1438317793-7435-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150731_064322_563806_408A9909)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7DC508@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7DC508@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

The code checks the total number of iterations to differentiate
between regular scan and scheduled scan. However, regular scan has
a total of one iteration, not zero. As a result, regular scan will
have lower priority than it should have, and in case scheduled
scan is already running when regular scan is requested, regular scan
will be delayed until scheduled scan is aborted.
Fix that by checking for total iterations number of one as an
identifier for regular scan.

Fixes: 133c8259f885 ("iwlwifi: mvm: rename generic_scan_cmd functions to dwell")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 5000bfcd..5514ad6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1023,7 +1023,7 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 	cmd->scan_priority =
 		iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_6);
 
-	if (iwl_mvm_scan_total_iterations(params) == 0)
+	if (iwl_mvm_scan_total_iterations(params) == 1)
 		cmd->ooc_priority =
 			iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_6);
 	else
-- 
2.1.4

