Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agave.telenet-ops.be ([195.130.137.77]:59048 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbXLBWSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2007 17:18:47 -0500
Message-ID: <47532F45.9020508@telenet.be> (sfid-20071202_221853_056924_9279767B)
Date: Sun, 02 Dec 2007 23:18:45 +0100
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomasw@gmail.com>, Ben Gamari <ben@mw0.ath.cx>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: Re: [PATCH] iwlwifi: delay firmware loading from pci_probe to network
 interface open
References: <1196327913-24715-1-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1196327913-24715-1-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi wrote:
> Tomas pointed my assertion "iwlwifi cannot get MAC address without
> firmware being loaded first" is not true. Here is a updated patch to
> get iwlwifi device MAC address from EEPROM before firmware being
> loaded. With this function, I don't need the mac80211 change for "set
> interface MAC address after driver's start() is called".
>
> BTW, I also pci_enable_device() and pci_disable_device() in the
> driver's start() and stop() handler. Hope it will make the device
> consume less power when the interface is not up.
>
> P.S. If you use wpa_supplicant with the patch. Please use 0.6.0 or
> above. I've seen problems with wpa_supplicant-0.4.8 in the order of
> interface up and wext parameters setting. After this patch, setting
> any wext parameters before interface up will likely return an error.
>
>
> This patch moves the firmware loading (read firmware from disk and load
> it into the device SRAM) from pci_probe time to the first network
> interface open time. There are two reasons for doing this:
>


There are a few problems with this patch as was reported on ipw3945-devel

I have attempted to identify and fix them all, which makes it work for
me again.

The main problem was:
pci_save/restore_state() wasn't being called when the device was
disabled in pci_probe to save power. which meant that when it was
reenabled it had no idea about the dma and hence the card would
seemingly never wake up, seeing as no init_alive_resp would be received

secondary problems:
1) additionally the code should not have dereferenced a null pointer. This
happened in mac80211 because the failure was hidden and null was returned
in ops->start

2) when the ops->start failed, the irq was registered, but never freeded because
ops->close wouldn't be called. i added a bit of error handling in the function
and pulled enable/disbale msi there because i was having additional oopses when testing
but i think they might be redundant. I figured it made sense to keep these two events
together though

3) there was an inconsistency in iwl*_mac_stop
the if condition was ones checked for falseness in 3945 and for trueness in 4965
i believe 4965 code was right so i altered it in the 3945 code

I wasn't really sure what mailinglists to spam with this message, but seeing as it
was (only?) posted here but only in iwlwifi git, ... Anyway the patch i reviewed
was the one in iwlwifi git, and my patch below is diffed against that git. The 4965
part of the patch is not tested. Without further ado:

signed-off-by Ian Schram <ischram@telenet.be>
---
diff --git a/origin/iwl3945-base.c b/origin/iwl3945-base.c
index 970ae6e..e6e778a 100644
--- a/origin/iwl3945-base.c
+++ b/origin/iwl3945-base.c
@@ -6979,12 +6979,14 @@ static int iwl3945_mac_open(struct ieee80211_hw *hw)
 		IWL_ERROR("Fail to pci_enable_device\n");
 		return -ENODEV;
 	}
+	pci_restore_state(priv->pci_dev);

+	pci_enable_msi(priv->pci_dev);
 	ret = request_irq(priv->pci_dev->irq, iwl3945_isr, IRQF_SHARED,
 			  DRV_NAME, priv);
 	if (ret) {
 		IWL_ERROR("Error allocating IRQ %d\n", priv->pci_dev->irq);
-		return ret;
+		goto out_disable_msi;
 	}

 	/* we should be verifying the device is ready to be opened */
@@ -6999,7 +7001,7 @@ static int iwl3945_mac_open(struct ieee80211_hw *hw)
 		if (ret) {
 			IWL_ERROR("Could not read microcode: %d\n", ret);
 			mutex_unlock(&priv->mutex);
-			return ret;
+			goto out_release_irq;
 		}
 	}

@@ -7018,11 +7020,19 @@ static int iwl3945_mac_open(struct ieee80211_hw *hw)
 		if (!test_bit(STATUS_READY, &priv->status)) {
 			IWL_ERROR("Wait for START_ALIVE timeout after %dms.\n",
 				  jiffies_to_msecs(UCODE_READY_TIMEOUT));
+			ret = -ENODEV;
+			goto out_release_irq;
 		}
 	}

 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
+
+out_release_irq:
+	free_irq(priv->pci_dev->irq, priv);
+out_disable_msi:
+	pci_disable_msi(priv->pci_dev);
+	return ret;	
 }

 static int iwl3945_mac_stop(struct ieee80211_hw *hw)
@@ -7036,7 +7046,7 @@ static int iwl3945_mac_stop(struct ieee80211_hw *hw)
 	 */
 	priv->is_open = 0;

-	if (!iwl3945_is_ready_rf(priv)) {
+	if (iwl3945_is_ready_rf(priv)) {
 		mutex_lock(&priv->mutex);
 		iwl3945_scan_cancel_timeout(priv, 100);
 		cancel_delayed_work(&priv->post_associate);
@@ -7047,6 +7057,7 @@ static int iwl3945_mac_stop(struct ieee80211_hw *hw)

 	flush_workqueue(priv->workqueue);
 	free_irq(priv->pci_dev->irq, priv);
+	pci_disable_msi(priv->pci_dev);

 	pci_disable_device(priv->pci_dev);

@@ -8638,8 +8649,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e

 	iwl3945_disable_interrupts(priv);

-	pci_enable_msi(pdev);
-
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 	if (err) {
 		IWL_ERROR("failed to create sysfs device attributes\n");
@@ -8678,6 +8687,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e

 	priv->hw->conf.beacon_int = 100;
 	priv->mac80211_registered = 1;
+	pci_save_state(pdev);
 	pci_disable_device(pdev);

 	return 0;
@@ -8686,8 +8696,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);

  out_release_irq:
-	free_irq(pdev->irq, priv);
-	pci_disable_msi(pdev);
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 	iwl3945_unset_hw_setting(priv);
@@ -8754,7 +8762,6 @@ static void iwl3945_pci_remove(struct pci_dev *pdev)
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;

-	pci_disable_msi(pdev);
 	pci_iounmap(pdev, priv->hw_base);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
diff --git a/origin/iwl4965-base.c b/origin/iwl4965-base.c
index 21397bd..e3a9bb9 100644
--- a/origin/iwl4965-base.c
+++ b/origin/iwl4965-base.c
@@ -7418,12 +7418,14 @@ static int iwl4965_mac_open(struct ieee80211_hw *hw)
 		IWL_ERROR("Fail to pci_enable_device\n");
 		return -ENODEV;
 	}
+	pci_restore_state(priv->pci_dev);

+	pci_enable_msi(priv->pci_dev);
 	ret = request_irq(priv->pci_dev->irq, iwl4965_isr, IRQF_SHARED,
 			  DRV_NAME, priv);
 	if (ret) {
 		IWL_ERROR("Error allocating IRQ %d\n", priv->pci_dev->irq);
-		return ret;
+		goto out_disable_msi;
 	}

 	/* we should be verifying the device is ready to be opened */
@@ -7438,7 +7440,7 @@ static int iwl4965_mac_open(struct ieee80211_hw *hw)
 		if (ret) {
 			IWL_ERROR("Could not read microcode: %d\n", ret);
 			mutex_unlock(&priv->mutex);
-			return ret;
+			goto out_free_irq;
 		}
 	}

@@ -7457,11 +7459,19 @@ static int iwl4965_mac_open(struct ieee80211_hw *hw)
 		if (!test_bit(STATUS_READY, &priv->status)) {
 			IWL_ERROR("Wait for START_ALIVE timeout after %dms.\n",
 				  jiffies_to_msecs(UCODE_READY_TIMEOUT));
+			ret=-ETIMEDOUT;
+			goto out_release_irq;
 		}
 	}

 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
+
+out_release_irq:
+	free_irq(priv->pci_dev->irq, priv);
+out_disable_msi:
+	pci_disable_msi(priv->pci_dev);
+	return ret;
 }

 static int iwl4965_mac_stop(struct ieee80211_hw *hw)
@@ -7486,6 +7496,7 @@ static int iwl4965_mac_stop(struct ieee80211_hw *hw)

 	flush_workqueue(priv->workqueue);
 	free_irq(priv->pci_dev->irq, priv);
+	pci_disable_msi(priv->pci_dev);

 	pci_disable_device(priv->pci_dev);

@@ -9283,8 +9294,6 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e

 	iwl4965_disable_interrupts(priv);

-	pci_enable_msi(pdev);
-
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl4965_attribute_group);
 	if (err) {
 		IWL_ERROR("failed to create sysfs device attributes\n");
@@ -9323,6 +9332,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e

 	priv->hw->conf.beacon_int = 100;
 	priv->mac80211_registered = 1;
+	pci_save_state(pdev);
 	pci_disable_device(pdev);

 	return 0;
@@ -9331,8 +9341,6 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);

  out_release_irq:
-	free_irq(pdev->irq, priv);
-	pci_disable_msi(pdev);
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 	iwl4965_unset_hw_setting(priv);
@@ -9399,7 +9407,6 @@ static void iwl4965_pci_remove(struct pci_dev *pdev)
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;

-	pci_disable_msi(pdev);
 	pci_iounmap(pdev, priv->hw_base);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
