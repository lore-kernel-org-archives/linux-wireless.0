Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:58066 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757272AbcAaLGa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:30 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/31] iwlwifi: pcie: add RTPM support when wifi is enabled
Date: Sun, 31 Jan 2016 13:06:00 +0200
Message-Id: <1454238386-27032-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_120634_385601_5F740F11)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Enable runtime power management (RTPM) for PCIe devices and implement
the corresponding functions to enable D0i3 mode when the device is
idle.

Additionally, remove some unnecessary #ifdef's because the RTPM code
will not be called if runtime PM is not configured.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  5 ++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 98 +++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  5 ++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 43 ++++++----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 17 +++-
 5 files changed, 141 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 82fb3a9..fe170a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -736,6 +736,11 @@ enum iwl_plat_pm_mode {
 	IWL_PLAT_PM_MODE_D0I3,
 };
 
+/* Max time to wait for trans to become idle/non-idle on d0i3
+ * enter/exit (in msecs).
+ */
+#define IWL_TRANS_IDLE_TIMEOUT 2000
+
 /**
  * struct iwl_trans - transport common data
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 676d239..16b579a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -67,9 +67,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#ifdef CONFIG_IWLWIFI_PCIE_RTPM
 #include <linux/pm_runtime.h>
-#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
 #include <linux/pci.h>
 #include <linux/pci-aspm.h>
 #include <linux/acpi.h>
@@ -627,13 +625,15 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_free_drv;
 
-#ifdef CONFIG_IWLWIFI_PCIE_RTPM
-	pm_runtime_set_active(&pdev->dev);
-	pm_runtime_set_autosuspend_delay(&pdev->dev,
+	/* if RTPM is in use, enable it in our device */
+	if (iwl_trans->runtime_pm_mode != IWL_PLAT_PM_MODE_DISABLED) {
+		pm_runtime_set_active(&pdev->dev);
+		pm_runtime_set_autosuspend_delay(&pdev->dev,
 					 iwlwifi_mod_params.d0i3_entry_delay);
-	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_allow(&pdev->dev);
-#endif
+		pm_runtime_use_autosuspend(&pdev->dev);
+		pm_runtime_allow(&pdev->dev);
+	}
+
 	return 0;
 
 out_free_drv:
@@ -700,17 +700,90 @@ static int iwl_pci_resume(struct device *device)
 	return 0;
 }
 
+int iwl_pci_fw_enter_d0i3(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int ret;
+
+	if (test_bit(STATUS_FW_ERROR, &trans->status))
+		return 0;
+
+	set_bit(STATUS_TRANS_GOING_IDLE, &trans->status);
+
+	/* config the fw */
+	ret = iwl_op_mode_enter_d0i3(trans->op_mode);
+	if (ret == 1) {
+		IWL_DEBUG_RPM(trans, "aborting d0i3 entrance\n");
+		clear_bit(STATUS_TRANS_GOING_IDLE, &trans->status);
+		return -EBUSY;
+	}
+	if (ret)
+		goto err;
+
+	ret = wait_event_timeout(trans_pcie->d0i3_waitq,
+				 test_bit(STATUS_TRANS_IDLE, &trans->status),
+				 msecs_to_jiffies(IWL_TRANS_IDLE_TIMEOUT));
+	if (!ret) {
+		IWL_ERR(trans, "Timeout entering D0i3\n");
+		ret = -ETIMEDOUT;
+		goto err;
+	}
+
+	clear_bit(STATUS_TRANS_GOING_IDLE, &trans->status);
+
+	return 0;
+err:
+	clear_bit(STATUS_TRANS_GOING_IDLE, &trans->status);
+	iwl_trans_fw_error(trans);
+	return ret;
+}
+
+int iwl_pci_fw_exit_d0i3(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int ret;
+
+	/* sometimes a D0i3 entry is not followed through */
+	if (!test_bit(STATUS_TRANS_IDLE, &trans->status))
+		return 0;
+
+	/* config the fw */
+	ret = iwl_op_mode_exit_d0i3(trans->op_mode);
+	if (ret)
+		goto err;
+
+	/* we clear STATUS_TRANS_IDLE only when D0I3_END command is completed */
+
+	ret = wait_event_timeout(trans_pcie->d0i3_waitq,
+				 !test_bit(STATUS_TRANS_IDLE, &trans->status),
+				 msecs_to_jiffies(IWL_TRANS_IDLE_TIMEOUT));
+	if (!ret) {
+		IWL_ERR(trans, "Timeout exiting D0i3\n");
+		ret = -ETIMEDOUT;
+		goto err;
+	}
+
+	return 0;
+err:
+	clear_bit(STATUS_TRANS_IDLE, &trans->status);
+	iwl_trans_fw_error(trans);
+	return ret;
+}
+
 #ifdef CONFIG_IWLWIFI_PCIE_RTPM
 static int iwl_pci_runtime_suspend(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct iwl_trans *trans = pci_get_drvdata(pdev);
+	int ret;
 
 	IWL_DEBUG_RPM(trans, "entering runtime suspend\n");
 
-	/* For now we only allow D0I3 if the device is off */
-	if (test_bit(STATUS_DEVICE_ENABLED, &trans->status))
-		return -EBUSY;
+	if (test_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
+		ret = iwl_pci_fw_enter_d0i3(trans);
+		if (ret < 0)
+			return ret;
+	}
 
 	trans->system_pm_mode = IWL_PLAT_PM_MODE_D0I3;
 
@@ -729,7 +802,8 @@ static int iwl_pci_runtime_resume(struct device *device)
 
 	iwl_trans_d3_resume(trans, &d3_status, false);
 
-	trans->system_pm_mode = IWL_PLAT_PM_MODE_D3;
+	if (test_bit(STATUS_DEVICE_ENABLED, &trans->status))
+		return iwl_pci_fw_exit_d0i3(trans);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index bdda702..7bc02e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -2,6 +2,7 @@
  *
  * Copyright(c) 2003 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -374,6 +375,7 @@ struct iwl_trans_pcie {
 	bool ucode_write_complete;
 	wait_queue_head_t ucode_write_waitq;
 	wait_queue_head_t wait_command_queue;
+	wait_queue_head_t d0i3_waitq;
 
 	u8 cmd_queue;
 	u8 cmd_fifo;
@@ -594,4 +596,7 @@ static inline int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
 }
 #endif
 
+int iwl_pci_fw_exit_d0i3(struct iwl_trans *trans);
+int iwl_pci_fw_enter_d0i3(struct iwl_trans *trans);
+
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index db94fe1..cfdc7f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -72,9 +72,7 @@
 #include <linux/bitops.h>
 #include <linux/gfp.h>
 #include <linux/vmalloc.h>
-#ifdef CONFIG_IWLWIFI_PCIE_RTPM
 #include <linux/pm_runtime.h>
-#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
 
 #include "iwl-drv.h"
 #include "iwl-trans.h"
@@ -1197,9 +1195,6 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 	if (hw_rfkill != was_hw_rfkill)
 		iwl_trans_pcie_rf_kill(trans, hw_rfkill);
 
-#ifdef CONFIG_IWLWIFI_PCIE_RTPM
-	pm_runtime_put_sync(trans->dev);
-#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
 	/* re-take ownership to prevent other users from stealing the deivce */
 	iwl_pcie_prepare_card_hw(trans);
 }
@@ -1359,9 +1354,10 @@ static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 	/* ... rfkill can call stop_device and set it false if needed */
 	iwl_trans_pcie_rf_kill(trans, hw_rfkill);
 
-#ifdef CONFIG_IWLWIFI_PCIE_RTPM
-	pm_runtime_get_sync(trans->dev);
-#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
+	/* Make sure we sync here, because we'll need full access later */
+	if (low_power)
+		pm_runtime_resume(trans->dev);
+
 	return 0;
 }
 
@@ -1485,10 +1481,9 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int i;
 
-#ifdef CONFIG_IWLWIFI_PCIE_RTPM
 	/* TODO: check if this is really needed */
 	pm_runtime_disable(trans->dev);
-#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
+
 	synchronize_irq(trans_pcie->pci_dev->irq);
 
 	iwl_pcie_tx_free(trans);
@@ -1844,9 +1839,7 @@ void iwl_trans_pcie_ref(struct iwl_trans *trans)
 	spin_lock_irqsave(&trans_pcie->ref_lock, flags);
 	IWL_DEBUG_RPM(trans, "ref_counter: %d\n", trans_pcie->ref_count);
 	trans_pcie->ref_count++;
-#ifdef CONFIG_IWLWIFI_PCIE_RTPM
 	pm_runtime_get(&trans_pcie->pci_dev->dev);
-#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
 	spin_unlock_irqrestore(&trans_pcie->ref_lock, flags);
 }
 
@@ -1865,10 +1858,9 @@ void iwl_trans_pcie_unref(struct iwl_trans *trans)
 		return;
 	}
 	trans_pcie->ref_count--;
-#ifdef CONFIG_IWLWIFI_PCIE_RTPM
+
 	pm_runtime_mark_last_busy(&trans_pcie->pci_dev->dev);
 	pm_runtime_put_autosuspend(&trans_pcie->pci_dev->dev);
-#endif /* CONFIG_IWLWIFI_PCIE_RTPM */
 
 	spin_unlock_irqrestore(&trans_pcie->ref_lock, flags);
 }
@@ -2536,6 +2528,22 @@ static struct iwl_trans_dump_data
 	return dump_data;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
+{
+	if (trans->runtime_pm_mode == IWL_PLAT_PM_MODE_D0I3)
+		return iwl_pci_fw_enter_d0i3(trans);
+
+	return 0;
+}
+
+static void iwl_trans_pcie_resume(struct iwl_trans *trans)
+{
+	if (trans->runtime_pm_mode == IWL_PLAT_PM_MODE_D0I3)
+		iwl_pci_fw_exit_d0i3(trans);
+}
+#endif /* CONFIG_PM_SLEEP */
+
 static const struct iwl_trans_ops trans_ops_pcie = {
 	.start_hw = iwl_trans_pcie_start_hw,
 	.op_mode_leave = iwl_trans_pcie_op_mode_leave,
@@ -2546,6 +2554,11 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.d3_suspend = iwl_trans_pcie_d3_suspend,
 	.d3_resume = iwl_trans_pcie_d3_resume,
 
+#ifdef CONFIG_PM_SLEEP
+	.suspend = iwl_trans_pcie_suspend,
+	.resume = iwl_trans_pcie_resume,
+#endif /* CONFIG_PM_SLEEP */
+
 	.send_cmd = iwl_trans_pcie_send_hcmd,
 
 	.tx = iwl_trans_pcie_tx,
@@ -2735,6 +2748,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	/* Initialize the wait queue for commands */
 	init_waitqueue_head(&trans_pcie->wait_command_queue);
 
+	init_waitqueue_head(&trans_pcie->d0i3_waitq);
+
 	ret = iwl_pcie_alloc_ict(trans);
 	if (ret)
 		goto out_pci_disable_msi;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index b0b0fd9..c499345 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1,7 +1,8 @@
 /******************************************************************************
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -1727,6 +1728,20 @@ void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
 		wake_up(&trans_pcie->wait_command_queue);
 	}
 
+	if (meta->flags & CMD_MAKE_TRANS_IDLE) {
+		IWL_DEBUG_INFO(trans, "complete %s - mark trans as idle\n",
+			       iwl_get_cmd_string(trans, cmd->hdr.cmd));
+		set_bit(STATUS_TRANS_IDLE, &trans->status);
+		wake_up(&trans_pcie->d0i3_waitq);
+	}
+
+	if (meta->flags & CMD_WAKE_UP_TRANS) {
+		IWL_DEBUG_INFO(trans, "complete %s - clear trans idle flag\n",
+			       iwl_get_cmd_string(trans, cmd->hdr.cmd));
+		clear_bit(STATUS_TRANS_IDLE, &trans->status);
+		wake_up(&trans_pcie->d0i3_waitq);
+	}
+
 	meta->flags = 0;
 
 	spin_unlock_bh(&txq->lock);
-- 
2.5.0

