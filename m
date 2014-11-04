Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:64507 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaKDOeZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 09:34:25 -0500
Received: by mail-lb0-f178.google.com with SMTP id f15so12620103lbj.9
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 06:34:23 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/7] ath10k: simplify Rx loop
Date: Tue,  4 Nov 2014 15:22:06 +0100
Message-Id: <1415110931-10945-3-git-send-email-michal.kazior@tieto.com> (sfid-20141104_153430_674866_BCD3E5AB)
In-Reply-To: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
References: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since htt_rx_mpdu_status isn't used anymore
(instead attention flags are used) simplify the
loop.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 80 ++++++++++++++++----------------
 1 file changed, 39 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 85f11e6..cba2f3b 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1197,8 +1197,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	int fw_desc_len;
 	u8 *fw_desc;
 	bool channel_set;
-	int i, j;
-	int ret;
+	int i, ret, mpdu_count = 0;
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
@@ -1237,51 +1236,50 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			(sizeof(struct htt_rx_indication_mpdu_range) *
 				num_mpdu_ranges));
 
-	for (i = 0; i < num_mpdu_ranges; i++) {
-		for (j = 0; j < mpdu_ranges[i].mpdu_count; j++) {
-			attention = 0;
-			__skb_queue_head_init(&amsdu);
-			ret = ath10k_htt_rx_amsdu_pop(htt, &fw_desc,
-						      &fw_desc_len, &amsdu,
-						      &attention);
-
-			if (ret < 0) {
-				ath10k_warn(ar, "failed to pop amsdu from htt rx ring %d\n",
-					    ret);
-				__skb_queue_purge(&amsdu);
-				continue;
-			}
+	for (i = 0; i < num_mpdu_ranges; i++)
+		mpdu_count += mpdu_ranges[i].mpdu_count;
+
+	while (mpdu_count--) {
+		attention = 0;
+		__skb_queue_head_init(&amsdu);
+		ret = ath10k_htt_rx_amsdu_pop(htt, &fw_desc,
+					      &fw_desc_len, &amsdu,
+					      &attention);
+		if (ret < 0) {
+			ath10k_warn(ar, "failed to pop amsdu from htt rx ring %d\n",
+				    ret);
+			__skb_queue_purge(&amsdu);
+			continue;
+		}
 
-			if (!ath10k_htt_rx_amsdu_allowed(htt, skb_peek(&amsdu),
-							 channel_set,
-							 attention)) {
-				__skb_queue_purge(&amsdu);
-				continue;
-			}
+		if (!ath10k_htt_rx_amsdu_allowed(htt, skb_peek(&amsdu),
+						 channel_set, attention)) {
+			__skb_queue_purge(&amsdu);
+			continue;
+		}
 
-			if (ret > 0 && ath10k_unchain_msdu(&amsdu) < 0) {
-				__skb_queue_purge(&amsdu);
-				continue;
-			}
+		if (ret > 0 && ath10k_unchain_msdu(&amsdu) < 0) {
+			__skb_queue_purge(&amsdu);
+			continue;
+		}
 
-			if (attention & RX_ATTENTION_FLAGS_FCS_ERR)
-				rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
-			else
-				rx_status->flag &= ~RX_FLAG_FAILED_FCS_CRC;
+		if (attention & RX_ATTENTION_FLAGS_FCS_ERR)
+			rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
+		else
+			rx_status->flag &= ~RX_FLAG_FAILED_FCS_CRC;
 
-			if (attention & RX_ATTENTION_FLAGS_TKIP_MIC_ERR)
-				rx_status->flag |= RX_FLAG_MMIC_ERROR;
-			else
-				rx_status->flag &= ~RX_FLAG_MMIC_ERROR;
+		if (attention & RX_ATTENTION_FLAGS_TKIP_MIC_ERR)
+			rx_status->flag |= RX_FLAG_MMIC_ERROR;
+		else
+			rx_status->flag &= ~RX_FLAG_MMIC_ERROR;
 
-			hdr = ath10k_htt_rx_skb_get_hdr(skb_peek(&amsdu));
+		hdr = ath10k_htt_rx_skb_get_hdr(skb_peek(&amsdu));
 
-			if (ath10k_htt_rx_hdr_is_amsdu(hdr))
-				ath10k_htt_rx_amsdu(htt, rx_status, &amsdu);
-			else
-				ath10k_htt_rx_msdu(htt, rx_status,
-						   __skb_dequeue(&amsdu));
-		}
+		if (ath10k_htt_rx_hdr_is_amsdu(hdr))
+			ath10k_htt_rx_amsdu(htt, rx_status, &amsdu);
+		else
+			ath10k_htt_rx_msdu(htt, rx_status,
+					   __skb_dequeue(&amsdu));
 	}
 
 	tasklet_schedule(&htt->rx_replenish_task);
-- 
1.8.5.3

