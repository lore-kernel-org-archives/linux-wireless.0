Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab3HPLIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:08:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 18/20] iwlwifi: return -ENOMEM instead of NULL when OOM in iwl_drv_start()
Date: Fri, 16 Aug 2013 13:07:08 +0200
Message-Id: <1376651230-1060-18-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130809_532400_0134D373)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The callers of iwl_drv_start() are probe functions.  If a probe
function returns 0, it means it succeeded.  So if NULL was returned by
iwl_drv_start(), it would be considered as a success.

Fix this by returning -ENOMEM if the driver struct allocation fails in
iwl_drv_start().

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c  | 8 +++++---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index e88397b..99e1da3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1032,8 +1032,10 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans,
 	int ret;
 
 	drv = kzalloc(sizeof(*drv), GFP_KERNEL);
-	if (!drv)
-		return NULL;
+	if (!drv) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
 	drv->trans = trans;
 	drv->dev = trans->dev;
@@ -1078,7 +1080,7 @@ err_free_dbgfs:
 err_free_drv:
 #endif
 	kfree(drv);
-
+err:
 	return ERR_PTR(ret);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index e179efe..567ef01 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -332,7 +332,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(iwl_trans);
 	trans_pcie->drv = iwl_drv_start(iwl_trans, cfg);
 
-	if (IS_ERR_OR_NULL(trans_pcie->drv)) {
+	if (IS_ERR(trans_pcie->drv)) {
 		ret = PTR_ERR(trans_pcie->drv);
 		goto out_free_trans;
 	}
-- 
1.8.4.rc2

