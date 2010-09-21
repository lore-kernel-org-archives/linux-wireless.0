Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39912 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab0IUT1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 15:27:03 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	srinivasa.duvvuri@atheros.com, matt.smith@atheros.com,
	bennyam.malavazi@atheros.com
Subject: [RFC] mac80211: Deny new BA sessions from being started during offchannel operation
Date: Tue, 21 Sep 2010 15:27:02 -0400
Message-Id: <1285097222-10286-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It only makes sense to allow BlockAckRequests to be processed
when we are going to spend some time on the operating channel,
otherwise our timers will be off and until we properly figure out
how to handle CAB data when going offchannel extending the BA
session timers would be pointless. This blocks all new incoming
BlockAck requests while we go offchannel, but keeps existing
sessions alive.

Cc: srinivasa.duvvuri@atheros.com
Cc: matt.smith@atheros.com
Cc: bennyam.malavazi@atheros.com
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This is what I'm starting off with, then if a current BA session
timer is pending then postpone the offchannel operation for
the next target channel until its done or we surpass a counter.
Then after that I'd extend the reorder timer based on the
calculated max offchannel time -- or we can just disarm and
re-arm the timer completely when we come back.

For TX we'll just implement a TX flush prior to going offchannel.

 net/mac80211/agg-rx.c     |    8 ++++++--
 net/mac80211/offchannel.c |   14 ++++++++++++++
 net/mac80211/sta_info.h   |    3 ++-
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 58eab9e..64aa5ca 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -209,8 +209,12 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 
 	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "Suspend in progress. "
-		       "Denying ADDBA request\n");
+		if (local->quiescing)
+			printk(KERN_DEBUG "Suspend in progress. "
+			      "Denying ADDBA request\n");
+		else
+			printk(KERN_DEBUG "Offchannel operation in progress, "
+			      "Denying ADDBA request\n");
 #endif
 		goto end_no_lock;
 	}
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 4b56409..776d45b 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -23,6 +23,7 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct sta_info *sta;
 
 	local->offchannel_ps_enabled = false;
 
@@ -34,6 +35,12 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
+	mutex_lock(&local->sta_mtx);
+	list_for_each_entry(sta, &local->sta_list, list)
+		if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)
+			set_sta_flags(sta, WLAN_STA_BLOCK_BA);
+	mutex_unlock(&local->sta_mtx);
+
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		local->offchannel_ps_enabled = true;
 		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
@@ -59,6 +66,7 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
 
 	if (!local->ps_sdata)
 		ieee80211_send_nullfunc(local, sdata, 0);
@@ -92,6 +100,12 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 
 	ieee80211_sta_reset_beacon_monitor(sdata);
 	ieee80211_sta_reset_conn_monitor(sdata);
+
+	mutex_lock(&local->sta_mtx);
+	list_for_each_entry(sta, &local->sta_list, list)
+		if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)
+			clear_sta_flags(sta, WLAN_STA_BLOCK_BA);
+	mutex_unlock(&local->sta_mtx);
 }
 
 void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 810c5ce..207997a 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -36,7 +36,8 @@
  *	frame to this station is transmitted.
  * @WLAN_STA_MFP: Management frame protection is used with this STA.
  * @WLAN_STA_BLOCK_BA: Used to deny ADDBA requests (both TX and RX)
- *	during suspend/resume and station removal.
+ *	during suspend/resume, station removal, and when we go offchannel
+ *	when associated.
  * @WLAN_STA_PS_DRIVER: driver requires keeping this station in
  *	power-save mode logically to flush frames that might still
  *	be in the queues
-- 
1.7.0.4

