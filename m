Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6913 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbYDXSzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 03/21] iwlwifi: move hw_rx_handler_setup to iwl-4965.c
Date: Thu, 24 Apr 2008 11:55:20 -0700
Message-Id: <1209063338-6572-4-git-send-email-reinette.chatre@intel.com> (sfid-20080424_205619_937211_E0FE9B05)
In-Reply-To: <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch moves hw_rx_handler_setup to iwl-4965.c

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 ++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index b1b7363..2587773 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4065,7 +4065,7 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 #endif /* CONFIG_IWL4965_HT */
 
 /* Set up 4965-specific Rx frame reply handlers */
-void iwl4965_hw_rx_handler_setup(struct iwl_priv *priv)
+static void iwl4965_rx_handler_setup(struct iwl_priv *priv)
 {
 	/* Legacy Rx frames */
 	priv->rx_handlers[REPLY_RX] = iwl4965_rx_reply_rx;
@@ -4119,6 +4119,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.free_shared_mem = iwl4965_free_shared_mem,
 	.txq_update_byte_cnt_tbl = iwl4965_txq_update_byte_cnt_tbl,
 	.hw_nic_init = iwl4965_hw_nic_init,
+	.rx_handler_setup = iwl4965_rx_handler_setup,
 	.is_valid_rtc_data_addr = iwl4965_hw_valid_rtc_data_addr,
 	.alive_notify = iwl4965_alive_notify,
 	.load_ucode = iwl4965_load_bsm,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 3b73064..7b7c620 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -693,7 +693,6 @@ extern u8 iwl4965_sync_station(struct iwl_priv *priv, int sta_id,
  * iwl4965_mac_     <-- mac80211 callback
  *
  ****************************************************************************/
-extern void iwl4965_hw_rx_handler_setup(struct iwl_priv *priv);
 extern void iwl4965_hw_setup_deferred_work(struct iwl_priv *priv);
 extern void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv);
 extern int iwl4965_hw_rxq_stop(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8196ef7..fc0c276 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -105,6 +105,8 @@ struct iwl_lib_ops {
 	void (*txq_update_byte_cnt_tbl)(struct iwl_priv *priv,
 					struct iwl4965_tx_queue *txq,
 					u16 byte_cnt);
+	/* setup Rx handler */
+	void (*rx_handler_setup)(struct iwl_priv *priv);
 	/* nic init */
 	int (*hw_nic_init)(struct iwl_priv *priv);
 	/* alive notification */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index d2726dc..5f99ef6 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3237,7 +3237,7 @@ static void iwl4965_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_TX] = iwl4965_rx_reply_tx;
 
 	/* Set up hardware specific Rx handlers */
-	iwl4965_hw_rx_handler_setup(priv);
+	priv->cfg->ops->lib->rx_handler_setup(priv);
 }
 
 /**
-- 
1.5.3.4

