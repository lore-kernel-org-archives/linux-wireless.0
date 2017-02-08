Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39168 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753789AbdBHL22 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 06:28:28 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 13:23:07 +0200
Message-Id: <20170208112322.29413-3-luca@coelho.fi> (sfid-20170208_122839_539081_62FC8872)
In-Reply-To: <20170208112322.29413-1-luca@coelho.fi>
References: <20170208112322.29413-1-luca@coelho.fi>
Subject: [PATCH 02/17] iwlwifi: pcie: separate between SW and HW MSIX configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

The MSIX configuration flow includes two different stages:
configuring the HW by writing to the IVAR table and configuring the SW
to reflect the HW configuration.
The HW configuration is needed on each HW reset,
whereas the SW configuration is only needed during the init flow.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index f795ebea4c4a..e7a26f594386 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1147,7 +1147,7 @@ static void iwl_pcie_map_rx_causes(struct iwl_trans *trans)
 		iwl_write8(trans, CSR_MSIX_RX_IVAR(1), val);
 }
 
-static void iwl_pcie_init_msix(struct iwl_trans_pcie *trans_pcie)
+static void iwl_pcie_conf_msix_hw(struct iwl_trans_pcie *trans_pcie)
 {
 	struct iwl_trans *trans = trans_pcie->trans;
 
@@ -1170,12 +1170,20 @@ static void iwl_pcie_init_msix(struct iwl_trans_pcie *trans_pcie)
 	iwl_pcie_map_rx_causes(trans);
 
 	iwl_pcie_map_non_rx_causes(trans);
+}
+
+static void iwl_pcie_init_msix(struct iwl_trans_pcie *trans_pcie)
+{
+	struct iwl_trans *trans = trans_pcie->trans;
+
+	iwl_pcie_conf_msix_hw(trans_pcie);
 
-	trans_pcie->fh_init_mask =
-		~iwl_read32(trans, CSR_MSIX_FH_INT_MASK_AD);
+	if (!trans_pcie->msix_enabled)
+		return;
+
+	trans_pcie->fh_init_mask = ~iwl_read32(trans, CSR_MSIX_FH_INT_MASK_AD);
 	trans_pcie->fh_mask = trans_pcie->fh_init_mask;
-	trans_pcie->hw_init_mask =
-		~iwl_read32(trans, CSR_MSIX_HW_INT_MASK_AD);
+	trans_pcie->hw_init_mask = ~iwl_read32(trans, CSR_MSIX_HW_INT_MASK_AD);
 	trans_pcie->hw_mask = trans_pcie->hw_init_mask;
 }
 
@@ -1675,6 +1683,7 @@ static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 	iwl_pcie_apm_init(trans);
 
 	iwl_pcie_init_msix(trans_pcie);
+
 	/* From now on, the op_mode will be kept updated about RF kill state */
 	iwl_enable_rfkill_int(trans);
 
-- 
2.11.0
