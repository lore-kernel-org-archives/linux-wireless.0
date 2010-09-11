Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33858 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab0IKQUK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:20:10 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: backport skb_checksum_none_assert
Date: Sat, 11 Sep 2010 18:19:58 +0200
Message-Id: <1284221999-22521-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed by atlx, b44, atl1c and atl1e.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.37.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.37.h b/include/linux/compat-2.6.37.h
index 5bd6edb..8ea0bab 100644
--- a/include/linux/compat-2.6.37.h
+++ b/include/linux/compat-2.6.37.h
@@ -5,6 +5,8 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37))
 
+#include <linux/skbuff.h>
+
 /*
  * This is not part of The 2.6.37 kernel yet but we
  * we use it to optimize the backport code we
@@ -26,6 +28,21 @@
 
 extern struct kobj_ns_type_operations net_ns_type_operations;
 
+/**
+ * skb_checksum_none_assert - make sure skb ip_summed is CHECKSUM_NONE
+ * @skb: skb to check
+ *
+ * fresh skbs have their ip_summed set to CHECKSUM_NONE.
+ * Instead of forcing ip_summed to CHECKSUM_NONE, we can
+ * use this helper, to document places where we make this assertion.
+ */
+static inline void skb_checksum_none_assert(struct sk_buff *skb)
+{
+#ifdef DEBUG
+	BUG_ON(skb->ip_summed != CHECKSUM_NONE);
+#endif
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)) */
 
 #endif /* LINUX_26_37_COMPAT_H */
-- 
1.7.0.4

