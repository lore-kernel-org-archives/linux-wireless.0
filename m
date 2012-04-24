Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39524 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758589Ab2DXXva (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 19:51:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/11] iwlwifi: use IWL_* instead of dev_printk when possible
Date: Tue, 24 Apr 2012 16:46:02 -0700
Message-Id: <1335311164-10252-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120425_015156_781842_3F04567F)
In-Reply-To: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Also remove a debug print when allocation error occurred.
The kernel will complain anyway.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   11 +++++------
 drivers/net/wireless/iwlwifi/iwl-drv.c |    8 ++++----
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b53852d..8f60f28 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1422,32 +1422,31 @@ void iwl_set_hw_params(struct iwl_priv *priv)
 
 void iwl_debug_config(struct iwl_priv *priv)
 {
-	dev_printk(KERN_INFO, priv->trans->dev, "CONFIG_IWLWIFI_DEBUG "
+	IWL_INFO(priv, "CONFIG_IWLWIFI_DEBUG "
 #ifdef CONFIG_IWLWIFI_DEBUG
 		"enabled\n");
 #else
 		"disabled\n");
 #endif
-	dev_printk(KERN_INFO, priv->trans->dev, "CONFIG_IWLWIFI_DEBUGFS "
+	IWL_INFO(priv, "CONFIG_IWLWIFI_DEBUGFS "
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		"enabled\n");
 #else
 		"disabled\n");
 #endif
-	dev_printk(KERN_INFO, priv->trans->dev, "CONFIG_IWLWIFI_DEVICE_TRACING "
+	IWL_INFO(priv, "CONFIG_IWLWIFI_DEVICE_TRACING "
 #ifdef CONFIG_IWLWIFI_DEVICE_TRACING
 		"enabled\n");
 #else
 		"disabled\n");
 #endif
-
-	dev_printk(KERN_INFO, priv->trans->dev, "CONFIG_IWLWIFI_DEVICE_TESTMODE "
+	IWL_INFO(priv, "CONFIG_IWLWIFI_DEVICE_TESTMODE "
 #ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
 		"enabled\n");
 #else
 		"disabled\n");
 #endif
-	dev_printk(KERN_INFO, priv->trans->dev, "CONFIG_IWLWIFI_P2P "
+	IWL_INFO(priv, "CONFIG_IWLWIFI_P2P "
 #ifdef CONFIG_IWLWIFI_P2P
 		"enabled\n");
 #else
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 05302d6..430cca5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -66,6 +66,7 @@
 #include <linux/module.h>
 
 #include "iwl-drv.h"
+#include "iwl-debug.h"
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
 #include "iwl-agn-hw.h"
@@ -892,10 +893,9 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans,
 	int ret;
 
 	drv = kzalloc(sizeof(*drv), GFP_KERNEL);
-	if (!drv) {
-		dev_printk(KERN_ERR, trans->dev, "Couldn't allocate iwl_drv");
+	if (!drv)
 		return NULL;
-	}
+
 	drv->trans = trans;
 	drv->dev = trans->dev;
 	drv->cfg = cfg;
@@ -905,7 +905,7 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans,
 	ret = iwl_request_firmware(drv, true);
 
 	if (ret) {
-		dev_printk(KERN_ERR, trans->dev, "Couldn't request the fw");
+		IWL_ERR(trans, "Couldn't request the fw\n");
 		kfree(drv);
 		drv = NULL;
 	}
-- 
1.7.0.4

