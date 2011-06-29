Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:42298 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757618Ab1F2UrR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 16:47:17 -0400
Subject: [PATCH] compat: use macro for netdev_name() to support Debian
 kernel 2.6.32-5
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 29 Jun 2011 16:47:15 -0400
Message-ID: <20110629204715.8477.90064.stgit@mj.roinet.com> (sfid-20110629_224720_632302_37E808D3)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>

Debian backports netdev_name as a function.  As we cannot test if a
function is present, use an equivalent macro.

Reported by Sivaraman V <krusna@gmail.com> and Alex <alex9434@gmail.com>
---
 include/linux/compat-2.6.34.h |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index 9743d6c..bada700 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -20,12 +20,11 @@
 
 /* netdev_printk helpers, similar to dev_printk */
 
-static inline const char *netdev_name(const struct net_device *dev)
-{
-	if (dev->reg_state != NETREG_REGISTERED)
-		return "(unregistered net_device)";
-	return dev->name;
-}
+#ifndef netdev_name
+#define netdev_name(__dev) \
+	((__dev->reg_state != NETREG_REGISTERED) ? \
+		"(unregistered net_device)" : __dev->name)
+#endif
 
 #define netdev_printk(level, netdev, format, args...)		\
 	dev_printk(level, (netdev)->dev.parent,			\
