Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45406 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbYIIOd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 10:33:27 -0400
Subject: [PATCH] mac80211: Reorder debugfs calls during netdev deinit
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 16:33:15 +0200
Message-Id: <1220970795.31304.175.camel@johannes.berg> (sfid-20080909_163330_278454_AC4B4000)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jouni Malinen <j@w1.fi>

ieee80211_free_keys() must be called before
ieee80211_debugfs_remove_netdev() in order to make sure that the
possible default_key symlink is removed before attempting to
remove the netdev debugfs directory.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I've also seen the dangling netdev directories now, even without
802.11w.

 net/mac80211/iface.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/iface.c	2008-09-09 15:09:55.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-09-09 16:29:00.000000000 +0200
@@ -31,11 +31,11 @@ static void ieee80211_teardown_sdata(str
 	int flushed;
 	int i;
 
-	ieee80211_debugfs_remove_netdev(sdata);
-
 	/* free extra data */
 	ieee80211_free_keys(sdata);
 
+	ieee80211_debugfs_remove_netdev(sdata);
+
 	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
 		__skb_queue_purge(&sdata->fragments[i].skb_list);
 	sdata->fragment_next = 0;


