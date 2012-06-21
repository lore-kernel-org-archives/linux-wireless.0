Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:56507 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab2FUMAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 08:00:08 -0400
Received: by qadb17 with SMTP id b17so3918994qad.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 05:00:07 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat: Define include guard for vga_switcheroo.h
Date: Thu, 21 Jun 2012 14:59:59 +0300
Message-Id: <1340279999-389-1-git-send-email-ozancag@gmail.com> (sfid-20120621_140012_756537_8E4E0DF6)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check is missing in upstream. Patch sent but until this gets
merged, define it in compat tree for fixing compat-drm builds.

Also add a temporary header with the same name which will be used
to check whether the header should be included or not.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---

You can actually ignore this if you think that this should not be fixed
this way.

 include/linux/compat-3.5.h     |    6 ++++++
 include/linux/vga_switcheroo.h |    7 +++++++
 2 files changed, 13 insertions(+)
 create mode 100644 include/linux/vga_switcheroo.h

diff --git a/include/linux/compat-3.5.h b/include/linux/compat-3.5.h
index 74c8176..e999aee 100644
--- a/include/linux/compat-3.5.h
+++ b/include/linux/compat-3.5.h
@@ -78,6 +78,12 @@ static inline int fault_in_multipages_readable(const char __user *uaddr,
 /* switcheroo is available on >= 2.6.34 */
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
 #include <linux/vga_switcheroo.h>
+
+/* FIXME: The include guard is sent upstream, drop this
+ * once the guard is merged. */
+#ifndef LINUX_VGA_SWITCHEROO_H
+#define LINUX_VGA_SWITCHEROO_H
+#endif
 /*
  * This backports:
  *
diff --git a/include/linux/vga_switcheroo.h b/include/linux/vga_switcheroo.h
new file mode 100644
index 0000000..81ac31e
--- /dev/null
+++ b/include/linux/vga_switcheroo.h
@@ -0,0 +1,7 @@
+/* Hack for fixing the missing include guard in upstream
+ * header. We will drop this when the patch is merged upstream. */
+
+#ifndef LINUX_VGA_SWITCHEROO_H
+#define LINUX_VGA_SWITCHEROO_H
+#include_next <linux/vga_switcheroo.h>
+#endif
-- 
1.7.10.2

