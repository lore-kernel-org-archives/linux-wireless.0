Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:43531 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751897AbdJXRy0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Oct 2017 13:54:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH v2] ath10k: rebuild crypto header in Rx data frames
Date: Tue, 24 Oct 2017 20:54:12 +0300
Message-ID: <1508867652-16199-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20171024_195652_895140_779D21B1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Rx data frames notified through HTT_T2H_MSG_TYPE_RX_IND and
HTT_T2H_MSG_TYPE_RX_FRAG_IND expect PN/TSC check to be done
on host (mac80211) rather than firmware. Rebuild cipher header
in every received data frames (that are notified through those
HTT interfaces) from the rx_hdr_status tlv available in the
rx descriptor of the first msdu. Skip setting RX_FLAG_IV_STRIPPED
flag for the packets which requires mac80211 PN/TSC check support
and set appropriate RX_FLAG for stripped crypto tail. Hw QCA988X,
QCA9887, QCA99X0, QCA9984, QCA9888 and QCA4019 currently need the
rebuilding of cipher header to perform PN/TSC check for replay
attack.

Tested-by: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---

v2:

* Construct cipher header from rx_hdr_status tlv rather than from
  the msdu_start and mpdu_start tlvs. This fixes connection
  issues, also reduces the amount of code change.

* Make sure the frame is qos data before clearing AMSDU_PRESENT
  bit of qos control field.

* Fix traffic issue with QCA988X and QCA9887 hw by taking care of
  padding bytes added for 4-byte alignment before the cipher
  header.

TODO:

* CCMP-256 and GCMP/GCMP-256 are not yet supported 

 drivers/net/wireless/ath/ath10k/htt_rx.c | 91 ++++++++++++++++++++++++++------
 1 file changed, 74 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a3f5dc78353f..aae4f0ea9360 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1050,8 +1050,14 @@ static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
 
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
 
@@ -1075,7 +1081,8 @@ static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
 static void ath10k_htt_rx_h_undecap_nwifi(struct ath10k *ar,
 					  struct sk_buff *msdu,
 					  struct ieee80211_rx_status *status,
-					  const u8 first_hdr[64])
+					  const u8 first_hdr[64],
+					  enum htt_rx_mpdu_encrypt_type enctype)
 {
 	struct ieee80211_hdr *hdr;
 	struct htt_rx_desc *rxd;
@@ -1083,6 +1090,7 @@ static void ath10k_htt_rx_h_undecap_nwifi(struct ath10k *ar,
 	u8 da[ETH_ALEN];
 	u8 sa[ETH_ALEN];
 	int l3_pad_bytes;
+	int bytes_aligned = ar->hw_params.decap_align_bytes;
 
 	/* Delivered decapped frame:
 	 * [nwifi 802.11 header] <-- replaced with 802.11 hdr
@@ -1111,6 +1119,14 @@ static void ath10k_htt_rx_h_undecap_nwifi(struct ath10k *ar,
 	/* push original 802.11 header */
 	hdr = (struct ieee80211_hdr *)first_hdr;
 	hdr_len = ieee80211_hdrlen(hdr->frame_control);
+
+	if (!(status->flag & RX_FLAG_IV_STRIPPED)) {
+		memcpy(skb_push(msdu,
+				ath10k_htt_rx_crypto_param_len(ar, enctype)),
+		       (void *)hdr + round_up(hdr_len, bytes_aligned),
+			ath10k_htt_rx_crypto_param_len(ar, enctype));
+	}
+
 	memcpy(skb_push(msdu, hdr_len), hdr, hdr_len);
 
 	/* original 802.11 header has a different DA and in
@@ -1171,6 +1187,7 @@ static void ath10k_htt_rx_h_undecap_eth(struct ath10k *ar,
 	u8 sa[ETH_ALEN];
 	int l3_pad_bytes;
 	struct htt_rx_desc *rxd;
+	int bytes_aligned = ar->hw_params.decap_align_bytes;
 
 	/* Delivered decapped frame:
 	 * [eth header] <-- replaced with 802.11 hdr & rfc1042/llc
@@ -1199,6 +1216,14 @@ static void ath10k_htt_rx_h_undecap_eth(struct ath10k *ar,
 	/* push original 802.11 header */
 	hdr = (struct ieee80211_hdr *)first_hdr;
 	hdr_len = ieee80211_hdrlen(hdr->frame_control);
+
+	if (!(status->flag & RX_FLAG_IV_STRIPPED)) {
+		memcpy(skb_push(msdu,
+				ath10k_htt_rx_crypto_param_len(ar, enctype)),
+		       (void *)hdr + round_up(hdr_len, bytes_aligned),
+			ath10k_htt_rx_crypto_param_len(ar, enctype));
+	}
+
 	memcpy(skb_push(msdu, hdr_len), hdr, hdr_len);
 
 	/* original 802.11 header has a different DA and in
@@ -1212,12 +1237,14 @@ static void ath10k_htt_rx_h_undecap_eth(struct ath10k *ar,
 static void ath10k_htt_rx_h_undecap_snap(struct ath10k *ar,
 					 struct sk_buff *msdu,
 					 struct ieee80211_rx_status *status,
-					 const u8 first_hdr[64])
+					 const u8 first_hdr[64],
+					 enum htt_rx_mpdu_encrypt_type enctype)
 {
 	struct ieee80211_hdr *hdr;
 	size_t hdr_len;
 	int l3_pad_bytes;
 	struct htt_rx_desc *rxd;
+	int bytes_aligned = ar->hw_params.decap_align_bytes;
 
 	/* Delivered decapped frame:
 	 * [amsdu header] <-- replaced with 802.11 hdr
@@ -1233,6 +1260,14 @@ static void ath10k_htt_rx_h_undecap_snap(struct ath10k *ar,
 
 	hdr = (struct ieee80211_hdr *)first_hdr;
 	hdr_len = ieee80211_hdrlen(hdr->frame_control);
+
+	if (!(status->flag & RX_FLAG_IV_STRIPPED)) {
+		memcpy(skb_push(msdu,
+				ath10k_htt_rx_crypto_param_len(ar, enctype)),
+		       (void *)hdr + round_up(hdr_len, bytes_aligned),
+			ath10k_htt_rx_crypto_param_len(ar, enctype));
+	}
+
 	memcpy(skb_push(msdu, hdr_len), hdr, hdr_len);
 }
 
@@ -1267,13 +1302,15 @@ static void ath10k_htt_rx_h_undecap(struct ath10k *ar,
 					    is_decrypted);
 		break;
 	case RX_MSDU_DECAP_NATIVE_WIFI:
-		ath10k_htt_rx_h_undecap_nwifi(ar, msdu, status, first_hdr);
+		ath10k_htt_rx_h_undecap_nwifi(ar, msdu, status, first_hdr,
+					      enctype);
 		break;
 	case RX_MSDU_DECAP_ETHERNET2_DIX:
 		ath10k_htt_rx_h_undecap_eth(ar, msdu, status, first_hdr, enctype);
 		break;
 	case RX_MSDU_DECAP_8023_SNAP_LLC:
-		ath10k_htt_rx_h_undecap_snap(ar, msdu, status, first_hdr);
+		ath10k_htt_rx_h_undecap_snap(ar, msdu, status, first_hdr,
+					     enctype);
 		break;
 	}
 }
@@ -1316,7 +1353,8 @@ static void ath10k_htt_rx_h_csum_offload(struct sk_buff *msdu)
 
 static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 				 struct sk_buff_head *amsdu,
-				 struct ieee80211_rx_status *status)
+				 struct ieee80211_rx_status *status,
+				 bool fill_crypt_header)
 {
 	struct sk_buff *first;
 	struct sk_buff *last;
@@ -1326,7 +1364,6 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 	enum htt_rx_mpdu_encrypt_type enctype;
 	u8 first_hdr[64];
 	u8 *qos;
-	size_t hdr_len;
 	bool has_fcs_err;
 	bool has_crypto_err;
 	bool has_tkip_err;
@@ -1351,15 +1388,17 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 	 * decapped header. It'll be used for undecapping of each MSDU.
 	 */
 	hdr = (void *)rxd->rx_hdr_status;
-	hdr_len = ieee80211_hdrlen(hdr->frame_control);
-	memcpy(first_hdr, hdr, hdr_len);
+	memcpy(first_hdr, hdr, RX_HTT_HDR_STATUS_LEN);
 
 	/* Each A-MSDU subframe will use the original header as the base and be
 	 * reported as a separate MSDU so strip the A-MSDU bit from QoS Ctl.
 	 */
 	hdr = (void *)first_hdr;
-	qos = ieee80211_get_qos_ctl(hdr);
-	qos[0] &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		qos = ieee80211_get_qos_ctl(hdr);
+		qos[0] &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+	}
 
 	/* Some attention flags are valid only in the last MSDU. */
 	last = skb_peek_tail(amsdu);
@@ -1406,9 +1445,14 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 		status->flag |= RX_FLAG_DECRYPTED;
 
 		if (likely(!is_mgmt))
-			status->flag |= RX_FLAG_IV_STRIPPED |
-					RX_FLAG_MMIC_STRIPPED;
-}
+			status->flag |= RX_FLAG_MMIC_STRIPPED;
+
+		if (fill_crypt_header)
+			status->flag |= RX_FLAG_MIC_STRIPPED |
+					RX_FLAG_ICV_STRIPPED;
+		else
+			status->flag |= RX_FLAG_IV_STRIPPED;
+	}
 
 	skb_queue_walk(amsdu, msdu) {
 		ath10k_htt_rx_h_csum_offload(msdu);
@@ -1424,6 +1468,9 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 		if (is_mgmt)
 			continue;
 
+		if (fill_crypt_header)
+			continue;
+
 		hdr = (void *)msdu->data;
 		hdr->frame_control &= ~__cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 	}
@@ -1434,6 +1481,9 @@ static void ath10k_htt_rx_h_deliver(struct ath10k *ar,
 				    struct ieee80211_rx_status *status)
 {
 	struct sk_buff *msdu;
+	struct sk_buff *first_subframe;
+
+	first_subframe = skb_peek(amsdu);
 
 	while ((msdu = __skb_dequeue(amsdu))) {
 		/* Setup per-MSDU flags */
@@ -1442,6 +1492,13 @@ static void ath10k_htt_rx_h_deliver(struct ath10k *ar,
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
@@ -1584,7 +1641,7 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
 		ath10k_htt_rx_h_unchain(ar, &amsdu);
 
 	ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
-	ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);
+	ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status, true);
 	ath10k_htt_rx_h_deliver(ar, &amsdu, rx_status);
 
 	return num_msdus;
@@ -1923,7 +1980,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb,
 			budget_left -= skb_queue_len(&amsdu);
 			ath10k_htt_rx_h_ppdu(ar, &amsdu, status, vdev_id);
 			ath10k_htt_rx_h_filter(ar, &amsdu, status);
-			ath10k_htt_rx_h_mpdu(ar, &amsdu, status);
+			ath10k_htt_rx_h_mpdu(ar, &amsdu, status, false);
 			ath10k_htt_rx_h_deliver(ar, &amsdu, status);
 			break;
 		case -EAGAIN:
-- 
2.7.4
