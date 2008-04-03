Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbYDCXFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 19:05:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/5] iwlwifi: fix rfkill memory error
Date: Thu,  3 Apr 2008 16:05:24 -0700
Message-Id: <1207263924-25385-6-git-send-email-reinette.chatre@intel.com> (sfid-20080404_000605_999617_815CDDB5)
In-Reply-To: <1207263924-25385-5-git-send-email-reinette.chatre@intel.com>
References: <1207263924-25385-1-git-send-email-reinette.chatre@intel.com>
 <1207263924-25385-2-git-send-email-reinette.chatre@intel.com>
 <1207263924-25385-3-git-send-email-reinette.chatre@intel.com>
 <1207263924-25385-4-git-send-email-reinette.chatre@intel.com>
 <1207263924-25385-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

Do not free reference to device twice. After rfkill registration succeeds
we only need to call rfkill_unregister() and not rfkill_free().
Also add some debugging.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c   |    7 ++++-
 drivers/net/wireless/iwlwifi/iwl-rfkill.c |   31 +++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-rfkill.h |    2 -
 3 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f122307..d8a226e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -256,9 +256,13 @@ EXPORT_SYMBOL(iwl_setup);
 int iwlcore_low_level_notify(struct iwl_priv *priv,
 			      enum iwlcore_card_notify notify)
 {
+	int ret;
 	switch (notify) {
 	case IWLCORE_INIT_EVT:
-		iwl_rfkill_init(priv);
+		ret = iwl_rfkill_init(priv);
+		if (ret)
+			IWL_ERROR("Unable to initialize RFKILL system. "
+				  "Ignoring error: %d\n", ret);
 		break;
 	case IWLCORE_START_EVT:
 		break;
@@ -266,7 +270,6 @@ int iwlcore_low_level_notify(struct iwl_priv *priv,
 		break;
 	case IWLCORE_REMOVE_EVT:
 		iwl_rfkill_unregister(priv);
-		iwl_rfkill_free(priv);
 		break;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index 308d69b..8f38c24 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -75,8 +75,10 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 
 	BUG_ON(device == NULL);
 
+	IWL_DEBUG_RF_KILL("Initializing RFKILL.\n");
 	priv->rfkill_mngr.rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
 	if (!priv->rfkill_mngr.rfkill) {
+		IWL_ERROR("Unable to allocate rfkill device.\n");
 		ret = -ENOMEM;
 		goto error;
 	}
@@ -92,6 +94,7 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 
 	priv->rfkill_mngr.input_dev = input_allocate_device();
 	if (!priv->rfkill_mngr.input_dev) {
+		IWL_ERROR("Unable to allocate rfkill input device.\n");
 		ret = -ENOMEM;
 		goto freed_rfkill;
 	}
@@ -105,27 +108,35 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 	set_bit(KEY_WLAN, priv->rfkill_mngr.input_dev->keybit);
 
 	ret = rfkill_register(priv->rfkill_mngr.rfkill);
-	if (ret)
+	if (ret) {
+		IWL_ERROR("Unable to register rfkill: %d\n", ret);
 		goto free_input_dev;
+	}
 
 	ret = input_register_device(priv->rfkill_mngr.input_dev);
-	if (ret)
+	if (ret) {
+		IWL_ERROR("Unable to register rfkill input device: %d\n", ret);
 		goto unregister_rfkill;
+	}
 
+	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
 	return ret;
 
 unregister_rfkill:
 	rfkill_unregister(priv->rfkill_mngr.rfkill);
+	priv->rfkill_mngr.rfkill = NULL;
 
 free_input_dev:
 	input_free_device(priv->rfkill_mngr.input_dev);
 	priv->rfkill_mngr.input_dev = NULL;
 
 freed_rfkill:
-	rfkill_free(priv->rfkill_mngr.rfkill);
+	if (priv->rfkill_mngr.rfkill != NULL)
+		rfkill_free(priv->rfkill_mngr.rfkill);
 	priv->rfkill_mngr.rfkill = NULL;
 
 error:
+	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
 	return ret;
 }
 EXPORT_SYMBOL(iwl_rfkill_init);
@@ -138,19 +149,11 @@ void iwl_rfkill_unregister(struct iwl_priv *priv)
 
 	if (priv->rfkill_mngr.rfkill)
 		rfkill_unregister(priv->rfkill_mngr.rfkill);
-}
-EXPORT_SYMBOL(iwl_rfkill_unregister);
 
-
-void iwl_rfkill_free(struct iwl_priv *priv)
-{
-	if (priv->rfkill_mngr.input_dev)
-		input_free_device(priv->rfkill_mngr.input_dev);
-
-	if (priv->rfkill_mngr.rfkill)
-		rfkill_free(priv->rfkill_mngr.rfkill);
+	priv->rfkill_mngr.input_dev = NULL;
+	priv->rfkill_mngr.rfkill = NULL;
 }
-EXPORT_SYMBOL(iwl_rfkill_free);
+EXPORT_SYMBOL(iwl_rfkill_unregister);
 
 /* set rf-kill to the right state. */
 void iwl_rfkill_set_hw_state(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.h b/drivers/net/wireless/iwlwifi/iwl-rfkill.h
index a5cbc5a..e7aa51a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.h
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.h
@@ -41,12 +41,10 @@ struct iwl_rfkill_mngr {
 };
 
 void iwl_rfkill_set_hw_state(struct iwl_priv *priv);
-void iwl_rfkill_free(struct iwl_priv *priv);
 void iwl_rfkill_unregister(struct iwl_priv *priv);
 int iwl_rfkill_init(struct iwl_priv *priv);
 #else
 static inline void iwl_rfkill_set_hw_state(struct iwl_priv *priv) {}
-static inline void iwl_rfkill_free(struct iwl_priv *priv) {}
 static inline void iwl_rfkill_unregister(struct iwl_priv *priv) {}
 static inline int iwl_rfkill_init(struct iwl_priv *priv) { return 0; }
 #endif
-- 
1.5.3.4

