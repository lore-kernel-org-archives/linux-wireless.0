Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36670 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752337AbdI2Qq3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 12:46:29 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 19:44:15 +0300
Message-Id: <20170929164423.23666-11-luca@coelho.fi> (sfid-20170929_200835_725388_E21459D7)
In-Reply-To: <20170929164423.23666-1-luca@coelho.fi>
References: <20170929164423.23666-1-luca@coelho.fi>
Subject: [PATCH 10/18] iwlwifi: acpi: generalize iwl_mvm_sar_find_wifi_pkg()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Move this function to acpi.c, renaming it to iwl_acpi_get_wifi_pkg(),
because it can also be used with other methods (i.e. SPLC and WRDD).

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c | 52 ++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h | 10 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 60 +++-------------------------
 3 files changed, 68 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index a7b2a48618cd..5a3b75e45f5c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -95,3 +95,55 @@ void *iwl_acpi_get_object(struct device *dev, acpi_string method)
 	return buf.pointer;
 }
 IWL_EXPORT_SYMBOL(iwl_acpi_get_object);
+
+union acpi_object *iwl_acpi_get_wifi_pkg(struct device *dev,
+					 union acpi_object *data,
+					 int data_size)
+{
+	int i;
+	union acpi_object *wifi_pkg;
+
+	/*
+	 * We need at least one entry in the wifi package that
+	 * describes the domain, and one more entry, otherwise there's
+	 * no point in reading it.
+	 */
+	if (WARN_ON_ONCE(data_size < 2))
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * We need at least two packages, one for the revision and one
+	 * for the data itself.  Also check that the revision is valid
+	 * (i.e. it is an integer set to 0).
+	 */
+	if (data->type != ACPI_TYPE_PACKAGE ||
+	    data->package.count < 2 ||
+	    data->package.elements[0].type != ACPI_TYPE_INTEGER ||
+	    data->package.elements[0].integer.value != 0) {
+		IWL_DEBUG_DEV_RADIO(dev, "Unsupported packages structure\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* loop through all the packages to find the one for WiFi */
+	for (i = 1; i < data->package.count; i++) {
+		union acpi_object *domain;
+
+		wifi_pkg = &data->package.elements[i];
+
+		/* skip entries that are not a package with the right size */
+		if (wifi_pkg->type != ACPI_TYPE_PACKAGE ||
+		    wifi_pkg->package.count != data_size)
+			continue;
+
+		domain = &wifi_pkg->package.elements[0];
+		if (domain->type == ACPI_TYPE_INTEGER &&
+		    domain->integer.value == ACPI_WIFI_DOMAIN)
+			goto found;
+	}
+
+	return ERR_PTR(-ENOENT);
+
+found:
+	return wifi_pkg;
+}
+IWL_EXPORT_SYMBOL(iwl_acpi_get_wifi_pkg);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
index be3f49d5713a..f1db619c3ea0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
@@ -91,6 +91,9 @@
 #ifdef CONFIG_ACPI
 
 void *iwl_acpi_get_object(struct device *dev, acpi_string method);
+union acpi_object *iwl_acpi_get_wifi_pkg(struct device *dev,
+					 union acpi_object *data,
+					 int data_size);
 
 #else /* CONFIG_ACPI */
 
@@ -99,5 +102,12 @@ static inline void *iwl_acpi_get_object(struct device *dev, acpi_string method)
 	return ERR_PTR(-ENOENT);
 }
 
+static inline union acpi_object *iwl_acpi_get_wifi_pkg(struct device *dev,
+						       union acpi_object *data,
+						       int data_size)
+{
+	return ERR_PTR(-ENOENT);
+}
+
 #endif /* CONFIG_ACPI */
 #endif /* __iwl_fw_acpi__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 789aa7b74110..7a7b72bf1621 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -599,54 +599,6 @@ static int iwl_mvm_sar_set_profile(struct iwl_mvm *mvm,
 	return 0;
 }
 
-static union acpi_object *iwl_mvm_sar_find_wifi_pkg(struct iwl_mvm *mvm,
-						    union acpi_object *data,
-						    int data_size)
-{
-	union acpi_object *wifi_pkg = NULL;
-	int i;
-
-	/*
-	 * We need at least two packages, one for the revision and one
-	 * for the data itself.  Also check that the revision is valid
-	 * (i.e. it is an integer set to 0).
-	 */
-	if (data->type != ACPI_TYPE_PACKAGE ||
-	    data->package.count < 2 ||
-	    data->package.elements[0].type != ACPI_TYPE_INTEGER ||
-	    data->package.elements[0].integer.value != 0) {
-		IWL_DEBUG_RADIO(mvm, "Unsupported packages structure\n");
-		return ERR_PTR(-EINVAL);
-	}
-
-	/* loop through all the packages to find the one for WiFi */
-	for (i = 1; i < data->package.count; i++) {
-		union acpi_object *domain;
-
-		wifi_pkg = &data->package.elements[i];
-
-		/* Skip anything that is not a package with the right
-		 * amount of elements (i.e. domain_type,
-		 * enabled/disabled plus the actual data size.
-		 */
-		if (wifi_pkg->type != ACPI_TYPE_PACKAGE ||
-		    wifi_pkg->package.count != data_size)
-			continue;
-
-		domain = &wifi_pkg->package.elements[0];
-		if (domain->type == ACPI_TYPE_INTEGER &&
-		    domain->integer.value == ACPI_WIFI_DOMAIN)
-			break;
-
-		wifi_pkg = NULL;
-	}
-
-	if (!wifi_pkg)
-		return ERR_PTR(-ENOENT);
-
-	return wifi_pkg;
-}
-
 static int iwl_mvm_sar_get_wrds_table(struct iwl_mvm *mvm)
 {
 	union acpi_object *wifi_pkg, *table, *data;
@@ -657,8 +609,8 @@ static int iwl_mvm_sar_get_wrds_table(struct iwl_mvm *mvm)
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-	wifi_pkg = iwl_mvm_sar_find_wifi_pkg(mvm, data,
-					     ACPI_WRDS_WIFI_DATA_SIZE);
+	wifi_pkg = iwl_acpi_get_wifi_pkg(mvm->dev, data,
+					 ACPI_WRDS_WIFI_DATA_SIZE);
 	if (IS_ERR(wifi_pkg)) {
 		ret = PTR_ERR(wifi_pkg);
 		goto out_free;
@@ -694,8 +646,8 @@ static int iwl_mvm_sar_get_ewrd_table(struct iwl_mvm *mvm)
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-	wifi_pkg = iwl_mvm_sar_find_wifi_pkg(mvm, data,
-					     ACPI_EWRD_WIFI_DATA_SIZE);
+	wifi_pkg = iwl_acpi_get_wifi_pkg(mvm->dev, data,
+					 ACPI_EWRD_WIFI_DATA_SIZE);
 	if (IS_ERR(wifi_pkg)) {
 		ret = PTR_ERR(wifi_pkg);
 		goto out_free;
@@ -750,8 +702,8 @@ static int iwl_mvm_sar_get_wgds_table(struct iwl_mvm *mvm)
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-	wifi_pkg = iwl_mvm_sar_find_wifi_pkg(mvm, data,
-					     ACPI_WGDS_WIFI_DATA_SIZE);
+	wifi_pkg = iwl_acpi_get_wifi_pkg(mvm->dev, data,
+					 ACPI_WGDS_WIFI_DATA_SIZE);
 	if (IS_ERR(wifi_pkg)) {
 		ret = PTR_ERR(wifi_pkg);
 		goto out_free;
-- 
2.14.1
