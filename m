Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47628 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S936352AbdCXPhb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 11:37:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Mar 2017 17:37:12 +0200
Message-Id: <20170324153714.8880-2-luca@coelho.fi> (sfid-20170324_163806_014397_E748A3B2)
In-Reply-To: <20170324153714.8880-1-luca@coelho.fi>
References: <20170324153714.8880-1-luca@coelho.fi>
Subject: [PATCH 1/3] iwlwifi: mvm: fix accessing fw_id_to_mac_id
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Access should be by rcu_dereference. Issue was found by sparse.

Fixes: 65e254821cee ("iwlwifi: mvm: use firmware station PM notification for AP_LINK_PS")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 6927caecd48e..486dcceed17a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2401,7 +2401,7 @@ void iwl_mvm_sta_pm_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 		return;
 
 	rcu_read_lock();
-	sta = mvm->fw_id_to_mac_id[notif->sta_id];
+	sta = rcu_dereference(mvm->fw_id_to_mac_id[notif->sta_id]);
 	if (WARN_ON(IS_ERR_OR_NULL(sta))) {
 		rcu_read_unlock();
 		return;
-- 
2.11.0
