Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab1LNLX7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 06:23:59 -0500
Message-Id: <20111214112313.015117327@sipsolutions.net> (sfid-20111214_122407_985464_4DD0B733)
Date: Wed, 14 Dec 2011 12:20:29 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] mac80211: use station mutex in configuration
References: <20111214112026.409514167@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to use RCU here, we can just lock
the station mutex instead. This allows the code
to sleep, which is necessary for later patches.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/mac80211/cfg.c	2011-12-14 11:39:46.000000000 +0100
+++ b/net/mac80211/cfg.c	2011-12-14 11:41:05.000000000 +0100
@@ -954,11 +954,11 @@ static int ieee80211_change_station(stru
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *vlansdata;
 
-	rcu_read_lock();
+	mutex_lock(&local->sta_mtx);
 
 	sta = sta_info_get_bss(sdata, mac);
 	if (!sta) {
-		rcu_read_unlock();
+		mutex_unlock(&local->sta_mtx);
 		return -ENOENT;
 	}
 
@@ -966,7 +966,7 @@ static int ieee80211_change_station(stru
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    params->supported_rates &&
 	    !test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
-		rcu_read_unlock();
+		mutex_unlock(&local->sta_mtx);
 		return -EINVAL;
 	}
 
@@ -975,13 +975,13 @@ static int ieee80211_change_station(stru
 
 		if (vlansdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
 		    vlansdata->vif.type != NL80211_IFTYPE_AP) {
-			rcu_read_unlock();
+			mutex_unlock(&local->sta_mtx);
 			return -EINVAL;
 		}
 
 		if (params->vlan->ieee80211_ptr->use_4addr) {
 			if (vlansdata->u.vlan.sta) {
-				rcu_read_unlock();
+				mutex_unlock(&local->sta_mtx);
 				return -EBUSY;
 			}
 
@@ -997,7 +997,7 @@ static int ieee80211_change_station(stru
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) && params->supported_rates)
 		rate_control_rate_init(sta);
 
-	rcu_read_unlock();
+	mutex_unlock(&local->sta_mtx);
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED))


