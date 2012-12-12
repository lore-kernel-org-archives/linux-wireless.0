Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:15435 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab2LLPsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 10:48:23 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Joe Perches <joe@perches.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v10 2/3] wil6210: Local compensation for dynamic hexdump
Date: Wed, 12 Dec 2012 17:47:57 +0200
Message-ID: <1355327278-12965-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121212_164832_044617_0E7E3A0F)
In-Reply-To: <1355327278-12965-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1355327278-12965-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unless patch for dynamic hexdump merged into mainstream kernel,
need to provide replacement for the dynamic hexdump functionality

This patch do not hurt compilation with kernel that have
'dynamic hexdump' patch merged - check performed by
#if !defined(print_hex_dump_debug)

To REMOVE when dynamic hexdump merged!!

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/dbg_hexdump.h |   32 ++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h     |    2 ++
 2 files changed, 34 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wil6210/dbg_hexdump.h

diff --git a/drivers/net/wireless/ath/wil6210/dbg_hexdump.h b/drivers/net/wireless/ath/wil6210/dbg_hexdump.h
new file mode 100644
index 0000000..7144eed
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/dbg_hexdump.h
@@ -0,0 +1,32 @@
+#ifndef DBG_HEXDUMP_H_
+#define DBG_HEXDUMP_H_
+
+#if !defined(print_hex_dump_debug)
+#if defined(CONFIG_DYNAMIC_DEBUG)
+#define dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
+			 groupsize, buf, len, ascii)		\
+do {								\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor,		\
+		__builtin_constant_p(prefix_str) ? prefix_str : "hexdump");\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
+		print_hex_dump(KERN_DEBUG, prefix_str,		\
+			       prefix_type, rowsize, groupsize,	\
+			       buf, len, ascii);		\
+} while (0)
+
+#define print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
+			     groupsize, buf, len, ascii)	\
+	dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
+			 groupsize, buf, len, ascii)
+
+#define print_hex_dump_bytes(prefix_str, prefix_type, buf, len)	\
+	dynamic_hex_dump(prefix_str, prefix_type, 16, 1, buf, len, true)
+#else /* defined(CONFIG_DYNAMIC_DEBUG) */
+#define print_hex_dump_debug(prefix_str, prefix_type, rowsize,		\
+			     groupsize, buf, len, ascii)		\
+	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, rowsize,	\
+		       groupsize, buf, len, ascii)
+#endif /* defined(CONFIG_DYNAMIC_DEBUG) */
+#endif /* !defined(print_hex_dump_debug) */
+
+#endif /* DBG_HEXDUMP_H_ */
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index ef5a17f..dd6ccc5 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -21,6 +21,8 @@
 #include <linux/wireless.h>
 #include <net/cfg80211.h>
 
+#include "dbg_hexdump.h"
+
 #define WIL_NAME "wil6210"
 
 /**
-- 
1.7.10.4

