Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:18206 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbbJLM6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 08:58:38 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 4/7] ath10k: export htt tx rx handlers
Date: Mon, 12 Oct 2015 18:27:03 +0530
Message-ID: <1444654626-3290-5-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151012_145857_544398_E1F31C4B)
In-Reply-To: <1444654626-3290-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1444654626-3290-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some special copy engines delivers messages directly to HTT by
bypassing HTC layer. Hence exporting tx_completion and rx_handler
for delivering the data to HTT layer.

Reviewed-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    | 1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c | 1 +
 drivers/net/wireless/ath/ath10k/htt_tx.c | 6 ++++++
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index db0a99b..2bad50e 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1591,6 +1591,7 @@ int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt);
 int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
 				u8 max_subfrms_ampdu,
 				u8 max_subfrms_amsdu);
+void ath10k_htt_hif_tx_complete(struct ath10k *ar, struct sk_buff *skb);
 
 void __ath10k_htt_tx_dec_pending(struct ath10k_htt *htt, bool limit_mgmt_desc);
 int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt, struct sk_buff *skb);
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 606c1a3..6060dda 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2125,6 +2125,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 	/* Free the indication buffer */
 	dev_kfree_skb_any(skb);
 }
+EXPORT_SYMBOL(ath10k_htt_t2h_msg_handler);
 
 static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 {
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 5551747..1682397 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -187,6 +187,12 @@ void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
 	dev_kfree_skb_any(skb);
 }
 
+void ath10k_htt_hif_tx_complete(struct ath10k *ar, struct sk_buff *skb)
+{
+	dev_kfree_skb_any(skb);
+}
+EXPORT_SYMBOL(ath10k_htt_hif_tx_complete);
+
 int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt)
 {
 	struct ath10k *ar = htt->ar;
-- 
2.6.0

