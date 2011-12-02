Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36670 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab1LBK2a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 05:28:30 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH] compat: backport atomic64 support
Date: Fri,  2 Dec 2011 11:28:26 +0100
Message-Id: <1322821706-64627-1-git-send-email-nbd@openwrt.org> (sfid-20111202_112841_562525_1F35DD9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 compat/Makefile               |    5 +++++
 compat/compat_atomic.c        |   33 +++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.31.h |   14 ++++++++++++++
 include/linux/compat-3.1.h    |   12 ++++++++++++
 4 files changed, 64 insertions(+), 0 deletions(-)
 create mode 100644 compat/compat_atomic.c

diff --git a/compat/Makefile b/compat/Makefile
index fc43ba1..9e4db44 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -38,3 +38,8 @@ compat-$(CONFIG_COMPAT_KERNEL_3_1) += \
 	cordic.o \
 	crc8.o
 
+ifndef CONFIG_64BIT
+ifndef CONFIG_GENERIC_ATOMIC64
+  compat-y += compat_atomic.o
+endif
+endif
diff --git a/compat/compat_atomic.c b/compat/compat_atomic.c
new file mode 100644
index 0000000..747e275
--- /dev/null
+++ b/compat/compat_atomic.c
@@ -0,0 +1,33 @@
+#include <linux/spinlock.h>
+#include <linux/module.h>
+
+#if !((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)) && (defined(CONFIG_UML) || defined(CONFIG_X86))) && !((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33)) && defined(CONFIG_ARM) && !defined(CONFIG_GENERIC_ATOMIC64))
+
+static DEFINE_SPINLOCK(lock);
+
+long long atomic64_read(const atomic64_t *v)
+{
+    unsigned long flags;
+    long long val;
+
+    spin_lock_irqsave(&lock, flags);
+    val = v->counter;
+    spin_unlock_irqrestore(&lock, flags);
+    return val;
+}
+EXPORT_SYMBOL(atomic64_read);
+
+long long atomic64_add_return(long long a, atomic64_t *v)
+{
+    unsigned long flags;
+    long long val;
+
+    spin_lock_irqsave(&lock, flags);
+    val = v->counter += a;
+    spin_unlock_irqrestore(&lock, flags);
+    return val;
+}
+EXPORT_SYMBOL(atomic64_add_return);
+
+#endif
+
diff --git a/include/linux/compat-2.6.31.h b/include/linux/compat-2.6.31.h
index ce944bb..25db973 100644
--- a/include/linux/compat-2.6.31.h
+++ b/include/linux/compat-2.6.31.h
@@ -202,6 +202,20 @@ void compat_synchronize_threaded_irq(struct compat_threaded_irq *comp)
 #define skb_walk_frags(skb, iter)	\
 	for (iter = skb_shinfo(skb)->frag_list; iter; iter = iter->next)
 
+#ifndef CONFIG_64BIT
+
+typedef struct {
+	long long counter;
+} atomic64_t;
+
+extern long long atomic64_read(const atomic64_t *v);
+extern long long atomic64_add_return(long long a, atomic64_t *v);
+
+#define atomic64_inc_return(v)          atomic64_add_return(1LL, (v))
+
+#endif
+
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) */
 
 #endif /* LINUX_26_31_COMPAT_H */
diff --git a/include/linux/compat-3.1.h b/include/linux/compat-3.1.h
index e247791..0832183 100644
--- a/include/linux/compat-3.1.h
+++ b/include/linux/compat-3.1.h
@@ -30,6 +30,18 @@ static inline void security_sk_clone(const struct sock *sk, struct sock *newsk)
 {
 }
 
+/*
+ * In many versions, several architectures do not seem to include an
+ * atomic64_t implementation, and do not include the software emulation from
+ * asm-generic/atomic64_t.
+ * Detect and handle this here.
+ */
+#include <asm/atomic.h>
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)) && !defined(ATOMIC64_INIT) && !defined(CONFIG_X86) && !((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33)) && defined(CONFIG_ARM) && !defined(CONFIG_GENERIC_ATOMIC64))
+#include <asm-generic/atomic64.h>
+#endif
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0)) */
 
 #endif /* LINUX_3_1_COMPAT_H */
-- 
1.7.3.2

