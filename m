Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:61428 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbZJASW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 14:22:28 -0400
Received: by bwz6 with SMTP id 6so367728bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2009 11:22:31 -0700 (PDT)
Message-ID: <4AC4F363.4080404@lwfinger.net>
Date: Thu, 01 Oct 2009 13:22:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] staging: Add proper selection of WIRELESS_EXT and WEXT_PRIV
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the incorporation of the patch entitled "wext: refactor", some
of the wireless drivers in drivers/staging fail to build because they
need to have CONFIG_WIRELESS_EXT and CONFIG_WEXT_PRIV defined.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

I know that Greg K-H maintains staging, but I sent this to you because
your tree is the only one affected at the moment. Greg is Cc'd.

Larry
---

Index: wireless-testing/drivers/staging/rtl8187se/Kconfig
===================================================================
--- wireless-testing.orig/drivers/staging/rtl8187se/Kconfig
+++ wireless-testing/drivers/staging/rtl8187se/Kconfig
@@ -1,6 +1,7 @@
 config RTL8187SE
 	tristate "RealTek RTL8187SE Wireless LAN NIC driver"
 	depends on PCI
-	depends on WIRELESS_EXT
+	select WIRELESS_EXT
+	select WEXT_PRIV
 	default N
 	---help---
Index: wireless-testing/drivers/staging/rtl8192e/Kconfig
===================================================================
--- wireless-testing.orig/drivers/staging/rtl8192e/Kconfig
+++ wireless-testing/drivers/staging/rtl8192e/Kconfig
@@ -1,6 +1,7 @@
 config RTL8192E
 	tristate "RealTek RTL8192E Wireless LAN NIC driver"
 	depends on PCI
-	depends on WIRELESS_EXT
+	select WIRELESS_EXT
+	select WEXT_PRIV
 	default N
 	---help---
Index: wireless-testing/drivers/staging/vt6655/Kconfig
===================================================================
--- wireless-testing.orig/drivers/staging/vt6655/Kconfig
+++ wireless-testing/drivers/staging/vt6655/Kconfig
@@ -1,6 +1,8 @@
 config VT6655
    tristate "VIA Technologies VT6655 support"
-   depends on WIRELESS_EXT && PCI
+   depends on PCI
+   select WIRELESS_EXT
+   select WEXT_PRIV
    ---help---
    This is a vendor-written driver for VIA VT6655.

Index: wireless-testing/drivers/staging/vt6656/Kconfig
===================================================================
--- wireless-testing.orig/drivers/staging/vt6656/Kconfig
+++ wireless-testing/drivers/staging/vt6656/Kconfig
@@ -1,6 +1,8 @@
 config VT6656
 	tristate "VIA Technologies VT6656 support"
-	depends on WIRELESS_EXT && USB
+	depends on USB
+	select WIRELESS_EXT
+	select WEXT_PRIV
 	---help---
 	This is a vendor-written driver for VIA VT6656.

