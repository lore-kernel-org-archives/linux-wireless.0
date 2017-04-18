Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52708 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757554AbdDRWRq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:17:46 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:08 +0300
Message-Id: <20170418221729.28372-5-luca@coelho.fi> (sfid-20170419_001754_903057_0402723C)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 04/25] iwlwifi: mvm: support new TX response for TVQM
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In TVQM mode the TX responses were changed to include
queue number since legacy TX queue number retrieval cannot
be scaled up to 512 queues.
Support this change.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h | 42 ++++++++++------------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  4 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       | 10 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 34 +++++++++++++++---
 4 files changed, 61 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index f83ee6e760d0..e9f055706a6f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -548,9 +548,11 @@ struct agg_tx_status {
  * @tlc_info: TLC rate info
  * @ra_tid: bits [3:0] = ra, bits [7:4] = tid
  * @frame_ctrl: frame control
+ * @tx_queue: TX queue for this response
  * @status: for non-agg:  frame status TX_STATUS_*
  *	for agg: status of 1st frame, AGG_TX_STATE_*; other frame status fields
  *	follow this one, up to frame_count.
+ *	For version 6 TX response isn't received for aggregation at all.
  *
  * After the array of statuses comes the SSN of the SCD. Look at
  * %iwl_mvm_get_scd_ssn for more details.
@@ -577,9 +579,17 @@ struct iwl_mvm_tx_resp {
 	u8 tlc_info;
 	u8 ra_tid;
 	__le16 frame_ctrl;
-
-	struct agg_tx_status status;
-} __packed; /* TX_RSP_API_S_VER_3 */
+	union {
+		struct {
+			struct agg_tx_status status;
+		} v3;/* TX_RSP_API_S_VER_3 */
+		struct {
+			__le16 tx_queue;
+			__le16 reserved2;
+			struct agg_tx_status status;
+		} v6;
+	};
+} __packed; /* TX_RSP_API_S_VER_6 */
 
 /**
  * struct iwl_mvm_ba_notif - notifies about reception of BA
@@ -619,11 +629,14 @@ struct iwl_mvm_ba_notif {
  * struct iwl_mvm_compressed_ba_tfd - progress of a TFD queue
  * @q_num: TFD queue number
  * @tfd_index: Index of first un-acked frame in the  TFD queue
+ * @scd_queue: For debug only - the physical queue the TFD queue is bound to
  */
 struct iwl_mvm_compressed_ba_tfd {
-	u8 q_num;
-	u8 reserved;
+	__le16 q_num;
 	__le16 tfd_index;
+	u8 scd_queue;
+	u8 reserved;
+	__le16 reserved2;
 } __packed; /* COMPRESSED_BA_TFD_API_S_VER_1 */
 
 /**
@@ -799,25 +812,6 @@ struct iwl_tx_path_flush_cmd {
 	__le16 reserved;
 } __packed; /* TX_PATH_FLUSH_CMD_API_S_VER_1 */
 
-/**
- * iwl_mvm_get_scd_ssn - returns the SSN of the SCD
- * @tx_resp: the Tx response from the fw (agg or non-agg)
- *
- * When the fw sends an AMPDU, it fetches the MPDUs one after the other. Since
- * it can't know that everything will go well until the end of the AMPDU, it
- * can't know in advance the number of MPDUs that will be sent in the current
- * batch. This is why it writes the agg Tx response while it fetches the MPDUs.
- * Hence, it can't know in advance what the SSN of the SCD will be at the end
- * of the batch. This is why the SSN of the SCD is written at the end of the
- * whole struct at a variable offset. This function knows how to cope with the
- * variable offset and returns the SSN of the SCD.
- */
-static inline u32 iwl_mvm_get_scd_ssn(struct iwl_mvm_tx_resp *tx_resp)
-{
-	return le32_to_cpup((__le32 *)&tx_resp->status +
-			    tx_resp->frame_count) & 0xfff;
-}
-
 /* Available options for the SCD_QUEUE_CFG HCMD */
 enum iwl_scd_cfg_actions {
 	SCD_CFG_DISABLE_QUEUE		= 0x0,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 2473f4bd6238..edaaa3bcf0b2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1442,6 +1442,7 @@ void iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 	struct iwl_mvm_tx_resp *beacon_notify_hdr;
 	struct ieee80211_vif *csa_vif;
 	struct ieee80211_vif *tx_blocked_vif;
+	struct agg_tx_status *agg_status;
 	u16 status;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1449,7 +1450,8 @@ void iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 	beacon_notify_hdr = &beacon->beacon_notify_hdr;
 	mvm->ap_last_beacon_gp2 = le32_to_cpu(beacon->gp2);
 
-	status = le16_to_cpu(beacon_notify_hdr->status.status) & TX_STATUS_MSK;
+	agg_status = iwl_mvm_get_agg_status(mvm, beacon_notify_hdr);
+	status = le16_to_cpu(agg_status->status) & TX_STATUS_MSK;
 	IWL_DEBUG_RX(mvm,
 		     "beacon status %#x retries:%d tsf:0x%16llX gp2:0x%X rate:%d\n",
 		     status, beacon_notify_hdr->failure_frame,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 2205c9f8bb58..70abc6cd3b47 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1250,6 +1250,16 @@ static inline bool iwl_mvm_is_cdb_supported(struct iwl_mvm *mvm)
 			   IWL_UCODE_TLV_CAPA_CDB_SUPPORT);
 }
 
+static inline struct agg_tx_status*
+iwl_mvm_get_agg_status(struct iwl_mvm *mvm,
+		       struct iwl_mvm_tx_resp *tx_resp)
+{
+	if (iwl_mvm_has_new_tx_api(mvm))
+		return &tx_resp->v6.status;
+	else
+		return &tx_resp->v3.status;
+}
+
 static inline bool iwl_mvm_is_tt_in_fw(struct iwl_mvm *mvm)
 {
 #ifdef CONFIG_THERMAL
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 2436253d936c..8d86a450ec3c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1279,6 +1279,26 @@ static void iwl_mvm_tx_status_check_trigger(struct iwl_mvm *mvm,
 	}
 }
 
+/**
+ * iwl_mvm_get_scd_ssn - returns the SSN of the SCD
+ * @tx_resp: the Tx response from the fw (agg or non-agg)
+ *
+ * When the fw sends an AMPDU, it fetches the MPDUs one after the other. Since
+ * it can't know that everything will go well until the end of the AMPDU, it
+ * can't know in advance the number of MPDUs that will be sent in the current
+ * batch. This is why it writes the agg Tx response while it fetches the MPDUs.
+ * Hence, it can't know in advance what the SSN of the SCD will be at the end
+ * of the batch. This is why the SSN of the SCD is written at the end of the
+ * whole struct at a variable offset. This function knows how to cope with the
+ * variable offset and returns the SSN of the SCD.
+ */
+static inline u32 iwl_mvm_get_scd_ssn(struct iwl_mvm *mvm,
+				      struct iwl_mvm_tx_resp *tx_resp)
+{
+	return le32_to_cpup((__le32 *)iwl_mvm_get_agg_status(mvm, tx_resp) +
+			    tx_resp->frame_count) & 0xfff;
+}
+
 static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 				     struct iwl_rx_packet *pkt)
 {
@@ -1288,8 +1308,10 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 	struct iwl_mvm_tx_resp *tx_resp = (void *)pkt->data;
 	int sta_id = IWL_MVM_TX_RES_GET_RA(tx_resp->ra_tid);
 	int tid = IWL_MVM_TX_RES_GET_TID(tx_resp->ra_tid);
-	u32 status = le16_to_cpu(tx_resp->status.status);
-	u16 ssn = iwl_mvm_get_scd_ssn(tx_resp);
+	struct agg_tx_status *agg_status =
+		iwl_mvm_get_agg_status(mvm, tx_resp);
+	u32 status = le16_to_cpu(agg_status->status);
+	u16 ssn = iwl_mvm_get_scd_ssn(mvm, tx_resp);
 	struct iwl_mvm_sta *mvmsta;
 	struct sk_buff_head skbs;
 	u8 skb_freed = 0;
@@ -1298,6 +1320,9 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 
 	__skb_queue_head_init(&skbs);
 
+	if (iwl_mvm_has_new_tx_api(mvm))
+		txq_id = le16_to_cpu(tx_resp->v6.tx_queue);
+
 	seq_ctl = le16_to_cpu(tx_resp->seq_ctl);
 
 	/* we can free until ssn % q.n_bd not inclusive */
@@ -1554,7 +1579,8 @@ static void iwl_mvm_rx_tx_cmd_agg_dbg(struct iwl_mvm *mvm,
 				      struct iwl_rx_packet *pkt)
 {
 	struct iwl_mvm_tx_resp *tx_resp = (void *)pkt->data;
-	struct agg_tx_status *frame_status = &tx_resp->status;
+	struct agg_tx_status *frame_status =
+		iwl_mvm_get_agg_status(mvm, tx_resp);
 	int i;
 
 	for (i = 0; i < tx_resp->frame_count; i++) {
@@ -1769,7 +1795,7 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 		if (tid == IWL_MGMT_TID)
 			tid = IWL_MAX_TID_COUNT;
 		iwl_mvm_tx_reclaim(mvm, sta_id, tid,
-				   (int)ba_res->tfd[0].q_num,
+				   (int)(le16_to_cpu(ba_res->tfd[0].q_num)),
 				   le16_to_cpu(ba_res->tfd[0].tfd_index),
 				   &ba_info, le32_to_cpu(ba_res->tx_rate));
 
-- 
2.11.0
