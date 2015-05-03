Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbbECTdJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:33:09 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/42] iwlwifi: mvm: avoid use-after-free on iwl_mvm_d0i3_enable_tx() [BUGFIX]
Date: Sun,  3 May 2015 22:31:44 +0300
Message-Id: <1430681513-7838-33-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213418_291171_17D4867C)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

qos_seq points (to a struct) inside the command response data.

Make sure to free the response only after qos_seq is not
needed anymore.

type=bugfix
bug=not-tracked
fixes=I78c07110b59dcd389207bd2b168b0a2760839fe0

Change-Id: I619ce2c17e064dc98c7be9abc1e23175fdc8fb9a
Reported-by: Heng Luo <heng.luo@intel.com>
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-on: https://gerrit.rds.intel.com/r/55381
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Tested-by: IWL Jenkins
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 1c66297..2ea0123 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1263,11 +1263,13 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 		ieee80211_iterate_active_interfaces(
 			mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 			iwl_mvm_d0i3_disconnect_iter, mvm);
-
-	iwl_free_resp(&get_status_cmd);
 out:
 	iwl_mvm_d0i3_enable_tx(mvm, qos_seq);
 
+	/* qos_seq might point inside resp_pkt, so free it only now */
+	if (get_status_cmd.resp_pkt)
+		iwl_free_resp(&get_status_cmd);
+
 	/* the FW might have updated the regdomain */
 	iwl_mvm_update_changed_regdom(mvm);
 
-- 
2.1.0

