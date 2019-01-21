Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A30C282E6
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB1152084A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbfAUHug (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:50:36 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:49028 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728295AbfAUHuf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 02:50:35 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1glULo-0006cr-NO; Mon, 21 Jan 2019 09:50:33 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon, 21 Jan 2019 09:50:11 +0200
Message-Id: <20190121075026.25059-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121075026.25059-1-luca@coelho.fi>
References: <20190121075026.25059-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 01/16] iwlwifi: mvm: support mac80211 AMSDU
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Support getting mac80211 building AMSDUs for us. Remove GSO
support from mvm - we don't need it anymore.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  34 +++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   3 +
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    |  14 ++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   |  14 ++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 229 +-----------------
 5 files changed, 68 insertions(+), 226 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 58bb92b0ef05..5c0816b81298 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -440,6 +440,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ieee80211_hw_set(hw, SUPPORTS_VHT_EXT_NSS_BW);
 	ieee80211_hw_set(hw, BUFF_MMPDU_TXQ);
 	ieee80211_hw_set(hw, STA_MMPDU_TXQ);
+	ieee80211_hw_set(hw, TX_AMSDU);
+	ieee80211_hw_set(hw, TX_FRAG_LIST);
 
 	if (iwl_mvm_has_tlc_offload(mvm)) {
 		ieee80211_hw_set(hw, TX_AMPDU_SETUP_IN_HW);
@@ -485,6 +487,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	hw->uapsd_queues = IWL_MVM_UAPSD_QUEUES;
 	hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
+	hw->max_tx_fragments = mvm->trans->max_skb_frags;
 
 	BUILD_BUG_ON(ARRAY_SIZE(mvm->ciphers) < ARRAY_SIZE(mvm_ciphers) + 6);
 	memcpy(mvm->ciphers, mvm_ciphers, sizeof(mvm_ciphers));
@@ -751,6 +754,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	}
 
 	hw->netdev_features |= mvm->cfg->features;
+	hw->netdev_features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
 	if (!iwl_mvm_is_csum_supported(mvm)) {
 		hw->netdev_features &= ~(IWL_TX_CSUM_NETIF_FLAGS |
 					 NETIF_F_RXCSUM);
@@ -3035,6 +3039,8 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 			iwl_mvm_tdls_check_trigger(mvm, vif, sta->addr,
 						   NL80211_TDLS_SETUP);
 		}
+
+		sta->max_rc_amsdu_len = 1;
 	} else if (old_state == IEEE80211_STA_NONE &&
 		   new_state == IEEE80211_STA_AUTH) {
 		/*
@@ -4724,6 +4730,33 @@ static void iwl_mvm_sync_rx_queues(struct ieee80211_hw *hw)
 	mutex_unlock(&mvm->mutex);
 }
 
+static bool iwl_mvm_can_hw_csum(struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_INET)
+	u8 protocol = ip_hdr(skb)->protocol;
+
+	return protocol == IPPROTO_TCP || protocol == IPPROTO_UDP;
+#else
+	return false;
+#endif
+}
+
+static bool iwl_mvm_mac_can_aggregate(struct ieee80211_hw *hw,
+				      struct sk_buff *head,
+				      struct sk_buff *skb)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	/* For now don't aggregate IPv6 in AMSDU */
+	if (skb->protocol != htons(ETH_P_IP))
+		return false;
+
+	if (!iwl_mvm_is_csum_supported(mvm))
+		return true;
+
+	return iwl_mvm_can_hw_csum(skb) == iwl_mvm_can_hw_csum(head);
+}
+
 const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.tx = iwl_mvm_mac_tx,
 	.wake_tx_queue = iwl_mvm_mac_wake_tx_queue,
@@ -4800,6 +4833,7 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 #endif
 	.get_survey = iwl_mvm_mac_get_survey,
 	.sta_statistics = iwl_mvm_mac_sta_statistics,
+	.can_aggregate_in_amsdu = iwl_mvm_mac_can_aggregate,
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	.sta_add_debugfs = iwl_mvm_sta_add_debugfs,
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 39ee3ace59b6..503e51d32e7f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1504,6 +1504,9 @@ void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
 			    struct ieee80211_tx_info *info,
 			    struct ieee80211_sta *sta, __le16 fc);
 void iwl_mvm_mac_itxq_xmit(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
+unsigned int iwl_mvm_max_amsdu_size(struct iwl_mvm *mvm,
+				    struct ieee80211_sta *sta,
+				    unsigned int tid);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 const char *iwl_mvm_get_tx_fail_reason(u32 status);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index a0ea0c160fd6..a28283ff7295 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -315,12 +315,26 @@ void iwl_mvm_tlc_update_notif(struct iwl_mvm *mvm,
 
 	if (flags & IWL_TLC_NOTIF_FLAG_AMSDU) {
 		u16 size = le32_to_cpu(notif->amsdu_size);
+		int i;
 
 		if (WARN_ON(sta->max_amsdu_len < size))
 			goto out;
 
 		mvmsta->amsdu_enabled = le32_to_cpu(notif->amsdu_enabled);
 		mvmsta->max_amsdu_len = size;
+		sta->max_rc_amsdu_len = mvmsta->max_amsdu_len;
+
+		for (i = 0; i < IWL_MAX_TID_COUNT; i++) {
+			if (mvmsta->amsdu_enabled & BIT(i))
+				sta->max_tid_amsdu_len[i] =
+					iwl_mvm_max_amsdu_size(mvm, sta, i);
+			else
+				/*
+				 * Not so elegant, but this will effectively
+				 * prevent AMSDU on this TID
+				 */
+				sta->max_tid_amsdu_len[i] = 1;
+		}
 
 		IWL_DEBUG_RATE(mvm,
 			       "AMSDU update. AMSDU size: %d, AMSDU selected size: %d, AMSDU TID bitmap 0x%X\n",
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 089972280daa..9b5682ce4b39 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -1744,6 +1744,7 @@ static void rs_set_amsdu_len(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			     enum rs_action scale_action)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	int i;
 
 	/*
 	 * In case TLC offload is not active amsdu_enabled is either 0xFFFF
@@ -1757,6 +1758,19 @@ static void rs_set_amsdu_len(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		mvmsta->amsdu_enabled = 0xFFFF;
 
 	mvmsta->max_amsdu_len = sta->max_amsdu_len;
+	sta->max_rc_amsdu_len = mvmsta->max_amsdu_len;
+
+	for (i = 0; i < IWL_MAX_TID_COUNT; i++) {
+		if (mvmsta->amsdu_enabled)
+			sta->max_tid_amsdu_len[i] =
+				iwl_mvm_max_amsdu_size(mvm, sta, i);
+		else
+			/*
+			 * Not so elegant, but this will effectively
+			 * prevent AMSDU on this TID
+			 */
+			sta->max_tid_amsdu_len[i] = 1;
+	}
 }
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index dfdfaa9ecfdb..2f2c355c13b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -779,78 +779,8 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	return 0;
 }
 
-#ifdef CONFIG_INET
-
-static int
-iwl_mvm_tx_tso_segment(struct sk_buff *skb, unsigned int num_subframes,
-		       netdev_features_t netdev_flags,
-		       struct sk_buff_head *mpdus_skb)
-{
-	struct sk_buff *tmp, *next;
-	struct ieee80211_hdr *hdr = (void *)skb->data;
-	char cb[sizeof(skb->cb)];
-	u16 i = 0;
-	unsigned int tcp_payload_len;
-	unsigned int mss = skb_shinfo(skb)->gso_size;
-	bool ipv4 = (skb->protocol == htons(ETH_P_IP));
-	u16 ip_base_id = ipv4 ? ntohs(ip_hdr(skb)->id) : 0;
-
-	skb_shinfo(skb)->gso_size = num_subframes * mss;
-	memcpy(cb, skb->cb, sizeof(cb));
-
-	next = skb_gso_segment(skb, netdev_flags);
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
-				u8 *qc;
-
-				if (ipv4)
-					ip_send_check(ip_hdr(tmp));
-
-				qc = ieee80211_get_qos_ctl((void *)tmp->data);
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
-}
-
-static unsigned int iwl_mvm_max_amsdu_size(struct iwl_mvm *mvm,
-					   struct ieee80211_sta *sta,
-					   unsigned int tid)
+unsigned int iwl_mvm_max_amsdu_size(struct iwl_mvm *mvm,
+				    struct ieee80211_sta *sta, unsigned int tid)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	enum nl80211_band band = mvmsta->vif->bss_conf.chandef.chan->band;
@@ -878,128 +808,6 @@ static unsigned int iwl_mvm_max_amsdu_size(struct iwl_mvm *mvm,
 		     mvm->fwrt.smem_cfg.lmac[lmac].txfifo_size[txf] - 256);
 }
 
-static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
-			  struct ieee80211_tx_info *info,
-			  struct ieee80211_sta *sta,
-			  struct sk_buff_head *mpdus_skb)
-{
-	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-	struct ieee80211_hdr *hdr = (void *)skb->data;
-	unsigned int mss = skb_shinfo(skb)->gso_size;
-	unsigned int num_subframes, tcp_payload_len, subf_len, max_amsdu_len;
-	u16 snap_ip_tcp, pad;
-	unsigned int dbg_max_amsdu_len;
-	netdev_features_t netdev_flags = NETIF_F_CSUM_MASK | NETIF_F_SG;
-	u8 tid;
-
-	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
-		tcp_hdrlen(skb);
-
-	dbg_max_amsdu_len = READ_ONCE(mvm->max_amsdu_len);
-
-	if (!mvmsta->max_amsdu_len ||
-	    !ieee80211_is_data_qos(hdr->frame_control) ||
-	    (!mvmsta->amsdu_enabled && !dbg_max_amsdu_len))
-		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
-
-	/*
-	 * Do not build AMSDU for IPv6 with extension headers.
-	 * ask stack to segment and checkum the generated MPDUs for us.
-	 */
-	if (skb->protocol == htons(ETH_P_IPV6) &&
-	    ((struct ipv6hdr *)skb_network_header(skb))->nexthdr !=
-	    IPPROTO_TCP) {
-		netdev_flags &= ~NETIF_F_CSUM_MASK;
-		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
-	}
-
-	tid = ieee80211_get_tid(hdr);
-	if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
-		return -EINVAL;
-
-	/*
-	 * No need to lock amsdu_in_ampdu_allowed since it can't be modified
-	 * during an BA session.
-	 */
-	if (info->flags & IEEE80211_TX_CTL_AMPDU &&
-	    !mvmsta->tid_data[tid].amsdu_in_ampdu_allowed)
-		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
-
-	if (iwl_mvm_vif_low_latency(iwl_mvm_vif_from_mac80211(mvmsta->vif)) ||
-	    !(mvmsta->amsdu_enabled & BIT(tid)))
-		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
-
-	max_amsdu_len = iwl_mvm_max_amsdu_size(mvm, sta, tid);
-
-	if (unlikely(dbg_max_amsdu_len))
-		max_amsdu_len = min_t(unsigned int, max_amsdu_len,
-				      dbg_max_amsdu_len);
-
-	/*
-	 * Limit A-MSDU in A-MPDU to 4095 bytes when VHT is not
-	 * supported. This is a spec requirement (IEEE 802.11-2015
-	 * section 8.7.3 NOTE 3).
-	 */
-	if (info->flags & IEEE80211_TX_CTL_AMPDU &&
-	    !sta->vht_cap.vht_supported)
-		max_amsdu_len = min_t(unsigned int, max_amsdu_len, 4095);
-
-	/* Sub frame header + SNAP + IP header + TCP header + MSS */
-	subf_len = sizeof(struct ethhdr) + snap_ip_tcp + mss;
-	pad = (4 - subf_len) & 0x3;
-
-	/*
-	 * If we have N subframes in the A-MSDU, then the A-MSDU's size is
-	 * N * subf_len + (N - 1) * pad.
-	 */
-	num_subframes = (max_amsdu_len + pad) / (subf_len + pad);
-
-	if (sta->max_amsdu_subframes &&
-	    num_subframes > sta->max_amsdu_subframes)
-		num_subframes = sta->max_amsdu_subframes;
-
-	tcp_payload_len = skb_tail_pointer(skb) - skb_transport_header(skb) -
-		tcp_hdrlen(skb) + skb->data_len;
-
-	/*
-	 * Make sure we have enough TBs for the A-MSDU:
-	 *	2 for each subframe
-	 *	1 more for each fragment
-	 *	1 more for the potential data in the header
-	 */
-	if ((num_subframes * 2 + skb_shinfo(skb)->nr_frags + 1) >
-	    mvm->trans->max_skb_frags)
-		num_subframes = 1;
-
-	if (num_subframes > 1)
-		*ieee80211_get_qos_ctl(hdr) |= IEEE80211_QOS_CTL_A_MSDU_PRESENT;
-
-	/* This skb fits in one single A-MSDU */
-	if (num_subframes * mss >= tcp_payload_len) {
-		__skb_queue_tail(mpdus_skb, skb);
-		return 0;
-	}
-
-	/*
-	 * Trick the segmentation function to make it
-	 * create SKBs that can fit into one A-MSDU.
-	 */
-	return iwl_mvm_tx_tso_segment(skb, num_subframes, netdev_flags,
-				      mpdus_skb);
-}
-#else /* CONFIG_INET */
-static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
-			  struct ieee80211_tx_info *info,
-			  struct ieee80211_sta *sta,
-			  struct sk_buff_head *mpdus_skb)
-{
-	/* Impossible to get TSO with CONFIG_INET */
-	WARN_ON(1);
-
-	return -1;
-}
-#endif
-
 /* Check if there are any timed-out TIDs on a given shared TXQ */
 static bool iwl_mvm_txq_should_update(struct iwl_mvm *mvm, int txq_id)
 {
@@ -1178,9 +986,6 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct ieee80211_tx_info info;
-	struct sk_buff_head mpdus_skbs;
-	unsigned int payload_len;
-	int ret;
 
 	if (WARN_ON_ONCE(!mvmsta))
 		return -1;
@@ -1190,35 +995,7 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	memcpy(&info, skb->cb, sizeof(info));
 
-	if (!skb_is_gso(skb))
-		return iwl_mvm_tx_mpdu(mvm, skb, &info, sta);
-
-	payload_len = skb_tail_pointer(skb) - skb_transport_header(skb) -
-		tcp_hdrlen(skb) + skb->data_len;
-
-	if (payload_len <= skb_shinfo(skb)->gso_size)
-		return iwl_mvm_tx_mpdu(mvm, skb, &info, sta);
-
-	__skb_queue_head_init(&mpdus_skbs);
-
-	ret = iwl_mvm_tx_tso(mvm, skb, &info, sta, &mpdus_skbs);
-	if (ret)
-		return ret;
-
-	if (WARN_ON(skb_queue_empty(&mpdus_skbs)))
-		return ret;
-
-	while (!skb_queue_empty(&mpdus_skbs)) {
-		skb = __skb_dequeue(&mpdus_skbs);
-
-		ret = iwl_mvm_tx_mpdu(mvm, skb, &info, sta);
-		if (ret) {
-			__skb_queue_purge(&mpdus_skbs);
-			return ret;
-		}
-	}
-
-	return 0;
+	return iwl_mvm_tx_mpdu(mvm, skb, &info, sta);
 }
 
 static void iwl_mvm_check_ratid_empty(struct iwl_mvm *mvm,
-- 
2.20.1

