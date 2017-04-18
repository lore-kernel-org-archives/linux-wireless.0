Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52840 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754250AbdDRWVr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:21:47 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:20 +0300
Message-Id: <20170418221729.28372-17-luca@coelho.fi> (sfid-20170419_002151_023762_5EA167AA)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 16/25] iwlwifi: mvm: add GEO_TX_POWER_LIMIT cmd for geographic tx power table
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

To utilize the maximum allowed tx power, an additional table was added
to the BIOS. The table consists of up to seven different regions
(currently only three are in use). Each region contains per band:
1. Maximum allowed tx power on the band.
2. Tx power offset for chain A.
3. Tx power offset for chain B.
On init flow driver reads this table by means of ACPI and
passes it to the firmware with GEO_TX_POWER_LIMIT cmd.
The firmware will use this table to enhance tx power with
the offset in the relevant table as well as verifying it does not
violate the maximum allowed tx power.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/fw-api-power.h  |  43 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 112 +++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   1 +
 5 files changed, 160 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h
index 3fa43d1348a2..750510aff70b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
- * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,7 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
- * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -351,6 +351,45 @@ struct iwl_dev_tx_power_cmd {
 	u8 reserved[3];
 } __packed; /* TX_REDUCED_POWER_API_S_VER_4 */
 
+#define IWL_NUM_GEO_PROFILES	3
+
+/**
+ * enum iwl_geo_per_chain_offset_operation - type of operation
+ * @IWL_PER_CHAIN_OFFSET_SET_TABLES: send the tables from the host to the FW.
+ * @IWL_PER_CHAIN_OFFSET_GET_CURRENT_TABLE: retrieve the last configured table.
+ */
+enum iwl_geo_per_chain_offset_operation {
+	IWL_PER_CHAIN_OFFSET_SET_TABLES,
+	IWL_PER_CHAIN_OFFSET_GET_CURRENT_TABLE,
+};  /* GEO_TX_POWER_LIMIT FLAGS TYPE */
+
+/**
+ * struct iwl_per_chain_offset - embedded struct for GEO_TX_POWER_LIMIT.
+ * @max_tx_power: maximum allowed tx power.
+ * @chain_a: tx power offset for chain a.
+ * @chain_b: tx power offset for chain b.
+ */
+struct iwl_per_chain_offset {
+	__le16 max_tx_power;
+	u8 chain_a;
+	u8 chain_b;
+} __packed; /* PER_CHAIN_LIMIT_OFFSET_PER_CHAIN_S_VER_1 */
+
+struct iwl_per_chain_offset_group {
+	struct iwl_per_chain_offset lb;
+	struct iwl_per_chain_offset hb;
+} __packed; /* PER_CHAIN_LIMIT_OFFSET_GROUP_S_VER_1 */
+
+/**
+ * struct iwl_geo_tx_power_profile_cmd - struct for GEO_TX_POWER_LIMIT cmd.
+ * @ops: operations, value from &enum iwl_geo_per_chain_offset_operation
+ * @table: offset profile per band.
+ */
+struct iwl_geo_tx_power_profiles_cmd {
+	__le32 ops;
+	struct iwl_per_chain_offset_group table[IWL_NUM_GEO_PROFILES];
+} __packed; /* GEO_TX_POWER_LIMIT */
+
 /**
  * struct iwl_beacon_filter_cmd
  * REPLY_BEACON_FILTERING_CMD = 0xd2 (command)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 56f50d8a7b69..5086dc00346c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -320,6 +320,7 @@ enum iwl_phy_ops_subcmd_ids {
 	CMD_DTS_MEASUREMENT_TRIGGER_WIDE = 0x0,
 	CTDP_CONFIG_CMD = 0x03,
 	TEMP_REPORTING_THRESHOLDS_CMD = 0x04,
+	GEO_TX_POWER_LIMIT = 0x05,
 	CT_KILL_NOTIFICATION = 0xFE,
 	DTS_MEASUREMENT_NOTIF_WIDE = 0xFF,
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index a845233d14a3..bce3cf5fab67 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -998,10 +998,14 @@ static int iwl_mvm_config_ltr(struct iwl_mvm *mvm)
 #ifdef CONFIG_ACPI
 #define ACPI_WRDS_METHOD		"WRDS"
 #define ACPI_EWRD_METHOD		"EWRD"
+#define ACPI_WGDS_METHOD		"WGDS"
 #define ACPI_WIFI_DOMAIN		(0x07)
 #define ACPI_WRDS_WIFI_DATA_SIZE	(IWL_MVM_SAR_TABLE_SIZE + 2)
 #define ACPI_EWRD_WIFI_DATA_SIZE	((IWL_MVM_SAR_PROFILE_NUM - 1) * \
 					 IWL_MVM_SAR_TABLE_SIZE + 3)
+#define ACPI_WGDS_WIFI_DATA_SIZE	18
+#define ACPI_WGDS_NUM_BANDS		2
+#define ACPI_WGDS_TABLE_SIZE		3
 
 static int iwl_mvm_sar_set_profile(struct iwl_mvm *mvm,
 				   union acpi_object *table,
@@ -1203,6 +1207,61 @@ static int iwl_mvm_sar_get_ewrd_table(struct iwl_mvm *mvm)
 	return ret;
 }
 
+static int iwl_mvm_sar_get_wgds_table(struct iwl_mvm *mvm,
+				      struct iwl_mvm_geo_table *geo_table)
+{
+	union acpi_object *wifi_pkg;
+	acpi_handle root_handle;
+	acpi_handle handle;
+	struct acpi_buffer wgds = {ACPI_ALLOCATE_BUFFER, NULL};
+	acpi_status status;
+	int i, ret;
+
+	root_handle = ACPI_HANDLE(mvm->dev);
+	if (!root_handle) {
+		IWL_DEBUG_RADIO(mvm,
+				"Could not retrieve root port ACPI handle\n");
+		return -ENOENT;
+	}
+
+	/* Get the method's handle */
+	status = acpi_get_handle(root_handle, (acpi_string)ACPI_WGDS_METHOD,
+				 &handle);
+	if (ACPI_FAILURE(status)) {
+		IWL_DEBUG_RADIO(mvm, "WGDS method not found\n");
+		return -ENOENT;
+	}
+
+	/* Call WGDS with no arguments */
+	status = acpi_evaluate_object(handle, NULL, NULL, &wgds);
+	if (ACPI_FAILURE(status)) {
+		IWL_DEBUG_RADIO(mvm, "WGDS invocation failed (0x%x)\n", status);
+		return -ENOENT;
+	}
+
+	wifi_pkg = iwl_mvm_sar_find_wifi_pkg(mvm, wgds.pointer,
+					     ACPI_WGDS_WIFI_DATA_SIZE);
+	if (IS_ERR(wifi_pkg)) {
+		ret = PTR_ERR(wifi_pkg);
+		goto out_free;
+	}
+
+	for (i = 0; i < ACPI_WGDS_WIFI_DATA_SIZE; i++) {
+		union acpi_object *entry;
+
+		entry = &wifi_pkg->package.elements[i + 1];
+		if ((entry->type != ACPI_TYPE_INTEGER) ||
+		    (entry->integer.value > U8_MAX))
+			return -EINVAL;
+
+		geo_table->values[i] = entry->integer.value;
+	}
+	ret = 0;
+out_free:
+	kfree(wgds.pointer);
+	return ret;
+}
+
 int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
 {
 	struct iwl_dev_tx_power_cmd cmd = {
@@ -1256,6 +1315,50 @@ int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
 	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0, len, &cmd);
 }
 
+static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
+{
+	struct iwl_mvm_geo_table geo_table;
+	struct iwl_geo_tx_power_profiles_cmd cmd = {
+		.ops = cpu_to_le32(IWL_PER_CHAIN_OFFSET_SET_TABLES),
+	};
+	int ret, i, j, idx;
+	u16 cmd_wide_id =  WIDE_ID(PHY_OPS_GROUP, GEO_TX_POWER_LIMIT);
+
+	ret = iwl_mvm_sar_get_wgds_table(mvm, &geo_table);
+	if (ret < 0) {
+		IWL_DEBUG_RADIO(mvm,
+				"Geo SAR BIOS table invalid or unavailable. (%d)\n",
+				ret);
+		/* we don't fail if the table is not available */
+		return 0;
+	}
+
+	IWL_DEBUG_RADIO(mvm, "Sending GEO_TX_POWER_LIMIT\n");
+
+	BUILD_BUG_ON(IWL_NUM_GEO_PROFILES * ACPI_WGDS_NUM_BANDS *
+		     ACPI_WGDS_TABLE_SIZE !=  ACPI_WGDS_WIFI_DATA_SIZE);
+
+	for (i = 0; i < IWL_NUM_GEO_PROFILES; i++) {
+		struct iwl_per_chain_offset *chain =
+			(struct iwl_per_chain_offset *)&cmd.table[i];
+
+		for (j = 0; j < ACPI_WGDS_NUM_BANDS; j++) {
+			u8 *value;
+
+			idx = i * ACPI_WGDS_NUM_BANDS * ACPI_WGDS_TABLE_SIZE +
+				j * ACPI_WGDS_TABLE_SIZE;
+			value = &geo_table.values[idx];
+			chain[j].max_tx_power = cpu_to_le16(value[0]);
+			chain[j].chain_a = value[1];
+			chain[j].chain_b = value[2];
+			IWL_DEBUG_RADIO(mvm,
+					"SAR geographic profile[%d] Band[%d]: chain A = %d chain B = %d max_tx_power = %d\n",
+					i, j, value[1], value[2], value[0]);
+		}
+	}
+	return iwl_mvm_send_cmd_pdu(mvm, cmd_wide_id, 0, sizeof(cmd), &cmd);
+}
+
 #else /* CONFIG_ACPI */
 static int iwl_mvm_sar_get_wrds_table(struct iwl_mvm *mvm)
 {
@@ -1266,6 +1369,11 @@ static int iwl_mvm_sar_get_ewrd_table(struct iwl_mvm *mvm)
 {
 	return -ENOENT;
 }
+
+static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
+{
+	return 0;
+}
 #endif /* CONFIG_ACPI */
 
 static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
@@ -1488,6 +1596,10 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (ret)
 		goto error;
 
+	ret = iwl_mvm_sar_geo_init(mvm);
+	if (ret)
+		goto error;
+
 	IWL_DEBUG_INFO(mvm, "RT uCode started.\n");
 	return 0;
  error:
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 14b8c2eba7fc..1938dfb44152 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -720,11 +720,16 @@ enum iwl_mvm_queue_status {
 #ifdef CONFIG_ACPI
 #define IWL_MVM_SAR_TABLE_SIZE		10
 #define IWL_MVM_SAR_PROFILE_NUM		4
+#define IWL_MVM_GEO_TABLE_SIZE		18
 
 struct iwl_mvm_sar_profile {
 	bool enabled;
 	u8 table[IWL_MVM_SAR_TABLE_SIZE];
 };
+
+struct iwl_mvm_geo_table {
+	u8 values[IWL_MVM_GEO_TABLE_SIZE];
+};
 #endif
 
 struct iwl_mvm {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index d313941ffc9d..488d3c948fe8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -446,6 +446,7 @@ static const struct iwl_hcmd_names iwl_mvm_phy_names[] = {
 	HCMD_NAME(CMD_DTS_MEASUREMENT_TRIGGER_WIDE),
 	HCMD_NAME(CTDP_CONFIG_CMD),
 	HCMD_NAME(TEMP_REPORTING_THRESHOLDS_CMD),
+	HCMD_NAME(GEO_TX_POWER_LIMIT),
 	HCMD_NAME(CT_KILL_NOTIFICATION),
 	HCMD_NAME(DTS_MEASUREMENT_NOTIF_WIDE),
 };
-- 
2.11.0
