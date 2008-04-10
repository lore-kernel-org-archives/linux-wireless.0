Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56427 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbYDJOk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 10:40:28 -0400
Subject: [PATCH] mac80211: further RCU fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 10 Apr 2008 15:36:09 +0200
Message-Id: <1207834569.19080.5.camel@johannes.berg> (sfid-20080410_154044_061844_6735EFAA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There were a few more instances of sta_info_get calls not being
protected by RCU, fix them.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c  |   20 +++++++++++++++++---
 net/mac80211/wext.c |    5 +++++
 2 files changed, 22 insertions(+), 3 deletions(-)

--- everything.orig/net/mac80211/cfg.c	2008-04-10 15:29:27.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-04-10 15:29:31.000000000 +0200
@@ -726,12 +726,18 @@ static int ieee80211_del_station(struct 
 	struct sta_info *sta;
 
 	if (mac) {
+		rcu_read_lock();
+
 		/* XXX: get sta belonging to dev */
 		sta = sta_info_get(local, mac);
-		if (!sta)
+		if (!sta) {
+			rcu_read_unlock();
 			return -ENOENT;
+		}
 
 		sta_info_unlink(&sta);
+		rcu_read_unlock();
+
 		sta_info_destroy(sta);
 	} else
 		sta_info_flush(local, sdata);
@@ -748,17 +754,23 @@ static int ieee80211_change_station(stru
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *vlansdata;
 
+	rcu_read_lock();
+
 	/* XXX: get sta belonging to dev */
 	sta = sta_info_get(local, mac);
-	if (!sta)
+	if (!sta) {
+		rcu_read_unlock();
 		return -ENOENT;
+	}
 
 	if (params->vlan && params->vlan != sta->sdata->dev) {
 		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
 		if (vlansdata->vif.type != IEEE80211_IF_TYPE_VLAN ||
-		    vlansdata->vif.type != IEEE80211_IF_TYPE_AP)
+		    vlansdata->vif.type != IEEE80211_IF_TYPE_AP) {
+			rcu_read_unlock();
 			return -EINVAL;
+		}
 
 		sta->sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 		ieee80211_send_layer2_update(sta);
@@ -766,6 +778,8 @@ static int ieee80211_change_station(stru
 
 	sta_apply_parameters(local, sta, params);
 
+	rcu_read_unlock();
+
 	return 0;
 }
 
--- everything.orig/net/mac80211/wext.c	2008-04-10 15:29:27.000000000 +0200
+++ everything/net/mac80211/wext.c	2008-04-10 15:29:31.000000000 +0200
@@ -983,6 +983,8 @@ static struct iw_statistics *ieee80211_g
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta = NULL;
 
+	rcu_read_lock();
+
 	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
 	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS)
 		sta = sta_info_get(local, sdata->u.sta.bssid);
@@ -999,6 +1001,9 @@ static struct iw_statistics *ieee80211_g
 		wstats->qual.noise = sta->last_noise;
 		wstats->qual.updated = local->wstats_flags;
 	}
+
+	rcu_read_unlock();
+
 	return wstats;
 }
 


