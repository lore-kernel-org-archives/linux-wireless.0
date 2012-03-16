Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965092Ab2CPMDL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 08:03:11 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 3/3] mac80211: synchronize channel switch and scan
Date: Fri, 16 Mar 2012 13:02:58 +0100
Message-Id: <1331899378-10543-3-git-send-email-sgruszka@redhat.com> (sfid-20120316_130316_161744_B4B1E532)
In-Reply-To: <1331899378-10543-1-git-send-email-sgruszka@redhat.com>
References: <1331899378-10543-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not perform actual channel switch and scan is parallel. Devices
that implement channel switch in hardware are responsible to do
synchronization by itself if needed.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   19 ++++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a48d40f..98b0d6c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -378,6 +378,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
 	IEEE80211_STA_NULLFUNC_ACKED	= BIT(8),
 	IEEE80211_STA_RESET_SIGNAL_AVE	= BIT(9),
+	IEEE80211_STA_CSA_DEFERRED	= BIT(10),
 };
 
 struct ieee80211_mgd_auth_data {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0737278..ebc60a2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -726,6 +726,13 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	if (!ifmgd->associated)
 		goto out;
 
+	mutex_lock(&sdata->local->mtx);
+	if (sdata->local->scanning) {
+		ifmgd->flags |= IEEE80211_STA_CSA_DEFERRED;
+		mutex_unlock(&sdata->local->mtx);
+		goto out_unlock;
+	}
+
 	sdata->local->oper_channel = sdata->local->csa_channel;
 	if (!sdata->local->ops->channel_switch) {
 		/* call "hw_config" only if doing sw channel switch */
@@ -741,8 +748,11 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
+
+	mutex_unlock(&sdata->local->mtx);
  out:
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
+ out_unlock:
 	mutex_unlock(&ifmgd->mtx);
 }
 
@@ -800,9 +810,6 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (!ifmgd->associated)
 		return;
 
-	if (sdata->local->scanning)
-		return;
-
 	/* Disregard subsequent beacons if we are already running a timer
 	   processing a CSA */
 
@@ -3037,12 +3044,18 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	/* Restart STA timers */
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
 		ieee80211_restart_sta_timer(sdata);
 	rcu_read_unlock();
+
+	if (ifmgd->flags & IEEE80211_STA_CSA_DEFERRED) {
+		ifmgd->flags &= ~IEEE80211_STA_CSA_DEFERRED;
+		ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
+	}
 }
 
 int ieee80211_max_network_latency(struct notifier_block *nb,
-- 
1.7.1

