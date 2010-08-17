Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50211 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935473Ab0HQSct (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 14:32:49 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat: backport net_ns_type_operations
Date: Tue, 17 Aug 2010 20:32:32 +0200
Message-Id: <1282069953-22360-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1282069953-22360-1-git-send-email-hauke@hauke-m.de>
References: <1282069953-22360-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net_ns_type_operations needs to be exported. This only works for kernel
>= 2.6.35 because struct kobj_ns_type_operations was introduced in
kernel 2.6.35.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile               |    1 +
 compat/compat-2.6.37.c        |   45 +++++++++++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.37.h |    2 +
 3 files changed, 48 insertions(+), 0 deletions(-)
 create mode 100644 compat/compat-2.6.37.c

diff --git a/compat/Makefile b/compat/Makefile
index bcd8fe7..b067be2 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -27,3 +27,4 @@ compat-$(CONFIG_COMPAT_KERNEL_31) += compat-2.6.31.o
 compat-$(CONFIG_COMPAT_KERNEL_32) += compat-2.6.32.o
 compat-$(CONFIG_COMPAT_KERNEL_33) += compat-2.6.33.o
 compat-$(CONFIG_COMPAT_KERNEL_35) += compat-2.6.35.o
+compat-$(CONFIG_COMPAT_KERNEL_37) += compat-2.6.37.o
diff --git a/compat/compat-2.6.37.c b/compat/compat-2.6.37.c
new file mode 100644
index 0000000..655b92f
--- /dev/null
+++ b/compat/compat-2.6.37.c
@@ -0,0 +1,45 @@
+/*
+ * Copyright 2010    Hauke Mehrtens <hauke@hauke-m.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compatibility file for Linux wireless for kernels 2.6.37.
+ */
+
+#include <linux/compat.h>
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)
+
+#include <linux/netdevice.h>
+#include <net/sock.h>
+#include <linux/nsproxy.h>
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35)
+static const void *net_current_ns(void)
+{
+	return current->nsproxy->net_ns;
+}
+
+static const void *net_initial_ns(void)
+{
+	return &init_net;
+}
+
+static const void *net_netlink_ns(struct sock *sk)
+{
+	return sock_net(sk);
+}
+
+struct kobj_ns_type_operations net_ns_type_operations = {
+	.type = KOBJ_NS_TYPE_NET,
+	.current_ns = net_current_ns,
+	.netlink_ns = net_netlink_ns,
+	.initial_ns = net_initial_ns,
+};
+EXPORT_SYMBOL_GPL(net_ns_type_operations);
+
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35)*/ 
+
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37) */
diff --git a/include/linux/compat-2.6.37.h b/include/linux/compat-2.6.37.h
index cf0279e..5bd6edb 100644
--- a/include/linux/compat-2.6.37.h
+++ b/include/linux/compat-2.6.37.h
@@ -24,6 +24,8 @@
 
 #define SDIO_CLASS_BT_AMP	0x09	/* Type-A Bluetooth AMP interface */
 
+extern struct kobj_ns_type_operations net_ns_type_operations;
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)) */
 
 #endif /* LINUX_26_37_COMPAT_H */
-- 
1.7.0.4

