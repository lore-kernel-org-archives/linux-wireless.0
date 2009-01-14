Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:54974 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZANPxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 10:53:23 -0500
Received: by bwz14 with SMTP id 14so1959929bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2009 07:53:20 -0800 (PST)
To: linux-wireless@vger.kernel.org
Subject: [PATCH] iwl3945: report killswitch changes even if the interface is down
Date: Wed, 14 Jan 2009 16:58:50 +0100
Cc: linville@tuxdriver.com, ipw3945-devel@lists.sourceforge.net,
	mabbaswireless@gmail.com, tomas.winkler@intel.com,
	yi.zhu@intel.com, reinette.chatre@intel.com, dcbw@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901141658.50842.helmut.schaa@gmail.com> (sfid-20090114_165328_307992_3D231A26)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently iwl3945 is not able to report hw-killswitch events while the
interface is down. This has implications on user space tools (like
NetworkManager) relying on rfkill notifications to bring the interface
up once the wireless gets enabled through a hw killswitch.

Thus enable the device already in iwl3945_pci_probe instead of iwl3945_up
and poll the CSR_GP_CNTRL register to update the killswitch state every
two seconds. The polling is only needed on 3945 hardware as this adapter
does not use interrupts to signal rfkill changes to the driver (in case no
firmware is loaded). The firmware loading is still done in iwl3945_up.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

I did not do any power measurements but I think it is more efficient to
leave the pci device enabled (without firmware being loaded) then to change
NetworkManagers behaviour to keep the interface up all the time just to get
rfkill notifications (which means the firmware has to be loaded).

The patch applies against wireless-testing from today.

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index fd34ba8..4d437cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1041,6 +1041,7 @@ struct iwl_priv {
 
 	/*For 3945 only*/
 	struct delayed_work thermal_periodic;
+	struct delayed_work rfkill_poll;
 
 	/* TX Power */
 	s8 tx_power_user_lmt;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 15425a0..04b7080 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5479,7 +5479,8 @@ static void iwl3945_bg_rf_kill(struct work_struct *work)
 		IWL_DEBUG(IWL_DL_INFO | IWL_DL_RF_KILL,
 			  "HW and/or SW RF Kill no longer active, restarting "
 			  "device\n");
-		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
+		if (!test_bit(STATUS_EXIT_PENDING, &priv->status) && 
+		     test_bit(STATUS_ALIVE, &priv->status))
 			queue_work(priv->workqueue, &priv->restart);
 	} else {
 
@@ -5496,6 +5497,25 @@ static void iwl3945_bg_rf_kill(struct work_struct *work)
 	iwl3945_rfkill_set_hw_state(priv);
 }
 
+static void iwl3945_rfkill_poll(struct work_struct *data)
+{
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, rfkill_poll.work);
+	unsigned long status = priv->status;
+
+	if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
+		clear_bit(STATUS_RF_KILL_HW, &priv->status);
+	else
+		set_bit(STATUS_RF_KILL_HW, &priv->status);
+
+	if (test_bit(STATUS_RF_KILL_HW, &status) != test_bit(STATUS_RF_KILL_HW, &priv->status))
+		queue_work(priv->workqueue, &priv->rf_kill);
+
+	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
+			   round_jiffies_relative(2 * HZ));
+
+}
+
 #define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)
 
 static void iwl3945_bg_scan_check(struct work_struct *data)
@@ -5898,20 +5918,6 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (pci_enable_device(priv->pci_dev)) {
-		IWL_ERR(priv, "Fail to pci_enable_device\n");
-		return -ENODEV;
-	}
-	pci_restore_state(priv->pci_dev);
-	pci_enable_msi(priv->pci_dev);
-
-	ret = request_irq(priv->pci_dev->irq, iwl3945_isr, IRQF_SHARED,
-			  DRV_NAME, priv);
-	if (ret) {
-		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
-		goto out_disable_msi;
-	}
-
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);
 
@@ -5962,10 +5968,6 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 	return 0;
 
 out_release_irq:
-	free_irq(priv->pci_dev->irq, priv);
-out_disable_msi:
-	pci_disable_msi(priv->pci_dev);
-	pci_disable_device(priv->pci_dev);
 	priv->is_open = 0;
 	IWL_DEBUG_MAC80211("leave - failed\n");
 	return ret;
@@ -5996,10 +5998,6 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 	iwl3945_down(priv);
 
 	flush_workqueue(priv->workqueue);
-	free_irq(priv->pci_dev->irq, priv);
-	pci_disable_msi(priv->pci_dev);
-	pci_save_state(priv->pci_dev);
-	pci_disable_device(priv->pci_dev);
 
 	IWL_DEBUG_MAC80211("leave\n");
 }
@@ -7207,6 +7205,7 @@ static void iwl3945_setup_deferred_work(struct iwl_priv *priv)
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl3945_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl3945_bg_alive_start);
 	INIT_DELAYED_WORK(&priv->scan_check, iwl3945_bg_scan_check);
+	INIT_DELAYED_WORK(&priv->rfkill_poll, iwl3945_rfkill_poll);
 
 	iwl3945_hw_setup_deferred_work(priv);
 
@@ -7497,6 +7496,15 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	iwl3945_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	pci_enable_msi(priv->pci_dev);
+
+	err = request_irq(priv->pci_dev->irq, iwl3945_isr, IRQF_SHARED,
+			  DRV_NAME, priv);
+	if (err) {
+		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
+		goto out_disable_msi;
+	}
+
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 	if (err) {
 		IWL_ERR(priv, "failed to create sysfs device attributes\n");
@@ -7507,14 +7515,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	iwl3945_setup_deferred_work(priv);
 	iwl3945_setup_rx_handlers(priv);
 
-	/***********************
-	 * 9. Conclude
-	 * ********************/
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-
 	/*********************************
-	 * 10. Setup and Register mac80211
+	 * 9. Setup and Register mac80211
 	 * *******************************/
 
 	err = ieee80211_register_hw(priv->hw);
@@ -7539,10 +7541,12 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	iwl3945_free_geos(priv);
 
  out_release_irq:
+	free_irq(priv->pci_dev->irq, priv);
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 	iwl3945_unset_hw_params(priv);
-
+ out_disable_msi:
+	pci_disable_msi(priv->pci_dev);
  out_iounmap:
 	pci_iounmap(pdev, priv->hw_base);
  out_pci_release_regions:
@@ -7605,6 +7609,9 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 
+	free_irq(pdev->irq, priv);
+	pci_disable_msi(pdev);
+
 	pci_iounmap(pdev, priv->hw_base);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
@@ -7630,7 +7637,8 @@ static int iwl3945_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		iwl3945_mac_stop(priv->hw);
 		priv->is_open = 1;
 	}
-
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
@@ -7641,6 +7649,8 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
 	pci_set_power_state(pdev, PCI_D0);
+	pci_enable_device(pdev);
+	pci_restore_state(pdev);
 
 	if (priv->is_open)
 		iwl3945_mac_start(priv->hw);
@@ -7719,6 +7729,10 @@ int iwl3945_rfkill_init(struct iwl_priv *priv)
 		goto freed_rfkill;
 	}
 
+	/* Start monitoring the killswitch */
+	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
+			   2 * HZ);
+
 	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
 	return ret;
 
@@ -7734,6 +7748,8 @@ error:
 
 void iwl3945_rfkill_unregister(struct iwl_priv *priv)
 {
+	cancel_delayed_work(&priv->rfkill_poll);
+
 	if (priv->rfkill)
 		rfkill_unregister(priv->rfkill);
