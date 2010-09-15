Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55158 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472Ab0IOUmw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 16:42:52 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: backport loff_t noop_llseek
Date: Wed, 15 Sep 2010 22:42:32 +0200
Message-Id: <1284583353-11456-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed by some debug parts of mac80211.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.35.c        |   17 +++++++++++++++++
 include/linux/compat-2.6.35.h |    2 ++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.35.c b/compat/compat-2.6.35.c
index 0d702ed..abb08c7 100644
--- a/compat/compat-2.6.35.c
+++ b/compat/compat-2.6.35.c
@@ -31,4 +31,21 @@ int hex_to_bin(char ch)
 }
 EXPORT_SYMBOL(hex_to_bin);
 
+/**
+ * noop_llseek - No Operation Performed llseek implementation
+ * @file:	file structure to seek on
+ * @offset:	file offset to seek to
+ * @origin:	type of seek
+ *
+ * This is an implementation of ->llseek useable for the rare special case when
+ * userspace expects the seek to succeed but the (device) file is actually not
+ * able to perform the seek. In this case you use noop_llseek() instead of
+ * falling back to the default implementation of ->llseek.
+ */
+loff_t noop_llseek(struct file *file, loff_t offset, int origin)
+{
+	return file->f_pos;
+}
+EXPORT_SYMBOL(noop_llseek);
+
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35) */
diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index f0562cd..32fd039 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -27,6 +27,8 @@ static inline wait_queue_head_t *sk_sleep(struct sock *sk)
 
 int hex_to_bin(char ch);
 
+extern loff_t noop_llseek(struct file *file, loff_t offset, int origin);
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)) */
 
 #endif /* LINUX_26_35_COMPAT_H */
-- 
1.7.0.4

