Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39421 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaJFN0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 09:26:14 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/4] ath10k: add tracepoint for wmi bcn tx
Date: Mon, 6 Oct 2014 18:57:02 +0530
Message-ID: <1412602024-31706-3-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141006_152617_478235_577D592D)
In-Reply-To: <1412602024-31706-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1412602024-31706-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Allows an easier beacon inspection/debugging.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/trace.h | 27 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c   |  1 +
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 04236d6..c074de0 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -397,6 +397,33 @@ TRACE_EVENT(ath10k_wmi_mgmt_tx,
 		__entry->len
 	)
 );
+
+TRACE_EVENT(ath10k_wmi_bcn_tx,
+	    TP_PROTO(struct ath10k *ar, void *data, size_t len),
+
+	TP_ARGS(ar, data, len),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
+		__field(size_t, len)
+		__dynamic_array(u8, data, len)
+	),
+
+	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
+		__entry->len = len;
+		memcpy(__get_dynamic_array(data), data, len);
+	),
+
+	TP_printk(
+		"%s %s len %zu\n",
+		__get_str(driver),
+		__get_str(device),
+		__entry->len
+	)
+);
 #endif /* _TRACE_H_ || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6cf4bfc..54042bf 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1893,6 +1893,7 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 		arvif->beacon = bcn;
 		arvif->beacon_sent = false;
 
+		trace_ath10k_wmi_bcn_tx(ar, bcn->data, bcn->len);
 		ath10k_wmi_tx_beacon_nowait(arvif);
 skip:
 		spin_unlock_bh(&ar->data_lock);
-- 
2.1.2

