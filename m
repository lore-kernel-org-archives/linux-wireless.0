Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:60008 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757093Ab1ELN2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 09:28:53 -0400
Received: by ewy5 with SMTP id 5so488474ewy.20
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 06:28:39 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] cfg80211/mac80211: avoid bounce back mac->cfg->mac on sched_scan_stopped
Date: Thu, 12 May 2011 16:28:29 +0300
Message-Id: <1305206909-20911-1-git-send-email-coelho@ti.com> (sfid-20110512_152903_988933_FE6BAEEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When sched_scan_stopped was called by the driver, mac80211 calls
cfg80211, which in turn was calling mac80211 back with a flag
"driver_initiated".  This flag was used so that mac80211 would do the
necessary cleanup but would not call the driver.  This was enough to
prevent the bounce back between the driver and mac80211, but not
between mac80211 and cfg80211.

To fix this, we now do the cleanup in mac80211 before calling
cfg80211.  To help with locking issues, the workqueue was moved from
cfg80211 to mac80211.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 include/net/cfg80211.h     |    3 +--
 net/mac80211/cfg.c         |    5 ++---
 net/mac80211/ieee80211_i.h |    5 +++--
 net/mac80211/main.c        |    3 +++
 net/mac80211/scan.c        |   33 +++++++++++++++++++++++++++------
 net/wireless/core.c        |    1 -
 net/wireless/core.h        |    2 --
 net/wireless/scan.c        |   21 +++++++--------------
 8 files changed, 43 insertions(+), 30 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1f1e221..9aed7df 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1515,8 +1515,7 @@ struct cfg80211_ops {
 	int	(*sched_scan_start)(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct cfg80211_sched_scan_request *request);
-	int	(*sched_scan_stop)(struct wiphy *wiphy, struct net_device *dev,
-				   bool driver_initiated);
+	int	(*sched_scan_stop)(struct wiphy *wiphy, struct net_device *dev);
 };
 
 /*
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a2ff474..e3c8910 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1376,15 +1376,14 @@ ieee80211_sched_scan_start(struct wiphy *wiphy,
 }
 
 static int
-ieee80211_sched_scan_stop(struct wiphy *wiphy, struct net_device *dev,
-			  bool driver_initiated)
+ieee80211_sched_scan_stop(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (!sdata->local->ops->sched_scan_stop)
 		return -EOPNOTSUPP;
 
-	return ieee80211_request_sched_scan_stop(sdata, driver_initiated);
+	return ieee80211_request_sched_scan_stop(sdata);
 }
 
 static int ieee80211_auth(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 88815be..92774ac 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -849,6 +849,7 @@ struct ieee80211_local {
 
 	bool sched_scanning;
 	struct ieee80211_sched_scan_ies sched_scan_ies;
+	struct work_struct sched_scan_stopped_work;
 
 	unsigned long leave_oper_channel_time;
 	enum mac80211_scan_state next_scan_state;
@@ -1160,8 +1161,8 @@ void ieee80211_rx_bss_put(struct ieee80211_local *local,
 /* scheduled scan handling */
 int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 				       struct cfg80211_sched_scan_request *req);
-int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata,
-				      bool driver_initiated);
+int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata);
+void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
 /* off-channel helpers */
 bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 30e6a68..7f89011 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -652,6 +652,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	setup_timer(&local->dynamic_ps_timer,
 		    ieee80211_dynamic_ps_timer, (unsigned long) local);
 
+	INIT_WORK(&local->sched_scan_stopped_work,
+		  ieee80211_sched_scan_stopped_work);
+
 	sta_info_init(local);
 
 	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index ea44a8e..d20046b 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -902,8 +902,7 @@ out:
 	return ret;
 }
 
-int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata,
-				      bool driver_initiated)
+int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	int ret = 0, i;
@@ -919,11 +918,9 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata,
 		for (i = 0; i < IEEE80211_NUM_BANDS; i++)
 			kfree(local->sched_scan_ies.ie[i]);
 
-		if (!driver_initiated)
-			drv_sched_scan_stop(local, sdata);
+		drv_sched_scan_stop(local, sdata);
 		local->sched_scanning = false;
 	}
-
 out:
 	mutex_unlock(&sdata->local->mtx);
 
@@ -940,12 +937,36 @@ void ieee80211_sched_scan_results(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_sched_scan_results);
 
+void ieee80211_sched_scan_stopped_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local,
+			     sched_scan_stopped_work);
+	int i;
+
+	mutex_lock(&local->mtx);
+
+	if (!local->sched_scanning) {
+		mutex_unlock(&local->mtx);
+		return;
+	}
+
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+		kfree(local->sched_scan_ies.ie[i]);
+
+	local->sched_scanning = false;
+
+	mutex_unlock(&local->mtx);
+
+	cfg80211_sched_scan_stopped(local->hw.wiphy);
+}
+
 void ieee80211_sched_scan_stopped(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
 	trace_api_sched_scan_stopped(local);
 
-	cfg80211_sched_scan_stopped(hw->wiphy);
+	ieee80211_queue_work(&local->hw, &local->sched_scan_stopped_work);
 }
 EXPORT_SYMBOL(ieee80211_sched_scan_stopped);
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f924a49..bbeb0b5 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -371,7 +371,6 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	INIT_LIST_HEAD(&rdev->bss_list);
 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
 	INIT_WORK(&rdev->sched_scan_results_wk, __cfg80211_sched_scan_results);
-	INIT_WORK(&rdev->sched_scan_stopped_wk, __cfg80211_sched_scan_stopped);
 #ifdef CONFIG_CFG80211_WEXT
 	rdev->wiphy.wext = &cfg80211_wext_handler;
 #endif
diff --git a/net/wireless/core.h b/net/wireless/core.h
index e3f7b1d..1f0b38e 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -64,7 +64,6 @@ struct cfg80211_registered_device {
 	unsigned long suspend_at;
 	struct work_struct scan_done_wk;
 	struct work_struct sched_scan_results_wk;
-	struct work_struct sched_scan_stopped_wk;
 
 #ifdef CONFIG_NL80211_TESTMODE
 	struct genl_info *testmode_info;
@@ -417,7 +416,6 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak);
 void __cfg80211_sched_scan_results(struct work_struct *wk);
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			       bool driver_initiated);
-void __cfg80211_sched_scan_stopped(struct work_struct *wk);
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev);
 int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev, enum nl80211_iftype ntype,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 65dfae3..73a441d 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -119,22 +119,14 @@ void cfg80211_sched_scan_results(struct wiphy *wiphy)
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_results);
 
-void __cfg80211_sched_scan_stopped(struct work_struct *wk)
+void cfg80211_sched_scan_stopped(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_device *rdev;
-
-	rdev = container_of(wk, struct cfg80211_registered_device,
-			    sched_scan_stopped_wk);
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
 	cfg80211_lock_rdev(rdev);
 	__cfg80211_stop_sched_scan(rdev, true);
 	cfg80211_unlock_rdev(rdev);
 }
-
-void cfg80211_sched_scan_stopped(struct wiphy *wiphy)
-{
-	queue_work(cfg80211_wq, &wiphy_to_dev(wiphy)->sched_scan_stopped_wk);
-}
 EXPORT_SYMBOL(cfg80211_sched_scan_stopped);
 
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
@@ -150,10 +142,11 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 
 	dev = rdev->sched_scan_req->dev;
 
-	err = rdev->ops->sched_scan_stop(&rdev->wiphy, dev,
-					 driver_initiated);
-	if (err)
-		return err;
+	if (!driver_initiated) {
+		err = rdev->ops->sched_scan_stop(&rdev->wiphy, dev);
+		if (err)
+			return err;
+	}
 
 	nl80211_send_sched_scan(rdev, dev, NL80211_CMD_SCHED_SCAN_STOPPED);
 
-- 
1.7.1

