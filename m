Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49030 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbYAOC06 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 21:26:58 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 06/12] iwlwifi: fix problem when rf_killswitch change during suspend/resume
Date: Mon, 14 Jan 2008 17:46:19 -0800
Message-Id: <1200361585-31801-7-git-send-email-reinette.chatre@intel.com> (sfid-20080115_022716_587785_A7124944)
In-Reply-To: <1200361585-31801-6-git-send-email-reinette.chatre@intel.com>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-2-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-3-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-4-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-5-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

After we delay device initialization until interface up, there are more
conditions for the hardware rf_kill switch states during suspend and
resume. For example, before suspend we can have interface up or down,
rf_kill enable or disable; before resume we can have rf_kill enable or
disable. So there are totally 2^3 = 8 conditions to handle. This patch
addressed this problem and makes sure every condition works correctly.

This patch also merges the device suspend and resume handlers with the
mac_start and mac_stop code since they are basically doing the same
thing.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  124 +++++++++----------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  133 +++++++++------------------
 2 files changed, 90 insertions(+), 167 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1a01475..d5d40bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6340,7 +6340,19 @@ static int __iwl3945_up(struct iwl3945_priv *priv)
 	if (test_bit(STATUS_RF_KILL_SW, &priv->status)) {
 		IWL_WARNING("Radio disabled by SW RF kill (module "
 			    "parameter)\n");
-		return 0;
+		return -ENODEV;
+	}
+
+	/* If platform's RF_KILL switch is NOT set to KILL */
+	if (iwl3945_read32(priv, CSR_GP_CNTRL) &
+				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
+		clear_bit(STATUS_RF_KILL_HW, &priv->status);
+	else {
+		set_bit(STATUS_RF_KILL_HW, &priv->status);
+		if (!test_bit(STATUS_IN_SUSPEND, &priv->status)) {
+			IWL_WARNING("Radio disabled by HW RF Kill switch\n");
+			return -ENODEV;
+		}
 	}
 
 	iwl3945_write32(priv, CSR_INT, 0xFFFFFFFF);
@@ -6370,6 +6382,10 @@ static int __iwl3945_up(struct iwl3945_priv *priv)
 	memcpy(priv->ucode_data_backup.v_addr, priv->ucode_data.v_addr,
 	       priv->ucode_data.len);
 
+	/* We return success when we resume from suspend and rf_kill is on. */
+	if (test_bit(STATUS_RF_KILL_HW, &priv->status))
+		return 0;
+
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
 		iwl3945_clear_stations_table(priv);
@@ -6914,12 +6930,18 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 		}
 	}
 
-	IWL_DEBUG_INFO("Start UP work.\n");
-	__iwl3945_up(priv);
+	ret = __iwl3945_up(priv);
 
-	priv->is_open = 1;
 	mutex_unlock(&priv->mutex);
 
+	if (ret)
+		goto out_release_irq;
+
+	IWL_DEBUG_INFO("Start UP work.\n");
+
+	if (test_bit(STATUS_IN_SUSPEND, &priv->status))
+		return 0;
+
 	/* Wait for START_ALIVE from ucode. Otherwise callbacks from
 	 * mac80211 will not be run successfully. */
 	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
@@ -6934,6 +6956,7 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 		}
 	}
 
+	priv->is_open = 1;
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
 
@@ -6941,6 +6964,9 @@ out_release_irq:
 	free_irq(priv->pci_dev->irq, priv);
 out_disable_msi:
 	pci_disable_msi(priv->pci_dev);
+	pci_disable_device(priv->pci_dev);
+	priv->is_open = 0;
+	IWL_DEBUG_MAC80211("leave - failed\n");
 	return ret;
 }
 
@@ -6950,12 +6976,17 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	/* stop mac, cancel any scan request and clear
-	 * RXON_FILTER_ASSOC_MSK BIT
-	 */
+	if (!priv->is_open) {
+		IWL_DEBUG_MAC80211("leave - skip\n");
+		return;
+	}
+
 	priv->is_open = 0;
 
 	if (iwl3945_is_ready_rf(priv)) {
+		/* stop mac, cancel any scan request and clear
+		 * RXON_FILTER_ASSOC_MSK BIT
+		 */
 		mutex_lock(&priv->mutex);
 		iwl3945_scan_cancel_timeout(priv, 100);
 		cancel_delayed_work(&priv->post_associate);
@@ -7329,7 +7360,6 @@ static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 	mutex_unlock(&priv->mutex);
 
 	IWL_DEBUG_MAC80211("leave\n");
-
 }
 
 static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
@@ -8726,89 +8756,27 @@ static int iwl3945_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
 
-	set_bit(STATUS_IN_SUSPEND, &priv->status);
-
-	/* Take down the device; powers it off, etc. */
-	iwl3945_down(priv);
-
-	if (priv->mac80211_registered)
-		ieee80211_stop_queues(priv->hw);
+	if (priv->is_open) {
+		set_bit(STATUS_IN_SUSPEND, &priv->status);
+		iwl3945_mac_stop(priv->hw);
+		priv->is_open = 1;
+	}
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
 }
 
-static void iwl3945_resume(struct iwl3945_priv *priv)
-{
-	unsigned long flags;
-
-	/* The following it a temporary work around due to the
-	 * suspend / resume not fully initializing the NIC correctly.
-	 * Without all of the following, resume will not attempt to take
-	 * down the NIC (it shouldn't really need to) and will just try
-	 * and bring the NIC back up.  However that fails during the
-	 * ucode verification process.  This then causes iwl3945_down to be
-	 * called *after* iwl3945_hw_nic_init() has succeeded -- which
-	 * then lets the next init sequence succeed.  So, we've
-	 * replicated all of that NIC init code here... */
-
-	iwl3945_write32(priv, CSR_INT, 0xFFFFFFFF);
-
-	iwl3945_hw_nic_init(priv);
-
-	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR,
-		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-	iwl3945_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-
-	/* tell the device to stop sending interrupts */
-	iwl3945_disable_interrupts(priv);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl3945_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-
-	if (!iwl3945_grab_nic_access(priv)) {
-		iwl3945_write_prph(priv, APMG_CLK_DIS_REG,
-					 APMG_CLK_VAL_DMA_CLK_RQT);
-		iwl3945_release_nic_access(priv);
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	udelay(5);
-
-	iwl3945_hw_nic_reset(priv);
-
-	/* Bring the device back up */
-	clear_bit(STATUS_IN_SUSPEND, &priv->status);
-	queue_work(priv->workqueue, &priv->up);
-}
-
 static int iwl3945_pci_resume(struct pci_dev *pdev)
 {
 	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
-	int err;
-
-	printk(KERN_INFO "Coming out of suspend...\n");
 
 	pci_set_power_state(pdev, PCI_D0);
-	err = pci_enable_device(pdev);
-	pci_restore_state(pdev);
 
-	/*
-	 * Suspend/Resume resets the PCI configuration space, so we have to
-	 * re-disable the RETRY_TIMEOUT register (0x41) to keep PCI Tx retries
-	 * from interfering with C3 CPU state. pci_restore_state won't help
-	 * here since it only restores the first 64 bytes pci config header.
-	 */
-	pci_write_config_byte(pdev, 0x41, 0x00);
-
-	iwl3945_resume(priv);
+	if (priv->is_open)
+		iwl3945_mac_start(priv->hw);
 
+	clear_bit(STATUS_IN_SUSPEND, &priv->status);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 090f883..621871d 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6761,7 +6761,6 @@ static void iwl4965_down(struct iwl4965_priv *priv)
 static int __iwl4965_up(struct iwl4965_priv *priv)
 {
 	int rc, i;
-	u32 hw_rf_kill = 0;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
 		IWL_WARNING("Exit pending; will not bring the NIC up\n");
@@ -6771,7 +6770,19 @@ static int __iwl4965_up(struct iwl4965_priv *priv)
 	if (test_bit(STATUS_RF_KILL_SW, &priv->status)) {
 		IWL_WARNING("Radio disabled by SW RF kill (module "
 			    "parameter)\n");
-		return 0;
+		return -ENODEV;
+	}
+
+	/* If platform's RF_KILL switch is NOT set to KILL */
+	if (iwl4965_read32(priv, CSR_GP_CNTRL) &
+				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
+		clear_bit(STATUS_RF_KILL_HW, &priv->status);
+	else {
+		set_bit(STATUS_RF_KILL_HW, &priv->status);
+		if (!test_bit(STATUS_IN_SUSPEND, &priv->status)) {
+			IWL_WARNING("Radio disabled by HW RF Kill switch\n");
+			return -ENODEV;
+		}
 	}
 
 	iwl4965_write32(priv, CSR_INT, 0xFFFFFFFF);
@@ -6801,17 +6812,9 @@ static int __iwl4965_up(struct iwl4965_priv *priv)
 	memcpy(priv->ucode_data_backup.v_addr, priv->ucode_data.v_addr,
 	       priv->ucode_data.len);
 
-	/* If platform's RF_KILL switch is set to KILL,
-	 * wait for BIT_INT_RF_KILL interrupt before loading uCode
-	 * and getting things started */
-	if (!(iwl4965_read32(priv, CSR_GP_CNTRL) &
-				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
-		hw_rf_kill = 1;
-
-	if (test_bit(STATUS_RF_KILL_HW, &priv->status) || hw_rf_kill) {
-		IWL_WARNING("Radio disabled by HW RF Kill switch\n");
+	/* We return success when we resume from suspend and rf_kill is on. */
+	if (test_bit(STATUS_RF_KILL_HW, &priv->status))
 		return 0;
-	}
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
@@ -7374,12 +7377,18 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 		}
 	}
 
-	IWL_DEBUG_INFO("Start UP work.\n");
-	__iwl4965_up(priv);
+	ret = __iwl4965_up(priv);
 
-	priv->is_open = 1;
 	mutex_unlock(&priv->mutex);
 
+	if (ret)
+		goto out_release_irq;
+
+	IWL_DEBUG_INFO("Start UP work done.\n");
+
+	if (test_bit(STATUS_IN_SUSPEND, &priv->status))
+		return 0;
+
 	/* Wait for START_ALIVE from ucode. Otherwise callbacks from
 	 * mac80211 will not be run successfully. */
 	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
@@ -7394,6 +7403,7 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 		}
 	}
 
+	priv->is_open = 1;
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
 
@@ -7401,6 +7411,9 @@ out_release_irq:
 	free_irq(priv->pci_dev->irq, priv);
 out_disable_msi:
 	pci_disable_msi(priv->pci_dev);
+	pci_disable_device(priv->pci_dev);
+	priv->is_open = 0;
+	IWL_DEBUG_MAC80211("leave - failed\n");
 	return ret;
 }
 
@@ -7410,12 +7423,17 @@ static void iwl4965_mac_stop(struct ieee80211_hw *hw)
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	/* stop mac, cancel any scan request and clear
-	 * RXON_FILTER_ASSOC_MSK BIT
-	 */
+	if (!priv->is_open) {
+		IWL_DEBUG_MAC80211("leave - skip\n");
+		return;
+	}
+
 	priv->is_open = 0;
 
 	if (iwl4965_is_ready_rf(priv)) {
+		/* stop mac, cancel any scan request and clear
+		 * RXON_FILTER_ASSOC_MSK BIT
+		 */
 		mutex_lock(&priv->mutex);
 		iwl4965_scan_cancel_timeout(priv, 100);
 		cancel_delayed_work(&priv->post_associate);
@@ -8147,7 +8165,6 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 	mutex_unlock(&priv->mutex);
 
 	IWL_DEBUG_MAC80211("leave\n");
-
 }
 
 static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
@@ -9322,89 +9339,27 @@ static int iwl4965_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct iwl4965_priv *priv = pci_get_drvdata(pdev);
 
-	set_bit(STATUS_IN_SUSPEND, &priv->status);
-
-	/* Take down the device; powers it off, etc. */
-	iwl4965_down(priv);
-
-	if (priv->mac80211_registered)
-		ieee80211_stop_queues(priv->hw);
+	if (priv->is_open) {
+		set_bit(STATUS_IN_SUSPEND, &priv->status);
+		iwl4965_mac_stop(priv->hw);
+		priv->is_open = 1;
+	}
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
 }
 
-static void iwl4965_resume(struct iwl4965_priv *priv)
-{
-	unsigned long flags;
-
-	/* The following it a temporary work around due to the
-	 * suspend / resume not fully initializing the NIC correctly.
-	 * Without all of the following, resume will not attempt to take
-	 * down the NIC (it shouldn't really need to) and will just try
-	 * and bring the NIC back up.  However that fails during the
-	 * ucode verification process.  This then causes iwl4965_down to be
-	 * called *after* iwl4965_hw_nic_init() has succeeded -- which
-	 * then lets the next init sequence succeed.  So, we've
-	 * replicated all of that NIC init code here... */
-
-	iwl4965_write32(priv, CSR_INT, 0xFFFFFFFF);
-
-	iwl4965_hw_nic_init(priv);
-
-	iwl4965_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl4965_write32(priv, CSR_UCODE_DRV_GP1_CLR,
-		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-	iwl4965_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl4965_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl4965_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-
-	/* tell the device to stop sending interrupts */
-	iwl4965_disable_interrupts(priv);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl4965_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-
-	if (!iwl4965_grab_nic_access(priv)) {
-		iwl4965_write_prph(priv, APMG_CLK_DIS_REG,
-				APMG_CLK_VAL_DMA_CLK_RQT);
-		iwl4965_release_nic_access(priv);
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	udelay(5);
-
-	iwl4965_hw_nic_reset(priv);
-
-	/* Bring the device back up */
-	clear_bit(STATUS_IN_SUSPEND, &priv->status);
-	queue_work(priv->workqueue, &priv->up);
-}
-
 static int iwl4965_pci_resume(struct pci_dev *pdev)
 {
 	struct iwl4965_priv *priv = pci_get_drvdata(pdev);
-	int err;
-
-	printk(KERN_INFO "Coming out of suspend...\n");
 
 	pci_set_power_state(pdev, PCI_D0);
-	err = pci_enable_device(pdev);
-	pci_restore_state(pdev);
 
-	/*
-	 * Suspend/Resume resets the PCI configuration space, so we have to
-	 * re-disable the RETRY_TIMEOUT register (0x41) to keep PCI Tx retries
-	 * from interfering with C3 CPU state. pci_restore_state won't help
-	 * here since it only restores the first 64 bytes pci config header.
-	 */
-	pci_write_config_byte(pdev, 0x41, 0x00);
-
-	iwl4965_resume(priv);
+	if (priv->is_open)
+		iwl4965_mac_start(priv->hw);
 
+	clear_bit(STATUS_IN_SUSPEND, &priv->status);
 	return 0;
 }
 
-- 
1.5.3.4

