Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:56721 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933262Ab0I0QHi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 12:07:38 -0400
Received: by pxi10 with SMTP id 10so1448893pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 09:07:37 -0700 (PDT)
From: greearb@gmail.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] wireless: Use first phyX name available when registering phy devices.
Date: Mon, 27 Sep 2010 09:07:26 -0700
Message-Id: <1285603646-7710-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1285603646-7710-1-git-send-email-greearb@candelatech.com>
References: <1285603646-7710-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Choose first available phyX name when creating phy devices.  This
means that reloading a wifi driver will not cause a change in the
name of it's phy device.

Also, allow users to rename a phy to any un-used name, including
phy%d.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 9c21ebf... 1684ad9... M	net/wireless/core.c
 net/wireless/core.c |   54 ++++++++++++++++++++++++++++----------------------
 1 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 9c21ebf..1684ad9 100644
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
@@ -320,9 +304,11 @@ static void cfg80211_event_work(struct work_struct *work)
 struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 {
 	static int wiphy_counter;
-
-	struct cfg80211_registered_device *rdev;
+	int i;
+	struct cfg80211_registered_device *rdev, *rdev2;
 	int alloc_size;
+	char nname[IFNAMSIZ + 1];
+	bool found = false;
 
 	WARN_ON(ops->add_key && (!ops->del_key || !ops->set_default_key));
 	WARN_ON(ops->auth && (!ops->assoc || !ops->deauth || !ops->disassoc));
@@ -346,16 +332,36 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 
 	if (unlikely(!wiphy_idx_valid(rdev->wiphy_idx))) {
 		wiphy_counter--;
+		goto too_many_devs;
+	}
+
+	/* 64k wiphy devices is enough for anyone! */
+	for (i = 0; i < 0xFFFF; i++) {
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
+			break;
+	}
+
+	if (unlikely(found)) {
+too_many_devs:
 		mutex_unlock(&cfg80211_mutex);
-		/* ugh, wrapped! */
+		/* ugh, too many devices already! */
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

