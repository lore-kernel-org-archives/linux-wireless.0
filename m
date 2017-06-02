Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60844 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751147AbdFBL1B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:27:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:42 +0300
Message-Id: <20170602112553.2466-15-luca@coelho.fi> (sfid-20170602_132705_470444_D4DAB19A)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 14/25] iwlwifi: update device ID for a000 family
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Three configurations will share device ID 2720, and will
be differentiated by RF ID.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |  3 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 12 +++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index fa120fb55373..c9481b23b1a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -348,7 +348,8 @@ enum {
 
 /* RF_ID value */
 #define CSR_HW_RF_ID_TYPE_JF		(0x00105000)
-#define CSR_HW_RF_ID_TYPE_HR		(0x00109000)
+#define CSR_HW_RF_ID_TYPE_HR		(0x0010A000)
+#define CSR_HW_RF_ID_TYPE_HRCDB		(0x00109000)
 
 /* EEPROM REG */
 #define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index e51760e752d4..2d92d3708619 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -538,7 +538,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 
 /* a000 Series */
 	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg_hr_cdb)},
-	{IWL_PCI_DEVICE(0x2722, 0x0A10, iwla000_2ac_cfg_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwla000_2ac_cfg_jf)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}
@@ -672,10 +672,12 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		iwl_trans->cfg = cfg_7265d;
 	}
 
-	if (iwl_trans->cfg->rf_id &&
-	    (cfg == &iwla000_2ac_cfg_hr || cfg == &iwla000_2ac_cfg_hr_cdb) &&
-	     iwl_trans->hw_rf_id == CSR_HW_RF_ID_TYPE_JF) {
-		cfg = &iwla000_2ac_cfg_jf;
+	if (iwl_trans->cfg->rf_id && cfg == &iwla000_2ac_cfg_hr_cdb) {
+		if (iwl_trans->hw_rf_id == CSR_HW_RF_ID_TYPE_JF)
+			cfg = &iwla000_2ac_cfg_jf;
+		else if (iwl_trans->hw_rf_id == CSR_HW_RF_ID_TYPE_HR)
+			cfg = &iwla000_2ac_cfg_hr;
+
 		iwl_trans->cfg = cfg;
 	}
 #endif
-- 
2.11.0
