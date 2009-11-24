Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:56600 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbZKXCZg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 21:25:36 -0500
Received: by mail-yw0-f182.google.com with SMTP id 12so5946537ywh.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 18:25:43 -0800 (PST)
Message-ID: <4B0B43DF.1060908@gmail.com>
Date: Mon, 23 Nov 2009 21:24:31 -0500
From: Arnaud Lacombe <lacombar@gmail.com>
MIME-Version: 1.0
To: mcgrof@bombadil.infradead.org
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: [PATCH 07/13] Add skeleton for 2.6.21
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 Makefile        |    1 +
 compat-2.6.21.c |   18 ++++++++++++++++++
 compat-2.6.21.h |   12 ++++++++++++
 compat.h        |    1 +
 4 files changed, 32 insertions(+), 0 deletions(-)
 create mode 100644 compat-2.6.21.c
 create mode 100644 compat-2.6.21.h

diff --git a/Makefile b/Makefile
index 3f1a4ad..1677589 100644
--- a/Makefile
+++ b/Makefile
@@ -25,6 +25,7 @@ compat-y += main.o
 compat-$(CONFIG_COMPAT_KERNEL_14) += compat-2.6.14.o
 compat-$(CONFIG_COMPAT_KERNEL_18) += compat-2.6.18.o
 compat-$(CONFIG_COMPAT_KERNEL_19) += compat-2.6.19.o
+compat-$(CONFIG_COMPAT_KERNEL_21) += compat-2.6.21.o
 compat-$(CONFIG_COMPAT_KERNEL_22) += compat-2.6.22.o
 compat-$(CONFIG_COMPAT_KERNEL_23) += compat-2.6.23.o
 compat-$(CONFIG_COMPAT_KERNEL_24) += compat-2.6.24.o
diff --git a/compat-2.6.21.c b/compat-2.6.21.c
new file mode 100644
index 0000000..e2737fb
--- /dev/null
+++ b/compat-2.6.21.c
@@ -0,0 +1,18 @@
+/*
+ * Copyright 2007	Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compatibility file for Linux wireless for kernels 2.6.21.
+ */
+
+#include <net/compat.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21))
+
+/* 2.6.21 compat code goes here */
+
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21) */
+
diff --git a/compat-2.6.21.h b/compat-2.6.21.h
new file mode 100644
index 0000000..c185cfb
--- /dev/null
+++ b/compat-2.6.21.h
@@ -0,0 +1,12 @@
+#ifndef LINUX_26_21_COMPAT_H
+#define LINUX_26_21_COMPAT_H
+
+#include <linux/autoconf.h>
+#include <linux/version.h>
+
+/* Compat work for 2.6.21 */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21))
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) */
+
+#endif /* LINUX_26_21_COMPAT_H */
diff --git a/compat.h b/compat.h
index f835aef..ceedc47 100644
--- a/compat.h
+++ b/compat.h
@@ -12,6 +12,7 @@
 #include "compat-2.6.14.h"
 #include "compat-2.6.18.h"
 #include "compat-2.6.19.h"
+#include "compat-2.6.21.h"
 #include "compat-2.6.22.h"
 #include "compat-2.6.23.h"
 #include "compat-2.6.24.h"
-- 
1.6.3.3.385.g60647.dirty


