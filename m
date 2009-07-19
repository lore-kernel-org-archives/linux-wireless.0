Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:56076 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZGSVVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 17:21:11 -0400
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: fix spare warnings in driver-trace.h
Date: Sun, 19 Jul 2009 23:21:07 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907192321.07595.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following errors:

driver-trace.h:148:1: error: cannot size expression
driver-trace.h:148:1: error: cannot size expression
[...]
driver-trace.h:222:1: error: cannot size expression
driver-trace.h:71:1: error: incompatible types for operation (<)
driver-trace.h:71:1:    left side has type void *<noident>
driver-trace.h:71:1:    right side has type int
driver-trace.h:99:1: error: incompatible types for operation (<)
driver-trace.h:99:1:    left side has type void *<noident>
driver-trace.h:99:1:    right side has type int
driver-trace.h:148:1: error: incompatible types for operation (<)
driver-trace.h:148:1:    left side has type void *<noident>
driver-trace.h:148:1:    right side has type int
driver-trace.h:222:1: error: cannot size expression
driver-trace.h:248:1: error: incompatible types for operation (<)
driver-trace.h:248:1:    left side has type void *<noident>
driver-trace.h:248:1:    right side has type int
driver-trace.h:446:1: error: incompatible types for operation (<)
driver-trace.h:446:1:    left side has type void *<noident>
driver-trace.h:446:1:    right side has type int

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 48c93d1..5a10da2 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -5,7 +5,7 @@
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 
-#ifndef CONFIG_MAC80211_DRIVER_API_TRACER
+#if !defined(CONFIG_MAC80211_DRIVER_API_TRACER) || defined(__CHECKER__)
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, ...) \
 static inline void trace_ ## name(proto) {}
@@ -639,7 +639,7 @@ TRACE_EVENT(drv_ampdu_action,
 		LOCAL_PR_ARG, STA_PR_ARG, __entry->action, __entry->tid, __entry->ret
 	)
 );
-#endif /* __MAC80211_DRIVER_TRACE */
+#endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
 #define TRACE_INCLUDE_PATH .
