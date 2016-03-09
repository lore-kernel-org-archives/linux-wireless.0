Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:20791 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933298AbcCIRqB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:46:01 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/21] iwlwifi: mvm: avoid panics with thermal device usage
Date: Wed,  9 Mar 2016 19:45:33 +0200
Message-Id: <1457545550-30677-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_184607_355715_3D1443B9)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thermal zone device registration can fail, and in this case
we don't want to remove WiFi functionality. This is why the
thermal zone registration function is void, and the flows
continue even if the thermal zone device registration failed.
Same applies for the cooling device.

This means that we at least need to remember that the thermal
zone device didn't register properly and take the minimal
precautions to avoid panic'ing when we access it.

This was missing.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c  | 57 +++++++++++++++-------------
 2 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index ab410b4..b869db9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1575,7 +1575,6 @@ void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state);
 int iwl_mvm_get_temp(struct iwl_mvm *mvm, s32 *temp);
 void iwl_mvm_ct_kill_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 int iwl_mvm_send_temp_report_ths_cmd(struct iwl_mvm *mvm);
-int iwl_mvm_cooling_device_register(struct iwl_mvm *mvm);
 int iwl_mvm_ctdp_command(struct iwl_mvm *mvm, u32 op, u32 budget);
 
 /* Location Aware Regulatory */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 999bcb8..0a02e98 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -211,10 +211,14 @@ void iwl_mvm_temp_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	 * the firmware and hence to take the mutex.
 	 * Avoid the deadlock by unlocking the mutex here.
 	 */
-	mutex_unlock(&mvm->mutex);
-	thermal_notify_framework(mvm->tz_device.tzone,
-				 mvm->tz_device.fw_trips_index[ths_crossed]);
-	mutex_lock(&mvm->mutex);
+	if (mvm->tz_device.tzone) {
+		struct iwl_mvm_thermal_device *tz_dev = &mvm->tz_device;
+
+		mutex_unlock(&mvm->mutex);
+		thermal_notify_framework(tz_dev->tzone,
+					 tz_dev->fw_trips_index[ths_crossed]);
+		mutex_lock(&mvm->mutex);
+	}
 #endif /* CONFIG_THERMAL */
 }
 
@@ -520,16 +524,20 @@ int iwl_mvm_send_temp_report_ths_cmd(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (!mvm->tz_device.tzone)
+		return -EINVAL;
+
 	/* The driver holds array of temperature trips that are unsorted
 	 * and uncompressed, the FW should get it compressed and sorted
 	 */
 
 	/* compress temp_trips to cmd array, remove uninitialized values*/
-	for (i = 0; i < IWL_MAX_DTS_TRIPS; i++)
+	for (i = 0; i < IWL_MAX_DTS_TRIPS; i++) {
 		if (mvm->tz_device.temp_trips[i] != S16_MIN) {
 			cmd.thresholds[idx++] =
 				cpu_to_le16(mvm->tz_device.temp_trips[i]);
 		}
+	}
 	cmd.num_temps = cpu_to_le32(idx);
 
 	if (!idx)
@@ -696,6 +704,7 @@ static void iwl_mvm_thermal_zone_register(struct iwl_mvm *mvm)
 		IWL_DEBUG_TEMP(mvm,
 			       "Failed to register to thermal zone (err = %ld)\n",
 			       PTR_ERR(mvm->tz_device.tzone));
+		mvm->tz_device.tzone = NULL;
 		return;
 	}
 
@@ -750,6 +759,10 @@ int iwl_mvm_ctdp_command(struct iwl_mvm *mvm, u32 op, u32 budget)
 		return ret;
 	}
 
+	/* can happen if the registration failed */
+	if (!mvm->cooling_dev.cdev)
+		return -EINVAL;
+
 	if (op == CTDP_CMD_OPERATION_START)
 		mvm->cooling_dev.cur_state = budget;
 
@@ -812,15 +825,12 @@ static struct thermal_cooling_device_ops tcooling_ops = {
 	.set_cur_state = iwl_mvm_tcool_set_cur_state,
 };
 
-int iwl_mvm_cooling_device_register(struct iwl_mvm *mvm)
+static void iwl_mvm_cooling_device_register(struct iwl_mvm *mvm)
 {
 	char name[] = "iwlwifi";
 
-	if (!iwl_mvm_is_ctdp_supported(mvm)) {
-		mvm->cooling_dev.cdev = NULL;
-
-		return 0;
-	}
+	if (!iwl_mvm_is_ctdp_supported(mvm))
+		return;
 
 	BUILD_BUG_ON(ARRAY_SIZE(name) >= THERMAL_NAME_LENGTH);
 
@@ -833,34 +843,29 @@ int iwl_mvm_cooling_device_register(struct iwl_mvm *mvm)
 		IWL_DEBUG_TEMP(mvm,
 			       "Failed to register to cooling device (err = %ld)\n",
 			       PTR_ERR(mvm->cooling_dev.cdev));
-		return PTR_ERR(mvm->cooling_dev.cdev);
+		mvm->cooling_dev.cdev = NULL;
+		return;
 	}
-
-	return 0;
 }
 
 static void iwl_mvm_thermal_zone_unregister(struct iwl_mvm *mvm)
 {
-	if (!iwl_mvm_is_tt_in_fw(mvm))
+	if (!iwl_mvm_is_tt_in_fw(mvm) || !mvm->tz_device.tzone)
 		return;
 
-	if (mvm->tz_device.tzone) {
-		IWL_DEBUG_TEMP(mvm, "Thermal zone device unregister\n");
-		thermal_zone_device_unregister(mvm->tz_device.tzone);
-		mvm->tz_device.tzone = NULL;
-	}
+	IWL_DEBUG_TEMP(mvm, "Thermal zone device unregister\n");
+	thermal_zone_device_unregister(mvm->tz_device.tzone);
+	mvm->tz_device.tzone = NULL;
 }
 
 static void iwl_mvm_cooling_device_unregister(struct iwl_mvm *mvm)
 {
-	if (!iwl_mvm_is_ctdp_supported(mvm))
+	if (!iwl_mvm_is_ctdp_supported(mvm) || !mvm->cooling_dev.cdev)
 		return;
 
-	if (mvm->cooling_dev.cdev) {
-		IWL_DEBUG_TEMP(mvm, "Cooling device unregister\n");
-		thermal_cooling_device_unregister(mvm->cooling_dev.cdev);
-		mvm->cooling_dev.cdev = NULL;
-	}
+	IWL_DEBUG_TEMP(mvm, "Cooling device unregister\n");
+	thermal_cooling_device_unregister(mvm->cooling_dev.cdev);
+	mvm->cooling_dev.cdev = NULL;
 }
 #endif /* CONFIG_THERMAL */
 
-- 
2.5.0

