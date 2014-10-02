Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:44955 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaJBML3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 08:11:29 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/4] ath10k: add tracing for ath10k_htt_pktlog
Date: Thu, 2 Oct 2014 17:42:12 +0530
Message-ID: <1412251934-7011-3-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141002_141132_248935_32DF5E0E)
In-Reply-To: <1412251934-7011-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1412251934-7011-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is useful for collecting pktlog statistics of tx, rx
and rate information, so add tracing for the API call.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.h  |  1 -
 drivers/net/wireless/ath/ath10k/htt.h    |  2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |  9 +++++++++
 drivers/net/wireless/ath/ath10k/hw.h     |  9 +++++++++
 drivers/net/wireless/ath/ath10k/trace.h  | 27 +++++++++++++++++++++++++++
 5 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 794e6bb..aafdcab 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -69,7 +69,6 @@ struct ath10k_fw_crash_data *
 ath10k_debug_get_new_fw_crash_data(struct ath10k *ar);
 
 void ath10k_debug_dbglog_add(struct ath10k *ar, u8 *buffer, int len);
-
 #define ATH10K_DFS_STAT_INC(ar, c) (ar->debug.dfs_stats.c++)
 
 #else
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 3b44217..15c58e8 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -725,7 +725,7 @@ static inline u8 *htt_rx_test_get_chars(struct htt_rx_test *rx_test)
  */
 struct htt_pktlog_msg {
 	u8 pad[3];
-	__le32 payload[1 /* or more */];
+	u8 payload[0];
 } __packed;
 
 struct htt_dbg_stats_rx_reorder_stats {
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 60d40a0..a078451 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1674,6 +1674,15 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 	case HTT_T2H_MSG_TYPE_RX_DELBA:
 		ath10k_htt_rx_delba(ar, resp);
 		break;
+	case HTT_T2H_MSG_TYPE_PKTLOG: {
+		struct ath10k_pktlog_hdr *hdr =
+			(struct ath10k_pktlog_hdr *)resp->pktlog_msg.payload;
+
+		trace_ath10k_htt_pktlog(ar, resp->pktlog_msg.payload,
+					sizeof(*hdr) +
+					__le16_to_cpu(hdr->size));
+		break;
+	}
 	case HTT_T2H_MSG_TYPE_RX_FLUSH: {
 		/* Ignore this event because mac80211 takes care of Rx
 		 * aggregation reordering.
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 006a9cb..4b86ca3 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -80,6 +80,15 @@ enum ath10k_mcast2ucast_mode {
 	ATH10K_MCAST2UCAST_ENABLED = 1,
 };
 
+struct ath10k_pktlog_hdr {
+	__le16 flags;
+	__le16 missed_cnt;
+	__le16 log_type;
+	__le16 size;
+	__le32 timestamp;
+	u8 payload[0];
+} __packed;
+
 /* Target specific defines for MAIN firmware */
 #define TARGET_NUM_VDEVS			8
 #define TARGET_NUM_PEER_AST			2
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 574b75a..971ff23 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -254,6 +254,33 @@ TRACE_EVENT(ath10k_wmi_dbglog,
 	)
 );
 
+TRACE_EVENT(ath10k_htt_pktlog,
+	    TP_PROTO(struct ath10k *ar, void *buf, u16 buf_len),
+
+	TP_ARGS(ar, buf, buf_len),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
+		__field(u16, buf_len)
+		__dynamic_array(u8, pktlog, buf_len)
+	),
+
+	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(pktlog), buf, buf_len);
+	),
+
+	TP_printk(
+		"%s %s size %hu",
+		__get_str(driver),
+		__get_str(device),
+		__entry->buf_len
+	 )
+);
+
 #endif /* _TRACE_H_ || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */
-- 
2.1.1

