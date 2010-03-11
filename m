Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47376 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab0CKVdK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 16:33:10 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/5] compat-wireless: fix building of iwmc3200wifi
Date: Thu, 11 Mar 2010 22:32:45 +0100
Message-Id: <1268343167-2961-6-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
References: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/13-trace.patch |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/patches/13-trace.patch b/patches/13-trace.patch
index 8c000f3..82b2643 100644
--- a/patches/13-trace.patch
+++ b/patches/13-trace.patch
@@ -23,6 +23,25 @@ in or compat headers.
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
  #include <trace/define_trace.h>
 +#endif
+--- a/drivers/net/wireless/iwmc3200wifi/trace.h
++++ b/drivers/net/wireless/iwmc3200wifi/trace.h
+@@ -1,7 +1,9 @@
+ #if !defined(__IWM_TRACE_H__) || defined(TRACE_HEADER_MULTI_READ)
+ #define __IWM_TRACE_H__
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+ #include <linux/tracepoint.h>
++#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)) */
+ 
+ #if !defined(CONFIG_IWM_TRACING)
+ #undef TRACE_EVENT
+@@ -280,4 +282,6 @@ TRACE_EVENT(iwm_rx_packet,
+ #define TRACE_INCLUDE_PATH .
+ #undef TRACE_INCLUDE_FILE
+ #define TRACE_INCLUDE_FILE trace
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
+ #include <trace/define_trace.h>
++#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30)) */
 --- a/net/mac80211/driver-trace.h
 +++ b/net/mac80211/driver-trace.h
 @@ -1,7 +1,9 @@
-- 
1.6.3.3

