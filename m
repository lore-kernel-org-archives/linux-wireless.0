Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56608 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758276AbZJLVUI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 17:20:08 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/9] [compat-2.6] Move trace headers
Date: Mon, 12 Oct 2009 23:19:12 +0200
Message-Id: <1255382358-20760-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move tracepoint headers into own patch file.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/patches/06-header-changes.patch |   19 -----------------
 compat/patches/13-trace.patch          |   35 +++++++++++++++++++++++++++++--
 2 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/compat/patches/06-header-changes.patch b/compat/patches/06-header-changes.patch
index b2e8fd8..ee0be7f 100644
--- a/compat/patches/06-header-changes.patch
+++ b/compat/patches/06-header-changes.patch
@@ -40,25 +40,6 @@ cases.
  #include <linux/spi/spi.h>
  #include <linux/spi/wl12xx.h>
  
---- a/net/mac80211/driver-trace.h	2009-08-18 16:19:34.574352433 -0700
-+++ b/net/mac80211/driver-trace.h	2009-08-18 16:19:35.694367614 -0700
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
-@@ -669,4 +671,6 @@ TRACE_EVENT(drv_ampdu_action,
- #define TRACE_INCLUDE_PATH .
- #undef TRACE_INCLUDE_FILE
- #define TRACE_INCLUDE_FILE driver-trace
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
- #include <trace/define_trace.h>
-+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30)) */
 --- a/net/mac80211/key.c
 +++ b/net/mac80211/key.c
 @@ -21,6 +21,9 @@
diff --git a/compat/patches/13-trace.patch b/compat/patches/13-trace.patch
index c43e723..144cae5 100644
--- a/compat/patches/13-trace.patch
+++ b/compat/patches/13-trace.patch
@@ -4,12 +4,41 @@ in or compat headers.
 
 [1] http://lxr.linux.no/#linux+v2.6.31/include/trace/define_trace.h
 
---- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h	2009-10-08 16:21:09.000000000 -0400
-+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h	2009-10-08 16:23:34.000000000 -0400
+--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
++++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+@@ -1,7 +1,9 @@
+ #if !defined(__IWLWIFI_DEVICE_TRACE) || defined(TRACE_HEADER_MULTI_READ)
+ #define __IWLWIFI_DEVICE_TRACE
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+ #include <linux/tracepoint.h>
++#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)) */
+ #include "iwl-dev.h"
+ 
+ #if !defined(CONFIG_IWLWIFI_DEVICE_TRACING) || defined(__CHECKER__)
 @@ -175,4 +175,6 @@
  #define TRACE_INCLUDE_PATH .
  #undef TRACE_INCLUDE_FILE
  #define TRACE_INCLUDE_FILE iwl-devtrace
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
  #include <trace/define_trace.h>
 +#endif
+--- a/net/mac80211/driver-trace.h	2009-08-18 16:19:34.574352433 -0700
++++ b/net/mac80211/driver-trace.h	2009-08-18 16:19:35.694367614 -0700
+@@ -1,7 +1,9 @@
+ #if !defined(__MAC80211_DRIVER_TRACE) || defined(TRACE_HEADER_MULTI_READ)
+ #define __MAC80211_DRIVER_TRACE
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+ #include <linux/tracepoint.h>
++#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)) */
+ #include <net/mac80211.h>
+ #include "ieee80211_i.h"
+ 
+@@ -669,4 +671,6 @@ TRACE_EVENT(drv_ampdu_action,
+ #define TRACE_INCLUDE_PATH .
+ #undef TRACE_INCLUDE_FILE
+ #define TRACE_INCLUDE_FILE driver-trace
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
+ #include <trace/define_trace.h>
++#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30)) */
-- 
1.6.2.1

