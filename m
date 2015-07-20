Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:32482 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbbGTTna (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 15:43:30 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: sara.sharon@intel.com,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 08/10] iwlwifi: mvm: add support for A-MSDU Tx
Date: Mon, 20 Jul 2015 22:43:02 +0300
Message-Id: <1437421384-19884-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150720_214344_984182_4D94522F)
In-Reply-To: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that LSO is working, we can have a big buffer at once
in the driver. Allow to build an A-MSDU out of all this
data. Using A-MSDU will allow better throughput.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   1 +
 drivers/net/wireless/iwlwifi/mvm/tx.c       | 105 +++++++++++++++++++++++++---
 2 files changed, 98 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index def314e..0334ad4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -435,6 +435,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ieee80211_hw_set(hw, CONNECTION_MONITOR);
 	ieee80211_hw_set(hw, CHANCTX_STA_CSA);
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
+	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
 
 	if (IWL_MVM_SW_CSUM_OFFLOAD)
 		hw->netdev_features |= NETIF_F_IP_CSUM | NETIF_F_TSO |
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 27b8491..3f89d71 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -476,8 +476,10 @@ static void iwl_update_ip_tcph(void *iph, struct tcphdr *tcph, bool ipv6,
  * @ieee80211_hdr *hdr: Points to the WiFi header.
  * @gso_nr_frags: The number of frags in the original GSO skb.
  * @wifi_hdr_iv_len: The length of the WiFi header including IV.
+ * @amsdu_pad: Number of bytes for the A-MSDU subframe
  * @tcp_fin: True if TCP_FIN is set in the original GSO skb.
  * @tcp_push: True if TCP_PSH is set in the original GSO skb.
+ * @amsdu: True if we are building an A-MSDU
  */
 struct iwl_lso_splitter {
 	unsigned int linear_payload_len;
@@ -493,8 +495,10 @@ struct iwl_lso_splitter {
 	struct ieee80211_hdr *hdr;
 	u8 gso_nr_frags;
 	u8 wifi_hdr_iv_len;
+	u8 amsdu_pad;
 	bool tcp_fin;
 	bool tcp_push;
+	bool amsdu;
 };
 
 /*
@@ -616,9 +620,10 @@ static int iwl_add_msdu(struct iwl_mvm *mvm, struct sk_buff *skb_gso,
 			struct iwl_lso_splitter *p)
 {
 
-	unsigned int tcp_seg_sz, snap_ip_tcp_len, copy_sz = 0;
+	unsigned int tcp_seg_sz, snap_ip_tcp_len, subframe_sz, copy_sz = 0;
 	bool ipv6 = p->si->gso_type & SKB_GSO_TCPV6;
 	u8 *start_hdr = *hdr_page_pos;
+	__be16 *length = NULL;
 	struct tcphdr *tcph;
 	struct iphdr *iph;
 
@@ -626,10 +631,32 @@ static int iwl_add_msdu(struct iwl_mvm *mvm, struct sk_buff *skb_gso,
 		8 + skb_network_header_len(skb_gso) + tcp_hdrlen(skb_gso);
 	copy_sz = min_t(unsigned int, p->linear_payload_len, p->mss);
 
-	*hdr_page_pos = get_page_pos(hdr_page, *hdr_page_pos, snap_ip_tcp_len + copy_sz);
+	*hdr_page_pos =
+		get_page_pos(hdr_page, *hdr_page_pos,
+			     snap_ip_tcp_len + copy_sz +
+			     sizeof(struct ethhdr) + 4);
 	if (!*hdr_page_pos)
 		return -1;
 
+	subframe_sz = snap_ip_tcp_len;
+
+	if (p->amsdu) {
+		memset(*hdr_page_pos, 0, p->amsdu_pad);
+		*hdr_page_pos += p->amsdu_pad;
+
+		/* TODO: AP MODE */
+
+		memcpy(*hdr_page_pos, p->hdr->addr3, ETH_ALEN);
+		*hdr_page_pos += ETH_ALEN;
+
+		memcpy(*hdr_page_pos, p->hdr->addr2, ETH_ALEN);
+		*hdr_page_pos += ETH_ALEN;
+
+		length = (void *)*hdr_page_pos;
+		*hdr_page_pos += sizeof(*length);
+		subframe_sz += sizeof(struct ethhdr);
+	}
+
 	/*
 	 * Copy SNAP / IP / TCP headers from the original GSO skb to the
 	 * header page.
@@ -671,6 +698,11 @@ static int iwl_add_msdu(struct iwl_mvm *mvm, struct sk_buff *skb_gso,
 
 	/* .. and now add the payload coming from the frags. */
 	tcp_seg_sz = iwl_add_tcp_segment(mvm, skb_gso, skb, p, copy_sz);
+	subframe_sz += tcp_seg_sz;
+	p->amsdu_pad = (4 - (subframe_sz)) & 0x3;
+
+	if (length)
+		*length = cpu_to_be16(subframe_sz - sizeof(struct ethhdr));
 
 	iwl_update_ip_tcph(iph, tcph, ipv6, tcp_seg_sz,
 			   p->gso_payload_pos - tcp_seg_sz, ip_id);
@@ -691,7 +723,7 @@ static int iwl_add_msdu(struct iwl_mvm *mvm, struct sk_buff *skb_gso,
 						tcp_seg_sz, tcp_hdrlen(skb_gso));
 	skb->ip_summed = CHECKSUM_COMPLETE;
 
-	return 0;
+	return subframe_sz;
 }
 
 static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff* skb_gso,
@@ -847,9 +879,12 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff* skb_gso,
 	if (keyconf && keyconf->cipher == WLAN_CIPHER_SUITE_CCMP)
 		s.wifi_hdr_iv_len += IEEE80211_CCMP_HDR_LEN;
 
+	s.amsdu = true;
 	while (s.gso_payload_pos < s.gso_payload_len) {
 		struct sk_buff *skb = dev_alloc_skb(s.wifi_hdr_iv_len);
-		int ret;
+		unsigned int ip_tcp_snap_hdrlen, amsdu_sz, max_amsdu_sz;
+		u8 *qc;
+
 		s.frag_in_mpdu = 0;
 
 		if (WARN_ON(s.gso_frag_num >= s.gso_nr_frags))
@@ -864,11 +899,65 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff* skb_gso,
 		memcpy(skb_put(skb, s.wifi_hdr_iv_len),
 		       wifi_hdr, s.wifi_hdr_iv_len);
 
-		ret = iwl_add_msdu(mvm, skb_gso, skb, &hdr_page,
-				   &hdr_page_pos, i++, &s);
-		if (ret < 0) {
-			skb_queue_purge(mpdus_skb);
+		/* No need to have an AMSDU if we have at most mss bytes */
+		if (s.gso_payload_len - s.gso_payload_pos <= s.mss)
+			s.amsdu = false;
+
+		max_amsdu_sz = sta->max_amsdu_sz;
+
+		if (!max_amsdu_sz || !s.amsdu) {
+			int l;
+
+			s.amsdu = false;
+			l = iwl_add_msdu(mvm, skb_gso, skb, &hdr_page,
+					 &hdr_page_pos, i++, &s);
+			if (l < 0) {
+				skb_queue_purge(mpdus_skb);
+				goto err;
+			}
+
+			__skb_queue_tail(mpdus_skb, skb);
+			continue;
+		}
+
+		if (WARN_ON_ONCE(max_amsdu_sz < s.mss))
 			goto err;
+
+		qc = ieee80211_get_qos_ctl((void *)skb->data);
+		*qc |= IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+
+		amsdu_sz = 0;
+		s.amsdu_pad = 0;
+		ip_tcp_snap_hdrlen =
+			8 + ip_hdrlen(skb_gso) + tcp_hdrlen(skb_gso);
+
+		i = 0;
+
+		/*
+		 * Make sure we have enough room for
+		 * ethernet header, SNAP header, IP header, TCP header and MSS.
+		 * Make sure we don't add more MSDUs than allowed
+		 */
+		while (amsdu_sz + sizeof(struct ethhdr) + s.mss +
+		       ip_tcp_snap_hdrlen < max_amsdu_sz &&
+		       (!sta->max_msdus || i < sta->max_msdus) &&
+		       s.gso_payload_pos < s.gso_payload_len) {
+			unsigned int l;
+
+
+			if (s.frag_in_mpdu >= mvm->trans->max_skb_frags - 1) {
+				IWL_ERR(mvm, "2 frags need for each MSDU\n");
+				break;
+			}
+
+			l = iwl_add_msdu(mvm, skb_gso, skb, &hdr_page,
+					 &hdr_page_pos, i++, &s);
+			if (l < 0) {
+				skb_queue_purge(mpdus_skb);
+				goto err;
+			}
+
+			amsdu_sz += l;
 		}
 
 		__skb_queue_tail(mpdus_skb, skb);
-- 
2.1.4

