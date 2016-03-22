Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50410 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbcCVLyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 07:54:53 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 9/9] ath10k: combine txrx and replenish task
Date: Tue, 22 Mar 2016 17:22:19 +0530
Message-ID: <1458647539-17213-10-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160322_125456_013762_E64A0E7B)
In-Reply-To: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since tx completion and rx indication processing are moved out
of txrx tasklet and rx ring lock contention also removed from txrx
for rx_ind messages, it would be efficient to combine both replenish
and txrx tasks. Refill threshold is adjusted for both AP135 and AP148
(low and high end systems). With this adjustment in AP135, TCP DL is
improved from 603 Mbps to 620 Mbps and UDP DL is improved from 758 Mbps
to 803 Mbps. Also no watchdog are observed on UDP BiDi.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |  3 +--
 drivers/net/wireless/ath/ath10k/htt_rx.c | 21 ++++++---------------
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 1adcae4..60bd9fe 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1662,7 +1662,6 @@ struct ath10k_htt {
 	/* set if host-fw communication goes haywire
 	 * used to avoid further failures */
 	bool rx_confused;
-	struct tasklet_struct rx_replenish_task;
 	atomic_t num_mpdus_ready;
 
 	/* This is used to group tx/rx completions separately and process them
@@ -1737,7 +1736,7 @@ struct htt_rx_desc {
 
 /* Refill a bunch of RX buffers for each refill round so that FW/HW can handle
  * aggregated traffic more nicely. */
-#define ATH10K_HTT_MAX_NUM_REFILL 16
+#define ATH10K_HTT_MAX_NUM_REFILL 100
 
 /*
  * DMA_MAP expects the buffer to be an integral number of cache lines.
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 31be0c6..96a7417 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -31,6 +31,8 @@
 /* when under memory pressure rx ring refill may fail and needs a retry */
 #define HTT_RX_RING_REFILL_RETRY_MS 50
 
+#define HTT_RX_RING_REFILL_RESCHED_MS 5
+
 static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb);
 static void ath10k_htt_txrx_compl_task(unsigned long ptr);
 
@@ -192,7 +194,8 @@ static void ath10k_htt_rx_msdu_buff_replenish(struct ath10k_htt *htt)
 		mod_timer(&htt->rx_ring.refill_retry_timer, jiffies +
 			  msecs_to_jiffies(HTT_RX_RING_REFILL_RETRY_MS));
 	} else if (num_deficit > 0) {
-		tasklet_schedule(&htt->rx_replenish_task);
+		mod_timer(&htt->rx_ring.refill_retry_timer, jiffies +
+			  msecs_to_jiffies(HTT_RX_RING_REFILL_RESCHED_MS));
 	}
 	spin_unlock_bh(&htt->rx_ring.lock);
 }
@@ -223,7 +226,6 @@ int ath10k_htt_rx_ring_refill(struct ath10k *ar)
 void ath10k_htt_rx_free(struct ath10k_htt *htt)
 {
 	del_timer_sync(&htt->rx_ring.refill_retry_timer);
-	tasklet_kill(&htt->rx_replenish_task);
 	tasklet_kill(&htt->txrx_compl_task);
 
 	skb_queue_purge(&htt->rx_compl_q);
@@ -380,13 +382,6 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 	return msdu_chaining;
 }
 
-static void ath10k_htt_rx_replenish_task(unsigned long ptr)
-{
-	struct ath10k_htt *htt = (struct ath10k_htt *)ptr;
-
-	ath10k_htt_rx_msdu_buff_replenish(htt);
-}
-
 static struct sk_buff *ath10k_htt_rx_pop_paddr(struct ath10k_htt *htt,
 					       u32 paddr)
 {
@@ -520,9 +515,6 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 	htt->rx_ring.sw_rd_idx.msdu_payld = 0;
 	hash_init(htt->rx_ring.skb_table);
 
-	tasklet_init(&htt->rx_replenish_task, ath10k_htt_rx_replenish_task,
-		     (unsigned long)htt);
-
 	skb_queue_head_init(&htt->rx_compl_q);
 	skb_queue_head_init(&htt->rx_in_ord_compl_q);
 	skb_queue_head_init(&htt->tx_fetch_ind_q);
@@ -1912,8 +1904,7 @@ static void ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 			return;
 		}
 	}
-
-	tasklet_schedule(&htt->rx_replenish_task);
+	ath10k_htt_rx_msdu_buff_replenish(htt);
 }
 
 static void ath10k_htt_rx_tx_fetch_resp_id_confirm(struct ath10k *ar,
@@ -2471,5 +2462,5 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 		dev_kfree_skb_any(skb);
 	}
 
-	tasklet_schedule(&htt->rx_replenish_task);
+	ath10k_htt_rx_msdu_buff_replenish(htt);
 }
-- 
2.7.4

