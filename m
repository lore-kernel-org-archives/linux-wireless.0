Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:40995 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab0AQVpo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 16:45:44 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH 1/2] mac80211: removed useless code in IBSS management
Date: Sun, 17 Jan 2010 22:45:23 +0100
Message-Id: <1263764724-14660-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee82011_sta_find_ibss() and ieee80211_sta_merge_ibss() are always
called with a defined state. So it's useless to check it or set it in
those function.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/ibss.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index b7f58c8..e0019f9 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -516,6 +516,9 @@ static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
 	return active;
 }
 
+/*
+ * This function is called with state == IEEE80211_IBSS_MLME_JOINED
+ */
 
 static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 {
@@ -581,6 +584,10 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 				  capability, 0);
 }
 
+/*
+ * This function is called with state == IEEE80211_IBSS_MLME_SEARCH
+ */
+
 static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
@@ -637,18 +644,14 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 
 	/* Selected IBSS not found in current scan results - try to scan */
-	if (ifibss->state == IEEE80211_IBSS_MLME_JOINED &&
-	    !ieee80211_sta_active_ibss(sdata)) {
-		mod_timer(&ifibss->timer,
-			  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
-	} else if (time_after(jiffies, ifibss->last_scan_completed +
+	if (time_after(jiffies, ifibss->last_scan_completed +
 					IEEE80211_SCAN_INTERVAL)) {
 		printk(KERN_DEBUG "%s: Trigger new scan to find an IBSS to "
 		       "join\n", sdata->name);
 
 		ieee80211_request_internal_scan(sdata, ifibss->ssid,
 						ifibss->ssid_len);
-	} else if (ifibss->state != IEEE80211_IBSS_MLME_JOINED) {
+	} else {
 		int interval = IEEE80211_SCAN_INTERVAL;
 
 		if (time_after(jiffies, ifibss->ibss_join_req +
@@ -666,7 +669,6 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 			interval = IEEE80211_SCAN_INTERVAL_SLOW;
 		}
 
-		ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
 		mod_timer(&ifibss->timer,
 			  round_jiffies(jiffies + interval));
 	}
-- 
1.6.3.3

