Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbbHRH6W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:22 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/26] iwlwifi: pass NAPI struct from transport layer
Date: Tue, 18 Aug 2015 10:57:27 +0300
Message-Id: <1439884656-18146-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_100108_972485_88F9297C)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The mac80211 patch to pass the NAPI struct only changed iwlwifi to
store the NAPI struct, but we can do better: pass it directly from
the lower transport layer to the opmode during RX, and then on to
mac80211 from there.

When we add multiple RX queues, we can then pass the appropriate
NAPI struct properly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/agn.h     |  2 +-
 drivers/net/wireless/iwlwifi/dvm/main.c    | 13 -------------
 drivers/net/wireless/iwlwifi/dvm/rx.c      |  3 ++-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h | 26 ++++----------------------
 drivers/net/wireless/iwlwifi/mvm/mvm.h     |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/ops.c     | 16 ++--------------
 drivers/net/wireless/iwlwifi/mvm/rx.c      |  8 +++++---
 drivers/net/wireless/iwlwifi/pcie/rx.c     |  2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c  |  7 +++----
 9 files changed, 20 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index 101ef31..edc3dd4 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -122,7 +122,7 @@ static inline void iwl_set_calib_hdr(struct iwl_calib_hdr *hdr, u8 cmd)
 void iwl_down(struct iwl_priv *priv);
 void iwl_cancel_deferred_work(struct iwl_priv *priv);
 void iwlagn_prepare_restart(struct iwl_priv *priv);
-void iwl_rx_dispatch(struct iwl_op_mode *op_mode,
+void iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct napi_struct *napi,
 		     struct iwl_rx_cmd_buffer *rxb);
 
 bool iwl_check_for_ct_kill(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 6448195..e7616f0 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -2029,18 +2029,6 @@ static bool iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 	return false;
 }
 
-static void iwl_napi_add(struct iwl_op_mode *op_mode,
-			 struct napi_struct *napi,
-			 struct net_device *napi_dev,
-			 int (*poll)(struct napi_struct *, int),
-			 int weight)
-{
-	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
-
-	netif_napi_add(napi_dev, napi, poll, weight);
-	priv->napi = napi;
-}
-
 static const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.start = iwl_op_mode_dvm_start,
 	.stop = iwl_op_mode_dvm_stop,
@@ -2053,7 +2041,6 @@ static const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.cmd_queue_full = iwl_cmd_queue_full,
 	.nic_config = iwl_nic_config,
 	.wimax_active = iwl_wimax_active,
-	.napi_add = iwl_napi_add,
 };
 
 /*****************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index 1517698..4785203 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -1073,7 +1073,8 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 		iwlagn_bt_rx_handler_setup(priv);
 }
 
-void iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb)
+void iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct napi_struct *napi,
+		     struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index 71b450a..b47fe9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -116,10 +116,6 @@ struct iwl_cfg;
  *	May sleep
  * @rx: Rx notification to the op_mode. rxb is the Rx buffer itself. Cmd is the
  *	HCMD this Rx responds to. Can't sleep.
- * @napi_add: NAPI initialization. The transport is fully responsible for NAPI,
- *	but the higher layers need to know about it (in particular mac80211 to
- *	to able to call the right NAPI RX functions); this function is needed
- *	to eventually call netif_napi_add() with higher layer involvement.
  * @queue_full: notifies that a HW queue is full.
  *	Must be atomic and called with BH disabled.
  * @queue_not_full: notifies that a HW queue is not full any more.
@@ -148,12 +144,8 @@ struct iwl_op_mode_ops {
 				     const struct iwl_fw *fw,
 				     struct dentry *dbgfs_dir);
 	void (*stop)(struct iwl_op_mode *op_mode);
-	void (*rx)(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb);
-	void (*napi_add)(struct iwl_op_mode *op_mode,
-			 struct napi_struct *napi,
-			 struct net_device *napi_dev,
-			 int (*poll)(struct napi_struct *, int),
-			 int weight);
+	void (*rx)(struct iwl_op_mode *op_mode, struct napi_struct *napi,
+		   struct iwl_rx_cmd_buffer *rxb);
 	void (*queue_full)(struct iwl_op_mode *op_mode, int queue);
 	void (*queue_not_full)(struct iwl_op_mode *op_mode, int queue);
 	bool (*hw_rf_kill)(struct iwl_op_mode *op_mode, bool state);
@@ -188,9 +180,10 @@ static inline void iwl_op_mode_stop(struct iwl_op_mode *op_mode)
 }
 
 static inline void iwl_op_mode_rx(struct iwl_op_mode *op_mode,
+				  struct napi_struct *napi,
 				  struct iwl_rx_cmd_buffer *rxb)
 {
-	return op_mode->ops->rx(op_mode, rxb);
+	return op_mode->ops->rx(op_mode, napi, rxb);
 }
 
 static inline void iwl_op_mode_queue_full(struct iwl_op_mode *op_mode,
@@ -258,15 +251,4 @@ static inline int iwl_op_mode_exit_d0i3(struct iwl_op_mode *op_mode)
 	return op_mode->ops->exit_d0i3(op_mode);
 }
 
-static inline void iwl_op_mode_napi_add(struct iwl_op_mode *op_mode,
-					struct napi_struct *napi,
-					struct net_device *napi_dev,
-					int (*poll)(struct napi_struct *, int),
-					int weight)
-{
-	if (!op_mode->ops->napi_add)
-		return;
-	op_mode->ops->napi_add(op_mode, napi, napi_dev, poll, weight);
-}
-
 #endif /* __iwl_op_mode_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 58544f2..b95a07e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -563,7 +563,6 @@ struct iwl_mvm {
 	const struct iwl_cfg *cfg;
 	struct iwl_phy_db *phy_db;
 	struct ieee80211_hw *hw;
-	struct napi_struct *napi;
 
 	/* for protecting access to iwl_mvm */
 	struct mutex mutex;
@@ -1085,7 +1084,8 @@ bool iwl_mvm_bcast_filter_build_cmd(struct iwl_mvm *mvm,
  * Convention: iwl_mvm_rx_<NAME OF THE CMD>
  */
 void iwl_mvm_rx_rx_phy_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
-void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
+			struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index e7f6c01..c15c994 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -717,6 +717,7 @@ static inline void iwl_mvm_rx_check_trigger(struct iwl_mvm *mvm,
 }
 
 static void iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
+				struct napi_struct *napi,
 				struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -724,7 +725,7 @@ static void iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
 	u8 i;
 
 	if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD)) {
-		iwl_mvm_rx_rx_mpdu(mvm, rxb);
+		iwl_mvm_rx_rx_mpdu(mvm, napi, rxb);
 		return;
 	}
 
@@ -1321,18 +1322,6 @@ int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode)
 	return _iwl_mvm_exit_d0i3(mvm);
 }
 
-static void iwl_mvm_napi_add(struct iwl_op_mode *op_mode,
-			     struct napi_struct *napi,
-			     struct net_device *napi_dev,
-			     int (*poll)(struct napi_struct *, int),
-			     int weight)
-{
-	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
-
-	netif_napi_add(napi_dev, napi, poll, weight);
-	mvm->napi = napi;
-}
-
 static const struct iwl_op_mode_ops iwl_mvm_ops = {
 	.start = iwl_op_mode_mvm_start,
 	.stop = iwl_op_mode_mvm_stop,
@@ -1346,5 +1335,4 @@ static const struct iwl_op_mode_ops iwl_mvm_ops = {
 	.nic_config = iwl_mvm_nic_config,
 	.enter_d0i3 = iwl_mvm_enter_d0i3,
 	.exit_d0i3 = iwl_mvm_exit_d0i3,
-	.napi_add = iwl_mvm_napi_add,
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index a0c27cc..c37c10a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -94,6 +94,7 @@ void iwl_mvm_rx_rx_phy_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
  * Adds the rxb to a new skb and give it to mac80211
  */
 static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
+					    struct napi_struct *napi,
 					    struct sk_buff *skb,
 					    struct ieee80211_hdr *hdr, u16 len,
 					    u32 ampdu_status, u8 crypt_len,
@@ -127,7 +128,7 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 				fraglen, rxb->truesize);
 	}
 
-	ieee80211_rx_napi(mvm->hw, skb, mvm->napi);
+	ieee80211_rx_napi(mvm->hw, skb, napi);
 }
 
 /*
@@ -253,7 +254,8 @@ static void iwl_mvm_rx_csum(struct ieee80211_sta *sta,
  *
  * Handles the actual data of the Rx packet from the fw
  */
-void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
+void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
+			struct iwl_rx_cmd_buffer *rxb)
 {
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_rx_status *rx_status;
@@ -442,7 +444,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	iwl_mvm_update_frame_stats(mvm, rate_n_flags,
 				   rx_status->flag & RX_FLAG_AMPDU_DETAILS);
 #endif
-	iwl_mvm_pass_packet_to_mac80211(mvm, skb, hdr, len, ampdu_status,
+	iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, hdr, len, ampdu_status,
 					crypt_len, rxb);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 5643ace..e06591f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -898,7 +898,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		index = SEQ_TO_INDEX(sequence);
 		cmd_index = get_cmd_index(&txq->q, index);
 
-		iwl_op_mode_rx(trans->op_mode, &rxcb);
+		iwl_op_mode_rx(trans->op_mode, &trans_pcie->napi, &rxcb);
 
 		if (reclaim) {
 			kzfree(txq->entries[cmd_index].free_buf);
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index ceea2d5..6ba7d30 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1460,11 +1460,10 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 	 * As this function may be called again in some corner cases don't
 	 * do anything if NAPI was already initialized.
 	 */
-	if (!trans_pcie->napi.poll && trans->op_mode->ops->napi_add) {
+	if (!trans_pcie->napi.poll) {
 		init_dummy_netdev(&trans_pcie->napi_dev);
-		iwl_op_mode_napi_add(trans->op_mode, &trans_pcie->napi,
-				     &trans_pcie->napi_dev,
-				     iwl_pcie_dummy_napi_poll, 64);
+		netif_napi_add(&trans_pcie->napi_dev, &trans_pcie->napi,
+			       iwl_pcie_dummy_napi_poll, 64);
 	}
 }
 
-- 
2.1.4

