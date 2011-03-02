Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:52236 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab1CBBVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 20:21:25 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [RFC v3 2/2] printk: add hexdump_debug macro
Date: Tue,  1 Mar 2011 17:24:10 -0800
Message-Id: <1299029050-32242-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1299029050-32242-1-git-send-email-bzhao@marvell.com>
References: <1299029050-32242-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hexdump_debug(str, buf, len)

str: "prefix string"
buf: buffer pointer
len: length of the buffer being printed

usage:
hexdump_debug("mwifiex data_d: tx_buf: ", tx_buf, 32);

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v3: use "str" as prefix string (Joe Perches)
v2: rebase against linux-next.git tree and split into 2 patches

 include/linux/printk.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index ee048e7..041ef6d 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -299,4 +299,15 @@ static inline void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 
 #endif
 
+#if defined(DEBUG)
+#define hexdump_debug(str, buf, len) \
+	print_hex_dump_bytes(str, DUMP_PREFIX_OFFSET, buf, len);
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

