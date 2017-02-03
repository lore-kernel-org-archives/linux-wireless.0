Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38066 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752286AbdBCOl0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:41:26 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:38:08 +0200
Message-Id: <20170203143812.7525-22-luca@coelho.fi> (sfid-20170203_154148_551051_65743E29)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 21/25] iwlwifi: remove unnecessary argument to iwl_drv_start()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

When iwl_drv_start() is called, trans->cfg must already be set, so
there's no need to pass cfg separately, since it can be accessed
directly from trans->cfg.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  | 5 ++---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h  | 4 +---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 +-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index d22821501676..899223e8414c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1504,8 +1504,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	kfree(pieces);
 }
 
-struct iwl_drv *iwl_drv_start(struct iwl_trans *trans,
-			      const struct iwl_cfg *cfg)
+struct iwl_drv *iwl_drv_start(struct iwl_trans *trans)
 {
 	struct iwl_drv *drv;
 	int ret;
@@ -1518,7 +1517,7 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans,
 
 	drv->trans = trans;
 	drv->dev = trans->dev;
-	drv->cfg = cfg;
+	drv->cfg = trans->cfg;
 
 	init_completion(&drv->request_firmware_complete);
 	INIT_LIST_HEAD(&drv->list);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.h b/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
index f6eacfdbc265..6c537e04864e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
@@ -118,15 +118,13 @@ struct iwl_cfg;
  * iwl_drv_start - start the drv
  *
  * @trans_ops: the ops of the transport
- * @cfg: device specific constants / virtual functions
  *
  * starts the driver: fetches the firmware. This should be called by bus
  * specific system flows implementations. For example, the bus specific probe
  * function should do bus related operations only, and then call to this
  * function. It returns the driver object or %NULL if an error occurred.
  */
-struct iwl_drv *iwl_drv_start(struct iwl_trans *trans,
-			      const struct iwl_cfg *cfg);
+struct iwl_drv *iwl_drv_start(struct iwl_trans *trans);
 
 /**
  * iwl_drv_stop - stop the drv
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 2f8134b2a504..43c2475346ac 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -677,7 +677,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif
 
 	pci_set_drvdata(pdev, iwl_trans);
-	iwl_trans->drv = iwl_drv_start(iwl_trans, cfg);
+	iwl_trans->drv = iwl_drv_start(iwl_trans);
 
 	if (IS_ERR(iwl_trans->drv)) {
 		ret = PTR_ERR(iwl_trans->drv);
-- 
2.11.0
