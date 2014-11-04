Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:61874 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaKDOe2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 09:34:28 -0500
Received: by mail-la0-f48.google.com with SMTP id gq15so959005lab.21
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 06:34:27 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/7] ath10k: remove unused function argument
Date: Tue,  4 Nov 2014 15:22:09 +0100
Message-Id: <1415110931-10945-6-git-send-email-michal.kazior@tieto.com> (sfid-20141104_153433_329087_46835774)
In-Reply-To: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
References: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original fix has been moved into a different
place in the code.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 6abfea7..55e4568 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -306,8 +306,7 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
 /* return: < 0 fatal error, 0 - non chained msdu, 1 chained msdu */
 static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 				   u8 **fw_desc, int *fw_desc_len,
-				   struct sk_buff_head *amsdu,
-				   u32 *attention)
+				   struct sk_buff_head *amsdu)
 {
 	struct ath10k *ar = htt->ar;
 	int msdu_len, msdu_chaining = 0;
@@ -348,11 +347,6 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 			return -EIO;
 		}
 
-		*attention |= __le32_to_cpu(rx_desc->attention.flags) &
-					    (RX_ATTENTION_FLAGS_TKIP_MIC_ERR |
-					     RX_ATTENTION_FLAGS_DECRYPT_ERR |
-					     RX_ATTENTION_FLAGS_FCS_ERR |
-					     RX_ATTENTION_FLAGS_MGMT_TYPE);
 		/*
 		 * Copy the FW rx descriptor for this MSDU from the rx
 		 * indication message into the MSDU's netbuf. HL uses the
@@ -1362,7 +1356,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	struct htt_rx_indication_mpdu_range *mpdu_ranges;
 	struct sk_buff_head amsdu;
 	int num_mpdu_ranges;
-	u32 attention;
 	int fw_desc_len;
 	u8 *fw_desc;
 	bool channel_set;
@@ -1412,11 +1405,9 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 		mpdu_count += mpdu_ranges[i].mpdu_count;
 
 	while (mpdu_count--) {
-		attention = 0;
 		__skb_queue_head_init(&amsdu);
 		ret = ath10k_htt_rx_amsdu_pop(htt, &fw_desc,
-					      &fw_desc_len, &amsdu,
-					      &attention);
+					      &fw_desc_len, &amsdu);
 		if (ret < 0) {
 			ath10k_warn(ar, "rx ring became corrupted: %d\n", ret);
 			__skb_queue_purge(&amsdu);
@@ -1445,7 +1436,6 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	int ret;
 	u8 *fw_desc;
 	int fw_desc_len;
-	u32 attention = 0;
 
 	fw_desc_len = __le16_to_cpu(frag->fw_rx_desc_bytes);
 	fw_desc = (u8 *)frag->fw_msdu_rx_desc;
@@ -1454,7 +1444,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 
 	spin_lock_bh(&htt->rx_ring.lock);
 	ret = ath10k_htt_rx_amsdu_pop(htt, &fw_desc, &fw_desc_len,
-				      &amsdu, &attention);
+				      &amsdu);
 	spin_unlock_bh(&htt->rx_ring.lock);
 
 	tasklet_schedule(&htt->rx_replenish_task);
-- 
1.8.5.3

