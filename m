Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54796 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965480AbXDLI32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2007 04:29:28 -0400
Subject: [PATCH] mac80211: kill useless scan printks
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>
Content-Type: text/plain
Date: Thu, 12 Apr 2007 02:56:39 +0200
Message-Id: <1176339399.3579.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the "starting scan" and "scan completed"
messages that mac80211 prints all the time.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
We should probably remove more but I find these most annoying. You ought
to know when you start a scan, and you get an iwevent when it
finishes...

 net/mac80211/ieee80211_sta.c |    3 ---
 1 file changed, 3 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-04-11 18:00:23.469481358 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-04-11 18:02:02.829481358 +0200
@@ -2558,7 +2558,6 @@ void ieee80211_scan_completed(struct iee
 	struct ieee80211_sub_if_data *sdata;
 	union iwreq_data wrqu;
 
-	printk(KERN_DEBUG "%s: scan completed\n", dev->name);
 	local->last_scan_completed = jiffies;
 	wmb();
 	local->sta_scanning = 0;
@@ -2703,8 +2702,6 @@ static int ieee80211_sta_start_scan(stru
 		return -EBUSY;
 	}
 
-	printk(KERN_DEBUG "%s: starting scan\n", dev->name);
-
 	if (local->ops->hw_scan) {
 		int rc = local->ops->hw_scan(local_to_hw(local),
 					    ssid, ssid_len);


