Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:58220 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750997AbeBINMm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 08:12:42 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  9 Feb 2018 15:12:30 +0200
Message-Id: <20180209131234.8504-2-luca@coelho.fi> (sfid-20180209_141246_931462_5225EB4D)
In-Reply-To: <20180209131234.8504-1-luca@coelho.fi>
References: <20180209131234.8504-1-luca@coelho.fi>
Subject: [PATCH 1/5] iwlwifi: mvm: fix security bug in PN checking
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

A previous patch allowed the same PN for packets originating from the
same AMSDU by copying PN only for the last packet in the series.

This however is bogus since we cannot assume the last frame will be
received on the same queue, and if it is received on a different ueue
we will end up not incrementing the PN and possibly let the next
packet to have the same PN and pass through.

Change the logic instead to driver explicitly indicate for the second
sub frame and on to be allowed to have the same PN as the first
subframe. Indicate it to mac80211 as well for the fallback queue.

Fixes: f1ae02b186d9 ("iwlwifi: mvm: allow same PN for de-aggregated AMSDU")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 39 ++++++++++++++-------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index a3f7c1bf3cc8..580de5851fc7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -71,6 +71,7 @@ static inline int iwl_mvm_check_pn(struct iwl_mvm *mvm, struct sk_buff *skb,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_rx_status *stats = IEEE80211_SKB_RXCB(skb);
 	struct iwl_mvm_key_pn *ptk_pn;
+	int res;
 	u8 tid, keyidx;
 	u8 pn[IEEE80211_CCMP_PN_LEN];
 	u8 *extiv;
@@ -127,12 +128,13 @@ static inline int iwl_mvm_check_pn(struct iwl_mvm *mvm, struct sk_buff *skb,
 	pn[4] = extiv[1];
 	pn[5] = extiv[0];
 
-	if (memcmp(pn, ptk_pn->q[queue].pn[tid],
-		   IEEE80211_CCMP_PN_LEN) <= 0)
+	res = memcmp(pn, ptk_pn->q[queue].pn[tid], IEEE80211_CCMP_PN_LEN);
+	if (res < 0)
+		return -1;
+	if (!res && !(stats->flag & RX_FLAG_ALLOW_SAME_PN))
 		return -1;
 
-	if (!(stats->flag & RX_FLAG_AMSDU_MORE))
-		memcpy(ptk_pn->q[queue].pn[tid], pn, IEEE80211_CCMP_PN_LEN);
+	memcpy(ptk_pn->q[queue].pn[tid], pn, IEEE80211_CCMP_PN_LEN);
 	stats->flag |= RX_FLAG_PN_VALIDATED;
 
 	return 0;
@@ -314,28 +316,21 @@ static void iwl_mvm_rx_csum(struct ieee80211_sta *sta,
 }
 
 /*
- * returns true if a packet outside BA session is a duplicate and
- * should be dropped
+ * returns true if a packet is a duplicate and should be dropped.
+ * Updates AMSDU PN tracking info
  */
-static bool iwl_mvm_is_nonagg_dup(struct ieee80211_sta *sta, int queue,
-				  struct ieee80211_rx_status *rx_status,
-				  struct ieee80211_hdr *hdr,
-				  struct iwl_rx_mpdu_desc *desc)
+static bool iwl_mvm_is_dup(struct ieee80211_sta *sta, int queue,
+			   struct ieee80211_rx_status *rx_status,
+			   struct ieee80211_hdr *hdr,
+			   struct iwl_rx_mpdu_desc *desc)
 {
 	struct iwl_mvm_sta *mvm_sta;
 	struct iwl_mvm_rxq_dup_data *dup_data;
-	u8 baid, tid, sub_frame_idx;
+	u8 tid, sub_frame_idx;
 
 	if (WARN_ON(IS_ERR_OR_NULL(sta)))
 		return false;
 
-	baid = (le32_to_cpu(desc->reorder_data) &
-		IWL_RX_MPDU_REORDER_BAID_MASK) >>
-		IWL_RX_MPDU_REORDER_BAID_SHIFT;
-
-	if (baid != IWL_RX_REORDER_DATA_INVALID_BAID)
-		return false;
-
 	mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	dup_data = &mvm_sta->dup_data[queue];
 
@@ -365,6 +360,12 @@ static bool iwl_mvm_is_nonagg_dup(struct ieee80211_sta *sta, int queue,
 		     dup_data->last_sub_frame[tid] >= sub_frame_idx))
 		return true;
 
+	/* Allow same PN as the first subframe for following sub frames */
+	if (dup_data->last_seq[tid] == hdr->seq_ctrl &&
+	    sub_frame_idx > dup_data->last_sub_frame[tid] &&
+	    desc->mac_flags2 & IWL_RX_MPDU_MFLG2_AMSDU)
+		rx_status->flag |= RX_FLAG_ALLOW_SAME_PN;
+
 	dup_data->last_seq[tid] = hdr->seq_ctrl;
 	dup_data->last_sub_frame[tid] = sub_frame_idx;
 
@@ -971,7 +972,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		if (ieee80211_is_data(hdr->frame_control))
 			iwl_mvm_rx_csum(sta, skb, desc);
 
-		if (iwl_mvm_is_nonagg_dup(sta, queue, rx_status, hdr, desc)) {
+		if (iwl_mvm_is_dup(sta, queue, rx_status, hdr, desc)) {
 			kfree_skb(skb);
 			goto out;
 		}
-- 
2.15.1
