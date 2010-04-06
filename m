Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46294 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab0DFWlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 18:41:16 -0400
Subject: [PATCH 2/2] compat: add stub headers linux/tracepoint.h and
 trace/define_trace.h
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 06 Apr 2010 18:41:15 -0400
Message-ID: <20100406224115.2937.89309.stgit@mj.roinet.com>
In-Reply-To: <20100406224109.2937.65315.stgit@mj.roinet.com>
References: <20100406224109.2937.65315.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should make 13-trace.patch in compat-wireless unnecessary.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 include/linux/tracepoint.h   |    8 ++++++++
 include/trace/define_trace.h |    8 ++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/tracepoint.h
 create mode 100644 include/trace/define_trace.h

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
new file mode 100644
index 0000000..7484716
--- /dev/null
+++ b/include/linux/tracepoint.h
@@ -0,0 +1,8 @@
+#ifndef _COMPAT_LINUX_TRACEPOINT_H
+#define _COMPAT_LINUX_TRACEPOINT_H 1
+
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+#include_next <linux/tracepoint.h>
+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)) */
+
+#endif	/* _COMPAT_LINUX_TRACEPOINT_H */
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
new file mode 100644
index 0000000..f5c01de
--- /dev/null
+++ b/include/trace/define_trace.h
@@ -0,0 +1,8 @@
+#ifndef _COMPAT_TRACE_DEFINE_TRACE_H
+#define _COMPAT_TRACE_DEFINE_TRACE_H 1
+
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
+#include_next <trace/define_trace.h>
+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30)) */
+
+#endif	/* _COMPAT_TRACE_DEFINE_TRACE_H */
