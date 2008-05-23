Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43571 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759025AbYEWCLY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:24 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: rename and move Tx queue activation/deactivation
Date: Fri, 23 May 2008 10:08:56 +0800
Message-Id: <1211508569-3163-19-git-send-email-yi.zhu@intel.com> (sfid-20080523_041135_760745_87CE40E3)
In-Reply-To: <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch moves iwl4965_txq_ctx_activate and iwl4965_txq_ctx_deactivate
to iwl-dev.h and removes 4965 prefix from their names.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   14 ++------------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |   10 ++++++++++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 52c7eae..f848a5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -911,16 +911,6 @@ static const u16 default_queue_to_tx_fifo[] = {
 	IWL_TX_FIFO_HCCA_2
 };
 
-static inline void iwl4965_txq_ctx_activate(struct iwl_priv *priv, int txq_id)
-{
-	set_bit(txq_id, &priv->txq_ctx_active_msk);
-}
-
-static inline void iwl4965_txq_ctx_deactivate(struct iwl_priv *priv, int txq_id)
-{
-	clear_bit(txq_id, &priv->txq_ctx_active_msk);
-}
-
 int iwl4965_alive_notify(struct iwl_priv *priv)
 {
 	u32 a;
@@ -998,7 +988,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 	/* Map each Tx/cmd queue to its corresponding fifo */
 	for (i = 0; i < ARRAY_SIZE(default_queue_to_tx_fifo); i++) {
 		int ac = default_queue_to_tx_fifo[i];
-		iwl4965_txq_ctx_activate(priv, i);
+		iwl_txq_ctx_activate(priv, i);
 		iwl4965_tx_queue_set_status(priv, &priv->txq[i], ac, 0);
 	}
 
@@ -3115,7 +3105,7 @@ static int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
 	iwl4965_set_wr_ptrs(priv, txq_id, ssn_idx);
 
 	iwl_clear_bits_prph(priv, IWL49_SCD_INTERRUPT_MASK, (1 << txq_id));
-	iwl4965_txq_ctx_deactivate(priv, txq_id);
+	iwl_txq_ctx_deactivate(priv, txq_id);
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
 
 	iwl_release_nic_access(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 305491f..533479e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1210,6 +1210,16 @@ struct iwl_priv {
 	struct timer_list statistics_periodic;
 }; /*iwl_priv */
 
+static inline void iwl_txq_ctx_activate(struct iwl_priv *priv, int txq_id)
+{
+	set_bit(txq_id, &priv->txq_ctx_active_msk);
+}
+
+static inline void iwl_txq_ctx_deactivate(struct iwl_priv *priv, int txq_id)
+{
+	clear_bit(txq_id, &priv->txq_ctx_active_msk);
+}
+
 static inline int iwl_is_associated(struct iwl_priv *priv)
 {
 	return (priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
-- 
1.5.3.6

