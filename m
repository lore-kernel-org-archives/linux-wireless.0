Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbZCNImz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 04:42:55 -0400
Subject: [PATCH] mac80211: acquire sta_lock for station suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bob Copeland <bcopeland@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 09:42:49 +0100
Message-Id: <1237020169.5235.66.camel@johannes.local> (sfid-20090314_094259_843037_AD6CAB8A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To avoid concurrent manipulations of the sta list (which shouldn't
be possible at this point, but anyway) we need to hold the sta_lock
around iterating the list.

At the same time, we do not need to iterate the list at all if
the driver doesn't want to be notified.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/pm.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- wireless-testing.orig/net/mac80211/pm.c	2009-03-14 09:35:01.000000000 +0100
+++ wireless-testing/net/mac80211/pm.c	2009-03-14 09:40:12.000000000 +0100
@@ -10,6 +10,7 @@ int __ieee80211_suspend(struct ieee80211
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_init_conf conf;
 	struct sta_info *sta;
+	unsigned long flags;
 
 	ieee80211_stop_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
@@ -21,9 +22,9 @@ int __ieee80211_suspend(struct ieee80211
 		ieee80211_disable_keys(sdata);
 
 	/* remove STAs */
-	list_for_each_entry(sta, &local->sta_list, list) {
-
-		if (local->ops->sta_notify) {
+	if (local->ops->sta_notify) {
+		spin_lock_irqsave(&local->sta_lock, flags);
+		list_for_each_entry(sta, &local->sta_list, list) {
 			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 				sdata = container_of(sdata->bss,
 					     struct ieee80211_sub_if_data,
@@ -32,11 +33,11 @@ int __ieee80211_suspend(struct ieee80211
 			local->ops->sta_notify(hw, &sdata->vif,
 				STA_NOTIFY_REMOVE, &sta->sta);
 		}
+		spin_unlock_irqrestore(&local->sta_lock, flags);
 	}
 
 	/* remove all interfaces */
 	list_for_each_entry(sdata, &local->interfaces, list) {
-
 		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
 		    sdata->vif.type != NL80211_IFTYPE_MONITOR &&
 		    netif_running(sdata->dev)) {
@@ -64,6 +65,7 @@ int __ieee80211_resume(struct ieee80211_
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_init_conf conf;
 	struct sta_info *sta;
+	unsigned long flags;
 	int res;
 
 	/* restart hardware */
@@ -75,7 +77,6 @@ int __ieee80211_resume(struct ieee80211_
 
 	/* add interfaces */
 	list_for_each_entry(sdata, &local->interfaces, list) {
-
 		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
 		    sdata->vif.type != NL80211_IFTYPE_MONITOR &&
 		    netif_running(sdata->dev)) {
@@ -87,9 +88,9 @@ int __ieee80211_resume(struct ieee80211_
 	}
 
 	/* add STAs back */
-	list_for_each_entry(sta, &local->sta_list, list) {
-
-		if (local->ops->sta_notify) {
+	if (local->ops->sta_notify) {
+		spin_lock_irqsave(&local->sta_lock, flags);
+		list_for_each_entry(sta, &local->sta_list, list) {
 			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 				sdata = container_of(sdata->bss,
 					     struct ieee80211_sub_if_data,
@@ -98,6 +99,7 @@ int __ieee80211_resume(struct ieee80211_
 			local->ops->sta_notify(hw, &sdata->vif,
 				STA_NOTIFY_ADD, &sta->sta);
 		}
+		spin_unlock_irqrestore(&local->sta_lock, flags);
 	}
 
 	/* add back keys */


