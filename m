Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47120 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab2FNRx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 13:53:26 -0400
Received: by weyu7 with SMTP id u7so1443016wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 10:53:25 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 3/3] compat: Backport fault_in_multipages_{writeable,readable}
Date: Thu, 14 Jun 2012 20:52:46 +0300
Message-Id: <1339696366-26970-3-git-send-email-ozancag@gmail.com> (sfid-20120614_195328_701847_C68ED3C2)
In-Reply-To: <1339696366-26970-1-git-send-email-ozancag@gmail.com>
References: <1339696366-26970-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This backports:

commit f56f821feb7b36223f309e0ec05986bb137ce418
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sun Mar 25 19:47:41 2012 +0200

    mm: extend prefault helpers to fault in more than PAGE_SIZE

The new functions are used by drm/i915 driver.

Trying kernel                     3.4.0-030400-generic	[OK]
Trying kernel                     3.3.7-030307-generic	[OK]
Trying kernel                     3.2.2-030202-generic	[OK]
Trying kernel                    3.1.10-030110-generic	[OK]
Trying kernel                    3.0.18-030018-generic	[OK]
Trying kernel                  2.6.39-02063904-generic	[OK]
Trying kernel                  2.6.38-02063808-generic	[OK]
Trying kernel                  2.6.37-02063706-generic	[OK]
Trying kernel                  2.6.36-02063604-generic	[OK]
Trying kernel                  2.6.35-02063512-generic	[OK]
Trying kernel                  2.6.34-02063410-generic	[OK]
Trying kernel                  2.6.33-02063305-generic	[OK]
Trying kernel                  2.6.32-02063255-generic	[OK]
Trying kernel                  2.6.31-02063113-generic	[OK]
Trying kernel                  2.6.30-02063010-generic	[OK]
Trying kernel                  2.6.29-02062906-generic	[OK]
Trying kernel                  2.6.28-02062810-generic	[OK]
Trying kernel                    2.6.27-020627-generic	[OK]
Trying kernel                    2.6.26-020626-generic	[OK]
Trying kernel                    2.6.25-020625-generic	[OK]
Trying kernel                    2.6.24-020624-generic	[OK]

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 include/linux/compat-3.5.h |   67 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/include/linux/compat-3.5.h b/include/linux/compat-3.5.h
index 1d9128a..74c8176 100644
--- a/include/linux/compat-3.5.h
+++ b/include/linux/compat-3.5.h
@@ -8,6 +8,73 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,5,0))
 
+/*
+ * This backports:
+ *
+ * commit f56f821feb7b36223f309e0ec05986bb137ce418
+ * Author: Daniel Vetter <daniel.vetter@ffwll.ch>
+ * Date:   Sun Mar 25 19:47:41 2012 +0200
+ *
+ *     mm: extend prefault helpers to fault in more than PAGE_SIZE
+ *
+ * The new functions are used by drm/i915 driver.
+ *
+ */
+
+static inline int fault_in_multipages_writeable(char __user *uaddr, int size)
+{
+        int ret = 0;
+        char __user *end = uaddr + size - 1;
+
+        if (unlikely(size == 0))
+                return ret;
+
+        /*
+         * Writing zeroes into userspace here is OK, because we know that if
+         * the zero gets there, we'll be overwriting it.
+         */
+        while (uaddr <= end) {
+                ret = __put_user(0, uaddr);
+                if (ret != 0)
+                        return ret;
+                uaddr += PAGE_SIZE;
+        }
+
+        /* Check whether the range spilled into the next page. */
+        if (((unsigned long)uaddr & PAGE_MASK) ==
+                        ((unsigned long)end & PAGE_MASK))
+                ret = __put_user(0, end);
+
+        return ret;
+}
+
+static inline int fault_in_multipages_readable(const char __user *uaddr,
+                                               int size)
+{
+        volatile char c;
+        int ret = 0;
+        const char __user *end = uaddr + size - 1;
+
+        if (unlikely(size == 0))
+                return ret;
+
+        while (uaddr <= end) {
+                ret = __get_user(c, uaddr);
+                if (ret != 0)
+                        return ret;
+                uaddr += PAGE_SIZE;
+        }
+
+        /* Check whether the range spilled into the next page. */
+        if (((unsigned long)uaddr & PAGE_MASK) ==
+                        ((unsigned long)end & PAGE_MASK)) {
+                ret = __get_user(c, end);
+                (void)c;
+        }
+
+        return ret;
+}
+
 /* switcheroo is available on >= 2.6.34 */
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
 #include <linux/vga_switcheroo.h>
-- 
1.7.10.2

