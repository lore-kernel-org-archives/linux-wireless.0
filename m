Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40602 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751410AbcEJUIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:08:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:04 +0300
Message-Id: <1462910797-20303-8-git-send-email-luca@coelho.fi> (sfid-20160510_220854_858395_2E4A20EB)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 08/41] iwlwifi: mvm: add reorder buffer per queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Next hardware will direct packets to core based on the TCP/UDP
streams.
This logic can create holes in reorder buffer since packets that
belong to other stream were directed to a different core.
However, those are valid holes and the packets can be indicated
in L3 order.

The hardware will utilize a mechanism of informing the driver of
the normalized ssn and the driver shall release all packets that
SN is lower than the nssn.
This enables managing the reorder across the queues without sharing
any data between them.

The reorder buffer is allocated and released directly in the RX path
in order to avoid various races between control path and rx path.
The code utilizes the internal messaging to notify rx queues of when
to delete the reorder buffer.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  24 +++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 181 +++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |  69 ++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h      |   9 ++
 5 files changed, 276 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index ae441c5..6286063 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -439,6 +439,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ieee80211_hw_set(hw, SUPPORTS_CLONED_SKBS);
 	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
 	ieee80211_hw_set(hw, NEEDS_UNIQUE_STA_ADDR);
+	if (iwl_mvm_has_new_rx_api(mvm))
+		ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
 
 	if (mvm->trans->max_skb_frags)
 		hw->netdev_features = NETIF_F_HIGHDMA | NETIF_F_SG;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index ea1817a..8272e54 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -614,6 +614,28 @@ struct iwl_mvm_shared_mem_cfg {
 };
 
 /**
+ * struct iwl_mvm_reorder_buffer - per ra/tid/queue reorder buffer
+ * @head_sn: reorder window head sn
+ * @num_stored: number of mpdus stored in the buffer
+ * @buf_size: the reorder buffer size as set by the last addba request
+ * @sta_id: sta id of this reorder buffer
+ * @queue: queue of this reorder buffer
+ * @last_amsdu: track last ASMDU SN for duplication detection
+ * @last_sub_index: track ASMDU sub frame index for duplication detection
+ * @entries: list of skbs stored
+ */
+struct iwl_mvm_reorder_buffer {
+	u16 head_sn;
+	u16 num_stored;
+	u8 buf_size;
+	u8 sta_id;
+	int queue;
+	u16 last_amsdu;
+	u8 last_sub_index;
+	struct sk_buff_head entries[IEEE80211_MAX_AMPDU_BUF];
+} ____cacheline_aligned_in_smp;
+
+/**
  * struct iwl_mvm_baid_data - BA session data
  * @sta_id: station id
  * @tid: tid of the session
@@ -622,6 +644,7 @@ struct iwl_mvm_shared_mem_cfg {
  * @last_rx: last rx jiffies, updated only if timeout passed from last update
  * @session_timer: timer to check if BA session expired, runs at 2 * timeout
  * @mvm: mvm pointer, needed for timer context
+ * @reorder_buf: reorder buffer, allocated per queue
  */
 struct iwl_mvm_baid_data {
 	struct rcu_head rcu_head;
@@ -632,6 +655,7 @@ struct iwl_mvm_baid_data {
 	unsigned long last_rx;
 	struct timer_list session_timer;
 	struct iwl_mvm *mvm;
+	struct iwl_mvm_reorder_buffer reorder_buf[];
 };
 
 struct iwl_mvm {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 8d5717b..4f320dc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -395,6 +395,67 @@ int iwl_mvm_notify_rx_queue(struct iwl_mvm *mvm, u32 rxq_mask,
 	return ret;
 }
 
+static void iwl_mvm_release_frames(struct iwl_mvm *mvm,
+				   struct ieee80211_sta *sta,
+				   struct napi_struct *napi,
+				   struct iwl_mvm_reorder_buffer *reorder_buf,
+				   u16 nssn)
+{
+	u16 ssn = reorder_buf->head_sn;
+
+	while (ieee80211_sn_less(ssn, nssn)) {
+		int index = ssn % reorder_buf->buf_size;
+		struct sk_buff_head *skb_list = &reorder_buf->entries[index];
+		struct sk_buff *skb;
+
+		ssn = ieee80211_sn_inc(ssn);
+
+		/* holes are valid since nssn indicates frames were received. */
+		if (skb_queue_empty(skb_list) || !skb_peek_tail(skb_list))
+			continue;
+		/* Empty the list. Will have more than one frame for A-MSDU */
+		while ((skb = __skb_dequeue(skb_list))) {
+			iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb,
+							reorder_buf->queue,
+							sta);
+			reorder_buf->num_stored--;
+		}
+	}
+	reorder_buf->head_sn = nssn;
+}
+
+static void iwl_mvm_del_ba(struct iwl_mvm *mvm, int queue,
+			   struct iwl_mvm_delba_data *data)
+{
+	struct iwl_mvm_baid_data *ba_data;
+	struct ieee80211_sta *sta;
+	struct iwl_mvm_reorder_buffer *reorder_buf;
+	u8 baid = data->baid;
+
+	if (WARN_ON_ONCE(baid >= IWL_RX_REORDER_DATA_INVALID_BAID))
+		return;
+
+	rcu_read_lock();
+
+	ba_data = rcu_dereference(mvm->baid_map[baid]);
+	if (WARN_ON_ONCE(!ba_data))
+		goto out;
+
+	sta = rcu_dereference(mvm->fw_id_to_mac_id[ba_data->sta_id]);
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(sta)))
+		goto out;
+
+	reorder_buf = &ba_data->reorder_buf[queue];
+
+	/* release all frames that are in the reorder buffer to the stack */
+	iwl_mvm_release_frames(mvm, sta, NULL, reorder_buf,
+			       ieee80211_sn_add(reorder_buf->head_sn,
+						reorder_buf->buf_size));
+
+out:
+	rcu_read_unlock();
+}
+
 void iwl_mvm_rx_queue_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			    int queue)
 {
@@ -418,12 +479,129 @@ void iwl_mvm_rx_queue_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	case IWL_MVM_RXQ_EMPTY:
 		break;
 	case IWL_MVM_RXQ_NOTIF_DEL_BA:
+		iwl_mvm_del_ba(mvm, queue, (void *)internal_notif->data);
 		break;
 	default:
 		WARN_ONCE(1, "Invalid identifier %d", internal_notif->type);
 	}
 }
 
+/*
+ * Returns true if the MPDU was buffered\dropped, false if it should be passed
+ * to upper layer.
+ */
+static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
+			    struct napi_struct *napi,
+			    int queue,
+			    struct ieee80211_sta *sta,
+			    struct sk_buff *skb,
+			    struct iwl_rx_mpdu_desc *desc)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_mvm_baid_data *baid_data;
+	struct iwl_mvm_reorder_buffer *buffer;
+	struct sk_buff *tail;
+	u32 reorder = le32_to_cpu(desc->reorder_data);
+	bool amsdu = desc->mac_flags2 & IWL_RX_MPDU_MFLG2_AMSDU;
+	u8 tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
+	u8 sub_frame_idx = desc->amsdu_info &
+			   IWL_RX_MPDU_AMSDU_SUBFRAME_IDX_MASK;
+	int index;
+	u16 nssn, sn;
+	u8 baid;
+
+	baid = (reorder & IWL_RX_MPDU_REORDER_BAID_MASK) >>
+		IWL_RX_MPDU_REORDER_BAID_SHIFT;
+
+	if (baid == IWL_RX_REORDER_DATA_INVALID_BAID)
+		return false;
+
+	/* no sta yet */
+	if (WARN_ON(IS_ERR_OR_NULL(sta)))
+		return false;
+
+	/* not a data packet */
+	if (!ieee80211_is_data_qos(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1))
+		return false;
+
+	if (unlikely(!ieee80211_is_data_present(hdr->frame_control)))
+		return false;
+
+	baid_data = rcu_dereference(mvm->baid_map[baid]);
+	if (WARN(!baid_data,
+		 "Received baid %d, but no data exists for this BAID\n", baid))
+		return false;
+	if (WARN(tid != baid_data->tid || mvm_sta->sta_id != baid_data->sta_id,
+		 "baid 0x%x is mapped to sta:%d tid:%d, but was received for sta:%d tid:%d\n",
+		 baid, baid_data->sta_id, baid_data->tid, mvm_sta->sta_id,
+		 tid))
+		return false;
+
+	nssn = reorder & IWL_RX_MPDU_REORDER_NSSN_MASK;
+	sn = (reorder & IWL_RX_MPDU_REORDER_SN_MASK) >>
+		IWL_RX_MPDU_REORDER_SN_SHIFT;
+
+	buffer = &baid_data->reorder_buf[queue];
+
+	/*
+	 * If there was a significant jump in the nssn - adjust.
+	 * If the SN is smaller than the NSSN it might need to first go into
+	 * the reorder buffer, in which case we just release up to it and the
+	 * rest of the function will take of storing it and releasing up to the
+	 * nssn
+	 */
+	if (!ieee80211_sn_less(nssn, buffer->head_sn + buffer->buf_size)) {
+		u16 min_sn = ieee80211_sn_less(sn, nssn) ? sn : nssn;
+
+		iwl_mvm_release_frames(mvm, sta, napi, buffer, min_sn);
+	}
+
+	/* drop any oudated packets */
+	if (ieee80211_sn_less(sn, buffer->head_sn))
+		goto drop;
+
+	/* release immediately if allowed by nssn and no stored frames */
+	if (!buffer->num_stored && ieee80211_sn_less(sn, nssn)) {
+		buffer->head_sn = nssn;
+		/* No need to update AMSDU last SN - we are moving the head */
+		return false;
+	}
+
+	index = sn % buffer->buf_size;
+
+	/*
+	 * Check if we already stored this frame
+	 * As AMSDU is either received or not as whole, logic is simple:
+	 * If we have frames in that position in the buffer and the last frame
+	 * originated from AMSDU had a different SN then it is a retransmission.
+	 * If it is the same SN then if the subframe index is incrementing it
+	 * is the same AMSDU - otherwise it is a retransmission.
+	 */
+	tail = skb_peek_tail(&buffer->entries[index]);
+	if (tail && !amsdu)
+		goto drop;
+	else if (tail && (sn != buffer->last_amsdu ||
+			  buffer->last_sub_index >= sub_frame_idx))
+		goto drop;
+
+	/* put in reorder buffer */
+	__skb_queue_tail(&buffer->entries[index], skb);
+	buffer->num_stored++;
+	if (amsdu) {
+		buffer->last_amsdu = sn;
+		buffer->last_sub_index = sub_frame_idx;
+	}
+
+	iwl_mvm_release_frames(mvm, sta, napi, buffer, nssn);
+	return true;
+
+drop:
+	kfree_skb(skb);
+	return true;
+}
+
 static void iwl_mvm_agg_rx_received(struct iwl_mvm *mvm, u8 baid)
 {
 	unsigned long now = jiffies;
@@ -638,7 +816,8 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	/* TODO: PHY info - gscan */
 
 	iwl_mvm_create_skb(skb, hdr, len, crypt_len, rxb);
-	iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, queue, sta);
+	if (!iwl_mvm_reorder(mvm, napi, queue, sta, skb, desc))
+		iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, queue, sta);
 	rcu_read_unlock();
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 4fb4c4e..2b83911 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1167,14 +1167,63 @@ int iwl_mvm_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 #define IWL_MAX_RX_BA_SESSIONS 16
 
-static void iwl_mvm_sync_rxq_del_ba(struct iwl_mvm *mvm)
+static void iwl_mvm_sync_rxq_del_ba(struct iwl_mvm *mvm, u8 baid)
 {
-	struct iwl_mvm_internal_rxq_notif data = {
-		.type = IWL_MVM_RXQ_EMPTY,
-		.sync = 1,
+	struct iwl_mvm_delba_notif notif = {
+		.metadata.type = IWL_MVM_RXQ_NOTIF_DEL_BA,
+		.metadata.sync = 1,
+		.delba.baid = baid,
 	};
+	iwl_mvm_sync_rx_queues_internal(mvm, (void *)&notif, sizeof(notif));
+};
+
+static void iwl_mvm_free_reorder(struct iwl_mvm *mvm,
+				 struct iwl_mvm_baid_data *data)
+{
+	int i;
+
+	iwl_mvm_sync_rxq_del_ba(mvm, data->baid);
+
+	for (i = 0; i < mvm->trans->num_rx_queues; i++) {
+		int j;
+		struct iwl_mvm_reorder_buffer *reorder_buf =
+			&data->reorder_buf[i];
 
-	iwl_mvm_sync_rx_queues_internal(mvm, &data, sizeof(data));
+		if (likely(!reorder_buf->num_stored))
+			continue;
+
+		/*
+		 * This shouldn't happen in regular DELBA since the internal
+		 * delBA notification should trigger a release of all frames in
+		 * the reorder buffer.
+		 */
+		WARN_ON(1);
+
+		for (j = 0; j < reorder_buf->buf_size; j++)
+			__skb_queue_purge(&reorder_buf->entries[j]);
+	}
+}
+
+static void iwl_mvm_init_reorder_buffer(struct iwl_mvm *mvm,
+					u32 sta_id,
+					struct iwl_mvm_baid_data *data,
+					u16 ssn, u8 buf_size)
+{
+	int i;
+
+	for (i = 0; i < mvm->trans->num_rx_queues; i++) {
+		struct iwl_mvm_reorder_buffer *reorder_buf =
+			&data->reorder_buf[i];
+		int j;
+
+		reorder_buf->num_stored = 0;
+		reorder_buf->head_sn = ssn;
+		reorder_buf->buf_size = buf_size;
+		reorder_buf->queue = i;
+		reorder_buf->sta_id = sta_id;
+		for (j = 0; j < reorder_buf->buf_size; j++)
+			__skb_queue_head_init(&reorder_buf->entries[j]);
+	}
 }
 
 int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
@@ -1198,7 +1247,10 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		 * Allocate here so if allocation fails we can bail out early
 		 * before starting the BA session in the firmware
 		 */
-		baid_data = kzalloc(sizeof(*baid_data), GFP_KERNEL);
+		baid_data = kzalloc(sizeof(*baid_data) +
+				    mvm->trans->num_rx_queues *
+				    sizeof(baid_data->reorder_buf[0]),
+				    GFP_KERNEL);
 		if (!baid_data)
 			return -ENOMEM;
 	}
@@ -1273,6 +1325,8 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			mod_timer(&baid_data->session_timer,
 				  TU_TO_EXP_TIME(timeout * 2));
 
+		iwl_mvm_init_reorder_buffer(mvm, mvm_sta->sta_id,
+					    baid_data, ssn, buf_size);
 		/*
 		 * protect the BA data with RCU to cover a case where our
 		 * internal RX sync mechanism will timeout (not that it's
@@ -1297,9 +1351,8 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			return -EINVAL;
 
 		/* synchronize all rx queues so we can safely delete */
-		iwl_mvm_sync_rxq_del_ba(mvm);
+		iwl_mvm_free_reorder(mvm, baid_data);
 		del_timer_sync(&baid_data->session_timer);
-
 		RCU_INIT_POINTER(mvm->baid_map[baid], NULL);
 		kfree_rcu(baid_data, rcu_head);
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 1226318..d2c58f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -348,6 +348,15 @@ struct iwl_mvm_key_pn {
 	} ____cacheline_aligned_in_smp q[];
 };
 
+struct iwl_mvm_delba_data {
+	u32 baid;
+} __packed;
+
+struct iwl_mvm_delba_notif {
+	struct iwl_mvm_internal_rxq_notif metadata;
+	struct iwl_mvm_delba_data delba;
+} __packed;
+
 /**
  * struct iwl_mvm_rxq_dup_data - per station per rx queue data
  * @last_seq: last sequence per tid for duplicate packet detection
-- 
2.8.1

