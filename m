Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4551 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618Ab2B0XTH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:07 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/24] iwlwifi: virtualize op_mode's set_hw_rf_kill
Date: Mon, 27 Feb 2012 14:07:36 -0800
Message-Id: <1330380468-17674-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001940_368159_4F4D5BED)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Export it as "hw_rf_kill" notification.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.h           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c          |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h       |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    6 +++---
 7 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 91aa83f..28fda18 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1388,6 +1388,7 @@ const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.rx = iwl_rx_dispatch,
 	.queue_full = iwl_stop_sw_queue,
 	.queue_not_full = iwl_wake_sw_queue,
+	.hw_rf_kill = iwl_set_hw_rfkill_state,
 	.free_skb = iwl_free_skb,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index db0e2ae..39d1e79 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -86,7 +86,7 @@ int __must_check iwl_rx_dispatch(struct iwl_op_mode *op_mode,
 				 struct iwl_device_cmd *cmd);
 void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, u8 ac);
 void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, u8 ac);
-
+void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state);
 
 /* MAC80211 */
 struct ieee80211_hw *iwl_alloc_all(void);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2aa69e0..3b91b6b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1455,8 +1455,10 @@ __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 	return cpu_to_le32(res);
 }
 
-void iwl_set_hw_rfkill_state(struct iwl_priv *priv, bool state)
+void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 {
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+
 	wiphy_rfkill_set_hw_state(priv->hw->wiphy, state);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index c1664e1..8ce4aac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -84,6 +84,8 @@ struct iwl_rx_mem_buffer;
  *	Must be atomic
  * @queue_not_full: notifies that a HW queue is not full any more.
  *	Ac is the ac of the queue. Must be atomic
+ * @hw_rf_kill:notifies of a change in the HW rf kill switch. True means that
+ *	the radio is killed. Must be atomic.
  * @free_skb: allows the transport layer to free skbs that haven't been
  *	reclaimed by the op_mode. This can happen when the driver is freed and
  *	there are Tx packets pending in the transport layer.
@@ -96,6 +98,7 @@ struct iwl_op_mode_ops {
 		  struct iwl_device_cmd *cmd);
 	void (*queue_full)(struct iwl_op_mode *op_mode, u8 ac);
 	void (*queue_not_full)(struct iwl_op_mode *op_mode, u8 ac);
+	void (*hw_rf_kill)(struct iwl_op_mode *op_mode, bool state);
 	void (*free_skb)(struct iwl_op_mode *op_mode, struct sk_buff *skb);
 };
 
@@ -136,6 +139,12 @@ static inline void iwl_op_mode_queue_not_full(struct iwl_op_mode *op_mode,
 	op_mode->ops->queue_not_full(op_mode, ac);
 }
 
+static inline void iwl_op_mode_hw_rf_kill(struct iwl_op_mode *op_mode,
+					  bool state)
+{
+	op_mode->ops->hw_rf_kill(op_mode, state);
+}
+
 static inline void iwl_op_mode_free_skb(struct iwl_op_mode *op_mode,
 					struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 0a3f6fd..5cbc637 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -533,7 +533,6 @@ enum iwl_rxon_context_id {
 };
 
 int iwlagn_hw_valid_rtc_data_addr(u32 addr);
-void iwl_set_hw_rfkill_state(struct iwl_priv *priv, bool state);
 void iwl_nic_config(struct iwl_priv *priv);
 void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
 const char *get_cmd_string(u8 cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 5791311..abb5277 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -1036,7 +1036,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 			else
 				clear_bit(STATUS_RF_KILL_HW,
 					  &trans->shrd->status);
-			iwl_set_hw_rfkill_state(priv(trans), hw_rf_kill);
+			iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rf_kill);
 		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 176063c..ca0fa9c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1045,7 +1045,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans, struct fw_img *fw)
 		set_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
 
 	if (iwl_is_rfkill(trans->shrd)) {
-		iwl_set_hw_rfkill_state(priv(trans), true);
+		iwl_op_mode_hw_rf_kill(trans->op_mode, true);
 		iwl_enable_interrupts(trans);
 		return -ERFKILL;
 	}
@@ -1524,7 +1524,7 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 	else
 		set_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
 
-	iwl_set_hw_rfkill_state(priv(trans),
+	iwl_op_mode_hw_rf_kill(trans->op_mode,
 				test_bit(STATUS_RF_KILL_HW,
 					 &trans->shrd->status));
 
@@ -1669,7 +1669,7 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 	else
 		clear_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
 
-	iwl_set_hw_rfkill_state(priv(trans), hw_rfkill);
+	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 
 	return 0;
 }
-- 
1.7.0.4

