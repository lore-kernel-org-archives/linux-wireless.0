Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51718 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753218AbdDNJCl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 05:02:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 14 Apr 2017 12:01:53 +0300
Message-Id: <20170414090210.31397-10-luca@coelho.fi> (sfid-20170414_110254_842035_142B5FD1)
In-Reply-To: <20170414090210.31397-1-luca@coelho.fi>
References: <20170414090210.31397-1-luca@coelho.fi>
Subject: [PATCH v2 09/26] iwlwifi: mvm: add support for EWRD (Dynamic SAR) ACPI table
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Dynamic SAR allows changing TX power limits at runtime to comply with
SAR regulations on multiple form factors (e.g. tablet vs. clamshell
mode).  To support this, a new table was added to ACPI, which is
called Extended Wireless Regulatory Descriptor (EWRD).  This table
allows OEMs to define different TX power profiles for each form-factor
or usage mode.

Read this new table and store it in our SAR profiles table, in
preparation for Dynamic SAR support.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 114 +++++++++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h |  11 ++-
 2 files changed, 108 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 6360361c576d..2a4c952ef01a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -992,8 +992,11 @@ static int iwl_mvm_config_ltr(struct iwl_mvm *mvm)
 
 #ifdef CONFIG_ACPI
 #define ACPI_WRDS_METHOD		"WRDS"
-#define ACPI_WRDS_WIFI			(0x07)
+#define ACPI_EWRD_METHOD		"EWRD"
+#define ACPI_WIFI_DOMAIN		(0x07)
 #define ACPI_WRDS_WIFI_DATA_SIZE	(IWL_MVM_SAR_TABLE_SIZE + 2)
+#define ACPI_EWRD_WIFI_DATA_SIZE	((IWL_MVM_SAR_PROFILE_NUM - 1) * \
+					 IWL_MVM_SAR_TABLE_SIZE + 3)
 
 static int iwl_mvm_sar_set_profile(struct iwl_mvm *mvm,
 				   union acpi_object *table,
@@ -1051,7 +1054,7 @@ static union acpi_object *iwl_mvm_sar_find_wifi_pkg(struct iwl_mvm *mvm,
 
 		domain = &wifi_pkg->package.elements[0];
 		if (domain->type == ACPI_TYPE_INTEGER &&
-		    domain->integer.value == ACPI_WRDS_WIFI)
+		    domain->integer.value == ACPI_WIFI_DOMAIN)
 			break;
 
 		wifi_pkg = NULL;
@@ -1123,6 +1126,78 @@ static int iwl_mvm_sar_get_wrds_table(struct iwl_mvm *mvm)
 	return ret;
 }
 
+static int iwl_mvm_sar_get_ewrd_table(struct iwl_mvm *mvm)
+{
+	union acpi_object *wifi_pkg;
+	acpi_handle root_handle;
+	acpi_handle handle;
+	struct acpi_buffer ewrd = {ACPI_ALLOCATE_BUFFER, NULL};
+	acpi_status status;
+	bool enabled;
+	int i, n_profiles, ret;
+
+	root_handle = ACPI_HANDLE(mvm->dev);
+	if (!root_handle) {
+		IWL_DEBUG_RADIO(mvm,
+				"Could not retrieve root port ACPI handle\n");
+		return -ENOENT;
+	}
+
+	/* Get the method's handle */
+	status = acpi_get_handle(root_handle, (acpi_string)ACPI_EWRD_METHOD,
+				 &handle);
+	if (ACPI_FAILURE(status)) {
+		IWL_DEBUG_RADIO(mvm, "EWRD method not found\n");
+		return -ENOENT;
+	}
+
+	/* Call EWRD with no arguments */
+	status = acpi_evaluate_object(handle, NULL, NULL, &ewrd);
+	if (ACPI_FAILURE(status)) {
+		IWL_DEBUG_RADIO(mvm, "EWRD invocation failed (0x%x)\n", status);
+		return -ENOENT;
+	}
+
+	wifi_pkg = iwl_mvm_sar_find_wifi_pkg(mvm, ewrd.pointer,
+					     ACPI_EWRD_WIFI_DATA_SIZE);
+	if (IS_ERR(wifi_pkg)) {
+		ret = PTR_ERR(wifi_pkg);
+		goto out_free;
+	}
+
+	if ((wifi_pkg->package.elements[1].type != ACPI_TYPE_INTEGER) ||
+	    (wifi_pkg->package.elements[2].type != ACPI_TYPE_INTEGER)) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	enabled = !!(wifi_pkg->package.elements[1].integer.value);
+	n_profiles = wifi_pkg->package.elements[2].integer.value;
+
+	for (i = 0; i < n_profiles; i++) {
+		/* the tables start at element 3 */
+		static int pos = 3;
+
+		/* The EWRD profiles officially go from 2 to 4, but we
+		 * save them in sar_profiles[1-3] (because we don't
+		 * have profile 0).  So in the array we start from 1.
+		 */
+		ret = iwl_mvm_sar_set_profile(mvm,
+					      &wifi_pkg->package.elements[pos],
+					      &mvm->sar_profiles[i + 1],
+					      enabled);
+		if (ret < 0)
+			break;
+
+		/* go to the next table */
+		pos += IWL_MVM_SAR_TABLE_SIZE;
+	}
+
+out_free:
+	kfree(ewrd.pointer);
+	return ret;
+}
+
 int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
 {
 	struct iwl_dev_tx_power_cmd cmd = {
@@ -1176,6 +1251,18 @@ int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
 	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0, len, &cmd);
 }
 
+#else /* CONFIG_ACPI */
+static int iwl_mvm_sar_get_wrds_table(struct iwl_mvm *mvm)
+{
+	return -ENOENT;
+}
+
+static int iwl_mvm_sar_get_ewrd_table(struct iwl_mvm *mvm)
+{
+	return -ENOENT;
+}
+#endif /* CONFIG_ACPI */
+
 static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 {
 	int ret;
@@ -1183,12 +1270,19 @@ static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 	ret = iwl_mvm_sar_get_wrds_table(mvm);
 	if (ret < 0) {
 		IWL_DEBUG_RADIO(mvm,
-				"SAR BIOS table invalid or unavailable. (%d)\n",
+				"WRDS SAR BIOS table invalid or unavailable. (%d)\n",
 				ret);
-		/* we don't fail if the table is not available */
+		/* if not available, don't fail and don't bother with EWRD */
 		return 0;
 	}
 
+	ret = iwl_mvm_sar_get_ewrd_table(mvm);
+	/* if EWRD is not available, we can still use WRDS, so don't fail */
+	if (ret < 0)
+		IWL_DEBUG_RADIO(mvm,
+				"EWRD SAR BIOS table invalid or unavailable. (%d)\n",
+				ret);
+
 	/* choose profile 1 (WRDS) as default for both chains */
 	ret = iwl_mvm_sar_select_profile(mvm, 1, 1);
 
@@ -1199,18 +1293,6 @@ static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 	return ret;
 }
 
-#else /* CONFIG_ACPI */
-static inline int iwl_mvm_sar_get_wrds_table(struct iwl_mvm *mvm)
-{
-	return -ENOENT;
-}
-
-static inline int iwl_mvm_sar_init(struct iwl_mvm *mvm)
-{
-	return 0;
-}
-#endif /* CONFIG_ACPI */
-
 static int iwl_mvm_load_rt_fw(struct iwl_mvm *mvm)
 {
 	int ret;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index f4e8fa3765fa..2205c9f8bb58 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -712,7 +712,7 @@ enum iwl_mvm_queue_status {
 
 #ifdef CONFIG_ACPI
 #define IWL_MVM_SAR_TABLE_SIZE		10
-#define IWL_MVM_SAR_PROFILE_NUM		1
+#define IWL_MVM_SAR_PROFILE_NUM		4
 
 struct iwl_mvm_sar_profile {
 	bool enabled;
@@ -1818,6 +1818,15 @@ int iwl_mvm_send_lqm_cmd(struct ieee80211_vif *vif,
 			 enum iwl_lqm_cmd_operatrions operation,
 			 u32 duration, u32 timeout);
 bool iwl_mvm_lqm_active(struct iwl_mvm *mvm);
+
+#ifdef CONFIG_ACPI
 int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b);
+#else
+static inline
+int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
+{
+	return -ENOENT;
+}
+#endif /* CONFIG_ACPI */
 
 #endif /* __IWL_MVM_H__ */
-- 
2.11.0
