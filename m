Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43697 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab0DRNiK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Apr 2010 09:38:10 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: Add linux/version.h include before using it.
Date: Sun, 18 Apr 2010 15:37:57 +0200
Message-Id: <1271597877-4878-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1271597877-4878-1-git-send-email-hauke@hauke-m.de>
References: <1271597877-4878-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This causes problems if theses header files are used without including
linux/compat-2.6.h

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/tracepoint.h   |    2 ++
 include/net/net_namespace.h  |    2 ++
 include/trace/define_trace.h |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 7484716..9f5add1 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -1,6 +1,8 @@
 #ifndef _COMPAT_LINUX_TRACEPOINT_H
 #define _COMPAT_LINUX_TRACEPOINT_H 1
 
+#include <linux/version.h>
+
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
 #include_next <linux/tracepoint.h>
 #endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)) */
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 206c0c1..0f74944 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -1,6 +1,8 @@
 #ifndef _COMPAT_NET_NET_NAMESPACE_H
 #define _COMPAT_NET_NET_NAMESPACE_H 1
 
+#include <linux/version.h>
+
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,23))
 #include_next <net/net_namespace.h>
 #endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,23)) */
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index f5c01de..a31105a 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -1,6 +1,8 @@
 #ifndef _COMPAT_TRACE_DEFINE_TRACE_H
 #define _COMPAT_TRACE_DEFINE_TRACE_H 1
 
+#include <linux/version.h>
+
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
 #include_next <trace/define_trace.h>
 #endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30)) */
-- 
1.6.3.3

