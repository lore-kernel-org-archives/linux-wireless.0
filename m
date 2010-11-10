Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36265 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab0KJCVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:35 -0500
Received: by mail-qy0-f181.google.com with SMTP id 31so159944qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:35 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 28/44] compat: avoid using `#include_next' directive in compat headers
Date: Tue,  9 Nov 2010 21:20:10 -0500
Message-Id: <1289355626-25373-29-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/pm_qos_params.h |    7 +++----
 include/linux/tracepoint.h    |   14 +++++++-------
 include/net/net_namespace.h   |   14 +++++++-------
 include/trace/define_trace.h  |    5 -----
 4 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/include/linux/pm_qos_params.h b/include/linux/pm_qos_params.h
index e1f083c..8c69ab2 100644
--- a/include/linux/pm_qos_params.h
+++ b/include/linux/pm_qos_params.h
@@ -1,8 +1,7 @@
 #include <linux/version.h>
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
-#include_next <linux/pm_qos_params.h>
-#else
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25))
+
 /* interface for the pm_qos_power infrastructure of the linux kernel.
  *
  * Mark Gross <mgross@linux.intel.com>
@@ -28,5 +27,5 @@ int pm_qos_requirement(int qos);
 
 int pm_qos_add_notifier(int qos, struct notifier_block *notifier);
 int pm_qos_remove_notifier(int qos, struct notifier_block *notifier);
-#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25)) */
 
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25)) */
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 9f5add1..4619247 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -1,10 +1,10 @@
-#ifndef _COMPAT_LINUX_TRACEPOINT_H
-#define _COMPAT_LINUX_TRACEPOINT_H 1
-
 #include <linux/version.h>
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
-#include_next <linux/tracepoint.h>
-#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)) */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28))
+
+#ifndef _LINUX_TRACEPOINT_H
+#define _LINUX_TRACEPOINT_H
+
+#endif /* _LINUX_TRACEPOINT_H */
 
-#endif	/* _COMPAT_LINUX_TRACEPOINT_H */
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)) */
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 0f74944..23a517a 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -1,10 +1,10 @@
-#ifndef _COMPAT_NET_NET_NAMESPACE_H
-#define _COMPAT_NET_NET_NAMESPACE_H 1
-
 #include <linux/version.h>
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,23))
-#include_next <net/net_namespace.h>
-#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,23)) */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
+
+#ifndef __NET_NET_NAMESPACE_H
+#define __NET_NET_NAMESPACE_H
+
+#endif /* __NET_NET_NAMESPACE_H */
 
-#endif	/* _COMPAT_NET_NET_NAMESPACE_H */
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)) */
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 7d03ccf..e69de29 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -1,5 +0,0 @@
-#include <linux/version.h>
-
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
-#include_next <trace/define_trace.h>
-#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30)) */
-- 
1.7.2.30.gc37d7.dirty

