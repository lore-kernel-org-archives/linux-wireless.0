Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:19205 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2LMHpm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 02:45:42 -0500
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Joe Perches <joe@perches.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: [PATCH] wil6210: alternative functions for dynamic hexdump
Date: Thu, 13 Dec 2012 09:45:37 +0200
Message-ID: <8023432.kYh0e0Thzc@lx-vladimir> (sfid-20121213_084554_240546_4043CAD4)
In-Reply-To: <20121212155610.GK15974@pogo>
References: <1355327278-12965-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1355327278-12965-3-git-send-email-qca_vkondrat@qca.qualcomm.com> <20121212155610.GK15974@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, December 12, 2012 07:56:10 AM Luis R. Rodriguez wrote:
> On Wed, Dec 12, 2012 at 05:47:57PM +0200, Vladimir Kondratiev wrote:
> > Unless patch for dynamic hexdump merged into mainstream kernel,
> > need to provide replacement for the dynamic hexdump functionality
> > 
> > This patch do not hurt compilation with kernel that have
> > 'dynamic hexdump' patch merged - check performed by
> > #if !defined(print_hex_dump_debug)
> > 
> > To REMOVE when dynamic hexdump merged!!
> > 
> > Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> 
> I'd say just prefix with wil_ for now.
> 
>   Luis

Well, there is 2 alternative approaches:

1) 'weak' local implementation of the same functions
2) alternative implementation with different names

I am in favor of 1) and this is what I submitted; but I'd provide
below option 2). If it looks better for the most of people, let it be.

Patch below is alternative for:
[PATCH v10 2/3] wil6210: Local compensation for dynamic hexdump

Either that patch or those below may be used.

Opinions?

>From 6ef3f53e3fe86c9a890dc457f6b3b2bc779becc2 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Thu, 13 Dec 2012 09:37:19 +0200
Subject: [PATCH] wil6210: alternative functions for dynamic hexdump

Unless patch for dynamic hexdump merged into mainstream kernel,
need to provide replacement for the dynamic hexdump functionality

This patch introduces alternative functions with prefix wil_.

To REMOVE when dynamic hexdump merged!!

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/dbg_hexdump.h |   30 ++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h     |    6 +++--
 2 files changed, 34 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/dbg_hexdump.h

diff --git a/drivers/net/wireless/ath/wil6210/dbg_hexdump.h b/drivers/net/wireless/ath/wil6210/dbg_hexdump.h
new file mode 100644
index 0000000..6a315ba
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/dbg_hexdump.h
@@ -0,0 +1,30 @@
+#ifndef WIL_DBG_HEXDUMP_H_
+#define WIL_DBG_HEXDUMP_H_
+
+#if defined(CONFIG_DYNAMIC_DEBUG)
+#define wil_dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
+			     groupsize, buf, len, ascii)	\
+do {								\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor,		\
+		__builtin_constant_p(prefix_str) ? prefix_str : "hexdump");\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
+		print_hex_dump(KERN_DEBUG, prefix_str,		\
+			       prefix_type, rowsize, groupsize,	\
+			       buf, len, ascii);		\
+} while (0)
+
+#define wil_print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
+				 groupsize, buf, len, ascii)		\
+	wil_dynamic_hex_dump(prefix_str, prefix_type, rowsize,		\
+			     groupsize, buf, len, ascii)
+
+#define print_hex_dump_bytes(prefix_str, prefix_type, buf, len)	\
+	wil_dynamic_hex_dump(prefix_str, prefix_type, 16, 1, buf, len, true)
+#else /* defined(CONFIG_DYNAMIC_DEBUG) */
+#define wil_print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
+				 groupsize, buf, len, ascii)		\
+	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, rowsize,	\
+		       groupsize, buf, len, ascii)
+#endif /* defined(CONFIG_DYNAMIC_DEBUG) */
+
+#endif /* WIL_DBG_HEXDUMP_H_ */
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index ef5a17f..9bcfffa 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -21,6 +21,8 @@
 #include <linux/wireless.h>
 #include <net/cfg80211.h>
 
+#include "dbg_hexdump.h"
+
 #define WIL_NAME "wil6210"
 
 /**
@@ -276,13 +278,13 @@ struct wil6210_priv {
 
 #define wil_hex_dump_TXRX(prefix_str, prefix_type, rowsize,	\
 			  groupsize, buf, len, ascii)		\
-			  print_hex_dump_debug("DBG[TXRX]" prefix_str,\
+			  wil_print_hex_dump_debug("DBG[TXRX]" prefix_str,\
 					 prefix_type, rowsize,	\
 					 groupsize, buf, len, ascii)
 
 #define wil_hex_dump_WMI(prefix_str, prefix_type, rowsize,	\
 			 groupsize, buf, len, ascii)		\
-			 print_hex_dump_debug("DBG[ WMI]" prefix_str,	\
+			 wil_print_hex_dump_debug("DBG[ WMI]" prefix_str,\
 					prefix_type, rowsize,	\
 					groupsize, buf, len, ascii)
 
-- 
1.7.10.4


