Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4357 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbZG2Vcs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 17:32:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] mac80211: use beacons for connection monitoring
Date: Wed, 29 Jul 2009 14:32:39 -0700
Message-Id: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

The connection monitor currently relies on probe requests paired
with probe responses to ensure that a connection is alive. This is
fragile in some environments where probe responses can get lost.
When we receive beacons we can also consider the connection to be
alive, so cancel connection poll instance when we receive a beacon.

The debug message "cancelling probereq poll due to a received beacon"
is removed as part of this change as this case is hit very often after
the above change and debug log receives significant number of these messages.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 net/mac80211/mlme.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e3b3156..9cf6153 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1743,14 +1743,10 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	if (memcmp(bssid, mgmt->bssid, ETH_ALEN) != 0)
 		return;
 
-	if (ifmgd->flags & IEEE80211_STA_BEACON_POLL) {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-		if (net_ratelimit()) {
-			printk(KERN_DEBUG "%s: cancelling probereq poll due "
-			       "to a received beacon\n", sdata->dev->name);
-		}
-#endif
-		ifmgd->flags &= ~IEEE80211_STA_BEACON_POLL;
+	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
+			    IEEE80211_STA_CONNECTION_POLL)) {
+		ifmgd->flags &= ~(IEEE80211_STA_BEACON_POLL |
+				  IEEE80211_STA_CONNECTION_POLL);
 		mutex_lock(&local->iflist_mtx);
 		ieee80211_recalc_ps(local, -1);
 		mutex_unlock(&local->iflist_mtx);
-- 
1.5.6.3

