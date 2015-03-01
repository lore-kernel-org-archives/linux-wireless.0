Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbbCATcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:08 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/31] iwlwifi: mvm: fix BT coex shared antenna activity check
Date: Sun,  1 Mar 2015 21:31:22 +0200
Message-Id: <1425238304-498-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203213_792781_133E117E)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The shared antenna should be forbidden to use only if there's
high BT activity. Comparing to BT_OFF was effectively causing
us to always forbid using the shared antenna for SISO. This
leads to degraded performance in scenarios where the shared
antenna would have better performance.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index d530ef3..85144d5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -1176,7 +1176,7 @@ bool iwl_mvm_bt_coex_is_ant_avail_old(struct iwl_mvm *mvm, u8 ant)
 bool iwl_mvm_bt_coex_is_shared_ant_avail_old(struct iwl_mvm *mvm)
 {
 	u32 ag = le32_to_cpu(mvm->last_bt_notif_old.bt_activity_grading);
-	return ag == BT_OFF;
+	return ag < BT_HIGH_TRAFFIC;
 }
 
 bool iwl_mvm_bt_coex_is_tpc_allowed_old(struct iwl_mvm *mvm,
-- 
1.9.1

