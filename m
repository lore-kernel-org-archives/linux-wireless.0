Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:46806 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbaCXUYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 16:24:08 -0400
Received: by mail-ee0-f53.google.com with SMTP id b57so4871956eek.40
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 13:24:07 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 5/8] ath10k: kill not needed fields from htt_rx_info
Date: Mon, 24 Mar 2014 21:23:19 +0100
Message-Id: <1395692603-4693-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140324_212416_491807_F428D317)
In-Reply-To: <1395692603-4693-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1395692603-4693-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kill rates, tsf, fcs_err, mic_err, amsdu_more, encrypt_type, signal
from htt_rx_info and setup this directly in ieee80211_rx_status.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |   13 ---
 drivers/net/wireless/ath/ath10k/htt_rx.c |  136 ++++++++++++++++--------------
 2 files changed, 74 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index e80f033..870f807 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1176,19 +1176,6 @@ struct htt_peer_unmap_event {
 struct htt_rx_info {
 	struct sk_buff *skb;
 	struct ieee80211_rx_status rx_status;
-	enum htt_rx_mpdu_status status;
-	enum htt_rx_mpdu_encrypt_type encrypt_type;
-	s8 signal;
-	struct {
-		u8 info0;
-		u32 info1;
-		u32 info2;
-	} rate;
-
-	u32 tsf;
-	bool fcs_err;
-	bool amsdu_more;
-	bool mic_err;
 };
 
 struct ath10k_htt_txbuf {
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 4ca19f9..a994a4f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -655,14 +655,12 @@ static const u8 rx_legacy_rate_idx[] = {
 	5,	/* 0x0F  - 9Mbps   */
 };
 
-static void ath10k_htt_rx_h_rates(struct ath10k *ar, struct htt_rx_info *info,
+static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 				  enum ieee80211_band band,
+				  u8 info0, u32 info1, u32 info2,
 				  struct ieee80211_rx_status *status)
 {
 	u8 cck, rate, rate_idx, bw, sgi, mcs, nss;
-	u8 info0 = info->rate.info0;
-	u32 info1 = info->rate.info1;
-	u32 info2 = info->rate.info2;
 	u8 preamble = 0;
 
 	/* Check if valid fields */
@@ -749,6 +747,27 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar, struct htt_rx_info *info,
 	}
 }
 
+static void ath10k_htt_rx_h_protected(struct ath10k_htt *htt,
+				      struct htt_rx_info *info,
+				      enum htt_rx_mpdu_encrypt_type enctype)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)info->skb->data;
+
+
+	if (enctype == HTT_RX_MPDU_ENCRYPT_NONE) {
+		info->rx_status.flag &= ~(RX_FLAG_DECRYPTED |
+					  RX_FLAG_IV_STRIPPED |
+					  RX_FLAG_MMIC_STRIPPED);
+		return;
+	}
+
+	info->rx_status.flag |= RX_FLAG_DECRYPTED |
+				RX_FLAG_IV_STRIPPED |
+				RX_FLAG_MMIC_STRIPPED;
+	hdr->frame_control = __cpu_to_le16(__le16_to_cpu(hdr->frame_control) &
+					   ~IEEE80211_FCTL_PROTECTED);
+}
+
 static bool ath10k_htt_rx_h_channel(struct ath10k *ar,
 				    struct ieee80211_rx_status *status)
 {
@@ -772,38 +791,10 @@ static bool ath10k_htt_rx_h_channel(struct ath10k *ar,
 static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 {
 	struct ieee80211_rx_status *status;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)info->skb->data;
 
 	status = IEEE80211_SKB_RXCB(info->skb);
 	memcpy(status, &info->rx_status, sizeof(*status));
 
-	if (info->encrypt_type != HTT_RX_MPDU_ENCRYPT_NONE) {
-		status->flag |= RX_FLAG_DECRYPTED | RX_FLAG_IV_STRIPPED |
-				RX_FLAG_MMIC_STRIPPED;
-		hdr->frame_control = __cpu_to_le16(
-				__le16_to_cpu(hdr->frame_control) &
-				~IEEE80211_FCTL_PROTECTED);
-	}
-
-	if (info->mic_err)
-		status->flag |= RX_FLAG_MMIC_ERROR;
-
-	if (info->fcs_err)
-		status->flag |= RX_FLAG_FAILED_FCS_CRC;
-
-	if (info->amsdu_more)
-		status->flag |= RX_FLAG_AMSDU_MORE;
-
-	status->signal = info->signal;
-
-	ath10k_htt_rx_h_rates(ar, info, status->band, status);
-
-	if (info->rate.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
-		/* TSF available only in 32-bit */
-		status->mactime = info->tsf & 0xffffffff;
-		status->flag |= RX_FLAG_MACTIME_END;
-	}
-
 	ath10k_dbg(ATH10K_DBG_DATA,
 		   "rx skb %p len %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i\n",
 		   info->skb,
@@ -817,7 +808,8 @@ static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 		   status->rate_idx,
 		   status->vht_nss,
 		   status->freq,
-		   status->band, status->flag, info->fcs_err);
+		   status->band, status->flag,
+		   !!(status->flag & RX_FLAG_FAILED_FCS_CRC));
 	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "rx skb: ",
 			info->skb->data, info->skb->len);
 
@@ -917,12 +909,14 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 		}
 
 		info->skb = skb;
-		info->encrypt_type = enctype;
+		ath10k_htt_rx_h_protected(htt, info, enctype);
 		skb = skb->next;
 		info->skb->next = NULL;
 
 		if (skb)
-			info->amsdu_more = true;
+			info->rx_status.flag |= RX_FLAG_AMSDU_MORE;
+		else
+			info->rx_status.flag &= ~RX_FLAG_AMSDU_MORE;
 
 		ath10k_process_rx(htt->ar, info);
 	}
@@ -997,7 +991,7 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
 	}
 
 	info->skb = skb;
-	info->encrypt_type = enctype;
+	ath10k_htt_rx_h_protected(htt, info, enctype);
 
 	ath10k_process_rx(htt->ar, info);
 }
@@ -1142,11 +1136,9 @@ static int ath10k_unchain_msdu(struct sk_buff *msdu_head)
 
 static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 					struct sk_buff *head,
-					struct htt_rx_info *info,
+					enum htt_rx_mpdu_status status,
 					bool channel_set)
 {
-	enum htt_rx_mpdu_status status = info->status;
-
 	if (!head) {
 		ath10k_warn("htt rx no data!\n");
 		return false;
@@ -1200,11 +1192,12 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 {
 	struct htt_rx_info info;
 	struct htt_rx_indication_mpdu_range *mpdu_ranges;
+	enum htt_rx_mpdu_status status;
 	struct ieee80211_hdr *hdr;
 	int num_mpdu_ranges;
 	int fw_desc_len;
 	u8 *fw_desc;
-	bool channel_set;
+	bool channel_set, fcs_err, mic_err;
 	int i, j;
 
 	lockdep_assert_held(&htt->rx_ring.lock);
@@ -1219,15 +1212,25 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	mpdu_ranges = htt_rx_ind_get_mpdu_ranges(rx);
 
 	/* Fill this once, while this is per-ppdu */
-	info.signal  = ATH10K_DEFAULT_NOISE_FLOOR;
-	info.signal += rx->ppdu.combined_rssi;
+	info.rx_status.signal  = ATH10K_DEFAULT_NOISE_FLOOR;
+	info.rx_status.signal += rx->ppdu.combined_rssi;
+
+	if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
+		/* TSF available only in 32-bit */
+		info.rx_status.mactime =
+				__le32_to_cpu(rx->ppdu.tsf) & 0xffffffff;
+		info.rx_status.flag |= RX_FLAG_MACTIME_END;
+	}
 
 	channel_set = ath10k_htt_rx_h_channel(htt->ar, &info.rx_status);
 
-	info.rate.info0 = rx->ppdu.info0;
-	info.rate.info1 = __le32_to_cpu(rx->ppdu.info1);
-	info.rate.info2 = __le32_to_cpu(rx->ppdu.info2);
-	info.tsf = __le32_to_cpu(rx->ppdu.tsf);
+	if (channel_set) {
+		ath10k_htt_rx_h_rates(htt->ar, info.rx_status.band,
+				      rx->ppdu.info0,
+				      __le32_to_cpu(rx->ppdu.info1),
+				      __le32_to_cpu(rx->ppdu.info2),
+				      &info.rx_status);
+	}
 
 	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt rx ind: ",
 			rx, sizeof(*rx) +
@@ -1235,7 +1238,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				num_mpdu_ranges));
 
 	for (i = 0; i < num_mpdu_ranges; i++) {
-		info.status = mpdu_ranges[i].mpdu_range_status;
+		status = mpdu_ranges[i].mpdu_range_status;
 
 		for (j = 0; j < mpdu_ranges[i].mpdu_count; j++) {
 			struct sk_buff *msdu_head, *msdu_tail;
@@ -1250,7 +1253,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 							 &msdu_tail);
 
 			if (!ath10k_htt_rx_amsdu_allowed(htt, msdu_head,
-							 &info,
+							 status,
 							 channel_set)) {
 				ath10k_htt_rx_free_msdu_chain(msdu_head);
 				continue;
@@ -1263,14 +1266,24 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			}
 
 			info.skb     = msdu_head;
-			info.fcs_err = ath10k_htt_rx_has_fcs_err(msdu_head);
-			info.mic_err = ath10k_htt_rx_has_mic_err(msdu_head);
 
-			if (info.fcs_err)
+			fcs_err = ath10k_htt_rx_has_fcs_err(msdu_head);
+			if (fcs_err)
+				info.rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+			else
+				info.rx_status.flag &= ~RX_FLAG_FAILED_FCS_CRC;
+
+			mic_err = ath10k_htt_rx_has_mic_err(msdu_head);
+			if (mic_err)
+				info.rx_status.flag |= RX_FLAG_MMIC_ERROR;
+			else
+				info.rx_status.flag &= ~RX_FLAG_MMIC_ERROR;
+
+			if (fcs_err)
 				ath10k_dbg(ATH10K_DBG_HTT,
 					   "htt rx has FCS err\n");
 
-			if (info.mic_err)
+			if (mic_err)
 				ath10k_dbg(ATH10K_DBG_HTT,
 					   "htt rx has MIC err\n");
 
@@ -1290,6 +1303,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 				struct htt_rx_fragment_indication *frag)
 {
 	struct sk_buff *msdu_head, *msdu_tail;
+	enum htt_rx_mpdu_encrypt_type enctype;
 	struct htt_rx_desc *rxd;
 	enum rx_msdu_decap_format fmt;
 	struct htt_rx_info info = {};
@@ -1343,15 +1357,13 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	}
 
 	info.skb = msdu_head;
-	info.status = HTT_RX_IND_MPDU_STATUS_OK;
-	info.encrypt_type = MS(__le32_to_cpu(rxd->mpdu_start.info0),
-				RX_MPDU_START_INFO0_ENCRYPT_TYPE);
+	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
+		     RX_MPDU_START_INFO0_ENCRYPT_TYPE);
+	ath10k_htt_rx_h_protected(htt, &info, enctype);
 	info.skb->ip_summed = ath10k_htt_rx_get_csum_state(info.skb);
 
-	if (tkip_mic_err) {
+	if (tkip_mic_err)
 		ath10k_warn("tkip mic error\n");
-		info.status = HTT_RX_IND_MPDU_STATUS_TKIP_MIC_ERR;
-	}
 
 	if (decrypt_err) {
 		ath10k_warn("decryption err in fragmented rx\n");
@@ -1359,9 +1371,9 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 		goto end;
 	}
 
-	if (info.encrypt_type != HTT_RX_MPDU_ENCRYPT_NONE) {
+	if (enctype != HTT_RX_MPDU_ENCRYPT_NONE) {
 		hdrlen = ieee80211_hdrlen(hdr->frame_control);
-		paramlen = ath10k_htt_rx_crypto_param_len(info.encrypt_type);
+		paramlen = ath10k_htt_rx_crypto_param_len(enctype);
 
 		/* It is more efficient to move the header than the payload */
 		memmove((void *)info.skb->data + paramlen,
@@ -1375,11 +1387,11 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	trim  = 4;
 
 	/* remove crypto trailer */
-	trim += ath10k_htt_rx_crypto_tail_len(info.encrypt_type);
+	trim += ath10k_htt_rx_crypto_tail_len(enctype);
 
 	/* last fragment of TKIP frags has MIC */
 	if (!ieee80211_has_morefrags(hdr->frame_control) &&
-	    info.encrypt_type == HTT_RX_MPDU_ENCRYPT_TKIP_WPA)
+	    enctype == HTT_RX_MPDU_ENCRYPT_TKIP_WPA)
 		trim += 8;
 
 	if (trim > info.skb->len) {
-- 
1.7.9.5

