Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:35571 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbcC3OGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:34 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 42/43] iwlwifi: mvm: allow setting the thermal state in D0i3
Date: Wed, 30 Mar 2016 17:05:14 +0300
Message-Id: <1459346715-7954-42-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_161040_966338_13CF2544)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We were not allowing the thermal state to be set when we were in D0i3
mode.  It was not very clearly specified how it should work, but now a
decision was made to allow the state to be set in D0i3 (which will
cause a brief wake up).  Remove the check in the set_cur_state
operation.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 3f5df76..eb3f460 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -801,9 +801,6 @@ static int iwl_mvm_tcool_set_cur_state(struct thermal_cooling_device *cdev,
 	if (!mvm->ucode_loaded || !(mvm->cur_ucode == IWL_UCODE_REGULAR))
 		return -EIO;
 
-	if (test_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status))
-		return -EBUSY;
-
 	mutex_lock(&mvm->mutex);
 
 	if (new_state >= ARRAY_SIZE(iwl_mvm_cdev_budgets)) {
-- 
2.5.0

