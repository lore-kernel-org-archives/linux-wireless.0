Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54490 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaICT4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:31 -0400
Received: by mail-wg0-f42.google.com with SMTP id b13so8919546wgh.13
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:29 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/36] iwlwifi: mvm: Add set NIC temperature debug option
Date: Wed,  3 Sep 2014 22:55:49 +0300
Message-Id: <1409774184-24665-1-git-send-email-egrumbach@gmail.com> (sfid-20140903_215634_625766_A1E365C7)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Add ability to set the NIC's temperature and ignore the actual temperature
that the FW supplies.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 57 ++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h     | 10 ++++++
 drivers/net/wireless/iwlwifi/mvm/rx.c      | 19 ++++++++++
 3 files changed, 86 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 7d18f46..f7e4488 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -257,6 +257,60 @@ static ssize_t iwl_dbgfs_sram_write(struct iwl_mvm *mvm, char *buf,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_set_nic_temperature_read(struct file *file,
+						  char __user *user_buf,
+						  size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	char buf[16];
+	int pos;
+
+	if (!mvm->temperature_test)
+		pos = scnprintf(buf , sizeof(buf), "disabled\n");
+	else
+		pos = scnprintf(buf , sizeof(buf), "%d\n", mvm->temperature);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
+/*
+ * Set NIC Temperature
+ * Cause the driver to ignore the actual NIC temperature reported by the FW
+ * Enable: any value between IWL_MVM_DEBUG_SET_TEMPERATURE_MIN -
+ * IWL_MVM_DEBUG_SET_TEMPERATURE_MAX
+ * Disable: IWL_MVM_DEBUG_SET_TEMPERATURE_DISABLE
+ */
+static ssize_t iwl_dbgfs_set_nic_temperature_write(struct iwl_mvm *mvm,
+						   char *buf, size_t count,
+						   loff_t *ppos)
+{
+	int temperature;
+
+	if (kstrtoint(buf, 10, &temperature))
+		return -EINVAL;
+	/* not a legal temperature */
+	if ((temperature > IWL_MVM_DEBUG_SET_TEMPERATURE_MAX &&
+	     temperature != IWL_MVM_DEBUG_SET_TEMPERATURE_DISABLE) ||
+	    temperature < IWL_MVM_DEBUG_SET_TEMPERATURE_MIN)
+		return -EINVAL;
+
+	mutex_lock(&mvm->mutex);
+	if (temperature == IWL_MVM_DEBUG_SET_TEMPERATURE_DISABLE) {
+		mvm->temperature_test = false;
+	} else {
+		mvm->temperature_test = true;
+		mvm->temperature = temperature;
+	}
+	IWL_DEBUG_TEMP(mvm, "%sabling debug set temperature (temp = %d)\n",
+		       mvm->temperature_test ? "En" : "Dis" ,
+		       mvm->temperature);
+	/* handle the temperature change */
+	iwl_mvm_tt_handler(mvm);
+	mutex_unlock(&mvm->mutex);
+
+	return count;
+}
+
 static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 				       size_t count, loff_t *ppos)
 {
@@ -1296,6 +1350,7 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(prph_reg, 64);
 MVM_DEBUGFS_WRITE_FILE_OPS(tx_flush, 16);
 MVM_DEBUGFS_WRITE_FILE_OPS(sta_drain, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(sram, 64);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(set_nic_temperature, 64);
 MVM_DEBUGFS_READ_FILE_OPS(stations);
 MVM_DEBUGFS_READ_FILE_OPS(bt_notif);
 MVM_DEBUGFS_READ_FILE_OPS(bt_cmd);
@@ -1336,6 +1391,8 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(tx_flush, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(sta_drain, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(sram, mvm->debugfs_dir, S_IWUSR | S_IRUSR);
+	MVM_DEBUGFS_ADD_FILE(set_nic_temperature, mvm->debugfs_dir,
+			     S_IWUSR | S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(stations, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_error_dump, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(bt_notif, dbgfs_dir, S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 2e73d3b..802d29e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -512,6 +512,10 @@ enum {
 	D0I3_PENDING_WAKEUP,
 };
 
+#define IWL_MVM_DEBUG_SET_TEMPERATURE_DISABLE 0xff
+#define IWL_MVM_DEBUG_SET_TEMPERATURE_MIN -100
+#define IWL_MVM_DEBUG_SET_TEMPERATURE_MAX 200
+
 struct iwl_mvm {
 	/* for logger access */
 	struct device *dev;
@@ -694,6 +698,12 @@ struct iwl_mvm {
 	/* Thermal Throttling and CTkill */
 	struct iwl_mvm_tt_mgmt thermal_throttle;
 	s32 temperature;	/* Celsius */
+	/*
+	 * Debug option to set the NIC temperature. This option makes the
+	 * driver think this is the actual NIC temperature, and ignore the
+	 * real temperature that is received from the fw
+	 */
+	bool temperature_test;  /* Debug test temperature is enabled */
 
 #ifdef CONFIG_NL80211_TESTMODE
 	u32 noa_duration;
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 4b98987..8f43aff 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -491,10 +491,29 @@ int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
 		.mvm = mvm,
 	};
 
+	/*
+	 * set temperature debug enabled - ignore FW temperature updates
+	 * and use the user set temperature.
+	 */
+	if (mvm->temperature_test) {
+		if (mvm->temperature < le32_to_cpu(common->temperature))
+			IWL_DEBUG_TEMP(mvm,
+				       "Ignoring FW temperature update that is greater than the debug set temperature (debug temp = %d, fw temp = %d)\n",
+				       mvm->temperature,
+				       le32_to_cpu(common->temperature));
+		/*
+		 * skip iwl_mvm_tt_handler since we are in
+		 * temperature debug mode and we are ignoring
+		 * the new temperature value
+		 */
+		goto update;
+	}
+
 	if (mvm->temperature != le32_to_cpu(common->temperature)) {
 		mvm->temperature = le32_to_cpu(common->temperature);
 		iwl_mvm_tt_handler(mvm);
 	}
+update:
 	iwl_mvm_update_rx_statistics(mvm, stats);
 
 	ieee80211_iterate_active_interfaces(mvm->hw,
-- 
1.9.1

