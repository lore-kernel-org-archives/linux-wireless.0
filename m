Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57489 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbcCVLxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 07:53:21 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 3/9] ath10k: remove unused fw_desc processing
Date: Tue, 22 Mar 2016 17:22:13 +0530
Message-ID: <1458647539-17213-4-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160322_125324_217135_AEAC5CF7)
In-Reply-To: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fw descriptor was never used and probably never will be. It makes
little sense to maintain support for it. Remove it and simplify rx
processing. This will make it easier to optimize rx processing later
as well.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 65 +-------------------------------
 1 file changed, 2 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index b888e3a..abb712f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -281,7 +281,6 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
 
 /* return: < 0 fatal error, 0 - non chained msdu, 1 chained msdu */
 static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
-				   u8 **fw_desc, int *fw_desc_len,
 				   struct sk_buff_head *amsdu)
 {
 	struct ath10k *ar = htt->ar;
@@ -323,48 +322,6 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 			return -EIO;
 		}
 
-		/*
-		 * Copy the FW rx descriptor for this MSDU from the rx
-		 * indication message into the MSDU's netbuf. HL uses the
-		 * same rx indication message definition as LL, and simply
-		 * appends new info (fields from the HW rx desc, and the
-		 * MSDU payload itself). So, the offset into the rx
-		 * indication message only has to account for the standard
-		 * offset of the per-MSDU FW rx desc info within the
-		 * message, and how many bytes of the per-MSDU FW rx desc
-		 * info have already been consumed. (And the endianness of
-		 * the host, since for a big-endian host, the rx ind
-		 * message contents, including the per-MSDU rx desc bytes,
-		 * were byteswapped during upload.)
-		 */
-		if (*fw_desc_len > 0) {
-			rx_desc->fw_desc.info0 = **fw_desc;
-			/*
-			 * The target is expected to only provide the basic
-			 * per-MSDU rx descriptors. Just to be sure, verify
-			 * that the target has not attached extension data
-			 * (e.g. LRO flow ID).
-			 */
-
-			/* or more, if there's extension data */
-			(*fw_desc)++;
-			(*fw_desc_len)--;
-		} else {
-			/*
-			 * When an oversized AMSDU happened, FW will lost
-			 * some of MSDU status - in this case, the FW
-			 * descriptors provided will be less than the
-			 * actual MSDUs inside this MPDU. Mark the FW
-			 * descriptors so that it will still deliver to
-			 * upper stack, if no CRC error for this MPDU.
-			 *
-			 * FIX THIS - the FW descriptors are actually for
-			 * MSDUs in the end of this A-MSDU instead of the
-			 * beginning.
-			 */
-			rx_desc->fw_desc.info0 = 0;
-		}
-
 		msdu_len_invalid = !!(__le32_to_cpu(rx_desc->attention.flags)
 					& (RX_ATTENTION_FLAGS_MPDU_LENGTH_ERR |
 					   RX_ATTENTION_FLAGS_MSDU_LENGTH_ERR));
@@ -1579,8 +1536,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	struct htt_rx_indication_mpdu_range *mpdu_ranges;
 	struct sk_buff_head amsdu;
 	int num_mpdu_ranges;
-	int fw_desc_len;
-	u8 *fw_desc;
 	int i, ret, mpdu_count = 0;
 
 	lockdep_assert_held(&htt->rx_ring.lock);
@@ -1588,9 +1543,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	if (htt->rx_confused)
 		return;
 
-	fw_desc_len = __le16_to_cpu(rx->prefix.fw_rx_desc_bytes);
-	fw_desc = (u8 *)&rx->fw_desc;
-
 	num_mpdu_ranges = MS(__le32_to_cpu(rx->hdr.info1),
 			     HTT_RX_INDICATION_INFO1_NUM_MPDU_RANGES);
 	mpdu_ranges = htt_rx_ind_get_mpdu_ranges(rx);
@@ -1605,8 +1557,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 
 	while (mpdu_count--) {
 		__skb_queue_head_init(&amsdu);
-		ret = ath10k_htt_rx_amsdu_pop(htt, &fw_desc,
-					      &fw_desc_len, &amsdu);
+		ret = ath10k_htt_rx_amsdu_pop(htt, &amsdu);
 		if (ret < 0) {
 			ath10k_warn(ar, "rx ring became corrupted: %d\n", ret);
 			__skb_queue_purge(&amsdu);
@@ -1634,17 +1585,11 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	struct ieee80211_rx_status *rx_status = &htt->rx_status;
 	struct sk_buff_head amsdu;
 	int ret;
-	u8 *fw_desc;
-	int fw_desc_len;
-
-	fw_desc_len = __le16_to_cpu(frag->fw_rx_desc_bytes);
-	fw_desc = (u8 *)frag->fw_msdu_rx_desc;
 
 	__skb_queue_head_init(&amsdu);
 
 	spin_lock_bh(&htt->rx_ring.lock);
-	ret = ath10k_htt_rx_amsdu_pop(htt, &fw_desc, &fw_desc_len,
-				      &amsdu);
+	ret = ath10k_htt_rx_amsdu_pop(htt, &amsdu);
 	spin_unlock_bh(&htt->rx_ring.lock);
 
 	tasklet_schedule(&htt->rx_replenish_task);
@@ -1668,12 +1613,6 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
 	ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);
 	ath10k_htt_rx_h_deliver(ar, &amsdu, rx_status);
-
-	if (fw_desc_len > 0) {
-		ath10k_dbg(ar, ATH10K_DBG_HTT,
-			   "expecting more fragmented rx in one indication %d\n",
-			   fw_desc_len);
-	}
 }
 
 static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
-- 
2.7.4

