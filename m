Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbZCCTcQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 14:32:16 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v2.6.29] iwlwifi: fix error flow in iwl*_pci_probe
Date: Tue,  3 Mar 2009 11:37:04 -0800
Message-Id: <1236109024-24221-1-git-send-email-reinette.chatre@intel.com> (sfid-20090303_203219_876338_4CFB7B03)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Both the agn and 3945 drivers has some problems with dealing with
errors in their probe functions. Ensure that a goto will undo only
things that was done before the goto was called.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   17 +++++++----------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 36bafeb..129e2d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3868,7 +3868,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	err = iwl_eeprom_check_version(priv);
 	if (err)
-		goto out_iounmap;
+		goto out_free_eeprom;
 
 	/* extract MAC Address */
 	iwl_eeprom_get_mac(priv, priv->mac_addr);
@@ -3945,6 +3945,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
  out_remove_sysfs:
+	destroy_workqueue(priv->workqueue);
+	priv->workqueue = NULL;
 	sysfs_remove_group(&pdev->dev.kobj, &iwl_attribute_group);
  out_uninit_drv:
 	iwl_uninit_drv(priv);
@@ -3953,8 +3955,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  out_iounmap:
 	pci_iounmap(pdev, priv->hw_base);
  out_pci_release_regions:
-	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
+	pci_release_regions(pdev);
  out_pci_disable_device:
 	pci_disable_device(pdev);
  out_ieee80211_free_hw:
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 93be74a..57dd34e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7911,7 +7911,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 				CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (err < 0) {
 		IWL_DEBUG_INFO("Failed to init the card\n");
-		goto out_remove_sysfs;
+		goto out_iounmap;
 	}
 
 	/***********************
@@ -7921,7 +7921,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	err = iwl3945_eeprom_init(priv);
 	if (err) {
 		IWL_ERROR("Unable to init EEPROM\n");
-		goto out_remove_sysfs;
+		goto out_iounmap;
 	}
 	/* MAC Address location in EEPROM same for 3945/4965 */
 	get_eeprom_mac(priv, priv->mac_addr);
@@ -7975,7 +7975,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	err = iwl3945_init_channel_map(priv);
 	if (err) {
 		IWL_ERROR("initializing regulatory failed: %d\n", err);
-		goto out_release_irq;
+		goto out_unset_hw_setting;
 	}
 
 	err = iwl3945_init_geos(priv);
@@ -8045,25 +8045,22 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	return 0;
 
  out_remove_sysfs:
+	destroy_workqueue(priv->workqueue);
+	priv->workqueue = NULL;
 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
  out_free_geos:
 	iwl3945_free_geos(priv);
  out_free_channel_map:
 	iwl3945_free_channel_map(priv);
-
-
- out_release_irq:
-	destroy_workqueue(priv->workqueue);
-	priv->workqueue = NULL;
+ out_unset_hw_setting:
 	iwl3945_unset_hw_setting(priv);
-
  out_iounmap:
 	pci_iounmap(pdev, priv->hw_base);
  out_pci_release_regions:
 	pci_release_regions(pdev);
  out_pci_disable_device:
-	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
+	pci_disable_device(pdev);
  out_ieee80211_free_hw:
 	ieee80211_free_hw(priv->hw);
  out:
-- 
1.5.6.3

