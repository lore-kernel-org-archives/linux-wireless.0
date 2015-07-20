Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:32482 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756780AbbGTTng (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 15:43:36 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: sara.sharon@intel.com,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 10/10] iwlwifi: don't send A-MSDU when not allowed by peer
Date: Mon, 20 Jul 2015 22:43:04 +0300
Message-Id: <1437421384-19884-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150720_214342_287459_02BF1CE1)
In-Reply-To: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A-MSDU is mandatory in the specification, but A-MSDU inside
A-MDPU is not. We need to ensure that the peer is able to
receive an A-MSDU inside an A-MPDU before sending it.
Add the relevant checks.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c      |  6 +++++-
 drivers/net/wireless/iwlwifi/mvm/sta.h      |  6 +++++-
 drivers/net/wireless/iwlwifi/mvm/tx.c       | 15 ++++++++++++---
 4 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 0334ad4..cacd7d0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -886,7 +886,7 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 		ret = iwl_mvm_sta_tx_agg_flush(mvm, vif, sta, tid);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		ret = iwl_mvm_sta_tx_agg_oper(mvm, vif, sta, tid, buf_size);
+		ret = iwl_mvm_sta_tx_agg_oper(mvm, vif, sta, tid, buf_size, amsdu);
 		break;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index f7d3921..4686be9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -976,7 +976,8 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 }
 
 int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			    struct ieee80211_sta *sta, u16 tid, u8 buf_size)
+			    struct ieee80211_sta *sta, u16 tid, u8 buf_size,
+			    bool amsdu)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
@@ -995,6 +996,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	queue = tid_data->txq_id;
 	tid_data->state = IWL_AGG_ON;
 	mvmsta->agg_tids |= BIT(tid);
+	tid_data->amsdu_in_ampdu_allowed = amsdu;
 	tid_data->ssn = 0xffff;
 	spin_unlock_bh(&mvmsta->lock);
 
@@ -1045,6 +1047,7 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	spin_lock_bh(&mvmsta->lock);
 
 	txq_id = tid_data->txq_id;
+	tid_data->amsdu_in_ampdu_allowed = false;
 
 	IWL_DEBUG_TX_QUEUES(mvm, "Stop AGG: sta %d tid %d q %d state %d\n",
 			    mvmsta->sta_id, tid, txq_id, tid_data->state);
@@ -1125,6 +1128,7 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	old_state = tid_data->state;
 	tid_data->state = IWL_AGG_OFF;
 	mvmsta->agg_tids &= ~BIT(tid);
+	tid_data->amsdu_in_ampdu_allowed = false;
 	spin_unlock_bh(&mvmsta->lock);
 
 	if (old_state >= IWL_AGG_ON) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index eedb215..26d1e31 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -258,6 +258,8 @@ enum iwl_mvm_agg_state {
  *	Tx response (TX_CMD), and the block ack notification (COMPRESSED_BA).
  * @reduced_tpc: Reduced tx power. Holds the data between the
  *	Tx response (TX_CMD), and the block ack notification (COMPRESSED_BA).
+ * @amsdu_in_ampdu_allowed: true if A-MSDU in A-MPDU is allowed. Relevant only
+ *	if &state is %IWL_AGG_ON.
  * @state: state of the BA agreement establishment / tear down.
  * @txq_id: Tx queue used by the BA session
  * @ssn: the first packet to be sent in AGG HW queue in Tx AGG start flow, or
@@ -272,6 +274,7 @@ struct iwl_mvm_tid_data {
 	/* The rest is Tx AGG related */
 	u32 rate_n_flags;
 	u8 reduced_tpc;
+	bool amsdu_in_ampdu_allowed;
 	enum iwl_mvm_agg_state state;
 	u16 txq_id;
 	u16 ssn;
@@ -387,7 +390,8 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			struct ieee80211_sta *sta, u16 tid, u8 buf_size);
+			    struct ieee80211_sta *sta, u16 tid, u8 buf_size,
+			    bool amsdu);
 int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, u16 tid);
 int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index cddc296..c23fd2e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -730,6 +730,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff* skb_gso,
 			  struct ieee80211_sta *sta,
 			  struct sk_buff_head *mpdus_skb)
 {
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb_gso);
 	struct ieee80211_key_conf *keyconf = info->control.hw_key;
 	struct ieee80211_hdr *wifi_hdr = (void *)skb_gso->data;
@@ -737,7 +738,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff* skb_gso,
 	struct iwl_lso_splitter s = {};
 	struct page *hdr_page;
 	unsigned int mpdu_sz;
-	u8 *hdr_page_pos;
+	u8 *hdr_page_pos, *qc, tid;
 	int i;
 
 	s.si = skb_shinfo(skb_gso);
@@ -879,11 +880,19 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff* skb_gso,
 	if (keyconf && keyconf->cipher == WLAN_CIPHER_SUITE_CCMP)
 		s.wifi_hdr_iv_len += IEEE80211_CCMP_HDR_LEN;
 
-	s.amsdu = true;
+	spin_lock(&mvmsta->lock);
+	qc = ieee80211_get_qos_ctl(s.hdr);
+	tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+	if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
+		return -1;
+
+	s.amsdu = !(info->flags & IEEE80211_TX_CTL_AMPDU) ||
+		mvmsta->tid_data[tid].amsdu_in_ampdu_allowed;
+	spin_unlock(&mvmsta->lock);
+
 	while (s.gso_payload_pos < s.gso_payload_len) {
 		struct sk_buff *skb = dev_alloc_skb(s.wifi_hdr_iv_len);
 		unsigned int ip_tcp_snap_hdrlen, amsdu_sz, max_amsdu_sz;
-		u8 *qc;
 
 		s.frag_in_mpdu = 0;
 
-- 
2.1.4

