Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880AbZDTWb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 18:31:28 -0400
Subject: [PATCH] mac80211: fix IBSS code to not sleep while atomic
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 00:30:49 +0200
Message-Id: <1240266649.17388.0.camel@johannes.local> (sfid-20090421_003131_880974_3EA96291)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the RCU locking here we sleep while in an atomic context,
since we can sleep just use mutex locking for the interface
list instead of RCU. Sorry, seems I didn't get that in my UML
test.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ibss.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2009-04-21 00:28:44.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-04-21 00:28:45.000000000 +0200
@@ -784,14 +784,14 @@ void ieee80211_ibss_notify_scan_complete
 {
 	struct ieee80211_sub_if_data *sdata;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			continue;
 		sdata->u.ibss.last_scan_completed = jiffies;
 		ieee80211_sta_find_ibss(sdata);
 	}
-	rcu_read_unlock();
+	mutex_unlock(&local->iflist_mtx);
 }
 
 ieee80211_rx_result


