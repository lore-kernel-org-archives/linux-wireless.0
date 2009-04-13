Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:40573 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZDMUo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 16:44:27 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ath: add module information
Date: Mon, 13 Apr 2009 22:44:23 +0200
Cc: "Bob Copeland" <me@bobcopeland.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200904132244.24122.chunkeey@web.de> (sfid-20090413_224429_546820_FBC23D17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds licensing information, description and author to the module.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
Luis,

what does your secretary say?
As we are "borrowing" dual licensed code and I guess Atheros wants
to keep their code "this way", right?

Regards,
	Chr
---
diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index a005b91..4bb0132 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -3,5 +3,4 @@ obj-$(CONFIG_ATH9K)		+= ath9k/
 obj-$(CONFIG_AR9170_USB)        += ar9170/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
-ath-objs 		:= regd.o
-
+ath-objs 		:= main.o regd.o
diff --git a/drivers/net/wireless/ath/main.c b/drivers/net/wireless/ath/main.c
new file mode 100644
index 0000000..c5eb144
--- /dev/null
+++ b/drivers/net/wireless/ath/main.c
@@ -0,0 +1,33 @@
+/*
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+MODULE_AUTHOR("Atheros Communications");
+MODULE_DESCRIPTION("Shared library for Atheros wireless LAN cards.");
+MODULE_LICENSE("Dual BSD/GPL");
+
+static int __init ath_init(void)
+{
+	return 0;
+}
+module_init(ath_init);
+
+static void __exit ath_exit(void)
+{
+}
+module_exit(ath_exit);
