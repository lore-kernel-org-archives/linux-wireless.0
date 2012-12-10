Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42214 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2LJVs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:48:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/10] iwlwifi: return real info in probe failure
Date: Mon, 10 Dec 2012 22:49:11 +0100
Message-Id: <1355176158-24675-3-git-send-email-johannes@sipsolutions.net> (sfid-20121210_224901_250914_F09D8F37)
In-Reply-To: <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
References: <1355176087.8083.17.camel@jlt4.sipsolutions.net>
 <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Don't return a hard coded -EFAULT, but rather the error
that occurred in the flow.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c  |  6 +++---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 11 ++++++++---
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 198634b..d3549f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1032,6 +1032,7 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans,
 
 	if (!drv->dbgfs_drv) {
 		IWL_ERR(drv, "failed to create debugfs directory\n");
+		ret = -ENOMEM;
 		goto err_free_drv;
 	}
 
@@ -1040,12 +1041,12 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans,
 
 	if (!drv->trans->dbgfs_dir) {
 		IWL_ERR(drv, "failed to create transport debugfs directory\n");
+		ret = -ENOMEM;
 		goto err_free_dbgfs;
 	}
 #endif
 
 	ret = iwl_request_firmware(drv, true);
-
 	if (ret) {
 		IWL_ERR(trans, "Couldn't request the fw\n");
 		goto err_fw;
@@ -1060,9 +1061,8 @@ err_free_dbgfs:
 err_free_drv:
 #endif
 	kfree(drv);
-	drv = NULL;
 
-	return drv;
+	return ERR_PTR(ret);
 }
 
 void iwl_drv_stop(struct iwl_drv *drv)
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 956fe6c..a93a170 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -267,6 +267,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	const struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	struct iwl_trans *iwl_trans;
 	struct iwl_trans_pcie *trans_pcie;
+	int ret;
 
 	iwl_trans = iwl_trans_pcie_alloc(pdev, ent, cfg);
 	if (iwl_trans == NULL)
@@ -276,11 +277,15 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(iwl_trans);
 	trans_pcie->drv = iwl_drv_start(iwl_trans, cfg);
-	if (!trans_pcie->drv)
+
+	if (IS_ERR_OR_NULL(trans_pcie->drv)) {
+		ret = PTR_ERR(trans_pcie->drv);
 		goto out_free_trans;
+	}
 
 	/* register transport layer debugfs here */
-	if (iwl_trans_dbgfs_register(iwl_trans, iwl_trans->dbgfs_dir))
+	ret = iwl_trans_dbgfs_register(iwl_trans, iwl_trans->dbgfs_dir);
+	if (ret)
 		goto out_free_drv;
 
 	return 0;
@@ -290,7 +295,7 @@ out_free_drv:
 out_free_trans:
 	iwl_trans_pcie_free(iwl_trans);
 	pci_set_drvdata(pdev, NULL);
-	return -EFAULT;
+	return ret;
 }
 
 static void __devexit iwl_pci_remove(struct pci_dev *pdev)
-- 
1.8.0

