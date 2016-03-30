Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47343 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbcC3PnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 11:43:16 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 3/3] ath10k: fix unconditional num_mpdus_ready subtraction
Date: Wed, 30 Mar 2016 21:12:31 +0530
Message-ID: <1459352551-11773-3-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160330_174318_495860_73B704E8)
In-Reply-To: <1459352551-11773-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1459352551-11773-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Decrement num_mpdus_ready only when rx amsdu is processed successfully.
Not doing so, will result in leak and impact stabilty under low memory
cases.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 96a7417..9696c2e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2412,14 +2412,12 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 	struct ath10k_htt *htt = (struct ath10k_htt *)ptr;
 	struct ath10k *ar = htt->ar;
 	struct htt_tx_done tx_done = {};
-	struct sk_buff_head rx_q;
 	struct sk_buff_head rx_ind_q;
 	struct sk_buff_head tx_ind_q;
 	struct sk_buff *skb;
 	unsigned long flags;
 	int num_mpdus;
 
-	__skb_queue_head_init(&rx_q);
 	__skb_queue_head_init(&rx_ind_q);
 	__skb_queue_head_init(&tx_ind_q);
 
@@ -2448,11 +2446,13 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 	ath10k_mac_tx_push_pending(ar);
 
 	num_mpdus = atomic_read(&htt->num_mpdus_ready);
-	atomic_sub(num_mpdus, &htt->num_mpdus_ready);
 
-	while (num_mpdus--) {
+	while (num_mpdus) {
 		if (ath10k_htt_rx_handle_amsdu(htt))
 			break;
+
+		num_mpdus--;
+		atomic_dec(&htt->num_mpdus_ready);
 	}
 
 	while ((skb = __skb_dequeue(&rx_ind_q))) {
-- 
2.7.4

