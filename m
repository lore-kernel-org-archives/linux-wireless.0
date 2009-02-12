Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:52692 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759326AbZBLRva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 12:51:30 -0500
Received: by fxm13 with SMTP id 13so2396442fxm.13
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 09:51:28 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Subject: [PATCH] iwlagn: clean up error path in iwl_pci_probe
Date: Thu, 12 Feb 2009 18:51:03 +0100
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200902121851.04202.helmut.schaa@gmail.com> (sfid-20090212_185155_407975_13C797F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This avoids triggering a BUG_ON in pci_disable_msi in the error path.
Furthermore remove the first call to pci_disable_device as it is already
called at out_pci_disable_device.

Both issues were introduced in the patch "iwlagn: fix hw-rfkill while
the interface is down".

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

JFI iwl3945 is not affected.

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 397577c..87b237d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3605,21 +3605,21 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = request_irq(priv->pci_dev->irq, iwl_isr, IRQF_SHARED,
 			  DRV_NAME, priv);
 	if (err) {
 		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
 		goto out_disable_msi;
 	}
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl_attribute_group);
 	if (err) {
 		IWL_ERR(priv, "failed to create sysfs device attributes\n");
-		goto out_uninit_drv;
+		goto out_free_irq;
 	}
 
 	iwl_setup_deferred_work(priv);
 	iwl_setup_rx_handlers(priv);
 
 	/**********************************
 	 * 9. Setup and register mac80211
 	 **********************************/
 
 	/* enable interrupts if needed: hw bug w/a */
@@ -3650,24 +3650,24 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		IWL_ERR(priv, "Unable to initialize RFKILL system. "
 				  "Ignoring error: %d\n", err);
 	else
 		iwl_rfkill_set_hw_state(priv);
 
 	iwl_power_initialize(priv);
 	return 0;
 
  out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &iwl_attribute_group);
+ out_free_irq:
+	free_irq(priv->pci_dev->irq, priv);
  out_disable_msi:
 	pci_disable_msi(priv->pci_dev);
-	pci_disable_device(priv->pci_dev);
- out_uninit_drv:
 	iwl_uninit_drv(priv);
  out_free_eeprom:
 	iwl_eeprom_free(priv);
  out_iounmap:
 	pci_iounmap(pdev, priv->hw_base);
  out_pci_release_regions:
 	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
  out_pci_disable_device:
 	pci_disable_device(pdev);
