Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:31050 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab0CXVXk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 17:23:40 -0400
Subject: compat: add compat-2.6.35.h and IW_HANDLER
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Wed, 24 Mar 2010 17:23:37 -0400
Message-Id: <1269465817.26368.5.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

compat: add compat-2.6.35.h and IW_HANDLER

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

I assume the patch that introduced IW_HANDLER won't be applied to
2.6.34, so the definition belongs to a new file, compat-2.6.35.h

 include/linux/compat-2.6.35.h |   13 +++++++++++++
 include/linux/compat-2.6.h    |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/compat-2.6.35.h

diff --git a/include/linux/compat-2.6.35.h
b/include/linux/compat-2.6.35.h
new file mode 100644
index 0000000..7387c46
--- /dev/null
+++ b/include/linux/compat-2.6.35.h
@@ -0,0 +1,13 @@
+#ifndef LINUX_26_35_COMPAT_H
+#define LINUX_26_35_COMPAT_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
+
+#define IW_HANDLER(id, func)			\
+	[IW_IOCTL_IDX(id)] = func
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)) */
+
+#endif /* LINUX_26_35_COMPAT_H */
diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index ceca997..6171cd9 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -27,5 +27,6 @@
 #include <linux/compat-2.6.32.h>
 #include <linux/compat-2.6.33.h>
 #include <linux/compat-2.6.34.h>
+#include <linux/compat-2.6.35.h>
 
 #endif /* LINUX_26_COMPAT_H */
