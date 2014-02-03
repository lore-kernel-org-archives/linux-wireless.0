Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:37341 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaBCU7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:08 -0500
Received: by mail-ee0-f43.google.com with SMTP id c41so3931669eek.30
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:07 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>, Ido Yariv <idox.yariv@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/62] iwlwifi: pcie: retrieve and parse ACPI power limitations
Date: Mon,  3 Feb 2014 22:57:38 +0200
Message-Id: <1391461088-8082-32-git-send-email-egrumbach@gmail.com> (sfid-20140203_220009_116842_D8A6415E)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Some platforms may have power limitations on PCIe cards connected to
specific root ports.

This information is encoded as part of the ACPI tables, for instance:
<snip>
           Name (SPLX, Package (0x02)
           {
               Zero,
               Package (0x03)
               {
                   0x07,
                   0x00000500,
                   0x80000000
               }
           })

           Method (SPLC, 0, Serialized)
           {
               Return (SPLX)
           }
</snip>

The structure returned contains the domain type, the default power
limitation and the default time window (reserved for future use).

Upon PCI probing, call the relevant ACPI method, parse the returned
structure, and save the power limitation.

Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h |    3 ++
 drivers/net/wireless/iwlwifi/pcie/drv.c  |   78 ++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 1f065cf..a350abe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -523,6 +523,7 @@ enum iwl_trans_state {
  *	starting the firmware, used for tracing
  * @rx_mpdu_cmd_hdr_size: used for tracing, amount of data before the
  *	start of the 802.11 header in the @rx_mpdu_cmd
+ * @dflt_pwr_limit: default power limit fetched from the platform (ACPI)
  */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
@@ -551,6 +552,8 @@ struct iwl_trans {
 	struct lockdep_map sync_cmd_lockdep_map;
 #endif
 
+	u64 dflt_pwr_limit;
+
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
 	char trans_specific[0] __aligned(sizeof(void *));
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 4b3a49b..8577939 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -66,6 +66,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/pci-aspm.h>
+#include <linux/acpi.h>
 
 #include "iwl-trans.h"
 #include "iwl-drv.h"
@@ -395,6 +396,81 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 };
 MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
 
+#ifdef CONFIG_ACPI
+#define SPL_METHOD		"SPLC"
+#define SPL_DOMAINTYPE_MODULE	BIT(0)
+#define SPL_DOMAINTYPE_WIFI	BIT(1)
+#define SPL_DOMAINTYPE_WIGIG	BIT(2)
+#define SPL_DOMAINTYPE_RFEM	BIT(3)
+
+static u64 splx_get_pwr_limit(struct iwl_trans *trans, union acpi_object *splx)
+{
+	union acpi_object *limits, *domain_type, *power_limit;
+
+	if (splx->type != ACPI_TYPE_PACKAGE ||
+	    splx->package.count != 2 ||
+	    splx->package.elements[0].type != ACPI_TYPE_INTEGER ||
+	    splx->package.elements[0].integer.value != 0) {
+		IWL_ERR(trans, "Unsupported splx structure");
+		return 0;
+	}
+
+	limits = &splx->package.elements[1];
+	if (limits->type != ACPI_TYPE_PACKAGE ||
+	    limits->package.count < 2 ||
+	    limits->package.elements[0].type != ACPI_TYPE_INTEGER ||
+	    limits->package.elements[1].type != ACPI_TYPE_INTEGER) {
+		IWL_ERR(trans, "Invalid limits element");
+		return 0;
+	}
+
+	domain_type = &limits->package.elements[0];
+	power_limit = &limits->package.elements[1];
+	if (!(domain_type->integer.value & SPL_DOMAINTYPE_WIFI)) {
+		IWL_DEBUG_INFO(trans, "WiFi power is not limited");
+		return 0;
+	}
+
+	return power_limit->integer.value;
+}
+
+static void set_dflt_pwr_limit(struct iwl_trans *trans, struct pci_dev *pdev)
+{
+	acpi_handle pxsx_handle;
+	acpi_handle handle;
+	struct acpi_buffer splx = {ACPI_ALLOCATE_BUFFER, NULL};
+	acpi_status status;
+
+	pxsx_handle = ACPI_HANDLE(&pdev->dev);
+	if (!pxsx_handle) {
+		IWL_ERR(trans, "Could not retrieve root port ACPI handle");
+		return;
+	}
+
+	/* Get the method's handle */
+	status = acpi_get_handle(pxsx_handle, (acpi_string)SPL_METHOD, &handle);
+	if (ACPI_FAILURE(status)) {
+		IWL_DEBUG_INFO(trans, "SPL method not found");
+		return;
+	}
+
+	/* Call SPLC with no arguments */
+	status = acpi_evaluate_object(handle, NULL, NULL, &splx);
+	if (ACPI_FAILURE(status)) {
+		IWL_ERR(trans, "SPLC invocation failed (0x%x)", status);
+		return;
+	}
+
+	trans->dflt_pwr_limit = splx_get_pwr_limit(trans, splx.pointer);
+	IWL_DEBUG_INFO(trans, "Default power limit set to %lld",
+		       trans->dflt_pwr_limit);
+	kfree(splx.pointer);
+}
+
+#else /* CONFIG_ACPI */
+static void set_dflt_pwr_limit(struct iwl_trans *trans, struct pci_dev *pdev) {}
+#endif
+
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
 
@@ -419,6 +495,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_free_trans;
 	}
 
+	set_dflt_pwr_limit(iwl_trans, pdev);
+
 	/* register transport layer debugfs here */
 	ret = iwl_trans_dbgfs_register(iwl_trans, iwl_trans->dbgfs_dir);
 	if (ret)
-- 
1.7.9.5

