Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:35851 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbcC3OGT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:19 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/43] iwlwifi: mvm: remove uneeded D0I3 checking
Date: Wed, 30 Mar 2016 17:05:00 +0300
Message-Id: <1459346715-7954-28-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160706_590589_5CE1B9DC)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

The driver can read the current state during D0I3,
therefore there is no reason not to do it.

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 8d27137..3f5df76 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -787,9 +787,6 @@ static int iwl_mvm_tcool_get_cur_state(struct thermal_cooling_device *cdev,
 {
 	struct iwl_mvm *mvm = (struct iwl_mvm *)(cdev->devdata);
 
-	if (test_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status))
-		return -EBUSY;
-
 	*state = mvm->cooling_dev.cur_state;
 
 	return 0;
-- 
2.5.0

