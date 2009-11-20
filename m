Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42088 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbZKTUFJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:09 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/19] iwlwifi: dump error log when uCode error occurred
Date: Fri, 20 Nov 2009 12:05:05 -0800
Message-Id: <1258747510-21233-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

uCode error log contain information as to what the error was and where
it occurred necessary to debug any uCode issues.

Always log the information without special debug flag, this can help to
capture the important information when error happened.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Acked-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h |    6 +-----
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 75f911b..463e31a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1605,7 +1605,6 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	return ret;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
 static const char *desc_lookup_text[] = {
 	"OK",
 	"FAIL",
@@ -1698,6 +1697,8 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+
 #define EVENT_START_OFFSET  (4 * sizeof(u32))
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f423afc..b62267e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1362,9 +1362,9 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
+	priv->cfg->ops->lib->dump_nic_error_log(priv);
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) {
-		priv->cfg->ops->lib->dump_nic_error_log(priv);
 		priv->cfg->ops->lib->dump_nic_event_log(priv);
 		iwl_print_rx_config_cmd(priv);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 14a9d13..1f99a5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -578,19 +578,15 @@ int iwl_pci_resume(struct pci_dev *pdev);
 /*****************************************************
 *  Error Handling Debugging
 ******************************************************/
+void iwl_dump_nic_error_log(struct iwl_priv *priv);
 #ifdef CONFIG_IWLWIFI_DEBUG
 void iwl_dump_nic_event_log(struct iwl_priv *priv);
-void iwl_dump_nic_error_log(struct iwl_priv *priv);
 void iwl_print_rx_config_cmd(struct iwl_priv *priv);
 #else
 static inline void iwl_dump_nic_event_log(struct iwl_priv *priv)
 {
 }
 
-static inline void iwl_dump_nic_error_log(struct iwl_priv *priv)
-{
-}
-
 static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv)
 {
 }
-- 
1.5.6.3

