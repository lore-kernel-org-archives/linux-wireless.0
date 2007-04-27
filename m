Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4697 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425AbXD0C1P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 22:27:15 -0400
Date: Thu, 26 Apr 2007 21:47:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: fix locking in wiphy_new
Message-ID: <20070427014744.GE25332@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

This patch fixes the locking in wiphy new. Ingo Oeser <netdev@axxeo.de>
noticed that locking in the error case was wrong and also suggested this
fix.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/core.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 532e1e0..24a21ad 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -53,21 +53,25 @@ struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
 
 	mutex_lock(&cfg80211_drv_mutex);
 
-	if (unlikely(wiphy_counter<0)) {
+	drv->idx = wiphy_counter;
+
+	/* now increase counter for the next device unless
+	 * it has wrapped previously */
+	if (wiphy_counter >= 0)
+		wiphy_counter++;
+
+	mutex_unlock(&cfg80211_drv_mutex);
+
+	if (unlikely(drv->idx < 0)) {
 		/* ugh, wrapped! */
 		kfree(drv);
 		return NULL;
 	}
-	drv->idx = wiphy_counter;
 
 	/* give it a proper name */
 	snprintf(drv->wiphy.dev.bus_id, BUS_ID_SIZE,
 		 PHY_NAME "%d", drv->idx);
 
-	/* now increase counter for the next time */
-	wiphy_counter++;
-	mutex_unlock(&cfg80211_drv_mutex);
-
 	mutex_init(&drv->mtx);
 	mutex_init(&drv->devlist_mtx);
 	INIT_LIST_HEAD(&drv->netdev_list);
-- 
1.5.0.6

-- 
John W. Linville
linville@tuxdriver.com
