Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41546 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2F1TpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 15:45:14 -0400
Received: by werb14 with SMTP id b14so662261wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 12:45:13 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH option B] bcma: use custom printing functions
Date: Thu, 28 Jun 2012 21:45:09 +0200
Message-Id: <1340912709-3153-1-git-send-email-zajec5@gmail.com> (sfid-20120628_214519_350331_37F02F07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having bus number printed makes it much easier to anaylze logs on
systems with more buses. For example Netgear WNDR4500 has 3 AMBA buses
in total, which makes standard log really messy.
---
This patch (option B) calls printk directly in custom functions.

Pros: We will still get "bcma" prefix when calling pr_<level> directly!
Cons: Not using prefered pr_<level> in custom functions

Personally I prefer this version. Sometime we can't use custom calls
(when we don't have bus reference): in early init or some small
functions like SPROM validation. It would be nice to still have "bcma"
prefix then (even without bus number).

Normally I don't like calling printk directly, but having such a calls
stored in 1 file sounds maintainable.
---
 drivers/bcma/bcma_private.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index b81755b..cc5d7b3 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -10,6 +10,11 @@
 
 #define BCMA_CORE_SIZE		0x1000
 
+#define bcma_err(fmt, ...) \
+	printk(KERN_ERR KBUILD_MODNAME "-%d: " fmt, bus->num, ##__VA_ARGS__)
+#define bcma_info(fmt, ...) \
+	printk(KERN_INFO KBUILD_MODNAME "-%d: " fmt, bus->num, ##__VA_ARGS__)
+
 struct bcma_bus;
 
 /* main.c */
-- 
1.7.7

