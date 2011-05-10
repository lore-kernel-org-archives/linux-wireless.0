Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53240 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab1EJLKn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 07:10:43 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat: backport kfree_rcu
Date: Tue, 10 May 2011 13:10:15 +0200
Message-Id: <1305025816-12538-2-git-send-email-hauke@hauke-m.de> (sfid-20110510_131045_968450_68E1C810)
In-Reply-To: <1305025816-12538-1-git-send-email-hauke@hauke-m.de>
References: <1305025816-12538-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.40.h |   60 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.40.h b/include/linux/compat-2.6.40.h
index 42f9fee..9ec8c1b 100644
--- a/include/linux/compat-2.6.40.h
+++ b/include/linux/compat-2.6.40.h
@@ -5,6 +5,8 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40))
 
+#include <linux/rcupdate.h>
+
 /*
  * This is not part of The 2.6.37 kernel yet but we
  * we use it to optimize the backport code we
@@ -22,6 +24,64 @@
 #define br_port_exists(dev)	(dev->br_port)
 #endif
 
+static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
+{
+	return offset < 4096;
+}
+
+static __always_inline
+void __kfree_rcu(struct rcu_head *head, unsigned long offset)
+{
+	typedef void (*rcu_callback)(struct rcu_head *);
+
+	/* This causes build failures with some kernel versions at positions
+	 * where this methods is not used at all.
+	 */
+	/* BUILD_BUG_ON(!__builtin_constant_p(offset)); */
+
+	/* See the kfree_rcu() header comment. */
+	/* BUILD_BUG_ON(!__is_kfree_rcu_offset(offset)); */
+
+	call_rcu(head, (rcu_callback)offset);
+}
+
+static inline void __rcu_reclaim(struct rcu_head *head)
+{
+	unsigned long offset = (unsigned long)head->func;
+
+	if (__is_kfree_rcu_offset(offset))
+		kfree((void *)head - offset);
+	else
+		head->func(head);
+}
+
+/**
+ * kfree_rcu() - kfree an object after a grace period.
+ * @ptr:	pointer to kfree
+ * @rcu_head:	the name of the struct rcu_head within the type of @ptr.
+ *
+ * Many rcu callbacks functions just call kfree() on the base structure.
+ * These functions are trivial, but their size adds up, and furthermore
+ * when they are used in a kernel module, that module must invoke the
+ * high-latency rcu_barrier() function at module-unload time.
+ *
+ * The kfree_rcu() function handles this issue.  Rather than encoding a
+ * function address in the embedded rcu_head structure, kfree_rcu() instead
+ * encodes the offset of the rcu_head structure within the base structure.
+ * Because the functions are not allowed in the low-order 4096 bytes of
+ * kernel virtual memory, offsets up to 4095 bytes can be accommodated.
+ * If the offset is larger than 4095 bytes, a compile-time error will
+ * be generated in __kfree_rcu().  If this error is triggered, you can
+ * either fall back to use of call_rcu() or rearrange the structure to
+ * position the rcu_head structure into the first 4096 bytes.
+ *
+ * Note that the allowable offset might decrease in the future, for example,
+ * to allow something like kmem_cache_free_rcu().
+ */
+#define kfree_rcu(ptr, rcu_head)					\
+	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
+
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40)) */
 
 #endif /* LINUX_26_40_COMPAT_H */
-- 
1.7.4.1

