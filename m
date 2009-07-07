Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34941 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZGGByi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 21:54:38 -0400
Subject: [PATCH] mac80211: fix sparse warning
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 03:54:43 +0200
Message-Id: <1246931683.26030.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_testmode_cmd can very well be static.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2009-07-07 03:53:56.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-07-07 03:53:58.000000000 +0200
@@ -1289,7 +1289,7 @@ static void ieee80211_rfkill_poll(struct
 }
 
 #ifdef CONFIG_NL80211_TESTMODE
-int ieee80211_testmode_cmd(struct wiphy *wiphy, void *data, int len)
+static int ieee80211_testmode_cmd(struct wiphy *wiphy, void *data, int len)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 


