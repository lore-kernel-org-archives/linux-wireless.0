Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58512 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753173AbXFNStF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 14:49:05 -0400
Date: Thu, 14 Jun 2007 11:48:09 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: James Ketrenos <jketreno@linux.intel.com>,
	Jeff Garzik <jeff@garzik.org>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi MSI support (rev3)
Message-ID: <20070614114809.39106c17@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous patch would crash on remove. pci_disable_msi has to be
called after free_irq.  FYI - pci_disable_msi is safe if MSI hasn't been
enabled.

--- a/drivers/net/wireless/mac80211/iwlwifi/base.c	2007-06-13 11:10:10.000000000 -0700
+++ b/drivers/net/wireless/mac80211/iwlwifi/base.c	2007-06-14 11:47:01.000000000 -0700
@@ -8117,10 +8117,13 @@ static int iwl_pci_probe(struct pci_dev 
 	/* If power management is turned on, default to AC mode */
 	priv->power_mode = IWL_POWER_AC;
 	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
+
+	pci_enable_msi(pdev);
+
 	err = request_irq(pdev->irq, iwl_isr, IRQF_SHARED, DRV_NAME, priv);
 	if (err) {
 		IWL_ERROR("Error allocating IRQ %d\n", pdev->irq);
-		goto out_destroy_workqueue;
+		goto out_disable_msi;
 	}
 
 	mutex_lock(&priv->mutex);
@@ -8157,7 +8160,8 @@ static int iwl_pci_probe(struct pci_dev 
  out_release_irq:
 	free_irq(pdev->irq, priv);
 
- out_destroy_workqueue:
+ out_disable_msi:
+	pci_disable_msi(pdev);
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 	iwl_unset_hw_setting(priv);
@@ -8225,6 +8229,7 @@ static void iwl_pci_remove(struct pci_de
 	priv->workqueue = NULL;
 
 	free_irq(pdev->irq, priv);
+	pci_disable_msi(pdev);
 	iounmap(priv->hw_base);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
