Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab0FFG4n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/23] iwlwifi: remove unused parameter in iwl_priv
Date: Sat,  5 Jun 2010 23:56:23 -0700
Message-Id: <1275807398-18184-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

restrict_refcnt is no longer used, remove it from iwl_priv
structure

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3 ---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ---
 3 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7c63c06..021b014 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3686,9 +3686,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->pci_dev = pdev;
 	priv->inta_mask = CSR_INI_SET_MASK;
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-	atomic_set(&priv->restrict_refcnt, 0);
-#endif
 	if (iwl_alloc_traffic_mem(priv))
 		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f359d9f..8b7731a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1346,7 +1346,6 @@ struct iwl_priv {
 	u32 debug_level; /* per device debugging will override global
 			    iwl_debug_level if set */
 	u32 framecnt_to_us;
-	atomic_t restrict_refcnt;
 #endif /* CONFIG_IWLWIFI_DEBUG */
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	/* debugfs */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 35471cf..f2ec752 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3946,9 +3946,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->pci_dev = pdev;
 	priv->inta_mask = CSR_INI_SET_MASK;
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-	atomic_set(&priv->restrict_refcnt, 0);
-#endif
 	if (iwl_alloc_traffic_mem(priv))
 		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
 
-- 
1.7.0.4

