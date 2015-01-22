Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbbAVUd7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:33:59 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/38] iwlwifi: mvm: let the firmware configure the scheduler
Date: Thu, 22 Jan 2015 22:33:04 +0200
Message-Id: <1421958809-3371-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_213408_443423_F561255D)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A new host command can be used to configure the scheduler
instead of accessing the scheduler's registers from the
driver. This is easier and less error prone since accessing
the hardware at certain moments can lead to races with the
firmware.
Prefer to use the host command whenever it is available.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h   |  3 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h | 39 ++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h    | 57 -----------------------
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c  |  6 +--
 drivers/net/wireless/iwlwifi/mvm/mvm.h       |  6 +--
 drivers/net/wireless/iwlwifi/mvm/sta.c       |  8 ++--
 drivers/net/wireless/iwlwifi/mvm/tx.c        |  2 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c     | 69 ++++++++++++++--------------
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 14 ++++--
 9 files changed, 97 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index c4266b0..32e8b5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -244,6 +244,8 @@ enum iwl_ucode_tlv_flag {
  * @IWL_UCODE_TLV_API_BASIC_DWELL: use only basic dwell time in scan command,
  *	regardless of the band or the number of the probes. FW will calculate
  *	the actual dwell time.
+ * @IWL_UCODE_TLV_API_SCD_CFG: This firmware can configure the scheduler
+ *	through the dedicated host command.
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = BIT(3),
@@ -252,6 +254,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF	= BIT(7),
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= BIT(8),
 	IWL_UCODE_TLV_API_BASIC_DWELL		= BIT(13),
+	IWL_UCODE_TLV_API_SCD_CFG		= BIT(15),
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
index 5bca1f8..81c4ea3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
@@ -592,4 +592,43 @@ static inline u32 iwl_mvm_get_scd_ssn(struct iwl_mvm_tx_resp *tx_resp)
 			    tx_resp->frame_count) & 0xfff;
 }
 
+/**
+ * struct iwl_scd_txq_cfg_cmd - New txq hw scheduler config command
+ * @token:
+ * @sta_id: station id
+ * @tid:
+ * @scd_queue: scheduler queue to confiug
+ * @enable: 1 queue enable, 0 queue disable
+ * @aggregate: 1 aggregated queue, 0 otherwise
+ * @tx_fifo: %enum iwl_mvm_tx_fifo
+ * @window: BA window size
+ * @ssn: SSN for the BA agreement
+ */
+struct iwl_scd_txq_cfg_cmd {
+	u8 token;
+	u8 sta_id;
+	u8 tid;
+	u8 scd_queue;
+	u8 enable;
+	u8 aggregate;
+	u8 tx_fifo;
+	u8 window;
+	__le16 ssn;
+	__le16 reserved;
+} __packed; /* SCD_QUEUE_CFG_CMD_API_S_VER_1 */
+
+/**
+ * struct iwl_scd_txq_cfg_rsp
+ * @token: taken from the command
+ * @sta_id: station id from the command
+ * @tid: tid from the command
+ * @scd_queue: scd_queue from the command
+ */
+struct iwl_scd_txq_cfg_rsp {
+	u8 token;
+	u8 sta_id;
+	u8 tid;
+	u8 scd_queue;
+} __packed; /* SCD_QUEUE_CFG_RSP_API_S_VER_1 */
+
 #endif /* __fw_api_tx_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 88af6dd..b1e9dac 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1680,63 +1680,6 @@ struct iwl_dts_measurement_notif {
 	__le32 voltage;
 } __packed; /* TEMPERATURE_MEASUREMENT_TRIGGER_NTFY_S */
 
-/**
- * enum iwl_scd_control - scheduler config command control flags
- * @IWL_SCD_CONTROL_RM_TID: remove TID from this queue
- * @IWL_SCD_CONTROL_SET_SSN: use the SSN and program it into HW
- */
-enum iwl_scd_control {
-	IWL_SCD_CONTROL_RM_TID	= BIT(4),
-	IWL_SCD_CONTROL_SET_SSN	= BIT(5),
-};
-
-/**
- * enum iwl_scd_flags - scheduler config command flags
- * @IWL_SCD_FLAGS_SHARE_TID: multiple TIDs map to this queue
- * @IWL_SCD_FLAGS_SHARE_RA: multiple RAs map to this queue
- * @IWL_SCD_FLAGS_DQA_ENABLED: DQA is enabled
- */
-enum iwl_scd_flags {
-	IWL_SCD_FLAGS_SHARE_TID		= BIT(0),
-	IWL_SCD_FLAGS_SHARE_RA		= BIT(1),
-	IWL_SCD_FLAGS_DQA_ENABLED	= BIT(2),
-};
-
-#define IWL_SCDQ_INVALID_STA	0xff
-
-/**
- * struct iwl_scd_txq_cfg_cmd - New txq hw scheduler config command
- * @token:	dialog token addba - unused legacy
- * @sta_id:	station id 4-bit
- * @tid:	TID 0..7
- * @scd_queue:	TFD queue num 0 .. 31
- * @enable:	1 queue enable, 0 queue disable
- * @aggregate:	1 aggregated queue, 0 otherwise
- * @tx_fifo:	tx fifo num 0..7
- * @window:	up to 64
- * @ssn:	starting seq num 12-bit
- * @control:	command control flags
- * @flags:	flags - see &enum iwl_scd_flags
- *
- * Note that every time the command is sent, all parameters must
- * be filled with the exception of
- *  - the SSN, which is only used with @IWL_SCD_CONTROL_SET_SSN
- *  - the window, which is only relevant when starting aggregation
- */
-struct iwl_scd_txq_cfg_cmd {
-	u8 token;
-	u8 sta_id;
-	u8 tid;
-	u8 scd_queue;
-	u8 enable;
-	u8 aggregate;
-	u8 tx_fifo;
-	u8 window;
-	__le16 ssn;
-	u8 control;
-	u8 flags;
-} __packed;
-
 /***********************************
  * TDLS API
  ***********************************/
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 7196b4d..a3e9cd9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -496,14 +496,14 @@ void iwl_mvm_mac_ctxt_release(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_P2P_DEVICE:
-		iwl_mvm_disable_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE);
+		iwl_mvm_disable_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE, 0);
 		break;
 	case NL80211_IFTYPE_AP:
-		iwl_mvm_disable_txq(mvm, vif->cab_queue);
+		iwl_mvm_disable_txq(mvm, vif->cab_queue, 0);
 		/* fall through */
 	default:
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-			iwl_mvm_disable_txq(mvm, vif->hw_queue[ac]);
+			iwl_mvm_disable_txq(mvm, vif->hw_queue[ac], 0);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 6355127..e9c05d7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -858,9 +858,9 @@ static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
 	       (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_D0I3_SUPPORT);
 }
 
-static inline bool iwl_mvm_is_dqa_supported(struct iwl_mvm *mvm)
+static inline bool iwl_mvm_is_scd_cfg_supported(struct iwl_mvm *mvm)
 {
-	return mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_DQA_SUPPORT;
+	return mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_API_SCD_CFG;
 }
 
 extern const u8 iwl_mvm_ac_to_tx_fifo[];
@@ -1298,7 +1298,7 @@ static inline bool iwl_mvm_vif_low_latency(struct iwl_mvm_vif *mvmvif)
 /* hw scheduler queue config */
 void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, u16 ssn,
 			const struct iwl_trans_txq_scd_cfg *cfg);
-void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue);
+void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, u8 flags);
 
 static inline void iwl_mvm_enable_ac_txq(struct iwl_mvm *mvm, int queue,
 					 u8 fifo)
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index ad32798..b93a177 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -251,7 +251,7 @@ static void iwl_mvm_tdls_sta_deinit(struct iwl_mvm *mvm,
 	/* disable the TDLS STA-specific queues */
 	sta_msk = mvmsta->tfd_queue_msk;
 	for_each_set_bit(i, &sta_msk, sizeof(sta_msk))
-		iwl_mvm_disable_txq(mvm, i);
+		iwl_mvm_disable_txq(mvm, i, 0);
 }
 
 int iwl_mvm_add_sta(struct iwl_mvm *mvm,
@@ -465,7 +465,7 @@ void iwl_mvm_sta_drained_wk(struct work_struct *wk)
 			unsigned long i, msk = mvm->tfd_drained[sta_id];
 
 			for_each_set_bit(i, &msk, sizeof(msk))
-				iwl_mvm_disable_txq(mvm, i);
+				iwl_mvm_disable_txq(mvm, i, 0);
 
 			mvm->tfd_drained[sta_id] = 0;
 			IWL_DEBUG_TDLS(mvm, "Drained sta %d, with queues %ld\n",
@@ -1058,7 +1058,7 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 		iwl_mvm_sta_tx_agg(mvm, sta, tid, txq_id, false);
 
-		iwl_mvm_disable_txq(mvm, txq_id);
+		iwl_mvm_disable_txq(mvm, txq_id, 0);
 		return 0;
 	case IWL_AGG_STARTING:
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
@@ -1116,7 +1116,7 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 		iwl_mvm_sta_tx_agg(mvm, sta, tid, txq_id, false);
 
-		iwl_mvm_disable_txq(mvm, tid_data->txq_id);
+		iwl_mvm_disable_txq(mvm, tid_data->txq_id, 0);
 	}
 
 	mvm->queue_to_mac80211[tid_data->txq_id] =
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 1fff0f4..8ed55d6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -496,7 +496,7 @@ static void iwl_mvm_check_ratid_empty(struct iwl_mvm *mvm,
 		IWL_DEBUG_TX_QUEUES(mvm,
 				    "Can continue DELBA flow ssn = next_recl = %d\n",
 				    tid_data->next_reclaimed);
-		iwl_mvm_disable_txq(mvm, tid_data->txq_id);
+		iwl_mvm_disable_txq(mvm, tid_data->txq_id, CMD_ASYNC);
 		tid_data->state = IWL_AGG_OFF;
 		/*
 		 * we can't hold the mutex - but since we are after a sequence
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index f0a1141..85effe2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -533,47 +533,46 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, u16 ssn,
 			const struct iwl_trans_txq_scd_cfg *cfg)
 {
-	if (iwl_mvm_is_dqa_supported(mvm)) {
-		struct iwl_scd_txq_cfg_cmd cmd = {
-			.scd_queue = queue,
-			.enable = 1,
-			.window = cfg->frame_limit,
-			.sta_id = cfg->sta_id,
-			.ssn = cpu_to_le16(ssn),
-			.tx_fifo = cfg->fifo,
-			.aggregate = cfg->aggregate,
-			.flags = IWL_SCD_FLAGS_DQA_ENABLED,
-			.tid = cfg->tid,
-			.control = IWL_SCD_CONTROL_SET_SSN,
-		};
-		int ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0,
-					       sizeof(cmd), &cmd);
-		if (ret)
-			IWL_ERR(mvm,
-				"Failed to configure queue %d on FIFO %d\n",
-				queue, cfg->fifo);
+	struct iwl_scd_txq_cfg_cmd cmd = {
+		.scd_queue = queue,
+		.enable = 1,
+		.window = cfg->frame_limit,
+		.sta_id = cfg->sta_id,
+		.ssn = cpu_to_le16(ssn),
+		.tx_fifo = cfg->fifo,
+		.aggregate = cfg->aggregate,
+		.tid = cfg->tid,
+	};
+
+	if (!iwl_mvm_is_scd_cfg_supported(mvm)) {
+		iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn, cfg);
+		return;
 	}
 
-	iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn,
-				 iwl_mvm_is_dqa_supported(mvm) ? NULL : cfg);
+	iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn, NULL);
+	WARN(iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0, sizeof(cmd), &cmd),
+	     "Failed to configure queue %d on FIFO %d\n", queue, cfg->fifo);
 }
 
-void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue)
+void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, u8 flags)
 {
-	iwl_trans_txq_disable(mvm->trans, queue,
-			      !iwl_mvm_is_dqa_supported(mvm));
-
-	if (iwl_mvm_is_dqa_supported(mvm)) {
-		struct iwl_scd_txq_cfg_cmd cmd = {
-			.scd_queue = queue,
-			.enable = 0,
-		};
-		int ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, CMD_ASYNC,
-					       sizeof(cmd), &cmd);
-		if (ret)
-			IWL_ERR(mvm, "Failed to disable queue %d (ret=%d)\n",
-				queue, ret);
+	struct iwl_scd_txq_cfg_cmd cmd = {
+		.scd_queue = queue,
+		.enable = 0,
+	};
+	int ret;
+
+	if (!iwl_mvm_is_scd_cfg_supported(mvm)) {
+		iwl_trans_txq_disable(mvm->trans, queue, true);
+		return;
 	}
+
+	iwl_trans_txq_disable(mvm->trans, queue, false);
+	ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, flags,
+				   sizeof(cmd), &cmd);
+	if (ret)
+		IWL_ERR(mvm, "Failed to disable queue %d (ret=%d)\n",
+			queue, ret);
 }
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index c1c4c7502..d40cd4a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1190,12 +1190,12 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
 	trans_pcie->txq[txq_id].q.read_ptr = (ssn & 0xff);
 	trans_pcie->txq[txq_id].q.write_ptr = (ssn & 0xff);
+	iwl_write_direct32(trans, HBUS_TARG_WRPTR,
+			   (ssn & 0xff) | (txq_id << 8));
 
 	if (cfg) {
 		u8 frame_limit = cfg->frame_limit;
 
-		iwl_write_direct32(trans, HBUS_TARG_WRPTR,
-				   (ssn & 0xff) | (txq_id << 8));
 		iwl_write_prph(trans, SCD_QUEUE_RDPTR(txq_id), ssn);
 
 		/* Set up Tx window size and frame limit for this queue */
@@ -1220,11 +1220,17 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 		if (txq_id == trans_pcie->cmd_queue &&
 		    trans_pcie->scd_set_active)
 			iwl_scd_enable_set_active(trans, BIT(txq_id));
+
+		IWL_DEBUG_TX_QUEUES(trans,
+				    "Activate queue %d on FIFO %d WrPtr: %d\n",
+				    txq_id, fifo, ssn & 0xff);
+	} else {
+		IWL_DEBUG_TX_QUEUES(trans,
+				    "Activate queue %d WrPtr: %d\n",
+				    txq_id, ssn & 0xff);
 	}
 
 	trans_pcie->txq[txq_id].active = true;
-	IWL_DEBUG_TX_QUEUES(trans, "Activate queue %d on FIFO %d WrPtr: %d\n",
-			    txq_id, fifo, ssn & 0xff);
 }
 
 void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id,
-- 
1.9.1

