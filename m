Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbbEZTSj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:39 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/39] iwlwifi: mvm: BT Coex - fix shared antenna check with new API
Date: Tue, 26 May 2015 22:17:35 +0300
Message-Id: <1432667872-18092-22-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_213348_263192_A7AA8516)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit below fixed this for the old firmware API only.
Since the new firmware API hasn't been released yet, this
doesn't fix anything on currently existing firmwares.
This completes:

commit afcee962b09842d0f4191beb4a2d08251b4c7705
Author: Eyal Shapira <eyal@wizery.com>
Date:   Mon Feb 9 15:18:17 2015 +0200

    iwlwifi: mvm: fix BT coex shared antenna activity check

type=bugfix
bug=not-tracked
fixes=unknown

Reviewed-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index a990886..662fa9c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -886,7 +886,7 @@ bool iwl_mvm_bt_coex_is_shared_ant_avail(struct iwl_mvm *mvm)
 	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_mvm_bt_coex_is_shared_ant_avail_old(mvm);
 
-	return le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) == BT_OFF;
+	return le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) < BT_HIGH_TRAFFIC;
 }
 
 bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
-- 
2.1.4

