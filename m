Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45594 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab2B0XTE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:04 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/24] iwlwifi: drv object can release its own memory
Date: Mon, 27 Feb 2012 14:07:29 -0800
Message-Id: <1330380468-17674-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001942_941108_C428EB05)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Move that code to the iwl-drv.c

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-drv.h |   13 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-pci.c |    3 +--
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 49f7e70..b3876de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -92,3 +92,10 @@ int iwl_drv_start(struct iwl_shared *shrd,
 	return ret;
 }
 
+void iwl_drv_stop(struct iwl_shared *shrd)
+{
+	iwl_remove(shrd->priv);
+
+	kfree(shrd->nic);
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.h b/drivers/net/wireless/iwlwifi/iwl-drv.h
index c405451..90534a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.h
@@ -107,4 +107,17 @@
 int iwl_drv_start(struct iwl_shared *shrd,
 		  struct iwl_trans *trans, struct iwl_cfg *cfg);
 
+/**
+ * iwl_drv_stop - stop the drv
+ *
+ * @shrd: the shrd area
+ *
+ * TODO: review the parameters given to this function
+ *
+ * Stop the driver. This should be called by bus specific system flows
+ * implementations. For example, the bus specific remove function should first
+ * call this function and then do the bus related operations only.
+ */
+void iwl_drv_stop(struct iwl_shared *shrd);
+
 #endif /* __iwl_drv_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index e269544..b9cdd1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -321,12 +321,11 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	struct iwl_bus *bus = pci_get_drvdata(pdev);
 	struct iwl_shared *shrd = bus->shrd;
 
-	iwl_remove(shrd->priv);
+	iwl_drv_stop(shrd);
 	iwl_trans_free(shrd->trans);
 
 	pci_set_drvdata(pdev, NULL);
 
-	kfree(bus->shrd->nic);
 	kfree(bus->shrd);
 	kfree(bus);
 }
-- 
1.7.0.4

