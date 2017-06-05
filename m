Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59458 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751186AbdFEUoD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:44:03 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:42:07 +0300
Message-Id: <20170605204218.30151-15-luca@coelho.fi> (sfid-20170605_224406_613603_BD984166)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 14/25] iwlwifi: mvm: add and use iwl_mvm_device_running()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This will help refactor this later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c  | 25 ++++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  5 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c       | 13 ++++++++----
 4 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 25092cb08c2e..744dc069ff23 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,6 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -82,7 +83,8 @@ static ssize_t iwl_dbgfs_ctdp_budget_read(struct file *file,
 	char buf[16];
 	int pos, budget;
 
-	if (!mvm->ucode_loaded || mvm->cur_ucode != IWL_UCODE_REGULAR)
+	if (!iwl_mvm_firmware_running(mvm) ||
+	    mvm->cur_ucode != IWL_UCODE_REGULAR)
 		return -EIO;
 
 	mutex_lock(&mvm->mutex);
@@ -102,7 +104,8 @@ static ssize_t iwl_dbgfs_stop_ctdp_write(struct iwl_mvm *mvm, char *buf,
 {
 	int ret;
 
-	if (!mvm->ucode_loaded || mvm->cur_ucode != IWL_UCODE_REGULAR)
+	if (!iwl_mvm_firmware_running(mvm) ||
+	    mvm->cur_ucode != IWL_UCODE_REGULAR)
 		return -EIO;
 
 	mutex_lock(&mvm->mutex);
@@ -118,7 +121,8 @@ static ssize_t iwl_dbgfs_tx_flush_write(struct iwl_mvm *mvm, char *buf,
 	int ret;
 	u32 scd_q_msk;
 
-	if (!mvm->ucode_loaded || mvm->cur_ucode != IWL_UCODE_REGULAR)
+	if (!iwl_mvm_firmware_running(mvm) ||
+	    mvm->cur_ucode != IWL_UCODE_REGULAR)
 		return -EIO;
 
 	if (sscanf(buf, "%x", &scd_q_msk) != 1)
@@ -139,7 +143,8 @@ static ssize_t iwl_dbgfs_sta_drain_write(struct iwl_mvm *mvm, char *buf,
 	struct iwl_mvm_sta *mvmsta;
 	int sta_id, drain, ret;
 
-	if (!mvm->ucode_loaded || mvm->cur_ucode != IWL_UCODE_REGULAR)
+	if (!iwl_mvm_firmware_running(mvm) ||
+	    mvm->cur_ucode != IWL_UCODE_REGULAR)
 		return -EIO;
 
 	if (sscanf(buf, "%d %d", &sta_id, &drain) != 2)
@@ -172,7 +177,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file, char __user *user_buf,
 	size_t ret;
 	u8 *ptr;
 
-	if (!mvm->ucode_loaded)
+	if (!iwl_mvm_firmware_running(mvm))
 		return -EINVAL;
 
 	/* default is to dump the entire data segment */
@@ -205,7 +210,7 @@ static ssize_t iwl_dbgfs_sram_write(struct iwl_mvm *mvm, char *buf,
 	u32 offset, len;
 	u32 img_offset, img_len;
 
-	if (!mvm->ucode_loaded)
+	if (!iwl_mvm_firmware_running(mvm))
 		return -EINVAL;
 
 	img = &mvm->fw->img[mvm->cur_ucode];
@@ -258,7 +263,7 @@ static ssize_t iwl_dbgfs_set_nic_temperature_write(struct iwl_mvm *mvm,
 {
 	int temperature;
 
-	if (!mvm->ucode_loaded && !mvm->temperature_test)
+	if (!iwl_mvm_firmware_running(mvm) && !mvm->temperature_test)
 		return -EIO;
 
 	if (kstrtoint(buf, 10, &temperature))
@@ -305,7 +310,7 @@ static ssize_t iwl_dbgfs_nic_temp_read(struct file *file,
 	int pos, ret;
 	s32 temp;
 
-	if (!mvm->ucode_loaded)
+	if (!iwl_mvm_firmware_running(mvm))
 		return -EIO;
 
 	mutex_lock(&mvm->mutex);
@@ -371,7 +376,7 @@ static ssize_t iwl_dbgfs_disable_power_off_write(struct iwl_mvm *mvm, char *buf,
 {
 	int ret, val;
 
-	if (!mvm->ucode_loaded)
+	if (!iwl_mvm_firmware_running(mvm))
 		return -EIO;
 
 	if (!strncmp("disable_power_off_d0=", buf, 21)) {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index f52c251cd891..9e0c0f0e5999 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4028,7 +4028,7 @@ static int iwl_mvm_mac_get_survey(struct ieee80211_hw *hw, int idx,
 
 	mutex_lock(&mvm->mutex);
 
-	if (mvm->ucode_loaded) {
+	if (iwl_mvm_firmware_running(mvm)) {
 		ret = iwl_mvm_request_statistics(mvm, false);
 		if (ret)
 			goto out;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 05489694979e..b47e1f1efc8a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1109,6 +1109,11 @@ static inline bool iwl_mvm_is_radio_hw_killed(struct iwl_mvm *mvm)
 	return test_bit(IWL_MVM_STATUS_HW_RFKILL, &mvm->status);
 }
 
+static inline bool iwl_mvm_firmware_running(struct iwl_mvm *mvm)
+{
+	return mvm->ucode_loaded;
+}
+
 /* Must be called with rcu_read_lock() held and it can only be
  * released when mvmsta is not needed anymore.
  */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 4e03ea911a1f..6414a46e8bb5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -628,7 +628,8 @@ static int iwl_mvm_tzone_get_temp(struct thermal_zone_device *device,
 
 	mutex_lock(&mvm->mutex);
 
-	if (!mvm->ucode_loaded || !(mvm->cur_ucode == IWL_UCODE_REGULAR)) {
+	if (!iwl_mvm_firmware_running(mvm) ||
+	    mvm->cur_ucode != IWL_UCODE_REGULAR) {
 		ret = -EIO;
 		goto out;
 	}
@@ -678,7 +679,8 @@ static int iwl_mvm_tzone_set_trip_temp(struct thermal_zone_device *device,
 
 	mutex_lock(&mvm->mutex);
 
-	if (!mvm->ucode_loaded || !(mvm->cur_ucode == IWL_UCODE_REGULAR)) {
+	if (!iwl_mvm_firmware_running(mvm) ||
+	    mvm->cur_ucode != IWL_UCODE_REGULAR) {
 		ret = -EIO;
 		goto out;
 	}
@@ -790,8 +792,11 @@ static int iwl_mvm_tcool_set_cur_state(struct thermal_cooling_device *cdev,
 	struct iwl_mvm *mvm = (struct iwl_mvm *)(cdev->devdata);
 	int ret;
 
-	if (!mvm->ucode_loaded || !(mvm->cur_ucode == IWL_UCODE_REGULAR))
-		return -EIO;
+	if (!iwl_mvm_firmware_running(mvm) ||
+	    mvm->cur_ucode != IWL_UCODE_REGULAR) {
+		ret = -EIO;
+		goto unlock;
+	}
 
 	mutex_lock(&mvm->mutex);
 
-- 
2.11.0
