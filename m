Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40876 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752059AbdG1OYL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:24:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:21 +0300
Message-Id: <20170728142337.19183-9-luca@coelho.fi> (sfid-20170728_162425_531494_F14BF28A)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 08/24] iwlwifi: mvm: check family instead of new TX API for workarounds
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are two workarounds because RSS is currently broken on A000
devices due to firmware issues, but checking for the new TX API
doesn't really make sense. Check the hardware family instead of
the new TX API - there's nothing better to check since it's just
a temporary workaround.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       | 3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 58f846610e5d..e04bf2f7c1ba 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1118,7 +1118,8 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 
 	/* Init RSS configuration */
 	/* TODO - remove a000 disablement when we have RXQ config API */
-	if (iwl_mvm_has_new_rx_api(mvm) && !iwl_mvm_has_new_tx_api(mvm)) {
+	if (iwl_mvm_has_new_rx_api(mvm) &&
+	    mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_A000) {
 		ret = iwl_send_rss_cfg_cmd(mvm);
 		if (ret) {
 			IWL_ERR(mvm, "Failed to configure RSS queues: %d\n",
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index ab6c6bf79565..44f144c58720 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4280,7 +4280,8 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 	lockdep_assert_held(&mvm->mutex);
 
 	/* TODO - remove a000 disablement when we have RXQ config API */
-	if (!iwl_mvm_has_new_rx_api(mvm) || iwl_mvm_has_new_tx_api(mvm))
+	if (!iwl_mvm_has_new_rx_api(mvm) ||
+	    mvm->trans->cfg->device_family == IWL_DEVICE_FAMILY_A000)
 		return;
 
 	notif->cookie = mvm->queue_sync_cookie;
-- 
2.13.2
