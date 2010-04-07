Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:34604 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab0DGFa5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 01:30:57 -0400
Subject: [PATCH 2/4] compat-wireless: remove 13-trace.patch,
 it's handled in compat now
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 07 Apr 2010 01:30:56 -0400
Message-ID: <20100407053056.23575.12200.stgit@mj.roinet.com>
In-Reply-To: <20100407053051.23575.94594.stgit@mj.roinet.com>
References: <20100407053051.23575.94594.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 patches/13-trace.patch |   63 ------------------------------------------------
 1 files changed, 0 insertions(+), 63 deletions(-)
 delete mode 100644 patches/13-trace.patch

diff --git a/patches/13-trace.patch b/patches/13-trace.patch
deleted file mode 100644
index e3fee40..0000000
--- a/patches/13-trace.patch
+++ /dev/null
@@ -1,63 +0,0 @@
-Older kernels do not have trace/define_trace.h [1] and if there
-is something there that we can backport we will define it
-in or compat headers.
-
-[1] http://lxr.linux.no/#linux+v2.6.31/include/trace/define_trace.h
-
---- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
-+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
-@@ -27,7 +27,9 @@
- #if !defined(__IWLWIFI_DEVICE_TRACE) || defined(TRACE_HEADER_MULTI_READ)
- #define __IWLWIFI_DEVICE_TRACE
- 
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
- #include <linux/tracepoint.h>
-+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)) */
- 
- #if !defined(CONFIG_IWLWIFI_DEVICE_TRACING) || defined(__CHECKER__)
- #undef TRACE_EVENT
-@@ -263,4 +265,6 @@ TRACE_EVENT(iwlwifi_dev_ucode_event,
- #define TRACE_INCLUDE_PATH .
- #undef TRACE_INCLUDE_FILE
- #define TRACE_INCLUDE_FILE iwl-devtrace
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
- #include <trace/define_trace.h>
-+#endif
---- a/drivers/net/wireless/iwmc3200wifi/trace.h
-+++ b/drivers/net/wireless/iwmc3200wifi/trace.h
-@@ -1,7 +1,9 @@
- #if !defined(__IWM_TRACE_H__) || defined(TRACE_HEADER_MULTI_READ)
- #define __IWM_TRACE_H__
- 
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
- #include <linux/tracepoint.h>
-+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)) */
- 
- #if !defined(CONFIG_IWM_TRACING)
- #undef TRACE_EVENT
-@@ -280,4 +282,6 @@ TRACE_EVENT(iwm_rx_packet,
- #define TRACE_INCLUDE_PATH .
- #undef TRACE_INCLUDE_FILE
- #define TRACE_INCLUDE_FILE trace
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
- #include <trace/define_trace.h>
-+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30)) */
---- a/net/mac80211/driver-trace.h
-+++ b/net/mac80211/driver-trace.h
-@@ -1,7 +1,9 @@
- #if !defined(__MAC80211_DRIVER_TRACE) || defined(TRACE_HEADER_MULTI_READ)
- #define __MAC80211_DRIVER_TRACE
- 
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
- #include <linux/tracepoint.h>
-+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)) */
- #include <net/mac80211.h>
- #include "ieee80211_i.h"
- 
-@@ -772,4 +774,6 @@ TRACE_EVENT(drv_flush,
- #define TRACE_INCLUDE_PATH .
- #undef TRACE_INCLUDE_FILE
- #define TRACE_INCLUDE_FILE driver-trace
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
- #include <trace/define_trace.h>
-+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30)) */
