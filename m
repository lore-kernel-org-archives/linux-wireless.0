Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:65244 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbaICT4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:38 -0400
Received: by mail-wg0-f50.google.com with SMTP id x12so9011017wgg.33
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:37 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/36] iwlwifi: mvm: reset the temperature when temperature test is disabled
Date: Wed,  3 Sep 2014 22:55:54 +0300
Message-Id: <1409774184-24665-6-git-send-email-egrumbach@gmail.com> (sfid-20140903_215644_381090_40A1F538)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Since we can't read the actual temperature when the firmware is
running, just set the temperature to 0 when the test is disabled and
disable CT Kill if it was enabled.

Additionally, since we rely on iwl_mvm_tt_handler() to exit CT kill
when in test mode, call iwl_mvm_exit_ctkill() in that function if the
temperature is low again.  Also make the iwl_mvm_enter_ctkill() and
iwl_mvm_exit_ctkill() return if called when not necessary anymore
(e.g. when iwl_mvm_exit_ctkill() is called when we're not in CT-kill).

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 10 ++++++++++
 drivers/net/wireless/iwlwifi/mvm/tt.c      | 12 ++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index f7e4488..83e562b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -296,7 +296,15 @@ static ssize_t iwl_dbgfs_set_nic_temperature_write(struct iwl_mvm *mvm,
 
 	mutex_lock(&mvm->mutex);
 	if (temperature == IWL_MVM_DEBUG_SET_TEMPERATURE_DISABLE) {
+		if (!mvm->temperature_test)
+			goto out;
+
 		mvm->temperature_test = false;
+		/* Since we can't read the temp while awake, just set
+		 * it to zero until we get the next RX stats from the
+		 * firmware.
+		 */
+		mvm->temperature = 0;
 	} else {
 		mvm->temperature_test = true;
 		mvm->temperature = temperature;
@@ -306,6 +314,8 @@ static ssize_t iwl_dbgfs_set_nic_temperature_write(struct iwl_mvm *mvm,
 		       mvm->temperature);
 	/* handle the temperature change */
 	iwl_mvm_tt_handler(mvm);
+
+out:
 	mutex_unlock(&mvm->mutex);
 
 	return count;
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index 0464599..d31603c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -314,6 +314,9 @@ static void iwl_mvm_enter_ctkill(struct iwl_mvm *mvm)
 {
 	u32 duration = mvm->thermal_throttle.params->ct_kill_duration;
 
+	if (test_bit(IWL_MVM_STATUS_HW_CTKILL, &mvm->status))
+		return;
+
 	IWL_ERR(mvm, "Enter CT Kill\n");
 	iwl_mvm_set_hw_ctkill_state(mvm, true);
 	schedule_delayed_work(&mvm->thermal_throttle.ct_kill_exit,
@@ -322,6 +325,9 @@ static void iwl_mvm_enter_ctkill(struct iwl_mvm *mvm)
 
 static void iwl_mvm_exit_ctkill(struct iwl_mvm *mvm)
 {
+	if (!test_bit(IWL_MVM_STATUS_HW_CTKILL, &mvm->status))
+		return;
+
 	IWL_ERR(mvm, "Exit CT Kill\n");
 	iwl_mvm_set_hw_ctkill_state(mvm, false);
 }
@@ -444,6 +450,12 @@ void iwl_mvm_tt_handler(struct iwl_mvm *mvm)
 		return;
 	}
 
+	if (params->support_ct_kill &&
+	    temperature <= tt->params->ct_kill_exit) {
+		iwl_mvm_exit_ctkill(mvm);
+		return;
+	}
+
 	if (params->support_dynamic_smps) {
 		if (!tt->dynamic_smps &&
 		    temperature >= params->dynamic_smps_entry) {
-- 
1.9.1

