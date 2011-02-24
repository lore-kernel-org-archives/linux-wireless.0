Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52275 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab1BXNqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 08:46:15 -0500
Subject: [PATCH] mac80211: remove IBSS merge delay
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 14:46:13 +0100
Message-ID: <1298555173.4775.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This reverts 4a332a38
("mac80211: Give it some time to do the TSF sync").

There's no point in waiting with a new IBSS merge
just because the hardware hasn't merged up with
the old IBSS yet, and since 34e8f082 we no longer
attempt to merge with the IBSS we're already in.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c |    5 -----
 1 file changed, 5 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2011-02-24 12:49:33.000000000 +0100
+++ wireless-testing/net/mac80211/ibss.c	2011-02-24 12:49:46.000000000 +0100
@@ -31,7 +31,6 @@
 #define IEEE80211_IBSS_JOIN_TIMEOUT (7 * HZ)
 
 #define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
-#define IEEE80211_IBSS_MERGE_DELAY 0x400000
 #define IEEE80211_IBSS_INACTIVITY_LIMIT (60 * HZ)
 
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
@@ -397,10 +396,6 @@ static void ieee80211_rx_bss_info(struct
 	       jiffies);
 #endif
 
-	/* give slow hardware some time to do the TSF sync */
-	if (rx_timestamp < IEEE80211_IBSS_MERGE_DELAY)
-		goto put_bss;
-
 	if (beacon_timestamp > rx_timestamp) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 		printk(KERN_DEBUG "%s: beacon TSF higher than "


