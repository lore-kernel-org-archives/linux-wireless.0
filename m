Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:47797 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbcC3OFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:48 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/43] iwlwifi: mvm: handle async temperature notification with unlocked mutex
Date: Wed, 30 Mar 2016 17:04:42 +0300
Message-Id: <1459346715-7954-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160551_872426_F7AFBBB2)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

Use RX_HANDLER_ASYNC_UNLOCKED instead of unlock and re-lock
the mutex independently.

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c  | 9 ---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 46a22fd..6153c8e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -292,7 +292,7 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 	RX_HANDLER(DTS_MEASUREMENT_NOTIFICATION, iwl_mvm_temp_notif,
 		   RX_HANDLER_ASYNC_LOCKED),
 	RX_HANDLER_GRP(PHY_OPS_GROUP, DTS_MEASUREMENT_NOTIF_WIDE,
-		       iwl_mvm_temp_notif, RX_HANDLER_ASYNC_LOCKED),
+		       iwl_mvm_temp_notif, RX_HANDLER_ASYNC_UNLOCKED),
 	RX_HANDLER_GRP(PHY_OPS_GROUP, CT_KILL_NOTIFICATION,
 		       iwl_mvm_ct_kill_notif, RX_HANDLER_SYNC),
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index f1f2825..8d27137 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -204,20 +204,11 @@ void iwl_mvm_temp_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	if (WARN_ON(ths_crossed >= IWL_MAX_DTS_TRIPS))
 		return;
 
-	/*
-	 * We are now handling a temperature notification from the firmware
-	 * in ASYNC and hold the mutex. thermal_notify_framework will call
-	 * us back through get_temp() which ought to send a SYNC command to
-	 * the firmware and hence to take the mutex.
-	 * Avoid the deadlock by unlocking the mutex here.
-	 */
 	if (mvm->tz_device.tzone) {
 		struct iwl_mvm_thermal_device *tz_dev = &mvm->tz_device;
 
-		mutex_unlock(&mvm->mutex);
 		thermal_notify_framework(tz_dev->tzone,
 					 tz_dev->fw_trips_index[ths_crossed]);
-		mutex_lock(&mvm->mutex);
 	}
 #endif /* CONFIG_THERMAL */
 }
-- 
2.5.0

