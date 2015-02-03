Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1144 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965333AbbBCHPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:15:06 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/19] iwlwifi: allow to define the stuck queue timer per queue
Date: Tue,  3 Feb 2015 09:14:32 +0200
Message-Id: <1422947678-16917-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081532_417786_315D8E8F)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Different queue can have different behavior. While it can be
unacceptable for a certain queue to be stuck for 2 seconds
(e.g. the command queue), it can happen that another queue
will stay stuck for even longer (a queue servicing a power
saving client in GO).
The op_mode can even make the timeout be a function of the
listen interval.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c      |  3 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c        |  2 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c     |  2 +-
 drivers/net/wireless/iwlwifi/iwl-config.h    |  2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h     | 29 +++++++++++---------
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c  | 10 +++++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h       | 15 ++++++----
 drivers/net/wireless/iwlwifi/mvm/ops.c       |  8 ++++--
 drivers/net/wireless/iwlwifi/mvm/sta.c       | 15 ++++++++--
 drivers/net/wireless/iwlwifi/mvm/utils.c     |  8 ++++--
 drivers/net/wireless/iwlwifi/pcie/internal.h | 10 +++----
 drivers/net/wireless/iwlwifi/pcie/trans.c    |  4 +--
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 41 +++++++++++++++-------------
 13 files changed, 87 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index a21400c..c4d6dd7 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1228,7 +1228,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	trans_cfg.no_reclaim_cmds = no_reclaim_cmds;
 	trans_cfg.n_no_reclaim_cmds = ARRAY_SIZE(no_reclaim_cmds);
 	trans_cfg.rx_buf_size_8k = iwlwifi_mod_params.amsdu_size_8K;
-	trans_cfg.queue_watchdog_timeout = IWL_WATCHDOG_DISABLED;
+	trans_cfg.cmd_q_wdg_timeout = IWL_WATCHDOG_DISABLED;
+
 	trans_cfg.command_names = iwl_dvm_cmd_strings;
 	trans_cfg.cmd_fifo = IWLAGN_CMD_FIFO_NUM;
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index d1ce3ce..1e40a12 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -715,7 +715,7 @@ int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	fifo = ctx->ac_to_fifo[tid_to_ac[tid]];
 
 	iwl_trans_txq_enable(priv->trans, q, fifo, sta_priv->sta_id, tid,
-			     buf_size, ssn);
+			     buf_size, ssn, 0);
 
 	/*
 	 * If the limit is 0, then it wasn't initialised yet,
diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index d5cee15..4dbef7e 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -267,7 +267,7 @@ static int iwl_alive_notify(struct iwl_priv *priv)
 	for (i = 0; i < n_queues; i++)
 		if (queue_to_txf[i] != IWL_TX_FIFO_UNUSED)
 			iwl_trans_ac_txq_enable(priv->trans, i,
-						queue_to_txf[i]);
+						queue_to_txf[i], 0);
 
 	priv->passive_no_rx = false;
 	priv->transport_queue_stop = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 445bff6..4b190d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -126,7 +126,7 @@ enum iwl_led_mode {
 
 /* TX queue watchdog timeouts in mSecs */
 #define IWL_WATCHDOG_DISABLED	0
-#define IWL_DEF_WD_TIMEOUT	2000
+#define IWL_DEF_WD_TIMEOUT	2500
 #define IWL_LONG_WD_TIMEOUT	10000
 #define IWL_MAX_WD_TIMEOUT	120000
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 84d8477..a96bd8d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -368,6 +368,7 @@ enum iwl_trans_status {
  * @cmd_queue: the index of the command queue.
  *	Must be set before start_fw.
  * @cmd_fifo: the fifo for host commands
+ * @cmd_q_wdg_timeout: the timeout of the watchdog timer for the command queue.
  * @no_reclaim_cmds: Some devices erroneously don't set the
  *	SEQ_RX_FRAME bit on some notifications, this is the
  *	list of such notifications to filter. Max length is
@@ -378,8 +379,6 @@ enum iwl_trans_status {
  * @bc_table_dword: set to true if the BC table expects the byte count to be
  *	in DWORD (as opposed to bytes)
  * @scd_set_active: should the transport configure the SCD for HCMD queue
- * @queue_watchdog_timeout: time (in ms) after which queues
- *	are considered stuck and will trigger device restart
  * @command_names: array of command names, must be 256 entries
  *	(one for each command); for debugging only
  * @sdio_adma_addr: the default address to set for the ADMA in SDIO mode until
@@ -390,13 +389,13 @@ struct iwl_trans_config {
 
 	u8 cmd_queue;
 	u8 cmd_fifo;
+	unsigned int cmd_q_wdg_timeout;
 	const u8 *no_reclaim_cmds;
 	unsigned int n_no_reclaim_cmds;
 
 	bool rx_buf_size_8k;
 	bool bc_table_dword;
 	bool scd_set_active;
-	unsigned int queue_watchdog_timeout;
 	const char *const *command_names;
 
 	u32 sdio_adma_addr;
@@ -511,7 +510,8 @@ struct iwl_trans_ops {
 			struct sk_buff_head *skbs);
 
 	void (*txq_enable)(struct iwl_trans *trans, int queue, u16 ssn,
-			   const struct iwl_trans_txq_scd_cfg *cfg);
+			   const struct iwl_trans_txq_scd_cfg *cfg,
+			   unsigned int queue_wdg_timeout);
 	void (*txq_disable)(struct iwl_trans *trans, int queue,
 			    bool configure_scd);
 
@@ -829,19 +829,21 @@ static inline void iwl_trans_txq_disable(struct iwl_trans *trans, int queue,
 
 static inline void
 iwl_trans_txq_enable_cfg(struct iwl_trans *trans, int queue, u16 ssn,
-			 const struct iwl_trans_txq_scd_cfg *cfg)
+			 const struct iwl_trans_txq_scd_cfg *cfg,
+			 unsigned int queue_wdg_timeout)
 {
 	might_sleep();
 
 	if (unlikely((trans->state != IWL_TRANS_FW_ALIVE)))
 		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
 
-	trans->ops->txq_enable(trans, queue, ssn, cfg);
+	trans->ops->txq_enable(trans, queue, ssn, cfg, queue_wdg_timeout);
 }
 
 static inline void iwl_trans_txq_enable(struct iwl_trans *trans, int queue,
 					int fifo, int sta_id, int tid,
-					int frame_limit, u16 ssn)
+					int frame_limit, u16 ssn,
+					unsigned int queue_wdg_timeout)
 {
 	struct iwl_trans_txq_scd_cfg cfg = {
 		.fifo = fifo,
@@ -851,11 +853,12 @@ static inline void iwl_trans_txq_enable(struct iwl_trans *trans, int queue,
 		.aggregate = sta_id >= 0,
 	};
 
-	iwl_trans_txq_enable_cfg(trans, queue, ssn, &cfg);
+	iwl_trans_txq_enable_cfg(trans, queue, ssn, &cfg, queue_wdg_timeout);
 }
 
-static inline void iwl_trans_ac_txq_enable(struct iwl_trans *trans, int queue,
-					   int fifo)
+static inline
+void iwl_trans_ac_txq_enable(struct iwl_trans *trans, int queue, int fifo,
+			     unsigned int queue_wdg_timeout)
 {
 	struct iwl_trans_txq_scd_cfg cfg = {
 		.fifo = fifo,
@@ -865,16 +868,16 @@ static inline void iwl_trans_ac_txq_enable(struct iwl_trans *trans, int queue,
 		.aggregate = false,
 	};
 
-	iwl_trans_txq_enable_cfg(trans, queue, 0, &cfg);
+	iwl_trans_txq_enable_cfg(trans, queue, 0, &cfg, queue_wdg_timeout);
 }
 
 static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans,
-						u32 txq_bm)
+						u32 txqs)
 {
 	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
 		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
 
-	return trans->ops->wait_tx_queue_empty(trans, txq_bm);
+	return trans->ops->wait_tx_queue_empty(trans, txqs);
 }
 
 static inline int iwl_trans_dbgfs_register(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 8bf78fa..7bdc622 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -462,6 +462,9 @@ exit_fail:
 
 int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
+	unsigned int wdg_timeout = iwlmvm_mod_params.tfd_q_hang_detect ?
+					mvm->cfg->base_params->wd_timeout :
+					IWL_WATCHDOG_DISABLED;
 	u32 ac;
 	int ret;
 
@@ -474,16 +477,17 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	switch (vif->type) {
 	case NL80211_IFTYPE_P2P_DEVICE:
 		iwl_mvm_enable_ac_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE,
-				      IWL_MVM_TX_FIFO_VO);
+				      IWL_MVM_TX_FIFO_VO, wdg_timeout);
 		break;
 	case NL80211_IFTYPE_AP:
 		iwl_mvm_enable_ac_txq(mvm, vif->cab_queue,
-				      IWL_MVM_TX_FIFO_MCAST);
+				      IWL_MVM_TX_FIFO_MCAST, wdg_timeout);
 		/* fall through */
 	default:
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 			iwl_mvm_enable_ac_txq(mvm, vif->hw_queue[ac],
-					      iwl_mvm_ac_to_tx_fifo[ac]);
+					      iwl_mvm_ac_to_tx_fifo[ac],
+					      wdg_timeout);
 		break;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 4a7620c..6c69d05 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1318,11 +1318,13 @@ static inline bool iwl_mvm_vif_low_latency(struct iwl_mvm_vif *mvmvif)
 
 /* hw scheduler queue config */
 void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, u16 ssn,
-			const struct iwl_trans_txq_scd_cfg *cfg);
+			const struct iwl_trans_txq_scd_cfg *cfg,
+			unsigned int wdg_timeout);
 void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, u8 flags);
 
-static inline void iwl_mvm_enable_ac_txq(struct iwl_mvm *mvm, int queue,
-					 u8 fifo)
+static inline
+void iwl_mvm_enable_ac_txq(struct iwl_mvm *mvm, int queue,
+			   u8 fifo, unsigned int wdg_timeout)
 {
 	struct iwl_trans_txq_scd_cfg cfg = {
 		.fifo = fifo,
@@ -1331,12 +1333,13 @@ static inline void iwl_mvm_enable_ac_txq(struct iwl_mvm *mvm, int queue,
 		.frame_limit = IWL_FRAME_LIMIT,
 	};
 
-	iwl_mvm_enable_txq(mvm, queue, 0, &cfg);
+	iwl_mvm_enable_txq(mvm, queue, 0, &cfg, wdg_timeout);
 }
 
 static inline void iwl_mvm_enable_agg_txq(struct iwl_mvm *mvm, int queue,
 					  int fifo, int sta_id, int tid,
-					  int frame_limit, u16 ssn)
+					  int frame_limit, u16 ssn,
+					  unsigned int wdg_timeout)
 {
 	struct iwl_trans_txq_scd_cfg cfg = {
 		.fifo = fifo,
@@ -1346,7 +1349,7 @@ static inline void iwl_mvm_enable_agg_txq(struct iwl_mvm *mvm, int queue,
 		.aggregate = true,
 	};
 
-	iwl_mvm_enable_txq(mvm, queue, ssn, &cfg);
+	iwl_mvm_enable_txq(mvm, queue, ssn, &cfg, wdg_timeout);
 }
 
 /* Assoc status */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index f801824..b6181ef 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -478,9 +478,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_DW_BC_TABLE)
 		trans_cfg.bc_table_dword = true;
 
-	if (iwlmvm_mod_params.tfd_q_hang_detect)
-		trans_cfg.queue_watchdog_timeout = cfg->base_params->wd_timeout;
-
 	trans_cfg.command_names = iwl_mvm_cmd_strings;
 
 	trans_cfg.cmd_queue = IWL_MVM_CMD_QUEUE;
@@ -489,6 +486,11 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	trans_cfg.sdio_adma_addr = fw->sdio_adma_addr;
 
+	/* Set a short watchdog for the command queue */
+	trans_cfg.cmd_q_wdg_timeout =
+		iwlmvm_mod_params.tfd_q_hang_detect ? IWL_DEF_WD_TIMEOUT :
+						      IWL_WATCHDOG_DISABLED;
+
 	snprintf(mvm->hw->wiphy->fw_version,
 		 sizeof(mvm->hw->wiphy->fw_version),
 		 "%s", fw->fw_version);
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 14a8484..5c23cdd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -209,6 +209,9 @@ static int iwl_mvm_tdls_sta_init(struct iwl_mvm *mvm,
 {
 	unsigned long used_hw_queues;
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	unsigned int wdg_timeout = iwlmvm_mod_params.tfd_q_hang_detect ?
+					mvm->cfg->base_params->wd_timeout :
+					IWL_WATCHDOG_DISABLED;
 	u32 ac;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -232,7 +235,7 @@ static int iwl_mvm_tdls_sta_init(struct iwl_mvm *mvm,
 	/* Found a place for all queues - enable them */
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		iwl_mvm_enable_ac_txq(mvm, mvmsta->hw_queue[ac],
-				      iwl_mvm_ac_to_tx_fifo[ac]);
+				      iwl_mvm_ac_to_tx_fifo[ac], wdg_timeout);
 		mvmsta->tfd_queue_msk |= BIT(mvmsta->hw_queue[ac]);
 	}
 
@@ -626,13 +629,16 @@ static int iwl_mvm_add_int_sta_common(struct iwl_mvm *mvm,
 
 int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm)
 {
+	unsigned int wdg_timeout = iwlmvm_mod_params.tfd_q_hang_detect ?
+					mvm->cfg->base_params->wd_timeout :
+					IWL_WATCHDOG_DISABLED;
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
 	/* Map Aux queue to fifo - needs to happen before adding Aux station */
 	iwl_mvm_enable_ac_txq(mvm, mvm->aux_queue,
-			      IWL_MVM_TX_FIFO_MCAST);
+			      IWL_MVM_TX_FIFO_MCAST, wdg_timeout);
 
 	/* Allocate aux station and assign to it the aux queue */
 	ret = iwl_mvm_allocate_int_sta(mvm, &mvm->aux_sta, BIT(mvm->aux_queue),
@@ -965,6 +971,9 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
+	unsigned int wdg_timeout = iwlmvm_mod_params.tfd_q_hang_detect ?
+					mvm->cfg->base_params->wd_timeout :
+					IWL_WATCHDOG_DISABLED;
 	int queue, fifo, ret;
 	u16 ssn;
 
@@ -988,7 +997,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return -EIO;
 
 	iwl_mvm_enable_agg_txq(mvm, queue, fifo, mvmsta->sta_id, tid,
-			       buf_size, ssn);
+			       buf_size, ssn, wdg_timeout);
 
 	/*
 	 * Even though in theory the peer could have different
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 02f434d..8decf99 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -531,7 +531,8 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 }
 
 void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, u16 ssn,
-			const struct iwl_trans_txq_scd_cfg *cfg)
+			const struct iwl_trans_txq_scd_cfg *cfg,
+			unsigned int wdg_timeout)
 {
 	struct iwl_scd_txq_cfg_cmd cmd = {
 		.scd_queue = queue,
@@ -545,11 +546,12 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, u16 ssn,
 	};
 
 	if (!iwl_mvm_is_scd_cfg_supported(mvm)) {
-		iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn, cfg);
+		iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn, cfg,
+					 wdg_timeout);
 		return;
 	}
 
-	iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn, NULL);
+	iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn, NULL, wdg_timeout);
 	WARN(iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0, sizeof(cmd), &cmd),
 	     "Failed to configure queue %d on FIFO %d\n", queue, cfg->fifo);
 }
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index e5652d8..cae0eb8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -216,6 +216,7 @@ struct iwl_pcie_txq_scratch_buf {
  * @need_update: indicates need to update read/write index
  * @active: stores if queue is active
  * @ampdu: true if this queue is an ampdu queue for an specific RA/TID
+ * @wd_timeout: queue watchdog timeout (jiffies) - per queue
  *
  * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
  * descriptors) and required locking structures.
@@ -232,6 +233,7 @@ struct iwl_txq {
 	bool need_update;
 	u8 active;
 	bool ampdu;
+	unsigned long wd_timeout;
 };
 
 static inline dma_addr_t
@@ -259,7 +261,6 @@ iwl_pcie_get_scratchbuf_dma(struct iwl_txq *txq, int idx)
  * @bc_table_dword: true if the BC table expects DWORD (as opposed to bytes)
  * @scd_set_active: should the transport configure the SCD for HCMD queue
  * @rx_page_order: page order for receive buffer size
- * @wd_timeout: queue watchdog timeout (jiffies)
  * @reg_lock: protect hw register access
  * @cmd_in_flight: true when we have a host command in flight
  * @fw_mon_phys: physical address of the buffer for the firmware monitor
@@ -302,6 +303,7 @@ struct iwl_trans_pcie {
 
 	u8 cmd_queue;
 	u8 cmd_fifo;
+	unsigned int cmd_q_wdg_timeout;
 	u8 n_no_reclaim_cmds;
 	u8 no_reclaim_cmds[MAX_NO_RECLAIM_CMDS];
 
@@ -312,9 +314,6 @@ struct iwl_trans_pcie {
 
 	const char *const *command_names;
 
-	/* queue watchdog */
-	unsigned long wd_timeout;
-
 	/*protect hw register */
 	spinlock_t reg_lock;
 	bool cmd_in_flight;
@@ -373,7 +372,8 @@ void iwl_pcie_tx_start(struct iwl_trans *trans, u32 scd_base_addr);
 int iwl_pcie_tx_stop(struct iwl_trans *trans);
 void iwl_pcie_tx_free(struct iwl_trans *trans);
 void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int queue, u16 ssn,
-			       const struct iwl_trans_txq_scd_cfg *cfg);
+			       const struct iwl_trans_txq_scd_cfg *cfg,
+			       unsigned int wdg_timeout);
 void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int queue,
 				bool configure_scd);
 int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index eb0ffc1..69935aa 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1269,6 +1269,7 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 
 	trans_pcie->cmd_queue = trans_cfg->cmd_queue;
 	trans_pcie->cmd_fifo = trans_cfg->cmd_fifo;
+	trans_pcie->cmd_q_wdg_timeout = trans_cfg->cmd_q_wdg_timeout;
 	if (WARN_ON(trans_cfg->n_no_reclaim_cmds > MAX_NO_RECLAIM_CMDS))
 		trans_pcie->n_no_reclaim_cmds = 0;
 	else
@@ -1283,9 +1284,6 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 	else
 		trans_pcie->rx_page_order = get_order(4 * 1024);
 
-	trans_pcie->wd_timeout =
-		msecs_to_jiffies(trans_cfg->queue_watchdog_timeout);
-
 	trans_pcie->command_names = trans_cfg->command_names;
 	trans_pcie->bc_table_dword = trans_cfg->bc_table_dword;
 	trans_pcie->scd_set_active = trans_cfg->scd_set_active;
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index bb9dd3e..af0bce7 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -163,7 +163,7 @@ static void iwl_pcie_txq_stuck_timer(unsigned long data)
 	spin_unlock(&txq->lock);
 
 	IWL_ERR(trans, "Queue %d stuck for %u ms.\n", txq->q.id,
-		jiffies_to_msecs(trans_pcie->wd_timeout));
+		jiffies_to_msecs(txq->wd_timeout));
 	IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
 		txq->q.read_ptr, txq->q.write_ptr);
 
@@ -674,7 +674,8 @@ void iwl_pcie_tx_start(struct iwl_trans *trans, u32 scd_base_addr)
 		iwl_write_prph(trans, SCD_CHAINEXT_EN, 0);
 
 	iwl_trans_ac_txq_enable(trans, trans_pcie->cmd_queue,
-				trans_pcie->cmd_fifo);
+				trans_pcie->cmd_fifo,
+				trans_pcie->cmd_q_wdg_timeout);
 
 	/* Activate all Tx DMA/FIFO channels */
 	iwl_scd_activate_fifos(trans);
@@ -909,10 +910,9 @@ error:
 	return ret;
 }
 
-static inline void iwl_pcie_txq_progress(struct iwl_trans_pcie *trans_pcie,
-					   struct iwl_txq *txq)
+static inline void iwl_pcie_txq_progress(struct iwl_txq *txq)
 {
-	if (!trans_pcie->wd_timeout)
+	if (!txq->wd_timeout)
 		return;
 
 	/*
@@ -922,7 +922,7 @@ static inline void iwl_pcie_txq_progress(struct iwl_trans_pcie *trans_pcie,
 	if (txq->q.read_ptr == txq->q.write_ptr)
 		del_timer(&txq->stuck_timer);
 	else
-		mod_timer(&txq->stuck_timer, jiffies + trans_pcie->wd_timeout);
+		mod_timer(&txq->stuck_timer, jiffies + txq->wd_timeout);
 }
 
 /* Frees buffers until index _not_ inclusive */
@@ -984,7 +984,7 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 		iwl_pcie_txq_free_tfd(trans, txq);
 	}
 
-	iwl_pcie_txq_progress(trans_pcie, txq);
+	iwl_pcie_txq_progress(txq);
 
 	if (iwl_queue_space(&txq->q) > txq->q.low_mark)
 		iwl_wake_queue(trans, txq);
@@ -1112,7 +1112,7 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 		spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
 	}
 
-	iwl_pcie_txq_progress(trans_pcie, txq);
+	iwl_pcie_txq_progress(txq);
 }
 
 static int iwl_pcie_txq_set_ratid_map(struct iwl_trans *trans, u16 ra_tid,
@@ -1145,14 +1145,18 @@ static int iwl_pcie_txq_set_ratid_map(struct iwl_trans *trans, u16 ra_tid,
 #define BUILD_RAxTID(sta_id, tid)	(((sta_id) << 4) + (tid))
 
 void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
-			       const struct iwl_trans_txq_scd_cfg *cfg)
+			       const struct iwl_trans_txq_scd_cfg *cfg,
+			       unsigned int wdg_timeout)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
 	int fifo = -1;
 
 	if (test_and_set_bit(txq_id, trans_pcie->queue_used))
 		WARN_ONCE(1, "queue %d already used - expect issues", txq_id);
 
+	txq->wd_timeout = msecs_to_jiffies(wdg_timeout);
+
 	if (cfg) {
 		fifo = cfg->fifo;
 
@@ -1176,7 +1180,7 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 
 			/* enable aggregations for the queue */
 			iwl_scd_txq_enable_agg(trans, txq_id);
-			trans_pcie->txq[txq_id].ampdu = true;
+			txq->ampdu = true;
 		} else {
 			/*
 			 * disable aggregations for the queue, this will also
@@ -1185,14 +1189,14 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 			 */
 			iwl_scd_txq_disable_agg(trans, txq_id);
 
-			ssn = trans_pcie->txq[txq_id].q.read_ptr;
+			ssn = txq->q.read_ptr;
 		}
 	}
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
-	trans_pcie->txq[txq_id].q.read_ptr = (ssn & 0xff);
-	trans_pcie->txq[txq_id].q.write_ptr = (ssn & 0xff);
+	txq->q.read_ptr = (ssn & 0xff);
+	txq->q.write_ptr = (ssn & 0xff);
 	iwl_write_direct32(trans, HBUS_TARG_WRPTR,
 			   (ssn & 0xff) | (txq_id << 8));
 
@@ -1233,7 +1237,7 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 				    txq_id, ssn & 0xff);
 	}
 
-	trans_pcie->txq[txq_id].active = true;
+	txq->active = true;
 }
 
 void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id,
@@ -1498,8 +1502,8 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	trace_iwlwifi_dev_hcmd(trans->dev, cmd, cmd_size, &out_cmd->hdr);
 
 	/* start timer if queue currently empty */
-	if (q->read_ptr == q->write_ptr && trans_pcie->wd_timeout)
-		mod_timer(&txq->stuck_timer, jiffies + trans_pcie->wd_timeout);
+	if (q->read_ptr == q->write_ptr && txq->wd_timeout)
+		mod_timer(&txq->stuck_timer, jiffies + txq->wd_timeout);
 
 	spin_lock_irqsave(&trans_pcie->reg_lock, flags);
 	ret = iwl_pcie_set_cmd_in_flight(trans, cmd);
@@ -1849,9 +1853,8 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	/* start timer if queue currently empty */
 	if (q->read_ptr == q->write_ptr) {
-		if (trans_pcie->wd_timeout)
-			mod_timer(&txq->stuck_timer,
-				  jiffies + trans_pcie->wd_timeout);
+		if (txq->wd_timeout)
+			mod_timer(&txq->stuck_timer, jiffies + txq->wd_timeout);
 		IWL_DEBUG_RPM(trans, "Q: %d first tx - take ref\n", q->id);
 		iwl_trans_pcie_ref(trans);
 	}
-- 
1.9.1

