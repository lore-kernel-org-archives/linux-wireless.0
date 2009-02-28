Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13154 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbZB1AQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 19:16:50 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/6] iwlwifi: fix *pci_probe error flow
Date: Fri, 27 Feb 2009 16:21:22 -0800
Message-Id: <1235780484-27979-5-git-send-email-reinette.chatre@intel.com> (sfid-20090228_011656_743786_78B7316B)
In-Reply-To: <1235780484-27979-4-git-send-email-reinette.chatre@intel.com>
References: <1235780484-27979-1-git-send-email-reinette.chatre@intel.com>
 <1235780484-27979-2-git-send-email-reinette.chatre@intel.com>
 <1235780484-27979-3-git-send-email-reinette.chatre@intel.com>
 <1235780484-27979-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

for iwlagn:
- Have to free eeprom of version check fails - otherwise we end up with
  memory leak.
- Include removal of workqueue (created in _setup_deferred_work) in error
  handling.

for iwl3945:
- Fix a few places to jump to correct error handling.
- Reorganize error handling to match with code flow.
- Include iwl_free_channel_map as part of error handling.
- Include releasing eeprom as part of error handling.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 +++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   22 ++++++++++++----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b49f9f7..18f6f68 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3405,7 +3405,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	err = iwl_eeprom_check_version(priv);
 	if (err)
-		goto out_iounmap;
+		goto out_free_eeprom;
 
 	/* extract MAC Address */
 	iwl_eeprom_get_mac(priv, priv->mac_addr);
@@ -3501,6 +3501,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
  out_remove_sysfs:
+	destroy_workqueue(priv->workqueue);
+	priv->workqueue = NULL;
 	sysfs_remove_group(&pdev->dev.kobj, &iwl_attribute_group);
  out_free_irq:
 	free_irq(priv->pci_dev->irq, priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 18735aa..913d1a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5053,7 +5053,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 			"invalid queues_num, should be between %d and %d\n",
 			IWL_MIN_NUM_QUEUES, IWL39_MAX_NUM_QUEUES);
 		err = -EINVAL;
-		goto out;
+		goto out_ieee80211_free_hw;
 	}
 
 	/*
@@ -5147,7 +5147,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	err = iwl_eeprom_init(priv);
 	if (err) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
-		goto out_remove_sysfs;
+		goto out_iounmap;
 	}
 	/* MAC Address location in EEPROM same for 3945/4965 */
 	eeprom = (struct iwl3945_eeprom *)priv->eeprom;
@@ -5161,7 +5161,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* Device-specific setup */
 	if (iwl3945_hw_set_hw_params(priv)) {
 		IWL_ERR(priv, "failed to set hw settings\n");
-		goto out_iounmap;
+		goto out_eeprom_free;
 	}
 
 	/***********************
@@ -5171,7 +5171,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	err = iwl3945_init_drv(priv);
 	if (err) {
 		IWL_ERR(priv, "initializing driver failed\n");
-		goto out_free_geos;
+		goto out_unset_hw_params;
 	}
 
 	IWL_INFO(priv, "Detected Intel Wireless WiFi Link %s\n",
@@ -5242,17 +5242,19 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	return 0;
 
  out_remove_sysfs:
+	destroy_workqueue(priv->workqueue);
+	priv->workqueue = NULL;
 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
- out_free_geos:
-	iwlcore_free_geos(priv);
-
  out_release_irq:
 	free_irq(priv->pci_dev->irq, priv);
-	destroy_workqueue(priv->workqueue);
-	priv->workqueue = NULL;
-	iwl3945_unset_hw_params(priv);
  out_disable_msi:
 	pci_disable_msi(priv->pci_dev);
+	iwlcore_free_geos(priv);
+	iwl_free_channel_map(priv);
+ out_unset_hw_params:
+	iwl3945_unset_hw_params(priv);
+ out_eeprom_free:
+	iwl_eeprom_free(priv);
  out_iounmap:
 	pci_iounmap(pdev, priv->hw_base);
  out_pci_release_regions:
-- 
1.5.6.3

