Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41130 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757899AbXK2BgJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 20:36:09 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/2] iwlwifi: delay firmware loading from pci_probe to network interface open
Date: Thu, 29 Nov 2007 09:34:07 +0800
Message-Id: <1196300047-6201-2-git-send-email-yi.zhu@intel.com> (sfid-20071129_013614_147308_F1D40864)
In-Reply-To: <1196300047-6201-1-git-send-email-yi.zhu@intel.com>
References: <1196300047-6201-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves the firmware loading (read firmware from disk and load
it into the device SRAM) from pci_probe time to the first network
interface open time. There are two reasons for doing this:

1. To support kernel buildin iwlwifi drivers. Because kernel initializes
   network devices subsystem before hard disk and SATA subsystem, it is
   impossible to get the firmware image from hard disk in the PCI probe
   handler. Thus delaying the firmware loading into the network
   interface open time is the way to go. Note, we only read the firmware
   image from hard disk the first time the interface is open. After this
   is succeeded, we cache the firmware image into the host memory. This
   is a performance gain when user open and close the interface multiple
   times and is necessary for device suspend and resume.

2. For better power saving. When the iwlwifi modules are loaded (or
   buildin the kernel) but the wireless network interface is not being
   used, it is a good practice the wireless device consumes as less
   power as possible. Unloading the firmware from the wireless device
   and unregister the driver's interrupt handler in the network
   interface close handler provides users a way to achieve this. User
   space network configuration tools (i.e NetworkManager) can also
   contribute here when it detects a wired cable is connected and
   close the wireless interface automatically.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  123 ++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  124 +++++++++++++++------------
 2 files changed, 135 insertions(+), 112 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 96420d5..ed7fc64 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5431,6 +5431,7 @@ static void iwl3945_dealloc_ucode_pci(struct iwl3945_priv *priv)
 				    priv->ucode_code.p_addr);
 		priv->ucode_code.v_addr = NULL;
 	}
+	priv->ucode_code.len = 0;
 	if (priv->ucode_data.v_addr != NULL) {
 		pci_free_consistent(priv->pci_dev,
 				    priv->ucode_data.len,
@@ -5438,6 +5439,7 @@ static void iwl3945_dealloc_ucode_pci(struct iwl3945_priv *priv)
 				    priv->ucode_data.p_addr);
 		priv->ucode_data.v_addr = NULL;
 	}
+	priv->ucode_data.len = 0;
 	if (priv->ucode_data_backup.v_addr != NULL) {
 		pci_free_consistent(priv->pci_dev,
 				    priv->ucode_data_backup.len,
@@ -5445,6 +5447,7 @@ static void iwl3945_dealloc_ucode_pci(struct iwl3945_priv *priv)
 				    priv->ucode_data_backup.p_addr);
 		priv->ucode_data_backup.v_addr = NULL;
 	}
+	priv->ucode_data_backup.len = 0;
 	if (priv->ucode_init.v_addr != NULL) {
 		pci_free_consistent(priv->pci_dev,
 				    priv->ucode_init.len,
@@ -5452,6 +5455,7 @@ static void iwl3945_dealloc_ucode_pci(struct iwl3945_priv *priv)
 				    priv->ucode_init.p_addr);
 		priv->ucode_init.v_addr = NULL;
 	}
+	priv->ucode_init.len = 0;
 	if (priv->ucode_init_data.v_addr != NULL) {
 		pci_free_consistent(priv->pci_dev,
 				    priv->ucode_init_data.len,
@@ -5459,6 +5463,7 @@ static void iwl3945_dealloc_ucode_pci(struct iwl3945_priv *priv)
 				    priv->ucode_init_data.p_addr);
 		priv->ucode_init_data.v_addr = NULL;
 	}
+	priv->ucode_init_data.len = 0;
 	if (priv->ucode_boot.v_addr != NULL) {
 		pci_free_consistent(priv->pci_dev,
 				    priv->ucode_boot.len,
@@ -5466,6 +5471,7 @@ static void iwl3945_dealloc_ucode_pci(struct iwl3945_priv *priv)
 				    priv->ucode_boot.p_addr);
 		priv->ucode_boot.v_addr = NULL;
 	}
+	priv->ucode_boot.len = 0;
 }
 
 /**
@@ -6135,30 +6141,12 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 	}
 
 	iwl3945_init_geos(priv);
+	iwl3945_reset_channel_flag(priv);
 
 	if (iwl3945_is_rfkill(priv))
 		return;
 
-	if (!priv->mac80211_registered) {
-		/* Unlock so any user space entry points can call back into
-		 * the driver without a deadlock... */
-		mutex_unlock(&priv->mutex);
-		iwl3945_rate_control_register(priv->hw);
-		rc = ieee80211_register_hw(priv->hw);
-		priv->hw->conf.beacon_int = 100;
-		mutex_lock(&priv->mutex);
-
-		if (rc) {
-			IWL_ERROR("Failed to register network "
-				  "device (error %d)\n", rc);
-			return;
-		}
-
-		priv->mac80211_registered = 1;
-
-		iwl3945_reset_channel_flag(priv);
-	} else
-		ieee80211_start_queues(priv->hw);
+	ieee80211_start_queues(priv->hw);
 
 	priv->active_rate = priv->rates_mask;
 	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
@@ -6191,6 +6179,7 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 	iwl3945_reg_txpower_periodic(priv);
 
 	IWL_DEBUG_INFO("ALIVE processing complete.\n");
+	wake_up_interruptible(&priv->wait_command_queue);
 
 	if (priv->error_recovering)
 		iwl3945_error_recovery(priv);
@@ -6341,8 +6330,9 @@ static int __iwl3945_up(struct iwl3945_priv *priv)
 	/* Copy original ucode data image from disk into backup cache.
 	 * This will be used to initialize the on-board processor's
 	 * data SRAM for a clean start when the runtime program first loads. */
-	memcpy(priv->ucode_data_backup.v_addr, priv->ucode_data.v_addr,
-			priv->ucode_data.len);
+	if (!priv->ucode_data_backup.len)
+		memcpy(priv->ucode_data_backup.v_addr, priv->ucode_data.v_addr,
+		       priv->ucode_data.len);
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
@@ -6847,21 +6837,56 @@ static void iwl3945_bg_scan_completed(struct work_struct *work)
  *
  *****************************************************************************/
 
+#define UCODE_READY_TIMEOUT	(2 * HZ)
+
 static int iwl3945_mac_start(struct ieee80211_hw *hw)
 {
 	struct iwl3945_priv *priv = hw->priv;
+	int ret;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
+	ret = request_irq(priv->pci_dev->irq, iwl3945_isr, IRQF_SHARED,
+			  DRV_NAME, priv);
+	if (ret) {
+		IWL_ERROR("Error allocating IRQ %d\n", priv->pci_dev->irq);
+		return ret;
+	}
+
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);
 
-	priv->is_open = 1;
+	memset(&priv->staging_rxon, 0, sizeof(struct iwl3945_rxon_cmd));
+	/* fetch ucode file from disk, alloc and copy to bus-master buffers ...
+	 * ucode filename and max sizes are card-specific. */
+
+	if (!priv->ucode_code.len) {
+		ret = iwl3945_read_ucode(priv);
+		if (ret) {
+			IWL_ERROR("Could not read microcode: %d\n", ret);
+			mutex_unlock(&priv->mutex);
+			return ret;
+		}
+	}
 
-	if (!iwl3945_is_rfkill(priv))
-		ieee80211_start_queues(priv->hw);
+	IWL_DEBUG_INFO("Start UP work.\n");
+	__iwl3945_up(priv);
 
+	priv->is_open = 1;
 	mutex_unlock(&priv->mutex);
+
+	/* Wait for START_ALIVE from ucode. Otherwise callbacks from
+	 * mac80211 will not be run successfully. */
+	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
+			test_bit(STATUS_READY, &priv->status),
+			UCODE_READY_TIMEOUT);
+	if (!ret) {
+		if (!test_bit(STATUS_READY, &priv->status)) {
+			IWL_ERROR("Wait for START_ALIVE timeout after %dms.\n",
+				  jiffies_to_msecs(UCODE_READY_TIMEOUT));
+		}
+	}
+
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
 }
@@ -6871,19 +6896,22 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 	struct iwl3945_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
-
-
 	mutex_lock(&priv->mutex);
+
 	/* stop mac, cancel any scan request and clear
 	 * RXON_FILTER_ASSOC_MSK BIT
 	 */
 	priv->is_open = 0;
 	iwl3945_scan_cancel_timeout(priv, 100);
 	cancel_delayed_work(&priv->post_associate);
-	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwl3945_commit_rxon(priv);
+
+	__iwl3945_down(priv);
+
 	mutex_unlock(&priv->mutex);
 
+	flush_workqueue(priv->workqueue);
+	free_irq(priv->pci_dev->irq, priv);
+
 	IWL_DEBUG_MAC80211("leave\n");
 }
 
@@ -7108,6 +7136,9 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 		return 0;
 	}
 
+	if (!iwl3945_is_alive(priv))
+		return -EAGAIN;
+
 	mutex_lock(&priv->mutex);
 
 	IWL_DEBUG_MAC80211("enter: interface id %d\n", if_id);
@@ -8455,7 +8486,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* Device-specific setup */
 	if (iwl3945_hw_set_hw_setting(priv)) {
 		IWL_ERROR("failed to set hw settings\n");
-		mutex_unlock(&priv->mutex);
 		goto out_iounmap;
 	}
 
@@ -8482,47 +8512,29 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	pci_enable_msi(pdev);
 
-	err = request_irq(pdev->irq, iwl3945_isr, IRQF_SHARED, DRV_NAME, priv);
-	if (err) {
-		IWL_ERROR("Error allocating IRQ %d\n", pdev->irq);
-		goto out_disable_msi;
-	}
-
-	mutex_lock(&priv->mutex);
-
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 	if (err) {
 		IWL_ERROR("failed to create sysfs device attributes\n");
-		mutex_unlock(&priv->mutex);
 		goto out_release_irq;
 	}
 
-	/* fetch ucode file from disk, alloc and copy to bus-master buffers ...
-	 * ucode filename and max sizes are card-specific. */
-	err = iwl3945_read_ucode(priv);
+	iwl3945_rate_control_register(priv->hw);
+	err = ieee80211_register_hw(priv->hw);
 	if (err) {
-		IWL_ERROR("Could not read microcode: %d\n", err);
-		mutex_unlock(&priv->mutex);
-		goto out_pci_alloc;
+		IWL_ERROR("Failed to register network device (error %d)\n", err);
+		goto out_remove_sysfs;
 	}
 
-	mutex_unlock(&priv->mutex);
-
-	IWL_DEBUG_INFO("Queueing UP work.\n");
-
-	queue_work(priv->workqueue, &priv->up);
+	priv->hw->conf.beacon_int = 100;
+	priv->mac80211_registered = 1;
 
 	return 0;
 
- out_pci_alloc:
-	iwl3945_dealloc_ucode_pci(priv);
-
+ out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 
  out_release_irq:
 	free_irq(pdev->irq, priv);
-
- out_disable_msi:
 	pci_disable_msi(pdev);
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
@@ -8590,7 +8602,6 @@ static void iwl3945_pci_remove(struct pci_dev *pdev)
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 
-	free_irq(pdev->irq, priv);
 	pci_disable_msi(pdev);
 	pci_iounmap(pdev, priv->hw_base);
 	pci_release_regions(pdev);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index df011ea..b39d0d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5809,6 +5809,7 @@ static void iwl4965_dealloc_ucode_pci(struct iwl4965_priv *priv)
 				    priv->ucode_code.p_addr);
 		priv->ucode_code.v_addr = NULL;
 	}
+	priv->ucode_code.len = 0;
 	if (priv->ucode_data.v_addr != NULL) {
 		pci_free_consistent(priv->pci_dev,
 				    priv->ucode_data.len,
@@ -5816,6 +5817,7 @@ static void iwl4965_dealloc_ucode_pci(struct iwl4965_priv *priv)
 				    priv->ucode_data.p_addr);
 		priv->ucode_data.v_addr = NULL;
 	}
+	priv->ucode_data.len = 0;
 	if (priv->ucode_data_backup.v_addr != NULL) {
 		pci_free_consistent(priv->pci_dev,
 				    priv->ucode_data_backup.len,
@@ -5823,6 +5825,7 @@ static void iwl4965_dealloc_ucode_pci(struct iwl4965_priv *priv)
 				    priv->ucode_data_backup.p_addr);
 		priv->ucode_data_backup.v_addr = NULL;
 	}
+	priv->ucode_data_backup.len = 0;
 	if (priv->ucode_init.v_addr != NULL) {
 		pci_free_consistent(priv->pci_dev,
 				    priv->ucode_init.len,
@@ -5830,6 +5833,7 @@ static void iwl4965_dealloc_ucode_pci(struct iwl4965_priv *priv)
 				    priv->ucode_init.p_addr);
 		priv->ucode_init.v_addr = NULL;
 	}
+	priv->ucode_init.len = 0;
 	if (priv->ucode_init_data.v_addr != NULL) {
 		pci_free_consistent(priv->pci_dev,
 				    priv->ucode_init_data.len,
@@ -5837,6 +5841,7 @@ static void iwl4965_dealloc_ucode_pci(struct iwl4965_priv *priv)
 				    priv->ucode_init_data.p_addr);
 		priv->ucode_init_data.v_addr = NULL;
 	}
+	priv->ucode_init_data.len = 0;
 	if (priv->ucode_boot.v_addr != NULL) {
 		pci_free_consistent(priv->pci_dev,
 				    priv->ucode_boot.len,
@@ -5844,6 +5849,7 @@ static void iwl4965_dealloc_ucode_pci(struct iwl4965_priv *priv)
 				    priv->ucode_boot.p_addr);
 		priv->ucode_boot.v_addr = NULL;
 	}
+	priv->ucode_boot.len = 0;
 }
 
 /**
@@ -6501,30 +6507,12 @@ static void iwl4965_alive_start(struct iwl4965_priv *priv)
 	}
 
 	iwl4965_init_geos(priv);
+	iwl4965_reset_channel_flag(priv);
 
 	if (iwl4965_is_rfkill(priv))
 		return;
 
-	if (!priv->mac80211_registered) {
-		/* Unlock so any user space entry points can call back into
-		 * the driver without a deadlock... */
-		mutex_unlock(&priv->mutex);
-		iwl4965_rate_control_register(priv->hw);
-		rc = ieee80211_register_hw(priv->hw);
-		priv->hw->conf.beacon_int = 100;
-		mutex_lock(&priv->mutex);
-
-		if (rc) {
-			IWL_ERROR("Failed to register network "
-				  "device (error %d)\n", rc);
-			return;
-		}
-
-		priv->mac80211_registered = 1;
-
-		iwl4965_reset_channel_flag(priv);
-	} else
-		ieee80211_start_queues(priv->hw);
+	ieee80211_start_queues(priv->hw);
 
 	priv->active_rate = priv->rates_mask;
 	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
@@ -6555,7 +6543,9 @@ static void iwl4965_alive_start(struct iwl4965_priv *priv)
 	set_bit(STATUS_READY, &priv->status);
 
 	iwl4965_rf_kill_ct_config(priv);
+
 	IWL_DEBUG_INFO("ALIVE processing complete.\n");
+	wake_up_interruptible(&priv->wait_command_queue);
 
 	if (priv->error_recovering)
 		iwl4965_error_recovery(priv);
@@ -6707,8 +6697,9 @@ static int __iwl4965_up(struct iwl4965_priv *priv)
 	/* Copy original ucode data image from disk into backup cache.
 	 * This will be used to initialize the on-board processor's
 	 * data SRAM for a clean start when the runtime program first loads. */
-	memcpy(priv->ucode_data_backup.v_addr, priv->ucode_data.v_addr,
-			priv->ucode_data.len);
+	if (!priv->ucode_data_backup.len)
+		memcpy(priv->ucode_data_backup.v_addr, priv->ucode_data.v_addr,
+		       priv->ucode_data.len);
 
 	/* If platform's RF_KILL switch is set to KILL,
 	 * wait for BIT_INT_RF_KILL interrupt before loading uCode
@@ -7247,21 +7238,56 @@ static void iwl4965_bg_scan_completed(struct work_struct *work)
  *
  *****************************************************************************/
 
+#define UCODE_READY_TIMEOUT	(2 * HZ)
+
 static int iwl4965_mac_start(struct ieee80211_hw *hw)
 {
 	struct iwl4965_priv *priv = hw->priv;
+	int ret;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
+	ret = request_irq(priv->pci_dev->irq, iwl4965_isr, IRQF_SHARED,
+			  DRV_NAME, priv);
+	if (ret) {
+		IWL_ERROR("Error allocating IRQ %d\n", priv->pci_dev->irq);
+		return ret;
+	}
+
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);
 
-	priv->is_open = 1;
+	memset(&priv->staging_rxon, 0, sizeof(struct iwl4965_rxon_cmd));
+	/* fetch ucode file from disk, alloc and copy to bus-master buffers ...
+	 * ucode filename and max sizes are card-specific. */
+
+	if (!priv->ucode_code.len) {
+		ret = iwl4965_read_ucode(priv);
+		if (ret) {
+			IWL_ERROR("Could not read microcode: %d\n", ret);
+			mutex_unlock(&priv->mutex);
+			return ret;
+		}
+	}
 
-	if (!iwl4965_is_rfkill(priv))
-		ieee80211_start_queues(priv->hw);
+	IWL_DEBUG_INFO("Start UP work.\n");
+	__iwl4965_up(priv);
 
+	priv->is_open = 1;
 	mutex_unlock(&priv->mutex);
+
+	/* Wait for START_ALIVE from ucode. Otherwise callbacks from
+	 * mac80211 will not be run successfully. */
+	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
+			test_bit(STATUS_READY, &priv->status),
+			UCODE_READY_TIMEOUT);
+	if (!ret) {
+		if (!test_bit(STATUS_READY, &priv->status)) {
+			IWL_ERROR("Wait for START_ALIVE timeout after %dms.\n",
+				  jiffies_to_msecs(UCODE_READY_TIMEOUT));
+		}
+	}
+
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
 }
@@ -7271,19 +7297,22 @@ static void iwl4965_mac_stop(struct ieee80211_hw *hw)
 	struct iwl4965_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
-
-
 	mutex_lock(&priv->mutex);
+
 	/* stop mac, cancel any scan request and clear
 	 * RXON_FILTER_ASSOC_MSK BIT
 	 */
 	priv->is_open = 0;
 	iwl4965_scan_cancel_timeout(priv, 100);
 	cancel_delayed_work(&priv->post_associate);
-	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwl4965_commit_rxon(priv);
+
+	__iwl4965_down(priv);
+
 	mutex_unlock(&priv->mutex);
 
+	flush_workqueue(priv->workqueue);
+	free_irq(priv->pci_dev->irq, priv);
+
 	IWL_DEBUG_MAC80211("leave\n");
 }
 
@@ -7523,6 +7552,9 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 		return 0;
 	}
 
+	if (!iwl4965_is_alive(priv))
+		return -EAGAIN;
+
 	mutex_lock(&priv->mutex);
 
 	IWL_DEBUG_MAC80211("enter: interface id %d\n", if_id);
@@ -9081,7 +9113,6 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* Device-specific setup */
 	if (iwl4965_hw_set_hw_setting(priv)) {
 		IWL_ERROR("failed to set hw settings\n");
-		mutex_unlock(&priv->mutex);
 		goto out_iounmap;
 	}
 
@@ -9108,47 +9139,29 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	pci_enable_msi(pdev);
 
-	err = request_irq(pdev->irq, iwl4965_isr, IRQF_SHARED, DRV_NAME, priv);
-	if (err) {
-		IWL_ERROR("Error allocating IRQ %d\n", pdev->irq);
-		goto out_disable_msi;
-	}
-
-	mutex_lock(&priv->mutex);
-
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl4965_attribute_group);
 	if (err) {
 		IWL_ERROR("failed to create sysfs device attributes\n");
-		mutex_unlock(&priv->mutex);
 		goto out_release_irq;
 	}
 
-	/* fetch ucode file from disk, alloc and copy to bus-master buffers ...
-	 * ucode filename and max sizes are card-specific. */
-	err = iwl4965_read_ucode(priv);
+	iwl4965_rate_control_register(priv->hw);
+	err = ieee80211_register_hw(priv->hw);
 	if (err) {
-		IWL_ERROR("Could not read microcode: %d\n", err);
-		mutex_unlock(&priv->mutex);
-		goto out_pci_alloc;
+		IWL_ERROR("Failed to register network device (error %d)\n", err);
+		goto out_remove_sysfs;
 	}
 
-	mutex_unlock(&priv->mutex);
-
-	IWL_DEBUG_INFO("Queueing UP work.\n");
-
-	queue_work(priv->workqueue, &priv->up);
+	priv->hw->conf.beacon_int = 100;
+	priv->mac80211_registered = 1;
 
 	return 0;
 
- out_pci_alloc:
-	iwl4965_dealloc_ucode_pci(priv);
-
+ out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
 
  out_release_irq:
 	free_irq(pdev->irq, priv);
-
- out_disable_msi:
 	pci_disable_msi(pdev);
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
@@ -9216,7 +9229,6 @@ static void iwl4965_pci_remove(struct pci_dev *pdev)
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 
-	free_irq(pdev->irq, priv);
 	pci_disable_msi(pdev);
 	pci_iounmap(pdev, priv->hw_base);
 	pci_release_regions(pdev);
-- 
1.5.3.6
