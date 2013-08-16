Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3HPLHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:07:18 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 07/20] iwlwifi: pcie: don't swallow error codes in iwl_trans_pcie_alloc()
Date: Fri, 16 Aug 2013 13:06:57 +0200
Message-Id: <1376651230-1060-7-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130735_603375_5516AD0D)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The iwl_trans_pcie_alloc() function doesn't pass up error codes
returned from functions it calls, swallowing them and returning NULL
in all failure cases.  The caller checks if the return value is NULL
and returns -ENOMEM.  This is not correct, because in certain cases
the failure was not due to an OOM situation.

To fix this, modify the iwl_trans_pcie_alloc() function to use
ERR_PTR() to return error codes and clean up the error handling code
a bit.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c   |  4 ++--
 drivers/net/wireless/iwlwifi/pcie/trans.c | 26 +++++++++++++++-----------
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 9ec8dfe..e179efe 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -324,8 +324,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int ret;
 
 	iwl_trans = iwl_trans_pcie_alloc(pdev, ent, cfg);
-	if (iwl_trans == NULL)
-		return -ENOMEM;
+	if (IS_ERR(iwl_trans))
+		return PTR_ERR(iwl_trans);
 
 	pci_set_drvdata(pdev, iwl_trans);
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index d88c0c7..ff9787f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1381,9 +1381,10 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 
 	trans = kzalloc(sizeof(struct iwl_trans) +
 			sizeof(struct iwl_trans_pcie), GFP_KERNEL);
-
-	if (!trans)
-		return NULL;
+	if (!trans) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -1406,10 +1407,9 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 				       PCIE_LINK_STATE_CLKPM);
 	}
 
-	if (pci_enable_device(pdev)) {
-		err = -ENODEV;
+	err = pci_enable_device(pdev);
+	if (err)
 		goto out_no_pci;
-	}
 
 	pci_set_master(pdev);
 
@@ -1478,17 +1478,20 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 				  SLAB_HWCACHE_ALIGN,
 				  NULL);
 
-	if (!trans->dev_cmd_pool)
+	if (!trans->dev_cmd_pool) {
+		err = -ENOMEM;
 		goto out_pci_disable_msi;
+	}
 
 	trans_pcie->inta_mask = CSR_INI_SET_MASK;
 
 	if (iwl_pcie_alloc_ict(trans))
 		goto out_free_cmd_pool;
 
-	if (request_threaded_irq(pdev->irq, iwl_pcie_isr_ict,
-				 iwl_pcie_irq_handler,
-				 IRQF_SHARED, DRV_NAME, trans)) {
+	err = request_threaded_irq(pdev->irq, iwl_pcie_isr_ict,
+				   iwl_pcie_irq_handler,
+				   IRQF_SHARED, DRV_NAME, trans);
+	if (err) {
 		IWL_ERR(trans, "Error allocating IRQ %d\n", pdev->irq);
 		goto out_free_ict;
 	}
@@ -1507,5 +1510,6 @@ out_pci_disable_device:
 	pci_disable_device(pdev);
 out_no_pci:
 	kfree(trans);
-	return NULL;
+out:
+	return ERR_PTR(err);
 }
-- 
1.8.4.rc2

