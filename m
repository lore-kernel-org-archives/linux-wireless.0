Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64842 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2HNQUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 12:20:34 -0400
Received: by weyx8 with SMTP id x8so397748wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2012 09:20:32 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat: Backport __wake_up_all_locked()
Date: Tue, 14 Aug 2012 19:20:25 +0300
Message-Id: <1344961225-28231-1-git-send-email-ozancag@gmail.com> (sfid-20120814_182038_691284_24CCF244)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This backports:

commit 63b2001169e75cd71e917ec953fdab572e3f944a
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu Dec 1 00:04:00 2011 +0100

	sched/wait: Add __wake_up_all_locked() API

$ git describe --contains 63b2001169e75cd71e917ec953fdab572e3f944a
v3.4-rc1~3^2~24

This is used by the 3.6-rcX radeon DRM driver (radeon_sa.c) and will
probably be used by other drivers in the near future.

__wake_up_all_locked() is a preprocessor macro around __wake_up_locked()
which gained a 3rd parameter in 3.4.

That's why I backported the new __wake_up_locked() as
compat_wake_up_locked() to avoid name conflicts.

This new function uses the internal __wake_up_common() function
which needed a backport too. I backported it as
compat_wake_up_common() as __wake_up_common() was made available
in kernels between 2.6.28 <= x <= 2.6.30 through wait.h and
dropped after 2.6.30. Renaming fixes build problems of compat
for those kernels.

Trying kernel 3.5.0-030500-generic [OK]
Trying kernel 3.4.4-030404-generic [OK]
Trying kernel 3.3.7-030307-generic [OK]
Trying kernel 3.2.2-030202-generic [OK]
Trying kernel 3.1.10-030110-generic [OK]
Trying kernel 3.0.18-030018-generic [OK]
Trying kernel 2.6.39-02063904-generic [OK]
Trying kernel 2.6.38-02063808-generic [OK]
Trying kernel 2.6.37-02063706-generic [OK]
Trying kernel 2.6.36-02063604-generic [OK]
Trying kernel 2.6.35-02063512-generic [OK]
Trying kernel 2.6.34-02063410-generic [OK]
Trying kernel 2.6.33-02063305-generic [OK]
Trying kernel 2.6.32-02063255-generic [OK]
Trying kernel 2.6.31-02063113-generic [OK]
Trying kernel 2.6.30-02063010-generic [OK]
Trying kernel 2.6.29-02062906-generic [OK]
Trying kernel 2.6.28-02062810-generic [OK]
Trying kernel 2.6.27-020627-generic [OK]
Trying kernel 2.6.26-020626-generic [OK]
Trying kernel 2.6.25-020625-generic [OK]
Trying kernel 2.6.24-020624-generic [OK]

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 compat/compat-3.4.c        | 29 +++++++++++++++++++++++++++++
 include/linux/compat-3.4.h | 13 +++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/compat/compat-3.4.c b/compat/compat-3.4.c
index 4ff439b..a771260 100644
--- a/compat/compat-3.4.c
+++ b/compat/compat-3.4.c
@@ -10,6 +10,35 @@
 
 #include <linux/fs.h>
 #include <linux/module.h>
+#include <linux/wait.h>
+
+/* __wake_up_common was declared as part of the wait.h until
+ * 2.6.31 in which they made it private to the scheduler. Prefix it with
+ * compat to avoid double declaration issues.
+ */
+static void compat_wake_up_common(wait_queue_head_t *q, unsigned int mode,
+			int nr_exclusive, int wake_flags, void *key)
+{
+	wait_queue_t *curr, *next;
+
+	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
+		unsigned flags = curr->flags;
+
+		if (curr->func(curr, mode, wake_flags, key) &&
+				(flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
+			break;
+	}
+}
+
+/* The last 'nr' parameter was added to the __wake_up_locked() function
+ * in 3.4 kernel. Define a new one prefixed with compat_ for the new API.
+ */
+void compat_wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr)
+{
+	compat_wake_up_common(q, mode, nr, 0, NULL);
+}
+EXPORT_SYMBOL_GPL(compat_wake_up_locked);
+
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
 #include <linux/i2c.h>
diff --git a/include/linux/compat-3.4.h b/include/linux/compat-3.4.h
index 06a3a07..07bfa53 100644
--- a/include/linux/compat-3.4.h
+++ b/include/linux/compat-3.4.h
@@ -5,6 +5,19 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0))
 
+
+/* This backports:
+ *
+ * commit 63b2001169e75cd71e917ec953fdab572e3f944a
+ * Author: Thomas Gleixner <tglx@linutronix.de>
+ * Date:   Thu Dec 1 00:04:00 2011 +0100
+
+ * 	sched/wait: Add __wake_up_all_locked() API
+ */
+#include <linux/wait.h>
+extern void compat_wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
+#define wake_up_all_locked(x)	compat_wake_up_locked((x), TASK_NORMAL, 0)
+
 /* This backports:
  *
  * commit a8203725dfded5c1f79dca3368a4a273e24b59bb
-- 
1.7.11.2

