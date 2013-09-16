Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:60942 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab3IPMtl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 08:49:41 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 1/4] ath10k: report A-MSDU subframes individually
Date: Mon, 16 Sep 2013 14:49:14 +0200
Message-ID: <1379335757-15180-2-git-send-email-michal.kazior@tieto.com> (sfid-20130916_144946_086885_60B26D9C)
In-Reply-To: <1379335757-15180-1-git-send-email-michal.kazior@tieto.com>
References: <1379335757-15180-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HW reports each A-MSDU subframe as a separate
sk_buff. It is impossible to configure it to
behave differently.

Until now ath10k was reconstructing A-MSDUs from
subframes which involved a lot of memory
operations. This proved to be a significant
contributor to degraded RX performance.

This at least doubles RX performance on AP135.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |  189 ++++++++++--------------------
 drivers/net/wireless/ath/ath10k/txrx.c   |    5 +
 3 files changed, 71 insertions(+), 124 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index e090902..9bcff3e 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1181,6 +1181,7 @@ struct htt_rx_info {
 		u32 info2;
 	} rate;
 	bool fcs_err;
+	bool amsdu_more;
 };
 
 struct ath10k_htt {
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a39fbf4..dad584f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -41,6 +41,10 @@
 /* when under memory pressure rx ring refill may fail and needs a retry */
 #define HTT_RX_RING_REFILL_RETRY_MS 50
 
+
+static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb);
+
+
 static int ath10k_htt_rx_ring_size(struct ath10k_htt *htt)
 {
 	int size;
@@ -591,136 +595,92 @@ static bool ath10k_htt_rx_hdr_is_amsdu(struct ieee80211_hdr *hdr)
 	return false;
 }
 
-static int ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
-			struct htt_rx_info *info)
+struct rfc1042_hdr {
+	u8 llc_dsap;
+	u8 llc_ssap;
+	u8 llc_ctrl;
+	u8 snap_oui[3];
+	__be16 snap_type;
+} __packed;
+
+struct amsdu_subframe_hdr {
+	u8 dst[ETH_ALEN];
+	u8 src[ETH_ALEN];
+	__be16 len;
+} __packed;
+
+static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
+				struct htt_rx_info *info)
 {
 	struct htt_rx_desc *rxd;
-	struct sk_buff *amsdu;
 	struct sk_buff *first;
-	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb = info->skb;
 	enum rx_msdu_decap_format fmt;
 	enum htt_rx_mpdu_encrypt_type enctype;
+	struct ieee80211_hdr *hdr;
+	u8 hdr_buf[64];
 	unsigned int hdr_len;
-	int crypto_len;
 
 	rxd = (void *)skb->data - sizeof(*rxd);
-	fmt = MS(__le32_to_cpu(rxd->msdu_start.info1),
-			RX_MSDU_START_INFO1_DECAP_FORMAT);
 	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
 			RX_MPDU_START_INFO0_ENCRYPT_TYPE);
 
-	/* FIXME: No idea what assumptions are safe here. Need logs */
-	if ((fmt == RX_MSDU_DECAP_RAW && skb->next)) {
-		ath10k_htt_rx_free_msdu_chain(skb->next);
-		skb->next = NULL;
-		return -ENOTSUPP;
-	}
-
-	/* A-MSDU max is a little less than 8K */
-	amsdu = dev_alloc_skb(8*1024);
-	if (!amsdu) {
-		ath10k_warn("A-MSDU allocation failed\n");
-		ath10k_htt_rx_free_msdu_chain(skb->next);
-		skb->next = NULL;
-		return -ENOMEM;
-	}
-
-	if (fmt >= RX_MSDU_DECAP_NATIVE_WIFI) {
-		int hdrlen;
-
-		hdr = (void *)rxd->rx_hdr_status;
-		hdrlen = ieee80211_hdrlen(hdr->frame_control);
-		memcpy(skb_put(amsdu, hdrlen), hdr, hdrlen);
-	}
+	hdr = (void *)rxd->rx_hdr_status;
+	hdr_len = ieee80211_hdrlen(hdr->frame_control);
+	memcpy(hdr_buf, hdr, hdr_len);
 
 	first = skb;
 	while (skb) {
 		void *decap_hdr;
-		int decap_len = 0;
+		int decap_len;
 
 		rxd = (void *)skb->data - sizeof(*rxd);
 		fmt = MS(__le32_to_cpu(rxd->msdu_start.info1),
-				RX_MSDU_START_INFO1_DECAP_FORMAT);
+			 RX_MSDU_START_INFO1_DECAP_FORMAT);
 		decap_hdr = (void *)rxd->rx_hdr_status;
 
-		if (skb == first) {
-			/* We receive linked A-MSDU subframe skbuffs. The
-			 * first one contains the original 802.11 header (and
-			 * possible crypto param) in the RX descriptor. The
-			 * A-MSDU subframe header follows that. Each part is
-			 * aligned to 4 byte boundary. */
-
-			hdr = (void *)amsdu->data;
-			hdr_len = ieee80211_hdrlen(hdr->frame_control);
-			crypto_len = ath10k_htt_rx_crypto_param_len(enctype);
-
-			decap_hdr += roundup(hdr_len, 4);
-			decap_hdr += roundup(crypto_len, 4);
-		}
-
-		/* When fmt == RX_MSDU_DECAP_8023_SNAP_LLC:
-		 *
-		 * SNAP 802.3 consists of:
-		 * [dst:6][src:6][len:2][dsap:1][ssap:1][ctl:1][snap:5]
-		 * [data][fcs:4].
-		 *
-		 * Since this overlaps with A-MSDU header (da, sa, len)
-		 * there's nothing extra to do. */
-
-		if (fmt == RX_MSDU_DECAP_ETHERNET2_DIX) {
-			/* Ethernet2 decap inserts ethernet header in place of
-			 * A-MSDU subframe header. */
-			skb_pull(skb, 6 + 6 + 2);
-
-			/* A-MSDU subframe header length */
-			decap_len += 6 + 6 + 2;
-
-			/* Ethernet2 decap also strips the LLC/SNAP so we need
-			 * to re-insert it. The LLC/SNAP follows A-MSDU
-			 * subframe header. */
-			/* FIXME: Not all LLCs are 8 bytes long */
-			decap_len += 8;
-
-			memcpy(skb_put(amsdu, decap_len), decap_hdr, decap_len);
-		}
-
-		if (fmt == RX_MSDU_DECAP_NATIVE_WIFI) {
-			/* Native Wifi decap inserts regular 802.11 header
-			 * in place of A-MSDU subframe header. */
-			hdr = (struct ieee80211_hdr *)skb->data;
-			skb_pull(skb, ieee80211_hdrlen(hdr->frame_control));
+		skb->ip_summed = ath10k_htt_rx_get_csum_state(skb);
 
-			/* A-MSDU subframe header length */
-			decap_len += 6 + 6 + 2;
-
-			memcpy(skb_put(amsdu, decap_len), decap_hdr, decap_len);
+		/* First frame in an A-MSDU chain has more decapped data. */
+		if (skb == first) {
+			decap_hdr += round_up(ieee80211_hdrlen(hdr->frame_control), 4);
+			decap_hdr += round_up(ath10k_htt_rx_crypto_param_len(enctype), 4);
 		}
 
-		if (fmt == RX_MSDU_DECAP_RAW)
-			skb_trim(skb, skb->len - 4); /* remove FCS */
-
-		memcpy(skb_put(amsdu, skb->len), skb->data, skb->len);
-
-		/* A-MSDU subframes are padded to 4bytes
-		 * but relative to first subframe, not the whole MPDU */
-		if (skb->next && ((decap_len + skb->len) & 3)) {
-			int padlen = 4 - ((decap_len + skb->len) & 3);
-			memset(skb_put(amsdu, padlen), 0, padlen);
+		switch (fmt) {
+		case RX_MSDU_DECAP_RAW:
+			skb_trim(skb, skb->len - FCS_LEN);
+			break;
+		case RX_MSDU_DECAP_NATIVE_WIFI:
+			break;
+		case RX_MSDU_DECAP_ETHERNET2_DIX:
+			decap_len = 0;
+			decap_len += sizeof(struct rfc1042_hdr);
+			decap_len += sizeof(struct amsdu_subframe_hdr);
+
+			skb_pull(skb, sizeof(struct ethhdr));
+			memcpy(skb_push(skb, decap_len), decap_hdr, decap_len);
+			memcpy(skb_push(skb, hdr_len), hdr_buf, hdr_len);
+			break;
+		case RX_MSDU_DECAP_8023_SNAP_LLC:
+			memcpy(skb_push(skb, hdr_len), hdr_buf, hdr_len);
+			break;
 		}
 
+		info->skb = skb;
+		info->amsdu_more = (skb->next != NULL);
+		info->encrypt_type = enctype;
 		skb = skb->next;
-	}
+		info->skb->next = NULL;
 
-	info->skb = amsdu;
-	info->encrypt_type = enctype;
-
-	ath10k_htt_rx_free_msdu_chain(first);
+		ath10k_process_rx(htt->ar, info);
+	}
 
-	return 0;
+	/* FIXME: It might be nice to re-assemble the A-MSDU when there's a
+	 * monitor interface active for sniffing purposes. */
 }
 
-static int ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
+static void ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
 {
 	struct sk_buff *skb = info->skb;
 	struct htt_rx_desc *rxd;
@@ -742,6 +702,8 @@ static int ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
 			RX_MPDU_START_INFO0_ENCRYPT_TYPE);
 	hdr = (void *)skb->data - RX_HTT_HDR_STATUS_LEN;
 
+	skb->ip_summed = ath10k_htt_rx_get_csum_state(skb);
+
 	switch (fmt) {
 	case RX_MSDU_DECAP_RAW:
 		/* remove trailing FCS */
@@ -782,7 +744,8 @@ static int ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
 
 	info->skb = skb;
 	info->encrypt_type = enctype;
-	return 0;
+
+	ath10k_process_rx(htt->ar, info);
 }
 
 static bool ath10k_htt_rx_has_decrypt_err(struct sk_buff *skb)
@@ -854,8 +817,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	int fw_desc_len;
 	u8 *fw_desc;
 	int i, j;
-	int ret;
-	int ip_summed;
 
 	memset(&info, 0, sizeof(info));
 
@@ -930,11 +891,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				continue;
 			}
 
-			/* The skb is not yet processed and it may be
-			 * reallocated. Since the offload is in the original
-			 * skb extract the checksum now and assign it later */
-			ip_summed = ath10k_htt_rx_get_csum_state(msdu_head);
-
 			info.skb     = msdu_head;
 			info.fcs_err = ath10k_htt_rx_has_fcs_err(msdu_head);
 			info.signal  = ATH10K_DEFAULT_NOISE_FLOOR;
@@ -947,24 +903,9 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			hdr = ath10k_htt_rx_skb_get_hdr(msdu_head);
 
 			if (ath10k_htt_rx_hdr_is_amsdu(hdr))
-				ret = ath10k_htt_rx_amsdu(htt, &info);
+				ath10k_htt_rx_amsdu(htt, &info);
 			else
-				ret = ath10k_htt_rx_msdu(htt, &info);
-
-			if (ret && !info.fcs_err) {
-				ath10k_warn("error processing msdus %d\n", ret);
-				dev_kfree_skb_any(info.skb);
-				continue;
-			}
-
-			if (ath10k_htt_rx_hdr_is_amsdu((void *)info.skb->data))
-				ath10k_dbg(ATH10K_DBG_HTT, "htt mpdu is amsdu\n");
-
-			info.skb->ip_summed = ip_summed;
-
-			ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt mpdu: ",
-					info.skb->data, info.skb->len);
-			ath10k_process_rx(htt->ar, &info);
+				ath10k_htt_rx_msdu(htt, &info);
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 68b6fae..ed54bce 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -261,6 +261,9 @@ void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 	if (info->fcs_err)
 		status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
+	if (info->amsdu_more)
+		status->flag |= RX_FLAG_AMSDU_MORE;
+
 	status->signal = info->signal;
 
 	spin_lock_bh(&ar->data_lock);
@@ -293,6 +296,8 @@ void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 		   status->vht_nss,
 		   status->freq,
 		   status->band);
+	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "rx skb: ",
+			info->skb->data, info->skb->len);
 
 	ieee80211_rx(ar->hw, info->skb);
 }
-- 
1.7.9.5

