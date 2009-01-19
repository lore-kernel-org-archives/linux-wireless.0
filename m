Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:37976 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262AbZASMKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 07:10:34 -0500
Received: by bwz14 with SMTP id 14so8237711bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 04:10:31 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCHv2] iwlagn: fix hw-rfkill while the interface is down
Date: Mon, 19 Jan 2009 13:10:07 +0100
MIME-Version: 1.0
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, mabbaswireless@gmail.com,
	tomas.winkler@intel.com, yi.zhu@intel.com, samuel@sortiz.org
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901191310.08654.helmut.schaa@gmail.com> (sfid-20090119_131040_145044_898075B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently iwlagn is not able to report hw-killswitch events while the
interface is down. This has implications on user space tools (like
NetworkManager) relying on rfkill notifications to bring the interface
up once the wireless gets enabled through a hw killswitch.

Thus, enable the device already in iwl_pci_probe instead of iwl_up
and enable interrups while the interface is down in order to get
notified about killswitch state changes. The firmware loading is still
done in iwl_up.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

That's the same patch as for 3945 I sent last week, but instead of polling
the killswitch state, we can use interrupts for iwlagn.

I did not do any power measurements but I think it is more efficient to
leave the pci device enabled (without firmware being loaded) then to change
NetworkManagers behaviour to keep the interface up all the time just to get
rfkill notifications (which means the firmware has to be loaded).

Changes since the first version:
- Rebased to current wireless-testing
- Minor cleanups

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d1994de..3b64639 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1399,13 +1399,16 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 				hw_rf_kill ? "disable radio" : "enable radio");
 
 		/* driver only loads ucode once setting the interface up.
-		 * the driver as well won't allow loading if RFKILL is set
-		 * therefore no need to restart the driver from this handler
+		 * the driver allows loading the ucode even if the radio
+		 * is killed. Hence update the killswitch state here. The
+		 * rfkill handler will care about restarting if needed.
 		 */
-		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status)) {
-			clear_bit(STATUS_RF_KILL_HW, &priv->status);
-			if (priv->is_open && !iwl_is_rfkill(priv))
-				queue_work(priv->workqueue, &priv->up);
+		if (!test_bit(STATUS_ALIVE, &priv->status)) {
+			if (hw_rf_kill)
+				set_bit(STATUS_RF_KILL_HW, &priv->status);
+			else
+				clear_bit(STATUS_RF_KILL_HW, &priv->status);
+			queue_work(priv->workqueue, &priv->rf_kill);
 		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
@@ -2158,7 +2161,8 @@ static void iwl_bg_rf_kill(struct work_struct *work)
 		IWL_DEBUG(IWL_DL_RF_KILL,
 			  "HW and/or SW RF Kill no longer active, restarting "
 			  "device\n");
-		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
+		if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
+		     test_bit(STATUS_ALIVE, &priv->status))
 			queue_work(priv->workqueue, &priv->restart);
 	} else {
 		/* make sure mac80211 stop sending Tx frame */
@@ -2355,31 +2359,9 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 	int ret;
-	u16 pci_cmd;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (pci_enable_device(priv->pci_dev)) {
-		IWL_ERR(priv, "Fail to pci_enable_device\n");
-		return -ENODEV;
-	}
-	pci_restore_state(priv->pci_dev);
-	pci_enable_msi(priv->pci_dev);
-
-	/* enable interrupts if needed: hw bug w/a */
-	pci_read_config_word(priv->pci_dev, PCI_COMMAND, &pci_cmd);
-	if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
-		pci_cmd &= ~PCI_COMMAND_INTX_DISABLE;
-		pci_write_config_word(priv->pci_dev, PCI_COMMAND, pci_cmd);
-	}
-
-	ret = request_irq(priv->pci_dev->irq, iwl_isr, IRQF_SHARED,
-			  DRV_NAME, priv);
-	if (ret) {
-		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
-		goto out_disable_msi;
-	}
-
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);
 
@@ -2392,7 +2374,7 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 		if (ret) {
 			IWL_ERR(priv, "Could not read microcode: %d\n", ret);
 			mutex_unlock(&priv->mutex);
-			goto out_release_irq;
+			return ret;
 		}
 	}
 
@@ -2403,7 +2385,7 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 	iwl_rfkill_set_hw_state(priv);
 
 	if (ret)
-		goto out_release_irq;
+		return ret;
 
 	if (iwl_is_rfkill(priv))
 		goto out;
@@ -2422,8 +2404,7 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 		if (!test_bit(STATUS_READY, &priv->status)) {
 			IWL_ERR(priv, "START_ALIVE timeout after %dms.\n",
 				jiffies_to_msecs(UCODE_READY_TIMEOUT));
-			ret = -ETIMEDOUT;
-			goto out_release_irq;
+			return -ETIMEDOUT;
 		}
 	}
 
@@ -2431,15 +2412,6 @@ out:
 	priv->is_open = 1;
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
-
-out_release_irq:
-	free_irq(priv->pci_dev->irq, priv);
-out_disable_msi:
-	pci_disable_msi(priv->pci_dev);
-	pci_disable_device(priv->pci_dev);
-	priv->is_open = 0;
-	IWL_DEBUG_MAC80211("leave - failed\n");
-	return ret;
 }
 
 static void iwl_mac_stop(struct ieee80211_hw *hw)
@@ -2467,10 +2439,10 @@ static void iwl_mac_stop(struct ieee80211_hw *hw)
 	iwl_down(priv);
 
 	flush_workqueue(priv->workqueue);
-	free_irq(priv->pci_dev->irq, priv);
-	pci_disable_msi(priv->pci_dev);
-	pci_save_state(priv->pci_dev);
-	pci_disable_device(priv->pci_dev);
+
+	/* enable interrupts again in order to receive rfkill changes */
+	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
+	iwl_enable_interrupts(priv);
 
 	IWL_DEBUG_MAC80211("leave\n");
 }
@@ -3729,6 +3701,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ieee80211_hw *hw;
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	unsigned long flags;
+	u16 pci_cmd;
 
 	/************************
 	 * 1. Allocating HW data
@@ -3872,26 +3845,36 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	iwl_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	pci_enable_msi(priv->pci_dev);
+
+	err = request_irq(priv->pci_dev->irq, iwl_isr, IRQF_SHARED,
+			  DRV_NAME, priv);
+	if (err) {
+		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
+		goto out_disable_msi;
+	}
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl_attribute_group);
 	if (err) {
 		IWL_ERR(priv, "failed to create sysfs device attributes\n");
 		goto out_uninit_drv;
 	}
 
-
 	iwl_setup_deferred_work(priv);
 	iwl_setup_rx_handlers(priv);
 
-	/********************
-	 * 9. Conclude
-	 ********************/
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-
 	/**********************************
-	 * 10. Setup and register mac80211
+	 * 9. Setup and register mac80211
 	 **********************************/
 
+	/* enable interrupts if needed: hw bug w/a */
+	pci_read_config_word(priv->pci_dev, PCI_COMMAND, &pci_cmd);
+	if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
+		pci_cmd &= ~PCI_COMMAND_INTX_DISABLE;
+		pci_write_config_word(priv->pci_dev, PCI_COMMAND, pci_cmd);
+	}
+
+	iwl_enable_interrupts(priv);
+
 	err = iwl_setup_mac(priv);
 	if (err)
 		goto out_remove_sysfs;
@@ -3900,15 +3883,27 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		IWL_ERR(priv, "failed to create debugfs files\n");
 
+	/* If platform's RF_KILL switch is NOT set to KILL */
+	if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
+		clear_bit(STATUS_RF_KILL_HW, &priv->status);
+	else
+		set_bit(STATUS_RF_KILL_HW, &priv->status);
+
 	err = iwl_rfkill_init(priv);
 	if (err)
 		IWL_ERR(priv, "Unable to initialize RFKILL system. "
 				  "Ignoring error: %d\n", err);
+	else
+		iwl_rfkill_set_hw_state(priv);
+
 	iwl_power_initialize(priv);
 	return 0;
 
  out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &iwl_attribute_group);
+ out_disable_msi:
+	pci_disable_msi(priv->pci_dev);
+	pci_disable_device(priv->pci_dev);
  out_uninit_drv:
 	iwl_uninit_drv(priv);
  out_free_eeprom:
@@ -3980,6 +3975,8 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 
+	free_irq(priv->pci_dev->irq, priv);
+	pci_disable_msi(priv->pci_dev);
 	pci_iounmap(pdev, priv->hw_base);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
@@ -4005,6 +4002,8 @@ static int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		priv->is_open = 1;
 	}
 
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
@@ -4015,6 +4014,9 @@ static int iwl_pci_resume(struct pci_dev *pdev)
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
 	pci_set_power_state(pdev, PCI_D0);
+	pci_enable_device(pdev);
+	pci_restore_state(pdev);
+	iwl_enable_interrupts(priv);
 
 	if (priv->is_open)
 		iwl_mac_start(priv->hw);
