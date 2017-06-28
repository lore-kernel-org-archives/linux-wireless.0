Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35748 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751515AbdF1UNt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:13:49 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:00 +0300
Message-Id: <20170628201330.9432-2-luca@coelho.fi> (sfid-20170628_221355_214579_68B4F516)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 01/31] iwlwifi: mvm: refactor geo init
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

We are going to add debugfs entry to retrieve the current geographic
profile being used in the FW. Currently the driver reads those tables
from the BIOS and passes them to the FW.
To prepare for this retrieving we want to store those
tables in the driver.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/fw-api-power.h  |  9 +++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 64 ++++++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       | 12 +++-
 3 files changed, 67 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h
index 9d87fddd29b6..7da57ef2454e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h
@@ -363,6 +363,7 @@ struct iwl_dev_tx_power_cmd {
 } __packed; /* TX_REDUCED_POWER_API_S_VER_4 */
 
 #define IWL_NUM_GEO_PROFILES	3
+#define IWL_GEO_PER_CHAIN_SIZE	3
 
 /**
  * enum iwl_geo_per_chain_offset_operation - type of operation
@@ -402,6 +403,14 @@ struct iwl_geo_tx_power_profiles_cmd {
 } __packed; /* GEO_TX_POWER_LIMIT */
 
 /**
+ * struct iwl_geo_tx_power_profiles_resp -  response to GEO_TX_POWER_LIMIT cmd
+ * @profile_idx: current geo profile in use
+ */
+struct iwl_geo_tx_power_profiles_resp {
+	__le32 profile_idx;
+} __packed; /* GEO_TX_POWER_LIMIT_RESP */
+
+/**
  * struct iwl_beacon_filter_cmd
  * REPLY_BEACON_FILTERING_CMD = 0xd2 (command)
  * @bf_energy_delta: Used for RSSI filtering, if in 'normal' state. Send beacon
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 24cc406d87ef..273e19460016 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1243,15 +1243,15 @@ static int iwl_mvm_sar_get_ewrd_table(struct iwl_mvm *mvm)
 	return ret;
 }
 
-static int iwl_mvm_sar_get_wgds_table(struct iwl_mvm *mvm,
-				      struct iwl_mvm_geo_table *geo_table)
+static int iwl_mvm_sar_get_wgds_table(struct iwl_mvm *mvm)
 {
 	union acpi_object *wifi_pkg;
 	acpi_handle root_handle;
 	acpi_handle handle;
 	struct acpi_buffer wgds = {ACPI_ALLOCATE_BUFFER, NULL};
 	acpi_status status;
-	int i, ret;
+	int i, j, ret;
+	int idx = 1;
 
 	root_handle = ACPI_HANDLE(mvm->dev);
 	if (!root_handle) {
@@ -1282,15 +1282,17 @@ static int iwl_mvm_sar_get_wgds_table(struct iwl_mvm *mvm,
 		goto out_free;
 	}
 
-	for (i = 0; i < ACPI_WGDS_WIFI_DATA_SIZE; i++) {
-		union acpi_object *entry;
+	for (i = 0; i < IWL_NUM_GEO_PROFILES; i++) {
+		for (j = 0; j < IWL_MVM_GEO_TABLE_SIZE; j++) {
+			union acpi_object *entry;
 
-		entry = &wifi_pkg->package.elements[i + 1];
-		if ((entry->type != ACPI_TYPE_INTEGER) ||
-		    (entry->integer.value > U8_MAX))
-			return -EINVAL;
+			entry = &wifi_pkg->package.elements[idx++];
+			if ((entry->type != ACPI_TYPE_INTEGER) ||
+			    (entry->integer.value > U8_MAX))
+				return -EINVAL;
 
-		geo_table->values[i] = entry->integer.value;
+			mvm->geo_profiles[i].values[j] = entry->integer.value;
+		}
 	}
 	ret = 0;
 out_free:
@@ -1351,16 +1353,47 @@ int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
 	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0, len, &cmd);
 }
 
+int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
+{
+	struct iwl_geo_tx_power_profiles_resp *resp;
+	int ret;
+
+	struct iwl_geo_tx_power_profiles_cmd geo_cmd = {
+		.ops = cpu_to_le32(IWL_PER_CHAIN_OFFSET_GET_CURRENT_TABLE),
+	};
+	struct iwl_host_cmd cmd = {
+		.id =  WIDE_ID(PHY_OPS_GROUP, GEO_TX_POWER_LIMIT),
+		.len = { sizeof(geo_cmd), },
+		.flags = CMD_WANT_SKB,
+		.data = { &geo_cmd },
+	};
+
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+	if (ret) {
+		IWL_ERR(mvm, "Failed to get geographic profile info %d\n", ret);
+		return ret;
+	}
+
+	resp = (void *)cmd.resp_pkt->data;
+	ret = le32_to_cpu(resp->profile_idx);
+	if (WARN_ON(ret > IWL_NUM_GEO_PROFILES)) {
+		ret = -EIO;
+		IWL_WARN(mvm, "Invalid geographic profile idx (%d)\n", ret);
+	}
+
+	iwl_free_resp(&cmd);
+	return ret;
+}
+
 static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
 {
-	struct iwl_mvm_geo_table geo_table;
 	struct iwl_geo_tx_power_profiles_cmd cmd = {
 		.ops = cpu_to_le32(IWL_PER_CHAIN_OFFSET_SET_TABLES),
 	};
-	int ret, i, j, idx;
+	int ret, i, j;
 	u16 cmd_wide_id =  WIDE_ID(PHY_OPS_GROUP, GEO_TX_POWER_LIMIT);
 
-	ret = iwl_mvm_sar_get_wgds_table(mvm, &geo_table);
+	ret = iwl_mvm_sar_get_wgds_table(mvm);
 	if (ret < 0) {
 		IWL_DEBUG_RADIO(mvm,
 				"Geo SAR BIOS table invalid or unavailable. (%d)\n",
@@ -1381,9 +1414,8 @@ static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
 		for (j = 0; j < ACPI_WGDS_NUM_BANDS; j++) {
 			u8 *value;
 
-			idx = i * ACPI_WGDS_NUM_BANDS * ACPI_WGDS_TABLE_SIZE +
-				j * ACPI_WGDS_TABLE_SIZE;
-			value = &geo_table.values[idx];
+			value = &mvm->geo_profiles[i].values[j *
+				IWL_GEO_PER_CHAIN_SIZE];
 			chain[j].max_tx_power = cpu_to_le16(value[0]);
 			chain[j].chain_a = value[1];
 			chain[j].chain_b = value[2];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 3b1f15873034..9b777b847e22 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -724,14 +724,14 @@ enum iwl_mvm_queue_status {
 #ifdef CONFIG_ACPI
 #define IWL_MVM_SAR_TABLE_SIZE		10
 #define IWL_MVM_SAR_PROFILE_NUM		4
-#define IWL_MVM_GEO_TABLE_SIZE		18
+#define IWL_MVM_GEO_TABLE_SIZE		6
 
 struct iwl_mvm_sar_profile {
 	bool enabled;
 	u8 table[IWL_MVM_SAR_TABLE_SIZE];
 };
 
-struct iwl_mvm_geo_table {
+struct iwl_mvm_geo_profile {
 	u8 values[IWL_MVM_GEO_TABLE_SIZE];
 };
 #endif
@@ -1071,6 +1071,7 @@ struct iwl_mvm {
 	struct delayed_work cs_tx_unblock_dwork;
 #ifdef CONFIG_ACPI
 	struct iwl_mvm_sar_profile sar_profiles[IWL_MVM_SAR_PROFILE_NUM];
+	struct iwl_mvm_geo_profile geo_profiles[IWL_NUM_GEO_PROFILES];
 #endif
 };
 
@@ -1889,12 +1890,19 @@ bool iwl_mvm_lqm_active(struct iwl_mvm *mvm);
 
 #ifdef CONFIG_ACPI
 int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b);
+int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm);
 #else
 static inline
 int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
 {
 	return -ENOENT;
 }
+
+static inline
+int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
+{
+	return -ENOENT;
+}
 #endif /* CONFIG_ACPI */
 
 #endif /* __IWL_MVM_H__ */
-- 
2.11.0
