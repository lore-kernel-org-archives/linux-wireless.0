Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46181 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab1CAFEO (ORCPT
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
Subject: [RFC v2 2/2] printk: add hexdump_debug macro
Date: Mon, 28 Feb 2011 21:06:56 -0800
Message-Id: <1298956016-30673-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1298956016-30673-1-git-send-email-bzhao@marvell.com>
References: <1298956016-30673-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hexdump_debug(str, buf, len)

str: "subject string"
buf: buffer pointer
len: length of the buffer being printed

usage:
hexdump_debug("mwifiex data: tx_buf:\n", tx_buf, 32);

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/linux/printk.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index ee048e7..c758131 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -299,4 +299,18 @@ static inline void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 
 #endif
 
+#if defined(DEBUG)
+#define hexdump_debug(str, buf, len) \
+do {									\
+	printk(KERN_DEBUG str);						\
+	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, buf, len);		\
+} while (0)
+#elif defined(CONFIG_DYNAMIC_DEBUG)
+#define hexdump_debug(str, buf, len) \
+	dynamic_hexdump_debug(str, buf, len)
+#else
+#define hexdump_debug(str, buf, len) \
+	no_printk(KERN_DEBUG str)
+#endif
+
 #endif
-- 
1.6.2.5

