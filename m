Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47265 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab0IZF2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Sep 2010 01:28:50 -0400
Received: by pzk34 with SMTP id 34so945865pzk.19
        for <linux-wireless@vger.kernel.org>; Sat, 25 Sep 2010 22:28:49 -0700 (PDT)
From: greearb@gmail.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] wireless:  make phy naming independent of phy index.
Date: Sat, 25 Sep 2010 22:28:41 -0700
Message-Id: <1285478921-5891-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The recent patch that re-used phy indexes on module reload
could cause races.  Instead, increment phy-index monitomically
for each new phy, but choose the first phy%d name that is
available.

Also, allow users to rename a phy to any un-used name, including
phy%d.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 8226ba7... d55d3ad... M	net/wireless/core.c
 net/wireless/core.c |   53 +++++++++++++++++++++++++--------------------------
 1 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 8226ba7..d55d3ad 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -178,26 +178,10 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 			char *newname)
 {
 	struct cfg80211_registered_device *rdev2;
-	int wiphy_idx, taken = -1, result, digits;
+	int result;
 
 	assert_cfg80211_lock();
 
-	/* prohibit calling the thing phy%d when %d is not its number */
-	sscanf(newname, PHY_NAME "%d%n", &wiphy_idx, &taken);
-	if (taken == strlen(newname) && wiphy_idx != rdev->wiphy_idx) {
-		/* count number of places needed to print wiphy_idx */
-		digits = 1;
-		while (wiphy_idx /= 10)
-			digits++;
-		/*
-		 * deny the name if it is phy<idx> where <idx> is printed
-		 * without leading zeroes. taken == strlen(newname) here
-		 */
-		if (taken == strlen(PHY_NAME) + digits)
-			return -EINVAL;
-	}
-
-
 	/* Ignore nop renames */
 	if (strcmp(newname, dev_name(&rdev->wiphy.dev)) == 0)
 		return 0;
@@ -205,7 +189,7 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 	/* Ensure another device does not already have this name. */
 	list_for_each_entry(rdev2, &cfg80211_rdev_list, list)
 		if (strcmp(newname, dev_name(&rdev2->wiphy.dev)) == 0)
-			return -EINVAL;
+			return -EEXIST;
 
 	result = device_rename(&rdev->wiphy.dev, newname);
 	if (result)
@@ -319,9 +303,12 @@ static void cfg80211_event_work(struct work_struct *work)
 
 struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 {
+	static int wiphy_counter;
 	int i;
-	struct cfg80211_registered_device *rdev;
+	struct cfg80211_registered_device *rdev, *rdev2;
 	int alloc_size;
+	char nname[IFNAMSIZ + 1];
+	bool found = false;
 
 	WARN_ON(ops->add_key && (!ops->del_key || !ops->set_default_key));
 	WARN_ON(ops->auth && (!ops->assoc || !ops->deauth || !ops->disassoc));
@@ -341,26 +328,38 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 
 	mutex_lock(&cfg80211_mutex);
 
+	rdev->wiphy_idx = wiphy_counter++;
+
+	if (unlikely(!wiphy_idx_valid(rdev->wiphy_idx)))
+		goto too_many_devs;
+
 	/* 64k wiphy devices is enough for anyone! */
 	for (i = 0; i < 0xFFFF; i++) {
-		if (!cfg80211_rdev_by_wiphy_idx(i))
+		found = false;
+		snprintf(nname, sizeof(nname)-1, PHY_NAME "%d", i);
+		nname[sizeof(nname)-1] = 0;
+		list_for_each_entry(rdev2, &cfg80211_rdev_list, list)
+			if (strcmp(nname, dev_name(&rdev2->wiphy.dev)) == 0) {
+				found = true;
+				break;
+			}
+
+		if (!found)
 			break;
 	}
-	if (i == 0xFFFF)
-		i = -1; /* invalid */
-	rdev->wiphy_idx = i;
 
-	if (unlikely(!wiphy_idx_valid(rdev->wiphy_idx))) {
+	if (unlikely(found)) {
+too_many_devs:
 		mutex_unlock(&cfg80211_mutex);
 		/* ugh, too many devices already! */
 		kfree(rdev);
 		return NULL;
 	}
 
-	mutex_unlock(&cfg80211_mutex);
-
 	/* give it a proper name */
-	dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
+	dev_set_name(&rdev->wiphy.dev, "%s", nname);
+
+	mutex_unlock(&cfg80211_mutex);
 
 	mutex_init(&rdev->mtx);
 	mutex_init(&rdev->devlist_mtx);
-- 
1.7.2.3

