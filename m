Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37350 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751594AbdGEGFw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 02:05:52 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  5 Jul 2017 09:05:39 +0300
Message-Id: <20170705060539.20737-8-luca@coelho.fi> (sfid-20170705_080600_160125_A9025F28)
In-Reply-To: <20170705060539.20737-1-luca@coelho.fi>
References: <20170705060539.20737-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 7/7] iwlwifi: mvm: defer setting IWL_MVM_STATUS_IN_HW_RESTART
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A hardware/firmware error may happen at any point in time. In
particular, it might happen while mac80211 is in the middle of
a flow. We observed the following situation:
 * mac80211 is in authentication flow, in ieee80211_prep_connection()
 * iwlwifi firmware crashes, but no error can be reported at this
   precise point (mostly because the driver method is void, but even
   if it wasn't we'd just shift to a race condition)
 * mac80211 continues the flow, trying to add the AP station
 * iwlwifi has already set its internal restart flag, and so thinks
   that adding the station is part of the restart and already set up,
   so it uses the information that's supposed to already be in the
   struct

This can happen with any flow in mac80211 and with any information
we try to preserve across hardware restarts.

To fix this, only set a new HW_RESTART_REQUESTED flag and translate
that to IN_HW_RESTART once mac80211 actually starts the restart by
calling our start() method. As a consequence, any mac80211 flow in
progress at the time of the restart will properly finish (certainly
with errors), before the restart is attempted.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=195299.

Reported-by: djagoo <dev@djagoo.io>
Reported-by: Łukasz Siudut <lsiudut@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 8 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      | 6 +++---
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index bcde1ba0f1c8..c7b1e58e3384 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1084,7 +1084,13 @@ int __iwl_mvm_mac_start(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
+	if (test_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED, &mvm->status)) {
+		/*
+		 * Now convert the HW_RESTART_REQUESTED flag to IN_HW_RESTART
+		 * so later code will - from now on - see that we're doing it.
+		 */
+		set_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
+		clear_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED, &mvm->status);
 		/* Clean up some internal and mac80211 state on restart */
 		iwl_mvm_restart_cleanup(mvm);
 	} else {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index eaacfaf37206..ddd8719f27b8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1090,6 +1090,7 @@ struct iwl_mvm {
  * @IWL_MVM_STATUS_HW_RFKILL: HW RF-kill is asserted
  * @IWL_MVM_STATUS_HW_CTKILL: CT-kill is active
  * @IWL_MVM_STATUS_ROC_RUNNING: remain-on-channel is running
+ * @IWL_MVM_STATUS_HW_RESTART_REQUESTED: HW restart was requested
  * @IWL_MVM_STATUS_IN_HW_RESTART: HW restart is active
  * @IWL_MVM_STATUS_IN_D0I3: NIC is in D0i3
  * @IWL_MVM_STATUS_ROC_AUX_RUNNING: AUX remain-on-channel is running
@@ -1101,6 +1102,7 @@ enum iwl_mvm_status {
 	IWL_MVM_STATUS_HW_RFKILL,
 	IWL_MVM_STATUS_HW_CTKILL,
 	IWL_MVM_STATUS_ROC_RUNNING,
+	IWL_MVM_STATUS_HW_RESTART_REQUESTED,
 	IWL_MVM_STATUS_IN_HW_RESTART,
 	IWL_MVM_STATUS_IN_D0I3,
 	IWL_MVM_STATUS_ROC_AUX_RUNNING,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 4d1188b8736a..9c175d5e9d67 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1235,9 +1235,8 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 	 */
 	if (!mvm->fw_restart && fw_error) {
 		iwl_mvm_fw_dbg_collect_desc(mvm, &iwl_mvm_dump_desc_assert,
-					    NULL);
-	} else if (test_and_set_bit(IWL_MVM_STATUS_IN_HW_RESTART,
-				    &mvm->status)) {
+					NULL);
+	} else if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
 		struct iwl_mvm_reprobe *reprobe;
 
 		IWL_ERR(mvm,
@@ -1268,6 +1267,7 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 
 		if (fw_error && mvm->fw_restart > 0)
 			mvm->fw_restart--;
+		set_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED, &mvm->status);
 		ieee80211_restart_hw(mvm->hw);
 	}
 }
-- 
2.11.0
