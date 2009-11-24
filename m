Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:56600 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555AbZKXCZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 21:25:07 -0500
Received: by ywh12 with SMTP id 12so5946537ywh.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 18:25:14 -0800 (PST)
Message-ID: <4B0B43C8.1040508@gmail.com>
Date: Mon, 23 Nov 2009 21:24:08 -0500
From: Arnaud Lacombe <lacombar@gmail.com>
MIME-Version: 1.0
To: mcgrof@bombadil.infradead.org
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: [PATCH 03/13] Add skeleton for 2.6.18
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 Makefile        |    1 +
 compat-2.6.18.c |   18 ++++++++++++++++++
 compat-2.6.18.h |   12 ++++++++++++
 compat.h        |    1 +
 4 files changed, 32 insertions(+), 0 deletions(-)
 create mode 100644 compat-2.6.18.c
 create mode 100644 compat-2.6.18.h

diff --git a/Makefile b/Makefile
index fe008df..9afc687 100644
--- a/Makefile
+++ b/Makefile
@@ -23,6 +23,7 @@ compat-y += main.o

 # Compat kernel compatibility code
 compat-$(CONFIG_COMPAT_KERNEL_14) += compat-2.6.14.o
+compat-$(CONFIG_COMPAT_KERNEL_18) += compat-2.6.18.o
 compat-$(CONFIG_COMPAT_KERNEL_22) += compat-2.6.22.o
 compat-$(CONFIG_COMPAT_KERNEL_23) += compat-2.6.23.o
 compat-$(CONFIG_COMPAT_KERNEL_24) += compat-2.6.24.o
diff --git a/compat-2.6.18.c b/compat-2.6.18.c
new file mode 100644
index 0000000..c7fb2e4
--- /dev/null
+++ b/compat-2.6.18.c
@@ -0,0 +1,18 @@
+/*
+ * Copyright 2007	Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compatibility file for Linux wireless for kernels 2.6.18.
+ */
+
+#include <net/compat.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18))
+
+/* 2.6.18 compat code goes here */
+
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18) */
+
diff --git a/compat-2.6.18.h b/compat-2.6.18.h
new file mode 100644
index 0000000..077f28b
--- /dev/null
+++ b/compat-2.6.18.h
@@ -0,0 +1,12 @@
+#ifndef LINUX_26_18_COMPAT_H
+#define LINUX_26_18_COMPAT_H
+
+#include <linux/autoconf.h>
+#include <linux/version.h>
+
+/* Compat work for 2.6.18 */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18))
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18)) */
+
+#endif /* LINUX_26_18_COMPAT_H */
diff --git a/compat.h b/compat.h
index e537c23..433840c 100644
--- a/compat.h
+++ b/compat.h
@@ -10,6 +10,7 @@
  */

 #include "compat-2.6.14.h"
+#include "compat-2.6.18.h"
 #include "compat-2.6.22.h"
 #include "compat-2.6.23.h"
 #include "compat-2.6.24.h"
-- 
1.6.3.3.385.g60647.dirty


