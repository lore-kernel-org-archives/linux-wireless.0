Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6272C282E6
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 870AD20989
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbfAUHuk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:50:40 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:49062 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728295AbfAUHuj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 02:50:39 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1glULs-0006cr-4n; Mon, 21 Jan 2019 09:50:36 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon, 21 Jan 2019 09:50:15 +0200
Message-Id: <20190121075026.25059-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121075026.25059-1-luca@coelho.fi>
References: <20190121075026.25059-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/16] iwlwifi: mvm: bring back mvm GSO code
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

We have a slightly better TCP performance with GSO.
Add it back, it can co-exist with the code that builds
AMSDUs in mac80211.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |   1 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 224 +++++++++++++++++-
 2 files changed, 223 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5c0816b81298..9a4fef834941 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -754,7 +754,6 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	}
 
 	hw->netdev_features |= mvm->cfg->features;
-	hw->netdev_features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
 	if (!iwl_mvm_is_csum_supported(mvm)) {
 		hw->netdev_features &= ~(IWL_TX_CSUM_NETIF_FLAGS |
 					 NETIF_F_RXCSUM);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 2f2c355c13b0..da8b69c9468c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -808,6 +808,197 @@ unsigned int iwl_mvm_max_amsdu_size(struct iwl_mvm *mvm,
 		     mvm->fwrt.smem_cfg.lmac[lmac].txfifo_size[txf] - 256);
 }
 
+#ifdef CONFIG_INET
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
+static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
+			  struct ieee80211_tx_info *info,
+			  struct ieee80211_sta *sta,
+			  struct sk_buff_head *mpdus_skb)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+	unsigned int mss = skb_shinfo(skb)->gso_size;
+	unsigned int num_subframes, tcp_payload_len, subf_len, max_amsdu_len;
+	u16 snap_ip_tcp, pad;
+	unsigned int dbg_max_amsdu_len;
+	netdev_features_t netdev_flags = NETIF_F_CSUM_MASK | NETIF_F_SG;
+	u8 tid;
+
+	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
+		tcp_hdrlen(skb);
+
+	dbg_max_amsdu_len = READ_ONCE(mvm->max_amsdu_len);
+
+	if (!mvmsta->max_amsdu_len ||
+	    !ieee80211_is_data_qos(hdr->frame_control) ||
+	    (!mvmsta->amsdu_enabled && !dbg_max_amsdu_len))
+		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
+
+	/*
+	 * Do not build AMSDU for IPv6 with extension headers.
+	 * ask stack to segment and checkum the generated MPDUs for us.
+	 */
+	if (skb->protocol == htons(ETH_P_IPV6) &&
+	    ((struct ipv6hdr *)skb_network_header(skb))->nexthdr !=
+	    IPPROTO_TCP) {
+		netdev_flags &= ~NETIF_F_CSUM_MASK;
+		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
+	}
+
+	tid = ieee80211_get_tid(hdr);
+	if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
+		return -EINVAL;
+
+	/*
+	 * No need to lock amsdu_in_ampdu_allowed since it can't be modified
+	 * during an BA session.
+	 */
+	if (info->flags & IEEE80211_TX_CTL_AMPDU &&
+	    !mvmsta->tid_data[tid].amsdu_in_ampdu_allowed)
+		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
+
+	if (iwl_mvm_vif_low_latency(iwl_mvm_vif_from_mac80211(mvmsta->vif)) ||
+	    !(mvmsta->amsdu_enabled & BIT(tid)))
+		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
+
+	max_amsdu_len = iwl_mvm_max_amsdu_size(mvm, sta, tid);
+
+	if (unlikely(dbg_max_amsdu_len))
+		max_amsdu_len = min_t(unsigned int, max_amsdu_len,
+				      dbg_max_amsdu_len);
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
+	/* Sub frame header + SNAP + IP header + TCP header + MSS */
+	subf_len = sizeof(struct ethhdr) + snap_ip_tcp + mss;
+	pad = (4 - subf_len) & 0x3;
+
+	/*
+	 * If we have N subframes in the A-MSDU, then the A-MSDU's size is
+	 * N * subf_len + (N - 1) * pad.
+	 */
+	num_subframes = (max_amsdu_len + pad) / (subf_len + pad);
+
+	if (sta->max_amsdu_subframes &&
+	    num_subframes > sta->max_amsdu_subframes)
+		num_subframes = sta->max_amsdu_subframes;
+
+	tcp_payload_len = skb_tail_pointer(skb) - skb_transport_header(skb) -
+		tcp_hdrlen(skb) + skb->data_len;
+
+	/*
+	 * Make sure we have enough TBs for the A-MSDU:
+	 *	2 for each subframe
+	 *	1 more for each fragment
+	 *	1 more for the potential data in the header
+	 */
+	if ((num_subframes * 2 + skb_shinfo(skb)->nr_frags + 1) >
+	    mvm->trans->max_skb_frags)
+		num_subframes = 1;
+
+	if (num_subframes > 1)
+		*ieee80211_get_qos_ctl(hdr) |= IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+
+	/* This skb fits in one single A-MSDU */
+	if (num_subframes * mss >= tcp_payload_len) {
+		__skb_queue_tail(mpdus_skb, skb);
+		return 0;
+	}
+
+	/*
+	 * Trick the segmentation function to make it
+	 * create SKBs that can fit into one A-MSDU.
+	 */
+	return iwl_mvm_tx_tso_segment(skb, num_subframes, netdev_flags,
+				      mpdus_skb);
+}
+#else /* CONFIG_INET */
+static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
+			  struct ieee80211_tx_info *info,
+			  struct ieee80211_sta *sta,
+			  struct sk_buff_head *mpdus_skb)
+{
+	/* Impossible to get TSO with CONFIG_INET */
+	WARN_ON(1);
+
+	return -1;
+}
+#endif
+
 /* Check if there are any timed-out TIDs on a given shared TXQ */
 static bool iwl_mvm_txq_should_update(struct iwl_mvm *mvm, int txq_id)
 {
@@ -986,6 +1177,9 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct ieee80211_tx_info info;
+	struct sk_buff_head mpdus_skbs;
+	unsigned int payload_len;
+	int ret;
 
 	if (WARN_ON_ONCE(!mvmsta))
 		return -1;
@@ -995,7 +1189,35 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	memcpy(&info, skb->cb, sizeof(info));
 
-	return iwl_mvm_tx_mpdu(mvm, skb, &info, sta);
+	if (!skb_is_gso(skb))
+		return iwl_mvm_tx_mpdu(mvm, skb, &info, sta);
+
+	payload_len = skb_tail_pointer(skb) - skb_transport_header(skb) -
+		tcp_hdrlen(skb) + skb->data_len;
+
+	if (payload_len <= skb_shinfo(skb)->gso_size)
+		return iwl_mvm_tx_mpdu(mvm, skb, &info, sta);
+
+	__skb_queue_head_init(&mpdus_skbs);
+
+	ret = iwl_mvm_tx_tso(mvm, skb, &info, sta, &mpdus_skbs);
+	if (ret)
+		return ret;
+
+	if (WARN_ON(skb_queue_empty(&mpdus_skbs)))
+		return ret;
+
+	while (!skb_queue_empty(&mpdus_skbs)) {
+		skb = __skb_dequeue(&mpdus_skbs);
+
+		ret = iwl_mvm_tx_mpdu(mvm, skb, &info, sta);
+		if (ret) {
+			__skb_queue_purge(&mpdus_skbs);
+			return ret;
+		}
+	}
+
+	return 0;
 }
 
 static void iwl_mvm_check_ratid_empty(struct iwl_mvm *mvm,
-- 
2.20.1

