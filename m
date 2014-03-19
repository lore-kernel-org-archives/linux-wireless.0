Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:37237 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933853AbaCSNw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 09:52:29 -0400
Received: by mail-ee0-f43.google.com with SMTP id e53so6601971eek.16
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2014 06:52:27 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC] ath10k: fix rssi and rate reporting
Date: Wed, 19 Mar 2014 14:52:15 +0100
Message-Id: <1395237135-18159-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140319_145236_155804_320268D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RSSI and RATE fields are valid only when
START_VALID bit is set.
So, in current implementation we have to remember
rssi and rates we have when START_VALID and report
the same also when END_VALID bit is set.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |    3 +++
 drivers/net/wireless/ath/ath10k/htt_rx.c |   41 +++++++++++++++---------------
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 870f807..bd3e537 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1278,6 +1278,9 @@ struct ath10k_htt {
 	struct tasklet_struct txrx_compl_task;
 	struct sk_buff_head tx_compl_q;
 	struct sk_buff_head rx_compl_q;
+
+	/* rx_info template */
+	struct htt_rx_info rx_info;
 };
 
 #define RX_HTT_HDR_STATUS_LEN 64
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 665a256..6e33475 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1128,7 +1128,6 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				  struct htt_rx_indication *rx)
 {
-	struct htt_rx_info info;
 	struct htt_rx_indication_mpdu_range *mpdu_ranges;
 	struct htt_rx_desc *rxd;
 	enum htt_rx_mpdu_status status;
@@ -1143,7 +1142,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
-	memset(&info, 0, sizeof(info));
 
 	fw_desc_len = __le16_to_cpu(rx->prefix.fw_rx_desc_bytes);
 	fw_desc = (u8 *)&rx->fw_desc;
@@ -1153,24 +1151,27 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	mpdu_ranges = htt_rx_ind_get_mpdu_ranges(rx);
 
 	/* Fill this once, while this is per-ppdu */
-	info.rx_status.signal  = ATH10K_DEFAULT_NOISE_FLOOR;
-	info.rx_status.signal += rx->ppdu.combined_rssi;
+	if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_START_VALID) {
+		memset(&htt->rx_info, 0, sizeof(htt->rx_info));
+		htt->rx_info.rx_status.signal  = ATH10K_DEFAULT_NOISE_FLOOR;
+		htt->rx_info.rx_status.signal += rx->ppdu.combined_rssi;
+	}
 
 	if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
 		/* TSF available only in 32-bit */
-		info.rx_status.mactime =
+		htt->rx_info.rx_status.mactime =
 				__le32_to_cpu(rx->ppdu.tsf) & 0xffffffff;
-		info.rx_status.flag |= RX_FLAG_MACTIME_END;
+		htt->rx_info.rx_status.flag |= RX_FLAG_MACTIME_END;
 	}
 
-	channel_set = ath10k_htt_rx_h_channel(htt->ar, &info.rx_status);
+	channel_set = ath10k_htt_rx_h_channel(htt->ar, &htt->rx_info.rx_status);
 
 	if (channel_set) {
-		ath10k_htt_rx_h_rates(htt->ar, info.rx_status.band,
+		ath10k_htt_rx_h_rates(htt->ar, htt->rx_info.rx_status.band,
 				      rx->ppdu.info0,
 				      __le32_to_cpu(rx->ppdu.info1),
 				      __le32_to_cpu(rx->ppdu.info2),
-				      &info.rx_status);
+				      &htt->rx_info.rx_status);
 	}
 
 	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt rx ind: ",
@@ -1218,24 +1219,24 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				continue;
 			}
 
-			info.skb     = msdu_head;
+			htt->rx_info.skb     = msdu_head;
 
 			/* Clean per-mpdu specyfic flags */
-			info.rx_status.flag &= ~(RX_FLAG_AMSDU_MORE |
-						 RX_FLAG_FAILED_FCS_CRC |
-						 RX_FLAG_MMIC_ERROR |
-						 RX_FLAG_DECRYPTED |
-						 RX_FLAG_IV_STRIPPED |
-						 RX_FLAG_MMIC_STRIPPED);
+			htt->rx_info.rx_status.flag &= ~(RX_FLAG_AMSDU_MORE |
+							 RX_FLAG_FAILED_FCS_CRC |
+							 RX_FLAG_MMIC_ERROR |
+							 RX_FLAG_DECRYPTED |
+							 RX_FLAG_IV_STRIPPED |
+							 RX_FLAG_MMIC_STRIPPED);
 
 			if (attention & RX_ATTENTION_FLAGS_FCS_ERR) {
-				info.rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+				htt->rx_info.rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 				ath10k_dbg(ATH10K_DBG_HTT,
 					   "htt rx has FCS err\n");
 			}
 
 			if (attention & RX_ATTENTION_FLAGS_TKIP_MIC_ERR) {
-				info.rx_status.flag |= RX_FLAG_MMIC_ERROR;
+				htt->rx_info.rx_status.flag |= RX_FLAG_MMIC_ERROR;
 				ath10k_dbg(ATH10K_DBG_HTT,
 					   "htt rx has MIC err\n");
 			}
@@ -1243,9 +1244,9 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			hdr = ath10k_htt_rx_skb_get_hdr(msdu_head);
 
 			if (ath10k_htt_rx_hdr_is_amsdu(hdr))
-				ath10k_htt_rx_amsdu(htt, &info);
+				ath10k_htt_rx_amsdu(htt, &htt->rx_info);
 			else
-				ath10k_htt_rx_msdu(htt, &info);
+				ath10k_htt_rx_msdu(htt, &htt->rx_info);
 		}
 	}
 
-- 
1.7.9.5

