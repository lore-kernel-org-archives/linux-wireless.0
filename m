Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:2475 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab2D0Xf0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2012 19:35:26 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/2] iwlwifi: modify #ifdef to avoid sparse complain
Date: Fri, 27 Apr 2012 16:29:38 -0700
Message-Id: <1335569379-25113-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120428_013531_844172_BB48CFB9)
In-Reply-To: <1335569379-25113-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335569379-25113-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   35 +++++++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-agn.h |    2 +-
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 100cbe2..8ee20c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1423,37 +1423,37 @@ void iwl_set_hw_params(struct iwl_priv *priv)
 
 
 
-void iwl_debug_config(struct iwl_priv *priv)
+/* show what optional capabilities we have */
+void iwl_option_config(struct iwl_priv *priv)
 {
-	IWL_INFO(priv, "CONFIG_IWLWIFI_DEBUG "
 #ifdef CONFIG_IWLWIFI_DEBUG
-		"enabled\n");
+	IWL_INFO(priv, "CONFIG_IWLWIFI_DEBUG enabled\n");
 #else
-		"disabled\n");
+	IWL_INFO(priv, "CONFIG_IWLWIFI_DEBUG disabled\n");
 #endif
-	IWL_INFO(priv, "CONFIG_IWLWIFI_DEBUGFS "
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-		"enabled\n");
+	IWL_INFO(priv, "CONFIG_IWLWIFI_DEBUGFS enabled\n");
 #else
-		"disabled\n");
+	IWL_INFO(priv, "CONFIG_IWLWIFI_DEBUGFS disabled\n");
 #endif
-	IWL_INFO(priv, "CONFIG_IWLWIFI_DEVICE_TRACING "
+
 #ifdef CONFIG_IWLWIFI_DEVICE_TRACING
-		"enabled\n");
+	IWL_INFO(priv, "CONFIG_IWLWIFI_DEVICE_TRACING enabled\n");
 #else
-		"disabled\n");
+	IWL_INFO(priv, "CONFIG_IWLWIFI_DEVICE_TRACING disabled\n");
 #endif
-	IWL_INFO(priv, "CONFIG_IWLWIFI_DEVICE_TESTMODE "
+
 #ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
-		"enabled\n");
+	IWL_INFO(priv, "CONFIG_IWLWIFI_DEVICE_TESTMODE enabled\n");
 #else
-		"disabled\n");
+	IWL_INFO(priv, "CONFIG_IWLWIFI_DEVICE_TESTMODE disabled\n");
 #endif
-	IWL_INFO(priv, "CONFIG_IWLWIFI_P2P "
+
 #ifdef CONFIG_IWLWIFI_P2P
-		"enabled\n");
+	IWL_INFO(priv, "CONFIG_IWLWIFI_P2P enabled\n");
 #else
-		"disabled\n");
+	IWL_INFO(priv, "CONFIG_IWLWIFI_P2P disabled\n");
 #endif
 }
 
@@ -1572,8 +1572,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 
 	SET_IEEE80211_DEV(priv->hw, priv->trans->dev);
 
-	/* show what debugging capabilities we have */
-	iwl_debug_config(priv);
+	iwl_option_config(priv);
 
 	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 34900e6..79c0fe0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -523,7 +523,7 @@ static inline const char *iwl_dvm_get_cmd_string(u8 cmd)
 void iwl_setup_deferred_work(struct iwl_priv *priv);
 int iwl_send_wimax_coex(struct iwl_priv *priv);
 int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
-void iwl_debug_config(struct iwl_priv *priv);
+void iwl_option_config(struct iwl_priv *priv);
 void iwl_set_hw_params(struct iwl_priv *priv);
 void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags);
 int iwl_init_drv(struct iwl_priv *priv);
-- 
1.7.0.4

