Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:34207 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaCXUZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 16:25:11 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so4860131eek.24
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 13:25:10 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 1/2] ath10k: introduce rx_status htt template
Date: Mon, 24 Mar 2014 21:24:57 +0100
Message-Id: <1395692698-4745-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140324_212516_379773_75BB2F81)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce rx_status htt template instead of
stack version, as a preparation for fix
rssi and rates reporting.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |    3 +++
 drivers/net/wireless/ath/ath10k/htt_rx.c |   36 +++++++++++++++---------------
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 2d669c0..645a563 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1273,6 +1273,9 @@ struct ath10k_htt {
 	struct tasklet_struct txrx_compl_task;
 	struct sk_buff_head tx_compl_q;
 	struct sk_buff_head rx_compl_q;
+
+	/* rx_status template */
+	struct ieee80211_rx_status rx_status;
 };
 
 #define RX_HTT_HDR_STATUS_LEN 64
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 17f152c..be25e16 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1139,7 +1139,7 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				  struct htt_rx_indication *rx)
 {
-	struct ieee80211_rx_status rx_status;
+	struct ieee80211_rx_status *rx_status = &htt->rx_status;
 	struct htt_rx_indication_mpdu_range *mpdu_ranges;
 	struct htt_rx_desc *rxd;
 	enum htt_rx_mpdu_status status;
@@ -1154,7 +1154,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
-	memset(&rx_status, 0, sizeof(rx_status));
+	memset(rx_status, 0, sizeof(*rx_status));
 
 	fw_desc_len = __le16_to_cpu(rx->prefix.fw_rx_desc_bytes);
 	fw_desc = (u8 *)&rx->fw_desc;
@@ -1164,23 +1164,23 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	mpdu_ranges = htt_rx_ind_get_mpdu_ranges(rx);
 
 	/* Fill this once, while this is per-ppdu */
-	rx_status.signal  = ATH10K_DEFAULT_NOISE_FLOOR;
-	rx_status.signal += rx->ppdu.combined_rssi;
+	rx_status->signal  = ATH10K_DEFAULT_NOISE_FLOOR;
+	rx_status->signal += rx->ppdu.combined_rssi;
 
 	if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
 		/* TSF available only in 32-bit */
-		rx_status.mactime = __le32_to_cpu(rx->ppdu.tsf) & 0xffffffff;
-		rx_status.flag |= RX_FLAG_MACTIME_END;
+		rx_status->mactime = __le32_to_cpu(rx->ppdu.tsf) & 0xffffffff;
+		rx_status->flag |= RX_FLAG_MACTIME_END;
 	}
 
-	channel_set = ath10k_htt_rx_h_channel(htt->ar, &rx_status);
+	channel_set = ath10k_htt_rx_h_channel(htt->ar, rx_status);
 
 	if (channel_set) {
-		ath10k_htt_rx_h_rates(htt->ar, rx_status.band,
+		ath10k_htt_rx_h_rates(htt->ar, rx_status->band,
 				      rx->ppdu.info0,
 				      __le32_to_cpu(rx->ppdu.info1),
 				      __le32_to_cpu(rx->ppdu.info2),
-				      &rx_status);
+				      rx_status);
 	}
 
 	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt rx ind: ",
@@ -1229,21 +1229,21 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			}
 
 			if (attention & RX_ATTENTION_FLAGS_FCS_ERR)
-				rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+				rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 			else
-				rx_status.flag &= ~RX_FLAG_FAILED_FCS_CRC;
+				rx_status->flag &= ~RX_FLAG_FAILED_FCS_CRC;
 
 			if (attention & RX_ATTENTION_FLAGS_TKIP_MIC_ERR)
-				rx_status.flag |= RX_FLAG_MMIC_ERROR;
+				rx_status->flag |= RX_FLAG_MMIC_ERROR;
 			else
-				rx_status.flag &= ~RX_FLAG_MMIC_ERROR;
+				rx_status->flag &= ~RX_FLAG_MMIC_ERROR;
 
 			hdr = ath10k_htt_rx_skb_get_hdr(msdu_head);
 
 			if (ath10k_htt_rx_hdr_is_amsdu(hdr))
-				ath10k_htt_rx_amsdu(htt, &rx_status, msdu_head);
+				ath10k_htt_rx_amsdu(htt, rx_status, msdu_head);
 			else
-				ath10k_htt_rx_msdu(htt, &rx_status, msdu_head);
+				ath10k_htt_rx_msdu(htt, rx_status, msdu_head);
 		}
 	}
 
@@ -1257,7 +1257,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	enum htt_rx_mpdu_encrypt_type enctype;
 	struct htt_rx_desc *rxd;
 	enum rx_msdu_decap_format fmt;
-	struct ieee80211_rx_status rx_status = {};
+	struct ieee80211_rx_status *rx_status = &htt->rx_status;
 	struct ieee80211_hdr *hdr;
 	int ret;
 	bool tkip_mic_err;
@@ -1305,7 +1305,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 
 	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
 		     RX_MPDU_START_INFO0_ENCRYPT_TYPE);
-	ath10k_htt_rx_h_protected(htt, &rx_status, msdu_head, enctype);
+	ath10k_htt_rx_h_protected(htt, rx_status, msdu_head, enctype);
 	msdu_head->ip_summed = ath10k_htt_rx_get_csum_state(msdu_head);
 
 	if (tkip_mic_err)
@@ -1350,7 +1350,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 
 	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt rx frag mpdu: ",
 			msdu_head->data, msdu_head->len);
-	ath10k_process_rx(htt->ar, &rx_status, msdu_head);
+	ath10k_process_rx(htt->ar, rx_status, msdu_head);
 
 end:
 	if (fw_desc_len > 0) {
-- 
1.7.9.5

