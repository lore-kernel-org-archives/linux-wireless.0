Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39178 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932096AbdBHL2l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 06:28:41 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 13:23:08 +0200
Message-Id: <20170208112322.29413-4-luca@coelho.fi> (sfid-20170208_122900_217104_81CCBBDD)
In-Reply-To: <20170208112322.29413-1-luca@coelho.fi>
References: <20170208112322.29413-1-luca@coelho.fi>
Subject: [PATCH 03/17] iwlwifi: pcie: re-configure IVAR table after suspend-resume
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

During the suspend/resume flow some HW blocks are reset.  This causes
the IVAR table to be completely erased.  This table is where interrupt
causes are bound to specific IRQs.  When the table is empty the
interrupt handlers are not called correctly.  Fix this by reconfiguring
the IVAR table after resume.

Fixes: 2e5d4a8f61dc ("iwlwifi: pcie: Add new configuration to enable MSIX")
Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index e7a26f594386..bb2a9a151957 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1152,13 +1152,19 @@ static void iwl_pcie_conf_msix_hw(struct iwl_trans_pcie *trans_pcie)
 	struct iwl_trans *trans = trans_pcie->trans;
 
 	if (!trans_pcie->msix_enabled) {
-		if (trans->cfg->mq_rx_supported)
+		if (trans->cfg->mq_rx_supported &&
+		    test_bit(STATUS_DEVICE_ENABLED, &trans->status))
 			iwl_write_prph(trans, UREG_CHICK,
 				       UREG_CHICK_MSI_ENABLE);
 		return;
 	}
-
-	iwl_write_prph(trans, UREG_CHICK, UREG_CHICK_MSIX_ENABLE);
+	/*
+	 * The IVAR table needs to be configured again after reset,
+	 * but if the device is disabled, we can't write to
+	 * prph.
+	 */
+	if (test_bit(STATUS_DEVICE_ENABLED, &trans->status))
+		iwl_write_prph(trans, UREG_CHICK, UREG_CHICK_MSIX_ENABLE);
 
 	/*
 	 * Each cause from the causes list above and the RX causes is
@@ -1457,6 +1463,7 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 				    enum iwl_d3_status *status,
 				    bool test,  bool reset)
 {
+	struct iwl_trans_pcie *trans_pcie =  IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 val;
 	int ret;
 
@@ -1469,11 +1476,15 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 	iwl_pcie_enable_rx_wake(trans, true);
 
 	/*
-	 * Also enables interrupts - none will happen as the device doesn't
-	 * know we're waking it up, only when the opmode actually tells it
-	 * after this call.
+	 * Reconfigure IVAR table in case of MSIX or reset ict table in
+	 * MSI mode since HW reset erased it.
+	 * Also enables interrupts - none will happen as
+	 * the device doesn't know we're waking it up, only when
+	 * the opmode actually tells it after this call.
 	 */
-	iwl_pcie_reset_ict(trans);
+	iwl_pcie_conf_msix_hw(trans_pcie);
+	if (!trans_pcie->msix_enabled)
+		iwl_pcie_reset_ict(trans);
 	iwl_enable_interrupts(trans);
 
 	iwl_set_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-- 
2.11.0
