Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:17452 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753200AbdJTQ2h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Oct 2017 12:28:37 -0400
Subject: [PATCH] ath10k: rebuild crypto header in RX data frames
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 20 Oct 2017 19:28:26 +0300
Message-ID: <150851690590.5158.11970481736247725763.stgit@potku.adurom.net> (sfid-20171020_182856_286263_6BDC5610)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

RX data frames notified through HTT_T2H_MSG_TYPE_RX_IND and
HTT_T2H_MSG_TYPE_RX_FRAG_IND expect PN/TSC check to be done
on host (mac80211) rather than firmware. Rebuild cipher header
in every received data frames (that are notified through those
HTT interfaces) from the PN/TSC and key_id information available
from rx descriptor of the first msdu of each mpdu. Skip setting
RX_FLAG_IV_STRIPPED flag for the packets which requires mac80211
PN/TSC check support and set appropriate RX_FLAG for stripped
crypto tail. QCA988X, QCA9887, QCA99X0, QCA9984, QCA9888 and
QCA4019 currently need the rebuilding of cipher header to perform
PN/TSC check for replay attack.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |  120 ++++++++++++++++++++++++++----
 1 file changed, 104 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a3f5dc78353f..9a070ad05179 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -995,8 +995,55 @@ static int ath10k_htt_rx_nwifi_hdrlen(struct ath10k *ar,
 	return len;
 }
 
+static void ath10k_htt_rx_build_crypto_hdr(struct ath10k *ar,
+					   struct sk_buff *msdu,
+					   struct htt_rx_desc *rxd,
+					   struct ieee80211_rx_status *status,
+					   enum htt_rx_mpdu_encrypt_type type)
+{
+	u8 *hdr;
+
+	if (!(status->flag & RX_FLAG_DECRYPTED) ||
+	    status->flag & RX_FLAG_IV_STRIPPED)
+		return;
+
+	switch (type) {
+	case HTT_RX_MPDU_ENCRYPT_NONE:
+		return;
+	case HTT_RX_MPDU_ENCRYPT_WEP40:
+	case HTT_RX_MPDU_ENCRYPT_WEP104:
+		hdr = skb_push(msdu, IEEE80211_WEP_IV_LEN);
+		memcpy(hdr, rxd->mpdu_start.pn, IEEE80211_WEP_IV_LEN - 1);
+		hdr[3] = rxd->msdu_end.common.key_id_octet;
+		return;
+	case HTT_RX_MPDU_ENCRYPT_TKIP_WITHOUT_MIC:
+	case HTT_RX_MPDU_ENCRYPT_TKIP_WPA:
+		hdr = skb_push(msdu, IEEE80211_TKIP_IV_LEN);
+		hdr[0] = rxd->mpdu_start.pn[1];
+		hdr[1] = 0;
+		hdr[2] = rxd->mpdu_start.pn[0];
+		hdr[3] = 0x20 | (rxd->msdu_end.common.key_id_octet << 6);
+		memcpy(hdr + 4, rxd->mpdu_start.pn + 2, 4);
+		return;
+	case HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2:
+		hdr = skb_push(msdu, IEEE80211_CCMP_HDR_LEN);
+		memcpy(hdr, rxd->mpdu_start.pn, 2);
+		hdr[2] = 0;
+		hdr[3] = 0x20 | (rxd->msdu_end.common.key_id_octet << 6);
+		memcpy(hdr + 4, rxd->mpdu_start.pn + 2, 4);
+		return;
+	case HTT_RX_MPDU_ENCRYPT_WEP128:
+	case HTT_RX_MPDU_ENCRYPT_WAPI:
+		return;
+	default:
+		ath10k_warn(ar, "unsupported encryption type %d\n", type);
+		return;
+	}
+}
+
 static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
 					struct sk_buff *msdu,
+					struct htt_rx_desc *first_rxd,
 					struct ieee80211_rx_status *status,
 					enum htt_rx_mpdu_encrypt_type enctype,
 					bool is_decrypted)
@@ -1050,8 +1097,14 @@ static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
 
 	hdr = (void *)msdu->data;
 
-	/* Tail */
-	if (status->flag & RX_FLAG_IV_STRIPPED)
+	/* MIC */
+	if ((status->flag & RX_FLAG_MIC_STRIPPED) &&
+	    enctype == HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2)
+		skb_trim(msdu, msdu->len - 8);
+
+	/* ICV */
+	if (status->flag & RX_FLAG_ICV_STRIPPED &&
+	    enctype != HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2)
 		skb_trim(msdu, msdu->len -
 			 ath10k_htt_rx_crypto_tail_len(ar, enctype));
 
@@ -1075,7 +1128,9 @@ static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
 static void ath10k_htt_rx_h_undecap_nwifi(struct ath10k *ar,
 					  struct sk_buff *msdu,
 					  struct ieee80211_rx_status *status,
-					  const u8 first_hdr[64])
+					  struct htt_rx_desc *first_rxd,
+					  const u8 first_hdr[64],
+					  enum htt_rx_mpdu_encrypt_type enctype)
 {
 	struct ieee80211_hdr *hdr;
 	struct htt_rx_desc *rxd;
@@ -1108,6 +1163,8 @@ static void ath10k_htt_rx_h_undecap_nwifi(struct ath10k *ar,
 	ether_addr_copy(sa, ieee80211_get_SA(hdr));
 	skb_pull(msdu, hdr_len);
 
+	ath10k_htt_rx_build_crypto_hdr(ar, msdu, first_rxd, status, enctype);
+
 	/* push original 802.11 header */
 	hdr = (struct ieee80211_hdr *)first_hdr;
 	hdr_len = ieee80211_hdrlen(hdr->frame_control);
@@ -1160,6 +1217,7 @@ static void *ath10k_htt_rx_h_find_rfc1042(struct ath10k *ar,
 static void ath10k_htt_rx_h_undecap_eth(struct ath10k *ar,
 					struct sk_buff *msdu,
 					struct ieee80211_rx_status *status,
+					struct htt_rx_desc *first_rxd,
 					const u8 first_hdr[64],
 					enum htt_rx_mpdu_encrypt_type enctype)
 {
@@ -1196,6 +1254,8 @@ static void ath10k_htt_rx_h_undecap_eth(struct ath10k *ar,
 	memcpy(skb_push(msdu, sizeof(struct rfc1042_hdr)), rfc1042,
 	       sizeof(struct rfc1042_hdr));
 
+	ath10k_htt_rx_build_crypto_hdr(ar, msdu, first_rxd, status, enctype);
+
 	/* push original 802.11 header */
 	hdr = (struct ieee80211_hdr *)first_hdr;
 	hdr_len = ieee80211_hdrlen(hdr->frame_control);
@@ -1212,7 +1272,9 @@ static void ath10k_htt_rx_h_undecap_eth(struct ath10k *ar,
 static void ath10k_htt_rx_h_undecap_snap(struct ath10k *ar,
 					 struct sk_buff *msdu,
 					 struct ieee80211_rx_status *status,
-					 const u8 first_hdr[64])
+					 struct htt_rx_desc *first_rxd,
+					 const u8 first_hdr[64],
+					 enum htt_rx_mpdu_encrypt_type enctype)
 {
 	struct ieee80211_hdr *hdr;
 	size_t hdr_len;
@@ -1231,6 +1293,8 @@ static void ath10k_htt_rx_h_undecap_snap(struct ath10k *ar,
 	skb_put(msdu, l3_pad_bytes);
 	skb_pull(msdu, sizeof(struct amsdu_subframe_hdr) + l3_pad_bytes);
 
+	ath10k_htt_rx_build_crypto_hdr(ar, msdu, first_rxd, status, enctype);
+
 	hdr = (struct ieee80211_hdr *)first_hdr;
 	hdr_len = ieee80211_hdrlen(hdr->frame_control);
 	memcpy(skb_push(msdu, hdr_len), hdr, hdr_len);
@@ -1240,6 +1304,7 @@ static void ath10k_htt_rx_h_undecap(struct ath10k *ar,
 				    struct sk_buff *msdu,
 				    struct ieee80211_rx_status *status,
 				    u8 first_hdr[64],
+				    struct htt_rx_desc *first_rxd,
 				    enum htt_rx_mpdu_encrypt_type enctype,
 				    bool is_decrypted)
 {
@@ -1263,17 +1328,20 @@ static void ath10k_htt_rx_h_undecap(struct ath10k *ar,
 
 	switch (decap) {
 	case RX_MSDU_DECAP_RAW:
-		ath10k_htt_rx_h_undecap_raw(ar, msdu, status, enctype,
-					    is_decrypted);
+		ath10k_htt_rx_h_undecap_raw(ar, msdu, first_rxd, status,
+					    enctype, is_decrypted);
 		break;
 	case RX_MSDU_DECAP_NATIVE_WIFI:
-		ath10k_htt_rx_h_undecap_nwifi(ar, msdu, status, first_hdr);
+		ath10k_htt_rx_h_undecap_nwifi(ar, msdu, status, first_rxd,
+					      first_hdr, enctype);
 		break;
 	case RX_MSDU_DECAP_ETHERNET2_DIX:
-		ath10k_htt_rx_h_undecap_eth(ar, msdu, status, first_hdr, enctype);
+		ath10k_htt_rx_h_undecap_eth(ar, msdu, status, first_rxd,
+					    first_hdr, enctype);
 		break;
 	case RX_MSDU_DECAP_8023_SNAP_LLC:
-		ath10k_htt_rx_h_undecap_snap(ar, msdu, status, first_hdr);
+		ath10k_htt_rx_h_undecap_snap(ar, msdu, status, first_rxd,
+					     first_hdr, enctype);
 		break;
 	}
 }
@@ -1316,7 +1384,8 @@ static void ath10k_htt_rx_h_csum_offload(struct sk_buff *msdu)
 
 static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 				 struct sk_buff_head *amsdu,
-				 struct ieee80211_rx_status *status)
+				 struct ieee80211_rx_status *status,
+				 bool fill_crypt_header)
 {
 	struct sk_buff *first;
 	struct sk_buff *last;
@@ -1406,14 +1475,20 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 		status->flag |= RX_FLAG_DECRYPTED;
 
 		if (likely(!is_mgmt))
-			status->flag |= RX_FLAG_IV_STRIPPED |
-					RX_FLAG_MMIC_STRIPPED;
+			status->flag |= RX_FLAG_MMIC_STRIPPED;
+
+		if (fill_crypt_header)
+			status->flag |= RX_FLAG_MIC_STRIPPED |
+					RX_FLAG_ICV_STRIPPED;
+		else
+			status->flag |= RX_FLAG_IV_STRIPPED;
 }
 
 	skb_queue_walk(amsdu, msdu) {
 		ath10k_htt_rx_h_csum_offload(msdu);
-		ath10k_htt_rx_h_undecap(ar, msdu, status, first_hdr, enctype,
-					is_decrypted);
+		ath10k_htt_rx_h_undecap(ar, msdu, status, first_hdr,
+					(void *)first->data - sizeof(*rxd),
+					enctype, is_decrypted);
 
 		/* Undecapping involves copying the original 802.11 header back
 		 * to sk_buff. If frame is protected and hardware has decrypted
@@ -1424,6 +1499,9 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 		if (is_mgmt)
 			continue;
 
+		if (fill_crypt_header)
+			continue;
+
 		hdr = (void *)msdu->data;
 		hdr->frame_control &= ~__cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 	}
@@ -1434,6 +1512,9 @@ static void ath10k_htt_rx_h_deliver(struct ath10k *ar,
 				    struct ieee80211_rx_status *status)
 {
 	struct sk_buff *msdu;
+	struct sk_buff *first_subframe;
+
+	first_subframe = skb_peek(amsdu);
 
 	while ((msdu = __skb_dequeue(amsdu))) {
 		/* Setup per-MSDU flags */
@@ -1442,6 +1523,13 @@ static void ath10k_htt_rx_h_deliver(struct ath10k *ar,
 		else
 			status->flag |= RX_FLAG_AMSDU_MORE;
 
+		if (msdu == first_subframe) {
+			first_subframe = NULL;
+			status->flag &= ~RX_FLAG_ALLOW_SAME_PN;
+		} else {
+			status->flag |= RX_FLAG_ALLOW_SAME_PN;
+		}
+
 		ath10k_process_rx(ar, status, msdu);
 	}
 }
@@ -1584,7 +1672,7 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
 		ath10k_htt_rx_h_unchain(ar, &amsdu);
 
 	ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
-	ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);
+	ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status, true);
 	ath10k_htt_rx_h_deliver(ar, &amsdu, rx_status);
 
 	return num_msdus;
@@ -1923,7 +2011,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb,
 			budget_left -= skb_queue_len(&amsdu);
 			ath10k_htt_rx_h_ppdu(ar, &amsdu, status, vdev_id);
 			ath10k_htt_rx_h_filter(ar, &amsdu, status);
-			ath10k_htt_rx_h_mpdu(ar, &amsdu, status);
+			ath10k_htt_rx_h_mpdu(ar, &amsdu, status, false);
 			ath10k_htt_rx_h_deliver(ar, &amsdu, status);
 			break;
 		case -EAGAIN:
