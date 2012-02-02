Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57810 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409Ab2BCAQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:52 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/28] iwlwifi: move the shrd memory from priv
Date: Thu,  2 Feb 2012 15:08:55 -0800
Message-Id: <1328224159-18134-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011740_996895_186229EC)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Allocating the shrd area dynamically will allow more agility
while revamping the flows.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    4 +---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-pci.c |   10 ++++++++++
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f3bd6a3..b42be30 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1780,9 +1780,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	}
 
 	priv = hw->priv;
-	priv->shrd = &priv->_shrd;
-	bus->shrd = priv->shrd;
-	priv->shrd->bus = bus;
+	priv->shrd = bus->shrd;
 	priv->shrd->priv = priv;
 
 	priv->shrd->trans = trans_ops->alloc(priv->shrd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index af84600..fff5b62 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -821,7 +821,6 @@ struct iwl_wipan_noa_data {
 struct iwl_priv {
 
 	/*data shared among all the driver's layers */
-	struct iwl_shared _shrd;
 	struct iwl_shared *shrd;
 
 	/* ieee device used by generic ieee processing code */
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 2c46063..a3ca0a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -374,10 +374,18 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!bus) {
 		dev_printk(KERN_ERR, &pdev->dev,
 			   "Couldn't allocate iwl_pci_bus");
+		return -ENOMEM;
+	}
+
+	bus->shrd = kzalloc(sizeof(*bus->shrd), GFP_KERNEL);
+	if (!bus->shrd) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "Couldn't allocate iwl_shared");
 		err = -ENOMEM;
 		goto out_no_pci;
 	}
 
+	bus->shrd->bus = bus;
 	pci_bus = IWL_BUS_GET_PCI_BUS(bus);
 	pci_bus->pci_dev = pdev;
 
@@ -472,6 +480,7 @@ out_pci_release_regions:
 out_pci_disable_device:
 	pci_disable_device(pdev);
 out_no_pci:
+	kfree(bus->shrd);
 	kfree(bus);
 	return err;
 }
@@ -491,6 +500,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pci_dev);
 	pci_set_drvdata(pci_dev, NULL);
 
+	kfree(bus->shrd);
 	kfree(bus);
 }
 
-- 
1.7.0.4

