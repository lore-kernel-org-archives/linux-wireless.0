Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51312 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754653AbdDMPZ3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 11:25:29 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 13 Apr 2017 18:24:50 +0300
Message-Id: <20170413152507.9648-10-luca@coelho.fi> (sfid-20170413_172535_814618_83CC34E8)
In-Reply-To: <20170413152507.9648-1-luca@coelho.fi>
References: <20170413152507.9648-1-luca@coelho.fi>
Subject: [PATCH 09/26] iwlwifi: mvm: add support for EWRD (Dynamic SAR) ACPI table
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
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 91 ++++++++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h |  2 +-
 2 files changed, 88 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index df9a721c58c2..50786e90a932 100644
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
@@ -1120,11 +1123,84 @@ static int iwl_mvm_sar_get_wrds_table(struct iwl_mvm *mvm)
 	kfree(wrds.pointer);
 	return ret;
 }
+
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
 #else /* CONFIG_ACPI */
 static int iwl_mvm_sar_get_wrds_table(struct iwl_mvm *mvm)
 {
 	return -ENOENT;
 }
+
+static int iwl_mvm_sar_get_ewrd_table(struct iwl_mvm *mvm)
+{
+	return -ENOENT;
+}
 #endif /* CONFIG_ACPI */
 
 static int
@@ -1182,12 +1258,19 @@ static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
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
 	/* choose profile 0 as default for both chains */
 	ret = iwl_mvm_sar_select_profile(mvm, 0, 0);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 0c35d9ebd4ac..a5bdc969717d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -712,7 +712,7 @@ enum iwl_mvm_queue_status {
 
 #ifdef CONFIG_ACPI
 #define IWL_MVM_SAR_TABLE_SIZE		10
-#define IWL_MVM_SAR_PROFILE_NUM		1
+#define IWL_MVM_SAR_PROFILE_NUM		4
 
 struct iwl_mvm_sar_profile {
 	bool enabled;
-- 
2.11.0
