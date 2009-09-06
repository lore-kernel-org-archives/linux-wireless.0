Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47146 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069AbZIFR6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2009 13:58:25 -0400
Date: Sun, 06 Sep 2009 12:58:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: Fix build error on i386 for net/wireless/scan.o
Message-ID: <4aa3f838.ef04Hi2n3Fg54rE9%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With i386 architecture, building the kernel v2.6.31-rc8-34797-g4910edb
fails with the following error:

  CC [M]  net/wireless/scan.o
net/wireless/scan.c: In function ‘cfg80211_inform_bss’:
net/wireless/scan.c:499: error: implicit declaration of function ‘kmemleak_ignore’
make[2]: *** [net/wireless/scan.o] Error 1

On x86_64, the build succeeds. Fix by including the appropriate header.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/net/wireless/scan.c
===================================================================
--- wireless-testing.orig/net/wireless/scan.c
+++ wireless-testing/net/wireless/scan.c
@@ -9,6 +9,7 @@
 #include <linux/wireless.h>
 #include <linux/nl80211.h>
 #include <linux/etherdevice.h>
+#include <linux/kmemleak.h>
 #include <net/arp.h>
 #include <net/cfg80211.h>
 #include <net/iw_handler.h>
