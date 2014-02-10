Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:41428 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbaBJVgN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 16:36:13 -0500
Received: from ip-94-112-189-223.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.189.223])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 10 Feb 2014 22:36:09 +0100
Date: Mon, 10 Feb 2014 22:38:28 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: linux-wireless@vger.kernel.org
Cc: Herton Ronaldo Krzesinski <herton@canonical.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-mips@linux-mips.org
Subject: [PATCH] rtl8187: fix regression on MIPS without coherent DMA
Message-ID: <20140210213828.GA15903@localhost.localdomain> (sfid-20140210_223616_972021_DF544B6A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes regression caused by commit a16dad77634 "MIPS: Fix
potencial corruption". That commit fixes one corruption scenario in
cost of adding another one, which actually start to cause crashes
on Yeeloong laptop when rtl8187 driver is used.

For correct DMA read operation on machines without DMA coherence, kernel
have to invalidate cache, such it will refill later with new data that
device wrote to memory, when that data is needed to process. We can only
invalidate full cache line. Hence when cache line includes both dma
buffer and some other data (written in cache, but not yet in main
memory), the other data can not hit memory due to invalidation. That
happen on rtl8187 where struct rtl8187_priv fields are located just
before and after small buffers that are passed to USB layer and DMA
is performed on them.

To fix the problem we align buffers and reserve space after them to make
them match cache line.

This patch does not resolve all possible MIPS problems entirely, for
that we have to assure that we always map cache aligned buffers for DMA,
what can be complex or even not possible. But patch fixes visible and
reproducible regression and seems other possible corruptions do not
happen in practice, since Yeeloong laptop works stable without rtl8187
driver.

Bug report:
https://bugzilla.kernel.org/show_bug.cgi?id=54391

Reported-by: Petr Pisar <petr.pisar@atlas.cz>
Bisected-by: Tom Li <biergaizi2009@gmail.com>
Reported-and-tested-by: Tom Li <biergaizi2009@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h b/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
index 56aee06..a6ad79f 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
+++ b/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
@@ -15,6 +15,8 @@
 #ifndef RTL8187_H
 #define RTL8187_H
 
+#include <linux/cache.h>
+
 #include "rtl818x.h"
 #include "leds.h"
 
@@ -139,7 +141,10 @@ struct rtl8187_priv {
 	u8 aifsn[4];
 	u8 rfkill_mask;
 	struct {
-		__le64 buf;
+		union {
+			__le64 buf;
+			u8 dummy1[L1_CACHE_BYTES];
+		} ____cacheline_aligned;
 		struct sk_buff_head queue;
 	} b_tx_status; /* This queue is used by both -b and non-b devices */
 	struct mutex io_mutex;
@@ -147,7 +152,8 @@ struct rtl8187_priv {
 		u8 bits8;
 		__le16 bits16;
 		__le32 bits32;
-	} *io_dmabuf;
+		u8 dummy2[L1_CACHE_BYTES];
+	} *io_dmabuf ____cacheline_aligned;
 	bool rfkill_off;
 	u16 seqno;
 };
-- 
1.7.4.4

