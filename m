Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58877 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255Ab1EVKsN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 06:48:13 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat: remove wrong backport of kfree_rcu
Date: Sun, 22 May 2011 12:47:34 +0200
Message-Id: <1306061254-4197-3-git-send-email-hauke@hauke-m.de> (sfid-20110522_124817_610643_F4E7DC6A)
In-Reply-To: <1306061254-4197-1-git-send-email-hauke@hauke-m.de>
References: <1306061254-4197-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Backporting kfree_rcu() in compat does not work as
struct rcu_head->func is always interpreted as a pointer in older
kernel versions, but when using kfree_rcu() it is set to an offset.
rcu_head->func is used in some functions in the kernel not backported
by compat-wireless.

In older kernel versions in __rcu_reclaim just the else path is available.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.40.h |   58 -----------------------------------------
 1 files changed, 0 insertions(+), 58 deletions(-)

diff --git a/include/linux/compat-2.6.40.h b/include/linux/compat-2.6.40.h
index 9ec8c1b..b3fc8f7 100644
--- a/include/linux/compat-2.6.40.h
+++ b/include/linux/compat-2.6.40.h
@@ -24,64 +24,6 @@
 #define br_port_exists(dev)	(dev->br_port)
 #endif
 
-static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
-{
-	return offset < 4096;
-}
-
-static __always_inline
-void __kfree_rcu(struct rcu_head *head, unsigned long offset)
-{
-	typedef void (*rcu_callback)(struct rcu_head *);
-
-	/* This causes build failures with some kernel versions at positions
-	 * where this methods is not used at all.
-	 */
-	/* BUILD_BUG_ON(!__builtin_constant_p(offset)); */
-
-	/* See the kfree_rcu() header comment. */
-	/* BUILD_BUG_ON(!__is_kfree_rcu_offset(offset)); */
-
-	call_rcu(head, (rcu_callback)offset);
-}
-
-static inline void __rcu_reclaim(struct rcu_head *head)
-{
-	unsigned long offset = (unsigned long)head->func;
-
-	if (__is_kfree_rcu_offset(offset))
-		kfree((void *)head - offset);
-	else
-		head->func(head);
-}
-
-/**
- * kfree_rcu() - kfree an object after a grace period.
- * @ptr:	pointer to kfree
- * @rcu_head:	the name of the struct rcu_head within the type of @ptr.
- *
- * Many rcu callbacks functions just call kfree() on the base structure.
- * These functions are trivial, but their size adds up, and furthermore
- * when they are used in a kernel module, that module must invoke the
- * high-latency rcu_barrier() function at module-unload time.
- *
- * The kfree_rcu() function handles this issue.  Rather than encoding a
- * function address in the embedded rcu_head structure, kfree_rcu() instead
- * encodes the offset of the rcu_head structure within the base structure.
- * Because the functions are not allowed in the low-order 4096 bytes of
- * kernel virtual memory, offsets up to 4095 bytes can be accommodated.
- * If the offset is larger than 4095 bytes, a compile-time error will
- * be generated in __kfree_rcu().  If this error is triggered, you can
- * either fall back to use of call_rcu() or rearrange the structure to
- * position the rcu_head structure into the first 4096 bytes.
- *
- * Note that the allowable offset might decrease in the future, for example,
- * to allow something like kmem_cache_free_rcu().
- */
-#define kfree_rcu(ptr, rcu_head)					\
-	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
-
-
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40)) */
 
 #endif /* LINUX_26_40_COMPAT_H */
-- 
1.7.4.1

