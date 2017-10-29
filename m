Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:27184 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbdJ2Hl1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 03:41:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] Revert "ath10k: fix napi_poll budget overflow"
Date: Sun, 29 Oct 2017 09:41:16 +0200
Message-ID: <1509262876-10944-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20171029_084439_684198_16437164)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thorsten reported on <fa6e3ee2-91b5-a54b-afe3-87f30aac7a48@leemhuis.info> that
commit c9353bf483d3 made ath10k unstable with QCA6174 on his Dell XPS13 (9360)
with an error message:

ath10k_pci 0000:3a:00.0: failed to extract amsdu: -11

It only seemed to happen with certain APs, not all, but when it happened the
only way to get ath10k working was to switch the wifi off and on with a hotkey.

As this commit made things even worse (a warning vs breaking the whole
connection) let's revert the commit for now and while the issue is being fixed.

Link: http://lists.infradead.org/pipermail/ath10k/2017-October/010227.html
Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f068376ec565..7ae3926f4995 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1745,8 +1745,7 @@ static void ath10k_htt_rx_delba(struct ath10k *ar, struct htt_resp *resp)
 }
 
 static int ath10k_htt_rx_extract_amsdu(struct sk_buff_head *list,
-				       struct sk_buff_head *amsdu,
-				       int budget_left)
+				       struct sk_buff_head *amsdu)
 {
 	struct sk_buff *msdu;
 	struct htt_rx_desc *rxd;
@@ -1757,9 +1756,8 @@ static int ath10k_htt_rx_extract_amsdu(struct sk_buff_head *list,
 	if (WARN_ON(!skb_queue_empty(amsdu)))
 		return -EINVAL;
 
-	while ((msdu = __skb_dequeue(list)) && budget_left) {
+	while ((msdu = __skb_dequeue(list))) {
 		__skb_queue_tail(amsdu, msdu);
-		budget_left--;
 
 		rxd = (void *)msdu->data - sizeof(*rxd);
 		if (rxd->msdu_end.common.info0 &
@@ -1850,8 +1848,7 @@ static int ath10k_htt_rx_h_rx_offload(struct ath10k *ar,
 	return num_msdu;
 }
 
-static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb,
-				    int budget_left)
+static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_htt *htt = &ar->htt;
 	struct htt_resp *resp = (void *)skb->data;
@@ -1908,9 +1905,9 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb,
 	if (offload)
 		num_msdus = ath10k_htt_rx_h_rx_offload(ar, &list);
 
-	while (!skb_queue_empty(&list) && budget_left) {
+	while (!skb_queue_empty(&list)) {
 		__skb_queue_head_init(&amsdu);
-		ret = ath10k_htt_rx_extract_amsdu(&list, &amsdu, budget_left);
+		ret = ath10k_htt_rx_extract_amsdu(&list, &amsdu);
 		switch (ret) {
 		case 0:
 			/* Note: The in-order indication may report interleaved
@@ -1920,7 +1917,6 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb,
 			 * should still give an idea about rx rate to the user.
 			 */
 			num_msdus += skb_queue_len(&amsdu);
-			budget_left -= skb_queue_len(&amsdu);
 			ath10k_htt_rx_h_ppdu(ar, &amsdu, status, vdev_id);
 			ath10k_htt_rx_h_filter(ar, &amsdu, status);
 			ath10k_htt_rx_h_mpdu(ar, &amsdu, status);
@@ -2563,8 +2559,7 @@ int ath10k_htt_txrx_compl_task(struct ath10k *ar, int budget)
 		}
 
 		spin_lock_bh(&htt->rx_ring.lock);
-		num_rx_msdus = ath10k_htt_rx_in_ord_ind(ar, skb,
-							(budget - quota));
+		num_rx_msdus = ath10k_htt_rx_in_ord_ind(ar, skb);
 		spin_unlock_bh(&htt->rx_ring.lock);
 		if (num_rx_msdus < 0) {
 			resched_napi = true;
-- 
2.7.4
