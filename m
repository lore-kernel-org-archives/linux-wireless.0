Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63532 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab2FNRxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 13:53:07 -0400
Received: by wgbdr13 with SMTP id dr13so2190594wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 10:53:06 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 1/3] compat: Backport vga_switcheroo_client_ops
Date: Thu, 14 Jun 2012 20:52:44 +0300
Message-Id: <1339696366-26970-1-git-send-email-ozancag@gmail.com> (sfid-20120614_195311_791899_133420E9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This backports:

  From 26ec685ff9d9c16525d8ec4c97e52fcdb187b302 Mon Sep 17 00:00:00

  From: Takashi Iwai <tiwai@suse.de>
  Date: Fri, 11 May 2012 07:51:17 +0200
  Subject: [PATCH] vga_switcheroo: Introduce struct vga_switcheroo_client_ops

  only for kernels >= 2.6.34 in which vga_switcheroo is available.

  Trying kernel                     3.4.0-030400-generic    [OK]
  Trying kernel                     3.3.7-030307-generic    [OK]
  Trying kernel                     3.2.2-030202-generic    [OK]
  Trying kernel                    3.1.10-030110-generic    [OK]
  Trying kernel                    3.0.18-030018-generic    [OK]
  Trying kernel                  2.6.39-02063904-generic    [OK]
  Trying kernel                  2.6.38-02063808-generic    [OK]
  Trying kernel                  2.6.37-02063706-generic    [OK]
  Trying kernel                  2.6.36-02063604-generic    [OK]
  Trying kernel                  2.6.35-02063512-generic    [OK]
  Trying kernel                  2.6.34-02063410-generic    [OK]
  Trying kernel                  2.6.33-02063305-generic    [OK]
  Trying kernel                  2.6.32-02063255-generic    [OK]
  Trying kernel                  2.6.31-02063113-generic    [OK]
  Trying kernel                  2.6.30-02063010-generic    [OK]
  Trying kernel                  2.6.29-02062906-generic    [OK]
  Trying kernel                  2.6.28-02062810-generic    [OK]
  Trying kernel                    2.6.27-020627-generic    [OK]
  Trying kernel                    2.6.26-020626-generic    [OK]
  Trying kernel                    2.6.25-020625-generic    [OK]
  Trying kernel                    2.6.24-020624-generic    [OK]

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 include/linux/compat-3.5.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/compat-3.5.h b/include/linux/compat-3.5.h
index 3f97a3d..1d9128a 100644
--- a/include/linux/compat-3.5.h
+++ b/include/linux/compat-3.5.h
@@ -8,6 +8,26 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,5,0))
 
+/* switcheroo is available on >= 2.6.34 */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+#include <linux/vga_switcheroo.h>
+/*
+ * This backports:
+ *
+ *   From 26ec685ff9d9c16525d8ec4c97e52fcdb187b302 Mon Sep 17 00:00:00 2001
+ *   From: Takashi Iwai <tiwai@suse.de>
+ *   Date: Fri, 11 May 2012 07:51:17 +0200
+ *   Subject: [PATCH] vga_switcheroo: Introduce struct vga_switcheroo_client_ops
+ *
+ */
+
+struct vga_switcheroo_client_ops {
+    void (*set_gpu_state)(struct pci_dev *dev, enum vga_switcheroo_state);
+    void (*reprobe)(struct pci_dev *dev);
+    bool (*can_switch)(struct pci_dev *dev);
+};
+#endif
+
 /*
  * This backports:
  *
-- 
1.7.10.2

