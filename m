Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42459 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0HAWDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 18:03:16 -0400
Received: by eya25 with SMTP id 25so1118027eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Aug 2010 15:03:15 -0700 (PDT)
From: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	Kshitij Kulshreshtha <kkhere.geo@gmail.com>
Subject: [PATCH 1/3] compat: backport hex_to_bin first introduced in v2.6.35
Date: Mon,  2 Aug 2010 00:02:49 +0200
Message-Id: <1280700173-14690-2-git-send-email-kkhere.geo@gmail.com>
In-Reply-To: <4C55D22A.5040302@hauke-m.de>
References: <4C55D22A.5040302@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
---
 compat/Makefile               |    1 +
 compat/compat-2.6.35.c        |   34 ++++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.35.h |    2 ++
 3 files changed, 37 insertions(+), 0 deletions(-)
 create mode 100644 compat/compat-2.6.35.c

diff --git a/compat/Makefile b/compat/Makefile
index 2005ff3..bcd8fe7 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -26,3 +26,4 @@ compat-$(CONFIG_COMPAT_KERNEL_30) += compat-2.6.30.o
 compat-$(CONFIG_COMPAT_KERNEL_31) += compat-2.6.31.o
 compat-$(CONFIG_COMPAT_KERNEL_32) += compat-2.6.32.o
 compat-$(CONFIG_COMPAT_KERNEL_33) += compat-2.6.33.o
+compat-$(CONFIG_COMPAT_KERNEL_35) += compat-2.6.35.o
diff --git a/compat/compat-2.6.35.c b/compat/compat-2.6.35.c
new file mode 100644
index 0000000..0d702ed
--- /dev/null
+++ b/compat/compat-2.6.35.c
@@ -0,0 +1,34 @@
+/*
+ * Copyright 2010    Kshitij Kulshreshtha <kkhere.geo@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compatibility file for Linux wireless for kernels 2.6.35.
+ */
+
+#include <linux/compat.h>
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)
+#include <linux/ctype.h>
+
+/**
+ * hex_to_bin - convert a hex digit to its real value
+ * @ch: ascii character represents hex digit
+ *
+ * hex_to_bin() converts one hex digit to its actual value or -1 in case of bad
+ * input.
+ */
+int hex_to_bin(char ch)
+{
+	if ((ch >= '0') && (ch <= '9'))
+		return ch - '0';
+	ch = tolower(ch);
+	if ((ch >= 'a') && (ch <= 'f'))
+		return ch - 'a' + 10;
+	return -1;
+}
+EXPORT_SYMBOL(hex_to_bin);
+
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35) */
diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index c6e7136..f0562cd 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -25,6 +25,8 @@ static inline wait_queue_head_t *sk_sleep(struct sock *sk)
 
 #define sdio_writeb_readb(func, write_byte, addr, err_ret) sdio_readb(func, addr, err_ret)
 
+int hex_to_bin(char ch);
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)) */
 
 #endif /* LINUX_26_35_COMPAT_H */
-- 
1.7.1

