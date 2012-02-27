Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4551 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677Ab2B0XTI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:08 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/24] iwlwifi: remove iwl_print_rx_config_cmd from shared
Date: Mon, 27 Feb 2012 14:07:42 -0800
Message-Id: <1330380468-17674-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001935_680140_E784F569)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

It is op_mode related

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.h           |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c          |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-shared.h        |   10 ----------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    4 ----
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 3c7f0c1..cb484e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -392,4 +392,14 @@ void iwl_testmode_cleanup(struct iwl_priv *priv)
 }
 #endif
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+void iwl_print_rx_config_cmd(struct iwl_priv *priv,
+			     enum iwl_rxon_context_id ctxid);
+#else
+static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv,
+					   enum iwl_rxon_context_id ctxid)
+{
+}
+#endif
+
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 88a8c74..275e089 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -835,6 +835,11 @@ static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	unsigned int reload_msec;
 	unsigned long reload_jiffies;
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_get_debug_level(priv->shrd) & IWL_DL_FW_ERRORS)
+		iwl_print_rx_config_cmd(priv, IWL_RXON_CTX_BSS);
+#endif
+
 	/* Set the FW error flag -- cleared on iwl_down */
 	set_bit(STATUS_FW_ERROR, &priv->shrd->status);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index e7b075e..5140c78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -557,16 +557,6 @@ iwl_remove_notification(struct iwl_shared *shrd,
 void iwl_reset_traffic_log(struct iwl_priv *priv);
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-void iwl_print_rx_config_cmd(struct iwl_priv *priv,
-			     enum iwl_rxon_context_id ctxid);
-#else
-static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv,
-					   enum iwl_rxon_context_id ctxid)
-{
-}
-#endif
-
 #define IWL_CMD(x) case x: return #x
 #define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 60e70b7..2c910fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -695,10 +695,6 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 	iwl_dump_csr(trans);
 	iwl_dump_fh(trans, NULL, false);
 	iwl_dump_nic_event_log(trans, false, NULL, false);
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS)
-		iwl_print_rx_config_cmd(priv(trans), IWL_RXON_CTX_BSS);
-#endif
 
 	iwl_op_mode_nic_error(trans->op_mode);
 }
-- 
1.7.0.4

