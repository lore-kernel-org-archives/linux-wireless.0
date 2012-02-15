Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53767 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab2BOVqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 16:46:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] compat: add dummy lockdep_rtnl_is_held implementation
Date: Wed, 15 Feb 2012 16:36:25 -0500
Message-Id: <1329341785-12811-1-git-send-email-linville@tuxdriver.com> (sfid-20120215_224650_279259_E5874232)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Obviously, this is wrong.  But the base kernel will have rtnl_mutex
declared static, with no way to access it.  I think this is the best
we can do...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/linux/compat-2.6.34.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index a9c9dd1..da242ce 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -292,6 +292,18 @@ static inline int rcu_read_lock_held(void)
 	return 1;
 }
 
+#ifdef CONFIG_PROVE_LOCKING
+/*
+ * Obviously, this is wrong.  But the base kernel will have rtnl_mutex
+ * declared static, with no way to access it.  I think this is the best
+ * we can do...
+ */
+static inline int lockdep_rtnl_is_held(void)
+{
+        return 1;
+}
+#endif /* #ifdef CONFIG_PROVE_LOCKING */
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */
 
 #endif /* LINUX_26_34_COMPAT_H */
-- 
1.7.4.4

