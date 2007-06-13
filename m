Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42241 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbXFMU32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 16:29:28 -0400
Date: Wed, 13 Jun 2007 13:28:23 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: MSI support
Message-ID: <20070613132823.2903bf5f@localhost>
In-Reply-To: <467039E0.7080109@garzik.org>
References: <20070613112939.3b73f928@localhost>
	<467039E0.7080109@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add Message Signal Interrupt support to iwlwifi. Tested on 3945.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

--- a/drivers/net/wireless/mac80211/iwlwifi/base.c	2007-06-13 11:10:10.000000000 -0700
+++ b/drivers/net/wireless/mac80211/iwlwifi/base.c	2007-06-13 13:10:25.000000000 -0700
@@ -8117,6 +8117,9 @@ static int iwl_pci_probe(struct pci_dev 
 	/* If power management is turned on, default to AC mode */
 	priv->power_mode = IWL_POWER_AC;
 	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
+
+	pci_enable_msi(pdev);
+
 	err = request_irq(pdev->irq, iwl_isr, IRQF_SHARED, DRV_NAME, priv);
 	if (err) {
 		IWL_ERROR("Error allocating IRQ %d\n", pdev->irq);
@@ -8155,6 +8158,7 @@ static int iwl_pci_probe(struct pci_dev 
 	sysfs_remove_group(&pdev->dev.kobj, &iwl_attribute_group);
 
  out_release_irq:
+	pci_disable_msi(pdev);
 	free_irq(pdev->irq, priv);
 
  out_destroy_workqueue:
@@ -8224,6 +8228,8 @@ static void iwl_pci_remove(struct pci_de
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 
+	pci_disable_msi(pdev);
+
 	free_irq(pdev->irq, priv);
 	iounmap(priv->hw_base);
 	pci_release_regions(pdev);
