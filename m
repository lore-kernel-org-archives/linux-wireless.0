Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404AbZFJNSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 09:18:21 -0400
Subject: [PATCH 2.6.31] mac80211: disable PS while probing AP
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 15:16:52 +0200
Message-Id: <1244639812.18481.61.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When associated, but probing the AP because we detected
beacon loss, we need to disable powersave to be able to
receive the probe response. Change the code to do that by
checking whether we're trying to probe when determining
the possibility of going into PS, and recalculate the PS
ability at the necessary spots.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-06-10 15:01:41.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-06-10 15:15:29.000000000 +0200
@@ -651,7 +651,8 @@ void ieee80211_recalc_ps(struct ieee8021
 	}
 
 	if (count == 1 && found->u.mgd.powersave &&
-	    (found->u.mgd.flags & IEEE80211_STA_ASSOCIATED)) {
+	    (found->u.mgd.flags & IEEE80211_STA_ASSOCIATED) &&
+	    !(found->u.mgd.flags & IEEE80211_STA_PROBEREQ_POLL)) {
 		s32 beaconint_us;
 
 		if (latency < 0)
@@ -1320,6 +1321,11 @@ void ieee80211_beacon_loss_work(struct w
 #endif
 
 	ifmgd->flags |= IEEE80211_STA_PROBEREQ_POLL;
+
+	mutex_lock(&sdata->local->iflist_mtx);
+	ieee80211_recalc_ps(sdata->local, -1);
+	mutex_unlock(&sdata->local->iflist_mtx);
+
 	ieee80211_send_probe_req(sdata, ifmgd->bssid, ifmgd->ssid,
 				 ifmgd->ssid_len, NULL, 0);
 
@@ -1340,6 +1346,7 @@ static void ieee80211_associated(struct 
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
+	unsigned long last_rx;
 	bool disassoc = false;
 
 	/* TODO: start monitoring current AP signal quality and number of
@@ -1356,17 +1363,21 @@ static void ieee80211_associated(struct 
 		printk(KERN_DEBUG "%s: No STA entry for own AP %pM\n",
 		       sdata->dev->name, ifmgd->bssid);
 		disassoc = true;
-		goto unlock;
+		rcu_read_unlock();
+		goto out;
 	}
 
+	last_rx = sta->last_rx;
+	rcu_read_unlock();
+
 	if ((ifmgd->flags & IEEE80211_STA_PROBEREQ_POLL) &&
-	    time_after(jiffies, sta->last_rx + IEEE80211_PROBE_WAIT)) {
+	    time_after(jiffies, last_rx + IEEE80211_PROBE_WAIT)) {
 		printk(KERN_DEBUG "%s: no probe response from AP %pM "
 		       "- disassociating\n",
 		       sdata->dev->name, ifmgd->bssid);
 		disassoc = true;
 		ifmgd->flags &= ~IEEE80211_STA_PROBEREQ_POLL;
-		goto unlock;
+		goto out;
 	}
 
 	/*
@@ -1385,26 +1396,29 @@ static void ieee80211_associated(struct 
 		}
 #endif
 		ifmgd->flags |= IEEE80211_STA_PROBEREQ_POLL;
+		mutex_lock(&local->iflist_mtx);
+		ieee80211_recalc_ps(local, -1);
+		mutex_unlock(&local->iflist_mtx);
 		ieee80211_send_probe_req(sdata, ifmgd->bssid, ifmgd->ssid,
 					 ifmgd->ssid_len, NULL, 0);
 		mod_timer(&ifmgd->timer, jiffies + IEEE80211_PROBE_WAIT);
-		goto unlock;
+		goto out;
 	}
 
-	if (time_after(jiffies, sta->last_rx + IEEE80211_PROBE_IDLE_TIME)) {
+	if (time_after(jiffies, last_rx + IEEE80211_PROBE_IDLE_TIME)) {
 		ifmgd->flags |= IEEE80211_STA_PROBEREQ_POLL;
+		mutex_lock(&local->iflist_mtx);
+		ieee80211_recalc_ps(local, -1);
+		mutex_unlock(&local->iflist_mtx);
 		ieee80211_send_probe_req(sdata, ifmgd->bssid, ifmgd->ssid,
 					 ifmgd->ssid_len, NULL, 0);
 	}
 
+ out:
 	if (!disassoc)
 		mod_timer(&ifmgd->timer,
 			  jiffies + IEEE80211_MONITORING_INTERVAL);
-
- unlock:
-	rcu_read_unlock();
-
-	if (disassoc)
+	else
 		ieee80211_set_disassoc(sdata, true, true,
 					WLAN_REASON_PREV_AUTH_NOT_VALID);
 }
@@ -1887,8 +1901,12 @@ static void ieee80211_rx_mgmt_probe_resp
 		ieee80211_authenticate(sdata);
 	}
 
-	if (ifmgd->flags & IEEE80211_STA_PROBEREQ_POLL)
+	if (ifmgd->flags & IEEE80211_STA_PROBEREQ_POLL) {
 		ifmgd->flags &= ~IEEE80211_STA_PROBEREQ_POLL;
+		mutex_lock(&sdata->local->iflist_mtx);
+		ieee80211_recalc_ps(sdata->local, -1);
+		mutex_unlock(&sdata->local->iflist_mtx);
+	}
 }
 
 /*
@@ -1946,6 +1964,9 @@ static void ieee80211_rx_mgmt_beacon(str
 		}
 #endif
 		ifmgd->flags &= ~IEEE80211_STA_PROBEREQ_POLL;
+		mutex_lock(&local->iflist_mtx);
+		ieee80211_recalc_ps(local, -1);
+		mutex_unlock(&local->iflist_mtx);
 	}
 
 	ncrc = crc32_be(0, (void *)&mgmt->u.beacon.beacon_int, 4);


