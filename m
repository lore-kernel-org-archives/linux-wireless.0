Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:56600 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752AbZKXCZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 21:25:26 -0500
Received: by mail-yw0-f182.google.com with SMTP id 12so5946537ywh.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 18:25:33 -0800 (PST)
Message-ID: <4B0B43D7.7020308@gmail.com>
Date: Mon, 23 Nov 2009 21:24:23 -0500
From: Arnaud Lacombe <lacombar@gmail.com>
MIME-Version: 1.0
To: mcgrof@bombadil.infradead.org
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: [PATCH 05/13] Add skeleton for 2.6.19
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 Makefile        |    1 +
 compat-2.6.19.c |   18 ++++++++++++++++++
 compat-2.6.19.h |   12 ++++++++++++
 compat.h        |    1 +
 4 files changed, 32 insertions(+), 0 deletions(-)
 create mode 100644 compat-2.6.19.c
 create mode 100644 compat-2.6.19.h

diff --git a/Makefile b/Makefile
index 9afc687..3f1a4ad 100644
--- a/Makefile
+++ b/Makefile
@@ -24,6 +24,7 @@ compat-y += main.o
 # Compat kernel compatibility code
 compat-$(CONFIG_COMPAT_KERNEL_14) += compat-2.6.14.o
 compat-$(CONFIG_COMPAT_KERNEL_18) += compat-2.6.18.o
+compat-$(CONFIG_COMPAT_KERNEL_19) += compat-2.6.19.o
 compat-$(CONFIG_COMPAT_KERNEL_22) += compat-2.6.22.o
 compat-$(CONFIG_COMPAT_KERNEL_23) += compat-2.6.23.o
 compat-$(CONFIG_COMPAT_KERNEL_24) += compat-2.6.24.o
diff --git a/compat-2.6.19.c b/compat-2.6.19.c
new file mode 100644
index 0000000..fc75b64
--- /dev/null
+++ b/compat-2.6.19.c
@@ -0,0 +1,18 @@
+/*
+ * Copyright 2007	Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compatibility file for Linux wireless for kernels 2.6.19.
+ */
+
+#include <net/compat.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19))
+
+/* 2.6.19 compat code goes here */
+
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19) */
+
diff --git a/compat-2.6.19.h b/compat-2.6.19.h
new file mode 100644
index 0000000..7967390
--- /dev/null
+++ b/compat-2.6.19.h
@@ -0,0 +1,12 @@
+#ifndef LINUX_26_19_COMPAT_H
+#define LINUX_26_19_COMPAT_H
+
+#include <linux/autoconf.h>
+#include <linux/version.h>
+
+/* Compat work for 2.6.19 */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,19))
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)) */
+
+#endif /* LINUX_26_19_COMPAT_H */
diff --git a/compat.h b/compat.h
index 433840c..f835aef 100644
--- a/compat.h
+++ b/compat.h
@@ -11,6 +11,7 @@

 #include "compat-2.6.14.h"
 #include "compat-2.6.18.h"
+#include "compat-2.6.19.h"
 #include "compat-2.6.22.h"
 #include "compat-2.6.23.h"
 #include "compat-2.6.24.h"
-- 
1.6.3.3.385.g60647.dirty


