Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:36331 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbbC3NIi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 09:08:38 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] cfg80211: Allow GO concurrent relaxation after BSS disconnetion
Date: Mon, 30 Mar 2015 16:08:25 +0300
Message-Id: <1427720905-30872-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150330_150842_887136_7378BDC6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

If P2P GO was allowed on a channel because of the GO concurrent
relaxation and additional station interface associated to an AP on
the same channel or the same UNII band, and the station interface
disconnected from the AP, allow the P2P GO to stay on that channel
unless the channel is marked as indoor only and the device is not
operating in an indoor environment.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/chan.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 7aaf741..fc3ec42 100644
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
+		    netif_running(wdev->netdev) && wdev->current_bss)
+			other_chan = wdev->current_bss->pub.channel;
+
+		/*
+		 * If a GO already operates on the same GO_CONCURRENT channel,
+		 * this one (maybe the same one) can beacon as well. We allow
+		 * the operation even if the station we relied on with
+		 * GO_CONCURRENT is disconnected now. But then we must make sure
+		 * we're not outdoor on an indoor-only channel.
+		 */
+		if (wdev->iftype == NL80211_IFTYPE_P2P_GO && wdev->netdev &&
+		    netif_running(wdev->netdev) && wdev->beacon_interval &&
+		    !(chan->flags & IEEE80211_CHAN_INDOOR_ONLY))
+			other_chan = wdev->chandef.chan;
+		wdev_unlock(wdev);
 
 		if (!other_chan)
 			continue;
-- 
1.9.1

