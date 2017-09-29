Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36534 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752159AbdI2QqB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 12:46:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 19:44:18 +0300
Message-Id: <20170929164423.23666-14-luca@coelho.fi> (sfid-20170929_200836_925263_9CC3C9A1)
In-Reply-To: <20170929164423.23666-1-luca@coelho.fi>
References: <20170929164423.23666-1-luca@coelho.fi>
Subject: [PATCH 13/18] iwlwifi: acpi: remove a couple of unnecessary ifdefs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Some of the #ifdef CONFIG_ACPI are not needed anymore, so they can be
removed.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  | 2 --
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 6 ------
 2 files changed, 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index d6c9e8a8df5b..7fa7849367ef 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -684,7 +684,6 @@ enum iwl_mvm_queue_status {
 
 #define IWL_MVM_NUM_CIPHERS             10
 
-#ifdef CONFIG_ACPI
 struct iwl_mvm_sar_profile {
 	bool enabled;
 	u8 table[ACPI_SAR_TABLE_SIZE];
@@ -693,7 +692,6 @@ struct iwl_mvm_sar_profile {
 struct iwl_mvm_geo_profile {
 	u8 values[ACPI_GEO_TABLE_SIZE];
 };
-#endif
 
 struct iwl_mvm {
 	/* for logger access */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index b5fce721b0b0..08f71b4297be 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -587,8 +587,6 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
 
-#ifdef CONFIG_ACPI
-
 static void set_dflt_pwr_limit(struct iwl_trans *trans, struct pci_dev *pdev)
 {
 	union acpi_object *data, *wifi_pkg;
@@ -611,10 +609,6 @@ static void set_dflt_pwr_limit(struct iwl_trans *trans, struct pci_dev *pdev)
 	kfree(data);
 }
 
-#else /* CONFIG_ACPI */
-static void set_dflt_pwr_limit(struct iwl_trans *trans, struct pci_dev *pdev) {}
-#endif
-
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
 
-- 
2.14.1
