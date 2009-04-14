Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:40202 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbZDNULX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 16:11:23 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2] ath: add module information
Date: Tue, 14 Apr 2009 22:11:20 +0200
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
References: <200904132244.24122.chunkeey@web.de> <20090414115843.GA6219@infradead.org>
In-Reply-To: <20090414115843.GA6219@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200904142211.21147.chunkeey@web.de> (sfid-20090414_234557_027333_B10C0E36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds licensing, author information and a description to the module.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
On Tuesday 14 April 2009 13:58:43 Christoph Hellwig wrote:
> > [module_init & module_exit stubs]
> 
> No need for these.

OK! will remove the ones in p54common.c too.
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
@@ -0,0 +1,22 @@
+/*
+ * Copyright (c) 2009 Atheros Communications Inc.
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
