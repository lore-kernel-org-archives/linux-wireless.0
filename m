Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42652 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbcCBH5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:41 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/43] iwlwifi: pcie: add pm_prepare and pm_complete ops
Date: Wed,  2 Mar 2016 09:56:24 +0200
Message-Id: <1456905404-14435-23-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085951_585885_91F80597)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

With these ops, we can know when we are about to enter system suspend.
This allows us to exit D0i3 state before entering suspend.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c  | 41 ++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 0ca0f13..91d74b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -836,6 +836,7 @@ struct iwl_trans {
 
 	enum iwl_plat_pm_mode system_pm_mode;
 	enum iwl_plat_pm_mode runtime_pm_mode;
+	bool suspending;
 
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 753ec67..d33b6ba 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -811,6 +811,45 @@ static int iwl_pci_runtime_resume(struct device *device)
 
 	return 0;
 }
+
+static int iwl_pci_system_prepare(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct iwl_trans *trans = pci_get_drvdata(pdev);
+
+	IWL_DEBUG_RPM(trans, "preparing for system suspend\n");
+
+	/* This is called before entering system suspend and before
+	 * the runtime resume is called.  Set the suspending flag to
+	 * prevent the wakelock from being taken.
+	 */
+	trans->suspending = true;
+
+	/* Wake the device up from runtime suspend before going to
+	 * platform suspend.  This is needed because we don't know
+	 * whether wowlan any is set and, if it's not, mac80211 will
+	 * disconnect (in which case, we can't be in D0i3).
+	 */
+	pm_runtime_resume(device);
+
+	return 0;
+}
+
+static void iwl_pci_system_complete(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct iwl_trans *trans = pci_get_drvdata(pdev);
+
+	IWL_DEBUG_RPM(trans, "completing system suspend\n");
+
+	/* This is called as a counterpart to the prepare op.  It is
+	 * called either when suspending fails or when suspend
+	 * completed successfully.  Now there's no risk of grabbing
+	 * the wakelock anymore, so we can release the suspending
+	 * flag.
+	 */
+	trans->suspending = false;
+}
 #endif /* CONFIG_IWLWIFI_PCIE_RTPM */
 
 static const struct dev_pm_ops iwl_dev_pm_ops = {
@@ -820,6 +859,8 @@ static const struct dev_pm_ops iwl_dev_pm_ops = {
 	SET_RUNTIME_PM_OPS(iwl_pci_runtime_suspend,
 			   iwl_pci_runtime_resume,
 			   NULL)
+	.prepare = iwl_pci_system_prepare,
+	.complete = iwl_pci_system_complete,
 #endif /* CONFIG_IWLWIFI_PCIE_RTPM */
 };
 
-- 
2.5.0

