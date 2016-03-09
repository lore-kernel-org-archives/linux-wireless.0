Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:63100 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbcCIRpz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:45:55 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/21] iwlwifi: pcie: forbid RTPM on device removal
Date: Wed,  9 Mar 2016 19:45:30 +0200
Message-Id: <1457545550-30677-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_184558_484993_FA78B836)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The pci driver keeps any unbound device in active state and forbids
runtime PM.  When our driver gets probed, we take control of the
state.  When the device is released (i.e. during unbind or module
removal), we should return the state to what it was before.  To do so,
we need to forbid RTPM in the driver remove op.

Additionally, remove an unnecessary pm_runtime_disable() call, move
the initial ref_count setting to a better place and add some comments
explaining what is going on.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   | 28 +++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |  6 ------
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index d33b6ba..05b9685 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -631,13 +631,31 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* if RTPM is in use, enable it in our device */
 	if (iwl_trans->runtime_pm_mode != IWL_PLAT_PM_MODE_DISABLED) {
+		/* We explicitly set the device to active here to
+		 * clear contingent errors.
+		 */
 		pm_runtime_set_active(&pdev->dev);
+
 		pm_runtime_set_autosuspend_delay(&pdev->dev,
 					 iwlwifi_mod_params.d0i3_entry_delay);
 		pm_runtime_use_autosuspend(&pdev->dev);
+
+		/* We are not supposed to call pm_runtime_allow() by
+		 * ourselves, but let userspace enable runtime PM via
+		 * sysfs.  However, since we don't enable this from
+		 * userspace yet, we need to allow/forbid() ourselves.
+		*/
 		pm_runtime_allow(&pdev->dev);
 	}
 
+	/* The PCI device starts with a reference taken and we are
+	 * supposed to release it here.  But to simplify the
+	 * interaction with the opmode, we don't do it now, but let
+	 * the opmode release it when it's ready.  To account for this
+	 * reference, we start with ref_count set to 1.
+	 */
+	trans_pcie->ref_count = 1;
+
 	return 0;
 
 out_free_drv:
@@ -652,7 +670,17 @@ static void iwl_pci_remove(struct pci_dev *pdev)
 	struct iwl_trans *trans = pci_get_drvdata(pdev);
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
+	/* if RTPM was in use, restore it to the state before probe */
+	if (trans->runtime_pm_mode != IWL_PLAT_PM_MODE_DISABLED) {
+		/* We should not call forbid here, but we do for now.
+		 * Check the comment to pm_runtime_allow() in
+		 * iwl_pci_probe().
+		 */
+		pm_runtime_forbid(trans->dev);
+	}
+
 	iwl_drv_stop(trans_pcie->drv);
+
 	iwl_trans_pcie_free(trans);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index e67957d..eb39c7e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1646,9 +1646,6 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 	trans->command_groups = trans_cfg->command_groups;
 	trans->command_groups_size = trans_cfg->command_groups_size;
 
-	/* init ref_count to 1 (should be cleared when ucode is loaded) */
-	trans_pcie->ref_count = 1;
-
 	/* Initialize NAPI here - it should be before registering to mac80211
 	 * in the opmode but after the HW struct is allocated.
 	 * As this function may be called again in some corner cases don't
@@ -1663,9 +1660,6 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int i;
 
-	/* TODO: check if this is really needed */
-	pm_runtime_disable(trans->dev);
-
 	iwl_pcie_synchronize_irqs(trans);
 
 	iwl_pcie_tx_free(trans);
-- 
2.5.0

