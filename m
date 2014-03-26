Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:45286 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120AbaCZUDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 16:03:13 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so2059987eek.39
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 13:03:12 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 19/20] rtl8180: enable rtl8187se support
Date: Wed, 26 Mar 2014 21:04:23 +0100
Message-Id: <1395864263-5181-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_210318_767882_6C62058E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Finally make rtl8187se works (hopefylly).
This patch adds PCI ID for rtl8187, updates copyright notes and
updates MODULE_DESCRIPTION.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 39 +++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 2046fe2..98d8256f 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -1,15 +1,42 @@
 
-/*
- * Linux device driver for RTL8180 / RTL8185
+/* Linux device driver for RTL8180 / RTL8185 / RTL8187SE
  *
  * Copyright 2007 Michael Wu <flamingice@sourmilk.net>
- * Copyright 2007 Andrea Merello <andrea.merello@gmail.com>
+ * Copyright 2007,2014 Andrea Merello <andrea.merello@gmail.com>
  *
  * Based on the r8180 driver, which is:
  * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  *
  * Thanks to Realtek for their support!
  *
+ ************************************************************************
+ *
+ * The driver was extended to the RTL8187SE in 2014 by
+ * Andrea Merello <andrea.merello@gmail.com>
+ *
+ * based also on:
+ *  - portions of rtl8187se Linux staging driver, Copyright Realtek corp.
+ *  - other GPL, unpublished (until now), Linux driver code,
+ *    Copyright Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ * A huge thanks goes to Sara V. Nari who forgives me when I'm
+ * sitting in front of my laptop at evening, week-end, night...
+ *
+ * A special thanks goes to Antonio Cuni, who helped me with
+ * some python userspace stuff I used to debug RTL8187SE code, and who
+ * bought a laptop with an unsupported Wi-Fi card some years ago...
+ *
+ * Thanks to Larry Finger for writing some code for rtl8187se and for
+ * his suggestions.
+ *
+ * Thanks to Dan Carpenter for reviewing my initial patch and for his
+ * suggestions.
+ *
+ * Thanks to Bernhard Schiffner for his help in testing and for his
+ * suggestions.
+ *
+ ************************************************************************
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -33,10 +60,14 @@
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_AUTHOR("Andrea Merello <andrea.merello@gmail.com>");
-MODULE_DESCRIPTION("RTL8180 / RTL8185 PCI wireless driver");
+MODULE_DESCRIPTION("RTL8180 / RTL8185 / RTL8187SE PCI wireless driver");
 MODULE_LICENSE("GPL");
 
 static DEFINE_PCI_DEVICE_TABLE(rtl8180_table) = {
+
+	/* rtl8187se */
+	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8199) },
+
 	/* rtl8185 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8185) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BELKIN, 0x700f) },
-- 
1.8.3.2

