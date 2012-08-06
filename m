Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44473 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2HFNg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 09:36:26 -0400
Received: by eaac11 with SMTP id c11so833308eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 06:36:25 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat: Backport kmalloc_array()
Date: Mon,  6 Aug 2012 16:36:18 +0300
Message-Id: <1344260178-404-1-git-send-email-ozancag@gmail.com> (sfid-20120806_153659_757313_5FBD3786)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new radeon DRM driver from 3.6 uses kmalloc_array().

This backports:

commit a8203725dfded5c1f79dca3368a4a273e24b59bb
Author: Xi Wang <xi.wang@gmail.com>
Date:   Mon Mar 5 15:14:41 2012 -0800

    slab: introduce kmalloc_array()

[root@ozan linux-2.6]# git describe --contains a8203725
v3.4-rc1~56^2~1

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
 include/linux/compat-3.4.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/compat-3.4.h b/include/linux/compat-3.4.h
index e603f4c..06a3a07 100644
--- a/include/linux/compat-3.4.h
+++ b/include/linux/compat-3.4.h
@@ -5,6 +5,24 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0))
 
+/* This backports:
+ *
+ * commit a8203725dfded5c1f79dca3368a4a273e24b59bb
+ * Author: Xi Wang <xi.wang@gmail.com>
+ * Date:   Mon Mar 5 15:14:41 2012 -0800
+ *
+ * 	slab: introduce kmalloc_array()
+ */
+
+/* SIZE_MAX is backported in compat-3.5.h so include it */
+#include <linux/compat-3.5.h>
+static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
+{
+	if (size != 0 && n > SIZE_MAX / size)
+		return NULL;
+	return __kmalloc(n * size, flags);
+}
+
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 
-- 
1.7.10.4

