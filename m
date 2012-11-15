Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58890 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767951Ab2KOOIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:34 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 09/22] brcm80211: Allow trace support to be enabled separately from debug
Date: Thu, 15 Nov 2012 08:07:59 -0600
Message-Id: <1352988492-21340-10-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150842_264382_4A49BB12)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the runtime overhead of trace support is small when tracing is
disabled, users may be interested in turning on trace support while
leaving other debug features off. Add a new config option named
CONFIG_BRCM_TRACING for this purpose.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/Kconfig             |   11 +++++++++++
 .../brcm80211/brcmsmac/brcms_trace_events.h        |    6 +++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index c9d811e..3735c27 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -63,6 +63,17 @@ config BRCMISCAN
 	  new E-Scan method which uses less memory in firmware and gives no
 	  limitation on the number of scan results.
 
+config BRCM_TRACING
+	bool "Broadcom device tracing"
+	depends on BRCMSMAC || BRCMFMAC
+	---help---
+	  If you say Y here, the Broadcom wireless drivers will register
+	  with ftrace to dump event information into the trace ringbuffer.
+	  Tracing can be enabled at runtime to aid in debugging wireless
+	  issues. This option adds a small amount of overhead when tracing
+	  is disabled. If unsure, say Y to allow developers to better help
+	  you when wireless problems occur.
+
 config BRCMDBG
 	bool "Broadcom driver debug functions"
 	depends on BRCMSMAC || BRCMFMAC
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
index 27dd73e..bcf6969 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
@@ -24,7 +24,7 @@
 #include <linux/tracepoint.h>
 #include "mac80211_if.h"
 
-#ifndef CONFIG_BRCMDBG
+#ifndef CONFIG_BRCM_TRACING
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, ...) \
 static inline void trace_ ## name(proto) {}
@@ -80,7 +80,7 @@ TRACE_EVENT(brcms_dpc,
 
 #endif /* __TRACE_BRCMSMAC_H */
 
-#ifdef CONFIG_BRCMDBG
+#ifdef CONFIG_BRCM_TRACING
 
 #undef TRACE_INCLUDE_PATH
 #define TRACE_INCLUDE_PATH .
@@ -89,4 +89,4 @@ TRACE_EVENT(brcms_dpc,
 
 #include <trace/define_trace.h>
 
-#endif /* CONFIG_BRCMDBG */
+#endif /* CONFIG_BRCM_TRACING */
-- 
1.7.9.5

