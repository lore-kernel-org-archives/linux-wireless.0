Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35550 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbcAMNv5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 08:51:57 -0500
Received: by mail-lf0-f45.google.com with SMTP id c192so255743217lfe.2
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2016 05:51:56 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: prevent txrx running for too long
Date: Wed, 13 Jan 2016 14:52:52 +0100
Message-Id: <1452693172-28340-1-git-send-email-michal.kazior@tieto.com> (sfid-20160113_145201_758310_416DA541)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On multicore systems it was possible for the txrx
tasklet to keep on running for long periods of
time on a single CPU due to tx completion
processing. Another CPU could feed the running
tasklet for an indefinite amount of time.

The tasklet is now guaranteed to run a finite
amount of time and is limited by HTT CE Rx ring
depth.

This improves behavior when RPS is used on target
system and might improve TCP handling as well.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 91afa3ae414c..3079434b5d9b 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2156,10 +2156,18 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 {
 	struct ath10k_htt *htt = (struct ath10k_htt *)ptr;
 	struct ath10k *ar = htt->ar;
+	struct sk_buff_head tx_q;
 	struct htt_resp *resp;
 	struct sk_buff *skb;
+	unsigned long flags;
 
-	while ((skb = skb_dequeue(&htt->tx_compl_q))) {
+	__skb_queue_head_init(&tx_q);
+
+	spin_lock_irqsave(&htt->tx_compl_q.lock, flags);
+	skb_queue_splice_init(&htt->tx_compl_q, &tx_q);
+	spin_unlock_irqrestore(&htt->tx_compl_q.lock, flags);
+
+	while ((skb = __skb_dequeue(&tx_q))) {
 		ath10k_htt_rx_frm_tx_compl(htt->ar, skb);
 		dev_kfree_skb_any(skb);
 	}
-- 
2.1.4

