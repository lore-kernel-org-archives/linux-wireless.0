Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:52397 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756567AbZBXOuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 09:50:21 -0500
Date: Tue, 24 Feb 2009 16:49:58 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Avoid AP mode BUG_ON hang with invalid lock assert
Message-ID: <20090224144958.GA467@jm.kir.nu> (sfid-20090224_155029_426458_2650CE9F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2b1d3f8fbd188d84713d25e9d1c3126e3852a1b3 added assert_cfg80211_lock()
calls into various places. At least one of them, nl80211_send_wiphy(),
should not have been there. That triggers the BUG_ON in
assert_cfg80211_lock() and pretty much kills the kernel whenever
someone runs hostapd.. Remove that call and make assert_cfg80211_lock()
use WARN_ON instead of BUG_ON to be a bit more friendly to users.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/wireless/core.h    |    2 +-
 net/wireless/nl80211.c |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

--- wireless-testing.orig/net/wireless/core.h	2009-02-24 16:32:53.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-02-24 16:33:18.000000000 +0200
@@ -76,7 +76,7 @@ extern struct list_head cfg80211_drv_lis
 
 static inline void assert_cfg80211_lock(void)
 {
-	BUG_ON(!mutex_is_locked(&cfg80211_mutex));
+	WARN_ON(!mutex_is_locked(&cfg80211_mutex));
 }
 
 /*
--- wireless-testing.orig/net/wireless/nl80211.c	2009-02-24 16:33:57.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-02-24 16:34:28.000000000 +0200
@@ -158,8 +158,6 @@ static int nl80211_send_wiphy(struct sk_
 	int i;
 	u16 ifmodes = dev->wiphy.interface_modes;
 
-	assert_cfg80211_lock();
-
 	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_WIPHY);
 	if (!hdr)
 		return -1;

-- 
Jouni Malinen                                            PGP id EFC895FA
