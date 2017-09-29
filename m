Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36562 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752522AbdI2QqI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 12:46:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 19:44:21 +0300
Message-Id: <20170929164423.23666-17-luca@coelho.fi> (sfid-20170929_200836_799632_FBB68865)
In-Reply-To: <20170929164423.23666-1-luca@coelho.fi>
References: <20170929164423.23666-1-luca@coelho.fi>
Subject: [PATCH 16/18] iwlwifi: acpi: move code that reads SPLC to acpi
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Move most of the set_dflt_pwr_limit() function to acpi.c and make it
return the pwr_limit value instead of setting directly.  Also rename
it to iwl_acpi_get_pwr_limit().

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  | 27 +++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  |  7 +++++++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 25 ++-----------------------
 3 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index adce36112b7f..75cae54ea7de 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -181,3 +181,30 @@ int iwl_acpi_get_mcc(struct device *dev, char *mcc)
 	return ret;
 }
 IWL_EXPORT_SYMBOL(iwl_acpi_get_mcc);
+
+u64 iwl_acpi_get_pwr_limit(struct device *dev)
+{
+	union acpi_object *data, *wifi_pkg;
+	u64 dflt_pwr_limit;
+
+	data = iwl_acpi_get_object(dev, ACPI_SPLC_METHOD);
+	if (IS_ERR(data)) {
+		dflt_pwr_limit = 0;
+		goto out;
+	}
+
+	wifi_pkg = iwl_acpi_get_wifi_pkg(dev, data,
+					 ACPI_SPLC_WIFI_DATA_SIZE);
+	if (IS_ERR(wifi_pkg) ||
+	    wifi_pkg->package.elements[1].integer.value != ACPI_TYPE_INTEGER) {
+		dflt_pwr_limit = 0;
+		goto out_free;
+	}
+
+	dflt_pwr_limit = wifi_pkg->package.elements[1].integer.value;
+out_free:
+	kfree(data);
+out:
+	return dflt_pwr_limit;
+}
+IWL_EXPORT_SYMBOL(iwl_acpi_get_pwr_limit);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
index fe9c1066c3b6..cb5f32c1d705 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
@@ -108,6 +108,8 @@ union acpi_object *iwl_acpi_get_wifi_pkg(struct device *dev,
  */
 int iwl_acpi_get_mcc(struct device *dev, char *mcc);
 
+u64 iwl_acpi_get_pwr_limit(struct device *dev);
+
 #else /* CONFIG_ACPI */
 
 static inline void *iwl_acpi_get_object(struct device *dev, acpi_string method)
@@ -127,5 +129,10 @@ static inline int iwl_acpi_get_mcc(struct device *dev, char *mcc)
 	return -ENOENT;
 }
 
+static inline u64 iwl_acpi_get_pwr_limit(struct device *dev)
+{
+	return 0;
+}
+
 #endif /* CONFIG_ACPI */
 #endif /* __iwl_fw_acpi__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 08f71b4297be..d81f2414fd8e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -78,6 +78,7 @@
 #include "iwl-trans.h"
 #include "iwl-drv.h"
 #include "internal.h"
+#include "fw/acpi.h"
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
 	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
@@ -587,28 +588,6 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
 
-static void set_dflt_pwr_limit(struct iwl_trans *trans, struct pci_dev *pdev)
-{
-	union acpi_object *data, *wifi_pkg;
-
-	data = iwl_acpi_get_object(trans->dev, ACPI_SPLC_METHOD);
-	if (IS_ERR(data))
-		return;
-
-	wifi_pkg = iwl_acpi_get_wifi_pkg(trans->dev, data,
-					 ACPI_SPLC_WIFI_DATA_SIZE);
-	if (IS_ERR(wifi_pkg) ||
-	    wifi_pkg->package.elements[1].integer.value != ACPI_TYPE_INTEGER)
-		goto out;
-
-	trans->dflt_pwr_limit = wifi_pkg->package.elements[1].integer.value;
-
-	IWL_DEBUG_INFO(trans, "Default power limit set to %lld\n",
-		       trans->dflt_pwr_limit);
-out:
-	kfree(data);
-}
-
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
 
@@ -672,7 +651,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_free_trans;
 	}
 
-	set_dflt_pwr_limit(iwl_trans, pdev);
+	iwl_trans->dflt_pwr_limit = iwl_acpi_get_pwr_limit(iwl_trans->dev);
 
 	/* register transport layer debugfs here */
 	ret = iwl_trans_pcie_dbgfs_register(iwl_trans);
-- 
2.14.1
