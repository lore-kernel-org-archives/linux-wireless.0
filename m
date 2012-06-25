Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53255 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab2FYKIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 06:08:41 -0400
Received: by bkcji2 with SMTP id ji2so2945687bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 03:08:40 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH v3] compat: Define include guard for vga_switcheroo.h
Date: Mon, 25 Jun 2012 13:08:32 +0300
Message-Id: <1340618912-6845-1-git-send-email-ozancag@gmail.com> (sfid-20120625_120845_477937_4E969469)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check is missing in upstream. Patch sent but until this gets
merged, define it in compat tree for fixing compat-drm builds.

Trying kernel  3.4.0-030400-generic [OK]
Trying kernel  3.3.7-030307-generic [OK]
Trying kernel  3.2.2-030202-generic [OK]
Trying kernel  3.1.10-030110-generic [OK]
Trying kernel  3.0.18-030018-generic [OK]
Trying kernel  2.6.39-02063904-generic [OK]
Trying kernel  2.6.38-02063808-generic [OK]
Trying kernel  2.6.37-02063706-generic [OK]
Trying kernel  2.6.36-02063604-generic [OK]
Trying kernel  2.6.35-02063512-generic [OK]
Trying kernel  2.6.34-02063410-generic [OK]
Trying kernel  2.6.33-02063305-generic [OK]
Trying kernel  2.6.32-02063255-generic [OK]
Trying kernel  2.6.31-02063113-generic [OK]
Trying kernel  2.6.30-02063010-generic [OK]
Trying kernel  2.6.29-02062906-generic [OK]
Trying kernel  2.6.28-02062810-generic [OK]
Trying kernel  2.6.27-020627-generic [OK]
Trying kernel  2.6.26-020626-generic [OK]
Trying kernel  2.6.25-020625-generic [OK]
Trying kernel  2.6.24-020624-generic [OK]

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 include/linux/vga_switcheroo.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 include/linux/vga_switcheroo.h

diff --git a/include/linux/vga_switcheroo.h b/include/linux/vga_switcheroo.h
new file mode 100644
index 0000000..4bda17b
--- /dev/null
+++ b/include/linux/vga_switcheroo.h
@@ -0,0 +1,12 @@
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+/*
+ * XXX: The include guard was sent upstream, drop this
+ * once the guard is merged.
+ */
+#ifndef LINUX_VGA_SWITCHEROO_H /* in case this gets upstream */
+#include_next <linux/vga_switcheroo.h>
+#ifndef LINUX_VGA_SWITCHEROO_H /* do not redefine once this gets upstream */
+#define LINUX_VGA_SWITCHEROO_H
+#endif /* case 1 LINUX_VGA_SWITCHEROO_H */
+#endif /* case 2 LINUX_VGA_SWITCHEROO_H */
+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
-- 
1.7.10.2

