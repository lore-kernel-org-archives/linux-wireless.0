Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60586 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751148AbdFBJfb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 05:35:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 12:35:10 +0300
Message-Id: <20170602093516.16369-5-luca@coelho.fi> (sfid-20170602_113546_332433_141DEA66)
In-Reply-To: <20170602093516.16369-1-luca@coelho.fi>
References: <20170602093516.16369-1-luca@coelho.fi>
Subject: [PATCH 04/10] iwlwifi: tt: move ucode_loaded check under mutex
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The ucode_loaded check should be under the mutex, since it can
otherwise change state after we looked at it and before we got
the mutex. Fix that.

Fixes: 5c89e7bc557e ("iwlwifi: mvm: add registration to cooling device")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index f9cbd197246f..506d58104e1c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -790,11 +790,13 @@ static int iwl_mvm_tcool_set_cur_state(struct thermal_cooling_device *cdev,
 	struct iwl_mvm *mvm = (struct iwl_mvm *)(cdev->devdata);
 	int ret;
 
-	if (!mvm->ucode_loaded || !(mvm->cur_ucode == IWL_UCODE_REGULAR))
-		return -EIO;
-
 	mutex_lock(&mvm->mutex);
 
+	if (!mvm->ucode_loaded || !(mvm->cur_ucode == IWL_UCODE_REGULAR)) {
+		ret = -EIO;
+		goto unlock;
+	}
+
 	if (new_state >= ARRAY_SIZE(iwl_mvm_cdev_budgets)) {
 		ret = -EINVAL;
 		goto unlock;
-- 
2.11.0
