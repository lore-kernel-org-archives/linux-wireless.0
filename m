Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23627 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031485Ab2CFWne (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:34 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 14/33] iwlwifi: virtualize command queue full behaviour
Date: Tue,  6 Mar 2012 13:30:49 -0800
Message-Id: <1331069468-11074-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234423_515650_3D0CDFD5)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the command queue is full, the transport
will return -ENOSPC, but the reaction to that
depends on the op_mode. Virtualize that, the
DVM op_mode checks for CT-kill and restarts
the hardware otherwise.

We may be able to get rid of this callback by
putting the behaviour check into the wrapper
but that needs more careful evaluation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   11 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h           |    2 ++
 drivers/net/wireless/iwlwifi/iwl-op-mode.h       |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    2 --
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    7 +------
 5 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2765700..7c3165e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1403,6 +1403,16 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 	ieee80211_free_hw(priv->hw);
 }
 
+static void iwl_cmd_queue_full(struct iwl_op_mode *op_mode)
+{
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+
+	if (!iwl_check_for_ct_kill(priv)) {
+		IWL_ERR(priv, "Restarting adapter queue is full\n");
+		iwl_nic_error(op_mode);
+	}
+}
+
 const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.start = iwl_op_mode_dvm_start,
 	.stop = iwl_op_mode_dvm_stop,
@@ -1412,6 +1422,7 @@ const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.hw_rf_kill = iwl_set_hw_rfkill_state,
 	.free_skb = iwl_free_skb,
 	.nic_error = iwl_nic_error,
+	.cmd_queue_full = iwl_cmd_queue_full,
 };
 
 /*****************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 1f62d6d..ec3a90c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -90,6 +90,8 @@ void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state);
 void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, u8 ac);
 void iwl_nic_error(struct iwl_op_mode *op_mode);
 
+bool iwl_check_for_ct_kill(struct iwl_priv *priv);
+
 /* MAC80211 */
 struct ieee80211_hw *iwl_alloc_all(void);
 int iwlagn_mac_setup_register(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index 55b8b27..a4a4907 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -122,6 +122,7 @@ struct iwl_fw;
  *	there are Tx packets pending in the transport layer.
  *	Must be atomic
  * @nic_error: error notification. Must be atomic
+ * @cmd_queue_full: Called when the command queue gets full. Must be atomic.
  */
 struct iwl_op_mode_ops {
 	struct iwl_op_mode *(*start)(struct iwl_trans *trans,
@@ -134,6 +135,7 @@ struct iwl_op_mode_ops {
 	void (*hw_rf_kill)(struct iwl_op_mode *op_mode, bool state);
 	void (*free_skb)(struct iwl_op_mode *op_mode, struct sk_buff *skb);
 	void (*nic_error)(struct iwl_op_mode *op_mode);
+	void (*cmd_queue_full)(struct iwl_op_mode *op_mode);
 };
 
 /**
@@ -192,6 +194,11 @@ static inline void iwl_op_mode_nic_error(struct iwl_op_mode *op_mode)
 	op_mode->ops->nic_error(op_mode);
 }
 
+static inline void iwl_op_mode_cmd_queue_full(struct iwl_op_mode *op_mode)
+{
+	op_mode->ops->cmd_queue_full(op_mode);
+}
+
 /*****************************************************
 * Op mode layers implementations
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 5e12b50..8ee5284 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -461,8 +461,6 @@ enum iwl_rxon_context_id {
 int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 void iwl_nic_config(struct iwl_priv *priv);
 const char *get_cmd_string(u8 cmd);
-bool iwl_check_for_ct_kill(struct iwl_priv *priv);
-
 
 /* notification wait support */
 void iwl_abort_notification_waits(struct iwl_shared *shrd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 844606b..7feeb2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -671,7 +671,6 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	dma_addr_t phys_addr;
 	u32 idx;
 	u16 copy_size, cmd_size;
-	bool is_ct_kill = false;
 	bool had_nocopy = false;
 	int i;
 	u8 *cmd_dest;
@@ -727,11 +726,7 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		spin_unlock_bh(&txq->lock);
 
 		IWL_ERR(trans, "No space in command queue\n");
-		is_ct_kill = iwl_check_for_ct_kill(priv(trans));
-		if (!is_ct_kill) {
-			IWL_ERR(trans, "Restarting adapter queue is full\n");
-			iwl_op_mode_nic_error(trans->op_mode);
-		}
+		iwl_op_mode_cmd_queue_full(trans->op_mode);
 		return -ENOSPC;
 	}
 
-- 
1.7.0.4

