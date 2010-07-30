Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55333 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab0G3Oop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 10:44:45 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OeqpH-0003Pq-M5
	for linux-wireless@vger.kernel.org; Fri, 30 Jul 2010 16:44:43 +0200
Subject: [PATCH] mac80211: unify scan and work mutexes
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 16:46:07 +0200
Message-ID: <1280501167.3710.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Having both scan and work mutexes is not just
a bit too fine grained, it also creates issues
when there's code that needs both since they
then need to be acquired in the right order,
which can be hard to do.

Therefore, use just a single mutex for both.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/main.c        |    4 ++--
 net/mac80211/mlme.c        |    8 ++++----
 net/mac80211/scan.c        |   30 +++++++++++++++---------------
 net/mac80211/work.c        |   35 +++++++++++++++--------------------
 5 files changed, 38 insertions(+), 43 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-07-30 16:28:07.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-07-30 16:39:06.000000000 +0200
@@ -634,7 +634,6 @@ struct ieee80211_local {
 	/*
 	 * work stuff, potentially off-channel (in the future)
 	 */
-	struct mutex work_mtx;
 	struct list_head work_list;
 	struct timer_list work_timer;
 	struct work_struct work_work;
@@ -746,9 +745,10 @@ struct ieee80211_local {
 	 */
 	struct mutex key_mtx;
 
+	/* mutex for scan and work locking */
+	struct mutex mtx;
 
 	/* Scanning and BSS list */
-	struct mutex scan_mtx;
 	unsigned long scanning;
 	struct cfg80211_ssid scan_ssid;
 	struct cfg80211_scan_request *int_scan_req;
--- wireless-testing.orig/net/mac80211/main.c	2010-07-30 16:28:07.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-07-30 16:28:38.000000000 +0200
@@ -455,7 +455,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	__hw_addr_init(&local->mc_list);
 
 	mutex_init(&local->iflist_mtx);
-	mutex_init(&local->scan_mtx);
+	mutex_init(&local->mtx);
 
 	mutex_init(&local->key_mtx);
 	spin_lock_init(&local->filter_lock);
@@ -756,7 +756,7 @@ void ieee80211_free_hw(struct ieee80211_
 	struct ieee80211_local *local = hw_to_local(hw);
 
 	mutex_destroy(&local->iflist_mtx);
-	mutex_destroy(&local->scan_mtx);
+	mutex_destroy(&local->mtx);
 
 	wiphy_free(local->hw.wiphy);
 }
--- wireless-testing.orig/net/mac80211/mlme.c	2010-07-30 16:28:07.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-07-30 16:28:38.000000000 +0200
@@ -1751,7 +1751,7 @@ void ieee80211_sta_rx_queued_mgmt(struct
 		struct ieee80211_local *local = sdata->local;
 		struct ieee80211_work *wk;
 
-		mutex_lock(&local->work_mtx);
+		mutex_lock(&local->mtx);
 		list_for_each_entry(wk, &local->work_list, list) {
 			if (wk->sdata != sdata)
 				continue;
@@ -1783,7 +1783,7 @@ void ieee80211_sta_rx_queued_mgmt(struct
 			free_work(wk);
 			break;
 		}
-		mutex_unlock(&local->work_mtx);
+		mutex_unlock(&local->mtx);
 
 		cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
 	}
@@ -2275,7 +2275,7 @@ int ieee80211_mgd_deauth(struct ieee8021
 
 		mutex_unlock(&ifmgd->mtx);
 
-		mutex_lock(&local->work_mtx);
+		mutex_lock(&local->mtx);
 		list_for_each_entry(wk, &local->work_list, list) {
 			if (wk->sdata != sdata)
 				continue;
@@ -2294,7 +2294,7 @@ int ieee80211_mgd_deauth(struct ieee8021
 			free_work(wk);
 			break;
 		}
-		mutex_unlock(&local->work_mtx);
+		mutex_unlock(&local->mtx);
 
 		/*
 		 * If somebody requests authentication and we haven't
--- wireless-testing.orig/net/mac80211/scan.c	2010-07-30 16:28:07.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2010-07-30 16:39:06.000000000 +0200
@@ -256,7 +256,7 @@ void ieee80211_scan_completed(struct iee
 
 	trace_api_scan_completed(local, aborted);
 
-	mutex_lock(&local->scan_mtx);
+	mutex_lock(&local->mtx);
 
 	/*
 	 * It's ok to abort a not-yet-running scan (that
@@ -268,7 +268,7 @@ void ieee80211_scan_completed(struct iee
 		aborted = true;
 
 	if (WARN_ON(!local->scan_req)) {
-		mutex_unlock(&local->scan_mtx);
+		mutex_unlock(&local->mtx);
 		return;
 	}
 
@@ -276,7 +276,7 @@ void ieee80211_scan_completed(struct iee
 	if (was_hw_scan && !aborted && ieee80211_prep_hw_scan(local)) {
 		ieee80211_queue_delayed_work(&local->hw,
 					     &local->scan_work, 0);
-		mutex_unlock(&local->scan_mtx);
+		mutex_unlock(&local->mtx);
 		return;
 	}
 
@@ -292,7 +292,7 @@ void ieee80211_scan_completed(struct iee
 	local->scan_channel = NULL;
 
 	/* we only have to protect scan_req and hw/sw scan */
-	mutex_unlock(&local->scan_mtx);
+	mutex_unlock(&local->mtx);
 
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 	if (was_hw_scan)
@@ -640,15 +640,15 @@ void ieee80211_scan_work(struct work_str
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 	unsigned long next_delay = 0;
 
-	mutex_lock(&local->scan_mtx);
+	mutex_lock(&local->mtx);
 	if (!sdata || !local->scan_req) {
-		mutex_unlock(&local->scan_mtx);
+		mutex_unlock(&local->mtx);
 		return;
 	}
 
 	if (local->hw_scan_req) {
 		int rc = drv_hw_scan(local, sdata, local->hw_scan_req);
-		mutex_unlock(&local->scan_mtx);
+		mutex_unlock(&local->mtx);
 		if (rc)
 			ieee80211_scan_completed(&local->hw, true);
 		return;
@@ -662,14 +662,14 @@ void ieee80211_scan_work(struct work_str
 		local->scan_sdata = NULL;
 
 		rc = __ieee80211_start_scan(sdata, req);
-		mutex_unlock(&local->scan_mtx);
+		mutex_unlock(&local->mtx);
 
 		if (rc)
 			ieee80211_scan_completed(&local->hw, true);
 		return;
 	}
 
-	mutex_unlock(&local->scan_mtx);
+	mutex_unlock(&local->mtx);
 
 	/*
 	 * Avoid re-scheduling when the sdata is going away.
@@ -712,9 +712,9 @@ int ieee80211_request_scan(struct ieee80
 {
 	int res;
 
-	mutex_lock(&sdata->local->scan_mtx);
+	mutex_lock(&sdata->local->mtx);
 	res = __ieee80211_start_scan(sdata, req);
-	mutex_unlock(&sdata->local->scan_mtx);
+	mutex_unlock(&sdata->local->mtx);
 
 	return res;
 }
@@ -727,7 +727,7 @@ int ieee80211_request_internal_scan(stru
 	int ret = -EBUSY;
 	enum ieee80211_band band;
 
-	mutex_lock(&local->scan_mtx);
+	mutex_lock(&local->mtx);
 
 	/* busy scanning */
 	if (local->scan_req)
@@ -762,7 +762,7 @@ int ieee80211_request_internal_scan(stru
 
 	ret = __ieee80211_start_scan(sdata, sdata->local->int_scan_req);
  unlock:
-	mutex_unlock(&local->scan_mtx);
+	mutex_unlock(&local->mtx);
 	return ret;
 }
 
@@ -776,10 +776,10 @@ void ieee80211_scan_cancel(struct ieee80
 	 * Only call this function when a scan can't be
 	 * queued -- mostly at suspend under RTNL.
 	 */
-	mutex_lock(&local->scan_mtx);
+	mutex_lock(&local->mtx);
 	abortscan = test_bit(SCAN_SW_SCANNING, &local->scanning) ||
 		    (!local->scanning && local->scan_req);
-	mutex_unlock(&local->scan_mtx);
+	mutex_unlock(&local->mtx);
 
 	if (abortscan)
 		ieee80211_scan_completed(&local->hw, true);
--- wireless-testing.orig/net/mac80211/work.c	2010-07-30 16:28:07.000000000 +0200
+++ wireless-testing/net/mac80211/work.c	2010-07-30 16:39:06.000000000 +0200
@@ -43,7 +43,7 @@ enum work_action {
 /* utils */
 static inline void ASSERT_WORK_MTX(struct ieee80211_local *local)
 {
-	WARN_ON(!mutex_is_locked(&local->work_mtx));
+	lockdep_assert_held(&local->mtx);
 }
 
 /*
@@ -757,7 +757,7 @@ static void ieee80211_work_rx_queued_mgm
 	mgmt = (struct ieee80211_mgmt *) skb->data;
 	fc = le16_to_cpu(mgmt->frame_control);
 
-	mutex_lock(&local->work_mtx);
+	mutex_lock(&local->mtx);
 
 	list_for_each_entry(wk, &local->work_list, list) {
 		const u8 *bssid = NULL;
@@ -833,7 +833,7 @@ static void ieee80211_work_rx_queued_mgm
 		WARN(1, "unexpected: %d", rma);
 	}
 
-	mutex_unlock(&local->work_mtx);
+	mutex_unlock(&local->mtx);
 
 	if (rma != WORK_ACT_DONE)
 		goto out;
@@ -845,9 +845,9 @@ static void ieee80211_work_rx_queued_mgm
 	case WORK_DONE_REQUEUE:
 		synchronize_rcu();
 		wk->started = false; /* restart */
-		mutex_lock(&local->work_mtx);
+		mutex_lock(&local->mtx);
 		list_add_tail(&wk->list, &local->work_list);
-		mutex_unlock(&local->work_mtx);
+		mutex_unlock(&local->mtx);
 	}
 
  out:
@@ -890,7 +890,7 @@ static void ieee80211_work_work(struct w
 
 	ieee80211_recalc_idle(local);
 
-	mutex_lock(&local->work_mtx);
+	mutex_lock(&local->mtx);
 
 	list_for_each_entry_safe(wk, tmp, &local->work_list, list) {
 		bool started = wk->started;
@@ -995,17 +995,13 @@ static void ieee80211_work_work(struct w
 		run_again(local, jiffies + HZ/2);
 	}
 
-	mutex_lock(&local->scan_mtx);
-
 	if (list_empty(&local->work_list) && local->scan_req &&
 	    !local->scanning)
 		ieee80211_queue_delayed_work(&local->hw,
 					     &local->scan_work,
 					     round_jiffies_relative(0));
 
-	mutex_unlock(&local->scan_mtx);
-
-	mutex_unlock(&local->work_mtx);
+	mutex_unlock(&local->mtx);
 
 	ieee80211_recalc_idle(local);
 
@@ -1035,16 +1031,15 @@ void ieee80211_add_work(struct ieee80211
 	wk->started = false;
 
 	local = wk->sdata->local;
-	mutex_lock(&local->work_mtx);
+	mutex_lock(&local->mtx);
 	list_add_tail(&wk->list, &local->work_list);
-	mutex_unlock(&local->work_mtx);
+	mutex_unlock(&local->mtx);
 
 	ieee80211_queue_work(&local->hw, &local->work_work);
 }
 
 void ieee80211_work_init(struct ieee80211_local *local)
 {
-	mutex_init(&local->work_mtx);
 	INIT_LIST_HEAD(&local->work_list);
 	setup_timer(&local->work_timer, ieee80211_work_timer,
 		    (unsigned long)local);
@@ -1057,7 +1052,7 @@ void ieee80211_work_purge(struct ieee802
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_work *wk;
 
-	mutex_lock(&local->work_mtx);
+	mutex_lock(&local->mtx);
 	list_for_each_entry(wk, &local->work_list, list) {
 		if (wk->sdata != sdata)
 			continue;
@@ -1065,19 +1060,19 @@ void ieee80211_work_purge(struct ieee802
 		wk->started = true;
 		wk->timeout = jiffies;
 	}
-	mutex_unlock(&local->work_mtx);
+	mutex_unlock(&local->mtx);
 
 	/* run cleanups etc. */
 	ieee80211_work_work(&local->work_work);
 
-	mutex_lock(&local->work_mtx);
+	mutex_lock(&local->mtx);
 	list_for_each_entry(wk, &local->work_list, list) {
 		if (wk->sdata != sdata)
 			continue;
 		WARN_ON(1);
 		break;
 	}
-	mutex_unlock(&local->work_mtx);
+	mutex_unlock(&local->mtx);
 }
 
 ieee80211_rx_result ieee80211_work_rx_mgmt(struct ieee80211_sub_if_data *sdata,
@@ -1163,7 +1158,7 @@ int ieee80211_wk_cancel_remain_on_channe
 	struct ieee80211_work *wk, *tmp;
 	bool found = false;
 
-	mutex_lock(&local->work_mtx);
+	mutex_lock(&local->mtx);
 	list_for_each_entry_safe(wk, tmp, &local->work_list, list) {
 		if ((unsigned long) wk == cookie) {
 			wk->timeout = jiffies;
@@ -1171,7 +1166,7 @@ int ieee80211_wk_cancel_remain_on_channe
 			break;
 		}
 	}
-	mutex_unlock(&local->work_mtx);
+	mutex_unlock(&local->mtx);
 
 	if (!found)
 		return -ENOENT;


