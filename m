Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032773Ab2CPMDP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 08:03:15 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 1/3] mac80211: do not scan and monitor connection in parallel
Date: Fri, 16 Mar 2012 13:02:56 +0100
Message-Id: <1331899378-10543-1-git-send-email-sgruszka@redhat.com> (sfid-20120316_130318_801255_E6602E32)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before we send probes in connection monitoring we check if scan is not
pending. But we do that check without locking. Fix that and also do not
start scan if connection monitoring is in progress.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   35 +++++++++++++++++++++++------------
 net/mac80211/scan.c        |   29 ++++++++++++++++++++++++++++-
 net/mac80211/work.c        |    7 +------
 4 files changed, 53 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 63fb0eb..a48d40f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1239,6 +1239,7 @@ int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_scan_request *req);
 void ieee80211_scan_cancel(struct ieee80211_local *local);
+void ieee80211_run_deferred_scan(struct ieee80211_local *local);
 ieee80211_rx_result
 ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0df2237..0737278 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1496,19 +1496,24 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_local *local = sdata->local;
 
+	mutex_lock(&local->mtx);
 	if (!(ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
-			      IEEE80211_STA_CONNECTION_POLL)))
-	    return;
+			      IEEE80211_STA_CONNECTION_POLL))) {
+		mutex_unlock(&local->mtx);
+		return;
+	}
 
 	ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
 			  IEEE80211_STA_BEACON_POLL);
-	mutex_lock(&sdata->local->iflist_mtx);
-	ieee80211_recalc_ps(sdata->local, -1);
-	mutex_unlock(&sdata->local->iflist_mtx);
+
+	mutex_lock(&local->iflist_mtx);
+	ieee80211_recalc_ps(local, -1);
+	mutex_unlock(&local->iflist_mtx);
 
 	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
-		return;
+		goto out;
 
 	/*
 	 * We've received a probe response, but are not sure whether
@@ -1520,6 +1525,9 @@ static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
 	mod_timer(&ifmgd->conn_mon_timer,
 		  round_jiffies_up(jiffies +
 				   IEEE80211_CONNECTION_IDLE_TIME));
+out:
+	ieee80211_run_deferred_scan(local);
+	mutex_unlock(&local->mtx);
 }
 
 void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
@@ -1586,17 +1594,18 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 	if (!ieee80211_sdata_running(sdata))
 		return;
 
-	if (sdata->local->scanning)
-		return;
-
-	if (sdata->local->tmp_channel)
-		return;
-
 	mutex_lock(&ifmgd->mtx);
 
 	if (!ifmgd->associated)
 		goto out;
 
+	mutex_lock(&sdata->local->mtx);
+
+	if (sdata->local->tmp_channel || sdata->local->scanning) {
+		mutex_unlock(&sdata->local->mtx);
+		goto out;
+	}
+
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	if (beacon && net_ratelimit())
 		printk(KERN_DEBUG "%s: detected beacon loss from AP "
@@ -1623,6 +1632,8 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 	else
 		ifmgd->flags |= IEEE80211_STA_CONNECTION_POLL;
 
+	mutex_unlock(&sdata->local->mtx);
+
 	if (already)
 		goto out;
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 33cd169..1b90f97 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -387,6 +387,33 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	return 0;
 }
 
+static bool ieee80211_can_scan(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata)
+{
+	if (!list_empty(&local->work_list))
+		return false;
+
+	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    sdata->u.mgd.flags & (IEEE80211_STA_BEACON_POLL |
+				  IEEE80211_STA_CONNECTION_POLL))
+		return false;
+
+	return true;
+}
+
+void ieee80211_run_deferred_scan(struct ieee80211_local *local)
+{
+	lockdep_assert_held(&local->mtx);
+
+	if (!local->scan_req || local->scanning)
+		return;
+
+	if (!ieee80211_can_scan(local, local->scan_sdata))
+		return;
+
+	ieee80211_queue_delayed_work(&local->hw, &local->scan_work,
+				     round_jiffies_relative(0));
+}
 
 static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 				  struct cfg80211_scan_request *req)
@@ -399,7 +426,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	if (local->scan_req)
 		return -EBUSY;
 
-	if (!list_empty(&local->work_list)) {
+	if (!ieee80211_can_scan(local, sdata)) {
 		/* wait for the work to finish/time out */
 		local->scan_req = req;
 		local->scan_sdata = sdata;
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index c6e230e..1f74af3 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -226,13 +226,8 @@ static void ieee80211_work_work(struct work_struct *work)
 		run_again(local, jiffies + HZ/2);
 	}
 
-	if (list_empty(&local->work_list) && local->scan_req &&
-	    !local->scanning)
-		ieee80211_queue_delayed_work(&local->hw,
-					     &local->scan_work,
-					     round_jiffies_relative(0));
-
 	ieee80211_recalc_idle(local);
+	ieee80211_run_deferred_scan(local);
 
 	mutex_unlock(&local->mtx);
 
-- 
1.7.1

