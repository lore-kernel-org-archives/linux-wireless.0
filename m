Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:11234 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbcCBH5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:41 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/43] iwlwifi: mvm: add duplicate packet detection per rx queue
Date: Wed,  2 Mar 2016 09:56:26 +0200
Message-Id: <1456905404-14435-25-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085951_103294_CE6097C6)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Next hardware will direct TCP/UDP streams to different cores.
Packets belonging to the same stream will be directed to the same
core.
The result is that duplicates will be always directed to the same
rx queue were the first packet was received.
This enabled parallelizing the duplicate packet detection across
the different cores, without sharing data between the rx queues.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 66 +++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 14 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h  | 13 +++++-
 3 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index a9180b0..d891942 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -285,6 +285,66 @@ static void iwl_mvm_rx_csum(struct ieee80211_sta *sta,
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 }
 
+/*
+ * returns true if a packet outside BA session is a duplicate and
+ * should be dropped
+ */
+static bool iwl_mvm_is_nonagg_dup(struct ieee80211_sta *sta, int queue,
+				  struct ieee80211_rx_status *rx_status,
+				  struct ieee80211_hdr *hdr,
+				  struct iwl_rx_mpdu_desc *desc)
+{
+	struct iwl_mvm_sta *mvm_sta;
+	struct iwl_mvm_rxq_dup_data *dup_data;
+	u8 baid, tid, sub_frame_idx;
+
+	if (WARN_ON(IS_ERR_OR_NULL(sta)))
+		return false;
+
+	baid = (le32_to_cpu(desc->reorder_data) &
+		IWL_RX_MPDU_REORDER_BAID_MASK) >>
+		IWL_RX_MPDU_REORDER_BAID_SHIFT;
+
+	if (baid != IWL_RX_REORDER_DATA_INVALID_BAID)
+		return false;
+
+	mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+	dup_data = &mvm_sta->dup_data[queue];
+
+	/*
+	 * Drop duplicate 802.11 retransmissions
+	 * (IEEE 802.11-2012: 9.3.2.10 "Duplicate detection and recovery")
+	 */
+	if (ieee80211_is_ctl(hdr->frame_control) ||
+	    ieee80211_is_qos_nullfunc(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1)) {
+		rx_status->flag |= RX_FLAG_DUP_VALIDATED;
+		return false;
+	}
+
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		/* frame has qos control */
+		tid = *ieee80211_get_qos_ctl(hdr) &
+			IEEE80211_QOS_CTL_TID_MASK;
+	else
+		tid = IWL_MAX_TID_COUNT;
+
+	/* If this wasn't a part of an A-MSDU the sub-frame index will be 0 */
+	sub_frame_idx = desc->amsdu_info & IWL_RX_MPDU_AMSDU_SUBFRAME_IDX_MASK;
+
+	if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
+		     dup_data->last_seq[tid] == hdr->seq_ctrl &&
+		     dup_data->last_sub_frame[tid] >= sub_frame_idx))
+		return true;
+
+	dup_data->last_seq[tid] = hdr->seq_ctrl;
+	dup_data->last_sub_frame[tid] = sub_frame_idx;
+
+	rx_status->flag |= RX_FLAG_DUP_VALIDATED;
+
+	return false;
+}
+
 void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			struct iwl_rx_cmd_buffer *rxb, int queue)
 {
@@ -389,6 +449,12 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 		if (ieee80211_is_data(hdr->frame_control))
 			iwl_mvm_rx_csum(sta, skb, desc);
+
+		if (iwl_mvm_is_nonagg_dup(sta, queue, rx_status, hdr, desc)) {
+			kfree_skb(skb);
+			rcu_read_unlock();
+			return;
+		}
 	}
 
 	/*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index b2123ce..4717b18 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -280,6 +280,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_mvm_rxq_dup_data *dup_data;
 	int i, ret, sta_id;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -327,6 +328,16 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	}
 	mvm_sta->agg_tids = 0;
 
+	if (iwl_mvm_has_new_rx_api(mvm) &&
+	    !test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
+		dup_data = kcalloc(mvm->trans->num_rx_queues,
+				   sizeof(*dup_data),
+				   GFP_KERNEL);
+		if (!dup_data)
+			return -ENOMEM;
+		mvm_sta->dup_data = dup_data;
+	}
+
 	ret = iwl_mvm_sta_send_to_fw(mvm, sta, false);
 	if (ret)
 		goto err;
@@ -508,6 +519,9 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (iwl_mvm_has_new_rx_api(mvm))
+		kfree(mvm_sta->dup_data);
+
 	if (vif->type == NL80211_IFTYPE_STATION &&
 	    mvmvif->ap_sta_id == mvm_sta->sta_id) {
 		ret = iwl_mvm_drain_sta(mvm, mvm_sta, true);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index f95f603..db701ca 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -296,6 +296,16 @@ struct iwl_mvm_key_pn {
 };
 
 /**
+ * struct iwl_mvm_rxq_dup_data - per station per rx queue data
+ * @last_seq: last sequence per tid for duplicate packet detection
+ * @last_sub_frame: last subframe packet
+ */
+struct iwl_mvm_rxq_dup_data {
+	__le16 last_seq[IWL_MAX_TID_COUNT + 1];
+	u8 last_sub_frame[IWL_MAX_TID_COUNT + 1];
+} ____cacheline_aligned_in_smp;
+
+/**
  * struct iwl_mvm_sta - representation of a station in the driver
  * @sta_id: the index of the station in the fw (will be replaced by id_n_color)
  * @tfd_queue_msk: the tfd queues used by the station
@@ -321,6 +331,7 @@ struct iwl_mvm_key_pn {
  *	we are sending frames from an AMPDU queue and there was a hole in
  *	the BA window. To be used for UAPSD only.
  * @ptk_pn: per-queue PTK PN data structures
+ * @dup_data: per queue duplicate packet detection data
  *
  * When mac80211 creates a station it reserves some space (hw->sta_data_size)
  * in the structure for use by driver. This structure is placed in that
@@ -340,8 +351,8 @@ struct iwl_mvm_sta {
 	struct iwl_mvm_tid_data tid_data[IWL_MAX_TID_COUNT];
 	struct iwl_lq_sta lq_sta;
 	struct ieee80211_vif *vif;
-
 	struct iwl_mvm_key_pn __rcu *ptk_pn[4];
+	struct iwl_mvm_rxq_dup_data *dup_data;
 
 	/* Temporary, until the new TLC will control the Tx protection */
 	s8 tx_protection;
-- 
2.5.0

