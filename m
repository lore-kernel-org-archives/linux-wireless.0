Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:52898 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaL2KAD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 05:00:03 -0500
Received: by mail-wg0-f54.google.com with SMTP id z12so677814wgg.13
        for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2014 02:00:01 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] cfg80211: fix deadlock during reg chan check
Date: Mon, 29 Dec 2014 11:59:59 +0200
Message-Id: <1419847199-25493-1-git-send-email-arik@wizery.com> (sfid-20141229_110007_781494_D8405C8A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a P2P GO is active, the cfg80211_reg_can_beacon function will take
the wdev lock, in its call to cfg80211_go_permissive_chan. But the wdev lock
is already taken by the parent channel-checking function, causing a
deadlock.
Split the checking code into two parts. The first part will check if the
wdev is active and saves the channel under the wdev lock. The second part
will check actual channel validity according to type.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
Requires the patch "cfg80211: correctly check ad-hoc channels" to be applied
first.

 net/wireless/reg.c | 56 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 978a5fd..fde4e17 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1533,45 +1533,40 @@ static void reg_call_notifier(struct wiphy *wiphy,
 
 static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
-	struct ieee80211_channel *ch;
 	struct cfg80211_chan_def chandef;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
-	bool ret = true;
+	enum nl80211_iftype iftype;
 
 	wdev_lock(wdev);
+	iftype = wdev->iftype;
 
+	/* make sure the interface is active */
 	if (!wdev->netdev || !netif_running(wdev->netdev))
-		goto out;
+		goto wdev_inactive_unlock;
 
-	switch (wdev->iftype) {
+	switch (iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
 		if (!wdev->beacon_interval)
-			goto out;
-
-		ret = cfg80211_reg_can_beacon(wiphy,
-					      &wdev->chandef, wdev->iftype);
+			goto wdev_inactive_unlock;
+		chandef = wdev->chandef;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		if (!wdev->ssid_len)
-			goto out;
-
-		ret = cfg80211_reg_can_beacon(wiphy,
-					      &wdev->chandef, wdev->iftype);
+			goto wdev_inactive_unlock;
+		chandef = wdev->chandef;
 		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
 		if (!wdev->current_bss ||
 		    !wdev->current_bss->pub.channel)
-			goto out;
+			goto wdev_inactive_unlock;
 
-		ch = wdev->current_bss->pub.channel;
-		if (rdev->ops->get_channel &&
-		    !rdev_get_channel(rdev, wdev, &chandef))
-			ret = cfg80211_chandef_usable(wiphy, &chandef,
-						      IEEE80211_CHAN_DISABLED);
-		else
-			ret = !(ch->flags & IEEE80211_CHAN_DISABLED);
+		if (!rdev->ops->get_channel ||
+		    rdev_get_channel(rdev, wdev, &chandef))
+			cfg80211_chandef_create(&chandef,
+						wdev->current_bss->pub.channel,
+						NL80211_CHAN_NO_HT);
 		break;
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_AP_VLAN:
@@ -1584,9 +1579,26 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 		break;
 	}
 
-out:
 	wdev_unlock(wdev);
-	return ret;
+
+	switch (iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_ADHOC:
+		return cfg80211_reg_can_beacon(wiphy, &chandef, iftype);
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		return cfg80211_chandef_usable(wiphy, &chandef,
+					       IEEE80211_CHAN_DISABLED);
+	default:
+		break;
+	}
+
+	return true;
+
+wdev_inactive_unlock:
+	wdev_unlock(wdev);
+	return true;
 }
 
 static void reg_leave_invalid_chans(struct wiphy *wiphy)
-- 
2.1.0

