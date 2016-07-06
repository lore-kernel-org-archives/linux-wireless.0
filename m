Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33370 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751243AbcGFKoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:27 +0300
Message-Id: <1467801651-1816-32-git-send-email-luca@coelho.fi> (sfid-20160706_124422_530395_83C50E88)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 32/56] iwlwifi: mvm: read SAR BIOS table from ACPI
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Read the SAR BIOS table from the ACPI and parse it into the
iwl_mvm_sar_table structure.  If the table is enabled, send it to the
firmware via REDUCE_TX_POWER_CMD.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 173 ++++++++++++++++++++++++++++
 1 file changed, 173 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 510b4c1..4db1d84 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -65,6 +65,7 @@
  *****************************************************************************/
 #include <net/mac80211.h>
 #include <linux/netdevice.h>
+#include <linux/acpi.h>
 
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
@@ -902,6 +903,174 @@ static int iwl_mvm_config_ltr(struct iwl_mvm *mvm)
 				    sizeof(cmd), &cmd);
 }
 
+#define ACPI_WRDS_METHOD	"WRDS"
+#define ACPI_WRDS_WIFI		(0x07)
+#define ACPI_WRDS_TABLE_SIZE	10
+
+struct iwl_mvm_sar_table {
+	bool enabled;
+	u8 values[ACPI_WRDS_TABLE_SIZE];
+};
+
+#ifdef CONFIG_ACPI
+static int iwl_mvm_sar_get_wrds(struct iwl_mvm *mvm, union acpi_object *wrds,
+				struct iwl_mvm_sar_table *sar_table)
+{
+	union acpi_object *data_pkg;
+	u32 i;
+
+	/* We need at least two packages, one for the revision and one
+	 * for the data itself.  Also check that the revision is valid
+	 * (i.e. it is an integer set to 0).
+	*/
+	if (wrds->type != ACPI_TYPE_PACKAGE ||
+	    wrds->package.count < 2 ||
+	    wrds->package.elements[0].type != ACPI_TYPE_INTEGER ||
+	    wrds->package.elements[0].integer.value != 0) {
+		IWL_DEBUG_RADIO(mvm, "Unsupported wrds structure\n");
+		return -EINVAL;
+	}
+
+	/* loop through all the packages to find the one for WiFi */
+	for (i = 1; i < wrds->package.count; i++) {
+		union acpi_object *domain;
+
+		data_pkg = &wrds->package.elements[i];
+
+		/* Skip anything that is not a package with the right
+		 * amount of elements (i.e. domain_type,
+		 * enabled/disabled plus the sar table size.
+		 */
+		if (data_pkg->type != ACPI_TYPE_PACKAGE ||
+		    data_pkg->package.count != ACPI_WRDS_TABLE_SIZE + 2)
+			continue;
+
+		domain = &data_pkg->package.elements[0];
+		if (domain->type == ACPI_TYPE_INTEGER &&
+		    domain->integer.value == ACPI_WRDS_WIFI)
+			break;
+
+		data_pkg = NULL;
+	}
+
+	if (!data_pkg)
+		return -ENOENT;
+
+	if (data_pkg->package.elements[1].type != ACPI_TYPE_INTEGER)
+		return -EINVAL;
+
+	sar_table->enabled = !!(data_pkg->package.elements[1].integer.value);
+
+	for (i = 0; i < ACPI_WRDS_TABLE_SIZE; i++) {
+		union acpi_object *entry;
+
+		entry = &data_pkg->package.elements[i + 2];
+		if ((entry->type != ACPI_TYPE_INTEGER) ||
+		    (entry->integer.value > U8_MAX))
+			return -EINVAL;
+
+		sar_table->values[i] = entry->integer.value;
+	}
+
+	return 0;
+}
+
+static int iwl_mvm_sar_get_table(struct iwl_mvm *mvm,
+				 struct iwl_mvm_sar_table *sar_table)
+{
+	acpi_handle root_handle;
+	acpi_handle handle;
+	struct acpi_buffer wrds = {ACPI_ALLOCATE_BUFFER, NULL};
+	acpi_status status;
+	int ret;
+
+	root_handle = ACPI_HANDLE(mvm->dev);
+	if (!root_handle) {
+		IWL_DEBUG_RADIO(mvm,
+				"Could not retrieve root port ACPI handle\n");
+		return -ENOENT;
+	}
+
+	/* Get the method's handle */
+	status = acpi_get_handle(root_handle, (acpi_string)ACPI_WRDS_METHOD,
+				 &handle);
+	if (ACPI_FAILURE(status)) {
+		IWL_DEBUG_RADIO(mvm, "WRDS method not found\n");
+		return -ENOENT;
+	}
+
+	/* Call WRDS with no arguments */
+	status = acpi_evaluate_object(handle, NULL, NULL, &wrds);
+	if (ACPI_FAILURE(status)) {
+		IWL_DEBUG_RADIO(mvm, "WRDS invocation failed (0x%x)\n", status);
+		return -ENOENT;
+	}
+
+	ret = iwl_mvm_sar_get_wrds(mvm, wrds.pointer, sar_table);
+	kfree(wrds.pointer);
+
+	return ret;
+}
+#else /* CONFIG_ACPI */
+static int iwl_mvm_sar_get_table(struct iwl_mvm *mvm,
+				 struct iwl_mvm_sar_table *sar_table)
+{
+	return -ENOENT;
+}
+#endif /* CONFIG_ACPI */
+
+static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
+{
+	struct iwl_mvm_sar_table sar_table;
+	struct iwl_dev_tx_power_cmd cmd = {
+		.v2.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_CHAINS),
+	};
+	int ret, i, j, idx;
+
+	/* we can't do anything with the table if the FW doesn't support it */
+	if (!fw_has_api(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_API_TX_POWER_CHAIN)) {
+		IWL_DEBUG_RADIO(mvm,
+				"FW doesn't support per-chain TX power settings.\n");
+		return 0;
+	}
+
+	ret = iwl_mvm_sar_get_table(mvm, &sar_table);
+	if (ret < 0) {
+		IWL_DEBUG_RADIO(mvm,
+				"SAR BIOS table invalid or unavailable. (%d)\n",
+				ret);
+		/* we don't fail if the table is not available */
+		return 0;
+	}
+
+	if (!sar_table.enabled)
+		return 0;
+
+	IWL_DEBUG_RADIO(mvm, "Sending REDUCE_TX_POWER_CMD per chain\n");
+
+	BUILD_BUG_ON(IWL_NUM_CHAIN_LIMITS * IWL_NUM_SUB_BANDS !=
+		     ACPI_WRDS_TABLE_SIZE);
+
+	for (i = 0; i < IWL_NUM_CHAIN_LIMITS; i++) {
+		IWL_DEBUG_RADIO(mvm, "  Chain[%d]:\n", i);
+		for (j = 0; j < IWL_NUM_SUB_BANDS; j++) {
+			idx = (i * IWL_NUM_SUB_BANDS) + j;
+			cmd.per_chain_restriction[i][j] =
+				cpu_to_le16(sar_table.values[idx]);
+			IWL_DEBUG_RADIO(mvm, "    Band[%d] = %d * .125dBm\n",
+					j, sar_table.values[idx]);
+		}
+	}
+
+	ret = iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0,
+				   sizeof(cmd), &cmd);
+	if (ret)
+		IWL_ERR(mvm, "failed to set per-chain TX power: %d\n", ret);
+
+	return ret;
+}
+
 int iwl_mvm_up(struct iwl_mvm *mvm)
 {
 	int ret, i;
@@ -1077,6 +1246,10 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
 		iwl_mvm_unref(mvm, IWL_MVM_REF_UCODE_DOWN);
 
+	ret = iwl_mvm_sar_init(mvm);
+	if (ret)
+		goto error;
+
 	IWL_DEBUG_INFO(mvm, "RT uCode started.\n");
 	return 0;
  error:
-- 
2.8.1

