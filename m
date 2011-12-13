Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37857 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab1LMUPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 15:15:16 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RaYkt-00036P-L5
	for linux-wireless@vger.kernel.org; Tue, 13 Dec 2011 21:15:15 +0100
Message-Id: <20111213201449.589673140@sipsolutions.net> (sfid-20111213_211521_688055_2861DB2E)
Date: Tue, 13 Dec 2011 21:07:18 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 1/4] mac80211: use station mutex in configuration
References: <20111213200717.465896579@sipsolutions.net>
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

--- a/net/mac80211/cfg.c	2011-12-13 21:01:26.000000000 +0100
+++ b/net/mac80211/cfg.c	2011-12-13 21:01:28.000000000 +0100
@@ -960,11 +960,11 @@ static int ieee80211_change_station(stru
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
 
@@ -972,7 +972,7 @@ static int ieee80211_change_station(stru
 	if ((params->sta_flags_mask & BIT(NL80211_STA_FLAG_TDLS_PEER)) &&
 	    !!(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) !=
 	    !!test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
-		rcu_read_unlock();
+		mutex_unlock(&local->sta_mtx);
 		return -EINVAL;
 	}
 
@@ -981,13 +981,13 @@ static int ieee80211_change_station(stru
 
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
 
@@ -1003,7 +1003,7 @@ static int ieee80211_change_station(stru
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) && params->supported_rates)
 		rate_control_rate_init(sta);
 
-	rcu_read_unlock();
+	mutex_unlock(&local->sta_mtx);
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED))


