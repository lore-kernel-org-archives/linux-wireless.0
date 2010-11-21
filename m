Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50478 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab0KUUss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Nov 2010 15:48:48 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: backport Generic exponentially weighted moving average (EWMA)
Date: Sun, 21 Nov 2010 21:48:36 +0100
Message-Id: <1290372517-6777-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile               |    1 +
 compat/compat-2.6.38.c        |   50 +++++++++++++++++++++++++++++++++++++++++
 include/linux/average.h       |    5 ++++
 include/linux/compat-2.6.38.h |   29 +++++++++++++++++++++++
 4 files changed, 85 insertions(+), 0 deletions(-)
 create mode 100644 compat/compat-2.6.38.c
 create mode 100644 include/linux/average.h

diff --git a/compat/Makefile b/compat/Makefile
index 46049af..18a9afc 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -27,3 +27,4 @@ compat-$(CONFIG_COMPAT_KERNEL_33) += compat-2.6.33.o
 compat-$(CONFIG_COMPAT_KERNEL_35) += compat-2.6.35.o
 compat-$(CONFIG_COMPAT_KERNEL_36) += compat-2.6.36.o
 compat-$(CONFIG_COMPAT_KERNEL_37) += compat-2.6.37.o
+compat-$(CONFIG_COMPAT_KERNEL_38) += compat-2.6.38.o
diff --git a/compat/compat-2.6.38.c b/compat/compat-2.6.38.c
new file mode 100644
index 0000000..172aa19
--- /dev/null
+++ b/compat/compat-2.6.38.c
@@ -0,0 +1,50 @@
+/*
+ * Copyright 2010    Hauke Mehrtens <hauke@hauke-m.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compatibility file for Linux wireless for kernels 2.6.38.
+ */
+
+#include <linux/compat.h>
+#include <linux/module.h>
+#include <linux/bug.h>
+
+/**
+ * ewma_init() - Initialize EWMA parameters
+ * @avg: Average structure
+ * @factor: Factor to use for the scaled up internal value. The maximum value
+ *	of averages can be ULONG_MAX/(factor*weight).
+ * @weight: Exponential weight, or decay rate. This defines how fast the
+ *	influence of older values decreases. Has to be bigger than 1.
+ *
+ * Initialize the EWMA parameters for a given struct ewma @avg.
+ */
+void ewma_init(struct ewma *avg, unsigned long factor, unsigned long weight)
+{
+	WARN_ON(weight <= 1 || factor == 0);
+	avg->internal = 0;
+	avg->weight = weight;
+	avg->factor = factor;
+}
+EXPORT_SYMBOL(ewma_init);
+
+/**
+ * ewma_add() - Exponentially weighted moving average (EWMA)
+ * @avg: Average structure
+ * @val: Current value
+ *
+ * Add a sample to the average.
+ */
+struct ewma *ewma_add(struct ewma *avg, unsigned long val)
+{
+	avg->internal = avg->internal  ?
+		(((avg->internal * (avg->weight - 1)) +
+			(val * avg->factor)) / avg->weight) :
+		(val * avg->factor);
+	return avg;
+}
+EXPORT_SYMBOL(ewma_add);
+
diff --git a/include/linux/average.h b/include/linux/average.h
new file mode 100644
index 0000000..ece86ca
--- /dev/null
+++ b/include/linux/average.h
@@ -0,0 +1,5 @@
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,37))
+#include_next <linux/average.h>
+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,37)) */
diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
index fa77a89..85eac51 100644
--- a/include/linux/compat-2.6.38.h
+++ b/include/linux/compat-2.6.38.h
@@ -5,6 +5,8 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,38))
 
+#include <linux/kernel.h>
+
 /*
  * This is not part of The 2.6.37 kernel yet but we
  * we use it to optimize the backport code we
@@ -25,6 +27,33 @@
 /* rename member in struct mmc_host in include/linux/mmc/host.h */
 #define max_segs	max_hw_segs
 
+
+/* Exponentially weighted moving average (EWMA) */
+
+/* For more documentation see lib/average.c */
+
+struct ewma {
+	unsigned long internal;
+	unsigned long factor;
+	unsigned long weight;
+};
+
+extern void ewma_init(struct ewma *avg, unsigned long factor,
+		      unsigned long weight);
+
+extern struct ewma *ewma_add(struct ewma *avg, unsigned long val);
+
+/**
+ * ewma_read() - Get average value
+ * @avg: Average structure
+ *
+ * Returns the average value held in @avg.
+ */
+static inline unsigned long ewma_read(const struct ewma *avg)
+{
+	return DIV_ROUND_CLOSEST(avg->internal, avg->factor);
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,38)) */
 
 #endif /* LINUX_26_38_COMPAT_H */
-- 
1.7.1

