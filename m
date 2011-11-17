Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43431 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab1KQVXg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 16:23:36 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/3] compat: backport kfree_rcu()
Date: Thu, 17 Nov 2011 22:23:10 +0100
Message-Id: <1321564991-7249-2-git-send-email-hauke@hauke-m.de> (sfid-20111117_222342_483194_BC3755AF)
In-Reply-To: <1321564991-7249-1-git-send-email-hauke@hauke-m.de>
References: <1321564991-7249-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a nested function everywhere kfree_rcu() was called. This
function frees the memory and is given as a function to call_rcu().
The kfree_rcu define was mad by Johannes Berg.
The rcu callback could happen every time also after the module was
unloaded and this will cause problems.
A rcu_barrier() was added into every module_exit so that this will not
be called after the module was unloaded.

The define overwriting module_exit is based on the original module_exit
which looks like this:
/* This is only required if you want to be unloadable. */
/#define module_exit(exitfn)                                    \
        static inline exitcall_t __exittest(void)               \
        { return exitfn; }                                      \
        void cleanup_module(void) __attribute__((alias(#exitfn)));

We replaced the call to the actual function exitfn() with a call to our
function which calls the original exitfn() and then rcu_barrier()

As a module will not be unloaded that ofter it should not have a big
performance impact when rcu_barrier() is called on every module exit,
also when no kfree_rcu() backport is used in that module.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
CC: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/compat-3.0.h |   48 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-3.0.h b/include/linux/compat-3.0.h
index 8c8720e..56639fd 100644
--- a/include/linux/compat-3.0.h
+++ b/include/linux/compat-3.0.h
@@ -5,6 +5,8 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0))
 
+#include <linux/rcupdate.h>
+
 /*
  * since commit 1c5cae815d19ffe02bdfda1260949ef2b1806171
  * "net: call dev_alloc_name from register_netdevice" dev_alloc_name is
@@ -79,6 +81,52 @@ static inline int __must_check kstrtos32_from_user(const char __user *s, size_t
 	return kstrtoint_from_user(s, count, base, res);
 }
 
+/* 
+ * This adds a nested function everywhere kfree_rcu() was called. This
+ * function frees the memory and is given as a function to call_rcu().
+ * The rcu callback could happen every time also after the module was
+ *  unloaded and this will cause problems.
+ */
+#define kfree_rcu(data, rcuhead)		do {			\
+		void __kfree_rcu_fn(struct rcu_head *rcu_head)		\
+		{							\
+			void *___ptr;					\
+			___ptr = container_of(rcu_head, typeof(*(data)), rcuhead);\
+			kfree(___ptr);					\
+		}							\
+		call_rcu(&(data)->rcuhead, __kfree_rcu_fn);		\
+	} while (0)
+
+#ifdef MODULE
+
+/*
+ * The define overwriting module_exit is based on the original module_exit
+ * which looks like this:
+ * #define module_exit(exitfn)                                    \
+ *         static inline exitcall_t __exittest(void)               \
+ *         { return exitfn; }                                      \
+ *         void cleanup_module(void) __attribute__((alias(#exitfn)));
+ *
+ * We replaced the call to the actual function exitfn() with a call to our
+ * function which calls the original exitfn() and then rcu_barrier()
+ *
+ * As a module will not be unloaded that ofter it should not have a big
+ * performance impact when rcu_barrier() is called on every module exit,
+ * also when no kfree_rcu() backport is used in that module.
+ */
+#undef module_exit
+#define module_exit(exitfn)						\
+	static inline exitcall_t __exittest(void)			\
+	{ return exitfn; }						\
+	void __exit __exit_compat(void)					\
+	{								\
+		exitfn();						\
+		rcu_barrier();						\
+	}								\
+	void cleanup_module(void) __attribute__((alias("__exit_compat")));
+
+#endif
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)) */
 
 #endif /* LINUX_3_0_COMPAT_H */
-- 
1.7.4.1

