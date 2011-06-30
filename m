Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:50877 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315Ab1F3Fcw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 01:32:52 -0400
Received: by mail-bw0-f42.google.com with SMTP id 19so1781723bwa.29
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 22:32:51 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	duaneg@dghda.com
Subject: [PATCH 3.0] cfg80211: fix deadlock with rfkill/sched_scan by adding new mutex
Date: Thu, 30 Jun 2011 08:32:41 +0300
Message-Id: <1309411961-3267-1-git-send-email-coelho@ti.com> (sfid-20110630_073255_804505_12928FE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was a deadlock when rfkill-blocking a wireless interface,
because we were locking the rdev mutex on NETDEV_GOING_DOWN to stop
sched_scans that were eventually running.  The rfkill block code was
already holding a mutex under rdev:

kernel: =======================================================
kernel: [ INFO: possible circular locking dependency detected ]
kernel: 3.0.0-rc1-00049-g1fa7b6a #57
kernel: -------------------------------------------------------
kernel: kworker/0:1/4525 is trying to acquire lock:
kernel: (&rdev->mtx){+.+.+.}, at: [<ffffffff8164c831>] cfg80211_netdev_notifier_call+0x131/0x5b0
kernel:
kernel: but task is already holding lock:
kernel: (&rdev->devlist_mtx){+.+.+.}, at: [<ffffffff8164dcef>] cfg80211_rfkill_set_block+0x4f/0xa0
kernel:
kernel: which lock already depends on the new lock.

To fix this, add a new mutex specifically for sched_scan, to protect
the sched_scan_req element in the rdev struct, instead of using the
global rdev mutex.

Reported-by: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 net/wireless/core.c    |   12 +++++++++---
 net/wireless/core.h    |    2 ++
 net/wireless/nl80211.c |   24 ++++++++++++++++++------
 net/wireless/scan.c    |   10 +++++-----
 4 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index c22ef34..880dbe2 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -366,6 +366,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 
 	mutex_init(&rdev->mtx);
 	mutex_init(&rdev->devlist_mtx);
+	mutex_init(&rdev->sched_scan_mtx);
 	INIT_LIST_HEAD(&rdev->netdev_list);
 	spin_lock_init(&rdev->bss_lock);
 	INIT_LIST_HEAD(&rdev->bss_list);
@@ -701,6 +702,7 @@ void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
 	rfkill_destroy(rdev->rfkill);
 	mutex_destroy(&rdev->mtx);
 	mutex_destroy(&rdev->devlist_mtx);
+	mutex_destroy(&rdev->sched_scan_mtx);
 	list_for_each_entry_safe(scan, tmp, &rdev->bss_list, list)
 		cfg80211_put_bss(&scan->pub);
 	cfg80211_rdev_free_wowlan(rdev);
@@ -737,12 +739,16 @@ static void wdev_cleanup_work(struct work_struct *work)
 		___cfg80211_scan_done(rdev, true);
 	}
 
+	cfg80211_unlock_rdev(rdev);
+
+	mutex_lock(&rdev->sched_scan_mtx);
+
 	if (WARN_ON(rdev->sched_scan_req &&
 		    rdev->sched_scan_req->dev == wdev->netdev)) {
 		__cfg80211_stop_sched_scan(rdev, false);
 	}
 
-	cfg80211_unlock_rdev(rdev);
+	mutex_unlock(&rdev->sched_scan_mtx);
 
 	mutex_lock(&rdev->devlist_mtx);
 	rdev->opencount--;
@@ -830,9 +836,9 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
 			break;
 		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_STATION:
-			cfg80211_lock_rdev(rdev);
+			mutex_lock(&rdev->sched_scan_mtx);
 			__cfg80211_stop_sched_scan(rdev, false);
-			cfg80211_unlock_rdev(rdev);
+			mutex_unlock(&rdev->sched_scan_mtx);
 
 			wdev_lock(wdev);
 #ifdef CONFIG_CFG80211_WEXT
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3dce1f1..a570ff9 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -65,6 +65,8 @@ struct cfg80211_registered_device {
 	struct work_struct scan_done_wk;
 	struct work_struct sched_scan_results_wk;
 
+	struct mutex sched_scan_mtx;
+
 #ifdef CONFIG_NL80211_TESTMODE
 	struct genl_info *testmode_info;
 #endif
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index aed6d2a..d3aa2f1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3461,9 +3461,6 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
 
-	if (rdev->sched_scan_req)
-		return -EINPROGRESS;
-
 	if (!info->attrs[NL80211_ATTR_SCHED_SCAN_INTERVAL])
 		return -EINVAL;
 
@@ -3502,12 +3499,21 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (ie_len > wiphy->max_scan_ie_len)
 		return -EINVAL;
 
+	mutex_lock(&rdev->sched_scan_mtx);
+
+	if (rdev->sched_scan_req) {
+		err = -EINPROGRESS;
+		goto out;
+	}
+
 	request = kzalloc(sizeof(*request)
 			+ sizeof(*request->ssids) * n_ssids
 			+ sizeof(*request->channels) * n_channels
 			+ ie_len, GFP_KERNEL);
-	if (!request)
-		return -ENOMEM;
+	if (!request) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	if (n_ssids)
 		request->ssids = (void *)&request->channels[n_channels];
@@ -3605,6 +3611,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 out_free:
 	kfree(request);
 out:
+	mutex_unlock(&rdev->sched_scan_mtx);
 	return err;
 }
 
@@ -3612,12 +3619,17 @@ static int nl80211_stop_sched_scan(struct sk_buff *skb,
 				   struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	int err;
 
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
 	    !rdev->ops->sched_scan_stop)
 		return -EOPNOTSUPP;
 
-	return __cfg80211_stop_sched_scan(rdev, false);
+	mutex_lock(&rdev->sched_scan_mtx);
+	err = __cfg80211_stop_sched_scan(rdev, false);
+	mutex_unlock(&rdev->sched_scan_mtx);
+
+	return err;
 }
 
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 7a6c676..ae0c225 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -100,14 +100,14 @@ void __cfg80211_sched_scan_results(struct work_struct *wk)
 	rdev = container_of(wk, struct cfg80211_registered_device,
 			    sched_scan_results_wk);
 
-	cfg80211_lock_rdev(rdev);
+	mutex_lock(&rdev->sched_scan_mtx);
 
 	/* we don't have sched_scan_req anymore if the scan is stopping */
 	if (rdev->sched_scan_req)
 		nl80211_send_sched_scan_results(rdev,
 						rdev->sched_scan_req->dev);
 
-	cfg80211_unlock_rdev(rdev);
+	mutex_unlock(&rdev->sched_scan_mtx);
 }
 
 void cfg80211_sched_scan_results(struct wiphy *wiphy)
@@ -123,9 +123,9 @@ void cfg80211_sched_scan_stopped(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
-	cfg80211_lock_rdev(rdev);
+	mutex_lock(&rdev->sched_scan_mtx);
 	__cfg80211_stop_sched_scan(rdev, true);
-	cfg80211_unlock_rdev(rdev);
+	mutex_unlock(&rdev->sched_scan_mtx);
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_stopped);
 
@@ -135,7 +135,7 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 	int err;
 	struct net_device *dev;
 
-	ASSERT_RDEV_LOCK(rdev);
+	lockdep_assert_held(&rdev->sched_scan_mtx);
 
 	if (!rdev->sched_scan_req)
 		return 0;
-- 
1.7.1

