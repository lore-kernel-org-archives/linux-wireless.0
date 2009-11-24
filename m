Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:39830 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZKXCYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 21:24:49 -0500
Received: by yxe17 with SMTP id 17so5307924yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 18:24:56 -0800 (PST)
Message-ID: <4B0B43B2.8010207@gmail.com>
Date: Mon, 23 Nov 2009 21:23:46 -0500
From: Arnaud Lacombe <lacombar@gmail.com>
MIME-Version: 1.0
To: mcgrof@bombadil.infradead.org
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: [PATCH 01/13] Add skeleton for 2.6.14
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 Makefile        |    1 +
 compat-2.6.14.c |   18 ++++++++++++++++++
 compat-2.6.14.h |   12 ++++++++++++
 compat.h        |    1 +
 4 files changed, 32 insertions(+), 0 deletions(-)
 create mode 100644 compat-2.6.14.c
 create mode 100644 compat-2.6.14.h

diff --git a/Makefile b/Makefile
index be95c6a..fe008df 100644
--- a/Makefile
+++ b/Makefile
@@ -22,6 +22,7 @@ obj-m += compat.o
 compat-y += main.o

 # Compat kernel compatibility code
+compat-$(CONFIG_COMPAT_KERNEL_14) += compat-2.6.14.o
 compat-$(CONFIG_COMPAT_KERNEL_22) += compat-2.6.22.o
 compat-$(CONFIG_COMPAT_KERNEL_23) += compat-2.6.23.o
 compat-$(CONFIG_COMPAT_KERNEL_24) += compat-2.6.24.o
diff --git a/compat-2.6.14.c b/compat-2.6.14.c
new file mode 100644
index 0000000..e0af181
--- /dev/null
+++ b/compat-2.6.14.c
@@ -0,0 +1,18 @@
+/*
+ * Copyright 2007	Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compatibility file for Linux wireless for kernels 2.6.14.
+ */
+
+#include <net/compat.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14))
+
+/* 2.6.14 compat code goes here */
+
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14) */
+
diff --git a/compat-2.6.14.h b/compat-2.6.14.h
new file mode 100644
index 0000000..ec12941
--- /dev/null
+++ b/compat-2.6.14.h
@@ -0,0 +1,12 @@
+#ifndef LINUX_26_14_COMPAT_H
+#define LINUX_26_14_COMPAT_H
+
+#include <linux/autoconf.h>
+#include <linux/version.h>
+
+/* Compat work for 2.6.14 */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14))
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14)) */
+
+#endif /* LINUX_26_14_COMPAT_H */
diff --git a/compat.h b/compat.h
index 5c9c803..e537c23 100644
--- a/compat.h
+++ b/compat.h
@@ -9,6 +9,7 @@
  * code introduced for *that* kernel revision.
  */

+#include "compat-2.6.14.h"
 #include "compat-2.6.22.h"
 #include "compat-2.6.23.h"
 #include "compat-2.6.24.h"
-- 
1.6.3.3.385.g60647.dirty


