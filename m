Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43138 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab0BLJpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2010 04:45:10 -0500
Subject: [PATCH] mac80211: fix netdev rename
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 10:45:05 +0100
Message-ID: <1265967905.4388.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a copy bug introduced by

    commit 47846c9b0c10808d9337d2e7d09361f3e0a0a71a
    Author: Johannes Berg <johannes@sipsolutions.net>
    Date:   Wed Nov 25 17:46:19 2009 +0100

        mac80211: reduce reliance on netdev

This manifested itself only in debug messages
and in the debugfs rename failure that would
always happen due to trying to rename the dir
over itself.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org
---
 net/mac80211/iface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/iface.c	2010-02-12 10:30:17.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2010-02-12 10:30:21.000000000 +0100
@@ -1031,7 +1031,7 @@ static int netdev_notify(struct notifier
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	memcpy(sdata->name, sdata->name, IFNAMSIZ);
+	memcpy(sdata->name, dev->name, IFNAMSIZ);
 
 	ieee80211_debugfs_rename_netdev(sdata);
 	return 0;


