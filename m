Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49E952269C
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168604; cv=none; b=u0UWBNRvO5BqTxa2hqS0oK8j8BN3f6rapaOPkaBV7QnSNtyyrVqtqc1eZZnjPmdzckyXCJmEHBxTumEMSHMV0t24eIjZ5CNQhuG0oyQv5JtBRxnysxjKiXz2AI8dYm94TIrM8r8CM6q0PIcd1pdnHSH3ZWEe91XtiXrOf8dOFa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168604; c=relaxed/simple;
	bh=TyLqz47TnlAYud0MdW5GkO4ZX2GQxZqcD/lowzTX1rM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yu7D7+jQtUOHN19X/na1ah9mXsrEDimupNrtTXQCi5F2FOA8g+9eM3NmfluEvNIOoVVJSHsDmLEhVddIsLyIdYxiI6Zy9/+VNTzBazyDJwFFTOfprv7Oud19uRhZ3x0u8PcnoA5UWSe4DrYf36OJnHIKO/12yvizt3ZDFJbRlBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ezWSPcBC; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ezWSPcBC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168597; x=1821704597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TyLqz47TnlAYud0MdW5GkO4ZX2GQxZqcD/lowzTX1rM=;
  b=ezWSPcBCY5C/Ih+8YiWmjwi4mtgF2/hvexVuYTtEWOLpBlFL5c5rLvTv
   MkK/Zb3ja4F1c2EADqIjN2X1NQU4L4F7ObzUZNK8UsslFIGvs3ZZ3uoCj
   mu7lREzK/Ca9Nzi8ZG5PXkZn7ycV4OhMI8Hgwq3j/Wh/UO/NrLgrD+Wdg
   xUcUSx3N/ldG3pyBJy5iCZrMQzKYI23rSx59AqRFYiIrEiKGl1R48F3kl
   1Mm4O9EX48kH1LcQUHxE2lfe8JqNlu41GQfoE+oFhnZYKuABY+5j05fm+
   UjFONufgB9YDYQqPf2YynqJrObwUwFT0aKKcaK44HkNq8AfGiEYviwirF
   Q==;
X-CSE-ConnectionGUID: ptCimPPvSMmhwIrlYQEHfQ==
X-CSE-MsgGUID: UsFIUEEtR3S9HMgLZg3+oQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781351"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781351"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:16 -0700
X-CSE-ConnectionGUID: 56aHkbc/Q0OG3Xhj1rVZOQ==
X-CSE-MsgGUID: b8zlt5ruSDW6+Zyt2UZxjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4697092"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:15 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Shahar Tzarfati <shahar.tzarfati@intel.com>
Subject: [PATCH iwlwifi-next 11/15] wifi: iwlwifi: uefi: add a way to probe connectivity UEFI variables
Date: Wed, 23 Sep 2026 16:04:54 +0300
Message-Id: <20260923160318.6caa9ca17ffe.I877c0d6ab5126edb3e4f1f187ca1e20e563b2ec4@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
References: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

The connectivity UEFI variables are only trusted when the platform
attests they are locked. When the lock status is unknown, the trust of
each variable has to be discovered on its own by checking whether it is
write protected. Probing depends on trying to rewrite UEFI variables and
it is only attempted on non-x86 platforms. If the write is rejected the
variable is considered locked and therefore trusted, otherwise it is
treated as not trusted.

Separate reading such a variable into two steps:
iwl_uefi_get_variable_guid() only fetches and validates the variable,
while iwl_uefi_get_verified_variable_guid() layers the trust decision on
top of it. The latter now takes an iwl_fw_runtime so it can consult the
lock status. Rename its WiFi-GUID wrapper from
iwl_uefi_get_verified_variable() to iwl_uefi_get_verified_wifi_var().

With the trust check now performed by every iwl_uefi_get_*() reached
through the GET_BIOS_TABLE() macro, the per-table lock-status gate in
that macro is redundant, so drop it here.

This move, and the new unknown-status handling, affect only the tables
reached through GET_BIOS_TABLE(), i.e. those that have both a UEFI and
an ACPI source.

Assisted-by: GitHub-Copilot:claude-opus-4-8
Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/init.c  |   4 +-
 .../wireless/intel/iwlwifi/fw/regulatory.c    |   4 +-
 .../wireless/intel/iwlwifi/fw/regulatory.h    |   3 +
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c  | 198 +++++++++++++-----
 5 files changed, 148 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/init.c b/drivers/net/wireless/intel/iwlwifi/fw/init.c
index d1d8058ad29f..d69757b0149d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/init.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/init.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Copyright (C) 2017 Intel Deutschland GmbH
- * Copyright (C) 2019-2021, 2024-2025 Intel Corporation
+ * Copyright (C) 2019-2021, 2024-2026 Intel Corporation
  */
 #include "iwl-drv.h"
 #include "runtime.h"
@@ -31,6 +31,8 @@ void iwl_fw_runtime_init(struct iwl_fw_runtime *fwrt, struct iwl_trans *trans,
 	fwrt->sanitize_ops = sanitize_ops;
 	fwrt->sanitize_ctx = sanitize_ctx;
 	fwrt->ops_ctx = ops_ctx;
+	/* default until the connectivity GUID lock status is resolved */
+	fwrt->uefi_tables_lock_status = UEFI_CNV_GUID_UNKNOWN;
 	for (i = 0; i < IWL_FW_RUNTIME_DUMP_WK_NUM; i++) {
 		fwrt->dump.wks[i].idx = i;
 		INIT_DELAYED_WORK(&fwrt->dump.wks[i].wk, iwl_fw_error_dump_wk);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
index 8dff97b8e0f1..c62f7f53323a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -11,9 +11,7 @@
 
 #define GET_BIOS_TABLE(__name, ...)					\
 do {									\
-	int ret = -ENOENT;						\
-	if (fwrt->uefi_tables_lock_status > UEFI_CNV_GUID_UNLOCKED)	\
-		ret = iwl_uefi_get_ ## __name(__VA_ARGS__);		\
+	int ret = iwl_uefi_get_ ## __name(__VA_ARGS__);			\
 	if (ret < 0)							\
 		ret = iwl_acpi_get_ ## __name(__VA_ARGS__);		\
 	return ret;							\
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
index 08fd11adf905..cd6218e3a740 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
@@ -53,11 +53,14 @@
  * @UEFI_CNV_GUID_UNLOCKED: the tables are unlocked
  * @UEFI_CNV_GUID_LOCKED: the tables are locked
  * @UEFI_CNV_GUID_TEST_MODE: the tables are locked in test mode
+ * @UEFI_CNV_GUID_UNKNOWN: the lock status could not be determined.
+ *	This value is a driver internal, not a possible BIOS reported one
  */
 enum iwl_uefi_cnv_guid_status {
 	UEFI_CNV_GUID_UNLOCKED = 0,
 	UEFI_CNV_GUID_LOCKED = 1,
 	UEFI_CNV_GUID_TEST_MODE = 2,
+	UEFI_CNV_GUID_UNKNOWN = 3,
 };
 
 struct iwl_tas_selection_data {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 12a1cf6b16f1..d0709ab2f593 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -110,7 +110,7 @@ struct iwl_txf_iter_data {
  * @ap_type_cmd_valid: if &ap_type_cmd is valid
  * @uefi_tables_lock_status: the status of the WIFI GUID UEFI variables lock,
  *	see &enum iwl_uefi_cnv_guid_status.
- *	Only read the UEFI variables if locked.
+ *	Trust the UEFI variables if locked or in test mode.
  * @sar_profiles: sar profiles as read from WRDS/EWRD BIOS tables
  * @geo_profiles: geographic profiles as read from WGDS BIOS table
  * @geo_bios_source: see &enum bios_source
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index 7df0e5ea4a1d..871d8f5db9c3 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -31,9 +31,10 @@ struct iwl_uefi_pnvm_mem_desc {
 } __packed;
 
 static void *iwl_uefi_get_variable(efi_char16_t *name, efi_guid_t *guid,
-				   unsigned long *data_size)
+				   u32 *attributes, unsigned long *data_size)
 {
 	efi_status_t status;
+	u32 attr = 0;
 	void *data;
 
 	if (!data_size)
@@ -52,15 +53,28 @@ static void *iwl_uefi_get_variable(efi_char16_t *name, efi_guid_t *guid,
 	if (!data)
 		return ERR_PTR(-ENOMEM);
 
-	status = efi.get_variable(name, guid, NULL, data_size, data);
+	status = efi.get_variable(name, guid, &attr, data_size, data);
 	if (status != EFI_SUCCESS) {
 		kfree(data);
 		return ERR_PTR(-ENOENT);
 	}
 
+	if (attributes)
+		*attributes = attr;
+
 	return data;
 }
 
+static efi_status_t iwl_uefi_set_variable(efi_char16_t *name, efi_guid_t *guid,
+					  u32 attributes, void *data,
+					  unsigned long data_size)
+{
+	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_SET_VARIABLE))
+		return EFI_UNSUPPORTED;
+
+	return efi.set_variable(name, guid, attributes, data_size, data);
+}
+
 void *iwl_uefi_get_pnvm(struct iwl_trans *trans, size_t *len)
 {
 	unsigned long package_size;
@@ -69,7 +83,7 @@ void *iwl_uefi_get_pnvm(struct iwl_trans *trans, size_t *len)
 	*len = 0;
 
 	data = iwl_uefi_get_variable(IWL_UEFI_OEM_PNVM_NAME, &IWL_EFI_WIFI_GUID,
-				     &package_size);
+				     NULL, &package_size);
 	if (IS_ERR(data)) {
 		IWL_DEBUG_FW(trans,
 			     "PNVM UEFI variable not found 0x%lx (len %lu)\n",
@@ -84,17 +98,18 @@ void *iwl_uefi_get_pnvm(struct iwl_trans *trans, size_t *len)
 }
 
 static void *
-iwl_uefi_get_verified_variable_guid(struct iwl_trans *trans,
-				    efi_guid_t *guid,
-				    efi_char16_t *uefi_var_name,
-				    char *var_name,
-				    unsigned int expected_size,
-				    unsigned long *size)
+iwl_uefi_get_variable_guid(struct iwl_trans *trans,
+			   efi_guid_t *guid,
+			   efi_char16_t *uefi_var_name,
+			   char *var_name,
+			   unsigned int expected_size,
+			   unsigned long *size,
+			   u32 *attributes)
 {
 	void *var;
 	unsigned long var_size;
 
-	var = iwl_uefi_get_variable(uefi_var_name, guid, &var_size);
+	var = iwl_uefi_get_variable(uefi_var_name, guid, attributes, &var_size);
 
 	if (IS_ERR(var)) {
 		IWL_DEBUG_RADIO(trans,
@@ -120,13 +135,72 @@ iwl_uefi_get_verified_variable_guid(struct iwl_trans *trans,
 }
 
 static void *
-iwl_uefi_get_verified_variable(struct iwl_trans *trans,
+iwl_uefi_get_verified_variable_guid(struct iwl_fw_runtime *fwrt,
+				    efi_guid_t *guid,
+				    efi_char16_t *uefi_var_name,
+				    char *var_name,
+				    unsigned int expected_size,
+				    unsigned long *size)
+{
+	unsigned long var_size;
+	u32 attributes = 0;
+	void *var;
+
+	if (fwrt->uefi_tables_lock_status == UEFI_CNV_GUID_UNLOCKED)
+		return ERR_PTR(-EINVAL);
+
+	/* In x86 either GLUI or GLAI should exist */
+	if ((IS_ENABLED(CONFIG_X86) || IS_ENABLED(CONFIG_X86_64) ||
+	     IS_ENABLED(CONFIG_X86_32)) &&
+	    fwrt->uefi_tables_lock_status == UEFI_CNV_GUID_UNKNOWN)
+		return ERR_PTR(-EINVAL);
+
+	var = iwl_uefi_get_variable_guid(fwrt->trans,
+					 guid,
+					 uefi_var_name, var_name,
+					 expected_size, &var_size,
+					 &attributes);
+	if (IS_ERR(var))
+		return var;
+
+	if (fwrt->uefi_tables_lock_status != UEFI_CNV_GUID_UNKNOWN)
+		goto out;
+
+	/*
+	 * The lock status is unknown, so probe it: rewrite the variable
+	 * with the data just read and trust it only if the firmware
+	 * refuses the write. Treat a zero attributes value as untrusted,
+	 * since a SetVariable() with no attributes would delete it.
+	 */
+	if (attributes) {
+		efi_status_t status;
+
+		status = iwl_uefi_set_variable(uefi_var_name, guid, attributes,
+					       var, var_size);
+		if (status == EFI_WRITE_PROTECTED ||
+		    status == EFI_SECURITY_VIOLATION ||
+		    status == EFI_ACCESS_DENIED)
+			goto out;
+	}
+
+	/* unprobeable (e.g. EFI_UNSUPPORTED) or writable: not trusted */
+	kfree(var);
+	return ERR_PTR(-EINVAL);
+
+out:
+	if (size)
+		*size = var_size;
+	return var;
+}
+
+static void *
+iwl_uefi_get_verified_wifi_var(struct iwl_fw_runtime *fwrt,
 			       efi_char16_t *uefi_var_name,
 			       char *var_name,
 			       unsigned int expected_size,
 			       unsigned long *size)
 {
-	return iwl_uefi_get_verified_variable_guid(trans, &IWL_EFI_WIFI_GUID,
+	return iwl_uefi_get_verified_variable_guid(fwrt, &IWL_EFI_WIFI_GUID,
 						   uefi_var_name, var_name,
 						   expected_size, size);
 }
@@ -292,11 +366,12 @@ u8 *iwl_uefi_get_reduced_power(struct iwl_trans *trans, size_t *len)
 	unsigned long package_size;
 	u8 *data;
 
-	package = iwl_uefi_get_verified_variable(trans,
-						 IWL_UEFI_REDUCED_POWER_NAME,
-						 "Reduced Power",
-						 sizeof(*package),
-						 &package_size);
+	package =
+		iwl_uefi_get_variable_guid(trans, &IWL_EFI_WIFI_GUID,
+					   IWL_UEFI_REDUCED_POWER_NAME,
+					   "Reduced Power",
+					   sizeof(*package),
+					   &package_size, NULL);
 	if (IS_ERR(package))
 		return ERR_CAST(package);
 
@@ -338,9 +413,9 @@ void iwl_uefi_get_step_table(struct iwl_trans *trans)
 	if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_AX210)
 		return;
 
-	data = iwl_uefi_get_verified_variable_guid(trans, &IWL_EFI_WIFI_BT_GUID,
-						   IWL_UEFI_STEP_NAME,
-						   "STEP", sizeof(*data), NULL);
+	data = iwl_uefi_get_variable_guid(trans, &IWL_EFI_WIFI_BT_GUID,
+					  IWL_UEFI_STEP_NAME, "STEP",
+					  sizeof(*data), NULL, NULL);
 	if (IS_ERR(data))
 		return;
 
@@ -393,8 +468,9 @@ void iwl_uefi_get_sgom_table(struct iwl_trans *trans,
 	if (!fwrt->geo_enabled)
 		return;
 
-	data = iwl_uefi_get_verified_variable(trans, IWL_UEFI_SGOM_NAME,
-					      "SGOM", sizeof(*data), NULL);
+	data = iwl_uefi_get_variable_guid(trans, &IWL_EFI_WIFI_GUID,
+					  IWL_UEFI_SGOM_NAME, "SGOM",
+					  sizeof(*data), NULL, NULL);
 	if (IS_ERR(data))
 		return;
 
@@ -427,8 +503,9 @@ void iwl_uefi_get_uats_table(struct iwl_trans *trans,
 	struct uefi_cnv_wlan_uats_data *data;
 	int ret;
 
-	data = iwl_uefi_get_verified_variable(trans, IWL_UEFI_UATS_NAME,
-					      "UATS", sizeof(*data), NULL);
+	data = iwl_uefi_get_variable_guid(trans, &IWL_EFI_WIFI_GUID,
+					  IWL_UEFI_UATS_NAME, "UATS",
+					  sizeof(*data), NULL, NULL);
 	if (IS_ERR(data))
 		return;
 
@@ -444,8 +521,9 @@ void iwl_uefi_get_uneb_table(struct iwl_trans *trans,
 {
 	struct uefi_cnv_wlan_uneb_data *data;
 
-	data = iwl_uefi_get_verified_variable(trans, IWL_UEFI_UNEB_NAME,
-					      "UNEB", sizeof(*data), NULL);
+	data = iwl_uefi_get_variable_guid(trans, &IWL_EFI_WIFI_GUID,
+					  IWL_UEFI_UNEB_NAME, "UNEB",
+					  sizeof(*data), NULL, NULL);
 	if (IS_ERR(data))
 		return;
 
@@ -506,8 +584,8 @@ int iwl_uefi_get_wrds_table(struct iwl_fw_runtime *fwrt)
 	int num_subbands;
 	int ret = 0;
 
-	data = iwl_uefi_get_verified_variable(fwrt->trans, IWL_UEFI_WRDS_NAME,
-					      "WRDS",
+	data = iwl_uefi_get_verified_wifi_var(fwrt,
+					      IWL_UEFI_WRDS_NAME, "WRDS",
 					      UEFI_SAR_WRDS_TABLE_SIZE_REV2,
 					      &size);
 
@@ -555,8 +633,8 @@ int iwl_uefi_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 	int num_subbands;
 	int profile_size;
 
-	data = iwl_uefi_get_verified_variable(fwrt->trans, IWL_UEFI_EWRD_NAME,
-					      "EWRD",
+	data = iwl_uefi_get_verified_wifi_var(fwrt,
+					      IWL_UEFI_EWRD_NAME, "EWRD",
 					      UEFI_SAR_EWRD_TABLE_SIZE_REV2,
 					      &size);
 	if (IS_ERR(data))
@@ -609,9 +687,9 @@ int iwl_uefi_get_wgds_table(struct iwl_fw_runtime *fwrt)
 	int n_subbands;
 	int ret = 0;
 
-	data = iwl_uefi_get_verified_variable(fwrt->trans, IWL_UEFI_WGDS_NAME,
-					      "WGDS", UEFI_WGDS_TABLE_SIZE_REV3,
-					      &size);
+	data = iwl_uefi_get_verified_wifi_var(fwrt,
+					      IWL_UEFI_WGDS_NAME, "WGDS",
+					      UEFI_WGDS_TABLE_SIZE_REV3, &size);
 	if (IS_ERR(data))
 		return -EINVAL;
 
@@ -684,9 +762,9 @@ int iwl_uefi_get_ppag_table(struct iwl_fw_runtime *fwrt)
 	u32 valid_rev;
 	int ret = 0;
 
-	data = iwl_uefi_get_verified_variable(fwrt->trans, IWL_UEFI_PPAG_NAME,
-					      "PPAG", UEFI_PPAG_DATA_SIZE_V5,
-					      NULL);
+	data = iwl_uefi_get_verified_wifi_var(fwrt,
+					      IWL_UEFI_PPAG_NAME, "PPAG",
+					      UEFI_PPAG_DATA_SIZE_V5, NULL);
 	if (!IS_ERR(data)) {
 		n_subbands = UEFI_PPAG_SUB_BANDS_NUM_REV5;
 		valid_rev = BIT(5);
@@ -694,7 +772,7 @@ int iwl_uefi_get_ppag_table(struct iwl_fw_runtime *fwrt)
 		goto parse_table;
 	}
 
-	data = iwl_uefi_get_verified_variable(fwrt->trans,
+	data = iwl_uefi_get_verified_wifi_var(fwrt,
 					      IWL_UEFI_PPAG_NAME,
 					      "PPAG",
 					      UEFI_PPAG_DATA_SIZE_V4,
@@ -752,8 +830,9 @@ int iwl_uefi_get_tas_table(struct iwl_fw_runtime *fwrt,
 	struct uefi_cnv_var_wtas *uefi_tas;
 	int ret, enabled;
 
-	uefi_tas = iwl_uefi_get_verified_variable(fwrt->trans, IWL_UEFI_WTAS_NAME,
-						  "WTAS", sizeof(*uefi_tas), NULL);
+	uefi_tas = iwl_uefi_get_verified_wifi_var(fwrt,
+						  IWL_UEFI_WTAS_NAME, "WTAS",
+						  sizeof(*uefi_tas), NULL);
 	if (IS_ERR(uefi_tas))
 		return -EINVAL;
 
@@ -805,7 +884,7 @@ int iwl_uefi_get_pwr_limit(struct iwl_fw_runtime *fwrt,
 	struct uefi_cnv_var_splc *data;
 	int ret = 0;
 
-	data = iwl_uefi_get_verified_variable(fwrt->trans, IWL_UEFI_SPLC_NAME,
+	data = iwl_uefi_get_verified_wifi_var(fwrt, IWL_UEFI_SPLC_NAME,
 					      "SPLC", sizeof(*data), NULL);
 	if (IS_ERR(data))
 		return -EINVAL;
@@ -827,8 +906,9 @@ int iwl_uefi_get_mcc(struct iwl_fw_runtime *fwrt, char *mcc)
 	struct uefi_cnv_var_wrdd *data;
 	int ret = 0;
 
-	data = iwl_uefi_get_verified_variable(fwrt->trans, IWL_UEFI_WRDD_NAME,
-					      "WRDD", sizeof(*data), NULL);
+	data = iwl_uefi_get_verified_wifi_var(fwrt,
+					      IWL_UEFI_WRDD_NAME, "WRDD",
+					      sizeof(*data), NULL);
 	if (IS_ERR(data))
 		return -EINVAL;
 
@@ -858,7 +938,7 @@ int iwl_uefi_get_eckv(struct iwl_fw_runtime *fwrt, u32 *extl_clk)
 	struct uefi_cnv_var_eckv *data;
 	int ret = 0;
 
-	data = iwl_uefi_get_verified_variable_guid(fwrt->trans,
+	data = iwl_uefi_get_verified_variable_guid(fwrt,
 						   &IWL_EFI_WIFI_BT_GUID,
 						   IWL_UEFI_ECKV_NAME,
 						   "ECKV", sizeof(*data), NULL);
@@ -882,8 +962,9 @@ int iwl_uefi_get_wbem(struct iwl_fw_runtime *fwrt, u32 *value)
 	struct uefi_cnv_wlan_wbem_data *data;
 	int ret = 0;
 
-	data = iwl_uefi_get_verified_variable(fwrt->trans, IWL_UEFI_WBEM_NAME,
-					      "WBEM", sizeof(*data), NULL);
+	data = iwl_uefi_get_verified_wifi_var(fwrt,
+					      IWL_UEFI_WBEM_NAME, "WBEM",
+					      sizeof(*data), NULL);
 	if (IS_ERR(data))
 		return -EINVAL;
 
@@ -909,7 +990,7 @@ static int iwl_uefi_load_dsm_values(struct iwl_fw_runtime *fwrt)
 
 	BUILD_BUG_ON(ARRAY_SIZE(data->functions) < ARRAY_SIZE(fwrt->dsm_values));
 
-	data = iwl_uefi_get_verified_variable(fwrt->trans, IWL_UEFI_DSM_NAME,
+	data = iwl_uefi_get_verified_wifi_var(fwrt, IWL_UEFI_DSM_NAME,
 					      "DSM", sizeof(*data), NULL);
 	if (IS_ERR(data))
 		return -EINVAL;
@@ -990,10 +1071,10 @@ int iwl_uefi_get_puncturing(struct iwl_fw_runtime *fwrt)
 	struct uefi_cnv_var_puncturing_data *data;
 	int ret = 0;
 
-	data = iwl_uefi_get_verified_variable(fwrt->trans,
-					      IWL_UEFI_PUNCTURING_NAME,
-					      "UefiCnvWlanPuncturing",
-					      sizeof(*data), NULL);
+	data = iwl_uefi_get_variable_guid(fwrt->trans, &IWL_EFI_WIFI_GUID,
+					  IWL_UEFI_PUNCTURING_NAME,
+					  "UefiCnvWlanPuncturing",
+					  sizeof(*data), NULL, NULL);
 	if (IS_ERR(data))
 		return -EINVAL;
 
@@ -1019,7 +1100,7 @@ int iwl_uefi_get_dsbr(struct iwl_fw_runtime *fwrt, u32 *value)
 	struct uefi_cnv_wlan_dsbr_data *data;
 	int ret = 0;
 
-	data = iwl_uefi_get_verified_variable_guid(fwrt->trans,
+	data = iwl_uefi_get_verified_variable_guid(fwrt,
 						   &IWL_EFI_WIFI_BT_GUID,
 						   IWL_UEFI_DSBR_NAME, "DSBR",
 						   sizeof(*data), NULL);
@@ -1045,8 +1126,9 @@ int iwl_uefi_get_phy_filters(struct iwl_fw_runtime *fwrt)
 	struct uefi_cnv_wpfc_data *data __free(kfree);
 	struct iwl_phy_specific_cfg *filters = &fwrt->phy_filters;
 
-	data = iwl_uefi_get_verified_variable(fwrt->trans, IWL_UEFI_WPFC_NAME,
-					      "WPFC", sizeof(*data), NULL);
+	data = iwl_uefi_get_verified_wifi_var(fwrt,
+					      IWL_UEFI_WPFC_NAME, "WPFC",
+					      sizeof(*data), NULL);
 	if (IS_ERR(data))
 		return -EINVAL;
 
@@ -1071,10 +1153,10 @@ int iwl_uefi_get_phy_filters(struct iwl_fw_runtime *fwrt)
 void iwl_uefi_get_guid_lock_status(struct iwl_fw_runtime *fwrt)
 {
 	struct uefi_cnv_var_glui *data __free(kfree) =
-		iwl_uefi_get_verified_variable_guid(fwrt->trans,
-						    &IWL_EFI_GLUI_GUID,
-						    IWL_UEFI_GLUI_NAME, "GLUI",
-						    sizeof(*data), NULL);
+		iwl_uefi_get_variable_guid(fwrt->trans,
+					   &IWL_EFI_GLUI_GUID,
+					   IWL_UEFI_GLUI_NAME, "GLUI",
+					   sizeof(*data), NULL, NULL);
 
 	if (IS_ERR(data))
 		return;
@@ -1085,7 +1167,7 @@ void iwl_uefi_get_guid_lock_status(struct iwl_fw_runtime *fwrt)
 		return;
 	}
 
-	/* UEFI_CNV_GUID_TEST_MODE is the max value */
+	/* UEFI_CNV_GUID_TEST_MODE is the max value the BIOS can report */
 	if (data->guid_lock_status > UEFI_CNV_GUID_TEST_MODE) {
 		IWL_DEBUG_RADIO(fwrt, "Invalid UEFI GUID lock status:%d\n",
 				data->guid_lock_status);
-- 
2.34.1

