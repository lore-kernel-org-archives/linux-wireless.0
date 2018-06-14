Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35268 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755265AbeFNUIi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 16:08:38 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, kvalo@codeaurora.org,
        Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] ath10k: Protect ath10k_htt_rx_ring_free with rx_ring.lock
Date: Thu, 14 Jun 2018 13:08:15 -0700
Message-Id: <1529006895-5105-1-git-send-email-greearb@candelatech.com> (sfid-20180614_220841_456605_20E9F38E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

While debugging driver crashes related to a buggy firmware
crashing under load, I noticed that ath10k_htt_rx_ring_free
could be called without being under lock.  I'm not sure if this
is the root cause of the crash or not, but it seems prudent to
protect it.

Originally tested on 4.16+ kernel with ath10k-ct 10.4 firmware
running on 9984 NIC.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Update description to specify how it was tested.
     Generate patch against linux-ath tree (original patch applied with offset)

 drivers/net/wireless/ath/ath10k/htt_rx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index bd23f69..ccd03f8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -268,11 +268,12 @@ int ath10k_htt_rx_ring_refill(struct ath10k *ar)
 	spin_lock_bh(&htt->rx_ring.lock);
 	ret = ath10k_htt_rx_ring_fill_n(htt, (htt->rx_ring.fill_level -
 					      htt->rx_ring.fill_cnt));
-	spin_unlock_bh(&htt->rx_ring.lock);
 
 	if (ret)
 		ath10k_htt_rx_ring_free(htt);
 
+	spin_unlock_bh(&htt->rx_ring.lock);
+
 	return ret;
 }
 
@@ -284,7 +285,9 @@ void ath10k_htt_rx_free(struct ath10k_htt *htt)
 	skb_queue_purge(&htt->rx_in_ord_compl_q);
 	skb_queue_purge(&htt->tx_fetch_ind_q);
 
+	spin_lock_bh(&htt->rx_ring.lock);
 	ath10k_htt_rx_ring_free(htt);
+	spin_unlock_bh(&htt->rx_ring.lock);
 
 	dma_free_coherent(htt->ar->dev,
 			  ath10k_htt_get_rx_ring_size(htt),
-- 
2.4.11
