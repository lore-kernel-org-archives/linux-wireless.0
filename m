Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:52368 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab3IRNIS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 09:08:18 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC] ath10k: replenish HTT RX buffers in a tasklet
Date: Wed, 18 Sep 2013 15:08:10 +0200
Message-ID: <1379509691-19904-1-git-send-email-michal.kazior@tieto.com> (sfid-20130918_150822_054151_B5C6F6AD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes system starvation when under heavy RX
traffic. This problem could be observed on AP135
and led to watchdog resetting the platform.

Patch starves FW RX ring buffer by progressively
replenishing buffers to auto-balance the RX
handled to the host system.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |    8 +++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c |   36 +++++++++++++++++++++++++++---
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index e090902..8dcf808 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -19,6 +19,7 @@
 #define _HTT_H_
 
 #include <linux/bug.h>
+#include <linux/interrupt.h>
 
 #include "htc.h"
 #include "rx_desc.h"
@@ -1268,6 +1269,7 @@ struct ath10k_htt {
 	/* set if host-fw communication goes haywire
 	 * used to avoid further failures */
 	bool rx_confused;
+	struct tasklet_struct rx_replenish_task;
 };
 
 #define RX_HTT_HDR_STATUS_LEN 64
@@ -1308,6 +1310,12 @@ struct htt_rx_desc {
 #define HTT_RX_BUF_SIZE 1920
 #define HTT_RX_MSDU_SIZE (HTT_RX_BUF_SIZE - (int)sizeof(struct htt_rx_desc))
 
+/* Refill a bunch of RX buffers for each refill round so that FW/HW can handle
+ * aggregated traffic more nicely. Picked empirically.
+ * FIXME: Can this value be calculated sanely? */
+#define ATH10K_HTT_MAX_NUM_REFILL 16
+
+
 /*
  * DMA_MAP expects the buffer to be an integral number of cache lines.
  * Rather than checking the actual cache line size, this code makes a
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a39fbf4..66e9ecd 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -178,10 +178,27 @@ static int ath10k_htt_rx_ring_fill_n(struct ath10k_htt *htt, int num)
 
 static void ath10k_htt_rx_msdu_buff_replenish(struct ath10k_htt *htt)
 {
-	int ret, num_to_fill;
+	int ret, num_deficit, num_to_fill;
 
+	/* Refilling the whole RX ring buffer proves to be a bad idea. The
+	 * reason is RX may take very long periods of time and starve other
+	 * tasks on a system.
+	 *
+	 * By limiting the number of refills the replenishing occurs
+	 * progressively. This in turns makes use of the fact tasklets are
+	 * processed in FIFO order. This means actual RX processing can starve
+	 * out refilling if there's not enough free processing power. If
+	 * there's not enough buffers on RX ring FW will not report RX until it
+	 * is refilled with enough buffers. This automatically balances load
+	 * wrt to CPU power.
+	 *
+	 * This probably comes at a cost of lower maximum theoretical
+	 * throughput but stabilizes the real throughput and prevents
+	 * starvation (which can lead to poor performance itself) */
 	spin_lock_bh(&htt->rx_ring.lock);
-	num_to_fill = htt->rx_ring.fill_level - htt->rx_ring.fill_cnt;
+	num_deficit = htt->rx_ring.fill_level - htt->rx_ring.fill_cnt;
+	num_to_fill = min(ATH10K_HTT_MAX_NUM_REFILL, num_deficit);
+	num_deficit -= num_to_fill;
 	ret = ath10k_htt_rx_ring_fill_n(htt, num_to_fill);
 	if (ret == -ENOMEM) {
 		/*
@@ -192,8 +209,11 @@ static void ath10k_htt_rx_msdu_buff_replenish(struct ath10k_htt *htt)
 		 */
 		mod_timer(&htt->rx_ring.refill_retry_timer, jiffies +
 			  msecs_to_jiffies(HTT_RX_RING_REFILL_RETRY_MS));
+	} else if (num_deficit > 0) {
+		tasklet_schedule(&htt->rx_replenish_task);
 	}
 	spin_unlock_bh(&htt->rx_ring.lock);
+
 }
 
 static void ath10k_htt_rx_ring_refill_retry(unsigned long arg)
@@ -212,6 +232,7 @@ void ath10k_htt_rx_detach(struct ath10k_htt *htt)
 {
 	int sw_rd_idx = htt->rx_ring.sw_rd_idx.msdu_payld;
 
+	tasklet_kill(&htt->rx_replenish_task);
 	del_timer_sync(&htt->rx_ring.refill_retry_timer);
 
 	while (sw_rd_idx != __le32_to_cpu(*(htt->rx_ring.alloc_idx.vaddr))) {
@@ -442,6 +463,12 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 	return msdu_chaining;
 }
 
+static void ath10k_htt_rx_replenish_task(unsigned long ptr)
+{
+	struct ath10k_htt *htt = (struct ath10k_htt *)ptr;
+	ath10k_htt_rx_msdu_buff_replenish(htt);
+}
+
 int ath10k_htt_rx_attach(struct ath10k_htt *htt)
 {
 	dma_addr_t paddr;
@@ -502,6 +529,9 @@ int ath10k_htt_rx_attach(struct ath10k_htt *htt)
 	if (__ath10k_htt_rx_ring_fill_n(htt, htt->rx_ring.fill_level))
 		goto err_fill_ring;
 
+	tasklet_init(&htt->rx_replenish_task, ath10k_htt_rx_replenish_task,
+		     (unsigned long)htt);
+
 	ath10k_dbg(ATH10K_DBG_BOOT, "htt rx ring size %d fill_level %d\n",
 		   htt->rx_ring.size, htt->rx_ring.fill_level);
 	return 0;
@@ -968,7 +998,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 		}
 	}
 
-	ath10k_htt_rx_msdu_buff_replenish(htt);
+	tasklet_schedule(&htt->rx_replenish_task);
 }
 
 static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
-- 
1.7.9.5

