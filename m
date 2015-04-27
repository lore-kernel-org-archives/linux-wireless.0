Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53375 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964835AbbD0NuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2015 09:50:18 -0400
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v3] cfg80211: Allow GO concurrent relaxation after BSS disconnection
Date: Mon, 27 Apr 2015 16:52:16 +0300
Message-Id: <1430142736-24032-1-git-send-email-ilan.peer@intel.com> (sfid-20150427_155022_871329_5457BC68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

If a P2P GO was allowed on a channel because of the GO concurrent
relaxation, i.e., another station interface was associated to an AP on
the same channel or the same UNII band, and the station interface
disconnected from the AP, allow the following use cases unless the
channel is marked as indoor only and the device is not operating in an
indoor environment:

1. Allow the P2P GO to stay on its current channel. The rationale behind
   this is that if the channel or UNII band were allowed by the AP they
   could still be used to continue the P2P GO operation, and avoid connection
   breakage.
2. Allow another P2P GO to start on the same channel or another channel
   that is in the same UNII band as the previous instantiated P2P GO.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/chan.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 7aaf741..5bcffdb 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -709,7 +709,7 @@ EXPORT_SYMBOL(cfg80211_chandef_usable);
 static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
 					struct ieee80211_channel *chan)
 {
-	struct wireless_dev *wdev_iter;
+	struct wireless_dev *wdev;
 	struct wiphy *wiphy = wiphy_idx_to_wiphy(rdev->wiphy_idx);
 
 	ASSERT_RTNL();
@@ -732,18 +732,27 @@ static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
 	 * and thus fail the GO instantiation, consider only the interfaces of
 	 * the current registered device.
 	 */
-	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
+	list_for_each_entry(wdev, &rdev->wdev_list, list) {
 		struct ieee80211_channel *other_chan = NULL;
 		int r1, r2;
 
-		if (wdev_iter->iftype != NL80211_IFTYPE_STATION ||
-		    !netif_running(wdev_iter->netdev))
-			continue;
-
-		wdev_lock(wdev_iter);
-		if (wdev_iter->current_bss)
-			other_chan = wdev_iter->current_bss->pub.channel;
-		wdev_unlock(wdev_iter);
+		wdev_lock(wdev);
+		if (wdev->iftype == NL80211_IFTYPE_STATION &&
+		    wdev->current_bss)
+			other_chan = wdev->current_bss->pub.channel;
+
+		/*
+		 * If a GO already operates on the same GO_CONCURRENT channel,
+		 * this one (maybe the same one) can beacon as well. We allow
+		 * the operation even if the station we relied on with
+		 * GO_CONCURRENT is disconnected now. But then we must make sure
+		 * we're not outdoor on an indoor-only channel.
+		 */
+		if (wdev->iftype == NL80211_IFTYPE_P2P_GO &&
+		    wdev->beacon_interval &&
+		    !(chan->flags & IEEE80211_CHAN_INDOOR_ONLY))
+			other_chan = wdev->chandef.chan;
+		wdev_unlock(wdev);
 
 		if (!other_chan)
 			continue;
-- 
1.9.1

