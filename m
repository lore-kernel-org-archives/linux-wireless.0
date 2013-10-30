Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:47767 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab3J3UcV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 16:32:21 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 9/9] iwlwifi: mvm: BT Coex - fix copy paste issue
Date: Wed, 30 Oct 2013 22:31:37 +0200
Message-Id: <1383165097-4445-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131030_213227_045286_CCD346D0)
In-Reply-To: <1383165097-4445-1-git-send-email-emmanuel.grumbach@intel.com>
References: <527143AA.5070900@gmail.com>
 <1383165097-4445-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Putting the context id of the primary phy context in
the placeholder of the secondary is obviously a bad
idea.
Spotted by smatch.

Fixes: dac94da8dba3 ("iwlwifi: mvm: new BT Coex API")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index 7444b2a..5d066cb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -755,7 +755,7 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 
 		cmd.bt_secondary_ci =
 			iwl_ci_mask[chan->def.chan->hw_value][ci_bw_idx];
-		cmd.secondary_ch_phy_id = *((u16 *)data.primary->drv_priv);
+		cmd.secondary_ch_phy_id = *((u16 *)data.secondary->drv_priv);
 	}
 
 	rcu_read_unlock();
-- 
1.8.3.2

