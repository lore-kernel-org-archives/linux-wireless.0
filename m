Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:48713 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555AbZKXCZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 21:25:53 -0500
Received: by yxe17 with SMTP id 17so5308557yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 18:25:59 -0800 (PST)
Message-ID: <4B0B43EA.9080304@gmail.com>
Date: Mon, 23 Nov 2009 21:24:42 -0500
From: Arnaud Lacombe <lacombar@gmail.com>
MIME-Version: 1.0
To: mcgrof@bombadil.infradead.org
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: [PATCH 06/13] Add compatibility call for kmem_cache_destroy()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On commit 133d205a, kmem_cache_destroy() was made returning void, while
older
kernel could return an error value.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 compat-2.6.19.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/compat-2.6.19.h b/compat-2.6.19.h
index 7967390..017044c 100644
--- a/compat-2.6.19.h
+++ b/compat-2.6.19.h
@@ -7,6 +7,19 @@
 /* Compat work for 2.6.19 */
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,19))

+#include <linux/slab.h>
+
+static inline int
+compat_kmem_cache_destroy(struct kmem_cache *cachep)
+{
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19))
+	return kmem_cache_destroy(cachep);
+#else
+	kmem_cache_destroy(cachep);
+	return 0;
+#endif
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)) */

 #endif /* LINUX_26_19_COMPAT_H */
-- 
1.6.3.3.385.g60647.dirty


