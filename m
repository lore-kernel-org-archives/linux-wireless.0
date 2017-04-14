Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51710 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753571AbdDNJCk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 05:02:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 14 Apr 2017 12:01:51 +0300
Message-Id: <20170414090210.31397-8-luca@coelho.fi> (sfid-20170414_110253_999108_98597531)
In-Reply-To: <20170414090210.31397-1-luca@coelho.fi>
References: <20170414090210.31397-1-luca@coelho.fi>
Subject: [PATCH v2 07/26] iwlwifi: mvm: refactor SAR init to prepare for dynamic SAR
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

We are adding support for dynamic TX power tables for SAR (specific
absorption rate) compliance.  Currently, we only support a single
(static) TX power table, which is read from ACPI, and use it
statically.

To prepare for more tables that can be switched dynamically, refactor
the SAR init flow to allow reusage and add the current static table as
a single entry in an array of tables.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 155 ++++++++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h |  17 ++-
 2 files changed, 107 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 4c5088643b2b..1679104e19e9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -990,85 +990,87 @@ static int iwl_mvm_config_ltr(struct iwl_mvm *mvm)
 				    sizeof(cmd), &cmd);
 }
 
-#define ACPI_WRDS_METHOD	"WRDS"
-#define ACPI_WRDS_WIFI		(0x07)
-#define ACPI_WRDS_TABLE_SIZE	10
+#ifdef CONFIG_ACPI
+#define ACPI_WRDS_METHOD		"WRDS"
+#define ACPI_WRDS_WIFI			(0x07)
+#define ACPI_WRDS_WIFI_DATA_SIZE	(IWL_MVM_SAR_TABLE_SIZE + 2)
+
+static int iwl_mvm_sar_set_profile(struct iwl_mvm *mvm,
+				   union acpi_object *table,
+				   struct iwl_mvm_sar_profile *profile,
+				   bool enabled)
+{
+	int i;
 
-struct iwl_mvm_sar_table {
-	bool enabled;
-	u8 values[ACPI_WRDS_TABLE_SIZE];
-};
+	profile->enabled = enabled;
 
-#ifdef CONFIG_ACPI
-static int iwl_mvm_sar_get_wrds(struct iwl_mvm *mvm, union acpi_object *wrds,
-				struct iwl_mvm_sar_table *sar_table)
+	for (i = 0; i < IWL_MVM_SAR_TABLE_SIZE; i++) {
+		if ((table[i].type != ACPI_TYPE_INTEGER) ||
+		    (table[i].integer.value > U8_MAX))
+			return -EINVAL;
+
+		profile->table[i] = table[i].integer.value;
+	}
+
+	return 0;
+}
+
+static union acpi_object *iwl_mvm_sar_find_wifi_pkg(struct iwl_mvm *mvm,
+						    union acpi_object *data,
+						    int data_size)
 {
-	union acpi_object *data_pkg;
-	u32 i;
+	int i;
+	union acpi_object *wifi_pkg;
 
-	/* We need at least two packages, one for the revision and one
+	/*
+	 * We need at least two packages, one for the revision and one
 	 * for the data itself.  Also check that the revision is valid
 	 * (i.e. it is an integer set to 0).
-	*/
-	if (wrds->type != ACPI_TYPE_PACKAGE ||
-	    wrds->package.count < 2 ||
-	    wrds->package.elements[0].type != ACPI_TYPE_INTEGER ||
-	    wrds->package.elements[0].integer.value != 0) {
-		IWL_DEBUG_RADIO(mvm, "Unsupported wrds structure\n");
-		return -EINVAL;
+	 */
+	if (data->type != ACPI_TYPE_PACKAGE ||
+	    data->package.count < 2 ||
+	    data->package.elements[0].type != ACPI_TYPE_INTEGER ||
+	    data->package.elements[0].integer.value != 0) {
+		IWL_DEBUG_RADIO(mvm, "Unsupported packages structure\n");
+		return ERR_PTR(-EINVAL);
 	}
 
 	/* loop through all the packages to find the one for WiFi */
-	for (i = 1; i < wrds->package.count; i++) {
+	for (i = 1; i < data->package.count; i++) {
 		union acpi_object *domain;
 
-		data_pkg = &wrds->package.elements[i];
+		wifi_pkg = &data->package.elements[i];
 
 		/* Skip anything that is not a package with the right
 		 * amount of elements (i.e. domain_type,
-		 * enabled/disabled plus the sar table size.
+		 * enabled/disabled plus the actual data size.
 		 */
-		if (data_pkg->type != ACPI_TYPE_PACKAGE ||
-		    data_pkg->package.count != ACPI_WRDS_TABLE_SIZE + 2)
+		if (wifi_pkg->type != ACPI_TYPE_PACKAGE ||
+		    wifi_pkg->package.count != data_size)
 			continue;
 
-		domain = &data_pkg->package.elements[0];
+		domain = &wifi_pkg->package.elements[0];
 		if (domain->type == ACPI_TYPE_INTEGER &&
 		    domain->integer.value == ACPI_WRDS_WIFI)
 			break;
 
-		data_pkg = NULL;
+		wifi_pkg = NULL;
 	}
 
-	if (!data_pkg)
-		return -ENOENT;
-
-	if (data_pkg->package.elements[1].type != ACPI_TYPE_INTEGER)
-		return -EINVAL;
-
-	sar_table->enabled = !!(data_pkg->package.elements[1].integer.value);
-
-	for (i = 0; i < ACPI_WRDS_TABLE_SIZE; i++) {
-		union acpi_object *entry;
-
-		entry = &data_pkg->package.elements[i + 2];
-		if ((entry->type != ACPI_TYPE_INTEGER) ||
-		    (entry->integer.value > U8_MAX))
-			return -EINVAL;
-
-		sar_table->values[i] = entry->integer.value;
-	}
+	if (!wifi_pkg)
+		return ERR_PTR(-ENOENT);
 
-	return 0;
+	return wifi_pkg;
 }
 
-static int iwl_mvm_sar_get_table(struct iwl_mvm *mvm,
-				 struct iwl_mvm_sar_table *sar_table)
+static int iwl_mvm_sar_get_wrds_table(struct iwl_mvm *mvm)
 {
+	union acpi_object *wifi_pkg, *table;
 	acpi_handle root_handle;
 	acpi_handle handle;
 	struct acpi_buffer wrds = {ACPI_ALLOCATE_BUFFER, NULL};
 	acpi_status status;
+	bool enabled;
 	int ret;
 
 	root_handle = ACPI_HANDLE(mvm->dev);
@@ -1093,22 +1095,36 @@ static int iwl_mvm_sar_get_table(struct iwl_mvm *mvm,
 		return -ENOENT;
 	}
 
-	ret = iwl_mvm_sar_get_wrds(mvm, wrds.pointer, sar_table);
-	kfree(wrds.pointer);
+	wifi_pkg = iwl_mvm_sar_find_wifi_pkg(mvm, wrds.pointer,
+					     ACPI_WRDS_WIFI_DATA_SIZE);
+	if (IS_ERR(wifi_pkg)) {
+		ret = PTR_ERR(wifi_pkg);
+		goto out_free;
+	}
+
+	if (wifi_pkg->package.elements[1].type != ACPI_TYPE_INTEGER) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	enabled = !!(wifi_pkg->package.elements[1].integer.value);
 
+	/* position of the actual table */
+	table = &wifi_pkg->package.elements[2];
+
+	/* The profile from WRDS is officially profile 1, but goes
+	 * into sar_profiles[0] (because we don't have a profile 0).
+	 */
+	ret = iwl_mvm_sar_set_profile(mvm, table, &mvm->sar_profiles[0],
+				      enabled);
+
+out_free:
+	kfree(wrds.pointer);
 	return ret;
 }
-#else /* CONFIG_ACPI */
-static int iwl_mvm_sar_get_table(struct iwl_mvm *mvm,
-				 struct iwl_mvm_sar_table *sar_table)
-{
-	return -ENOENT;
-}
-#endif /* CONFIG_ACPI */
 
 static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 {
-	struct iwl_mvm_sar_table sar_table;
 	struct iwl_dev_tx_power_cmd cmd = {
 		.v3.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_CHAINS),
 	};
@@ -1118,7 +1134,7 @@ static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TX_POWER_ACK))
 		len = sizeof(cmd.v3);
 
-	ret = iwl_mvm_sar_get_table(mvm, &sar_table);
+	ret = iwl_mvm_sar_get_wrds_table(mvm);
 	if (ret < 0) {
 		IWL_DEBUG_RADIO(mvm,
 				"SAR BIOS table invalid or unavailable. (%d)\n",
@@ -1127,22 +1143,23 @@ static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 		return 0;
 	}
 
-	if (!sar_table.enabled)
+	/* if profile 0 is disabled, there's nothing else to do here */
+	if (!mvm->sar_profiles[0].enabled)
 		return 0;
 
 	IWL_DEBUG_RADIO(mvm, "Sending REDUCE_TX_POWER_CMD per chain\n");
 
 	BUILD_BUG_ON(IWL_NUM_CHAIN_LIMITS * IWL_NUM_SUB_BANDS !=
-		     ACPI_WRDS_TABLE_SIZE);
+		     IWL_MVM_SAR_TABLE_SIZE);
 
 	for (i = 0; i < IWL_NUM_CHAIN_LIMITS; i++) {
 		IWL_DEBUG_RADIO(mvm, "  Chain[%d]:\n", i);
 		for (j = 0; j < IWL_NUM_SUB_BANDS; j++) {
 			idx = (i * IWL_NUM_SUB_BANDS) + j;
 			cmd.v3.per_chain_restriction[i][j] =
-				cpu_to_le16(sar_table.values[idx]);
+				cpu_to_le16(mvm->sar_profiles[0].table[idx]);
 			IWL_DEBUG_RADIO(mvm, "    Band[%d] = %d * .125dBm\n",
-					j, sar_table.values[idx]);
+					j, mvm->sar_profiles[0].table[idx]);
 		}
 	}
 
@@ -1153,6 +1170,18 @@ static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 	return ret;
 }
 
+#else /* CONFIG_ACPI */
+static inline int iwl_mvm_sar_get_wrds_table(struct iwl_mvm *mvm)
+{
+	return -ENOENT;
+}
+
+static inline int iwl_mvm_sar_init(struct iwl_mvm *mvm)
+{
+	return 0;
+}
+#endif /* CONFIG_ACPI */
+
 static int iwl_mvm_load_rt_fw(struct iwl_mvm *mvm)
 {
 	int ret;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 91bd5ebd5b65..0c35d9ebd4ac 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,7 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -710,6 +710,16 @@ enum iwl_mvm_queue_status {
 #define IWL_MVM_DQA_QUEUE_TIMEOUT	(5 * HZ)
 #define IWL_MVM_NUM_CIPHERS             10
 
+#ifdef CONFIG_ACPI
+#define IWL_MVM_SAR_TABLE_SIZE		10
+#define IWL_MVM_SAR_PROFILE_NUM		1
+
+struct iwl_mvm_sar_profile {
+	bool enabled;
+	u8 table[IWL_MVM_SAR_TABLE_SIZE];
+};
+#endif
+
 struct iwl_mvm {
 	/* for logger access */
 	struct device *dev;
@@ -1039,6 +1049,9 @@ struct iwl_mvm {
 	bool drop_bcn_ap_mode;
 
 	struct delayed_work cs_tx_unblock_dwork;
+#ifdef CONFIG_ACPI
+	struct iwl_mvm_sar_profile sar_profiles[IWL_MVM_SAR_PROFILE_NUM];
+#endif
 };
 
 /* Extract MVM priv from op_mode and _hw */
-- 
2.11.0
