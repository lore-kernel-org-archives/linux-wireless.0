Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:47191 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256AbcAaLG3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:29 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/31] iwlwifi: pcie: add initial RTPM support for PCI
Date: Sun, 31 Jan 2016 13:05:59 +0200
Message-Id: <1454238386-27032-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_120639_992956_187044B9)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Add an initial implementation of runtime power management (RTPM) for
PCI devices.  With this patch, RTPM is only used when wifi is off
(i.e. the wifi interface is down).  This implementation is behind a
new Kconfig flag, IWLWIFI_PCIE_RTPM.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig      | 12 +++++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   | 60 +++++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 27 +++++++++++
 3 files changed, 96 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 8660677..acaaf69 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -99,6 +99,18 @@ config IWLWIFI_UAPSD
 
 	  If unsure, say N.
 
+config IWLWIFI_PCIE_RTPM
+       bool "Enable runtime power management mode for PCIe devices"
+       depends on IWLMVM && IWLWIFI_PCIE && PM
+       default false
+       help
+         Say Y here to enable runtime power management for PCIe
+         devices.  If enabled, the device will go into low power mode
+         when idle for a short period of time, allowing for improved
+         power saving during runtime.
+
+	 If unsure, say N.
+
 menu "Debugging Options"
 
 config IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 6261a68..676d239 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -66,6 +67,9 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
+#ifdef CONFIG_IWLWIFI_PCIE_RTPM
+#include <linux/pm_runtime.h>
+#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
 #include <linux/pci.h>
 #include <linux/pci-aspm.h>
 #include <linux/acpi.h>
@@ -623,6 +627,13 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_free_drv;
 
+#ifdef CONFIG_IWLWIFI_PCIE_RTPM
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev,
+					 iwlwifi_mod_params.d0i3_entry_delay);
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_allow(&pdev->dev);
+#endif
 	return 0;
 
 out_free_drv:
@@ -689,15 +700,58 @@ static int iwl_pci_resume(struct device *device)
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
+#ifdef CONFIG_IWLWIFI_PCIE_RTPM
+static int iwl_pci_runtime_suspend(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct iwl_trans *trans = pci_get_drvdata(pdev);
+
+	IWL_DEBUG_RPM(trans, "entering runtime suspend\n");
+
+	/* For now we only allow D0I3 if the device is off */
+	if (test_bit(STATUS_DEVICE_ENABLED, &trans->status))
+		return -EBUSY;
+
+	trans->system_pm_mode = IWL_PLAT_PM_MODE_D0I3;
+
+	iwl_trans_d3_suspend(trans, false);
+
+	return 0;
+}
+
+static int iwl_pci_runtime_resume(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct iwl_trans *trans = pci_get_drvdata(pdev);
+	enum iwl_d3_status d3_status;
+
+	IWL_DEBUG_RPM(trans, "exiting runtime suspend (resume)\n");
+
+	iwl_trans_d3_resume(trans, &d3_status, false);
+
+	trans->system_pm_mode = IWL_PLAT_PM_MODE_D3;
+
+	return 0;
+}
+#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
+
+static const struct dev_pm_ops iwl_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(iwl_pci_suspend,
+				iwl_pci_resume)
+#ifdef CONFIG_IWLWIFI_PCIE_RTPM
+	SET_RUNTIME_PM_OPS(iwl_pci_runtime_suspend,
+			   iwl_pci_runtime_resume,
+			   NULL)
+#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
+};
 
 #define IWL_PM_OPS	(&iwl_dev_pm_ops)
 
-#else
+#else /* CONFIG_PM_SLEEP */
 
 #define IWL_PM_OPS	NULL
 
-#endif
+#endif /* CONFIG_PM_SLEEP */
 
 static struct pci_driver iwl_pci_driver = {
 	.name = DRV_NAME,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 3581096..db94fe1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -72,6 +72,9 @@
 #include <linux/bitops.h>
 #include <linux/gfp.h>
 #include <linux/vmalloc.h>
+#ifdef CONFIG_IWLWIFI_PCIE_RTPM
+#include <linux/pm_runtime.h>
+#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
 
 #include "iwl-drv.h"
 #include "iwl-trans.h"
@@ -1194,6 +1197,9 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 	if (hw_rfkill != was_hw_rfkill)
 		iwl_trans_pcie_rf_kill(trans, hw_rfkill);
 
+#ifdef CONFIG_IWLWIFI_PCIE_RTPM
+	pm_runtime_put_sync(trans->dev);
+#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
 	/* re-take ownership to prevent other users from stealing the deivce */
 	iwl_pcie_prepare_card_hw(trans);
 }
@@ -1353,6 +1359,9 @@ static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 	/* ... rfkill can call stop_device and set it false if needed */
 	iwl_trans_pcie_rf_kill(trans, hw_rfkill);
 
+#ifdef CONFIG_IWLWIFI_PCIE_RTPM
+	pm_runtime_get_sync(trans->dev);
+#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
 	return 0;
 }
 
@@ -1476,6 +1485,10 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int i;
 
+#ifdef CONFIG_IWLWIFI_PCIE_RTPM
+	/* TODO: check if this is really needed */
+	pm_runtime_disable(trans->dev);
+#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
 	synchronize_irq(trans_pcie->pci_dev->irq);
 
 	iwl_pcie_tx_free(trans);
@@ -1831,6 +1844,9 @@ void iwl_trans_pcie_ref(struct iwl_trans *trans)
 	spin_lock_irqsave(&trans_pcie->ref_lock, flags);
 	IWL_DEBUG_RPM(trans, "ref_counter: %d\n", trans_pcie->ref_count);
 	trans_pcie->ref_count++;
+#ifdef CONFIG_IWLWIFI_PCIE_RTPM
+	pm_runtime_get(&trans_pcie->pci_dev->dev);
+#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
 	spin_unlock_irqrestore(&trans_pcie->ref_lock, flags);
 }
 
@@ -1849,6 +1865,11 @@ void iwl_trans_pcie_unref(struct iwl_trans *trans)
 		return;
 	}
 	trans_pcie->ref_count--;
+#ifdef CONFIG_IWLWIFI_PCIE_RTPM
+	pm_runtime_mark_last_busy(&trans_pcie->pci_dev->dev);
+	pm_runtime_put_autosuspend(&trans_pcie->pci_dev->dev);
+#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
+
 	spin_unlock_irqrestore(&trans_pcie->ref_lock, flags);
 }
 
@@ -2728,6 +2749,12 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 
 	trans_pcie->inta_mask = CSR_INI_SET_MASK;
 
+#ifdef CONFIG_IWLWIFI_PCIE_RTPM
+	trans->runtime_pm_mode = IWL_PLAT_PM_MODE_D0I3;
+#else
+	trans->runtime_pm_mode = IWL_PLAT_PM_MODE_DISABLED;
+#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
+
 	return trans;
 
 out_free_ict:
-- 
2.5.0

