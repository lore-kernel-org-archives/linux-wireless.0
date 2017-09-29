Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36616 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752522AbdI2QqS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 12:46:18 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 19:44:19 +0300
Message-Id: <20170929164423.23666-15-luca@coelho.fi> (sfid-20170929_200836_529517_D9A034D7)
In-Reply-To: <20170929164423.23666-1-luca@coelho.fi>
References: <20170929164423.23666-1-luca@coelho.fi>
Subject: [PATCH 14/18] iwlwifi: acpi: move function to get mcc into acpi code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The iwl_get_bios_mcc() function was in the iwl-nvm-parse.c file, but
it has nothing to do with the NVM.  Move it to fw/acpi.c and rename it
to iwl_acpi_get_mcc().

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       | 34 ++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       | 15 ++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 34 ----------------------
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h | 10 -------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |  3 +-
 6 files changed, 51 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index 5a3b75e45f5c..adce36112b7f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -147,3 +147,37 @@ union acpi_object *iwl_acpi_get_wifi_pkg(struct device *dev,
 	return wifi_pkg;
 }
 IWL_EXPORT_SYMBOL(iwl_acpi_get_wifi_pkg);
+
+int iwl_acpi_get_mcc(struct device *dev, char *mcc)
+{
+	union acpi_object *wifi_pkg, *data;
+	u32 mcc_val;
+	int ret;
+
+	data = iwl_acpi_get_object(dev, ACPI_WRDD_METHOD);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	wifi_pkg = iwl_acpi_get_wifi_pkg(dev, data, ACPI_WRDD_WIFI_DATA_SIZE);
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
+	mcc_val = wifi_pkg->package.elements[1].integer.value;
+
+	mcc[0] = (mcc_val >> 8) & 0xff;
+	mcc[1] = mcc_val & 0xff;
+	mcc[2] = '\0';
+
+	ret = 0;
+out_free:
+	kfree(data);
+	return ret;
+}
+IWL_EXPORT_SYMBOL(iwl_acpi_get_mcc);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
index a7deb62f3f86..fe9c1066c3b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
@@ -98,6 +98,16 @@ union acpi_object *iwl_acpi_get_wifi_pkg(struct device *dev,
 					 union acpi_object *data,
 					 int data_size);
 
+/**
+ * iwl_acpi_get_mcc - read MCC from ACPI, if available
+ *
+ * @dev: the struct device
+ * @mcc: output buffer (3 bytes) that will get the MCC
+ *
+ * This function tries to read the current MCC from ACPI if available.
+ */
+int iwl_acpi_get_mcc(struct device *dev, char *mcc);
+
 #else /* CONFIG_ACPI */
 
 static inline void *iwl_acpi_get_object(struct device *dev, acpi_string method)
@@ -112,5 +122,10 @@ static inline union acpi_object *iwl_acpi_get_wifi_pkg(struct device *dev,
 	return ERR_PTR(-ENOENT);
 }
 
+static inline int iwl_acpi_get_mcc(struct device *dev, char *mcc)
+{
+	return -ENOENT;
+}
+
 #endif /* CONFIG_ACPI */
 #endif /* __iwl_fw_acpi__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index d98318f93b9e..d9a2ea9dd93f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -944,37 +944,3 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 	return regd;
 }
 IWL_EXPORT_SYMBOL(iwl_parse_nvm_mcc_info);
-
-int iwl_get_bios_mcc(struct device *dev, char *mcc)
-{
-	union acpi_object *wifi_pkg, *data;
-	u32 mcc_val;
-	int ret;
-
-	data = iwl_acpi_get_object(dev, ACPI_WRDD_METHOD);
-	if (IS_ERR(data))
-		return PTR_ERR(data);
-
-	wifi_pkg = iwl_acpi_get_wifi_pkg(dev, data, ACPI_WRDD_WIFI_DATA_SIZE);
-	if (IS_ERR(wifi_pkg)) {
-		ret = PTR_ERR(wifi_pkg);
-		goto out_free;
-	}
-
-	if (wifi_pkg->package.elements[1].type != ACPI_TYPE_INTEGER) {
-		ret = -EINVAL;
-		goto out_free;
-	}
-
-	mcc_val = wifi_pkg->package.elements[1].integer.value;
-
-	mcc[0] = (mcc_val >> 8) & 0xff;
-	mcc[1] = mcc_val & 0xff;
-	mcc[2] = '\0';
-
-	ret = 0;
-out_free:
-	kfree(data);
-	return ret;
-}
-IWL_EXPORT_SYMBOL(iwl_get_bios_mcc);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
index a39bd5c17c26..306736c7a042 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
@@ -109,14 +109,4 @@ struct ieee80211_regdomain *
 iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 		       int num_of_ch, __le32 *channels, u16 fw_mcc);
 
-/**
- * iwl_get_bios_mcc - read MCC from BIOS, if available
- *
- * @dev: the struct device
- * @mcc: output buffer (3 bytes) that will get the MCC
- *
- * This function tries to read the current MCC from ACPI if available.
- */
-int iwl_get_bios_mcc(struct device *dev, char *mcc);
-
 #endif /* __iwl_nvm_parse_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 7a7b72bf1621..f476882291ae 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -74,7 +74,6 @@
 #include "iwl-csr.h" /* for iwl_mvm_rx_card_state_notif */
 #include "iwl-io.h" /* for iwl_mvm_rx_card_state_notif */
 #include "iwl-prph.h"
-#include "iwl-eeprom-parse.h"
 #include "fw/acpi.h"
 
 #include "mvm.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 422aa6be9932..f4a5fcf4cc1f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -73,6 +73,7 @@
 #include "iwl-eeprom-read.h"
 #include "iwl-nvm-parse.h"
 #include "iwl-prph.h"
+#include "fw/acpi.h"
 
 /* Default NVM size to read */
 #define IWL_NVM_DEFAULT_CHUNK_SIZE (2*1024)
@@ -775,7 +776,7 @@ int iwl_mvm_init_mcc(struct iwl_mvm *mvm)
 		return -EIO;
 
 	if (iwl_mvm_is_wifi_mcc_supported(mvm) &&
-	    !iwl_get_bios_mcc(mvm->dev, mcc)) {
+	    !iwl_acpi_get_mcc(mvm->dev, mcc)) {
 		kfree(regd);
 		regd = iwl_mvm_get_regdomain(mvm->hw->wiphy, mcc,
 					     MCC_SOURCE_BIOS, NULL);
-- 
2.14.1
