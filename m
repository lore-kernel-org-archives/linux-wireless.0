Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:63470 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab3HUGeX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 02:34:23 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] ath10k: move htt rx processing to worker
Date: Wed, 21 Aug 2013 08:34:13 +0200
Message-ID: <1377066854-13981-3-git-send-email-michal.kazior@tieto.com> (sfid-20130821_083432_076865_0CBBDB97)
In-Reply-To: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This improves rx performance by a significant
value (280mbps -> 350mbps UDP) on AP135.

Note: it is not safe to move HTT tx completion
handling to a worker yet as it must be serialized
against HTC tx completions.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |    4 ++-
 drivers/net/wireless/ath/ath10k/htt.h    |    3 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c |   54 ++++++++++++++++++++++++++----
 3 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index e196833..7d5b71b 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -42,8 +42,10 @@
 
 #define ATH10K_NUM_HTC_TX_WORKERS ATH10K_HTC_EP_COUNT
 #define ATH10K_NUM_WMI_RX_WORKERS 1
+#define ATH10K_NUM_HTT_RX_WORKERS 1
 #define ATH10K_MAX_NUM_PARALLEL_WORKERS (ATH10K_NUM_HTC_TX_WORKERS + \
-					 ATH10K_NUM_WMI_RX_WORKERS)
+					 ATH10K_NUM_WMI_RX_WORKERS + \
+					 ATH10K_NUM_HTT_RX_WORKERS)
 
 /* Antenna noise floor */
 #define ATH10K_DEFAULT_NOISE_FLOOR -95
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 26c78a9..8abbf2c 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1268,6 +1268,9 @@ struct ath10k_htt {
 	/* set if host-fw communication goes haywire
 	 * used to avoid further failures */
 	bool rx_confused;
+
+	struct work_struct rx_work;
+	struct sk_buff_head rx_queue;
 };
 
 #define RX_HTT_HDR_STATUS_LEN 64
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 9bb0ae89..6cf4d95 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -40,6 +40,10 @@
 /* when under memory pressure rx ring refill may fail and needs a retry */
 #define HTT_RX_RING_REFILL_RETRY_MS 50
 
+
+static void ath10k_htt_rx_work(struct work_struct *work);
+
+
 static int ath10k_htt_rx_ring_size(struct ath10k_htt *htt)
 {
 	int size;
@@ -211,6 +215,8 @@ void ath10k_htt_rx_detach(struct ath10k_htt *htt)
 {
 	int sw_rd_idx = htt->rx_ring.sw_rd_idx.msdu_payld;
 
+	skb_queue_purge(&htt->rx_queue);
+	cancel_work_sync(&htt->rx_work);
 	del_timer_sync(&htt->rx_ring.refill_retry_timer);
 
 	while (sw_rd_idx != __le32_to_cpu(*(htt->rx_ring.alloc_idx.vaddr))) {
@@ -501,6 +507,9 @@ int ath10k_htt_rx_attach(struct ath10k_htt *htt)
 	if (__ath10k_htt_rx_ring_fill_n(htt, htt->rx_ring.fill_level))
 		goto err_fill_ring;
 
+	INIT_WORK(&htt->rx_work, ath10k_htt_rx_work);
+	skb_queue_head_init(&htt->rx_queue);
+
 	ath10k_dbg(ATH10K_DBG_HTT, "HTT RX ring size: %d, fill_level: %d\n",
 		   htt->rx_ring.size, htt->rx_ring.fill_level);
 	return 0;
@@ -1083,17 +1092,11 @@ end:
 	}
 }
 
-void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
+static void ath10k_htt_rx_process_skb(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_htt *htt = &ar->htt;
 	struct htt_resp *resp = (struct htt_resp *)skb->data;
 
-	/* confirm alignment */
-	if (!IS_ALIGNED((unsigned long)skb->data, 4))
-		ath10k_warn("unaligned htt message, expect trouble\n");
-
-	ath10k_dbg(ATH10K_DBG_HTT, "HTT RX, msg_type: 0x%0X\n",
-		   resp->hdr.msg_type);
 	switch (resp->hdr.msg_type) {
 	case HTT_T2H_MSG_TYPE_VERSION_CONF: {
 		htt->target_version_major = resp->ver_resp.major;
@@ -1214,3 +1217,40 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 	/* Free the indication buffer */
 	dev_kfree_skb_any(skb);
 }
+
+static void ath10k_htt_rx_work(struct work_struct *work)
+{
+	struct ath10k_htt *htt = container_of(work, struct ath10k_htt, rx_work);
+	struct sk_buff *skb;
+
+	for (;;) {
+		skb = skb_dequeue(&htt->rx_queue);
+		if (!skb)
+			break;
+
+		ath10k_htt_rx_process_skb(htt->ar, skb);
+	}
+}
+
+void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
+{
+	struct ath10k_htt *htt = &ar->htt;
+	struct htt_resp *resp = (struct htt_resp *)skb->data;
+
+	/* confirm alignment */
+	if (!IS_ALIGNED((unsigned long)skb->data, 4))
+		ath10k_warn("unaligned htt message, expect trouble\n");
+
+	ath10k_dbg(ATH10K_DBG_HTT, "HTT RX, msg_type: 0x%0X\n",
+		   resp->hdr.msg_type);
+	switch (resp->hdr.msg_type) {
+	case HTT_T2H_MSG_TYPE_RX_FRAG_IND:
+	case HTT_T2H_MSG_TYPE_RX_IND:
+		skb_queue_tail(&htt->rx_queue, skb);
+		queue_work(ar->workqueue, &htt->rx_work);
+		break;
+	default:
+		ath10k_htt_rx_process_skb(ar, skb);
+		break;
+	}
+}
-- 
1.7.9.5

