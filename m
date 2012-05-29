Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44027 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370Ab2E2WmG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 18:42:06 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] compat: add ida_simple_{get,remove}
Date: Wed, 30 May 2012 00:41:48 +0200
Message-Id: <1338331308-29732-5-git-send-email-hauke@hauke-m.de> (sfid-20120530_004213_014407_004E081E)
In-Reply-To: <1338331308-29732-1-git-send-email-hauke@hauke-m.de>
References: <1338331308-29732-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed by net/bluetooth/hci_core.c

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile            |    1 +
 compat/compat-3.1.c        |   83 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/compat-3.1.h |    5 +++
 3 files changed, 89 insertions(+)
 create mode 100644 compat/compat-3.1.c

diff --git a/compat/Makefile b/compat/Makefile
index eb4eda1..c661f5d 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -37,6 +37,7 @@ compat-$(CONFIG_COMPAT_KERNEL_2_6_39) += \
 	compat-2.6.39.o \
 	kstrtox.o
 compat-$(CONFIG_COMPAT_KERNEL_3_0) += compat-3.0.o
+compat-$(CONFIG_COMPAT_KERNEL_3_1) += compat-3.1.o
 compat-$(CONFIG_COMPAT_KERNEL_3_2) += compat-3.2.o
 compat-$(CONFIG_COMPAT_KERNEL_3_3) += \
 	compat-3.3.o \
diff --git a/compat/compat-3.1.c b/compat/compat-3.1.c
new file mode 100644
index 0000000..d427dd3
--- /dev/null
+++ b/compat/compat-3.1.c
@@ -0,0 +1,83 @@
+/*
+ * Copyright 2012    Hauke Mehrtens <hauke@hauke-m.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compatibility file for Linux wireless for kernels 3.1.
+ */
+
+#include <linux/idr.h>
+
+static DEFINE_SPINLOCK(simple_ida_lock);
+
+/**
+ * ida_simple_get - get a new id.
+ * @ida: the (initialized) ida.
+ * @start: the minimum id (inclusive, < 0x8000000)
+ * @end: the maximum id (exclusive, < 0x8000000 or 0)
+ * @gfp_mask: memory allocation flags
+ *
+ * Allocates an id in the range start <= id < end, or returns -ENOSPC.
+ * On memory allocation failure, returns -ENOMEM.
+ *
+ * Use ida_simple_remove() to get rid of an id.
+ */
+int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
+		   gfp_t gfp_mask)
+{
+	int ret, id;
+	unsigned int max;
+	unsigned long flags;
+
+	BUG_ON((int)start < 0);
+	BUG_ON((int)end < 0);
+
+	if (end == 0)
+		max = 0x80000000;
+	else {
+		BUG_ON(end < start);
+		max = end - 1;
+	}
+
+again:
+	if (!ida_pre_get(ida, gfp_mask))
+		return -ENOMEM;
+
+	spin_lock_irqsave(&simple_ida_lock, flags);
+	ret = ida_get_new_above(ida, start, &id);
+	if (!ret) {
+		if (id > max) {
+			ida_remove(ida, id);
+			ret = -ENOSPC;
+		} else {
+			ret = id;
+		}
+	}
+	spin_unlock_irqrestore(&simple_ida_lock, flags);
+
+	if (unlikely(ret == -EAGAIN))
+		goto again;
+
+	return ret;
+}
+EXPORT_SYMBOL(ida_simple_get);
+
+/**
+ * ida_simple_remove - remove an allocated id.
+ * @ida: the (initialized) ida.
+ * @id: the id returned by ida_simple_get.
+ */
+void ida_simple_remove(struct ida *ida, unsigned int id)
+{
+	unsigned long flags;
+
+	BUG_ON((int)id < 0);
+	spin_lock_irqsave(&simple_ida_lock, flags);
+	ida_remove(ida, id);
+	spin_unlock_irqrestore(&simple_ida_lock, flags);
+}
+EXPORT_SYMBOL(ida_simple_remove);
+/* source lib/idr.c */
+
diff --git a/include/linux/compat-3.1.h b/include/linux/compat-3.1.h
index fdd27d4..da8e971 100644
--- a/include/linux/compat-3.1.h
+++ b/include/linux/compat-3.1.h
@@ -8,6 +8,7 @@
 #include <linux/security.h>
 #include <linux/skbuff.h>
 #include <net/ip.h>
+#include <linux/idr.h>
 
 /* Backports 56f8a75c */
 static inline bool ip_is_fragment(const struct iphdr *iph)
@@ -83,6 +84,10 @@ static inline void security_sk_clone(const struct sock *sk, struct sock *newsk)
 #include <asm-generic/atomic64.h>
 #endif
 
+int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
+		   gfp_t gfp_mask);
+void ida_simple_remove(struct ida *ida, unsigned int id);
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0)) */
 
 #endif /* LINUX_3_1_COMPAT_H */
-- 
1.7.9.5

