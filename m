Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759947AbZKFWw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:52:59 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/20] iwlwifi: print rx_on config to help debug
Date: Fri,  6 Nov 2009 14:52:46 -0800
Message-Id: <1257547983-12590-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

To help debug rx related issues, if IWL_DEBUG_RADIO flag is set, print
the rxon configuration when rxon host command send to uCode.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 ++
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-core.h |    5 +++++
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2bbd04d..46503a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -134,6 +134,7 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 		}
 
 		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
+		iwl_print_rx_config_cmd(priv);
 		return 0;
 	}
 
@@ -229,6 +230,7 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 		}
 		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
 	}
+	iwl_print_rx_config_cmd(priv);
 
 	iwl_init_sensitivity(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 112181b..34ffcdd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1329,7 +1329,7 @@ void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 EXPORT_SYMBOL(iwl_rx_csa);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-static void iwl_print_rx_config_cmd(struct iwl_priv *priv)
+void iwl_print_rx_config_cmd(struct iwl_priv *priv)
 {
 	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
 
@@ -1347,6 +1347,7 @@ static void iwl_print_rx_config_cmd(struct iwl_priv *priv)
 	IWL_DEBUG_RADIO(priv, "u8[6] bssid_addr: %pM\n", rxon->bssid_addr);
 	IWL_DEBUG_RADIO(priv, "u16 assoc_id: 0x%x\n", le16_to_cpu(rxon->assoc_id));
 }
+EXPORT_SYMBOL(iwl_print_rx_config_cmd);
 #endif
 /**
  * iwl_irq_handle_error - called for HW or SW error interrupt from card
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 9574d8f..3f97036 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -579,6 +579,7 @@ int iwl_pci_resume(struct pci_dev *pdev);
 #ifdef CONFIG_IWLWIFI_DEBUG
 void iwl_dump_nic_event_log(struct iwl_priv *priv);
 void iwl_dump_nic_error_log(struct iwl_priv *priv);
+void iwl_print_rx_config_cmd(struct iwl_priv *priv);
 #else
 static inline void iwl_dump_nic_event_log(struct iwl_priv *priv)
 {
@@ -587,6 +588,10 @@ static inline void iwl_dump_nic_event_log(struct iwl_priv *priv)
 static inline void iwl_dump_nic_error_log(struct iwl_priv *priv)
 {
 }
+
+static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv)
+{
+}
 #endif
 
 void iwl_clear_isr_stats(struct iwl_priv *priv);
-- 
1.5.6.3

