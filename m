Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:51414 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab0GWC3j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 22:29:39 -0400
Subject: [PATCH v2] cfg80211: fix race between sysfs and cfg80211
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1279394982.3931.0.camel@jlt3.sipsolutions.net>
References: <1279336415.1941.6.camel@kero>
	 <1279394982.3931.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Fri, 23 Jul 2010 04:29:30 +0200
Message-ID: <1279852170.14136.0.camel@sakura.staff.proxad.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maxime Bizon <mbizon@freebox.fr>

device_add() is called before adding the phy to the cfg80211 device
list.

So if a userspace program uses sysfs uevents to detect new phy
devices, and queries nl80211 to get phy info, it can get ENODEV even
though the phy exists in sysfs.

An easy workaround is to hold the cfg80211 mutex until the phy is
present in sysfs/cfg80211/debugfs.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
---
 net/wireless/core.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 6ac70c1..fd164db 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -472,24 +472,22 @@ int wiphy_register(struct wiphy *wiphy)
 	/* check and set up bitrates */
 	ieee80211_set_bitrate_flags(wiphy);
 
+	mutex_lock(&cfg80211_mutex);
+
 	res = device_add(&rdev->wiphy.dev);
 	if (res)
-		return res;
+		goto out_unlock;
 
 	res = rfkill_register(rdev->rfkill);
 	if (res)
 		goto out_rm_dev;
 
-	mutex_lock(&cfg80211_mutex);
-
 	/* set up regulatory info */
 	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
 
 	list_add_rcu(&rdev->list, &cfg80211_rdev_list);
 	cfg80211_rdev_list_generation++;
 
-	mutex_unlock(&cfg80211_mutex);
-
 	/* add to debugfs */
 	rdev->wiphy.debugfsdir =
 		debugfs_create_dir(wiphy_name(&rdev->wiphy),
@@ -509,11 +507,15 @@ int wiphy_register(struct wiphy *wiphy)
 	}
 
 	cfg80211_debugfs_rdev_add(rdev);
+	mutex_unlock(&cfg80211_mutex);
 
 	return 0;
 
- out_rm_dev:
+out_rm_dev:
 	device_del(&rdev->wiphy.dev);
+
+out_unlock:
+	mutex_unlock(&cfg80211_mutex);
 	return res;
 }
 EXPORT_SYMBOL(wiphy_register);
-- 
1.7.1



-- 
Maxime



