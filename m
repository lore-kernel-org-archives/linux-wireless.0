Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57175 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750826AbbJEPBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:37:00 +0300
Message-Id: <1444055820-27506-29-git-send-email-luca@coelho.fi> (sfid-20151005_170136_355330_D94129D0)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 29/29] iwlwifi: mvm: add minimal multi-RXQ infrastructure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the new multi-queue capability depends on a new firmware API,
we can already add some code for it. If the new API is present, a
new opmode ops struct is used that handles the new rx_rss method.

For now, only restructure the RX handling to distinguish between
the two. Future patches will convert the new infrastructure to
actually use the new RX descriptor layout.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h |   6 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c | 104 ++++++++++++++++++++++++---------
 2 files changed, 83 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index f4e22f5..0d3aff1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -970,6 +970,12 @@ static inline bool iwl_mvm_is_csum_supported(struct iwl_mvm *mvm)
 			   IWL_UCODE_TLV_CAPA_CSUM_SUPPORT);
 }
 
+static inline bool iwl_mvm_has_new_rx_api(struct iwl_mvm *mvm)
+{
+	/* firmware flag isn't defined yet */
+	return false;
+}
+
 extern const u8 iwl_mvm_ac_to_tx_fifo[];
 
 struct iwl_rate_info {
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 0e8166f..064c100 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -89,6 +89,7 @@ MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 
 static const struct iwl_op_mode_ops iwl_mvm_ops;
+static const struct iwl_op_mode_ops iwl_mvm_ops_mq;
 
 struct iwl_mvm_mod_params iwlmvm_mod_params = {
 	.power_scheme = IWL_POWER_SCHEME_BPS,
@@ -424,7 +425,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		hw->max_tx_aggregation_subframes = cfg->max_tx_agg_size;
 
 	op_mode = hw->priv;
-	op_mode->ops = &iwl_mvm_ops;
 
 	mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	mvm->dev = trans->dev;
@@ -433,6 +433,15 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	mvm->fw = fw;
 	mvm->hw = hw;
 
+	if (iwl_mvm_has_new_rx_api(mvm)) {
+		op_mode->ops = &iwl_mvm_ops_mq;
+	} else {
+		op_mode->ops = &iwl_mvm_ops;
+
+		if (WARN_ON(trans->num_rx_queues > 1))
+			goto out_free;
+	}
+
 	mvm->restart_fw = iwlwifi_mod_params.restart_fw ? -1 : 0;
 
 	mvm->aux_queue = 15;
@@ -719,21 +728,11 @@ static inline void iwl_mvm_rx_check_trigger(struct iwl_mvm *mvm,
 	}
 }
 
-static void iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
-				struct napi_struct *napi,
-				struct iwl_rx_cmd_buffer *rxb)
+static void iwl_mvm_rx_common(struct iwl_mvm *mvm,
+			      struct iwl_rx_cmd_buffer *rxb,
+			      struct iwl_rx_packet *pkt)
 {
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
-	u8 i;
-
-	if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD)) {
-		iwl_mvm_rx_rx_mpdu(mvm, napi, rxb);
-		return;
-	} else if (pkt->hdr.cmd == REPLY_RX_PHY_CMD) {
-		iwl_mvm_rx_rx_phy_cmd(mvm, rxb);
-		return;
-	}
+	int i;
 
 	iwl_mvm_rx_check_trigger(mvm, pkt);
 
@@ -773,6 +772,36 @@ static void iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
 	}
 }
 
+static void iwl_mvm_rx(struct iwl_op_mode *op_mode,
+		       struct napi_struct *napi,
+		       struct iwl_rx_cmd_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+
+	if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD))
+		iwl_mvm_rx_rx_mpdu(mvm, napi, rxb);
+	else if (pkt->hdr.cmd == REPLY_RX_PHY_CMD)
+		iwl_mvm_rx_rx_phy_cmd(mvm, rxb);
+	else
+		iwl_mvm_rx_common(mvm, rxb, pkt);
+}
+
+static void iwl_mvm_rx_mq(struct iwl_op_mode *op_mode,
+			  struct napi_struct *napi,
+			  struct iwl_rx_cmd_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+
+	if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD))
+		iwl_mvm_rx_rx_mpdu(mvm, napi, rxb);
+	else if (pkt->hdr.cmd == REPLY_RX_PHY_CMD)
+		iwl_mvm_rx_rx_phy_cmd(mvm, rxb);
+	else
+		iwl_mvm_rx_common(mvm, rxb, pkt);
+}
+
 static void iwl_mvm_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
@@ -1366,17 +1395,38 @@ int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode)
 	return _iwl_mvm_exit_d0i3(mvm);
 }
 
+#define IWL_MVM_COMMON_OPS					\
+	/* these could be differentiated */			\
+	.queue_full = iwl_mvm_stop_sw_queue,			\
+	.queue_not_full = iwl_mvm_wake_sw_queue,		\
+	.hw_rf_kill = iwl_mvm_set_hw_rfkill_state,		\
+	.free_skb = iwl_mvm_free_skb,				\
+	.nic_error = iwl_mvm_nic_error,				\
+	.cmd_queue_full = iwl_mvm_cmd_queue_full,		\
+	.nic_config = iwl_mvm_nic_config,			\
+	.enter_d0i3 = iwl_mvm_enter_d0i3,			\
+	.exit_d0i3 = iwl_mvm_exit_d0i3,				\
+	/* as we only register one, these MUST be common! */	\
+	.start = iwl_op_mode_mvm_start,				\
+	.stop = iwl_op_mode_mvm_stop
+
 static const struct iwl_op_mode_ops iwl_mvm_ops = {
-	.start = iwl_op_mode_mvm_start,
-	.stop = iwl_op_mode_mvm_stop,
-	.rx = iwl_mvm_rx_dispatch,
-	.queue_full = iwl_mvm_stop_sw_queue,
-	.queue_not_full = iwl_mvm_wake_sw_queue,
-	.hw_rf_kill = iwl_mvm_set_hw_rfkill_state,
-	.free_skb = iwl_mvm_free_skb,
-	.nic_error = iwl_mvm_nic_error,
-	.cmd_queue_full = iwl_mvm_cmd_queue_full,
-	.nic_config = iwl_mvm_nic_config,
-	.enter_d0i3 = iwl_mvm_enter_d0i3,
-	.exit_d0i3 = iwl_mvm_exit_d0i3,
+	IWL_MVM_COMMON_OPS,
+	.rx = iwl_mvm_rx,
+};
+
+static void iwl_mvm_rx_mq_rss(struct iwl_op_mode *op_mode,
+			      struct napi_struct *napi,
+			      struct iwl_rx_cmd_buffer *rxb,
+			      unsigned int queue)
+{
+	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+
+	iwl_mvm_rx_rx_mpdu(mvm, napi, rxb);
+}
+
+static const struct iwl_op_mode_ops iwl_mvm_ops_mq = {
+	IWL_MVM_COMMON_OPS,
+	.rx = iwl_mvm_rx_mq,
+	.rx_rss = iwl_mvm_rx_mq_rss,
 };
-- 
2.5.3

