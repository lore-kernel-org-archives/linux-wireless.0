Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:51723 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaACLIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jan 2014 06:08:53 -0500
Subject: [PATCH 2/3] ath10k: add trace event for WMI_DEBUG_MESG_EVENTID
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 03 Jan 2014 12:59:26 +0200
Message-ID: <20140103105926.13474.5152.stgit@potku.adurom.net> (sfid-20140103_120900_082939_9E311E9C)
In-Reply-To: <20140103105718.13474.70922.stgit@potku.adurom.net>
References: <20140103105718.13474.70922.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send firmware WMI debug logs to user space for further processing.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/trace.h |   21 +++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c   |    9 +++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 90817dd..4eb2ecb 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -182,6 +182,27 @@ TRACE_EVENT(ath10k_htt_stats,
 	)
 );
 
+TRACE_EVENT(ath10k_wmi_dbglog,
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
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index f992570..4e043bb 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1071,9 +1071,14 @@ static void ath10k_wmi_event_echo(struct ath10k *ar, struct sk_buff *skb)
 	ath10k_dbg(ATH10K_DBG_WMI, "WMI_ECHO_EVENTID\n");
 }
 
-static void ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
+static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_DEBUG_MESG_EVENTID\n");
+	ath10k_dbg(ATH10K_DBG_WMI, "wmi event debug mesg len %d\n",
+		   skb->len);
+
+	trace_ath10k_wmi_dbglog(skb->data, skb->len);
+
+	return 0;
 }
 
 static void ath10k_wmi_event_update_stats(struct ath10k *ar,

