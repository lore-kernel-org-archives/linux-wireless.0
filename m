Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36901 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZBFOZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 09:25:38 -0500
Subject: [PATCH] zd1211rw: do not ratelimit no-ops
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Daniel Drake <dsd@gentoo.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 14:31:18 +0100
Message-Id: <1233927078.4175.0.camel@johannes.local> (sfid-20090206_152543_039159_43C8ECC6)
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


