Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:34211 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbcCBH5J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:09 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/43] iwlwifi: mvm: add Tx A-MSDU inside A-MPDU
Date: Wed,  2 Mar 2016 09:56:16 +0200
Message-Id: <1456905404-14435-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085715_687219_43FCCC17)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the peer allows, we can have A-MSDU inside A-MDPU.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |  4 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h      |  5 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 37 +++++++++++++++++------
 4 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index f1ed90b..1a4946f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -847,6 +847,7 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 	u16 tid = params->tid;
 	u16 *ssn = &params->ssn;
 	u8 buf_size = params->buf_size;
+	bool amsdu = params->amsdu;
 
 	IWL_DEBUG_HT(mvm, "A-MPDU action on addr %pM tid %d: action %d\n",
 		     sta->addr, tid, action);
@@ -907,7 +908,8 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 		ret = iwl_mvm_sta_tx_agg_flush(mvm, vif, sta, tid);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		ret = iwl_mvm_sta_tx_agg_oper(mvm, vif, sta, tid, buf_size);
+		ret = iwl_mvm_sta_tx_agg_oper(mvm, vif, sta, tid,
+					      buf_size, amsdu);
 		break;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 4854e79..b2123ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1031,7 +1031,8 @@ release_locks:
 }
 
 int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			    struct ieee80211_sta *sta, u16 tid, u8 buf_size)
+			    struct ieee80211_sta *sta, u16 tid, u8 buf_size,
+			    bool amsdu)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
@@ -1051,6 +1052,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	tid_data->state = IWL_AGG_ON;
 	mvmsta->agg_tids |= BIT(tid);
 	tid_data->ssn = 0xffff;
+	tid_data->amsdu_in_ampdu_allowed = amsdu;
 	spin_unlock_bh(&mvmsta->lock);
 
 	fifo = iwl_mvm_ac_to_tx_fifo[tid_to_mac80211_ac[tid]];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index e3b9446..b01650a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -260,6 +260,7 @@ enum iwl_mvm_agg_state {
  *	Tx response (TX_CMD), and the block ack notification (COMPRESSED_BA).
  * @reduced_tpc: Reduced tx power. Holds the data between the
  *	Tx response (TX_CMD), and the block ack notification (COMPRESSED_BA).
+ * @amsdu_in_ampdu_allowed: true if A-MSDU in A-MPDU is allowed.
  * @state: state of the BA agreement establishment / tear down.
  * @txq_id: Tx queue used by the BA session
  * @ssn: the first packet to be sent in AGG HW queue in Tx AGG start flow, or
@@ -274,6 +275,7 @@ struct iwl_mvm_tid_data {
 	/* The rest is Tx AGG related */
 	u32 rate_n_flags;
 	u8 reduced_tpc;
+	bool amsdu_in_ampdu_allowed;
 	enum iwl_mvm_agg_state state;
 	u16 txq_id;
 	u16 ssn;
@@ -405,7 +407,8 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			struct ieee80211_sta *sta, u16 tid, u8 buf_size);
+			    struct ieee80211_sta *sta, u16 tid, u8 buf_size,
+			    bool amsdu);
 int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, u16 tid);
 int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 6f67de5..ff08b17 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -438,19 +438,26 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 			  struct ieee80211_sta *sta,
 			  struct sk_buff_head *mpdus_skb)
 {
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	unsigned int mss = skb_shinfo(skb)->gso_size;
 	struct sk_buff *tmp, *next;
 	char cb[sizeof(skb->cb)];
-	unsigned int num_subframes, tcp_payload_len, subf_len;
+	unsigned int num_subframes, tcp_payload_len, subf_len, max_amsdu_len;
 	bool ipv4 = (skb->protocol == htons(ETH_P_IP));
 	u16 ip_base_id = ipv4 ? ntohs(ip_hdr(skb)->id) : 0;
 	u16 amsdu_add, snap_ip_tcp, pad, i = 0;
+	u8 *qc, tid;
 
 	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
 		tcp_hdrlen(skb);
 
+	qc = ieee80211_get_qos_ctl(hdr);
+	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
+	if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
+		return -EINVAL;
+
 	if (!sta->max_amsdu_len ||
 	    !ieee80211_is_data_qos(hdr->frame_control)) {
 		num_subframes = 1;
@@ -458,13 +465,28 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 		goto segment;
 	}
 
-	/* TODO: for now, disable A-MSDU inside AMPDU */
-	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+	/*
+	 * No need to lock amsdu_in_ampdu_allowed since it can't be modified
+	 * during an BA session.
+	 */
+	if (info->flags & IEEE80211_TX_CTL_AMPDU &&
+	    !mvmsta->tid_data[tid].amsdu_in_ampdu_allowed) {
 		num_subframes = 1;
 		pad = 0;
 		goto segment;
 	}
 
+	max_amsdu_len = sta->max_amsdu_len;
+
+	/*
+	 * Limit A-MSDU in A-MPDU to 4095 bytes when VHT is not
+	 * supported. This is a spec requirement (IEEE 802.11-2015
+	 * section 8.7.3 NOTE 3).
+	 */
+	if (info->flags & IEEE80211_TX_CTL_AMPDU &&
+	    !sta->vht_cap.vht_supported)
+		max_amsdu_len = min_t(unsigned int, max_amsdu_len, 4095);
+
 	/* Sub frame header + SNAP + IP header + TCP header + MSS */
 	subf_len = sizeof(struct ethhdr) + snap_ip_tcp + mss;
 	pad = (4 - subf_len) & 0x3;
@@ -473,12 +495,9 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	 * If we have N subframes in the A-MSDU, then the A-MSDU's size is
 	 * N * subf_len + (N - 1) * pad.
 	 */
-	num_subframes = (sta->max_amsdu_len + pad) / (subf_len + pad);
-	if (num_subframes > 1) {
-		u8 *qc = ieee80211_get_qos_ctl((void *)skb->data);
-
+	num_subframes = (max_amsdu_len + pad) / (subf_len + pad);
+	if (num_subframes > 1)
 		*qc |= IEEE80211_QOS_CTL_A_MSDU_PRESENT;
-	}
 
 	tcp_payload_len = skb_tail_pointer(skb) - skb_transport_header(skb) -
 		tcp_hdrlen(skb) + skb->data_len;
@@ -555,7 +574,7 @@ segment:
 			info->driver_data[0] = (void *)(uintptr_t)amsdu_add;
 			skb_shinfo(tmp)->gso_size = mss;
 		} else {
-			u8 *qc = ieee80211_get_qos_ctl((void *)tmp->data);
+			qc = ieee80211_get_qos_ctl((void *)tmp->data);
 
 			if (ipv4)
 				ip_send_check(ip_hdr(tmp));
-- 
2.5.0

