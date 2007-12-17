Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbXLQRrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 12:47:09 -0500
Subject: [PATCH] mac80211: round station cleanup timer
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 15:07:43 +0100
Message-Id: <1197900463.4885.43.camel@johannes.berg> (sfid-20071217_174713_185527_2654961B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The station cleanup timer runs every ten seconds, the exact
timing is not relevant at all so it can well run together with
other things to save power.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/sta_info.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/sta_info.c	2007-12-17 15:03:29.003635524 +0100
+++ everything/net/mac80211/sta_info.c	2007-12-17 15:07:01.303633192 +0100
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/skbuff.h>
 #include <linux/if_arp.h>
+#include <linux/timer.h>
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
@@ -312,7 +313,8 @@ static void sta_info_cleanup(unsigned lo
 	}
 	read_unlock_bh(&local->sta_lock);
 
-	local->sta_cleanup.expires = jiffies + STA_INFO_CLEANUP_INTERVAL;
+	local->sta_cleanup.expires =
+		round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL);
 	add_timer(&local->sta_cleanup);
 }
 
@@ -351,7 +353,8 @@ void sta_info_init(struct ieee80211_loca
 	INIT_LIST_HEAD(&local->sta_list);
 
 	init_timer(&local->sta_cleanup);
-	local->sta_cleanup.expires = jiffies + STA_INFO_CLEANUP_INTERVAL;
+	local->sta_cleanup.expires =
+		round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL);
 	local->sta_cleanup.data = (unsigned long) local;
 	local->sta_cleanup.function = sta_info_cleanup;
 


