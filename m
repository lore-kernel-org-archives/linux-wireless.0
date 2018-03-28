Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36942 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752572AbeC1OMI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 10:12:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Mar 2018 17:11:46 +0300
Message-Id: <20180328141157.5427-4-luca@coelho.fi> (sfid-20180328_161218_538777_335BD997)
In-Reply-To: <20180328141157.5427-1-luca@coelho.fi>
References: <20180328141157.5427-1-luca@coelho.fi>
Subject: [PATCH 03/14] iwlwifi: mvm: move TSO segment to a separate function
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

This makes future bail-outs from transmitting an AMSDU more
readable.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 158 +++++++++++++++-------------
 1 file changed, 83 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 7dfe4cde55e3..795065974d78 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -687,6 +687,74 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 }
 
 #ifdef CONFIG_INET
+
+static int
+iwl_mvm_tx_tso_segment(struct sk_buff *skb, unsigned int num_subframes,
+		       netdev_features_t netdev_flags,
+		       struct sk_buff_head *mpdus_skb)
+{
+	struct sk_buff *tmp, *next;
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+	char cb[sizeof(skb->cb)];
+	u16 i = 0;
+	unsigned int tcp_payload_len;
+	unsigned int mss = skb_shinfo(skb)->gso_size;
+	bool ipv4 = (skb->protocol == htons(ETH_P_IP));
+	u16 ip_base_id = ipv4 ? ntohs(ip_hdr(skb)->id) : 0;
+
+	skb_shinfo(skb)->gso_size = num_subframes * mss;
+	memcpy(cb, skb->cb, sizeof(cb));
+
+	next = skb_gso_segment(skb, netdev_flags);
+	skb_shinfo(skb)->gso_size = mss;
+	if (WARN_ON_ONCE(IS_ERR(next)))
+		return -EINVAL;
+	else if (next)
+		consume_skb(skb);
+
+	while (next) {
+		tmp = next;
+		next = tmp->next;
+
+		memcpy(tmp->cb, cb, sizeof(tmp->cb));
+		/*
+		 * Compute the length of all the data added for the A-MSDU.
+		 * This will be used to compute the length to write in the TX
+		 * command. We have: SNAP + IP + TCP for n -1 subframes and
+		 * ETH header for n subframes.
+		 */
+		tcp_payload_len = skb_tail_pointer(tmp) -
+			skb_transport_header(tmp) -
+			tcp_hdrlen(tmp) + tmp->data_len;
+
+		if (ipv4)
+			ip_hdr(tmp)->id = htons(ip_base_id + i * num_subframes);
+
+		if (tcp_payload_len > mss) {
+			skb_shinfo(tmp)->gso_size = mss;
+		} else {
+			if (ieee80211_is_data_qos(hdr->frame_control)) {
+				u8 *qc;
+
+				if (ipv4)
+					ip_send_check(ip_hdr(tmp));
+
+				qc = ieee80211_get_qos_ctl((void *)tmp->data);
+				*qc &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+			}
+			skb_shinfo(tmp)->gso_size = 0;
+		}
+
+		tmp->prev = NULL;
+		tmp->next = NULL;
+
+		__skb_queue_tail(mpdus_skb, tmp);
+		i++;
+	}
+
+	return 0;
+}
+
 static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 			  struct ieee80211_tx_info *info,
 			  struct ieee80211_sta *sta,
@@ -695,14 +763,10 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	unsigned int mss = skb_shinfo(skb)->gso_size;
-	struct sk_buff *tmp, *next;
-	char cb[sizeof(skb->cb)];
 	unsigned int num_subframes, tcp_payload_len, subf_len, max_amsdu_len;
-	bool ipv4 = (skb->protocol == htons(ETH_P_IP));
-	u16 ip_base_id = ipv4 ? ntohs(ip_hdr(skb)->id) : 0;
-	u16 snap_ip_tcp, pad, i = 0;
+	u16 snap_ip_tcp, pad;
 	unsigned int dbg_max_amsdu_len;
-	netdev_features_t netdev_features = NETIF_F_CSUM_MASK | NETIF_F_SG;
+	netdev_features_t netdev_flags = NETIF_F_CSUM_MASK | NETIF_F_SG;
 	u8 *qc, tid, txf;
 
 	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
@@ -712,16 +776,8 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	if (!sta->max_amsdu_len ||
 	    !ieee80211_is_data_qos(hdr->frame_control) ||
-	    (!mvmsta->tlc_amsdu && !dbg_max_amsdu_len)) {
-		num_subframes = 1;
-		pad = 0;
-		goto segment;
-	}
-
-	qc = ieee80211_get_qos_ctl(hdr);
-	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
-	if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
-		return -EINVAL;
+	    (!mvmsta->tlc_amsdu && !dbg_max_amsdu_len))
+		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
 
 	/*
 	 * Do not build AMSDU for IPv6 with extension headers.
@@ -730,22 +786,22 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (skb->protocol == htons(ETH_P_IPV6) &&
 	    ((struct ipv6hdr *)skb_network_header(skb))->nexthdr !=
 	    IPPROTO_TCP) {
-		num_subframes = 1;
-		pad = 0;
-		netdev_features &= ~NETIF_F_CSUM_MASK;
-		goto segment;
+		netdev_flags &= ~NETIF_F_CSUM_MASK;
+		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
 	}
 
+	qc = ieee80211_get_qos_ctl(hdr);
+	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
+	if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
+		return -EINVAL;
+
 	/*
 	 * No need to lock amsdu_in_ampdu_allowed since it can't be modified
 	 * during an BA session.
 	 */
 	if (info->flags & IEEE80211_TX_CTL_AMPDU &&
-	    !mvmsta->tid_data[tid].amsdu_in_ampdu_allowed) {
-		num_subframes = 1;
-		pad = 0;
-		goto segment;
-	}
+	    !mvmsta->tid_data[tid].amsdu_in_ampdu_allowed)
+		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
 
 	max_amsdu_len = sta->max_amsdu_len;
 
@@ -811,56 +867,8 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	 * Trick the segmentation function to make it
 	 * create SKBs that can fit into one A-MSDU.
 	 */
-segment:
-	skb_shinfo(skb)->gso_size = num_subframes * mss;
-	memcpy(cb, skb->cb, sizeof(cb));
-
-	next = skb_gso_segment(skb, netdev_features);
-	skb_shinfo(skb)->gso_size = mss;
-	if (WARN_ON_ONCE(IS_ERR(next)))
-		return -EINVAL;
-	else if (next)
-		consume_skb(skb);
-
-	while (next) {
-		tmp = next;
-		next = tmp->next;
-
-		memcpy(tmp->cb, cb, sizeof(tmp->cb));
-		/*
-		 * Compute the length of all the data added for the A-MSDU.
-		 * This will be used to compute the length to write in the TX
-		 * command. We have: SNAP + IP + TCP for n -1 subframes and
-		 * ETH header for n subframes.
-		 */
-		tcp_payload_len = skb_tail_pointer(tmp) -
-			skb_transport_header(tmp) -
-			tcp_hdrlen(tmp) + tmp->data_len;
-
-		if (ipv4)
-			ip_hdr(tmp)->id = htons(ip_base_id + i * num_subframes);
-
-		if (tcp_payload_len > mss) {
-			skb_shinfo(tmp)->gso_size = mss;
-		} else {
-			if (ieee80211_is_data_qos(hdr->frame_control)) {
-				qc = ieee80211_get_qos_ctl((void *)tmp->data);
-
-				if (ipv4)
-					ip_send_check(ip_hdr(tmp));
-				*qc &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
-			}
-			skb_shinfo(tmp)->gso_size = 0;
-		}
-
-		tmp->prev = NULL;
-		tmp->next = NULL;
-
-		__skb_queue_tail(mpdus_skb, tmp);
-		i++;
-	}
-
-	return 0;
+	return iwl_mvm_tx_tso_segment(skb, num_subframes, netdev_flags,
+				      mpdus_skb);
 }
 #else /* CONFIG_INET */
 static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
-- 
2.16.2
