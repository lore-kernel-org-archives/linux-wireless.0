Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50375 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbYAOC05 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 21:26:57 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Ian Schram <ischram@telenet.be>
Subject: [PATCH 05/12] iwlwifi: delay firmware loading from pci_probe to network interface open
Date: Mon, 14 Jan 2008 17:46:18 -0800
Message-Id: <1200361585-31801-6-git-send-email-reinette.chatre@intel.com> (sfid-20080115_022710_198103_7FE5555D)
In-Reply-To: <1200361585-31801-5-git-send-email-reinette.chatre@intel.com>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-2-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-3-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-4-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

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

This patch also includes the pci_save/restore_state() fixed by Ian Schram
upon the first version.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Ian Schram <ischram@telenet.be>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    8 -
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    5 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  183 +++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  187 ++++++++++++++++-----------
 4 files changed, 217 insertions(+), 166 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 77e7202..0779a23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1004,14 +1004,6 @@ int iwl3945_hw_nic_init(struct iwl3945_priv *priv)
 			    CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MM);
 	}
 
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/* Initialize the EEPROM */
-	rc = iwl3945_eeprom_init(priv);
-	if (rc)
-		return rc;
-
-	spin_lock_irqsave(&priv->lock, flags);
 	if (EEPROM_SKU_CAP_OP_MODE_MRC == priv->eeprom.sku_cap) {
 		IWL_DEBUG_INFO("SKU OP mode is mrc\n");
 		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e6a0397..5fcc2a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -506,11 +506,6 @@ int iwl4965_hw_nic_init(struct iwl4965_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	/* Read the EEPROM */
-	rc = iwl4965_eeprom_init(priv);
-	if (rc)
-		return rc;
-
 	if (priv->eeprom.calib_version < EEPROM_TX_POWER_VERSION_NEW) {
 		IWL_ERROR("Older EEPROM detected!  Aborting.\n");
 		return -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index cb05ab5..1a01475 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6179,31 +6179,12 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
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
-			iwl3945_rate_control_unregister(priv->hw);
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
@@ -6236,6 +6217,7 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 	iwl3945_reg_txpower_periodic(priv);
 
 	IWL_DEBUG_INFO("ALIVE processing complete.\n");
+	wake_up_interruptible(&priv->wait_command_queue);
 
 	if (priv->error_recovering)
 		iwl3945_error_recovery(priv);
@@ -6348,7 +6330,6 @@ static void iwl3945_down(struct iwl3945_priv *priv)
 
 static int __iwl3945_up(struct iwl3945_priv *priv)
 {
-	DECLARE_MAC_BUF(mac);
 	int rc, i;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
@@ -6387,7 +6368,7 @@ static int __iwl3945_up(struct iwl3945_priv *priv)
 	 * This will be used to initialize the on-board processor's
 	 * data SRAM for a clean start when the runtime program first loads. */
 	memcpy(priv->ucode_data_backup.v_addr, priv->ucode_data.v_addr,
-			priv->ucode_data.len);
+	       priv->ucode_data.len);
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
@@ -6406,13 +6387,6 @@ static int __iwl3945_up(struct iwl3945_priv *priv)
 		/* start card; "initialize" will load runtime ucode */
 		iwl3945_nic_start(priv);
 
-		/* MAC Address location in EEPROM is same for 3945/4965 */
-		get_eeprom_mac(priv, priv->mac_addr);
-		IWL_DEBUG_INFO("MAC address: %s\n",
-			       print_mac(mac, priv->mac_addr));
-
-		SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
-
 		IWL_DEBUG_INFO(DRV_NAME " is coming up\n");
 
 		return 0;
@@ -6901,23 +6875,73 @@ static void iwl3945_bg_scan_completed(struct work_struct *work)
  *
  *****************************************************************************/
 
+#define UCODE_READY_TIMEOUT	(2 * HZ)
+
 static int iwl3945_mac_start(struct ieee80211_hw *hw)
 {
 	struct iwl3945_priv *priv = hw->priv;
+	int ret;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
+	if (pci_enable_device(priv->pci_dev)) {
+		IWL_ERROR("Fail to pci_enable_device\n");
+		return -ENODEV;
+	}
+	pci_restore_state(priv->pci_dev);
+	pci_enable_msi(priv->pci_dev);
+
+	ret = request_irq(priv->pci_dev->irq, iwl3945_isr, IRQF_SHARED,
+			  DRV_NAME, priv);
+	if (ret) {
+		IWL_ERROR("Error allocating IRQ %d\n", priv->pci_dev->irq);
+		goto out_disable_msi;
+	}
+
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);
 
-	priv->is_open = 1;
+	memset(&priv->staging_rxon, 0, sizeof(struct iwl3945_rxon_cmd));
+	/* fetch ucode file from disk, alloc and copy to bus-master buffers ...
+	 * ucode filename and max sizes are card-specific. */
 
-	if (!iwl3945_is_rfkill(priv))
-		ieee80211_start_queues(priv->hw);
+	if (!priv->ucode_code.len) {
+		ret = iwl3945_read_ucode(priv);
+		if (ret) {
+			IWL_ERROR("Could not read microcode: %d\n", ret);
+			mutex_unlock(&priv->mutex);
+			goto out_release_irq;
+		}
+	}
 
+	IWL_DEBUG_INFO("Start UP work.\n");
+	__iwl3945_up(priv);
+
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
+			ret = -ETIMEDOUT;
+			goto out_release_irq;
+		}
+	}
+
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
+
+out_release_irq:
+	free_irq(priv->pci_dev->irq, priv);
+out_disable_msi:
+	pci_disable_msi(priv->pci_dev);
+	return ret;
 }
 
 static void iwl3945_mac_stop(struct ieee80211_hw *hw)
@@ -6926,23 +6950,25 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-
-	mutex_lock(&priv->mutex);
 	/* stop mac, cancel any scan request and clear
 	 * RXON_FILTER_ASSOC_MSK BIT
 	 */
 	priv->is_open = 0;
-	if (!iwl3945_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211("leave - RF not ready\n");
+
+	if (iwl3945_is_ready_rf(priv)) {
+		mutex_lock(&priv->mutex);
+		iwl3945_scan_cancel_timeout(priv, 100);
+		cancel_delayed_work(&priv->post_associate);
 		mutex_unlock(&priv->mutex);
-		return;
 	}
 
-	iwl3945_scan_cancel_timeout(priv, 100);
-	cancel_delayed_work(&priv->post_associate);
-	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwl3945_commit_rxon(priv);
-	mutex_unlock(&priv->mutex);
+	iwl3945_down(priv);
+
+	flush_workqueue(priv->workqueue);
+	free_irq(priv->pci_dev->irq, priv);
+	pci_disable_msi(priv->pci_dev);
+	pci_save_state(priv->pci_dev);
+	pci_disable_device(priv->pci_dev);
 
 	IWL_DEBUG_MAC80211("leave\n");
 }
@@ -6995,11 +7021,12 @@ static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
 		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 	}
 
-	iwl3945_set_mode(priv, conf->type);
+	if (iwl3945_is_ready(priv))
+		iwl3945_set_mode(priv, conf->type);
 
-	IWL_DEBUG_MAC80211("leave\n");
 	mutex_unlock(&priv->mutex);
 
+	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
 }
 
@@ -7173,6 +7200,9 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 		return 0;
 	}
 
+	if (!iwl3945_is_alive(priv))
+		return -EAGAIN;
+
 	mutex_lock(&priv->mutex);
 
 	if (conf->bssid)
@@ -8385,6 +8415,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	struct iwl3945_priv *priv;
 	struct ieee80211_hw *hw;
 	int i;
+	DECLARE_MAC_BUF(mac);
 
 	/* Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan. */
@@ -8537,7 +8568,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* Device-specific setup */
 	if (iwl3945_hw_set_hw_setting(priv)) {
 		IWL_ERROR("failed to set hw settings\n");
-		mutex_unlock(&priv->mutex);
 		goto out_iounmap;
 	}
 
@@ -8562,50 +8592,53 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	iwl3945_disable_interrupts(priv);
 
-	pci_enable_msi(pdev);
-
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
+	/* nic init */
+	iwl3945_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+                    CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
+
+        iwl3945_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+        err = iwl3945_poll_bit(priv, CSR_GP_CNTRL,
+                          CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+                          CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+        if (err < 0) {
+                IWL_DEBUG_INFO("Failed to init the card\n");
+		goto out_remove_sysfs;
+        }
+	/* Read the EEPROM */
+	err = iwl3945_eeprom_init(priv);
 	if (err) {
-		IWL_ERROR("Could not read microcode: %d\n", err);
-		mutex_unlock(&priv->mutex);
-		goto out_pci_alloc;
+		IWL_ERROR("Unable to init EEPROM\n");
+		goto out_remove_sysfs;
 	}
+	/* MAC Address location in EEPROM same for 3945/4965 */
+	get_eeprom_mac(priv, priv->mac_addr);
+	IWL_DEBUG_INFO("MAC address: %s\n", print_mac(mac, priv->mac_addr));
+	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
 
-	mutex_unlock(&priv->mutex);
-
-	IWL_DEBUG_INFO("Queueing UP work.\n");
+	iwl3945_rate_control_register(priv->hw);
+	err = ieee80211_register_hw(priv->hw);
+	if (err) {
+		IWL_ERROR("Failed to register network device (error %d)\n", err);
+		goto out_remove_sysfs;
+	}
 
-	queue_work(priv->workqueue, &priv->up);
+	priv->hw->conf.beacon_int = 100;
+	priv->mac80211_registered = 1;
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
 
 	return 0;
 
- out_pci_alloc:
-	iwl3945_dealloc_ucode_pci(priv);
-
+ out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 
  out_release_irq:
-	free_irq(pdev->irq, priv);
-
- out_disable_msi:
-	pci_disable_msi(pdev);
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 	iwl3945_unset_hw_setting(priv);
@@ -8671,8 +8704,6 @@ static void iwl3945_pci_remove(struct pci_dev *pdev)
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 
-	free_irq(pdev->irq, priv);
-	pci_disable_msi(pdev);
 	pci_iounmap(pdev, priv->hw_base);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 4d3ae28..090f883 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6608,31 +6608,12 @@ static void iwl4965_alive_start(struct iwl4965_priv *priv)
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
-			iwl4965_rate_control_unregister(priv->hw);
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
@@ -6663,7 +6644,9 @@ static void iwl4965_alive_start(struct iwl4965_priv *priv)
 	set_bit(STATUS_READY, &priv->status);
 
 	iwl4965_rf_kill_ct_config(priv);
+
 	IWL_DEBUG_INFO("ALIVE processing complete.\n");
+	wake_up_interruptible(&priv->wait_command_queue);
 
 	if (priv->error_recovering)
 		iwl4965_error_recovery(priv);
@@ -6777,7 +6760,6 @@ static void iwl4965_down(struct iwl4965_priv *priv)
 
 static int __iwl4965_up(struct iwl4965_priv *priv)
 {
-	DECLARE_MAC_BUF(mac);
 	int rc, i;
 	u32 hw_rf_kill = 0;
 
@@ -6817,7 +6799,7 @@ static int __iwl4965_up(struct iwl4965_priv *priv)
 	 * This will be used to initialize the on-board processor's
 	 * data SRAM for a clean start when the runtime program first loads. */
 	memcpy(priv->ucode_data_backup.v_addr, priv->ucode_data.v_addr,
-			priv->ucode_data.len);
+	       priv->ucode_data.len);
 
 	/* If platform's RF_KILL switch is set to KILL,
 	 * wait for BIT_INT_RF_KILL interrupt before loading uCode
@@ -6848,13 +6830,6 @@ static int __iwl4965_up(struct iwl4965_priv *priv)
 		/* start card; "initialize" will load runtime ucode */
 		iwl4965_nic_start(priv);
 
-		/* MAC Address location in EEPROM is same for 3945/4965 */
-		get_eeprom_mac(priv, priv->mac_addr);
-		IWL_DEBUG_INFO("MAC address: %s\n",
-			       print_mac(mac, priv->mac_addr));
-
-		SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
-
 		IWL_DEBUG_INFO(DRV_NAME " is coming up\n");
 
 		return 0;
@@ -7360,23 +7335,73 @@ static void iwl4965_bg_scan_completed(struct work_struct *work)
  *
  *****************************************************************************/
 
+#define UCODE_READY_TIMEOUT	(2 * HZ)
+
 static int iwl4965_mac_start(struct ieee80211_hw *hw)
 {
 	struct iwl4965_priv *priv = hw->priv;
+	int ret;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
+	if (pci_enable_device(priv->pci_dev)) {
+		IWL_ERROR("Fail to pci_enable_device\n");
+		return -ENODEV;
+	}
+	pci_restore_state(priv->pci_dev);
+	pci_enable_msi(priv->pci_dev);
+
+	ret = request_irq(priv->pci_dev->irq, iwl4965_isr, IRQF_SHARED,
+			  DRV_NAME, priv);
+	if (ret) {
+		IWL_ERROR("Error allocating IRQ %d\n", priv->pci_dev->irq);
+		goto out_disable_msi;
+	}
+
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);
 
-	priv->is_open = 1;
+	memset(&priv->staging_rxon, 0, sizeof(struct iwl4965_rxon_cmd));
+	/* fetch ucode file from disk, alloc and copy to bus-master buffers ...
+	 * ucode filename and max sizes are card-specific. */
 
-	if (!iwl4965_is_rfkill(priv))
-		ieee80211_start_queues(priv->hw);
+	if (!priv->ucode_code.len) {
+		ret = iwl4965_read_ucode(priv);
+		if (ret) {
+			IWL_ERROR("Could not read microcode: %d\n", ret);
+			mutex_unlock(&priv->mutex);
+			goto out_release_irq;
+		}
+	}
 
+	IWL_DEBUG_INFO("Start UP work.\n");
+	__iwl4965_up(priv);
+
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
+			ret = -ETIMEDOUT;
+			goto out_release_irq;
+		}
+	}
+
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
+
+out_release_irq:
+	free_irq(priv->pci_dev->irq, priv);
+out_disable_msi:
+	pci_disable_msi(priv->pci_dev);
+	return ret;
 }
 
 static void iwl4965_mac_stop(struct ieee80211_hw *hw)
@@ -7385,23 +7410,25 @@ static void iwl4965_mac_stop(struct ieee80211_hw *hw)
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-
-	mutex_lock(&priv->mutex);
 	/* stop mac, cancel any scan request and clear
 	 * RXON_FILTER_ASSOC_MSK BIT
 	 */
 	priv->is_open = 0;
-	if (!iwl4965_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211("leave - RF not ready\n");
+
+	if (iwl4965_is_ready_rf(priv)) {
+		mutex_lock(&priv->mutex);
+		iwl4965_scan_cancel_timeout(priv, 100);
+		cancel_delayed_work(&priv->post_associate);
 		mutex_unlock(&priv->mutex);
-		return;
 	}
 
-	iwl4965_scan_cancel_timeout(priv, 100);
-	cancel_delayed_work(&priv->post_associate);
-	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwl4965_commit_rxon(priv);
-	mutex_unlock(&priv->mutex);
+	iwl4965_down(priv);
+
+	flush_workqueue(priv->workqueue);
+	free_irq(priv->pci_dev->irq, priv);
+	pci_disable_msi(priv->pci_dev);
+	pci_save_state(priv->pci_dev);
+	pci_disable_device(priv->pci_dev);
 
 	IWL_DEBUG_MAC80211("leave\n");
 }
@@ -7453,11 +7480,13 @@ static int iwl4965_mac_add_interface(struct ieee80211_hw *hw,
 		IWL_DEBUG_MAC80211("Set %s\n", print_mac(mac, conf->mac_addr));
 		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 	}
-	iwl4965_set_mode(priv, conf->type);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	if (iwl4965_is_ready(priv))
+		iwl4965_set_mode(priv, conf->type);
+
 	mutex_unlock(&priv->mutex);
 
+	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
 }
 
@@ -7559,9 +7588,9 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 
 	IWL_DEBUG_MAC80211("leave\n");
 
-	mutex_unlock(&priv->mutex);
 out:
 	clear_bit(STATUS_CONF_PENDING, &priv->status);
+	mutex_unlock(&priv->mutex);
 	return ret;
 }
 
@@ -7646,6 +7675,9 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
 		return 0;
 	}
 
+	if (!iwl4965_is_alive(priv))
+		return -EAGAIN;
+
 	mutex_lock(&priv->mutex);
 
 	if (conf->bssid)
@@ -8990,6 +9022,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	struct iwl4965_priv *priv;
 	struct ieee80211_hw *hw;
 	int i;
+	DECLARE_MAC_BUF(mac);
 
 	/* Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan. */
@@ -9131,7 +9164,6 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* Device-specific setup */
 	if (iwl4965_hw_set_hw_setting(priv)) {
 		IWL_ERROR("failed to set hw settings\n");
-		mutex_unlock(&priv->mutex);
 		goto out_iounmap;
 	}
 
@@ -9156,50 +9188,53 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	iwl4965_disable_interrupts(priv);
 
-	pci_enable_msi(pdev);
-
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
+	/* nic init */
+	iwl4965_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+                    CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
+
+        iwl4965_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+        err = iwl4965_poll_bit(priv, CSR_GP_CNTRL,
+                          CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+                          CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+        if (err < 0) {
+                IWL_DEBUG_INFO("Failed to init the card\n");
+		goto out_remove_sysfs;
+        }
+	/* Read the EEPROM */
+	err = iwl4965_eeprom_init(priv);
 	if (err) {
-		IWL_ERROR("Could not read microcode: %d\n", err);
-		mutex_unlock(&priv->mutex);
-		goto out_pci_alloc;
+		IWL_ERROR("Unable to init EEPROM\n");
+		goto out_remove_sysfs;
 	}
+	/* MAC Address location in EEPROM same for 3945/4965 */
+	get_eeprom_mac(priv, priv->mac_addr);
+	IWL_DEBUG_INFO("MAC address: %s\n", print_mac(mac, priv->mac_addr));
+	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
 
-	mutex_unlock(&priv->mutex);
-
-	IWL_DEBUG_INFO("Queueing UP work.\n");
+	iwl4965_rate_control_register(priv->hw);
+	err = ieee80211_register_hw(priv->hw);
+	if (err) {
+		IWL_ERROR("Failed to register network device (error %d)\n", err);
+		goto out_remove_sysfs;
+	}
 
-	queue_work(priv->workqueue, &priv->up);
+	priv->hw->conf.beacon_int = 100;
+	priv->mac80211_registered = 1;
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
 
 	return 0;
 
- out_pci_alloc:
-	iwl4965_dealloc_ucode_pci(priv);
-
+ out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
 
  out_release_irq:
-	free_irq(pdev->irq, priv);
-
- out_disable_msi:
-	pci_disable_msi(pdev);
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 	iwl4965_unset_hw_setting(priv);
@@ -9265,8 +9300,6 @@ static void iwl4965_pci_remove(struct pci_dev *pdev)
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 
-	free_irq(pdev->irq, priv);
-	pci_disable_msi(pdev);
 	pci_iounmap(pdev, priv->hw_base);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-- 
1.5.3.4

