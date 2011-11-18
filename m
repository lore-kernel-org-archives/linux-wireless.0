Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41892 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab1KRU6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 15:58:31 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] compat: implement dummy security_sk_clone
Date: Fri, 18 Nov 2011 15:52:44 -0500
Message-Id: <1321649564-12954-1-git-send-email-linville@tuxdriver.com> (sfid-20111118_215833_507184_320A87F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has been defined in include/linux/security.h for some time, but was
only given an EXPORT_SYMBOL for 3.1.  Add a compat_* definition to avoid
breaking the module load with an undefined symbol.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/linux/compat-3.1.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-3.1.h b/include/linux/compat-3.1.h
index 93bb1f6..e247791 100644
--- a/include/linux/compat-3.1.h
+++ b/include/linux/compat-3.1.h
@@ -19,6 +19,17 @@
 	.prod_id = { NULL, NULL, (v3), NULL }, \
 	.prod_id_hash = { 0, 0, (vh3), 0 }, }
 
+/*
+ * This has been defined in include/linux/security.h for some time, but was
+ * only given an EXPORT_SYMBOL for 3.1.  Add a compat_* definition to avoid
+ * breaking the compile.
+ */
+#define security_sk_clone(a, b) compat_security_sk_clone(a, b)
+
+static inline void security_sk_clone(const struct sock *sk, struct sock *newsk)
+{
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0)) */
 
 #endif /* LINUX_3_1_COMPAT_H */
-- 
1.7.4.4

