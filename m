Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62995 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab2E1LTo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 07:19:44 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 13/14] cfg80211: extend combination checking to consider channels
Date: Mon, 28 May 2012 13:19:01 +0200
Message-ID: <1338203942-5667-14-git-send-email-michal.kazior@tieto.com> (sfid-20120528_131951_352327_F7619775)
In-Reply-To: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_can_change_interface will soon be used
before .start_ap, .join_mesh, .join_ibss and .auth to
verify whether a given interface combination is
allowed.

.connect cannot be handled since the driver scans
and connects on its own. It is up to the driver
then to refuse a connection (with -EBUSY for
example).

Change-Id: I334c78aa9189f24fcf8829b98b7703ddde120eec
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/core.c |    2 +-
 net/wireless/core.h |    8 +++++---
 net/wireless/util.c |   46 ++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index d0caca8..67dbbbb 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1007,7 +1007,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		if (rfkill_blocked(rdev->rfkill))
 			return notifier_from_errno(-ERFKILL);
 		mutex_lock(&rdev->devlist_mtx);
-		ret = cfg80211_can_add_interface(rdev, wdev->iftype);
+		ret = cfg80211_can_add_interface(rdev, wdev->iftype, NULL);
 		mutex_unlock(&rdev->devlist_mtx);
 		if (ret)
 			return notifier_from_errno(ret);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 2dd7508..26f6625 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -448,13 +448,15 @@ void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev);
 
 int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 				  struct wireless_dev *wdev,
-				  enum nl80211_iftype iftype);
+				  enum nl80211_iftype iftype,
+				  struct ieee80211_channel *chan);
 
 static inline int
 cfg80211_can_add_interface(struct cfg80211_registered_device *rdev,
-			   enum nl80211_iftype iftype)
+			   enum nl80211_iftype iftype,
+			   struct ieee80211_channel *chan)
 {
-	return cfg80211_can_change_interface(rdev, NULL, iftype);
+	return cfg80211_can_change_interface(rdev, NULL, iftype, chan);
 }
 
 struct ieee80211_channel *
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 9449a60..59c06bb 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -808,7 +808,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	if (ntype != otype && netif_running(dev)) {
 		mutex_lock(&rdev->devlist_mtx);
 		err = cfg80211_can_change_interface(rdev, dev->ieee80211_ptr,
-						    ntype);
+						    ntype, NULL);
 		mutex_unlock(&rdev->devlist_mtx);
 		if (err)
 			return err;
@@ -938,10 +938,14 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 
 int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 				  struct wireless_dev *wdev,
-				  enum nl80211_iftype iftype)
+				  enum nl80211_iftype iftype,
+				  struct ieee80211_channel *chan)
 {
 	struct wireless_dev *wdev_iter;
 	int num[NUM_NL80211_IFTYPES];
+	struct ieee80211_channel **used_channels;
+	int num_different_channels = 0;
+	int num_max_channels = 0;
 	int total = 1;
 	int i, j;
 
@@ -952,6 +956,20 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 	if (rdev->wiphy.software_iftypes & BIT(iftype))
 		return 0;
 
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		if (!rdev->wiphy.bands[i])
+			continue;
+
+		num_max_channels += rdev->wiphy.bands[i]->n_channels;
+	}
+	if (!num_max_channels)
+		return -EINVAL;
+
+	used_channels = kzalloc(num_max_channels * sizeof(*used_channels),
+				GFP_KERNEL);
+	if (!used_channels)
+		return -ENOMEM;
+
 	memset(num, 0, sizeof(num));
 
 	num[iftype] = 1;
@@ -965,9 +983,26 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 		if (rdev->wiphy.software_iftypes & BIT(wdev_iter->iftype))
 			continue;
 
+		for (i = 0; i < num_max_channels; i++) {
+			if (!used_channels[i]) {
+				used_channels[i] = chan;
+				num_different_channels++;
+				break;
+			}
+			else if (used_channels[i] == chan) {
+				break;
+			}
+		}
+
+		if (i == num_max_channels) {
+			kfree(used_channels);
+			return -ENOMEM;
+		}
+
 		num[wdev_iter->iftype]++;
 		total++;
 	}
+	kfree(used_channels);
 
 	if (total == 1 && rdev->wiphy.n_iface_combinations == 0)
 		return 0;
@@ -978,12 +1013,15 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 
 		c = &rdev->wiphy.iface_combinations[i];
 
+		if (total > c->max_interfaces)
+			continue;
+		if (num_different_channels > c->num_different_channels)
+			continue;
+
 		limits = kmemdup(c->limits, sizeof(limits[0]) * c->n_limits,
 				 GFP_KERNEL);
 		if (!limits)
 			return -ENOMEM;
-		if (total > c->max_interfaces)
-			goto cont;
 
 		for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
 			if (rdev->wiphy.software_iftypes & BIT(iftype))
-- 
1.7.0.4

