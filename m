Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbbLUUvL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:51:11 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/45] iwlwifi: mvm: check iwl_mvm_wowlan_config_key_params() return value
Date: Mon, 21 Dec 2015 22:50:11 +0200
Message-Id: <1450731046-2796-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215201_537204_A22DB2CB)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

commit 9a4c830007817e ("iwlwifi: mvm: refactor d3 key
update functions") refactored some code into
iwl_mvm_wowlan_config_key_params() function, but the
return value was never checked, and not all the function
flows returned valid values. fix it.

Fixes: ac8ef0ce38de ("iwlwifi: mvm: refactor d3 key update functions")
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 9e51843..542de74 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -917,6 +917,7 @@ int iwl_mvm_wowlan_config_key_params(struct iwl_mvm *mvm,
 		if (ret)
 			goto out;
 	}
+	ret = 0;
 out:
 	kfree(key_data.rsc_tsc);
 	return ret;
@@ -946,8 +947,11 @@ iwl_mvm_wowlan_config(struct iwl_mvm *mvm,
 		 * that isn't really a problem though.
 		 */
 		mutex_unlock(&mvm->mutex);
-		iwl_mvm_wowlan_config_key_params(mvm, vif, true, CMD_ASYNC);
+		ret = iwl_mvm_wowlan_config_key_params(mvm, vif, true,
+						       CMD_ASYNC);
 		mutex_lock(&mvm->mutex);
+		if (ret)
+			return ret;
 	}
 
 	ret = iwl_mvm_send_cmd_pdu(mvm, WOWLAN_CONFIGURATION, 0,
-- 
2.5.0

