Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934532Ab1IOTcF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:05 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/27] iwlagn: use enum iwl_rxon_context_id instead of u8
Date: Thu, 15 Sep 2011 11:46:32 -0700
Message-Id: <1316112414-6341-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213310_843244_E333F5B9)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

enum iwl_rxon_context_id is the right type to use when we need a
rxon_context_id.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c   |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-shared.h |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-trans.c  |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-trans.h  |   12 ++++++++----
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 208ca21..90ab27e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -817,7 +817,8 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-void iwl_print_rx_config_cmd(struct iwl_priv *priv, u8 ctxid)
+void iwl_print_rx_config_cmd(struct iwl_priv *priv,
+			     enum iwl_rxon_context_id ctxid)
 {
 	struct iwl_rxon_context *ctx = &priv->contexts[ctxid];
 	struct iwl_rxon_cmd *rxon = &ctx->staging;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 0f15d58..36872f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -399,9 +399,11 @@ void iwl_reset_traffic_log(struct iwl_priv *priv);
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-void iwl_print_rx_config_cmd(struct iwl_priv *priv, u8 ctxid);
+void iwl_print_rx_config_cmd(struct iwl_priv *priv,
+			     enum iwl_rxon_context_id ctxid);
 #else
-static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv, u8 ctxid)
+static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv,
+					   enum iwl_rxon_context_id ctxid)
 {
 }
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 228c861..209dd7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1041,7 +1041,8 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 }
 
 static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
-		struct iwl_device_cmd *dev_cmd, u8 ctx, u8 sta_id)
+		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
+		u8 sta_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -1413,7 +1414,7 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 #endif /* CONFIG_PM */
 
 static void iwl_trans_pcie_wake_any_queue(struct iwl_trans *trans,
-					  u8 ctx)
+					  enum iwl_rxon_context_id ctx)
 {
 	u8 ac, txq_id;
 	struct iwl_trans_pcie *trans_pcie =
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 71a6fb0..f067408 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -178,14 +178,16 @@ struct iwl_trans_ops {
 	void (*stop_device)(struct iwl_trans *trans);
 	void (*tx_start)(struct iwl_trans *trans);
 
-	void (*wake_any_queue)(struct iwl_trans *trans, u8 ctx);
+	void (*wake_any_queue)(struct iwl_trans *trans,
+			       enum iwl_rxon_context_id ctx);
 
 	int (*send_cmd)(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 
 	int (*send_cmd_pdu)(struct iwl_trans *trans, u8 id, u32 flags, u16 len,
 		     const void *data);
 	int (*tx)(struct iwl_trans *trans, struct sk_buff *skb,
-		struct iwl_device_cmd *dev_cmd, u8 ctx, u8 sta_id);
+		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
+		u8 sta_id);
 	void (*reclaim)(struct iwl_trans *trans, int sta_id, int tid,
 			int txq_id, int ssn, u32 status,
 			struct sk_buff_head *skbs);
@@ -255,7 +257,8 @@ static inline void iwl_trans_tx_start(struct iwl_trans *trans)
 	trans->ops->tx_start(trans);
 }
 
-static inline void iwl_trans_wake_any_queue(struct iwl_trans *trans, u8 ctx)
+static inline void iwl_trans_wake_any_queue(struct iwl_trans *trans,
+					    enum iwl_rxon_context_id ctx)
 {
 	trans->ops->wake_any_queue(trans, ctx);
 }
@@ -274,7 +277,8 @@ static inline int iwl_trans_send_cmd_pdu(struct iwl_trans *trans, u8 id,
 }
 
 static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
-		struct iwl_device_cmd *dev_cmd, u8 ctx, u8 sta_id)
+		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
+		u8 sta_id)
 {
 	return trans->ops->tx(trans, skb, dev_cmd, ctx, sta_id);
 }
-- 
1.7.0.4

