Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbbCLNFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:48 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Jonathan Doron <jonathanx.doron@intel.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/49] iwlwifi: mvm: support LAR updates from BIOS
Date: Thu, 12 Mar 2015 15:04:03 +0200
Message-Id: <1426165474-25586-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140553_034736_19E2A26C)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jonathan Doron <jonathanx.doron@intel.com>

When booting the card, check for a dedicated regulatory ACPI entry. If
such exists, read it and give the information to FW with the appropriate
source.

Signed-off-by: Jonathan Doron <jonathanx.doron@intel.com>
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/nvm.c | 103 +++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 41189e5..d08ea69 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -64,6 +64,8 @@
  *****************************************************************************/
 #include <linux/firmware.h>
 #include <linux/rtnetlink.h>
+#include <linux/pci.h>
+#include <linux/acpi.h>
 #include "iwl-trans.h"
 #include "iwl-csr.h"
 #include "mvm.h"
@@ -670,12 +672,104 @@ exit:
 	return resp_cp;
 }
 
+#ifdef CONFIG_ACPI
+#define WRD_METHOD		"WRDD"
+#define WRDD_WIFI		(0x07)
+#define WRDD_WIGIG		(0x10)
+
+static u32 iwl_mvm_wrdd_get_mcc(struct iwl_mvm *mvm, union acpi_object *wrdd)
+{
+	union acpi_object *mcc_pkg, *domain_type, *mcc_value;
+	u32 i;
+
+	if (wrdd->type != ACPI_TYPE_PACKAGE ||
+	    wrdd->package.count < 2 ||
+	    wrdd->package.elements[0].type != ACPI_TYPE_INTEGER ||
+	    wrdd->package.elements[0].integer.value != 0) {
+		IWL_DEBUG_LAR(mvm, "Unsupported wrdd structure\n");
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
+static int iwl_mvm_get_bios_mcc(struct iwl_mvm *mvm, char *mcc)
+{
+	acpi_handle root_handle;
+	acpi_handle handle;
+	struct acpi_buffer wrdd = {ACPI_ALLOCATE_BUFFER, NULL};
+	acpi_status status;
+	u32 mcc_val;
+	struct pci_dev *pdev = to_pci_dev(mvm->dev);
+
+	root_handle = ACPI_HANDLE(&pdev->dev);
+	if (!root_handle) {
+		IWL_DEBUG_LAR(mvm,
+			      "Could not retrieve root port ACPI handle\n");
+		return -ENOENT;
+	}
+
+	/* Get the method's handle */
+	status = acpi_get_handle(root_handle, (acpi_string)WRD_METHOD, &handle);
+	if (ACPI_FAILURE(status)) {
+		IWL_DEBUG_LAR(mvm, "WRD method not found\n");
+		return -ENOENT;
+	}
+
+	/* Call WRDD with no arguments */
+	status = acpi_evaluate_object(handle, NULL, NULL, &wrdd);
+	if (ACPI_FAILURE(status)) {
+		IWL_DEBUG_LAR(mvm, "WRDC invocation failed (0x%x)\n", status);
+		return -ENOENT;
+	}
+
+	mcc_val = iwl_mvm_wrdd_get_mcc(mvm, wrdd.pointer);
+	kfree(wrdd.pointer);
+	if (!mcc_val)
+		return -ENOENT;
+
+	mcc[0] = (mcc_val >> 8) & 0xff;
+	mcc[1] = mcc_val & 0xff;
+	mcc[2] = '\0';
+	return 0;
+}
+#else /* CONFIG_ACPI */
+static int iwl_mvm_get_bios_mcc(struct iwl_mvm *mvm, char *mcc)
+{
+	return -ENOENT;
+}
+#endif
+
 int iwl_mvm_init_mcc(struct iwl_mvm *mvm)
 {
 	bool tlv_lar;
 	bool nvm_lar;
 	int retval;
 	struct ieee80211_regdomain *regd;
+	char mcc[3];
 
 	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_8000) {
 		tlv_lar = mvm->fw->ucode_capa.capa[0] &
@@ -712,6 +806,15 @@ int iwl_mvm_init_mcc(struct iwl_mvm *mvm)
 	if (IS_ERR_OR_NULL(regd))
 		return -EIO;
 
+	if (iwl_mvm_is_wifi_mcc_supported(mvm) &&
+	    !iwl_mvm_get_bios_mcc(mvm, mcc)) {
+		kfree(regd);
+		regd = iwl_mvm_get_regdomain(mvm->hw->wiphy, mcc,
+					     MCC_SOURCE_BIOS);
+		if (IS_ERR_OR_NULL(regd))
+			return -EIO;
+	}
+
 	retval = regulatory_set_wiphy_regd_sync_rtnl(mvm->hw->wiphy, regd);
 	kfree(regd);
 	return retval;
-- 
1.9.1

