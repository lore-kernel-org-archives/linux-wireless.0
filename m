Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:39750 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbbIYGzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2015 02:55:20 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 4/7] ath10k: export htt tx rx handlers
Date: Fri, 25 Sep 2015 12:23:33 +0530
Message-ID: <1443164016-3612-5-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150925_085524_845820_478DDD08)
In-Reply-To: <1443164016-3612-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1443164016-3612-1-git-send-email-rmanohar@qti.qualcomm.com>
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
index 5a8e4ea..3b9ddef 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1587,6 +1587,7 @@ int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt);
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
index eb5ba9b..64ba977 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -175,6 +175,12 @@ void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
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
2.5.2

