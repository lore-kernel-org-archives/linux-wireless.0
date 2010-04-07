Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:10390 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab0DGF0x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 01:26:53 -0400
Subject: [PATCH] compat: add net/net_namespace.h stub for Linux 2.6.23 and
 older
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 07 Apr 2010 01:26:52 -0400
Message-ID: <20100407052652.23137.84949.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This obviates a good part of 06-header-changes.patch in compat-wireless.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 include/net/net_namespace.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)
 create mode 100644 include/net/net_namespace.h

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
new file mode 100644
index 0000000..206c0c1
--- /dev/null
+++ b/include/net/net_namespace.h
@@ -0,0 +1,8 @@
+#ifndef _COMPAT_NET_NET_NAMESPACE_H
+#define _COMPAT_NET_NET_NAMESPACE_H 1
+
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,23))
+#include_next <net/net_namespace.h>
+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,23)) */
+
+#endif	/* _COMPAT_NET_NET_NAMESPACE_H */
