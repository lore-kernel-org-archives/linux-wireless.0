Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33044 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbbDJNFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 09:05:14 -0400
Received: by lbbzk7 with SMTP id zk7so13203464lbb.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2015 06:05:13 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: add extra check for frame tracing
Date: Fri, 10 Apr 2015 13:02:28 +0000
Message-Id: <1428670948-7665-1-git-send-email-michal.kazior@tieto.com> (sfid-20150410_150519_454285_48CAC652)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frames are logged via tracing in two slices:
header and payload, separately. This is done for
performance reasons when one wants to, e.g.
analyse metadata only of frames only.

If for some reason device delivered a frame buffer
which was sized below what 802.11 header implied
tracing logic would blow doing an invalid memory
accesses.

I've hit this problem when running IBSS on QCA988X
with 999.999.0.636 and tracing at the same time.

Fixes: 5ce8e7fdcc7a ("ath10k: handle ieee80211 header and payload tracing separately")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/trace.h | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 71dfcd96354b..71bdb368813d 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -21,11 +21,16 @@
 #include "core.h"
 
 #if !defined(_TRACE_H_)
-static inline u32 ath10k_frm_hdr_len(const void *buf)
+static inline u32 ath10k_frm_hdr_len(const void *buf, size_t len)
 {
 	const struct ieee80211_hdr *hdr = buf;
 
-	return ieee80211_hdrlen(hdr->frame_control);
+	/* In some rare cases (e.g. fcs error) device reports frame buffer
+	 * shorter than what frame header implies (e.g. len = 0). The buffer
+	 * can still be accessed so do a simple min() to guarantee caller
+	 * doesn't get value greater than len.
+	 */
+	return min_t(u32, len, ieee80211_hdrlen(hdr->frame_control));
 }
 #endif
 
@@ -360,13 +365,13 @@ DECLARE_EVENT_CLASS(ath10k_hdr_event,
 		__string(device, dev_name(ar->dev))
 		__string(driver, dev_driver_string(ar->dev))
 		__field(size_t, len)
-		__dynamic_array(u8, data, ath10k_frm_hdr_len(data))
+		__dynamic_array(u8, data, ath10k_frm_hdr_len(data, len))
 	),
 
 	TP_fast_assign(
 		__assign_str(device, dev_name(ar->dev));
 		__assign_str(driver, dev_driver_string(ar->dev));
-		__entry->len = ath10k_frm_hdr_len(data);
+		__entry->len = ath10k_frm_hdr_len(data, len);
 		memcpy(__get_dynamic_array(data), data, __entry->len);
 	),
 
@@ -387,15 +392,16 @@ DECLARE_EVENT_CLASS(ath10k_payload_event,
 		__string(device, dev_name(ar->dev))
 		__string(driver, dev_driver_string(ar->dev))
 		__field(size_t, len)
-		__dynamic_array(u8, payload, (len - ath10k_frm_hdr_len(data)))
+		__dynamic_array(u8, payload, (len -
+					      ath10k_frm_hdr_len(data, len)))
 	),
 
 	TP_fast_assign(
 		__assign_str(device, dev_name(ar->dev));
 		__assign_str(driver, dev_driver_string(ar->dev));
-		__entry->len = len - ath10k_frm_hdr_len(data);
+		__entry->len = len - ath10k_frm_hdr_len(data, len);
 		memcpy(__get_dynamic_array(payload),
-		       data + ath10k_frm_hdr_len(data), __entry->len);
+		       data + ath10k_frm_hdr_len(data, len), __entry->len);
 	),
 
 	TP_printk(
-- 
2.1.4

