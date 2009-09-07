Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:54540 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbZIGOe5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2009 10:34:57 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: add missing #include <linux/kmemleak.h>
Date: Mon, 7 Sep 2009 16:34:33 +0200
Cc: John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909071634.33669.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

Fixes this error:

  CC [M]  net/wireless/scan.o
net/wireless/scan.c: In function 'cfg80211_inform_bss':
net/wireless/scan.c:499: error: implicit declaration of function 'kmemleak_ignore'

Index: linux-wl/net/wireless/scan.c
===================================================================
--- linux-wl.orig/net/wireless/scan.c   2009-09-07 15:25:01.000000000 +0200
+++ linux-wl/net/wireless/scan.c        2009-09-07 15:25:09.000000000 +0200
@@ -9,6 +9,7 @@
 #include <linux/wireless.h>
 #include <linux/nl80211.h>
 #include <linux/etherdevice.h>
+#include <linux/kmemleak.h>
 #include <net/arp.h>
 #include <net/cfg80211.h>
 #include <net/iw_handler.h>


