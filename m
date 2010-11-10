Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47672 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab0KJCVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:51 -0500
Received: by mail-qy0-f174.google.com with SMTP id 12so2500227qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:51 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 34/44] compat/2.6.24: move 'struct net' to its own compat header
Date: Tue,  9 Nov 2010 21:20:16 -0500
Message-Id: <1289355626-25373-35-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.24.h |   31 -------------------------------
 include/net/net_namespace.h   |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/include/linux/compat-2.6.24.h b/include/linux/compat-2.6.24.h
index 6d5dce5..4c1231f 100644
--- a/include/linux/compat-2.6.24.h
+++ b/include/linux/compat-2.6.24.h
@@ -21,37 +21,6 @@
 
 #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
-struct proc_dir_entry;
-struct net_device;
-struct net {
-	atomic_t		count;		/* To decided when the network
-						 *  namespace should be freed.
-						 */
-	atomic_t		use_count;	/* To track references we
-						 * destroy on demand
-						 */
-	struct list_head	list;		/* list of network namespaces */
-	struct work_struct	work;		/* work struct for freeing */
-
-	struct proc_dir_entry 	*proc_net;
-	struct proc_dir_entry 	*proc_net_stat;
-	struct proc_dir_entry 	*proc_net_root;
-
-	struct net_device       *loopback_dev;          /* The loopback */
-
-	struct list_head 	dev_base_head;
-	struct hlist_head 	*dev_name_head;
-	struct hlist_head	*dev_index_head;
-};
-
-#ifdef CONFIG_NET
-/* Init's network namespace */
-extern struct net init_net;
-#define INIT_NET_NS(net_ns) .net_ns = &init_net,
-#else
-#define INIT_NET_NS(net_ns)
-#endif
-
 /* Added on 2.6.24 in include/linux/types.h by Al viro on commit 142956af */
 typedef unsigned long               uintptr_t;
 
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 23a517a..250fea2 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -5,6 +5,42 @@
 #ifndef __NET_NET_NAMESPACE_H
 #define __NET_NET_NAMESPACE_H
 
+#include <linux/list.h>
+#include <linux/workqueue.h>
+
+#include <asm/atomic.h>
+
+struct proc_dir_entry;
+struct net_device;
+struct net {
+	atomic_t		count;		/* To decided when the network
+						 *  namespace should be freed.
+						 */
+	atomic_t		use_count;	/* To track references we
+						 * destroy on demand
+						 */
+	struct list_head	list;		/* list of network namespaces */
+	struct work_struct	work;		/* work struct for freeing */
+
+	struct proc_dir_entry 	*proc_net;
+	struct proc_dir_entry 	*proc_net_stat;
+	struct proc_dir_entry 	*proc_net_root;
+
+	struct net_device       *loopback_dev;          /* The loopback */
+
+	struct list_head 	dev_base_head;
+	struct hlist_head 	*dev_name_head;
+	struct hlist_head	*dev_index_head;
+};
+
+#ifdef CONFIG_NET
+/* Init's network namespace */
+extern struct net init_net;
+#define INIT_NET_NS(net_ns) .net_ns = &init_net,
+#else
+#define INIT_NET_NS(net_ns)
+#endif
+
 #endif /* __NET_NET_NAMESPACE_H */
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)) */
-- 
1.7.2.30.gc37d7.dirty

