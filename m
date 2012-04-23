Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32825 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755745Ab2DWVwz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/29] iwlwifi: move debugfs registration function declarations
Date: Mon, 23 Apr 2012 14:47:20 -0700
Message-Id: <1335217660-21950-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235350_426270_85E1FE1B)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

They clearly belong into iwl-agn.h as they have no
relation to the (generic) debug logging framework.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.h   |   13 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-debug.h |   15 ---------------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index bd467c0..1db6bde 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -474,6 +474,19 @@ static inline void iwl_dvm_set_pmi(struct iwl_priv *priv, bool state)
 	iwl_trans_set_pmi(priv->trans, state);
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+int iwl_dbgfs_register(struct iwl_priv *priv, const char *name);
+void iwl_dbgfs_unregister(struct iwl_priv *priv);
+#else
+static inline int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
+{
+	return 0;
+}
+static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
+{
+}
+#endif /* CONFIG_IWLWIFI_DEBUGFS */
+
 #ifdef CONFIG_IWLWIFI_DEBUG
 #define IWL_DEBUG_QUIET_RFKILL(m, fmt, args...)	\
 do {									\
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 8bae7cc..d3e1783 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -32,8 +32,6 @@
 #include "iwl-shared.h"
 #include "iwl-devtrace.h"
 
-struct iwl_priv;
-
 void __iwl_err(struct device *dev, bool rfkill_prefix, bool only_trace,
 		const char *fmt, ...);
 void __iwl_warn(struct device *dev, const char *fmt, ...);
@@ -80,19 +78,6 @@ do {                                            			\
 #define iwl_print_hex_dump(m, level, p, len)
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-int iwl_dbgfs_register(struct iwl_priv *priv, const char *name);
-void iwl_dbgfs_unregister(struct iwl_priv *priv);
-#else
-static inline int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
-{
-	return 0;
-}
-static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
-{
-}
-#endif				/* CONFIG_IWLWIFI_DEBUGFS */
-
 /*
  * To use the debug system:
  *
-- 
1.7.0.4

