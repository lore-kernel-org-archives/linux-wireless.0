Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38696 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730314AbeG0OLF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 10:11:05 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 27 Jul 2018 15:48:32 +0300
Message-Id: <20180727124838.25910-11-luca@coelho.fi> (sfid-20180727_144920_298571_79BFF450)
In-Reply-To: <20180727124838.25910-1-luca@coelho.fi>
References: <20180727124838.25910-1-luca@coelho.fi>
Subject: [PATCH 10/16] iwlwifi: pcie: don't access periphery registers when not available
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The periphery can't be accessed before we set the
INIT_DONE bit which initializes the device.

A previous patch added a reconfiguration of the MSI-X
tables upon resume, but at that point in the flow,
INIT_DONE wasn't set. Since the reconfiguration of the
MSI-X tables require periphery access, it failed.

The difference between WoWLAN and without WoWLAN is that
in WoWLAN, iwl_trans_pcie_d3_suspend clears the INIT_DONE
without clearing the STATUS_DEVICE_ENABLED bit in the
software status. Because of that, the resume code thinks
that the device is enabled, but the INIT_DONE bit has been
cleared.

To fix this, don't reconfigure the MSI-X tables in case
WoWLAN is enabled. It will be done in
iwl_trans_pcie_d3_resume anyway.

Fixes: 52848a79b9d2 ("iwlwifi: pcie: reconfigure MSI-X HW on resume")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  4 ++++
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 24 +++++++++----------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 651975bc159b..51a2e2deea9c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -994,6 +994,10 @@ static int iwl_pci_resume(struct device *device)
 	if (!trans->op_mode)
 		return 0;
 
+	/* In WOWLAN, let iwl_trans_pcie_d3_resume do the rest of the work */
+	if (test_bit(STATUS_DEVICE_ENABLED, &trans->status))
+		return 0;
+
 	/* reconfigure the MSI-X mapping to get the correct IRQ for rfkill */
 	iwl_pcie_conf_msix_hw(trans_pcie);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 7928e8089f42..a54c2bc985ad 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1563,18 +1563,6 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 
 	iwl_pcie_enable_rx_wake(trans, true);
 
-	/*
-	 * Reconfigure IVAR table in case of MSIX or reset ict table in
-	 * MSI mode since HW reset erased it.
-	 * Also enables interrupts - none will happen as
-	 * the device doesn't know we're waking it up, only when
-	 * the opmode actually tells it after this call.
-	 */
-	iwl_pcie_conf_msix_hw(trans_pcie);
-	if (!trans_pcie->msix_enabled)
-		iwl_pcie_reset_ict(trans);
-	iwl_enable_interrupts(trans);
-
 	iwl_set_bit(trans, CSR_GP_CNTRL,
 		    BIT(trans->cfg->csr->flag_mac_access_req));
 	iwl_set_bit(trans, CSR_GP_CNTRL,
@@ -1592,6 +1580,18 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 		return ret;
 	}
 
+	/*
+	 * Reconfigure IVAR table in case of MSIX or reset ict table in
+	 * MSI mode since HW reset erased it.
+	 * Also enables interrupts - none will happen as
+	 * the device doesn't know we're waking it up, only when
+	 * the opmode actually tells it after this call.
+	 */
+	iwl_pcie_conf_msix_hw(trans_pcie);
+	if (!trans_pcie->msix_enabled)
+		iwl_pcie_reset_ict(trans);
+	iwl_enable_interrupts(trans);
+
 	iwl_pcie_set_pwr(trans, false);
 
 	if (!reset) {
-- 
2.18.0
