Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39460 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754725AbeDMMni (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 08:43:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Apr 2018 15:42:48 +0300
Message-Id: <20180413124256.21769-18-luca@coelho.fi> (sfid-20180413_144342_340935_E4FB94ED)
In-Reply-To: <20180413124256.21769-1-luca@coelho.fi>
References: <20180413124256.21769-1-luca@coelho.fi>
Subject: [PATCH 17/25] iwlwifi: mvm: use the new get_tid function
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

This saves some typing and is overall more readable.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  7 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 11 ++++-------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index f9cd7575b422..34791628cfb3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -112,7 +112,7 @@ static inline int iwl_mvm_check_pn(struct iwl_mvm *mvm, struct sk_buff *skb,
 		return -1;
 
 	if (ieee80211_is_data_qos(hdr->frame_control))
-		tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
+		tid = ieee80211_get_tid(hdr);
 	else
 		tid = 0;
 
@@ -347,8 +347,7 @@ static bool iwl_mvm_is_dup(struct ieee80211_sta *sta, int queue,
 
 	if (ieee80211_is_data_qos(hdr->frame_control))
 		/* frame has qos control */
-		tid = *ieee80211_get_qos_ctl(hdr) &
-			IEEE80211_QOS_CTL_TID_MASK;
+		tid = ieee80211_get_tid(hdr);
 	else
 		tid = IWL_MAX_TID_COUNT;
 
@@ -628,7 +627,7 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 	bool amsdu = desc->mac_flags2 & IWL_RX_MPDU_MFLG2_AMSDU;
 	bool last_subframe =
 		desc->amsdu_info & IWL_RX_MPDU_AMSDU_LAST_SUBFRAME;
-	u8 tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
+	u8 tid = ieee80211_get_tid(hdr);
 	u8 sub_frame_idx = desc->amsdu_info &
 			   IWL_RX_MPDU_AMSDU_SUBFRAME_IDX_MASK;
 	struct iwl_mvm_reorder_buf_entry *entries;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 90381348697c..d0916f2552e2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -767,7 +767,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	u16 snap_ip_tcp, pad;
 	unsigned int dbg_max_amsdu_len;
 	netdev_features_t netdev_flags = NETIF_F_CSUM_MASK | NETIF_F_SG;
-	u8 *qc, tid, txf;
+	u8 tid, txf;
 
 	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
 		tcp_hdrlen(skb);
@@ -790,8 +790,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
 	}
 
-	qc = ieee80211_get_qos_ctl(hdr);
-	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
+	tid = ieee80211_get_tid(hdr);
 	if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
 		return -EINVAL;
 
@@ -846,7 +845,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	 */
 	num_subframes = (max_amsdu_len + pad) / (subf_len + pad);
 	if (num_subframes > 1)
-		*qc |= IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+		*ieee80211_get_qos_ctl(hdr) |= IEEE80211_QOS_CTL_A_MSDU_PRESENT;
 
 	tcp_payload_len = skb_tail_pointer(skb) - skb_transport_header(skb) -
 		tcp_hdrlen(skb) + skb->data_len;
@@ -1007,9 +1006,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	 * assignment of MGMT TID
 	 */
 	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc)) {
-		u8 *qc = NULL;
-		qc = ieee80211_get_qos_ctl(hdr);
-		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+		tid = ieee80211_get_tid(hdr);
 		if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
 			goto drop_unlock_sta;
 
-- 
2.16.3
