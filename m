Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:23299 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161492AbXDWS6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 14:58:20 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 08/13] mac80211: misc cleanups in ieee80211_sta.c
Date: Mon, 23 Apr 2007 14:48:14 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070423184813.7029.55687.stgit@magic.sourmilk.net>
In-Reply-To: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This eliminates some unnecessary code in ieee80211_sta.c.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211_sta.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 04a63a7..fe5c762 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1926,7 +1926,6 @@ void ieee80211_sta_work(struct work_struct *work)
 	if (local->sta_scanning)
 		return;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->type != IEEE80211_IF_TYPE_STA &&
 	    sdata->type != IEEE80211_IF_TYPE_IBSS) {
 		printk(KERN_DEBUG "%s: ieee80211_sta_work: non-STA interface "
@@ -2121,7 +2120,7 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 		return 0;
 	} else {
 		if (ifsta->state != IEEE80211_AUTHENTICATE) {
-			ieee80211_sta_start_scan(dev, NULL, 0);;
+			ieee80211_sta_start_scan(dev, NULL, 0);
 			ifsta->state = IEEE80211_AUTHENTICATE;
 			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
 		} else

