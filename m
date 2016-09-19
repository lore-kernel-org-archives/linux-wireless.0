Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56000 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932428AbcISHcJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:32:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
        Arik Nemtsov <arikx.nemtsov@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:14 +0300
Message-Id: <20160919073028.22065-11-luca@coelho.fi> (sfid-20160919_093213_541274_304568D2)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 11/25] iwlwifi: move BIOS MCC retrieval to common code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

This will be used by more than MVM, so move it to iwlwifi

While at it, rename WRD_METHOD to the more appropriate
WRDD_METHOD and add some documentation.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 89 +++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h | 20 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       | 93 +---------------------
 3 files changed, 109 insertions(+), 93 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index adba3b0..3bd6fc1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -67,6 +67,7 @@
 #include <linux/export.h>
 #include <linux/etherdevice.h>
 #include <linux/pci.h>
+#include <linux/acpi.h>
 #include "iwl-drv.h"
 #include "iwl-modparams.h"
 #include "iwl-nvm-parse.h"
@@ -904,3 +905,91 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 	return regd;
 }
 IWL_EXPORT_SYMBOL(iwl_parse_nvm_mcc_info);
+
+#ifdef CONFIG_ACPI
+#define WRDD_METHOD		"WRDD"
+#define WRDD_WIFI		(0x07)
+#define WRDD_WIGIG		(0x10)
+
+static u32 iwl_wrdd_get_mcc(struct device *dev, union acpi_object *wrdd)
+{
+	union acpi_object *mcc_pkg, *domain_type, *mcc_value;
+	u32 i;
+
+	if (wrdd->type != ACPI_TYPE_PACKAGE ||
+	    wrdd->package.count < 2 ||
+	    wrdd->package.elements[0].type != ACPI_TYPE_INTEGER ||
+	    wrdd->package.elements[0].integer.value != 0) {
+		IWL_DEBUG_EEPROM(dev, "Unsupported wrdd structure\n");
+		return 0;
+	}
+
+	for (i = 1 ; i < wrdd->package.count ; ++i) {
+		mcc_pkg = &wrdd->package.elements[i];
+
+		if (mcc_pkg->type != ACPI_TYPE_PACKAGE ||
+		    mcc_pkg->package.count < 2 ||
+		    mcc_pkg->package.elements[0].type != ACPI_TYPE_INTEGER ||
+		    mcc_pkg->package.elements[1].type != ACPI_TYPE_INTEGER) {
+			mcc_pkg = NULL;
+			continue;
+		}
+
+		domain_type = &mcc_pkg->package.elements[0];
+		if (domain_type->integer.value == WRDD_WIFI)
+			break;
+
+		mcc_pkg = NULL;
+	}
+
+	if (mcc_pkg) {
+		mcc_value = &mcc_pkg->package.elements[1];
+		return mcc_value->integer.value;
+	}
+
+	return 0;
+}
+
+int iwl_get_bios_mcc(struct device *dev, char *mcc)
+{
+	acpi_handle root_handle;
+	acpi_handle handle;
+	struct acpi_buffer wrdd = {ACPI_ALLOCATE_BUFFER, NULL};
+	acpi_status status;
+	u32 mcc_val;
+
+	root_handle = ACPI_HANDLE(dev);
+	if (!root_handle) {
+		IWL_DEBUG_EEPROM(dev,
+				 "Could not retrieve root port ACPI handle\n");
+		return -ENOENT;
+	}
+
+	/* Get the method's handle */
+	status = acpi_get_handle(root_handle, (acpi_string)WRDD_METHOD,
+				 &handle);
+	if (ACPI_FAILURE(status)) {
+		IWL_DEBUG_EEPROM(dev, "WRD method not found\n");
+		return -ENOENT;
+	}
+
+	/* Call WRDD with no arguments */
+	status = acpi_evaluate_object(handle, NULL, NULL, &wrdd);
+	if (ACPI_FAILURE(status)) {
+		IWL_DEBUG_EEPROM(dev, "WRDC invocation failed (0x%x)\n",
+				 status);
+		return -ENOENT;
+	}
+
+	mcc_val = iwl_wrdd_get_mcc(dev, wrdd.pointer);
+	kfree(wrdd.pointer);
+	if (!mcc_val)
+		return -ENOENT;
+
+	mcc[0] = (mcc_val >> 8) & 0xff;
+	mcc[1] = mcc_val & 0xff;
+	mcc[2] = '\0';
+	return 0;
+}
+IWL_EXPORT_SYMBOL(iwl_get_bios_mcc);
+#endif
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
index d704d52..7249e5b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
@@ -5,7 +5,8 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2015 Intel Corporation. All rights reserved.
+ * Copyright(c) 2016        Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -93,4 +94,21 @@ struct ieee80211_regdomain *
 iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 		       int num_of_ch, __le32 *channels, u16 fw_mcc);
 
+#ifdef CONFIG_ACPI
+/**
+ * iwl_get_bios_mcc - read MCC from BIOS, if available
+ *
+ * @dev: the struct device
+ * @mcc: output buffer (3 bytes) that will get the MCC
+ *
+ * This function tries to read the current MCC from ACPI if available.
+ */
+int iwl_get_bios_mcc(struct device *dev, char *mcc);
+#else
+static inline int iwl_get_bios_mcc(struct device *dev, char *mcc)
+{
+	return -ENOENT;
+}
+#endif
+
 #endif /* __iwl_nvm_parse_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 7a686f6..eade099 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -66,7 +66,6 @@
  *****************************************************************************/
 #include <linux/firmware.h>
 #include <linux/rtnetlink.h>
-#include <linux/acpi.h>
 #include "iwl-trans.h"
 #include "iwl-csr.h"
 #include "mvm.h"
@@ -751,96 +750,6 @@ exit:
 	return resp_cp;
 }
 
-#ifdef CONFIG_ACPI
-#define WRD_METHOD		"WRDD"
-#define WRDD_WIFI		(0x07)
-#define WRDD_WIGIG		(0x10)
-
-static u32 iwl_mvm_wrdd_get_mcc(struct iwl_mvm *mvm, union acpi_object *wrdd)
-{
-	union acpi_object *mcc_pkg, *domain_type, *mcc_value;
-	u32 i;
-
-	if (wrdd->type != ACPI_TYPE_PACKAGE ||
-	    wrdd->package.count < 2 ||
-	    wrdd->package.elements[0].type != ACPI_TYPE_INTEGER ||
-	    wrdd->package.elements[0].integer.value != 0) {
-		IWL_DEBUG_LAR(mvm, "Unsupported wrdd structure\n");
-		return 0;
-	}
-
-	for (i = 1 ; i < wrdd->package.count ; ++i) {
-		mcc_pkg = &wrdd->package.elements[i];
-
-		if (mcc_pkg->type != ACPI_TYPE_PACKAGE ||
-		    mcc_pkg->package.count < 2 ||
-		    mcc_pkg->package.elements[0].type != ACPI_TYPE_INTEGER ||
-		    mcc_pkg->package.elements[1].type != ACPI_TYPE_INTEGER) {
-			mcc_pkg = NULL;
-			continue;
-		}
-
-		domain_type = &mcc_pkg->package.elements[0];
-		if (domain_type->integer.value == WRDD_WIFI)
-			break;
-
-		mcc_pkg = NULL;
-	}
-
-	if (mcc_pkg) {
-		mcc_value = &mcc_pkg->package.elements[1];
-		return mcc_value->integer.value;
-	}
-
-	return 0;
-}
-
-static int iwl_mvm_get_bios_mcc(struct iwl_mvm *mvm, char *mcc)
-{
-	acpi_handle root_handle;
-	acpi_handle handle;
-	struct acpi_buffer wrdd = {ACPI_ALLOCATE_BUFFER, NULL};
-	acpi_status status;
-	u32 mcc_val;
-
-	root_handle = ACPI_HANDLE(mvm->dev);
-	if (!root_handle) {
-		IWL_DEBUG_LAR(mvm,
-			      "Could not retrieve root port ACPI handle\n");
-		return -ENOENT;
-	}
-
-	/* Get the method's handle */
-	status = acpi_get_handle(root_handle, (acpi_string)WRD_METHOD, &handle);
-	if (ACPI_FAILURE(status)) {
-		IWL_DEBUG_LAR(mvm, "WRD method not found\n");
-		return -ENOENT;
-	}
-
-	/* Call WRDD with no arguments */
-	status = acpi_evaluate_object(handle, NULL, NULL, &wrdd);
-	if (ACPI_FAILURE(status)) {
-		IWL_DEBUG_LAR(mvm, "WRDC invocation failed (0x%x)\n", status);
-		return -ENOENT;
-	}
-
-	mcc_val = iwl_mvm_wrdd_get_mcc(mvm, wrdd.pointer);
-	kfree(wrdd.pointer);
-	if (!mcc_val)
-		return -ENOENT;
-
-	mcc[0] = (mcc_val >> 8) & 0xff;
-	mcc[1] = mcc_val & 0xff;
-	mcc[2] = '\0';
-	return 0;
-}
-#else /* CONFIG_ACPI */
-static int iwl_mvm_get_bios_mcc(struct iwl_mvm *mvm, char *mcc)
-{
-	return -ENOENT;
-}
-#endif
-
 int iwl_mvm_init_mcc(struct iwl_mvm *mvm)
 {
 	bool tlv_lar;
@@ -884,7 +793,7 @@ int iwl_mvm_init_mcc(struct iwl_mvm *mvm)
 		return -EIO;
 
 	if (iwl_mvm_is_wifi_mcc_supported(mvm) &&
-	    !iwl_mvm_get_bios_mcc(mvm, mcc)) {
+	    !iwl_get_bios_mcc(mvm->dev, mcc)) {
 		kfree(regd);
 		regd = iwl_mvm_get_regdomain(mvm->hw->wiphy, mcc,
 					     MCC_SOURCE_BIOS, NULL);
-- 
2.9.3
