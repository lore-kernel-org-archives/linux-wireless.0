Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43333 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab2HAXFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 19:05:53 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat: add sk_wmem_alloc_get and sk_has_allocations
Date: Thu,  2 Aug 2012 01:05:24 +0200
Message-Id: <1343862324-26057-3-git-send-email-hauke@hauke-m.de> (sfid-20120802_010555_786245_85DF40F0)
In-Reply-To: <1343862324-26057-1-git-send-email-hauke@hauke-m.de>
References: <1343862324-26057-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These functions are copied from the kernel.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.31.h |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/include/linux/compat-2.6.31.h b/include/linux/compat-2.6.31.h
index 25db973..347ae26 100644
--- a/include/linux/compat-2.6.31.h
+++ b/include/linux/compat-2.6.31.h
@@ -11,6 +11,7 @@
 #include <net/dst.h>
 #include <net/genetlink.h>
 #include <linux/ethtool.h>
+#include <net/sock.h>
 
 /*
  * These macros allow us to backport rfkill without any
@@ -215,6 +216,39 @@ extern long long atomic64_add_return(long long a, atomic64_t *v);
 
 #endif
 
+/**
+ * sk_rmem_alloc_get - returns read allocations
+ * @sk: socket
+ *
+ * Returns sk_rmem_alloc
+ */
+static inline int sk_rmem_alloc_get(const struct sock *sk)
+{
+	return atomic_read(&sk->sk_rmem_alloc);
+}
+
+/**
+ * sk_wmem_alloc_get - returns write allocations
+ * @sk: socket
+ *
+ * Returns sk_wmem_alloc minus initial offset of one
+ */
+static inline int sk_wmem_alloc_get(const struct sock *sk)
+{
+	return atomic_read(&sk->sk_wmem_alloc) - 1;
+}
+
+/**
+ * sk_has_allocations - check if allocations are outstanding
+ * @sk: socket
+ *
+ * Returns true if socket has write or read allocations
+ */
+static inline bool sk_has_allocations(const struct sock *sk)
+{
+	return sk_wmem_alloc_get(sk) || sk_rmem_alloc_get(sk);
+}
+
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) */
 
-- 
1.7.9.5

