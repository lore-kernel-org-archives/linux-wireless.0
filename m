Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44007 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab2E2WmA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 18:42:00 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/4] compat: do not include qdisc_cb_private_validate with every kernel
Date: Wed, 30 May 2012 00:41:45 +0200
Message-Id: <1338331308-29732-2-git-send-email-hauke@hauke-m.de> (sfid-20120530_004205_124382_D1B87BBF)
In-Reply-To: <1338331308-29732-1-git-send-email-hauke@hauke-m.de>
References: <1338331308-29732-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This method got backported into kernel 3.2.9 and 3.0.23. Compat should
not provide it for these kernel versions as it will cause some compile
errors.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-3.3.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/compat-3.3.h b/include/linux/compat-3.3.h
index 1eb873d..620e661 100644
--- a/include/linux/compat-3.3.h
+++ b/include/linux/compat-3.3.h
@@ -10,6 +10,7 @@
 #include <linux/skbuff.h>
 #include <net/sch_generic.h>
 
+#if !((LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,9) && LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)) || (LINUX_VERSION_CODE >= KERNEL_VERSION(3,0,23) && LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0)))
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,37))
 static inline void qdisc_cb_private_validate(const struct sk_buff *skb, int sz)
 {
@@ -21,6 +22,7 @@ static inline void qdisc_cb_private_validate(const struct sk_buff *skb, int sz)
 	/* XXX ? */
 }
 #endif
+#endif
 
 extern struct sk_buff *__pskb_copy(struct sk_buff *skb,
 				   int headroom, gfp_t gfp_mask);
-- 
1.7.9.5

