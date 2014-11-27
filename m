Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:32947 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaK0KY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 05:24:57 -0500
Received: by mail-wi0-f175.google.com with SMTP id l15so15308091wiw.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2014 02:24:56 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: simplify rx ring size/fill calculation
Date: Thu, 27 Nov 2014 11:12:43 +0100
Message-Id: <1417083163-2962-1-git-send-email-michal.kazior@tieto.com> (sfid-20141127_112500_742578_210365E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't bother with fancy arithmetic and just
hardcode the final values.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |  3 +
 drivers/net/wireless/ath/ath10k/htt_rx.c | 98 +++-----------------------------
 2 files changed, 12 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 17ca6ac..1bd5545 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -158,6 +158,9 @@ enum htt_rx_ring_flags {
 	HTT_RX_RING_FLAGS_PHY_DATA_RX  = 1 << 15
 };
 
+#define HTT_RX_RING_SIZE_MIN 128
+#define HTT_RX_RING_SIZE_MAX 2048
+
 struct htt_rx_ring_setup_ring {
 	__le32 fw_idx_shadow_reg_paddr;
 	__le32 rx_ring_base_paddr;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 85910b2..9c782a4 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -25,19 +25,8 @@
 
 #include <linux/log2.h>
 
-/* slightly larger than one large A-MPDU */
-#define HTT_RX_RING_SIZE_MIN 128
-
-/* roughly 20 ms @ 1 Gbps of 1500B MSDUs */
-#define HTT_RX_RING_SIZE_MAX 2048
-
-#define HTT_RX_AVG_FRM_BYTES 1000
-
-/* ms, very conservative */
-#define HTT_RX_HOST_LATENCY_MAX_MS 20
-
-/* ms, conservative */
-#define HTT_RX_HOST_LATENCY_WORST_LIKELY_MS 10
+#define HTT_RX_RING_SIZE 1024
+#define HTT_RX_RING_FILL_LEVEL 1000
 
 /* when under memory pressure rx ring refill may fail and needs a retry */
 #define HTT_RX_RING_REFILL_RETRY_MS 50
@@ -45,68 +34,6 @@
 static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb);
 static void ath10k_htt_txrx_compl_task(unsigned long ptr);
 
-static int ath10k_htt_rx_ring_size(struct ath10k_htt *htt)
-{
-	int size;
-
-	/*
-	 * It is expected that the host CPU will typically be able to
-	 * service the rx indication from one A-MPDU before the rx
-	 * indication from the subsequent A-MPDU happens, roughly 1-2 ms
-	 * later. However, the rx ring should be sized very conservatively,
-	 * to accomodate the worst reasonable delay before the host CPU
-	 * services a rx indication interrupt.
-	 *
-	 * The rx ring need not be kept full of empty buffers. In theory,
-	 * the htt host SW can dynamically track the low-water mark in the
-	 * rx ring, and dynamically adjust the level to which the rx ring
-	 * is filled with empty buffers, to dynamically meet the desired
-	 * low-water mark.
-	 *
-	 * In contrast, it's difficult to resize the rx ring itself, once
-	 * it's in use. Thus, the ring itself should be sized very
-	 * conservatively, while the degree to which the ring is filled
-	 * with empty buffers should be sized moderately conservatively.
-	 */
-
-	/* 1e6 bps/mbps / 1e3 ms per sec = 1000 */
-	size =
-	    htt->max_throughput_mbps +
-	    1000  /
-	    (8 * HTT_RX_AVG_FRM_BYTES) * HTT_RX_HOST_LATENCY_MAX_MS;
-
-	if (size < HTT_RX_RING_SIZE_MIN)
-		size = HTT_RX_RING_SIZE_MIN;
-
-	if (size > HTT_RX_RING_SIZE_MAX)
-		size = HTT_RX_RING_SIZE_MAX;
-
-	size = roundup_pow_of_two(size);
-
-	return size;
-}
-
-static int ath10k_htt_rx_ring_fill_level(struct ath10k_htt *htt)
-{
-	int size;
-
-	/* 1e6 bps/mbps / 1e3 ms per sec = 1000 */
-	size =
-	    htt->max_throughput_mbps *
-	    1000  /
-	    (8 * HTT_RX_AVG_FRM_BYTES) * HTT_RX_HOST_LATENCY_WORST_LIKELY_MS;
-
-	/*
-	 * Make sure the fill level is at least 1 less than the ring size.
-	 * Leaving 1 element empty allows the SW to easily distinguish
-	 * between a full ring vs. an empty ring.
-	 */
-	if (size >= htt->rx_ring.size)
-		size = htt->rx_ring.size - 1;
-
-	return size;
-}
-
 static void ath10k_htt_rx_ring_free(struct ath10k_htt *htt)
 {
 	struct sk_buff *skb;
@@ -462,25 +389,18 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 
 	htt->rx_confused = false;
 
-	htt->rx_ring.size = ath10k_htt_rx_ring_size(htt);
+	/* XXX: The fill level could be changed during runtime in response to
+	 * the host processing latency. Is this really worth it?
+	 */
+	htt->rx_ring.size = HTT_RX_RING_SIZE;
+	htt->rx_ring.size_mask = htt->rx_ring.size - 1;
+	htt->rx_ring.fill_level = HTT_RX_RING_FILL_LEVEL;
+
 	if (!is_power_of_2(htt->rx_ring.size)) {
 		ath10k_warn(ar, "htt rx ring size is not power of 2\n");
 		return -EINVAL;
 	}
 
-	htt->rx_ring.size_mask = htt->rx_ring.size - 1;
-
-	/*
-	 * Set the initial value for the level to which the rx ring
-	 * should be filled, based on the max throughput and the
-	 * worst likely latency for the host to fill the rx ring
-	 * with new buffers. In theory, this fill level can be
-	 * dynamically adjusted from the initial value set here, to
-	 * reflect the actual host latency rather than a
-	 * conservative assumption about the host latency.
-	 */
-	htt->rx_ring.fill_level = ath10k_htt_rx_ring_fill_level(htt);
-
 	htt->rx_ring.netbufs_ring =
 		kzalloc(htt->rx_ring.size * sizeof(struct sk_buff *),
 			GFP_KERNEL);
-- 
1.8.5.3

