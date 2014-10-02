Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:63612 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaJBRJE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 13:09:04 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 3/4] ath10k: add tracing for rx descriptor
Date: Thu, 2 Oct 2014 22:39:37 +0530
Message-ID: <1412269778-1045-4-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141002_190908_940597_8AEBF386)
In-Reply-To: <1412269778-1045-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1412269778-1045-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon the reception of frame, the descriptor status are reported
to user space by tracepoint. This is useful for collecting rx
statistics.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |  4 ++++
 drivers/net/wireless/ath/ath10k/trace.h  | 29 +++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a078451..7add88e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -316,6 +316,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 	int msdu_len, msdu_chaining = 0;
 	struct sk_buff *msdu, *next;
 	struct htt_rx_desc *rx_desc;
+	u32 tsf;
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
@@ -447,6 +448,9 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 		last_msdu = __le32_to_cpu(rx_desc->msdu_end.info0) &
 				RX_MSDU_END_INFO0_LAST_MSDU;
 
+		tsf = __le32_to_cpu(rx_desc->ppdu_end.tsf_timestamp);
+		trace_ath10k_htt_rx_desc(ar, tsf, &rx_desc->attention,
+					 sizeof(*rx_desc) - sizeof(u32));
 		if (last_msdu) {
 			msdu->next = NULL;
 			break;
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 971ff23..3841667 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -281,6 +281,35 @@ TRACE_EVENT(ath10k_htt_pktlog,
 	 )
 );
 
+TRACE_EVENT(ath10k_htt_rx_desc,
+	    TP_PROTO(struct ath10k *ar, u32 tsf, void *rxdesc, u16 len),
+
+	TP_ARGS(ar, tsf, rxdesc, len),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
+		__field(u32, tsf)
+		__field(u16, len)
+		__dynamic_array(u8, rxdesc, len)
+	),
+
+	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
+		__entry->tsf = tsf;
+		__entry->len = len;
+		memcpy(__get_dynamic_array(rxdesc), rxdesc, len);
+	),
+
+	TP_printk(
+		"%s %s %u len %hu",
+		__get_str(driver),
+		__get_str(device),
+		__entry->tsf,
+		__entry->len
+	 )
+);
 #endif /* _TRACE_H_ || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */
-- 
2.1.1

