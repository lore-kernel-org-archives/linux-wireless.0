Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45594 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448Ab2B0XTH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:07 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/24] iwlwifi: virtualize op_mode's fw_error
Date: Mon, 27 Feb 2012 14:07:37 -0800
Message-Id: <1330380468-17674-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001931_745075_0AFFE751)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Export it as "nic_error" notification, the error handling will be in
the op_mode.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.h           |    2 ++
 drivers/net/wireless/iwlwifi/iwl-core.c          |    9 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h       |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    4 ++--
 7 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 28fda18..a0346ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1390,6 +1390,7 @@ const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.queue_not_full = iwl_wake_sw_queue,
 	.hw_rf_kill = iwl_set_hw_rfkill_state,
 	.free_skb = iwl_free_skb,
+	.nic_error = iwl_nic_error,
 };
 
 /*****************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 39d1e79..3c7f0c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -87,6 +87,8 @@ int __must_check iwl_rx_dispatch(struct iwl_op_mode *op_mode,
 void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, u8 ac);
 void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, u8 ac);
 void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state);
+void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, u8 ac);
+void iwl_nic_error(struct iwl_op_mode *op_mode);
 
 /* MAC80211 */
 struct ieee80211_hw *iwl_alloc_all(void);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 3b91b6b..88a8c74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -830,7 +830,7 @@ void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 }
 #endif
 
-void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
+static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 {
 	unsigned int reload_msec;
 	unsigned long reload_jiffies;
@@ -1455,6 +1455,13 @@ __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 	return cpu_to_le32(res);
 }
 
+void iwl_nic_error(struct iwl_op_mode *op_mode)
+{
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+
+	iwlagn_fw_error(priv, false);
+}
+
 void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index 8ce4aac..e2a780d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -90,6 +90,7 @@ struct iwl_rx_mem_buffer;
  *	reclaimed by the op_mode. This can happen when the driver is freed and
  *	there are Tx packets pending in the transport layer.
  *	Must be atomic
+ * @nic_error: error notification. Must be atomic
  */
 struct iwl_op_mode_ops {
 	struct iwl_op_mode *(*start)(struct iwl_trans *trans);
@@ -100,6 +101,7 @@ struct iwl_op_mode_ops {
 	void (*queue_not_full)(struct iwl_op_mode *op_mode, u8 ac);
 	void (*hw_rf_kill)(struct iwl_op_mode *op_mode, bool state);
 	void (*free_skb)(struct iwl_op_mode *op_mode, struct sk_buff *skb);
+	void (*nic_error)(struct iwl_op_mode *op_mode);
 };
 
 /**
@@ -151,6 +153,11 @@ static inline void iwl_op_mode_free_skb(struct iwl_op_mode *op_mode,
 	op_mode->ops->free_skb(op_mode, skb);
 }
 
+static inline void iwl_op_mode_nic_error(struct iwl_op_mode *op_mode)
+{
+	op_mode->ops->nic_error(op_mode);
+}
+
 /*****************************************************
 * Op mode layers implementations
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 5cbc637..f3b6fd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -534,7 +534,6 @@ enum iwl_rxon_context_id {
 
 int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 void iwl_nic_config(struct iwl_priv *priv);
-void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
 const char *get_cmd_string(u8 cmd);
 bool iwl_check_for_ct_kill(struct iwl_priv *priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index abb5277..2072bc2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -701,7 +701,7 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 		iwl_print_rx_config_cmd(priv(trans), IWL_RXON_CTX_BSS);
 #endif
 
-	iwlagn_fw_error(priv, false);
+	iwl_op_mode_nic_error(trans->op_mode);
 }
 
 #define EVENT_START_OFFSET  (4 * sizeof(u32))
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index bca0f4f..82e3448 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -689,7 +689,7 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		is_ct_kill = iwl_check_for_ct_kill(priv(trans));
 		if (!is_ct_kill) {
 			IWL_ERR(trans, "Restarting adapter queue is full\n");
-			iwlagn_fw_error(priv(trans), false);
+			iwl_op_mode_nic_error(trans->op_mode);
 		}
 		return -ENOSPC;
 	}
@@ -822,7 +822,7 @@ static void iwl_hcmd_queue_reclaim(struct iwl_trans *trans, int txq_id,
 		if (nfreed++ > 0) {
 			IWL_ERR(trans, "HCMD skipped: index (%d) %d %d\n", idx,
 					q->write_ptr, q->read_ptr);
-			iwlagn_fw_error(priv(trans), false);
+			iwl_op_mode_nic_error(trans->op_mode);
 		}
 
 	}
-- 
1.7.0.4

