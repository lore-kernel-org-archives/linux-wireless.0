Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45618 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbYCNRsl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2008 13:48:41 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Assaf Krauss <assaf.krauss@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4/5] iwlwifi: Probe Flow - Performing allocation in a separate function
Date: Fri, 14 Mar 2008 10:38:48 -0700
Message-Id: <1205516329-22172-5-git-send-email-reinette.chatre@intel.com> (sfid-20080314_174956_514904_F3697E7F)
In-Reply-To: <1205516329-22172-4-git-send-email-reinette.chatre@intel.com>
References: <1205516329-22172-1-git-send-email-reinette.chatre@intel.com>
 <1205516329-22172-2-git-send-email-reinette.chatre@intel.com>
 <1205516329-22172-3-git-send-email-reinette.chatre@intel.com>
 <1205516329-22172-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

Performing allocation in a separate function (previously handled in
'probe')

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |   27 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   13 +++++--------
 3 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 3a9fc90..244318a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -29,12 +29,15 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/version.h>
+#include <net/mac80211.h>
 
 struct iwl_priv; /* FIXME: remove */
 #include "iwl-debug.h"
 #include "iwl-eeprom.h"
 #include "iwl-core.h"
 
+#include "iwl-4965.h" /* FIXME: remove */
+
 MODULE_DESCRIPTION("iwl core");
 MODULE_VERSION(IWLWIFI_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
@@ -44,3 +47,27 @@ MODULE_LICENSE("GPL");
 u32 iwl_debug_level;
 EXPORT_SYMBOL(iwl_debug_level);
 #endif
+
+/* This function both allocates and initializes hw and priv. */
+struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
+		struct ieee80211_ops *hw_ops)
+{
+	struct iwl_priv *priv;
+
+	/* mac80211 allocates memory for this device instance, including
+	 *   space for this driver's private structure */
+	struct ieee80211_hw *hw =
+		ieee80211_alloc_hw(sizeof(struct iwl_priv), hw_ops);
+	if (hw == NULL) {
+		IWL_ERROR("Can not allocate network device\n");
+		goto out;
+	}
+
+	priv = hw->priv;
+	priv->hw = hw;
+
+out:
+	return hw;
+}
+EXPORT_SYMBOL(iwl_alloc_all);
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index fb4ce08..33bef1f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -103,4 +103,11 @@ struct iwl_cfg {
 	const struct iwl_mod_params *mod_params;
 };
 
+/***************************
+ *   L i b                 *
+ ***************************/
+
+struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
+		struct ieee80211_ops *hw_ops);
+
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index ebdf2d1..4d95ea5 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -8635,21 +8635,18 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		iwl4965_hw_ops.hw_scan = NULL;
 	}
 
-	/* mac80211 allocates memory for this device instance, including
-	 *   space for this driver's private structure */
-	hw = ieee80211_alloc_hw(sizeof(struct iwl_priv), &iwl4965_hw_ops);
-	if (hw == NULL) {
-		IWL_ERROR("Can not allocate network device\n");
+	hw = iwl_alloc_all(cfg, &iwl4965_hw_ops);
+	if (!hw) {
 		err = -ENOMEM;
 		goto out;
 	}
+	priv = hw->priv;
+	/* At this point both hw and priv are allocated. */
+
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
 	IWL_DEBUG_INFO("*** LOAD DRIVER ***\n");
-	priv = hw->priv;
-	priv->hw = hw;
 	priv->cfg = cfg;
-
 	priv->pci_dev = pdev;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-- 
1.5.3.4

