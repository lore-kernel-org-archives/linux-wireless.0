Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbYLHXLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 18:11:08 -0500
Subject: [PATCH] mac80211: only create default STA interface if supported
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 00:10:30 +0100
Message-Id: <1228777830.22164.152.camel@johannes.berg> (sfid-20081209_001113_388011_1C46594F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers will support this, obviously, but this forces them to
set it up properly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- everything.orig/net/mac80211/main.c	2008-12-09 00:07:37.000000000 +0100
+++ everything/net/mac80211/main.c	2008-12-09 00:09:00.000000000 +0100
@@ -892,12 +892,14 @@ int ieee80211_register_hw(struct ieee802
 
 	local->mdev->select_queue = ieee80211_select_queue;
 
-	/* add one default STA interface */
-	result = ieee80211_if_add(local, "wlan%d", NULL,
-				  NL80211_IFTYPE_STATION, NULL);
-	if (result)
-		printk(KERN_WARNING "%s: Failed to add default virtual iface\n",
-		       wiphy_name(local->hw.wiphy));
+	/* add one default STA interface if supported */
+	if (local->hw.wiphy->interface_modes & NL80211_IFTYPE_STATION) {
+		result = ieee80211_if_add(local, "wlan%d", NULL,
+					  NL80211_IFTYPE_STATION, NULL);
+		if (result)
+			printk(KERN_WARNING "%s: Failed to add default virtual iface\n",
+			       wiphy_name(local->hw.wiphy));
+	}
 
 	rtnl_unlock();
 


