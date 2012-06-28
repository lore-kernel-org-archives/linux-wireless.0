Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44264 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2F1TpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 15:45:08 -0400
Received: by wgbdr13 with SMTP id dr13so2542617wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 12:45:06 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH option A] bcma: use custom printing functions
Date: Thu, 28 Jun 2012 21:44:48 +0200
Message-Id: <1340912688-3089-1-git-send-email-zajec5@gmail.com> (sfid-20120628_214513_551196_979CAEB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having bus number printed makes it much easier to anaylze logs on
systems with more buses. For example Netgear WNDR4500 has 3 AMBA buses
in total, which makes standard log really messy.
---
This patch (option A) keeps using pr_<level> in custom functions.

Pros: We use prefered functions (pr_<level>) in custom functions
Cons: Sometimes we may need to call pr_<level> directly. We won't get
	messages prefixed then (because of not setting pr_fmt).
---
 drivers/bcma/bcma_private.h |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index b81755b..1f638c5 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -1,10 +1,6 @@
 #ifndef LINUX_BCMA_PRIVATE_H_
 #define LINUX_BCMA_PRIVATE_H_
 
-#ifndef pr_fmt
-#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
-#endif
-
 #include <linux/bcma/bcma.h>
 #include <linux/delay.h>
 
@@ -12,6 +8,11 @@
 
 struct bcma_bus;
 
+#define bcma_err(fmt, ...) \
+	pr_err(KBUILD_MODNAME "-%d: " fmt, bus->num, ##__VA_ARGS__)
+#define bcma_info(fmt, ...) \
+	pr_info(KBUILD_MODNAME "-%d: " fmt, bus->num, ##__VA_ARGS__)
+
 /* main.c */
 int __devinit bcma_bus_register(struct bcma_bus *bus);
 void bcma_bus_unregister(struct bcma_bus *bus);
-- 
1.7.7

