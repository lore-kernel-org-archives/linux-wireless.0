Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbYLKIbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 03:31:20 -0500
Subject: [PATCH] mac80211: fix ifmodes check
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 11 Dec 2008 09:30:46 +0100
Message-Id: <1228984246.15837.80.camel@johannes.berg> (sfid-20081211_093124_063419_48A3EA75)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In "mac80211: only create default STA interface if supported",
I tried to make sure a driver supported STA mode before adding
the default virtual interface. That had a stupid bug though
which Larry found: I didn't use BIT().

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 net/mac80211/main.c |    2 +-
 1 filechanged, 1 insertion(+), 1 deletion(-)
	 
--- everything.orig/net/mac80211/main.c	2008-12-11 09:27:30.000000000 +0100
+++ everything/net/mac80211/main.c	2008-12-11 09:27:39.000000000 +0100
@@ -887,7 +887,7 @@ int ieee80211_register_hw(struct ieee802
 	local->mdev->select_queue = ieee80211_select_queue;
 
 	/* add one default STA interface if supported */
-	if (local->hw.wiphy->interface_modes & NL80211_IFTYPE_STATION) {
+	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION)) {
 		result = ieee80211_if_add(local, "wlan%d", NULL,
 					  NL80211_IFTYPE_STATION, NULL);
 		if (result)


