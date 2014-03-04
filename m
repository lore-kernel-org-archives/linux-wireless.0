Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:45066 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346AbaCDMxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 07:53:00 -0500
Received: by mail-ee0-f51.google.com with SMTP id c13so2820424eek.10
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 04:52:59 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 12/14] ath10k: kill encrypt_type from htt_rx_info
Date: Tue,  4 Mar 2014 13:52:25 +0100
Message-Id: <1393937548-7482-13-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140304_135318_885625_7AA634D2)
In-Reply-To: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setup flags directly in ieee80211_rx_status.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |    1 -
 drivers/net/wireless/ath/ath10k/htt_rx.c |   48 +++++++++++++++++++-----------
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 7ebbd8b..870f807 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1176,7 +1176,6 @@ struct htt_peer_unmap_event {
 struct htt_rx_info {
 	struct sk_buff *skb;
 	struct ieee80211_rx_status rx_status;
-	enum htt_rx_mpdu_encrypt_type encrypt_type;
 };
 
 struct ath10k_htt_txbuf {
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 976499d..555aecf 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -767,22 +767,34 @@ static bool ath10k_htt_rx_h_channel(struct ath10k *ar,
 	return true;
 }
 
-static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
+static void ath10k_htt_rx_h_protected(struct ath10k_htt *htt,
+				      struct htt_rx_info *info,
+				      enum htt_rx_mpdu_encrypt_type enctype)
 {
-	struct ieee80211_rx_status *status;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)info->skb->data;
 
-	status = IEEE80211_SKB_RXCB(info->skb);
-	memcpy(status, &info->rx_status, sizeof(*status));
-
-	if (info->encrypt_type != HTT_RX_MPDU_ENCRYPT_NONE) {
-		status->flag |= RX_FLAG_DECRYPTED | RX_FLAG_IV_STRIPPED |
-				RX_FLAG_MMIC_STRIPPED;
+	if (enctype != HTT_RX_MPDU_ENCRYPT_NONE) {
+		info->rx_status.flag |= RX_FLAG_DECRYPTED |
+					RX_FLAG_IV_STRIPPED |
+					RX_FLAG_MMIC_STRIPPED;
 		hdr->frame_control = __cpu_to_le16(
 				__le16_to_cpu(hdr->frame_control) &
-				~IEEE80211_FCTL_PROTECTED);
+					~IEEE80211_FCTL_PROTECTED);
+		return;
 	}
 
+	info->rx_status.flag &= ~(RX_FLAG_DECRYPTED |
+				  RX_FLAG_IV_STRIPPED |
+				  RX_FLAG_MMIC_STRIPPED);
+}
+
+static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
+{
+	struct ieee80211_rx_status *status;
+
+	status = IEEE80211_SKB_RXCB(info->skb);
+	memcpy(status, &info->rx_status, sizeof(*status));
+
 	ath10k_dbg(ATH10K_DBG_DATA,
 		   "rx skb %p len %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i\n",
 		   info->skb,
@@ -897,7 +909,7 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 		}
 
 		info->skb = skb;
-		info->encrypt_type = enctype;
+		ath10k_htt_rx_h_protected(htt, info, enctype);
 		skb = skb->next;
 		info->skb->next = NULL;
 
@@ -979,7 +991,7 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
 	}
 
 	info->skb = skb;
-	info->encrypt_type = enctype;
+	ath10k_htt_rx_h_protected(htt, info, enctype);
 
 	ath10k_process_rx(htt->ar, info);
 }
@@ -1243,6 +1255,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 				struct htt_rx_fragment_indication *frag)
 {
 	struct sk_buff *msdu_head, *msdu_tail;
+	enum htt_rx_mpdu_encrypt_type enctype;
 	struct htt_rx_desc *rxd;
 	enum rx_msdu_decap_format fmt;
 	struct htt_rx_info info = {};
@@ -1296,8 +1309,9 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	}
 
 	info.skb = msdu_head;
-	info.encrypt_type = MS(__le32_to_cpu(rxd->mpdu_start.info0),
-				RX_MPDU_START_INFO0_ENCRYPT_TYPE);
+	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
+		     RX_MPDU_START_INFO0_ENCRYPT_TYPE);
+	ath10k_htt_rx_h_protected(htt, &info, enctype);
 	info.skb->ip_summed = ath10k_htt_rx_get_csum_state(info.skb);
 
 	if (tkip_mic_err)
@@ -1309,9 +1323,9 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 		goto end;
 	}
 
-	if (info.encrypt_type != HTT_RX_MPDU_ENCRYPT_NONE) {
+	if (enctype != HTT_RX_MPDU_ENCRYPT_NONE) {
 		hdrlen = ieee80211_hdrlen(hdr->frame_control);
-		paramlen = ath10k_htt_rx_crypto_param_len(info.encrypt_type);
+		paramlen = ath10k_htt_rx_crypto_param_len(enctype);
 
 		/* It is more efficient to move the header than the payload */
 		memmove((void *)info.skb->data + paramlen,
@@ -1325,11 +1339,11 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
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

