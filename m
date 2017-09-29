Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36544 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752522AbdI2QqE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 12:46:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 19:44:16 +0300
Message-Id: <20170929164423.23666-12-luca@coelho.fi> (sfid-20170929_200835_881555_02D0C83A)
In-Reply-To: <20170929164423.23666-1-luca@coelho.fi>
References: <20170929164423.23666-1-luca@coelho.fi>
Subject: [PATCH 11/18] iwlwifi: acpi: use iwl_acpi_get_wifi_pkg when reading reading SPLC
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Instead of finding the wifi package with its own code, we can reuse
the new iwl_acpi_get_wifi_pkg() function when reading the default
power limit from SPLC.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  |  2 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 61 +++++----------------------
 2 files changed, 12 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
index f1db619c3ea0..f5c8c856311a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
@@ -85,6 +85,8 @@
 #define ACPI_EWRD_WIFI_DATA_SIZE	((ACPI_SAR_PROFILE_NUM - 1) * \
 					 ACPI_SAR_TABLE_SIZE + 3)
 #define ACPI_WGDS_WIFI_DATA_SIZE	18
+#define ACPI_SPLC_WIFI_DATA_SIZE	2
+
 #define ACPI_WGDS_NUM_BANDS		2
 #define ACPI_WGDS_TABLE_SIZE		3
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index a6c4f096cb19..b5fce721b0b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -588,67 +588,26 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
 
 #ifdef CONFIG_ACPI
-static u64 splc_get_pwr_limit(struct iwl_trans *trans, union acpi_object *splc)
-{
-	union acpi_object *data_pkg, *dflt_pwr_limit;
-	int i;
-
-	/* We need at least two elements, one for the revision and one
-	 * for the data itself.  Also check that the revision is
-	 * supported (currently only revision 0).
-	*/
-	if (splc->type != ACPI_TYPE_PACKAGE ||
-	    splc->package.count < 2 ||
-	    splc->package.elements[0].type != ACPI_TYPE_INTEGER ||
-	    splc->package.elements[0].integer.value != 0) {
-		IWL_DEBUG_INFO(trans,
-			       "Unsupported structure returned by the SPLC method.  Ignoring.\n");
-		return 0;
-	}
-
-	/* loop through all the packages to find the one for WiFi */
-	for (i = 1; i < splc->package.count; i++) {
-		union acpi_object *domain;
-
-		data_pkg = &splc->package.elements[i];
-
-		/* Skip anything that is not a package with the right
-		 * amount of elements (i.e. at least 2 integers).
-		 */
-		if (data_pkg->type != ACPI_TYPE_PACKAGE ||
-		    data_pkg->package.count < 2 ||
-		    data_pkg->package.elements[0].type != ACPI_TYPE_INTEGER ||
-		    data_pkg->package.elements[1].type != ACPI_TYPE_INTEGER)
-			continue;
-
-		domain = &data_pkg->package.elements[0];
-		if (domain->integer.value == ACPI_WIFI_DOMAIN)
-			break;
-
-		data_pkg = NULL;
-	}
-
-	if (!data_pkg) {
-		IWL_DEBUG_INFO(trans,
-			       "No element for the WiFi domain returned by the SPLC method.\n");
-		return 0;
-	}
-
-	dflt_pwr_limit = &data_pkg->package.elements[1];
-	return dflt_pwr_limit->integer.value;
-}
 
 static void set_dflt_pwr_limit(struct iwl_trans *trans, struct pci_dev *pdev)
 {
-	union acpi_object *data;
+	union acpi_object *data, *wifi_pkg;
 
 	data = iwl_acpi_get_object(trans->dev, ACPI_SPLC_METHOD);
 	if (IS_ERR(data))
 		return;
 
-	trans->dflt_pwr_limit = splc_get_pwr_limit(trans, data);
+	wifi_pkg = iwl_acpi_get_wifi_pkg(trans->dev, data,
+					 ACPI_SPLC_WIFI_DATA_SIZE);
+	if (IS_ERR(wifi_pkg) ||
+	    wifi_pkg->package.elements[1].integer.value != ACPI_TYPE_INTEGER)
+		goto out;
+
+	trans->dflt_pwr_limit = wifi_pkg->package.elements[1].integer.value;
+
 	IWL_DEBUG_INFO(trans, "Default power limit set to %lld\n",
 		       trans->dflt_pwr_limit);
+out:
 	kfree(data);
 }
 
-- 
2.14.1
