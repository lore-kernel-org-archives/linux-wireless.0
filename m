Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37323 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbZBJUaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:30:25 -0500
Message-Id: <20090210202552.659884920@sipsolutions.net> (sfid-20090210_213027_862662_3D5FAA55)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:25:37 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/27] zd1211rw: do not ratelimit no-ops
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is rather confusing to see this in the log:
[  695.606877] __ratelimit: 40 callbacks suppressed
[  700.726878] __ratelimit: 40 callbacks suppressed

without ever seeing any actual message. This is because
zd1211rw doesn't compile out the net_ratelimit() call
properly if debugging is not enabled.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/zd1211rw/zd_def.h |    5 +++++
 drivers/net/wireless/zd1211rw/zd_mac.c |    7 +++----
 2 files changed, 8 insertions(+), 4 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_def.h	2009-02-06 14:25:41.000000000 +0100
+++ wireless-testing/drivers/net/wireless/zd1211rw/zd_def.h	2009-02-06 14:26:42.000000000 +0100
@@ -33,8 +33,13 @@ typedef u16 __nocast zd_addr_t;
 #ifdef DEBUG
 #  define dev_dbg_f(dev, fmt, args...) \
 	  dev_printk_f(KERN_DEBUG, dev, fmt, ## args)
+#  define dev_dbg_f_limit(dev, fmt, args...) do {\
+	if (net_ratelimit())
+		dev_printk_f(KERN_DEBUG, dev, fmt, ## args)
+} while (0)
 #else
 #  define dev_dbg_f(dev, fmt, args...) do { (void)(dev); } while (0)
+#  define dev_dbg_f_limit(dev, fmt, args...) do { (void)(dev); } while (0)
 #endif /* DEBUG */
 
 #ifdef DEBUG
--- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2009-02-06 14:25:27.000000000 +0100
+++ wireless-testing/drivers/net/wireless/zd1211rw/zd_mac.c	2009-02-06 14:26:57.000000000 +0100
@@ -793,10 +793,9 @@ static void zd_process_intr(struct work_
 	struct zd_mac *mac = container_of(work, struct zd_mac, process_intr);
 
 	int_status = le16_to_cpu(*(__le16 *)(mac->intr_buffer+4));
-	if (int_status & INT_CFG_NEXT_BCN) {
-		if (net_ratelimit())
-			dev_dbg_f(zd_mac_dev(mac), "INT_CFG_NEXT_BCN\n");
-	} else
+	if (int_status & INT_CFG_NEXT_BCN)
+		dev_dbg_f_limit(zd_mac_dev(mac), "INT_CFG_NEXT_BCN\n");
+	else
 		dev_dbg_f(zd_mac_dev(mac), "Unsupported interrupt\n");
 
 	zd_chip_enable_hwint(&mac->chip);

-- 

