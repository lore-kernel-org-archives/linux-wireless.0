Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20261 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbcBEPnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 10:43:22 -0500
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <arnagara@qti.qualcomm.com>,
	<kvalo@qca.qualcomm.com>
Subject: [PATCH 2/2] ath10k: add hw_rev to trace events to support pktlog
Date: Fri, 5 Feb 2016 21:12:49 +0530
Message-ID: <1454686969-5740-2-git-send-email-arnagara@qti.qualcomm.com> (sfid-20160205_164325_344120_A98BEB2E)
In-Reply-To: <1454686969-5740-1-git-send-email-arnagara@qti.qualcomm.com>
References: <1454686969-5740-1-git-send-email-arnagara@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pktlog data is different between firmware variants (eg. 10.2 vs 10.4). To
have a unified user space script to decode pktlog trace events generated,
it is desirable to know which firmware variant has provided the events and
thereby decode the pktlogs appropriately. Hardware revision (hw_rev) helps
to determine the firmware variant sending these trace events. So add hw_rev
to trace events.

Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/trace.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 71bdb36..e0d00ce 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -250,6 +250,7 @@ TRACE_EVENT(ath10k_wmi_dbglog,
 	TP_STRUCT__entry(
 		__string(device, dev_name(ar->dev))
 		__string(driver, dev_driver_string(ar->dev))
+		__field(u8, hw_type);
 		__field(size_t, buf_len)
 		__dynamic_array(u8, buf, buf_len)
 	),
@@ -257,14 +258,16 @@ TRACE_EVENT(ath10k_wmi_dbglog,
 	TP_fast_assign(
 		__assign_str(device, dev_name(ar->dev));
 		__assign_str(driver, dev_driver_string(ar->dev));
+		__entry->hw_type = ar->hw_rev;
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(buf), buf, buf_len);
 	),
 
 	TP_printk(
-		"%s %s len %zu",
+		"%s %s %d len %zu",
 		__get_str(driver),
 		__get_str(device),
+		__entry->hw_type,
 		__entry->buf_len
 	)
 );
@@ -277,6 +280,7 @@ TRACE_EVENT(ath10k_htt_pktlog,
 	TP_STRUCT__entry(
 		__string(device, dev_name(ar->dev))
 		__string(driver, dev_driver_string(ar->dev))
+		__field(u8, hw_type);
 		__field(u16, buf_len)
 		__dynamic_array(u8, pktlog, buf_len)
 	),
@@ -284,14 +288,16 @@ TRACE_EVENT(ath10k_htt_pktlog,
 	TP_fast_assign(
 		__assign_str(device, dev_name(ar->dev));
 		__assign_str(driver, dev_driver_string(ar->dev));
+		__entry->hw_type = ar->hw_rev;
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(pktlog), buf, buf_len);
 	),
 
 	TP_printk(
-		"%s %s size %hu",
+		"%s %s %d size %hu",
 		__get_str(driver),
 		__get_str(device),
+		__entry->hw_type,
 		__entry->buf_len
 	 )
 );
@@ -440,6 +446,7 @@ TRACE_EVENT(ath10k_htt_rx_desc,
 	TP_STRUCT__entry(
 		__string(device, dev_name(ar->dev))
 		__string(driver, dev_driver_string(ar->dev))
+		__field(u8, hw_type);
 		__field(u16, len)
 		__dynamic_array(u8, rxdesc, len)
 	),
@@ -447,14 +454,16 @@ TRACE_EVENT(ath10k_htt_rx_desc,
 	TP_fast_assign(
 		__assign_str(device, dev_name(ar->dev));
 		__assign_str(driver, dev_driver_string(ar->dev));
+		__entry->hw_type = ar->hw_rev;
 		__entry->len = len;
 		memcpy(__get_dynamic_array(rxdesc), data, len);
 	),
 
 	TP_printk(
-		"%s %s rxdesc len %d",
+		"%s %s %d rxdesc len %d",
 		__get_str(driver),
 		__get_str(device),
+		__entry->hw_type,
 		__entry->len
 	 )
 );
-- 
1.9.1

