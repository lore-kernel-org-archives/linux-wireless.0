Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22360 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbcCBH5m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:42 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/43] iwlwifi: mvm: add RSS queues notification infrastructure
Date: Wed,  2 Mar 2016 09:56:27 +0200
Message-Id: <1456905404-14435-26-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085953_519308_7AE816A6)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In multi rx queue HW, without execessive locking, there is no sync
between the ctrl path (default queue) and the rest of the rx queues.
This might cause issues on certain situations. For example, in case
a delBA was processed on a default queue but out of order packets
still wait for processing on the other queue.

The solution is to introduce internal messaging between the CTRL path
and the other rx queues.
The driver will send a message to the firmware, which will echo it to
all the requested queues. The message will be in order inside the queue.
This way we can avoid CTRL path and RSS queues races.

Add support for this messaging mechanism. As the firmware is agnostic to
the data sent, add internal representation of the data as well.
Although currently only delBA flow will use it, the internal representation
will enable generic use of this infrastructure for future uses.
Next patch will utilize this messaging mechanism for the reorder buffer
delBA flow.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h | 52 ++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  8 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 48 ++++++++++++++++++++
 5 files changed, 114 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index df939f5..eb9b870 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -391,4 +391,56 @@ struct iwl_rss_config_cmd {
 	u8 indirection_table[IWL_RSS_INDIRECTION_TABLE_SIZE];
 } __packed; /* RSS_CONFIG_CMD_API_S_VER_1 */
 
+#define IWL_MULTI_QUEUE_SYNC_MSG_MAX_SIZE 128
+#define IWL_MULTI_QUEUE_SYNC_SENDER_POS 0
+#define IWL_MULTI_QUEUE_SYNC_SENDER_MSK 0xf
+
+/**
+ * struct iwl_rxq_sync_cmd - RXQ notification trigger
+ *
+ * @flags: flags of the notification. bit 0:3 are the sender queue
+ * @rxq_mask: rx queues to send the notification on
+ * @count: number of bytes in payload, should be DWORD aligned
+ * @payload: data to send to rx queues
+ */
+struct iwl_rxq_sync_cmd {
+	__le32 flags;
+	__le32 rxq_mask;
+	__le32 count;
+	u8 payload[];
+} __packed; /* MULTI_QUEUE_DRV_SYNC_HDR_CMD_API_S_VER_1 */
+
+/**
+ * struct iwl_rxq_sync_notification - Notification triggered by RXQ
+ * sync command
+ *
+ * @count: number of bytes in payload
+ * @payload: data to send to rx queues
+ */
+struct iwl_rxq_sync_notification {
+	__le32 count;
+	u8 payload[];
+} __packed; /* MULTI_QUEUE_DRV_SYNC_HDR_CMD_API_S_VER_1 */
+
+/**
+* Internal message identifier
+*
+* @IWL_MVM_RXQ_NOTIF_DEL_BA: notify RSS queues of delBA
+*/
+enum iwl_mvm_rxq_notif_type {
+	IWL_MVM_RXQ_NOTIF_DEL_BA,
+};
+
+/**
+* struct iwl_mvm_internal_rxq_notif - Internal representation of the data sent
+* in &iwl_rxq_sync_cmd. Should be DWORD aligned.
+*
+* @type: value from &iwl_mvm_rxq_notif_type
+* @data: payload
+*/
+struct iwl_mvm_internal_rxq_notif {
+	u32 type;
+	u8 data[];
+} __packed;
+
 #endif /* __fw_api_rx_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index e1e1194..f432ddd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -289,6 +289,8 @@ enum iwl_phy_ops_subcmd_ids {
 
 enum iwl_data_path_subcmd_ids {
 	UPDATE_MU_GROUPS_CMD = 0x1,
+	TRIGGER_RX_QUEUES_NOTIF_CMD = 0x2,
+	RX_QUEUES_NOTIFICATION = 0xFF,
 };
 
 enum iwl_prot_offload_subcmd_ids {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index fa987bd..f05d2a1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1225,6 +1225,10 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			struct iwl_rx_cmd_buffer *rxb, int queue);
 void iwl_mvm_rx_frame_release(struct iwl_mvm *mvm,
 			      struct iwl_rx_cmd_buffer *rxb, int queue);
+int iwl_mvm_notify_rx_queue(struct iwl_mvm *mvm, u32 rxq_mask,
+			    const u8 *data, u32 count);
+void iwl_mvm_rx_queue_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
+			    int queue);
 void iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 52c73d0..ac271ff 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -404,6 +404,8 @@ static const struct iwl_hcmd_names iwl_mvm_phy_names[] = {
  */
 static const struct iwl_hcmd_names iwl_mvm_data_path_names[] = {
 	HCMD_NAME(UPDATE_MU_GROUPS_CMD),
+	HCMD_NAME(TRIGGER_RX_QUEUES_NOTIF_CMD),
+	HCMD_NAME(RX_QUEUES_NOTIFICATION),
 };
 
 /* Please keep this array *SORTED* by hex value.
@@ -876,6 +878,9 @@ static void iwl_mvm_rx_mq(struct iwl_op_mode *op_mode,
 		iwl_mvm_rx_mpdu_mq(mvm, napi, rxb, 0);
 	else if (pkt->hdr.cmd == REPLY_RX_PHY_CMD)
 		iwl_mvm_rx_phy_cmd_mq(mvm, rxb);
+	else if (unlikely(pkt->hdr.group_id == DATA_PATH_GROUP &&
+			  pkt->hdr.cmd == RX_QUEUES_NOTIFICATION))
+		iwl_mvm_rx_queue_notif(mvm, rxb, 0);
 	else
 		iwl_mvm_rx_common(mvm, rxb, pkt);
 }
@@ -1548,6 +1553,9 @@ static void iwl_mvm_rx_mq_rss(struct iwl_op_mode *op_mode,
 
 	if (unlikely(pkt->hdr.cmd == FRAME_RELEASE))
 		iwl_mvm_rx_frame_release(mvm, rxb, queue);
+	else if (unlikely(pkt->hdr.cmd == RX_QUEUES_NOTIFICATION &&
+			  pkt->hdr.group_id == DATA_PATH_GROUP))
+		iwl_mvm_rx_queue_notif(mvm, rxb, queue);
 	else
 		iwl_mvm_rx_mpdu_mq(mvm, napi, rxb, queue);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index d891942..590fc6f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -345,6 +345,54 @@ static bool iwl_mvm_is_nonagg_dup(struct ieee80211_sta *sta, int queue,
 	return false;
 }
 
+int iwl_mvm_notify_rx_queue(struct iwl_mvm *mvm, u32 rxq_mask,
+			    const u8 *data, u32 count)
+{
+	struct iwl_rxq_sync_cmd *cmd;
+	u32 data_size = sizeof(*cmd) + count;
+	int ret;
+
+	/* should be DWORD aligned */
+	if (WARN_ON(count & 3 || count > IWL_MULTI_QUEUE_SYNC_MSG_MAX_SIZE))
+		return -EINVAL;
+
+	cmd = kzalloc(data_size, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->rxq_mask = cpu_to_le32(rxq_mask);
+	cmd->count =  cpu_to_le32(count);
+	cmd->flags = 0;
+	memcpy(cmd->payload, data, count);
+
+	ret = iwl_mvm_send_cmd_pdu(mvm,
+				   WIDE_ID(DATA_PATH_GROUP,
+					   TRIGGER_RX_QUEUES_NOTIF_CMD),
+				   0, data_size, cmd);
+
+	kfree(cmd);
+	return ret;
+}
+
+void iwl_mvm_rx_queue_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
+			    int queue)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_rxq_sync_notification *notif;
+	struct iwl_mvm_internal_rxq_notif *internal_notif;
+
+	notif = (void *)pkt->data;
+	internal_notif = (void *)notif->payload;
+
+	switch (internal_notif->type) {
+	case IWL_MVM_RXQ_NOTIF_DEL_BA:
+		/* TODO */
+		break;
+	default:
+		WARN_ONCE(1, "Invalid identifier %d", internal_notif->type);
+	}
+}
+
 void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			struct iwl_rx_cmd_buffer *rxb, int queue)
 {
-- 
2.5.0

