Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58867 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab1EVKsK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 06:48:10 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat: backport RCU_INIT_POINTER
Date: Sun, 22 May 2011 12:47:33 +0200
Message-Id: <1306061254-4197-2-git-send-email-hauke@hauke-m.de> (sfid-20110522_124814_747851_AFCF7B2D)
In-Reply-To: <1306061254-4197-1-git-send-email-hauke@hauke-m.de>
References: <1306061254-4197-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.37.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.37.h b/include/linux/compat-2.6.37.h
index a83c9c7..e0dd6b4 100644
--- a/include/linux/compat-2.6.37.h
+++ b/include/linux/compat-2.6.37.h
@@ -115,6 +115,15 @@ extern void *vzalloc(unsigned long size);
 #define rtnl_dereference(p)                                     \
         rcu_dereference_protected(p, lockdep_rtnl_is_held())
 
+/**
+ * RCU_INIT_POINTER() - initialize an RCU protected pointer
+ *
+ * Initialize an RCU-protected pointer in such a way to avoid RCU-lockdep
+ * splats.
+ */
+#define RCU_INIT_POINTER(p, v) \
+		p = (typeof(*v) __force __rcu *)(v)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)) */
 
 #endif /* LINUX_26_37_COMPAT_H */
-- 
1.7.4.1

