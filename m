Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52065 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265Ab2GFVFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 17:05:36 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/3] mac80211: track scheduled scan virtual interface
Date: Fri,  6 Jul 2012 23:05:32 +0200
Message-Id: <1341608733-7503-3-git-send-email-johannes@sipsolutions.net> (sfid-20120706_230545_201404_86DBAD3F)
In-Reply-To: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>
References: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of tracking whether or not we're in a
scheduled scan, track the virtual interface
(sdata) in an RCU-protected pointer to make it
usable from RX to check the MAC address.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/main.c        |    3 ++-
 net/mac80211/rx.c          |    4 ++--
 net/mac80211/scan.c        |   20 ++++++++++----------
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index da66a73..2e7dc0c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -967,9 +967,9 @@ struct ieee80211_local {
 	int scan_channel_idx;
 	int scan_ies_len;
 
-	bool sched_scanning;
 	struct ieee80211_sched_scan_ies sched_scan_ies;
 	struct work_struct sched_scan_stopped_work;
+	struct ieee80211_sub_if_data __rcu *sched_scan_sdata;
 
 	unsigned long leave_oper_channel_time;
 	enum mac80211_scan_state next_scan_state;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 731681c..e706f9e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -326,7 +326,8 @@ static void ieee80211_restart_work(struct work_struct *work)
 
 	mutex_lock(&local->mtx);
 	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
-	     local->sched_scanning,
+	     rcu_dereference_protected(local->sched_scan_sdata,
+				       lockdep_is_held(&local->mtx)),
 		"%s called with hardware scan in progress\n", __func__);
 	mutex_unlock(&local->mtx);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 14b5fb4..4e09b7f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -461,13 +461,13 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 	struct sk_buff *skb = rx->skb;
 
 	if (likely(!(status->rx_flags & IEEE80211_RX_IN_SCAN) &&
-		   !local->sched_scanning))
+		   !rcu_access_pointer(local->sched_scan_sdata)))
 		return RX_CONTINUE;
 
 	if (test_bit(SCAN_HW_SCANNING, &local->scanning) ||
 	    test_bit(SCAN_SW_SCANNING, &local->scanning) ||
 	    test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning) ||
-	    local->sched_scanning)
+	    rcu_access_pointer(local->sched_scan_sdata))
 		return ieee80211_scan_rx(rx->sdata, skb);
 
 	/* scanning finished during invoking of handlers */
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 48d3219..a5848d2 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -931,9 +931,9 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	int ret, i;
 
-	mutex_lock(&sdata->local->mtx);
+	mutex_lock(&local->mtx);
 
-	if (local->sched_scanning) {
+	if (rcu_access_pointer(local->sched_scan_sdata)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -964,7 +964,7 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 	ret = drv_sched_scan_start(local, sdata, req,
 				   &local->sched_scan_ies);
 	if (ret == 0) {
-		local->sched_scanning = true;
+		rcu_assign_pointer(local->sched_scan_sdata, sdata);
 		goto out;
 	}
 
@@ -972,7 +972,7 @@ out_free:
 	while (i > 0)
 		kfree(local->sched_scan_ies.ie[--i]);
 out:
-	mutex_unlock(&sdata->local->mtx);
+	mutex_unlock(&local->mtx);
 	return ret;
 }
 
@@ -981,22 +981,22 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	int ret = 0, i;
 
-	mutex_lock(&sdata->local->mtx);
+	mutex_lock(&local->mtx);
 
 	if (!local->ops->sched_scan_stop) {
 		ret = -ENOTSUPP;
 		goto out;
 	}
 
-	if (local->sched_scanning) {
+	if (rcu_access_pointer(local->sched_scan_sdata)) {
 		for (i = 0; i < IEEE80211_NUM_BANDS; i++)
 			kfree(local->sched_scan_ies.ie[i]);
 
 		drv_sched_scan_stop(local, sdata);
-		local->sched_scanning = false;
+		rcu_assign_pointer(local->sched_scan_sdata, NULL);
 	}
 out:
-	mutex_unlock(&sdata->local->mtx);
+	mutex_unlock(&local->mtx);
 
 	return ret;
 }
@@ -1020,7 +1020,7 @@ void ieee80211_sched_scan_stopped_work(struct work_struct *work)
 
 	mutex_lock(&local->mtx);
 
-	if (!local->sched_scanning) {
+	if (!rcu_access_pointer(local->sched_scan_sdata)) {
 		mutex_unlock(&local->mtx);
 		return;
 	}
@@ -1028,7 +1028,7 @@ void ieee80211_sched_scan_stopped_work(struct work_struct *work)
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
 		kfree(local->sched_scan_ies.ie[i]);
 
-	local->sched_scanning = false;
+	rcu_assign_pointer(local->sched_scan_sdata, NULL);
 
 	mutex_unlock(&local->mtx);
 
-- 
1.7.10.4

