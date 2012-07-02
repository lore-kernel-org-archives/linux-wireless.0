Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45740 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab2GBOW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 10:22:27 -0400
Received: by eeit10 with SMTP id t10so2095596eei.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jul 2012 07:22:26 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 2/5] compat: Backport shmem_read_mapping_page()
Date: Mon,  2 Jul 2012 17:22:11 +0300
Message-Id: <1341238934-30855-2-git-send-email-ozancag@gmail.com> (sfid-20120702_162242_917344_7C5A0E26)
In-Reply-To: <1341238934-30855-1-git-send-email-ozancag@gmail.com>
References: <1341238934-30855-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This backports:

commit d9d90e5eb70e09903dadff42099b6c948f814050
Author: Hugh Dickins <hughd@google.com>
Date:   Mon Jun 27 16:18:04 2011 -0700

    tmpfs: add shmem_read_mapping_page_gfp

shmem_read_mapping_page() is a wrapper around
shmem_read_mapping_page_gfp().

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
 compat/compat-3.0.c        |   23 +++++++++++++++++++++++
 include/linux/compat-3.0.h |   29 +++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/compat/compat-3.0.c b/compat/compat-3.0.c
index 1da45ac..e841373 100644
--- a/compat/compat-3.0.c
+++ b/compat/compat-3.0.c
@@ -12,6 +12,29 @@
 #include <linux/compat.h>
 #include <linux/if_ether.h>
 
+/* This pulls-in a lot of non-exported symbol backports
+ * on kernels older than 2.6.32. There's no harm for not
+ * making this available on kernels < 2.6.32. */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32))
+#include <linux/pagemap.h>
+
+/* This backports:
+ *
+ * commit d9d90e5eb70e09903dadff42099b6c948f814050
+ * Author: Hugh Dickins <hughd@google.com>
+ * Date:   Mon Jun 27 16:18:04 2011 -0700
+ *
+ *	tmpfs: add shmem_read_mapping_page_gfp
+ */
+
+struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
+                                        pgoff_t index, gfp_t gfp)
+{
+       return read_cache_page_gfp(mapping, index, gfp);
+}
+EXPORT_SYMBOL_GPL(shmem_read_mapping_page_gfp);
+#endif
+
 int mac_pton(const char *s, u8 *mac)
 {
 	int i;
diff --git a/include/linux/compat-3.0.h b/include/linux/compat-3.0.h
index 22ab539..ba25846 100644
--- a/include/linux/compat-3.0.h
+++ b/include/linux/compat-3.0.h
@@ -7,6 +7,35 @@
 
 #include <linux/rcupdate.h>
 
+/* This pulls-in a lot of non-exported symbol backports
+ * on kernels older than 2.6.32. There's no harm for not
+ * making this available on kernels < 2.6.32. */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32))
+#include <linux/pagemap.h>
+
+/* This backports the 2nd part of:
+ *
+ * commit d9d90e5eb70e09903dadff42099b6c948f814050
+ * Author: Hugh Dickins <hughd@google.com>
+ * Date:   Mon Jun 27 16:18:04 2011 -0700
+ *
+ *	tmpfs: add shmem_read_mapping_page_gfp
+ *
+ * First part is in compat-3.0.c.
+ */
+extern struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
+						pgoff_t index, gfp_t gfp);
+
+
+static inline struct page *shmem_read_mapping_page(
+                               struct address_space *mapping, pgoff_t index)
+{
+       return shmem_read_mapping_page_gfp(mapping, index,
+                                       mapping_gfp_mask(mapping));
+}
+#endif
+
+
 /*
  * since commit 1c5cae815d19ffe02bdfda1260949ef2b1806171
  * "net: call dev_alloc_name from register_netdevice" dev_alloc_name is
-- 
1.7.10.4

