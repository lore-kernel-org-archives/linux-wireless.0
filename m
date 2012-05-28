Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:64704 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab2E1LTn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 07:19:43 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 12/14] cfg80211: move devlist locking out of can_change_interface
Date: Mon, 28 May 2012 13:19:00 +0200
Message-ID: <1338203942-5667-13-git-send-email-michal.kazior@tieto.com> (sfid-20120528_131949_694054_BA558092)
In-Reply-To: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Soon this function will be called for .start_ap,
.join_ibss, .join_mesh and .auth which may be run
under devlist_mtx lock already.

Change-Id: Ia7502d22f15df1bbda8a1a7dee63553ee5adb22c
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/core.c |    2 ++
 net/wireless/util.c |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 1596d18..d0caca8 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1006,7 +1006,9 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			return notifier_from_errno(-EOPNOTSUPP);
 		if (rfkill_blocked(rdev->rfkill))
 			return notifier_from_errno(-ERFKILL);
+		mutex_lock(&rdev->devlist_mtx);
 		ret = cfg80211_can_add_interface(rdev, wdev->iftype);
+		mutex_unlock(&rdev->devlist_mtx);
 		if (ret)
 			return notifier_from_errno(ret);
 		cfg80211_update_iface_num(rdev, wdev, 1);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 252ba8d..9449a60 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -806,8 +806,10 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		return -EBUSY;
 
 	if (ntype != otype && netif_running(dev)) {
+		mutex_lock(&rdev->devlist_mtx);
 		err = cfg80211_can_change_interface(rdev, dev->ieee80211_ptr,
 						    ntype);
+		mutex_unlock(&rdev->devlist_mtx);
 		if (err)
 			return err;
 
@@ -944,6 +946,7 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 	int i, j;
 
 	ASSERT_RTNL();
+	lockdep_assert_held(&rdev->devlist_mtx);
 
 	/* Always allow software iftypes */
 	if (rdev->wiphy.software_iftypes & BIT(iftype))
@@ -953,7 +956,6 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 
 	num[iftype] = 1;
 
-	mutex_lock(&rdev->devlist_mtx);
 	list_for_each_entry(wdev_iter, &rdev->netdev_list, list) {
 		if (wdev_iter == wdev)
 			continue;
@@ -966,7 +968,6 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 		num[wdev_iter->iftype]++;
 		total++;
 	}
-	mutex_unlock(&rdev->devlist_mtx);
 
 	if (total == 1 && rdev->wiphy.n_iface_combinations == 0)
 		return 0;
-- 
1.7.0.4

