Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:34828 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753318AbdBVIPc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Feb 2017 03:15:32 -0500
Received: by mail-lf0-f42.google.com with SMTP id z127so2070243lfa.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Feb 2017 00:15:31 -0800 (PST)
From: Marcin Rokicki <marcin.rokicki@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: Modify macros to fix style issues
Date: Wed, 22 Feb 2017 09:15:27 +0100
Message-Id: <1487751327-2917-1-git-send-email-marcin.rokicki@tieto.com> (sfid-20170222_091536_364315_DB5584EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both macros are used internally to convert incomming parameters
to strings in a switch case statement.

Current implementation gives following output from checkpatch.pl:
 - ERROR: Macros with complex values should be enclosed in parentheses
 - WARNING: Macros with flow control statements should be avoided

Fix them by modify local variable in the middle and just return at the end.

Btw add const to function that return string literals

Signed-off-by: Marcin Rokicki <marcin.rokicki@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 36 +++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 427220c..0bf578f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -312,9 +312,16 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_TX_MODE_DYNAMIC,
 };
 
-static inline char *wmi_service_name(int service_id)
+#define SVCSTR(x) \
+{ \
+	case x: \
+		str = #x; \
+		break; \
+}
+
+static inline const char *wmi_service_name(int service_id)
 {
-#define SVCSTR(x) case x: return #x
+	const char *str = NULL;
 
 	switch (service_id) {
 	SVCSTR(WMI_SERVICE_BEACON_OFFLOAD);
@@ -408,13 +415,13 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_TX_MODE_PUSH_ONLY);
 	SVCSTR(WMI_SERVICE_TX_MODE_PUSH_PULL);
 	SVCSTR(WMI_SERVICE_TX_MODE_DYNAMIC);
-	default:
-		return NULL;
 	}
 
-#undef SVCSTR
+	return str;
 }
 
+#undef SVCSTR
+
 #define WMI_SERVICE_IS_ENABLED(wmi_svc_bmap, svc_id, len) \
 	((svc_id) < (len) && \
 	 __le32_to_cpu((wmi_svc_bmap)[(svc_id) / (sizeof(u32))]) & \
@@ -6412,10 +6419,17 @@ enum wmi_wow_wakeup_event {
 	WOW_EVENT_MAX,
 };
 
-#define C2S(x) case x: return #x
+#define C2S(x) \
+{ \
+	case x: \
+		str = #x; \
+		break; \
+}
 
 static inline const char *wow_wakeup_event(enum wmi_wow_wakeup_event ev)
 {
+	const char *str = NULL;
+
 	switch (ev) {
 	C2S(WOW_BMISS_EVENT);
 	C2S(WOW_BETTER_AP_EVENT);
@@ -6442,9 +6456,9 @@ static inline const char *wow_wakeup_event(enum wmi_wow_wakeup_event ev)
 	C2S(WOW_BEACON_EVENT);
 	C2S(WOW_CLIENT_KICKOUT_EVENT);
 	C2S(WOW_EVENT_MAX);
-	default:
-		return NULL;
 	}
+
+	return str;
 }
 
 enum wmi_wow_wake_reason {
@@ -6482,6 +6496,8 @@ enum wmi_wow_wake_reason {
 
 static inline const char *wow_reason(enum wmi_wow_wake_reason reason)
 {
+	const char *str = NULL;
+
 	switch (reason) {
 	C2S(WOW_REASON_UNSPECIFIED);
 	C2S(WOW_REASON_NLOD);
@@ -6513,9 +6529,9 @@ static inline const char *wow_reason(enum wmi_wow_wake_reason reason)
 	C2S(WOW_REASON_BEACON_RECV);
 	C2S(WOW_REASON_CLIENT_KICKOUT_EVENT);
 	C2S(WOW_REASON_DEBUG_TEST);
-	default:
-		return NULL;
 	}
+
+	return str;
 }
 
 #undef C2S
-- 
2.7.4
