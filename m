Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:57564 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbeAPWUZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 17:20:25 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fix station info handling bugs
Date: Tue, 16 Jan 2018 23:20:22 +0100
Message-Id: <20180116222022.13161-1-johannes@sipsolutions.net> (sfid-20180116_232033_038691_92E953EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Fix two places where the structure isn't initialized to zero,
and thus can't be filled properly by the driver.

Fixes: 4a4b8169501b ("cfg80211: Accept multiple RSSI thresholds for CQM")
Fixes: 9930380f0bd8 ("cfg80211: implement IWRATE")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Dave, can you apply this as an exception? I'm not really expecting
any other patches to show up now, and seems easier to have a single
patch than a whole pull request (especially now that patchwork seems
to be swallowing mine ...)
---
 net/wireless/nl80211.c     | 2 +-
 net/wireless/wext-compat.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c084dd2205ac..91e55bb85416 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9832,7 +9832,7 @@ static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
 	 */
 	if (!wdev->cqm_config->last_rssi_event_value && wdev->current_bss &&
 	    rdev->ops->get_station) {
-		struct station_info sinfo;
+		struct station_info sinfo = {};
 		u8 *mac_addr;
 
 		mac_addr = wdev->current_bss->pub.bssid;
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 7ca04a7de85a..05186a47878f 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1254,8 +1254,7 @@ static int cfg80211_wext_giwrate(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
-	/* we are under RTNL - globally locked - so can use a static struct */
-	static struct station_info sinfo;
+	struct station_info sinfo = {};
 	u8 addr[ETH_ALEN];
 	int err;
 
-- 
2.15.1
