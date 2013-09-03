Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:39608 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab3ICIn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 04:43:58 -0400
Subject: [PATCH 1/3] ath10k: add trace event ath10k_htt_stats
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Sep 2013 11:43:55 +0300
Message-ID: <20130903084355.26199.33730.stgit@localhost6.localdomain6> (sfid-20130903_104402_680268_4B65A519)
In-Reply-To: <20130903084302.26199.3538.stgit@localhost6.localdomain6>
References: <20130903084302.26199.3538.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For analysing various data path statistics in user space.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |    5 ++++-
 drivers/net/wireless/ath/ath10k/trace.h  |   21 +++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 9bb0ae89..af31d2f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -20,6 +20,7 @@
 #include "htt.h"
 #include "txrx.h"
 #include "debug.h"
+#include "trace.h"
 
 #include <linux/log2.h>
 
@@ -1198,8 +1199,10 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 	case HTT_T2H_MSG_TYPE_TEST:
 		/* FIX THIS */
 		break;
-	case HTT_T2H_MSG_TYPE_TX_INSPECT_IND:
 	case HTT_T2H_MSG_TYPE_STATS_CONF:
+		trace_ath10k_htt_stats(skb->data, skb->len);
+		break;
+	case HTT_T2H_MSG_TYPE_TX_INSPECT_IND:
 	case HTT_T2H_MSG_TYPE_RX_ADDBA:
 	case HTT_T2H_MSG_TYPE_RX_DELBA:
 	case HTT_T2H_MSG_TYPE_RX_FLUSH:
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 85e806b..bf1ceb8 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -158,6 +158,27 @@ TRACE_EVENT(ath10k_wmi_event,
 	)
 );
 
+TRACE_EVENT(ath10k_htt_stats,
+	TP_PROTO(void *buf, size_t buf_len),
+
+	TP_ARGS(buf, buf_len),
+
+	TP_STRUCT__entry(
+		__field(size_t, buf_len)
+		__dynamic_array(u8, buf, buf_len)
+	),
+
+	TP_fast_assign(
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(buf), buf, buf_len);
+	),
+
+	TP_printk(
+		"len %zu",
+		__entry->buf_len
+	)
+);
+
 #endif /* _TRACE_H_ || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */

