Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48993 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933934AbXCWUn3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:29 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/19] mac80211: fix rtnl locking in ieee80211_register_hw
Message-Id: <20070323204445.517D6484A1@silver.suse.cz>
Date: Fri, 23 Mar 2007 21:44:45 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtnl locking in ieee80211_register_hw was racy. This patch fixes that.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/mac80211/ieee80211.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

9d0a7f4ed6daf144111954e2ecd70df78e7449d9
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index e7576c5..9d95250 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4666,18 +4666,13 @@ int ieee80211_register_hw(struct ieee802
 	SET_NETDEV_DEV(local->mdev, wiphy_dev(local->hw.wiphy));
 
 	result = register_netdevice(local->mdev);
-	if (result < 0) {
-		rtnl_unlock();
+	if (result < 0)
 		goto fail_dev;
-	}
 	result = ieee80211_sysfs_add_netdevice(local->mdev);
-	if (result < 0) {
-		rtnl_unlock();
+	if (result < 0)
 		goto fail_if_sysfs;
-	}
 
 	result = ieee80211_init_rate_ctrl_alg(local, NULL);
-	rtnl_unlock();
 	if (result < 0) {
 		printk(KERN_DEBUG "%s: Failed to initialize rate control "
 		       "algorithm\n", local->mdev->name);
@@ -4696,7 +4691,6 @@ int ieee80211_register_hw(struct ieee802
 	ieee80211_install_qdisc(local->mdev);
 
 	/* add one default STA interface */
-	rtnl_lock();
 	result = ieee80211_if_add(local->mdev, "wlan%d", 1, &sta_dev);
 	if (result == 0)
 		ieee80211_if_set_type(sta_dev, IEEE80211_IF_TYPE_STA);
@@ -4713,8 +4707,9 @@ fail_wep:
 fail_rate:
 	ieee80211_sysfs_remove_netdevice(local->mdev);
 fail_if_sysfs:
-	unregister_netdev(local->mdev);
+	unregister_netdevice(local->mdev);
 fail_dev:
+	rtnl_unlock();
 	sta_info_stop(local);
 fail_sta_info:
 	ieee80211_dev_sysfs_del(local);
-- 
1.3.0

