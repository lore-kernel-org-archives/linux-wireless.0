Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:30076 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030334AbXCCRzP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 12:55:15 -0500
Received: by ug-out-1314.google.com with SMTP id 44so960621uga
        for <linux-wireless@vger.kernel.org>; Sat, 03 Mar 2007 09:55:13 -0800 (PST)
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: rename rt2x00lib.c
Date: Sat, 3 Mar 2007 18:55:06 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200703031855.06488.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is best to rename rt2x00lib.c now, because we want to
link rt2x00debug.c and several other objects to it soon.
Patches for creating those new objects, which will link to
rt2x00lib as well will arrive soon.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

The rt2x00lib.c file has been renamed with the following command:
cg-mv drivers/net/wireless/mac80211/rt2x00/rt2x00lib.c drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c

diff --git a/drivers/net/wireless/mac80211/rt2x00/Makefile b/drivers/net/wireless/mac80211/rt2x00/Makefile
index 10c7d9a..f9f9810 100644
--- a/drivers/net/wireless/mac80211/rt2x00/Makefile
+++ b/drivers/net/wireless/mac80211/rt2x00/Makefile
@@ -1,3 +1,5 @@
+rt2x00lib-objs := rt2x00dev.o
+
 obj-$(CONFIG_RT2X00_LIB)	+= rt2x00lib.o
 obj-$(CONFIG_RT2400PCI)		+= rt2400pci.o
 obj-$(CONFIG_RT2500PCI)		+= rt2500pci.o
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
similarity index 100%
rename from drivers/net/wireless/mac80211/rt2x00/rt2x00lib.c
rename to drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
