Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95129C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 13:04:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D2222067D
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 13:04:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfDZNEq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 09:04:46 -0400
Received: from alexa-out-blr-02.qualcomm.com ([103.229.18.198]:17395 "EHLO
        alexa-out-blr.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726067AbfDZNEq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 09:04:46 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Apr 2019 09:04:44 EDT
X-IronPort-AV: E=Sophos;i="5.60,397,1549909800"; 
   d="scan'208";a="426434"
Received: from ironmsg01-blr.qualcomm.com ([10.86.208.130])
  by alexa-out-blr.qualcomm.com with ESMTP/TLS/AES256-SHA; 26 Apr 2019 18:28:28 +0530
X-IronPort-AV: E=McAfee;i="5900,7806,9238"; a="8980313"
Received: from vnaralas-linux.qualcomm.com ([10.201.26.231])
  by ironmsg01-blr.qualcomm.com with ESMTP; 26 Apr 2019 18:28:28 +0530
Received: by vnaralas-linux.qualcomm.com (Postfix, from userid 443942)
        id CB1CE2B63; Fri, 26 Apr 2019 18:28:26 +0530 (IST)
From:   Venkateswara Naralasetty <vnaralas@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        Kan Yan <kyan@chromium.org>
Subject: [PATCHv2] ath10k: Add wrapper function to ath10k debug
Date:   Fri, 26 Apr 2019 18:28:25 +0530
Message-Id: <1556283505-29539-1-git-send-email-vnaralas@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ath10k_dbg() is called in ath10k_process_rx() with huge set of arguments
which is causing CPU overhead even when debug_mask is not set.
Good improvement was observed in the receive side performance when call
to ath10k_dbg() is avoided in the RX path.

Since currently all debug messages are sent via tracing infrastructure,
we cannot entirely avoid calling ath10k_dbg. Therefore, call to
ath10k_dbg() is made conditional based on tracing config in the driver.

Trasmit performance remains unchanged with this patch; below are some
experimental results with this patch and tracing disabled.

mesh mode:

		w/o this patch          with this patch
Traffic       TP      CPU Usage      TP      CPU usage

TCP          840Mbps    76.53%      960Mbps    78.14%
UDP          1030Mbps   74.58%      1132Mbps   74.31%

Infra mode:

		w/o this patch          with this patch
Traffic        TP      CPU Usage      TP      CPU usage

TCP Rx       1241Mbps   80.89%      1270Mbps   73.50%
UDP Rx       1433Mbps   81.77%      1472Mbps   72.80%

Tested platform	: IPQ8064
hardware used	: QCA9984
firmware ver	: ver 10.4-3.5.3-00057

Signed-off-by: Kan Yan <kyan@chromium.org>
Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
---
v2:
 * changed trace enabled check from IS_ENABLED(CONFIG_ATH10K_TRACING)
 * to trace_ath10k_log_dbg_enabled().

 drivers/net/wireless/ath/ath10k/core.c  |  2 ++
 drivers/net/wireless/ath/ath10k/debug.c |  8 ++++----
 drivers/net/wireless/ath/ath10k/debug.h | 22 ++++++++++++++++------
 drivers/net/wireless/ath/ath10k/trace.c |  1 +
 drivers/net/wireless/ath/ath10k/trace.h |  6 +++++-
 5 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index cfd7bb2..ab709bf 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -26,6 +26,8 @@
 #include "coredump.h"
 
 unsigned int ath10k_debug_mask;
+EXPORT_SYMBOL(ath10k_debug_mask);
+
 static unsigned int ath10k_cryptmode_param;
 static bool uart_print;
 static bool skip_otp;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 32d967a..1b63929 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2620,8 +2620,8 @@ void ath10k_debug_unregister(struct ath10k *ar)
 #endif /* CONFIG_ATH10K_DEBUGFS */
 
 #ifdef CONFIG_ATH10K_DEBUG
-void ath10k_dbg(struct ath10k *ar, enum ath10k_debug_mask mask,
-		const char *fmt, ...)
+void __ath10k_dbg(struct ath10k *ar, enum ath10k_debug_mask mask,
+		  const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -2638,7 +2638,7 @@ void ath10k_dbg(struct ath10k *ar, enum ath10k_debug_mask mask,
 
 	va_end(args);
 }
-EXPORT_SYMBOL(ath10k_dbg);
+EXPORT_SYMBOL(__ath10k_dbg);
 
 void ath10k_dbg_dump(struct ath10k *ar,
 		     enum ath10k_debug_mask mask,
@@ -2651,7 +2651,7 @@ void ath10k_dbg_dump(struct ath10k *ar,
 
 	if (ath10k_debug_mask & mask) {
 		if (msg)
-			ath10k_dbg(ar, mask, "%s\n", msg);
+			__ath10k_dbg(ar, mask, "%s\n", msg);
 
 		for (ptr = buf; (ptr - buf) < len; ptr += 16) {
 			linebuflen = 0;
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index db78e85..a5b2039 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -240,18 +240,18 @@ void ath10k_sta_update_rx_tid_stats_ampdu(struct ath10k *ar,
 #endif /* CONFIG_MAC80211_DEBUGFS */
 
 #ifdef CONFIG_ATH10K_DEBUG
-__printf(3, 4) void ath10k_dbg(struct ath10k *ar,
-			       enum ath10k_debug_mask mask,
-			       const char *fmt, ...);
+__printf(3, 4) void __ath10k_dbg(struct ath10k *ar,
+				 enum ath10k_debug_mask mask,
+				 const char *fmt, ...);
 void ath10k_dbg_dump(struct ath10k *ar,
 		     enum ath10k_debug_mask mask,
 		     const char *msg, const char *prefix,
 		     const void *buf, size_t len);
 #else /* CONFIG_ATH10K_DEBUG */
 
-static inline int ath10k_dbg(struct ath10k *ar,
-			     enum ath10k_debug_mask dbg_mask,
-			     const char *fmt, ...)
+static inline int __ath10k_dbg(struct ath10k *ar,
+			       enum ath10k_debug_mask dbg_mask,
+			       const char *fmt, ...)
 {
 	return 0;
 }
@@ -263,4 +263,14 @@ static inline void ath10k_dbg_dump(struct ath10k *ar,
 {
 }
 #endif /* CONFIG_ATH10K_DEBUG */
+
+/* Avoid calling __ath10k_dbg() if debug_mask is not set and tracing
+ * disabled.
+ */
+#define ath10k_dbg(ar, dbg_mask, fmt, ...)			\
+do {								\
+	if ((ath10k_debug_mask & dbg_mask) ||			\
+	    trace_ath10k_log_dbg_enabled())			\
+		__ath10k_dbg(ar, dbg_mask, fmt, ##__VA_ARGS__); \
+} while (0)
 #endif /* _DEBUG_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/trace.c b/drivers/net/wireless/ath/ath10k/trace.c
index 3ecdff1..c7d4c97 100644
--- a/drivers/net/wireless/ath/ath10k/trace.c
+++ b/drivers/net/wireless/ath/ath10k/trace.c
@@ -7,3 +7,4 @@
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
+EXPORT_SYMBOL(__tracepoint_ath10k_log_dbg);
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index ba977bb..ab91645 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -29,7 +29,11 @@ static inline u32 ath10k_frm_hdr_len(const void *buf, size_t len)
 #if !defined(CONFIG_ATH10K_TRACING)
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, ...) \
-static inline void trace_ ## name(proto) {}
+static inline void trace_ ## name(proto) {} \
+static inline bool trace_##name##_enabled(void) \
+{						\
+	return false;				\
+}
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(...)
 #undef DEFINE_EVENT
-- 
2.7.4

