Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:40810 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaJBMFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 08:05:14 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 3/4] ath10k: add tracing for rx descriptor
Date: Thu, 2 Oct 2014 17:36:09 +0530
Message-ID: <1412251570-31096-4-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141002_140518_328441_A6299463)
In-Reply-To: <1412251570-31096-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1412251570-31096-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon the reception of frame, the descriptor status are reported
to user space by tracepoint. This is useful for collecting rx
statistics for pktlog.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c  | 17 +++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h  |  5 +++++
 drivers/net/wireless/ath/ath10k/htt_rx.c |  2 ++
 drivers/net/wireless/ath/ath10k/trace.h  | 29 +++++++++++++++++++++++++++++
 4 files changed, 53 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 48672da..29fa820 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1439,6 +1439,23 @@ void ath10k_debug_unregister(struct ath10k *ar)
 	cancel_delayed_work_sync(&ar->debug.htt_stats_dwork);
 }
 
+void ath10k_debug_pktlog_rx(struct ath10k *ar, struct sk_buff *msdu)
+{
+	struct htt_rx_desc *rxd;
+	u32 tsf;
+
+	if (!(ar->debug.pktlog_filter & ATH10K_PKTLOG_RX))
+		return;
+
+	while (msdu) {
+		rxd = (void *)msdu->data - sizeof(*rxd);
+		tsf = __le32_to_cpu(rxd->ppdu_end.tsf_timestamp);
+
+		trace_ath10k_rx_pktlog(ar, tsf, &rxd->attention,
+				       sizeof(*rxd) - sizeof(u32));
+		msdu = msdu->next;
+	}
+}
 #endif /* CONFIG_ATH10K_DEBUGFS */
 
 #ifdef CONFIG_ATH10K_DEBUG
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index aafdcab..389387c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -71,6 +71,7 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar);
 void ath10k_debug_dbglog_add(struct ath10k *ar, u8 *buffer, int len);
 #define ATH10K_DFS_STAT_INC(ar, c) (ar->debug.dfs_stats.c++)
 
+void ath10k_debug_pktlog_rx(struct ath10k *ar, struct sk_buff *msdu);
 #else
 static inline int ath10k_debug_start(struct ath10k *ar)
 {
@@ -121,6 +122,10 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
 	return NULL;
 }
 
+static inline void ath10k_debug_pktlog_rx(struct ath10k *ar,
+					  struct sk_buff *msdu)
+{
+}
 #define ATH10K_DFS_STAT_INC(ar, c) do { } while (0)
 
 #endif /* CONFIG_ATH10K_DEBUGFS */
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a078451..be24071 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1295,6 +1295,8 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				continue;
 			}
 
+			ath10k_debug_pktlog_rx(ar, msdu_head);
+
 			rxd = container_of((void *)msdu_head->data,
 					   struct htt_rx_desc,
 					   msdu_payload);
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 971ff23..3dff799 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -281,6 +281,35 @@ TRACE_EVENT(ath10k_htt_pktlog,
 	 )
 );
 
+TRACE_EVENT(ath10k_rx_pktlog,
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

