Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:46321 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442AbaJUOGr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 10:06:47 -0400
Received: by mail-lb0-f169.google.com with SMTP id 10so1092953lbg.28
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 07:06:45 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: re-use trace class
Date: Tue, 21 Oct 2014 15:55:00 +0200
Message-Id: <1413899700-10717-3-git-send-email-michal.kazior@tieto.com> (sfid-20141021_160652_236117_F2C62D3C)
In-Reply-To: <1413899700-10717-1-git-send-email-michal.kazior@tieto.com>
References: <1413899700-10717-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of defining a completely new tracepoint
use an existing tracepoint class.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/trace.h | 32 +++++---------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 2409cb5..b9a2ba6 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -281,33 +281,6 @@ TRACE_EVENT(ath10k_htt_pktlog,
 	 )
 );
 
-TRACE_EVENT(ath10k_htt_rx_desc,
-	    TP_PROTO(struct ath10k *ar, void *rxdesc, u16 len),
-
-	TP_ARGS(ar, rxdesc, len),
-
-	TP_STRUCT__entry(
-		__string(device, dev_name(ar->dev))
-		__string(driver, dev_driver_string(ar->dev))
-		__field(u16, len)
-		__dynamic_array(u8, rxdesc, len)
-	),
-
-	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
-		__entry->len = len;
-		memcpy(__get_dynamic_array(rxdesc), rxdesc, len);
-	),
-
-	TP_printk(
-		"%s %s len %hu",
-		__get_str(driver),
-		__get_str(device),
-		__entry->len
-	 )
-);
-
 TRACE_EVENT(ath10k_htt_tx,
 	    TP_PROTO(struct ath10k *ar, u16 msdu_id, u16 msdu_len,
 		     u8 vdev_id, u8 tid),
@@ -414,6 +387,11 @@ DEFINE_EVENT(ath10k_data_event, ath10k_wmi_bcn_tx,
 	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
 	     TP_ARGS(ar, data, len)
 );
+
+DEFINE_EVENT(ath10k_data_event, ath10k_htt_rx_desc,
+	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
+	     TP_ARGS(ar, data, len)
+);
 #endif /* _TRACE_H_ || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */
-- 
1.8.5.3

