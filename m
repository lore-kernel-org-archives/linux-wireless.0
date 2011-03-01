Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46177 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1CAFEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 00:04:14 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [RFC v2 1/2] dynamic debug: add dynamic_hexdump_debug macro
Date: Mon, 28 Feb 2011 21:06:55 -0800
Message-Id: <1298956016-30673-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1298956016-30673-1-git-send-email-bzhao@marvell.com>
References: <1298956016-30673-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dynamic_hexdump_debug(str, buf, len)

str: "subject string"
buf: buffer pointer
len: length of the buffer being printed

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/linux/dynamic_debug.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 0c9653f..429a176 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -70,6 +70,19 @@ extern int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
 		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
 	} while (0)
 
+#define dynamic_hexdump_debug(str, buf, len)				\
+do {									\
+	static struct _ddebug descriptor				\
+	__used								\
+	__attribute__((section("__verbose"), aligned(8))) =		\
+	{ KBUILD_MODNAME, __func__, __FILE__, str, __LINE__,		\
+		_DPRINTK_FLAGS_DEFAULT };				\
+	if (unlikely(descriptor.enabled)) {				\
+		printk(KERN_DEBUG str);					\
+		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, buf, len);	\
+	}								\
+} while (0)
+
 #else
 
 static inline int ddebug_remove_module(const char *mod)
@@ -81,6 +94,15 @@ static inline int ddebug_remove_module(const char *mod)
 	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
 #define dynamic_dev_dbg(dev, fmt, ...)					\
 	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__); } while (0)
+
+#define dynamic_hexdump_debug(str, buf, len)				\
+do {									\
+	if (0) {							\
+		printk(KERN_DEBUG str);					\
+		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, buf, len);	\
+	}								\
+} while (0)
+
 #endif
 
 #endif
-- 
1.6.2.5

