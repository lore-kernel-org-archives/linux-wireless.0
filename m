Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:9509 "EHLO annwn14.rutgers.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161558AbXDWS6U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 14:58:20 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 13/13] mac80211: stop all virtual interfaces when master device goes down
Date: Mon, 23 Apr 2007 14:48:15 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070423184814.7029.35852.stgit@magic.sourmilk.net>
In-Reply-To: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

The master device cannot actually veto taking a device down. This patch
makes all virtual devices go down if the master device goes down.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index e876e04..6002f2d 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2293,13 +2293,11 @@ static int ieee80211_master_stop(struct net_device *dev)
 	struct ieee80211_sub_if_data *sdata;
 
 	read_lock(&local->sub_if_lock);
-	list_for_each_entry(sdata, &local->sub_if_list, list) {
-		if (sdata->dev != dev && netif_running(sdata->dev)) {
-			read_unlock(&local->sub_if_lock);
-			return -EOPNOTSUPP;
-		}
-	}
+	list_for_each_entry(sdata, &local->sub_if_list, list)
+		if (sdata->dev != dev && netif_running(sdata->dev))
+			dev_close(sdata->dev);
 	read_unlock(&local->sub_if_lock);
+
 	return 0;
 }
 
@@ -2475,7 +2473,8 @@ static int ieee80211_stop(struct net_device *dev)
 	local->open_count--;
 	if (local->open_count == 0) {
 		ieee80211_stop_scan(local);
-		dev_close(local->mdev);
+		if (netif_running(local->mdev))
+			dev_close(local->mdev);
 		if (local->apdev)
 			dev_close(local->apdev);
 		if (local->ops->stop)

