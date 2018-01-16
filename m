Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:57456 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbeAPWLD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 17:11:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: wext: don't use static struct
Date: Tue, 16 Jan 2018 23:11:00 +0100
Message-Id: <20180116221100.10079-1-johannes@sipsolutions.net> (sfid-20180116_231106_067303_D6DC246D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no point in persistently allocating memory for these,
they're small enough to live on the stack.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/wext-compat.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 05186a47878f..c2b3d5ac0554 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1291,9 +1291,8 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
-	/* we are under RTNL - globally locked - so can use static structs */
-	static struct iw_statistics wstats;
-	static struct station_info sinfo;
+	struct iw_statistics wstats = {};
+	struct station_info sinfo = {};
 	u8 bssid[ETH_ALEN];
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION)
@@ -1311,13 +1310,9 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 	memcpy(bssid, wdev->current_bss->pub.bssid, ETH_ALEN);
 	wdev_unlock(wdev);
 
-	memset(&sinfo, 0, sizeof(sinfo));
-
 	if (rdev_get_station(rdev, dev, bssid, &sinfo))
 		return NULL;
 
-	memset(&wstats, 0, sizeof(wstats));
-
 	switch (rdev->wiphy.signal_type) {
 	case CFG80211_SIGNAL_TYPE_MBM:
 		if (sinfo.filled & BIT(NL80211_STA_INFO_SIGNAL)) {
-- 
2.15.1
