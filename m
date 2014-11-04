Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:52229 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaKDOe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 09:34:27 -0500
Received: by mail-la0-f41.google.com with SMTP id s18so996055lam.28
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 06:34:25 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/7] ath10k: unify rx undecapping
Date: Tue,  4 Nov 2014 15:22:08 +0100
Message-Id: <1415110931-10945-5-git-send-email-michal.kazior@tieto.com> (sfid-20141104_153439_780538_B745BAF5)
In-Reply-To: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
References: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This creates a single, common path for MSDU,
A-MSDU and fragmented Rx.

Hopefully this will make it easier to understand
Rx path and make it easier to work with.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 738 +++++++++++++++++--------------
 1 file changed, 412 insertions(+), 326 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 651028e..6abfea7 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -603,35 +603,6 @@ static int ath10k_htt_rx_crypto_tail_len(struct ath10k *ar,
 	return 0;
 }
 
-/* Applies for first msdu in chain, before altering it. */
-static struct ieee80211_hdr *ath10k_htt_rx_skb_get_hdr(struct sk_buff *skb)
-{
-	struct htt_rx_desc *rxd;
-	enum rx_msdu_decap_format fmt;
-
-	rxd = (void *)skb->data - sizeof(*rxd);
-	fmt = MS(__le32_to_cpu(rxd->msdu_start.info1),
-		 RX_MSDU_START_INFO1_DECAP_FORMAT);
-
-	if (fmt == RX_MSDU_DECAP_RAW)
-		return (void *)skb->data;
-
-	return (void *)skb->data - RX_HTT_HDR_STATUS_LEN;
-}
-
-/* This function only applies for first msdu in an msdu chain */
-static bool ath10k_htt_rx_hdr_is_amsdu(struct ieee80211_hdr *hdr)
-{
-	u8 *qc;
-
-	if (ieee80211_is_data_qos(hdr->frame_control)) {
-		qc = ieee80211_get_qos_ctl(hdr);
-		if (qc[0] & 0x80)
-			return true;
-	}
-	return false;
-}
-
 struct rfc1042_hdr {
 	u8 llc_dsap;
 	u8 llc_ssap;
@@ -757,41 +728,6 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 	}
 }
 
-static void ath10k_htt_rx_h_protected(struct ath10k_htt *htt,
-				      struct ieee80211_rx_status *rx_status,
-				      struct sk_buff *skb,
-				      enum htt_rx_mpdu_encrypt_type enctype,
-				      enum rx_msdu_decap_format fmt,
-				      bool dot11frag)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-
-	rx_status->flag &= ~(RX_FLAG_DECRYPTED |
-			     RX_FLAG_IV_STRIPPED |
-			     RX_FLAG_MMIC_STRIPPED);
-
-	if (enctype == HTT_RX_MPDU_ENCRYPT_NONE)
-		return;
-
-	/*
-	 * There's no explicit rx descriptor flag to indicate whether a given
-	 * frame has been decrypted or not. We're forced to use the decap
-	 * format as an implicit indication. However fragmentation rx is always
-	 * raw and it probably never reports undecrypted raws.
-	 *
-	 * This makes sure sniffed frames are reported as-is without stripping
-	 * the protected flag.
-	 */
-	if (fmt == RX_MSDU_DECAP_RAW && !dot11frag)
-		return;
-
-	rx_status->flag |= RX_FLAG_DECRYPTED |
-			   RX_FLAG_IV_STRIPPED |
-			   RX_FLAG_MMIC_STRIPPED;
-	hdr->frame_control = __cpu_to_le16(__le16_to_cpu(hdr->frame_control) &
-					   ~IEEE80211_FCTL_PROTECTED);
-}
-
 static bool ath10k_htt_rx_h_channel(struct ath10k *ar,
 				    struct ieee80211_rx_status *status)
 {
@@ -886,178 +822,262 @@ static int ath10k_htt_rx_nwifi_hdrlen(struct ieee80211_hdr *hdr)
 	return round_up(ieee80211_hdrlen(hdr->frame_control), 4);
 }
 
-static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
-				struct ieee80211_rx_status *rx_status,
-				struct sk_buff_head *amsdu)
+static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
+					struct sk_buff *msdu,
+					struct ieee80211_rx_status *status,
+					enum htt_rx_mpdu_encrypt_type enctype,
+					bool is_decrypted)
 {
-	struct ath10k *ar = htt->ar;
+	struct ieee80211_hdr *hdr;
 	struct htt_rx_desc *rxd;
-	struct sk_buff *skb;
-	struct sk_buff *first;
-	enum rx_msdu_decap_format fmt;
-	enum htt_rx_mpdu_encrypt_type enctype;
+	size_t hdr_len;
+	size_t crypto_len;
+	bool is_first;
+	bool is_last;
+
+	rxd = (void *)msdu->data - sizeof(*rxd);
+	is_first = !!(rxd->msdu_end.info0 &
+		      __cpu_to_le32(RX_MSDU_END_INFO0_FIRST_MSDU));
+	is_last = !!(rxd->msdu_end.info0 &
+		     __cpu_to_le32(RX_MSDU_END_INFO0_LAST_MSDU));
+
+	/* Delivered decapped frame:
+	 * [802.11 header]
+	 * [crypto param] <-- can be trimmed if !fcs_err &&
+	 *                    !decrypt_err && !peer_idx_invalid
+	 * [amsdu header] <-- only if A-MSDU
+	 * [rfc1042/llc]
+	 * [payload]
+	 * [FCS] <-- at end, needs to be trimmed
+	 */
+
+	/* This probably shouldn't happen but warn just in case */
+	if (unlikely(WARN_ON_ONCE(!is_first)))
+		return;
+
+	/* This probably shouldn't happen but warn just in case */
+	if (unlikely(WARN_ON_ONCE(!(is_first && is_last))))
+		return;
+
+	skb_trim(msdu, msdu->len - FCS_LEN);
+
+	/* In most cases this will be true for sniffed frames. It makes sense
+	 * to deliver them as-is without stripping the crypto param. This would
+	 * also make sense for software based decryption (which is not
+	 * implemented in ath10k).
+	 *
+	 * If there's no error then the frame is decrypted. At least that is
+	 * the case for frames that come in via fragmented rx indication.
+	 */
+	if (!is_decrypted)
+		return;
+
+	/* The payload is decrypted so strip crypto params. Start from tail
+	 * since hdr is used to compute some stuff.
+	 */
+
+	hdr = (void *)msdu->data;
+
+	/* Tail */
+	skb_trim(msdu, msdu->len - ath10k_htt_rx_crypto_tail_len(ar, enctype));
+
+	/* MMIC */
+	if (!ieee80211_has_morefrags(hdr->frame_control) &&
+	    enctype == HTT_RX_MPDU_ENCRYPT_TKIP_WPA)
+		skb_trim(msdu, msdu->len - 8);
+
+	/* Head */
+	hdr_len = ieee80211_hdrlen(hdr->frame_control);
+	crypto_len = ath10k_htt_rx_crypto_param_len(ar, enctype);
+
+	memmove((void *)msdu->data + crypto_len,
+		(void *)msdu->data, hdr_len);
+	skb_pull(msdu, crypto_len);
+}
+
+static void ath10k_htt_rx_h_undecap_nwifi(struct ath10k *ar,
+					  struct sk_buff *msdu,
+					  struct ieee80211_rx_status *status,
+					  const u8 first_hdr[64])
+{
 	struct ieee80211_hdr *hdr;
-	u8 hdr_buf[64], da[ETH_ALEN], sa[ETH_ALEN], *qos;
-	unsigned int hdr_len;
+	size_t hdr_len;
+	u8 da[ETH_ALEN];
+	u8 sa[ETH_ALEN];
 
-	first = skb_peek(amsdu);
+	/* Delivered decapped frame:
+	 * [nwifi 802.11 header] <-- replaced with 802.11 hdr
+	 * [rfc1042/llc]
+	 *
+	 * Note: The nwifi header doesn't have QoS Control and is
+	 * (always?) a 3addr frame.
+	 *
+	 * Note2: There's no A-MSDU subframe header. Even if it's part
+	 * of an A-MSDU.
+	 */
 
-	rxd = (void *)first->data - sizeof(*rxd);
-	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
-		     RX_MPDU_START_INFO0_ENCRYPT_TYPE);
+	/* pull decapped header and copy SA & DA */
+	hdr = (struct ieee80211_hdr *)msdu->data;
+	hdr_len = ath10k_htt_rx_nwifi_hdrlen(hdr);
+	ether_addr_copy(da, ieee80211_get_DA(hdr));
+	ether_addr_copy(sa, ieee80211_get_SA(hdr));
+	skb_pull(msdu, hdr_len);
 
-	hdr = (struct ieee80211_hdr *)rxd->rx_hdr_status;
+	/* push original 802.11 header */
+	hdr = (struct ieee80211_hdr *)first_hdr;
 	hdr_len = ieee80211_hdrlen(hdr->frame_control);
-	memcpy(hdr_buf, hdr, hdr_len);
-	hdr = (struct ieee80211_hdr *)hdr_buf;
+	memcpy(skb_push(msdu, hdr_len), hdr, hdr_len);
 
-	while ((skb = __skb_dequeue(amsdu))) {
-		void *decap_hdr;
-		int len;
-
-		rxd = (void *)skb->data - sizeof(*rxd);
-		fmt = MS(__le32_to_cpu(rxd->msdu_start.info1),
-			 RX_MSDU_START_INFO1_DECAP_FORMAT);
-		decap_hdr = (void *)rxd->rx_hdr_status;
-
-		skb->ip_summed = ath10k_htt_rx_get_csum_state(skb);
-
-		/* First frame in an A-MSDU chain has more decapped data. */
-		if (skb == first) {
-			len = round_up(ieee80211_hdrlen(hdr->frame_control), 4);
-			len += round_up(ath10k_htt_rx_crypto_param_len(ar,
-						enctype), 4);
-			decap_hdr += len;
-		}
+	/* original 802.11 header has a different DA and in
+	 * case of 4addr it may also have different SA
+	 */
+	hdr = (struct ieee80211_hdr *)msdu->data;
+	ether_addr_copy(ieee80211_get_DA(hdr), da);
+	ether_addr_copy(ieee80211_get_SA(hdr), sa);
+}
 
-		switch (fmt) {
-		case RX_MSDU_DECAP_RAW:
-			/* remove trailing FCS */
-			skb_trim(skb, skb->len - FCS_LEN);
-			break;
-		case RX_MSDU_DECAP_NATIVE_WIFI:
-			/* pull decapped header and copy SA & DA */
-			hdr = (struct ieee80211_hdr *)skb->data;
-			hdr_len = ath10k_htt_rx_nwifi_hdrlen(hdr);
-			ether_addr_copy(da, ieee80211_get_DA(hdr));
-			ether_addr_copy(sa, ieee80211_get_SA(hdr));
-			skb_pull(skb, hdr_len);
-
-			/* push original 802.11 header */
-			hdr = (struct ieee80211_hdr *)hdr_buf;
-			hdr_len = ieee80211_hdrlen(hdr->frame_control);
-			memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
-
-			/* original A-MSDU header has the bit set but we're
-			 * not including A-MSDU subframe header */
-			hdr = (struct ieee80211_hdr *)skb->data;
-			qos = ieee80211_get_qos_ctl(hdr);
-			qos[0] &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
-
-			/* original 802.11 header has a different DA and in
-			 * case of 4addr it may also have different SA
-			 */
-			ether_addr_copy(ieee80211_get_DA(hdr), da);
-			ether_addr_copy(ieee80211_get_SA(hdr), sa);
-			break;
-		case RX_MSDU_DECAP_ETHERNET2_DIX:
-			/* strip ethernet header and insert decapped 802.11
-			 * header, amsdu subframe header and rfc1042 header */
+static void *ath10k_htt_rx_h_find_rfc1042(struct ath10k *ar,
+					  struct sk_buff *msdu,
+					  enum htt_rx_mpdu_encrypt_type enctype)
+{
+	struct ieee80211_hdr *hdr;
+	struct htt_rx_desc *rxd;
+	size_t hdr_len, crypto_len;
+	void *rfc1042;
+	bool is_first, is_last, is_amsdu;
 
-			len = 0;
-			len += sizeof(struct rfc1042_hdr);
-			len += sizeof(struct amsdu_subframe_hdr);
+	rxd = (void *)msdu->data - sizeof(*rxd);
+	hdr = (void *)rxd->rx_hdr_status;
 
-			skb_pull(skb, sizeof(struct ethhdr));
-			memcpy(skb_push(skb, len), decap_hdr, len);
-			memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
-			break;
-		case RX_MSDU_DECAP_8023_SNAP_LLC:
-			/* insert decapped 802.11 header making a singly
-			 * A-MSDU */
-			memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
-			break;
-		}
+	is_first = !!(rxd->msdu_end.info0 &
+		      __cpu_to_le32(RX_MSDU_END_INFO0_FIRST_MSDU));
+	is_last = !!(rxd->msdu_end.info0 &
+		     __cpu_to_le32(RX_MSDU_END_INFO0_LAST_MSDU));
+	is_amsdu = !(is_first && is_last);
 
-		ath10k_htt_rx_h_protected(htt, rx_status, skb, enctype, fmt,
-					  false);
+	rfc1042 = hdr;
 
-		if (skb_queue_empty(amsdu))
-			rx_status->flag &= ~RX_FLAG_AMSDU_MORE;
-		else
-			rx_status->flag |= RX_FLAG_AMSDU_MORE;
+	if (is_first) {
+		hdr_len = ieee80211_hdrlen(hdr->frame_control);
+		crypto_len = ath10k_htt_rx_crypto_param_len(ar, enctype);
 
-		ath10k_process_rx(htt->ar, rx_status, skb);
+		rfc1042 += round_up(hdr_len, 4) +
+			   round_up(crypto_len, 4);
 	}
 
-	/* FIXME: It might be nice to re-assemble the A-MSDU when there's a
-	 * monitor interface active for sniffing purposes. */
+	if (is_amsdu)
+		rfc1042 += sizeof(struct amsdu_subframe_hdr);
+
+	return rfc1042;
 }
 
-static void ath10k_htt_rx_msdu(struct ath10k_htt *htt,
-			       struct ieee80211_rx_status *rx_status,
-			       struct sk_buff *skb)
+static void ath10k_htt_rx_h_undecap_eth(struct ath10k *ar,
+					struct sk_buff *msdu,
+					struct ieee80211_rx_status *status,
+					const u8 first_hdr[64],
+					enum htt_rx_mpdu_encrypt_type enctype)
 {
-	struct ath10k *ar = htt->ar;
-	struct htt_rx_desc *rxd;
 	struct ieee80211_hdr *hdr;
-	enum rx_msdu_decap_format fmt;
-	enum htt_rx_mpdu_encrypt_type enctype;
-	int hdr_len;
+	struct ethhdr *eth;
+	size_t hdr_len;
 	void *rfc1042;
+	u8 da[ETH_ALEN];
+	u8 sa[ETH_ALEN];
 
-	rxd = (void *)skb->data - sizeof(*rxd);
-	fmt = MS(__le32_to_cpu(rxd->msdu_start.info1),
-		 RX_MSDU_START_INFO1_DECAP_FORMAT);
-	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
-		     RX_MPDU_START_INFO0_ENCRYPT_TYPE);
-	hdr = (struct ieee80211_hdr *)rxd->rx_hdr_status;
+	/* Delivered decapped frame:
+	 * [eth header] <-- replaced with 802.11 hdr & rfc1042/llc
+	 * [payload]
+	 */
+
+	rfc1042 = ath10k_htt_rx_h_find_rfc1042(ar, msdu, enctype);
+	if (WARN_ON_ONCE(!rfc1042))
+		return;
+
+	/* pull decapped header and copy SA & DA */
+	eth = (struct ethhdr *)msdu->data;
+	ether_addr_copy(da, eth->h_dest);
+	ether_addr_copy(sa, eth->h_source);
+	skb_pull(msdu, sizeof(struct ethhdr));
+
+	/* push rfc1042/llc/snap */
+	memcpy(skb_push(msdu, sizeof(struct rfc1042_hdr)), rfc1042,
+	       sizeof(struct rfc1042_hdr));
+
+	/* push original 802.11 header */
+	hdr = (struct ieee80211_hdr *)first_hdr;
+	hdr_len = ieee80211_hdrlen(hdr->frame_control);
+	memcpy(skb_push(msdu, hdr_len), hdr, hdr_len);
+
+	/* original 802.11 header has a different DA and in
+	 * case of 4addr it may also have different SA
+	 */
+	hdr = (struct ieee80211_hdr *)msdu->data;
+	ether_addr_copy(ieee80211_get_DA(hdr), da);
+	ether_addr_copy(ieee80211_get_SA(hdr), sa);
+}
+
+static void ath10k_htt_rx_h_undecap_snap(struct ath10k *ar,
+					 struct sk_buff *msdu,
+					 struct ieee80211_rx_status *status,
+					 const u8 first_hdr[64])
+{
+	struct ieee80211_hdr *hdr;
+	size_t hdr_len;
+
+	/* Delivered decapped frame:
+	 * [amsdu header] <-- replaced with 802.11 hdr
+	 * [rfc1042/llc]
+	 * [payload]
+	 */
+
+	skb_pull(msdu, sizeof(struct amsdu_subframe_hdr));
+
+	hdr = (struct ieee80211_hdr *)first_hdr;
 	hdr_len = ieee80211_hdrlen(hdr->frame_control);
+	memcpy(skb_push(msdu, hdr_len), hdr, hdr_len);
+}
 
-	skb->ip_summed = ath10k_htt_rx_get_csum_state(skb);
+static void ath10k_htt_rx_h_undecap(struct ath10k *ar,
+				    struct sk_buff *msdu,
+				    struct ieee80211_rx_status *status,
+				    u8 first_hdr[64],
+				    enum htt_rx_mpdu_encrypt_type enctype,
+				    bool is_decrypted)
+{
+	struct htt_rx_desc *rxd;
+	enum rx_msdu_decap_format decap;
+	struct ieee80211_hdr *hdr;
 
-	switch (fmt) {
+	/* First msdu's decapped header:
+	 * [802.11 header] <-- padded to 4 bytes long
+	 * [crypto param] <-- padded to 4 bytes long
+	 * [amsdu header] <-- only if A-MSDU
+	 * [rfc1042/llc]
+	 *
+	 * Other (2nd, 3rd, ..) msdu's decapped header:
+	 * [amsdu header] <-- only if A-MSDU
+	 * [rfc1042/llc]
+	 */
+
+	rxd = (void *)msdu->data - sizeof(*rxd);
+	hdr = (void *)rxd->rx_hdr_status;
+	decap = MS(__le32_to_cpu(rxd->msdu_start.info1),
+		   RX_MSDU_START_INFO1_DECAP_FORMAT);
+
+	switch (decap) {
 	case RX_MSDU_DECAP_RAW:
-		/* remove trailing FCS */
-		skb_trim(skb, skb->len - FCS_LEN);
+		ath10k_htt_rx_h_undecap_raw(ar, msdu, status, enctype, is_decrypted);
 		break;
 	case RX_MSDU_DECAP_NATIVE_WIFI:
-		/* Pull decapped header */
-		hdr = (struct ieee80211_hdr *)skb->data;
-		hdr_len = ath10k_htt_rx_nwifi_hdrlen(hdr);
-		skb_pull(skb, hdr_len);
-
-		/* Push original header */
-		hdr = (struct ieee80211_hdr *)rxd->rx_hdr_status;
-		hdr_len = ieee80211_hdrlen(hdr->frame_control);
-		memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
+		ath10k_htt_rx_h_undecap_nwifi(ar, msdu, status, first_hdr);
 		break;
 	case RX_MSDU_DECAP_ETHERNET2_DIX:
-		/* strip ethernet header and insert decapped 802.11 header and
-		 * rfc1042 header */
-
-		rfc1042 = hdr;
-		rfc1042 += roundup(hdr_len, 4);
-		rfc1042 += roundup(ath10k_htt_rx_crypto_param_len(ar,
-					enctype), 4);
-
-		skb_pull(skb, sizeof(struct ethhdr));
-		memcpy(skb_push(skb, sizeof(struct rfc1042_hdr)),
-		       rfc1042, sizeof(struct rfc1042_hdr));
-		memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
+		ath10k_htt_rx_h_undecap_eth(ar, msdu, status, first_hdr, enctype);
 		break;
 	case RX_MSDU_DECAP_8023_SNAP_LLC:
-		/* remove A-MSDU subframe header and insert
-		 * decapped 802.11 header. rfc1042 header is already there */
-
-		skb_pull(skb, sizeof(struct amsdu_subframe_hdr));
-		memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
+		ath10k_htt_rx_h_undecap_snap(ar, msdu, status, first_hdr);
 		break;
 	}
-
-	ath10k_htt_rx_h_protected(htt, rx_status, skb, enctype, fmt, false);
-
-	ath10k_process_rx(htt->ar, rx_status, skb);
 }
 
 static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb)
@@ -1091,6 +1111,126 @@ static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb)
 	return CHECKSUM_UNNECESSARY;
 }
 
+static void ath10k_htt_rx_h_csum_offload(struct sk_buff *msdu)
+{
+	msdu->ip_summed = ath10k_htt_rx_get_csum_state(msdu);
+}
+
+static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
+				 struct sk_buff_head *amsdu,
+				 struct ieee80211_rx_status *status)
+{
+	struct sk_buff *first;
+	struct sk_buff *last;
+	struct sk_buff *msdu;
+	struct htt_rx_desc *rxd;
+	struct ieee80211_hdr *hdr;
+	enum htt_rx_mpdu_encrypt_type enctype;
+	u8 first_hdr[64];
+	u8 *qos;
+	size_t hdr_len;
+	bool has_fcs_err;
+	bool has_crypto_err;
+	bool has_tkip_err;
+	bool has_peer_idx_invalid;
+	bool is_decrypted;
+
+	if (skb_queue_empty(amsdu))
+		return;
+
+	first = skb_peek(amsdu);
+	rxd = (void *)first->data - sizeof(*rxd);
+
+	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
+		     RX_MPDU_START_INFO0_ENCRYPT_TYPE);
+
+	/* First MSDU's Rx descriptor in an A-MSDU contains full 802.11
+	 * decapped header. It'll be used for undecapping of each MSDU.
+	 */
+	hdr = (void *)rxd->rx_hdr_status;
+	hdr_len = ieee80211_hdrlen(hdr->frame_control);
+	memcpy(first_hdr, hdr, hdr_len);
+
+	/* Each A-MSDU subframe will use the original header as the base and be
+	 * reported as a separate MSDU so strip the A-MSDU bit from QoS Ctl.
+	 */
+	hdr = (void *)first_hdr;
+	qos = ieee80211_get_qos_ctl(hdr);
+	qos[0] &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+
+	/* Some attention flags are valid only in the last MSDU. */
+	last = skb_peek_tail(amsdu);
+	rxd = (void *)last->data - sizeof(*rxd);
+	has_fcs_err = !!(rxd->attention.flags &
+			 __cpu_to_le32(RX_ATTENTION_FLAGS_FCS_ERR));
+	has_crypto_err = !!(rxd->attention.flags &
+			    __cpu_to_le32(RX_ATTENTION_FLAGS_DECRYPT_ERR));
+	has_tkip_err = !!(rxd->attention.flags &
+			  __cpu_to_le32(RX_ATTENTION_FLAGS_TKIP_MIC_ERR));
+	has_peer_idx_invalid = !!(rxd->attention.flags &
+			          __cpu_to_le32(RX_ATTENTION_FLAGS_PEER_IDX_INVALID));
+
+	/* Note: If hardware captures an encrypted frame that it can't decrypt,
+	 * e.g. due to fcs error, missing peer or invalid key data it will
+	 * report the frame as raw.
+	 */
+	is_decrypted = (enctype != HTT_RX_MPDU_ENCRYPT_NONE &&
+			!has_fcs_err &&
+			!has_crypto_err &&
+			!has_peer_idx_invalid);
+
+	/* Clear per-MPDU flags while leaving per-PPDU flags intact. */
+	status->flag &= ~(RX_FLAG_FAILED_FCS_CRC |
+			  RX_FLAG_MMIC_ERROR |
+			  RX_FLAG_DECRYPTED |
+			  RX_FLAG_IV_STRIPPED |
+			  RX_FLAG_MMIC_STRIPPED);
+
+	if (has_fcs_err)
+		status->flag |= RX_FLAG_FAILED_FCS_CRC;
+
+	if (has_tkip_err)
+		status->flag |= RX_FLAG_MMIC_ERROR;
+
+	if (is_decrypted)
+		status->flag |= RX_FLAG_DECRYPTED |
+				RX_FLAG_IV_STRIPPED |
+				RX_FLAG_MMIC_STRIPPED;
+
+	skb_queue_walk(amsdu, msdu) {
+		ath10k_htt_rx_h_csum_offload(msdu);
+		ath10k_htt_rx_h_undecap(ar, msdu, status, first_hdr, enctype,
+					is_decrypted);
+
+		/* Undecapping involves copying the original 802.11 header back
+		 * to sk_buff. If frame is protected and hardware has decrypted
+		 * it then remove the protected bit.
+		 */
+		if (!is_decrypted)
+			continue;
+
+		hdr = (void *)msdu->data;
+		hdr->frame_control &= ~__cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+	}
+}
+
+static void ath10k_htt_rx_h_deliver(struct ath10k *ar,
+				    struct sk_buff_head *amsdu,
+				    struct ieee80211_rx_status *status)
+{
+	struct sk_buff *msdu;
+
+	while ((msdu = __skb_dequeue(amsdu))) {
+		/* Setup per-MSDU flags */
+		if (skb_queue_empty(amsdu))
+			status->flag &= ~RX_FLAG_AMSDU_MORE;
+		else
+			status->flag |= RX_FLAG_AMSDU_MORE;
+
+		ath10k_process_rx(ar, status, msdu);
+	}
+}
+
 static int ath10k_unchain_msdu(struct sk_buff_head *amsdu)
 {
 	struct sk_buff *skb, *first;
@@ -1134,45 +1274,86 @@ static int ath10k_unchain_msdu(struct sk_buff_head *amsdu)
 	return 0;
 }
 
-static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
-					struct sk_buff *head,
-					bool channel_set,
-					u32 attention)
+static void ath10k_htt_rx_h_unchain(struct ath10k *ar,
+				    struct sk_buff_head *amsdu,
+				    bool chained)
 {
-	struct ath10k *ar = htt->ar;
+	struct sk_buff *first;
+	struct htt_rx_desc *rxd;
+	enum rx_msdu_decap_format decap;
 
-	if (head->len == 0) {
-		ath10k_dbg(ar, ATH10K_DBG_HTT,
-			   "htt rx dropping due to zero-len\n");
-		return false;
-	}
+	first = skb_peek(amsdu);
+	rxd = (void *)first->data - sizeof(*rxd);
+	decap = MS(__le32_to_cpu(rxd->msdu_start.info1),
+		   RX_MSDU_START_INFO1_DECAP_FORMAT);
 
-	if (attention & RX_ATTENTION_FLAGS_DECRYPT_ERR) {
-		ath10k_dbg(ar, ATH10K_DBG_HTT,
-			   "htt rx dropping due to decrypt-err\n");
-		return false;
+	if (!chained)
+		return;
+
+	/* FIXME: Current unchaining logic can only handle simple case of raw
+	 * msdu chaining. If decapping is other than raw the chaining may be
+	 * more complex and this isn't handled by the current code. Don't even
+	 * try re-constructing such frames - it'll be pretty much garbage.
+	 */
+	if (decap != RX_MSDU_DECAP_RAW ||
+	    skb_queue_len(amsdu) != 1 + rxd->frag_info.ring2_more_count) {
+		__skb_queue_purge(amsdu);
+		return;
 	}
 
-	if (!channel_set) {
-		ath10k_warn(ar, "no channel configured; ignoring frame!\n");
+	ath10k_unchain_msdu(amsdu);
+}
+
+static bool ath10k_htt_rx_amsdu_allowed(struct ath10k *ar,
+					struct sk_buff_head *amsdu,
+					struct ieee80211_rx_status *rx_status)
+{
+	struct sk_buff *msdu;
+	struct htt_rx_desc *rxd;
+
+	msdu = skb_peek(amsdu);
+	rxd = (void *)msdu->data - sizeof(*rxd);
+
+	/* FIXME: It might be a good idea to do some fuzzy-testing to drop
+	 * invalid/dangerous frames.
+	 */
+
+	if (!rx_status->freq) {
+		ath10k_warn(ar, "no channel configured; ignoring frame(s)!\n");
 		return false;
 	}
 
-	/* Skip mgmt frames while we handle this in WMI */
-	if (attention & RX_ATTENTION_FLAGS_MGMT_TYPE) {
+	/* Management frames are handled via WMI events. The pros of such
+	 * approach is that channel is explicitly provided in WMI events
+	 * whereas HTT doesn't provide channel information for Rxed frames.
+	 */
+	if (rxd->attention.flags &
+	    __cpu_to_le32(RX_ATTENTION_FLAGS_MGMT_TYPE)) {
 		ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx mgmt ctrl\n");
 		return false;
 	}
 
-	if (test_bit(ATH10K_CAC_RUNNING, &htt->ar->dev_flags)) {
-		ath10k_dbg(ar, ATH10K_DBG_HTT,
-			   "htt rx CAC running\n");
+	if (test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags)) {
+		ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx cac running\n");
 		return false;
 	}
 
 	return true;
 }
 
+static void ath10k_htt_rx_h_filter(struct ath10k *ar,
+				   struct sk_buff_head *amsdu,
+				   struct ieee80211_rx_status *rx_status)
+{
+	if (skb_queue_empty(amsdu))
+		return;
+
+	if (ath10k_htt_rx_amsdu_allowed(ar, amsdu, rx_status))
+		return;
+
+	__skb_queue_purge(amsdu);
+}
+
 static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				  struct htt_rx_indication *rx)
 {
@@ -1180,7 +1361,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	struct ieee80211_rx_status *rx_status = &htt->rx_status;
 	struct htt_rx_indication_mpdu_range *mpdu_ranges;
 	struct sk_buff_head amsdu;
-	struct ieee80211_hdr *hdr;
 	int num_mpdu_ranges;
 	u32 attention;
 	int fw_desc_len;
@@ -1247,34 +1427,10 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			break;
 		}
 
-		if (!ath10k_htt_rx_amsdu_allowed(htt, skb_peek(&amsdu),
-						 channel_set, attention)) {
-			__skb_queue_purge(&amsdu);
-			continue;
-		}
-
-		if (ret > 0 && ath10k_unchain_msdu(&amsdu) < 0) {
-			__skb_queue_purge(&amsdu);
-			continue;
-		}
-
-		if (attention & RX_ATTENTION_FLAGS_FCS_ERR)
-			rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
-		else
-			rx_status->flag &= ~RX_FLAG_FAILED_FCS_CRC;
-
-		if (attention & RX_ATTENTION_FLAGS_TKIP_MIC_ERR)
-			rx_status->flag |= RX_FLAG_MMIC_ERROR;
-		else
-			rx_status->flag &= ~RX_FLAG_MMIC_ERROR;
-
-		hdr = ath10k_htt_rx_skb_get_hdr(skb_peek(&amsdu));
-
-		if (ath10k_htt_rx_hdr_is_amsdu(hdr))
-			ath10k_htt_rx_amsdu(htt, rx_status, &amsdu);
-		else
-			ath10k_htt_rx_msdu(htt, rx_status,
-					   __skb_dequeue(&amsdu));
+		ath10k_htt_rx_h_unchain(ar, &amsdu, ret > 0);
+		ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
+		ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);
+		ath10k_htt_rx_h_deliver(ar, &amsdu, rx_status);
 	}
 
 	tasklet_schedule(&htt->rx_replenish_task);
@@ -1284,19 +1440,11 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 				       struct htt_rx_fragment_indication *frag)
 {
 	struct ath10k *ar = htt->ar;
-	struct sk_buff *msdu;
-	enum htt_rx_mpdu_encrypt_type enctype;
-	struct htt_rx_desc *rxd;
-	enum rx_msdu_decap_format fmt;
 	struct ieee80211_rx_status *rx_status = &htt->rx_status;
-	struct ieee80211_hdr *hdr;
 	struct sk_buff_head amsdu;
 	int ret;
-	bool tkip_mic_err;
-	bool decrypt_err;
 	u8 *fw_desc;
-	int fw_desc_len, hdrlen, paramlen;
-	int trim;
+	int fw_desc_len;
 	u32 attention = 0;
 
 	fw_desc_len = __le16_to_cpu(frag->fw_rx_desc_bytes);
@@ -1326,75 +1474,13 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 		return;
 	}
 
-	msdu = __skb_dequeue(&amsdu);
-
 	/* FIXME: implement signal strength */
 	rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
-	hdr = (struct ieee80211_hdr *)msdu->data;
-	rxd = (void *)msdu->data - sizeof(*rxd);
-	tkip_mic_err = !!(attention & RX_ATTENTION_FLAGS_TKIP_MIC_ERR);
-	decrypt_err = !!(attention & RX_ATTENTION_FLAGS_DECRYPT_ERR);
-	fmt = MS(__le32_to_cpu(rxd->msdu_start.info1),
-		 RX_MSDU_START_INFO1_DECAP_FORMAT);
-
-	if (fmt != RX_MSDU_DECAP_RAW) {
-		ath10k_warn(ar, "we dont support non-raw fragmented rx yet\n");
-		dev_kfree_skb_any(msdu);
-		goto end;
-	}
-
-	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
-		     RX_MPDU_START_INFO0_ENCRYPT_TYPE);
-	ath10k_htt_rx_h_protected(htt, rx_status, msdu, enctype, fmt,
-				  true);
-	msdu->ip_summed = ath10k_htt_rx_get_csum_state(msdu);
-
-	if (tkip_mic_err)
-		ath10k_warn(ar, "tkip mic error\n");
-
-	if (decrypt_err) {
-		ath10k_warn(ar, "decryption err in fragmented rx\n");
-		dev_kfree_skb_any(msdu);
-		goto end;
-	}
-
-	if (enctype != HTT_RX_MPDU_ENCRYPT_NONE) {
-		hdrlen = ieee80211_hdrlen(hdr->frame_control);
-		paramlen = ath10k_htt_rx_crypto_param_len(ar, enctype);
-
-		/* It is more efficient to move the header than the payload */
-		memmove((void *)msdu->data + paramlen,
-			(void *)msdu->data,
-			hdrlen);
-		skb_pull(msdu, paramlen);
-		hdr = (struct ieee80211_hdr *)msdu->data;
-	}
-
-	/* remove trailing FCS */
-	trim  = 4;
-
-	/* remove crypto trailer */
-	trim += ath10k_htt_rx_crypto_tail_len(ar, enctype);
-
-	/* last fragment of TKIP frags has MIC */
-	if (!ieee80211_has_morefrags(hdr->frame_control) &&
-	    enctype == HTT_RX_MPDU_ENCRYPT_TKIP_WPA)
-		trim += MICHAEL_MIC_LEN;
-
-	if (trim > msdu->len) {
-		ath10k_warn(ar, "htt rx fragment: trailer longer than the frame itself? drop\n");
-		dev_kfree_skb_any(msdu);
-		goto end;
-	}
-
-	skb_trim(msdu, msdu->len - trim);
-
-	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt rx frag mpdu: ",
-			msdu->data, msdu->len);
-	ath10k_process_rx(htt->ar, rx_status, msdu);
+	ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
+	ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);
+	ath10k_htt_rx_h_deliver(ar, &amsdu, rx_status);
 
-end:
 	if (fw_desc_len > 0) {
 		ath10k_dbg(ar, ATH10K_DBG_HTT,
 			   "expecting more fragmented rx in one indication %d\n",
-- 
1.8.5.3

