Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57738 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbaCXUYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 16:24:14 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so4866884eek.36
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 13:24:13 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 8/8] ath10k: finally kill htt_rx_info
Date: Mon, 24 Mar 2014 21:23:22 +0100
Message-Id: <1395692603-4693-8-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140324_212424_713509_B4AEAEA9)
In-Reply-To: <1395692603-4693-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1395692603-4693-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Struct htt_rx_info is not needed anymore while
we will use ieee80211_rx_status structure as
a template.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |    5 --
 drivers/net/wireless/ath/ath10k/htt_rx.c |  120 +++++++++++++++---------------
 2 files changed, 60 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 870f807..2d669c0 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1173,11 +1173,6 @@ struct htt_peer_unmap_event {
 	u16 peer_id;
 };
 
-struct htt_rx_info {
-	struct sk_buff *skb;
-	struct ieee80211_rx_status rx_status;
-};
-
 struct ath10k_htt_txbuf {
 	struct htt_data_tx_desc_frag frags[2];
 	struct ath10k_htc_hdr htc_hdr;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 5dfda22..17f152c 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -752,22 +752,23 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 }
 
 static void ath10k_htt_rx_h_protected(struct ath10k_htt *htt,
-				      struct htt_rx_info *info,
+				      struct ieee80211_rx_status *rx_status,
+				      struct sk_buff *skb,
 				      enum htt_rx_mpdu_encrypt_type enctype)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)info->skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 
 	if (enctype == HTT_RX_MPDU_ENCRYPT_NONE) {
-		info->rx_status.flag &= ~(RX_FLAG_DECRYPTED |
-					  RX_FLAG_IV_STRIPPED |
-					  RX_FLAG_MMIC_STRIPPED);
+		rx_status->flag &= ~(RX_FLAG_DECRYPTED |
+				     RX_FLAG_IV_STRIPPED |
+				     RX_FLAG_MMIC_STRIPPED);
 		return;
 	}
 
-	info->rx_status.flag |= RX_FLAG_DECRYPTED |
-				RX_FLAG_IV_STRIPPED |
-				RX_FLAG_MMIC_STRIPPED;
+	rx_status->flag |= RX_FLAG_DECRYPTED |
+			   RX_FLAG_IV_STRIPPED |
+			   RX_FLAG_MMIC_STRIPPED;
 	hdr->frame_control = __cpu_to_le16(__le16_to_cpu(hdr->frame_control) &
 					   ~IEEE80211_FCTL_PROTECTED);
 }
@@ -792,17 +793,19 @@ static bool ath10k_htt_rx_h_channel(struct ath10k *ar,
 	return true;
 }
 
-static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
+static void ath10k_process_rx(struct ath10k *ar,
+			      struct ieee80211_rx_status *rx_status,
+			      struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *status;
 
-	status = IEEE80211_SKB_RXCB(info->skb);
-	memcpy(status, &info->rx_status, sizeof(*status));
+	status = IEEE80211_SKB_RXCB(skb);
+	*status = *rx_status;
 
 	ath10k_dbg(ATH10K_DBG_DATA,
 		   "rx skb %p len %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %imic-err %i\n",
-		   info->skb,
-		   info->skb->len,
+		   skb,
+		   skb->len,
 		   status->flag == 0 ? "legacy" : "",
 		   status->flag & RX_FLAG_HT ? "ht" : "",
 		   status->flag & RX_FLAG_VHT ? "vht" : "",
@@ -816,9 +819,9 @@ static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 		   !!(status->flag & RX_FLAG_FAILED_FCS_CRC),
 		   !!(status->flag & RX_FLAG_MMIC_ERROR));
 	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "rx skb: ",
-			info->skb->data, info->skb->len);
+			skb->data, skb->len);
 
-	ieee80211_rx(ar->hw, info->skb);
+	ieee80211_rx(ar->hw, skb);
 }
 
 static int ath10k_htt_rx_nwifi_hdrlen(struct ieee80211_hdr *hdr)
@@ -828,11 +831,12 @@ static int ath10k_htt_rx_nwifi_hdrlen(struct ieee80211_hdr *hdr)
 }
 
 static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
-				struct htt_rx_info *info)
+				struct ieee80211_rx_status *rx_status,
+				struct sk_buff *skb_in)
 {
 	struct htt_rx_desc *rxd;
+	struct sk_buff *skb = skb_in;
 	struct sk_buff *first;
-	struct sk_buff *skb = info->skb;
 	enum rx_msdu_decap_format fmt;
 	enum htt_rx_mpdu_encrypt_type enctype;
 	struct ieee80211_hdr *hdr;
@@ -913,26 +917,27 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 			break;
 		}
 
-		info->skb = skb;
-		ath10k_htt_rx_h_protected(htt, info, enctype);
+		skb_in = skb;
+		ath10k_htt_rx_h_protected(htt, rx_status, skb_in, enctype);
 		skb = skb->next;
-		info->skb->next = NULL;
+		skb_in->next = NULL;
 
 		if (skb)
-			info->rx_status.flag |= RX_FLAG_AMSDU_MORE;
+			rx_status->flag |= RX_FLAG_AMSDU_MORE;
 		else
-			info->rx_status.flag &= ~RX_FLAG_AMSDU_MORE;
+			rx_status->flag &= ~RX_FLAG_AMSDU_MORE;
 
-		ath10k_process_rx(htt->ar, info);
+		ath10k_process_rx(htt->ar, rx_status, skb_in);
 	}
 
 	/* FIXME: It might be nice to re-assemble the A-MSDU when there's a
 	 * monitor interface active for sniffing purposes. */
 }
 
-static void ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
+static void ath10k_htt_rx_msdu(struct ath10k_htt *htt,
+			       struct ieee80211_rx_status *rx_status,
+			       struct sk_buff *skb)
 {
-	struct sk_buff *skb = info->skb;
 	struct htt_rx_desc *rxd;
 	struct ieee80211_hdr *hdr;
 	enum rx_msdu_decap_format fmt;
@@ -995,10 +1000,9 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
 		break;
 	}
 
-	info->skb = skb;
-	ath10k_htt_rx_h_protected(htt, info, enctype);
+	ath10k_htt_rx_h_protected(htt, rx_status, skb, enctype);
 
-	ath10k_process_rx(htt->ar, info);
+	ath10k_process_rx(htt->ar, rx_status, skb);
 }
 
 static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb)
@@ -1135,7 +1139,7 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				  struct htt_rx_indication *rx)
 {
-	struct htt_rx_info info;
+	struct ieee80211_rx_status rx_status;
 	struct htt_rx_indication_mpdu_range *mpdu_ranges;
 	struct htt_rx_desc *rxd;
 	enum htt_rx_mpdu_status status;
@@ -1150,7 +1154,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
-	memset(&info, 0, sizeof(info));
+	memset(&rx_status, 0, sizeof(rx_status));
 
 	fw_desc_len = __le16_to_cpu(rx->prefix.fw_rx_desc_bytes);
 	fw_desc = (u8 *)&rx->fw_desc;
@@ -1160,24 +1164,23 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	mpdu_ranges = htt_rx_ind_get_mpdu_ranges(rx);
 
 	/* Fill this once, while this is per-ppdu */
-	info.rx_status.signal  = ATH10K_DEFAULT_NOISE_FLOOR;
-	info.rx_status.signal += rx->ppdu.combined_rssi;
+	rx_status.signal  = ATH10K_DEFAULT_NOISE_FLOOR;
+	rx_status.signal += rx->ppdu.combined_rssi;
 
 	if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
 		/* TSF available only in 32-bit */
-		info.rx_status.mactime =
-				__le32_to_cpu(rx->ppdu.tsf) & 0xffffffff;
-		info.rx_status.flag |= RX_FLAG_MACTIME_END;
+		rx_status.mactime = __le32_to_cpu(rx->ppdu.tsf) & 0xffffffff;
+		rx_status.flag |= RX_FLAG_MACTIME_END;
 	}
 
-	channel_set = ath10k_htt_rx_h_channel(htt->ar, &info.rx_status);
+	channel_set = ath10k_htt_rx_h_channel(htt->ar, &rx_status);
 
 	if (channel_set) {
-		ath10k_htt_rx_h_rates(htt->ar, info.rx_status.band,
+		ath10k_htt_rx_h_rates(htt->ar, rx_status.band,
 				      rx->ppdu.info0,
 				      __le32_to_cpu(rx->ppdu.info1),
 				      __le32_to_cpu(rx->ppdu.info2),
-				      &info.rx_status);
+				      &rx_status);
 	}
 
 	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt rx ind: ",
@@ -1225,24 +1228,22 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				continue;
 			}
 
-			info.skb     = msdu_head;
-
 			if (attention & RX_ATTENTION_FLAGS_FCS_ERR)
-				info.rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+				rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 			else
-				info.rx_status.flag &= ~RX_FLAG_FAILED_FCS_CRC;
+				rx_status.flag &= ~RX_FLAG_FAILED_FCS_CRC;
 
 			if (attention & RX_ATTENTION_FLAGS_TKIP_MIC_ERR)
-				info.rx_status.flag |= RX_FLAG_MMIC_ERROR;
+				rx_status.flag |= RX_FLAG_MMIC_ERROR;
 			else
-				info.rx_status.flag &= ~RX_FLAG_MMIC_ERROR;
+				rx_status.flag &= ~RX_FLAG_MMIC_ERROR;
 
 			hdr = ath10k_htt_rx_skb_get_hdr(msdu_head);
 
 			if (ath10k_htt_rx_hdr_is_amsdu(hdr))
-				ath10k_htt_rx_amsdu(htt, &info);
+				ath10k_htt_rx_amsdu(htt, &rx_status, msdu_head);
 			else
-				ath10k_htt_rx_msdu(htt, &info);
+				ath10k_htt_rx_msdu(htt, &rx_status, msdu_head);
 		}
 	}
 
@@ -1256,7 +1257,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	enum htt_rx_mpdu_encrypt_type enctype;
 	struct htt_rx_desc *rxd;
 	enum rx_msdu_decap_format fmt;
-	struct htt_rx_info info = {};
+	struct ieee80211_rx_status rx_status = {};
 	struct ieee80211_hdr *hdr;
 	int ret;
 	bool tkip_mic_err;
@@ -1302,18 +1303,17 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 		goto end;
 	}
 
-	info.skb = msdu_head;
 	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
 		     RX_MPDU_START_INFO0_ENCRYPT_TYPE);
-	ath10k_htt_rx_h_protected(htt, &info, enctype);
-	info.skb->ip_summed = ath10k_htt_rx_get_csum_state(info.skb);
+	ath10k_htt_rx_h_protected(htt, &rx_status, msdu_head, enctype);
+	msdu_head->ip_summed = ath10k_htt_rx_get_csum_state(msdu_head);
 
 	if (tkip_mic_err)
 		ath10k_warn("tkip mic error\n");
 
 	if (decrypt_err) {
 		ath10k_warn("decryption err in fragmented rx\n");
-		dev_kfree_skb_any(info.skb);
+		dev_kfree_skb_any(msdu_head);
 		goto end;
 	}
 
@@ -1322,11 +1322,11 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 		paramlen = ath10k_htt_rx_crypto_param_len(enctype);
 
 		/* It is more efficient to move the header than the payload */
-		memmove((void *)info.skb->data + paramlen,
-			(void *)info.skb->data,
+		memmove((void *)msdu_head->data + paramlen,
+			(void *)msdu_head->data,
 			hdrlen);
-		skb_pull(info.skb, paramlen);
-		hdr = (struct ieee80211_hdr *)info.skb->data;
+		skb_pull(msdu_head, paramlen);
+		hdr = (struct ieee80211_hdr *)msdu_head->data;
 	}
 
 	/* remove trailing FCS */
@@ -1340,17 +1340,17 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	    enctype == HTT_RX_MPDU_ENCRYPT_TKIP_WPA)
 		trim += 8;
 
-	if (trim > info.skb->len) {
+	if (trim > msdu_head->len) {
 		ath10k_warn("htt rx fragment: trailer longer than the frame itself? drop\n");
-		dev_kfree_skb_any(info.skb);
+		dev_kfree_skb_any(msdu_head);
 		goto end;
 	}
 
-	skb_trim(info.skb, info.skb->len - trim);
+	skb_trim(msdu_head, msdu_head->len - trim);
 
 	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt rx frag mpdu: ",
-			info.skb->data, info.skb->len);
-	ath10k_process_rx(htt->ar, &info);
+			msdu_head->data, msdu_head->len);
+	ath10k_process_rx(htt->ar, &rx_status, msdu_head);
 
 end:
 	if (fw_desc_len > 0) {
-- 
1.7.9.5

