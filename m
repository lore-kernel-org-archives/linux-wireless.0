Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:51874 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161546AbXDWS6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 14:58:20 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 09/13] mac80211: remove hw_scan callback
Date: Mon, 23 Apr 2007 14:48:14 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070423184814.7029.8413.stgit@magic.sourmilk.net>
In-Reply-To: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

The hw_scan callback breaks the auto AP selection code in ieee80211_sta.c.
No in-tree drivers use it either. This patch removes it.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 include/net/mac80211.h       |    4 ----
 net/mac80211/ieee80211.c     |    3 +--
 net/mac80211/ieee80211_sta.c |   11 +----------
 3 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b4b6619..cade956 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -668,10 +668,6 @@ struct ieee80211_ops {
 	int (*passive_scan)(struct ieee80211_hw *hw, int state,
 			    struct ieee80211_scan_conf *conf);
 
-	/* Ask the hardware to service the scan request, no need to start
-	 * the scan state machine in stack. */
-	int (*hw_scan)(struct ieee80211_hw *hw, u8 *ssid, size_t len);
-
 	/* return low-level statistics */
 	int (*get_stats)(struct ieee80211_hw *hw,
 			 struct ieee80211_low_level_stats *stats);
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 25ea011..ddb8153 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2235,8 +2235,7 @@ static void ieee80211_if_shutdown(struct net_device *dev)
 		sdata->u.sta.state = IEEE80211_DISABLED;
 		del_timer_sync(&sdata->u.sta.timer);
 		skb_queue_purge(&sdata->u.sta.skb_queue);
-		if (!local->ops->hw_scan &&
-		    local->scan_dev == sdata->dev) {
+		if (local->scan_dev == sdata->dev) {
 			local->sta_scanning = 0;
 			cancel_delayed_work(&local->scan_work);
 		}
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index fe5c762..7cb2dd3 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -23,6 +23,7 @@
 #include <linux/wireless.h>
 #include <linux/random.h>
 #include <linux/etherdevice.h>
+#include <linux/rtnetlink.h>
 #include <net/iw_handler.h>
 #include <asm/types.h>
 #include <asm/delay.h>
@@ -2713,16 +2714,6 @@ static int ieee80211_sta_start_scan(struct net_device *dev,
 		return -EBUSY;
 	}
 
-	if (local->ops->hw_scan) {
-		int rc = local->ops->hw_scan(local_to_hw(local),
-					    ssid, ssid_len);
-		if (!rc) {
-			local->sta_scanning = 1;
-			local->scan_dev = dev;
-		}
-		return rc;
-	}
-
 	local->sta_scanning = 1;
 
 	read_lock(&local->sub_if_lock);

