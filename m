Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57623 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbcCVLyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 07:54:03 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 6/9] ath10k: register ath10k_htt_htc_t2h_msg_handler
Date: Tue, 22 Mar 2016 17:22:16 +0530
Message-ID: <1458647539-17213-7-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160322_125408_306624_F552C54D)
In-Reply-To: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Except qca61x4 family chips (qca6164, qca6174), copy engine 5 is used
for receiving target to host htt messages. In follow up patch, CE5
descriptors will be reused. In such case, same API can not be used as
htc layer callback where the response messages will be freed at the end.
Hence register new API for HTC layer that free up received message and
keep the message handler common for both HTC and HIF layers.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.c    |  2 +-
 drivers/net/wireless/ath/ath10k/htt.h    |  3 ++-
 drivers/net/wireless/ath/ath10k/htt_rx.c | 22 +++++++++++++++-------
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 7561f22..17a3008 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -149,7 +149,7 @@ int ath10k_htt_connect(struct ath10k_htt *htt)
 	memset(&conn_resp, 0, sizeof(conn_resp));
 
 	conn_req.ep_ops.ep_tx_complete = ath10k_htt_htc_tx_complete;
-	conn_req.ep_ops.ep_rx_complete = ath10k_htt_t2h_msg_handler;
+	conn_req.ep_ops.ep_rx_complete = ath10k_htt_htc_t2h_msg_handler;
 
 	/* connect to control service */
 	conn_req.service_id = ATH10K_HTC_SVC_ID_HTT_DATA_MSG;
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 27a65ec..1adcae4 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1765,7 +1765,8 @@ int ath10k_htt_rx_ring_refill(struct ath10k *ar);
 void ath10k_htt_rx_free(struct ath10k_htt *htt);
 
 void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb);
-void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_htt_htc_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb);
+bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt);
 int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie);
 int ath10k_htt_send_frag_desc_bank_cfg(struct ath10k_htt *htt);
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index dde2237..31be0c6 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2219,7 +2219,18 @@ static inline enum ieee80211_band phy_mode_to_band(u32 phy_mode)
 	return band;
 }
 
-void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
+void ath10k_htt_htc_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
+{
+	bool release;
+
+	release = ath10k_htt_t2h_msg_handler(ar, skb);
+
+	/* Free the indication buffer */
+	if (release)
+		dev_kfree_skb_any(skb);
+}
+
+bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_htt *htt = &ar->htt;
 	struct htt_resp *resp = (struct htt_resp *)skb->data;
@@ -2235,8 +2246,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 	if (resp->hdr.msg_type >= ar->htt.t2h_msg_types_max) {
 		ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx, unsupported msg_type: 0x%0X\n max: 0x%0X",
 			   resp->hdr.msg_type, ar->htt.t2h_msg_types_max);
-		dev_kfree_skb_any(skb);
-		return;
+		return true;
 	}
 	type = ar->htt.t2h_msg_types[resp->hdr.msg_type];
 
@@ -2352,7 +2362,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 	case HTT_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND: {
 		skb_queue_tail(&htt->rx_in_ord_compl_q, skb);
 		tasklet_schedule(&htt->txrx_compl_task);
-		return;
+		return false;
 	}
 	case HTT_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND:
 		break;
@@ -2394,9 +2404,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 				skb->data, skb->len);
 		break;
 	};
-
-	/* Free the indication buffer */
-	dev_kfree_skb_any(skb);
+	return true;
 }
 EXPORT_SYMBOL(ath10k_htt_t2h_msg_handler);
 
-- 
2.7.4

