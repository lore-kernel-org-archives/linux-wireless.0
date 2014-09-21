Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:45344 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaIUTWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:33 -0400
Received: by mail-we0-f178.google.com with SMTP id t60so1913360wes.23
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:22:32 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/17] iwlwifi: mvm: prepare for scheduler config command
Date: Sun, 21 Sep 2014 22:22:06 +0300
Message-Id: <1411327338-23099-5-git-send-email-egrumbach@gmail.com> (sfid-20140921_212238_343184_84A75804)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

The scheduler is a HW sub-block that directs the work of the Flow
Handler by issuing requests for frame transfers, specifying source
and destination. Its primary function is to allocate flows into the
TX FIFOs based upon a pre-determined mapping.

The driver has some responsibilities to the scheduler, namely
initialising and maintaining the hardware registers. This is
currently done by directly accessing them, which can cause races
with the firmware also accessing the registers.

To address this problem, change the driver to no longer directly
access the registers but go through the firmware for this if the
firmware has support for DQA and thus the new command.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h       |  3 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h   | 60 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 20 +++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 38 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  1 +
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 12 +++---
 drivers/net/wireless/iwlwifi/mvm/tx.c       |  4 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c    | 46 ++++++++++++++++++++++
 8 files changed, 165 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index e337546..4f6e668 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -153,6 +153,8 @@ enum iwl_ucode_tlv_api {
  * @IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT: supports adding TPC Report IE in
  *	probe requests.
  * @IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT: supports Quiet Period requests
+ * @IWL_UCODE_TLV_CAPA_DQA_SUPPORT: supports dynamic queue allocation (DQA),
+ *	which also implies support for the scheduler configuration command
  */
 enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= BIT(0),
@@ -160,6 +162,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT	= BIT(9),
 	IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT	= BIT(10),
 	IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT		= BIT(11),
+	IWL_UCODE_TLV_CAPA_DQA_SUPPORT			= BIT(12),
 };
 
 /* The default calibrate table size if not specified by firmware file */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index a2c6628..667a922 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -116,6 +116,9 @@ enum {
 	TXPATH_FLUSH = 0x1e,
 	MGMT_MCAST_KEY = 0x1f,
 
+	/* scheduler config */
+	SCD_QUEUE_CFG = 0x1d,
+
 	/* global key */
 	WEP_KEY = 0x20,
 
@@ -1650,4 +1653,61 @@ struct iwl_dts_measurement_notif {
 	__le32 voltage;
 } __packed; /* TEMPERATURE_MEASUREMENT_TRIGGER_NTFY_S */
 
+/**
+ * enum iwl_scd_control - scheduler config command control flags
+ * @IWL_SCD_CONTROL_RM_TID: remove TID from this queue
+ * @IWL_SCD_CONTROL_SET_SSN: use the SSN and program it into HW
+ */
+enum iwl_scd_control {
+	IWL_SCD_CONTROL_RM_TID	= BIT(4),
+	IWL_SCD_CONTROL_SET_SSN	= BIT(5),
+};
+
+/**
+ * enum iwl_scd_flags - scheduler config command flags
+ * @IWL_SCD_FLAGS_SHARE_TID: multiple TIDs map to this queue
+ * @IWL_SCD_FLAGS_SHARE_RA: multiple RAs map to this queue
+ * @IWL_SCD_FLAGS_DQA_ENABLED: DQA is enabled
+ */
+enum iwl_scd_flags {
+	IWL_SCD_FLAGS_SHARE_TID		= BIT(0),
+	IWL_SCD_FLAGS_SHARE_RA		= BIT(1),
+	IWL_SCD_FLAGS_DQA_ENABLED	= BIT(2),
+};
+
+#define IWL_SCDQ_INVALID_STA	0xff
+
+/**
+ * struct iwl_scd_txq_cfg_cmd - New txq hw scheduler config command
+ * @token:	dialog token addba - unused legacy
+ * @sta_id:	station id 4-bit
+ * @tid:	TID 0..7
+ * @scd_queue:	TFD queue num 0 .. 31
+ * @enable:	1 queue enable, 0 queue disable
+ * @aggregate:	1 aggregated queue, 0 otherwise
+ * @tx_fifo:	tx fifo num 0..7
+ * @window:	up to 64
+ * @ssn:	starting seq num 12-bit
+ * @control:	command control flags
+ * @flags:	flags - see &enum iwl_scd_flags
+ *
+ * Note that every time the command is sent, all parameters must
+ * be filled with the exception of
+ *  - the SSN, which is only used with @IWL_SCD_CONTROL_SET_SSN
+ *  - the window, which is only relevant when starting aggregation
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
+	u8 control;
+	u8 flags;
+} __packed;
+
 #endif /* __fw_api_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 8342671..0c5c0b0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -427,17 +427,17 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_P2P_DEVICE:
-		iwl_trans_ac_txq_enable(mvm->trans, IWL_MVM_OFFCHANNEL_QUEUE,
-					IWL_MVM_TX_FIFO_VO);
+		iwl_mvm_enable_ac_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE,
+				      IWL_MVM_TX_FIFO_VO);
 		break;
 	case NL80211_IFTYPE_AP:
-		iwl_trans_ac_txq_enable(mvm->trans, vif->cab_queue,
-					IWL_MVM_TX_FIFO_MCAST);
+		iwl_mvm_enable_ac_txq(mvm, vif->cab_queue,
+				      IWL_MVM_TX_FIFO_MCAST);
 		/* fall through */
 	default:
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-			iwl_trans_ac_txq_enable(mvm->trans, vif->hw_queue[ac],
-						iwl_mvm_ac_to_tx_fifo[ac]);
+			iwl_mvm_enable_ac_txq(mvm, vif->hw_queue[ac],
+					      iwl_mvm_ac_to_tx_fifo[ac]);
 		break;
 	}
 
@@ -452,16 +452,14 @@ void iwl_mvm_mac_ctxt_release(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_P2P_DEVICE:
-		iwl_trans_txq_disable(mvm->trans, IWL_MVM_OFFCHANNEL_QUEUE,
-				      true);
+		iwl_mvm_disable_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE);
 		break;
 	case NL80211_IFTYPE_AP:
-		iwl_trans_txq_disable(mvm->trans, vif->cab_queue, true);
+		iwl_mvm_disable_txq(mvm, vif->cab_queue);
 		/* fall through */
 	default:
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-			iwl_trans_txq_disable(mvm->trans, vif->hw_queue[ac],
-					      true);
+			iwl_mvm_disable_txq(mvm, vif->hw_queue[ac]);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 5529958..8eacebb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -779,6 +779,11 @@ static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
 	       (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_D0I3_SUPPORT);
 }
 
+static inline bool iwl_mvm_is_dqa_supported(struct iwl_mvm *mvm)
+{
+	return mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_DQA_SUPPORT;
+}
+
 extern const u8 iwl_mvm_ac_to_tx_fifo[];
 
 struct iwl_rate_info {
@@ -1141,6 +1146,39 @@ static inline bool iwl_mvm_vif_low_latency(struct iwl_mvm_vif *mvmvif)
 	return mvmvif->low_latency;
 }
 
+/* hw scheduler queue config */
+void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, u16 ssn,
+			const struct iwl_trans_txq_scd_cfg *cfg);
+void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue);
+
+static inline void iwl_mvm_enable_ac_txq(struct iwl_mvm *mvm, int queue,
+					 u8 fifo)
+{
+	struct iwl_trans_txq_scd_cfg cfg = {
+		.fifo = fifo,
+		.tid = IWL_MAX_TID_COUNT,
+		.aggregate = false,
+		.frame_limit = IWL_FRAME_LIMIT,
+	};
+
+	iwl_mvm_enable_txq(mvm, queue, 0, &cfg);
+}
+
+static inline void iwl_mvm_enable_agg_txq(struct iwl_mvm *mvm, int queue,
+					  int fifo, int sta_id, int tid,
+					  int frame_limit, u16 ssn)
+{
+	struct iwl_trans_txq_scd_cfg cfg = {
+		.fifo = fifo,
+		.sta_id = sta_id,
+		.tid = tid,
+		.frame_limit = frame_limit,
+		.aggregate = true,
+	};
+
+	iwl_mvm_enable_txq(mvm, queue, ssn, &cfg);
+}
+
 /* Assoc status */
 bool iwl_mvm_is_idle(struct iwl_mvm *mvm);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index f887779..9bf9de7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -342,6 +342,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(BT_COEX_UPDATE_REDUCED_TXP),
 	CMD(PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION),
 	CMD(ANTENNA_COUPLING_NOTIFICATION),
+	CMD(SCD_QUEUE_CFG),
 };
 #undef CMD
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 666f16b..bccd787 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -535,8 +535,8 @@ int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm)
 	lockdep_assert_held(&mvm->mutex);
 
 	/* Map Aux queue to fifo - needs to happen before adding Aux station */
-	iwl_trans_ac_txq_enable(mvm->trans, mvm->aux_queue,
-				IWL_MVM_TX_FIFO_MCAST);
+	iwl_mvm_enable_ac_txq(mvm, mvm->aux_queue,
+			      IWL_MVM_TX_FIFO_MCAST);
 
 	/* Allocate aux station and assign to it the aux queue */
 	ret = iwl_mvm_allocate_int_sta(mvm, &mvm->aux_sta, BIT(mvm->aux_queue),
@@ -887,8 +887,8 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (ret)
 		return -EIO;
 
-	iwl_trans_txq_enable(mvm->trans, queue, fifo, mvmsta->sta_id, tid,
-			     buf_size, ssn);
+	iwl_mvm_enable_agg_txq(mvm, queue, fifo, mvmsta->sta_id, tid,
+			       buf_size, ssn);
 
 	/*
 	 * Even though in theory the peer could have different
@@ -956,7 +956,7 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 		iwl_mvm_sta_tx_agg(mvm, sta, tid, txq_id, false);
 
-		iwl_trans_txq_disable(mvm->trans, txq_id, true);
+		iwl_mvm_disable_txq(mvm, txq_id);
 		return 0;
 	case IWL_AGG_STARTING:
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
@@ -1013,7 +1013,7 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 		iwl_mvm_sta_tx_agg(mvm, sta, tid, txq_id, false);
 
-		iwl_trans_txq_disable(mvm->trans, tid_data->txq_id, true);
+		iwl_mvm_disable_txq(mvm, tid_data->txq_id);
 	}
 
 	mvm->queue_to_mac80211[tid_data->txq_id] =
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index d84f3ca..66e1a3d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -493,11 +493,11 @@ static void iwl_mvm_check_ratid_empty(struct iwl_mvm *mvm,
 		IWL_DEBUG_TX_QUEUES(mvm,
 				    "Can continue DELBA flow ssn = next_recl = %d\n",
 				    tid_data->next_reclaimed);
-		iwl_trans_txq_disable(mvm->trans, tid_data->txq_id, true);
+		iwl_mvm_disable_txq(mvm, tid_data->txq_id);
 		tid_data->state = IWL_AGG_OFF;
 		/*
 		 * we can't hold the mutex - but since we are after a sequence
-		 * point (call to iwl_trans_txq_disable), so we don't even need
+		 * point (call to iwl_mvm_disable_txq(), so we don't even need
 		 * a memory barrier.
 		 */
 		mvm->queue_to_mac80211[tid_data->txq_id] =
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 1958f29..8021f6e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -530,6 +530,52 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 		iwl_mvm_dump_umac_error_log(mvm);
 }
 
+void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, u16 ssn,
+			const struct iwl_trans_txq_scd_cfg *cfg)
+{
+	if (iwl_mvm_is_dqa_supported(mvm)) {
+		struct iwl_scd_txq_cfg_cmd cmd = {
+			.scd_queue = queue,
+			.enable = 1,
+			.window = cfg->frame_limit,
+			.sta_id = cfg->sta_id,
+			.ssn = cpu_to_le16(ssn),
+			.tx_fifo = cfg->fifo,
+			.aggregate = cfg->aggregate,
+			.flags = IWL_SCD_FLAGS_DQA_ENABLED,
+			.tid = cfg->tid,
+			.control = IWL_SCD_CONTROL_SET_SSN,
+		};
+		int ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0,
+					       sizeof(cmd), &cmd);
+		if (ret)
+			IWL_ERR(mvm,
+				"Failed to configure queue %d on FIFO %d\n",
+				queue, cfg->fifo);
+	}
+
+	iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn,
+				 iwl_mvm_is_dqa_supported(mvm) ? NULL : cfg);
+}
+
+void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue)
+{
+	iwl_trans_txq_disable(mvm->trans, queue,
+			      !iwl_mvm_is_dqa_supported(mvm));
+
+	if (iwl_mvm_is_dqa_supported(mvm)) {
+		struct iwl_scd_txq_cfg_cmd cmd = {
+			.scd_queue = queue,
+			.enable = 0,
+		};
+		int ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, CMD_ASYNC,
+					       sizeof(cmd), &cmd);
+		if (ret)
+			IWL_ERR(mvm, "Failed to disable queue %d (ret=%d)\n",
+				queue, ret);
+	}
+}
+
 /**
  * iwl_mvm_send_lq_cmd() - Send link quality command
  * @init: This command is sent as part of station initialization right
-- 
1.9.1

