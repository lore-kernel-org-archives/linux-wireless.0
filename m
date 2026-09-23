Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492A75218AD
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168601; cv=none; b=Oi25PeAI/yXz8JVuMwkhGSpWHZyPEMwrLMcJhODzZlEG6/PkPJT4NEnwML2yw+okFAhnXOxspn+U4c3ifdADkHo10tT86EJ3/MkBgzCLx7A7VQQIspGolj83vQsUoOMGbRbNJKk3IhkeuLH6X1JLAgFGeIHhia5tvvd/Wf2VJnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168601; c=relaxed/simple;
	bh=Ay+H5e9nBJXMYliDQcsIRxkK0KhlI1ejOXJEGvGrzlM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ElCuWmcr6+Z2vph2Xi7LQNX3NbmlxfDwCV8x82l4vziIr1dcpGqxTwJHEIH+g1o15IMLyY5ayxjaVoU4eAQ80UvTR3JMvWaR8DIbB+WxEQJ8oUyH8PuRhyrWuh0s/jGR37NubtKFUr9t/yVxRB5f/mcnGfBfW0pbKnsTof6n3qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nLpQ1v8t; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nLpQ1v8t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168597; x=1821704597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ay+H5e9nBJXMYliDQcsIRxkK0KhlI1ejOXJEGvGrzlM=;
  b=nLpQ1v8tSUx5ue4uOENsbJSSj06cckLLvuabAr1Y1cg01Jkf2WqkIYvF
   8eZvprGAz/Ha/n3VwMaGLLhWMCypvak7PmcB5cl42IhxnD+FvSvhGSShj
   GQ8N1VKoOdKjTatvhthtXhqXpnQE8UvaU4wB1lRGngOyjnHDgFx4ziMES
   vsq/FIb2VaFpgQyTXY0r3J/a3EmYyvQK5iIweM+079Q5jWxUHDWkpIeWC
   ibfCdZyZ/EWAQwMNhIW9crO1uSxVOSw31lGDsTsA7XDlxgZD23SJdm0m7
   zLGTH8tsAj2pQEPvZK/mO78eBSF+P1gPwzN4yykUz9ud7JUe/qu55yMGQ
   g==;
X-CSE-ConnectionGUID: csw/105WQtmojMsISC4Qpg==
X-CSE-MsgGUID: Sd3Afde0RyaxKQfAqteHIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781348"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781348"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:14 -0700
X-CSE-ConnectionGUID: zwYoLp8yQC+UPS/ayqCTog==
X-CSE-MsgGUID: ZRmSuOjWSxmt1/lGWlwt6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4697089"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:13 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Shahar Tzarfati <shahar.tzarfati@intel.com>
Subject: [PATCH iwlwifi-next 10/15] wifi: iwlwifi: uefi: add UEFI GUID Lock Indicator (GLUI) definitions
Date: Wed, 23 Sep 2026 16:04:53 +0300
Message-Id: <20260923160318.55d7dc9c9531.If4c9949de70fe78951464b983caf2c9d974061b3@changeid>
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

The platform provides a root-of-trust mechanism for connectivity UEFI
variables via a dedicated UEFI GUID Lock Indicator (GLUI) variable. The
GLUI may remain locked in both production and testing modes. A UEFI
indicator is used rather than relying on the ACPI GLAI alone, so the
mechanism also works on platforms that do not expose ACPI.

Add the building blocks for consuming this variable and
iwl_uefi_get_guid_lock_status() to read its value and store it, so the
driver can use its lock state to decide whether the connectivity UEFI
variables are trusted.

Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Assisted-by: GitHub-Copilot:claude-opus-4-8
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  |  3 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  |  4 ---
 .../wireless/intel/iwlwifi/fw/regulatory.c    |  2 +-
 .../wireless/intel/iwlwifi/fw/regulatory.h    | 13 +++++++
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |  4 +--
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c  | 34 +++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h  | 12 +++++++
 7 files changed, 64 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index 71e0950d0193..f53cb531cf88 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -1153,7 +1153,8 @@ void iwl_acpi_get_guid_lock_status(struct iwl_fw_runtime *fwrt)
 	}
 
 	if (wifi_pkg->package.elements[1].type != ACPI_TYPE_INTEGER ||
-	    wifi_pkg->package.elements[1].integer.value > ACPI_GLAI_MAX_STATUS)
+	    wifi_pkg->package.elements[1].integer.value >
+	    UEFI_CNV_GUID_TEST_MODE)
 		goto out_free;
 
 	fwrt->uefi_tables_lock_status =
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
index 45eb35ffb637..426b0c51abec 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
@@ -89,7 +89,6 @@
  * and one for the status
  */
 #define ACPI_GLAI_WIFI_DATA_SIZE	2
-#define ACPI_GLAI_MAX_STATUS		2
 /*
  * TAS size: 1 elelment for type,
  *	     1 element for enabled field,
@@ -111,9 +110,6 @@
 #define ACPI_PPAG_WIFI_DATA_SIZE_V3	((ACPI_PPAG_NUM_CHAINS * \
 					  ACPI_PPAG_NUM_BANDS_V3) + 2)
 
-/* The Inidcator whether UEFI WIFI GUID tables are locked is read from ACPI */
-#define UEFI_WIFI_GUID_UNLOCKED		0
-
 #define ACPI_DSM_REV 0
 
 #define DSM_INTERNAL_FUNC_GET_PLAT_INFO	1
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
index 3ab383b569bc..8dff97b8e0f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -12,7 +12,7 @@
 #define GET_BIOS_TABLE(__name, ...)					\
 do {									\
 	int ret = -ENOENT;						\
-	if (fwrt->uefi_tables_lock_status > UEFI_WIFI_GUID_UNLOCKED)	\
+	if (fwrt->uefi_tables_lock_status > UEFI_CNV_GUID_UNLOCKED)	\
 		ret = iwl_uefi_get_ ## __name(__VA_ARGS__);		\
 	if (ret < 0)							\
 		ret = iwl_acpi_get_ ## __name(__VA_ARGS__);		\
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
index 22c97c75b83c..08fd11adf905 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
@@ -47,6 +47,19 @@
 #define IWL_WTAS_CANADA_UHB_MSK		BIT(15)
 #define IWL_WTAS_USA_UHB_MSK		BIT(16)
 
+/**
+ * enum iwl_uefi_cnv_guid_status - lock status of the connectivity
+ * UEFI tables
+ * @UEFI_CNV_GUID_UNLOCKED: the tables are unlocked
+ * @UEFI_CNV_GUID_LOCKED: the tables are locked
+ * @UEFI_CNV_GUID_TEST_MODE: the tables are locked in test mode
+ */
+enum iwl_uefi_cnv_guid_status {
+	UEFI_CNV_GUID_UNLOCKED = 0,
+	UEFI_CNV_GUID_LOCKED = 1,
+	UEFI_CNV_GUID_TEST_MODE = 2,
+};
+
 struct iwl_tas_selection_data {
 	u8 override_tas_iec:1,
 	   enable_tas_iec:1,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index ac01ac0092ee..12a1cf6b16f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -108,8 +108,8 @@ struct iwl_txf_iter_data {
  * @dump: debug dump data
  * @ap_type_cmd: AP type tables (for enablement on 6 GHz)
  * @ap_type_cmd_valid: if &ap_type_cmd is valid
- * @uefi_tables_lock_status: The status of the WIFI GUID UEFI variables lock:
- *	0: Unlocked, 1 and 2: Locked.
+ * @uefi_tables_lock_status: the status of the WIFI GUID UEFI variables lock,
+ *	see &enum iwl_uefi_cnv_guid_status.
  *	Only read the UEFI variables if locked.
  * @sar_profiles: sar profiles as read from WRDS/EWRD BIOS tables
  * @geo_profiles: geographic profiles as read from WGDS BIOS table
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index 7c290b526383..7df0e5ea4a1d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -20,6 +20,10 @@
 					 0x8d, 0x03, 0x77, 0x2e,	\
 					 0xcc, 0x3d, 0xa5, 0x31)
 
+#define IWL_EFI_GLUI_GUID	EFI_GUID(0x6c5bed75, 0x0ee8, 0x4d45,	\
+					 0x98, 0x0b, 0x4d, 0x81,	\
+					 0x31, 0xba, 0x84, 0xb5)
+
 struct iwl_uefi_pnvm_mem_desc {
 	__le32 addr;
 	__le32 size;
@@ -1063,3 +1067,33 @@ int iwl_uefi_get_phy_filters(struct iwl_fw_runtime *fwrt)
 	IWL_DEBUG_RADIO(fwrt, "Loaded WPFC config from UEFI\n");
 	return 0;
 }
+
+void iwl_uefi_get_guid_lock_status(struct iwl_fw_runtime *fwrt)
+{
+	struct uefi_cnv_var_glui *data __free(kfree) =
+		iwl_uefi_get_verified_variable_guid(fwrt->trans,
+						    &IWL_EFI_GLUI_GUID,
+						    IWL_UEFI_GLUI_NAME, "GLUI",
+						    sizeof(*data), NULL);
+
+	if (IS_ERR(data))
+		return;
+
+	if (data->revision != IWL_UEFI_GLUI_REVISION) {
+		IWL_DEBUG_RADIO(fwrt, "Unsupported UEFI GLUI revision:%d\n",
+				data->revision);
+		return;
+	}
+
+	/* UEFI_CNV_GUID_TEST_MODE is the max value */
+	if (data->guid_lock_status > UEFI_CNV_GUID_TEST_MODE) {
+		IWL_DEBUG_RADIO(fwrt, "Invalid UEFI GUID lock status:%d\n",
+				data->guid_lock_status);
+		return;
+	}
+
+	fwrt->uefi_tables_lock_status = data->guid_lock_status;
+
+	IWL_DEBUG_RADIO(fwrt, "Loaded UEFI WIFI GUID lock status: %d\n",
+			fwrt->uefi_tables_lock_status);
+}
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.h b/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
index 386ca3744408..64fa1a78aacf 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
@@ -13,6 +13,7 @@
 #define IWL_UEFI_STEP_NAME		L"UefiCnvCommonSTEP"
 #define IWL_UEFI_UATS_NAME		L"CnvUefiWlanUATS"
 #define IWL_UEFI_WRDS_NAME		L"UefiCnvWlanWRDS"
+#define IWL_UEFI_GLUI_NAME		L"UefiCnvCommonGLUI"
 #define IWL_UEFI_EWRD_NAME		L"UefiCnvWlanEWRD"
 #define IWL_UEFI_WGDS_NAME		L"UefiCnvWlanWGDS"
 #define IWL_UEFI_PPAG_NAME		L"UefiCnvWlanPPAG"
@@ -40,6 +41,7 @@
 #define IWL_UEFI_DSM_REVISION		4
 #define IWL_UEFI_PUNCTURING_REVISION	0
 #define IWL_UEFI_DSBR_REVISION		1
+#define IWL_UEFI_GLUI_REVISION		0
 
 struct pnvm_sku_package {
 	u8 rev;
@@ -54,6 +56,11 @@ struct uefi_cnv_wlan_sgom_data {
 	u8 offset_map[IWL_SGOM_MAP_SIZE - 1];
 } __packed;
 
+struct uefi_cnv_var_glui {
+	u8 revision;
+	u8 guid_lock_status;
+} __packed;
+
 struct uefi_cnv_wlan_uats_data {
 	u8 revision;
 	u8 mcc_to_ap_type_map[IWL_UATS_MAP_SIZE - 1];
@@ -349,6 +356,7 @@ void iwl_uefi_get_uneb_table(struct iwl_trans *trans,
 int iwl_uefi_get_puncturing(struct iwl_fw_runtime *fwrt);
 int iwl_uefi_get_dsbr(struct iwl_fw_runtime *fwrt, u32 *value);
 int iwl_uefi_get_phy_filters(struct iwl_fw_runtime *fwrt);
+void iwl_uefi_get_guid_lock_status(struct iwl_fw_runtime *fwrt);
 #else /* CONFIG_EFI */
 static inline void *iwl_uefi_get_pnvm(struct iwl_trans *trans, size_t *len)
 {
@@ -466,5 +474,9 @@ static inline int iwl_uefi_get_phy_filters(struct iwl_fw_runtime *fwrt)
 {
 	return -ENOENT;
 }
+
+static inline void iwl_uefi_get_guid_lock_status(struct iwl_fw_runtime *fwrt)
+{
+}
 #endif /* CONFIG_EFI */
 #endif /* __iwl_fw_uefi__ */
-- 
2.34.1

