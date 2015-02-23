Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35569 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbbBWXew (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 18:34:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: emmanuel.grumbach@intel.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: iterate using station list in AP SMPS
Date: Tue, 24 Feb 2015 00:34:49 +0100
Message-Id: <1424734489-19115-1-git-send-email-johannes@sipsolutions.net> (sfid-20150224_003454_686600_68CAC6A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When changing AP SMPS, we need to look up all the stations
for this interface, so there's no reason to iterate over
hash chains rather than doing the simpler iteration over
the station list.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 69 ++++++++++++++++++++++++------------------------------
 1 file changed, 30 insertions(+), 39 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index dd4ff36c557a..06557e4f9588 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2273,7 +2273,6 @@ int __ieee80211_request_smps_ap(struct ieee80211_sub_if_data *sdata,
 {
 	struct sta_info *sta;
 	enum ieee80211_smps_mode old_req;
-	int i;
 
 	if (WARN_ON_ONCE(sdata->vif.type != NL80211_IFTYPE_AP))
 		return -EINVAL;
@@ -2301,48 +2300,40 @@ int __ieee80211_request_smps_ap(struct ieee80211_sub_if_data *sdata,
 	       smps_mode, atomic_read(&sdata->u.ap.num_mcast_sta));
 
 	mutex_lock(&sdata->local->sta_mtx);
-	for (i = 0; i < STA_HASH_SIZE; i++) {
-		for (sta = rcu_dereference_protected(sdata->local->sta_hash[i],
-				lockdep_is_held(&sdata->local->sta_mtx));
-		     sta;
-		     sta = rcu_dereference_protected(sta->hnext,
-				lockdep_is_held(&sdata->local->sta_mtx))) {
-			/*
-			 * Only stations associated to our AP and
-			 * associated VLANs
-			 */
-			if (sta->sdata->bss != &sdata->u.ap)
-				continue;
+	list_for_each_entry(sta, &sdata->local->sta_list, list) {
+		/*
+		 * Only stations associated to our AP and
+		 * associated VLANs
+		 */
+		if (sta->sdata->bss != &sdata->u.ap)
+			continue;
 
-			/* This station doesn't support MIMO - skip it */
-			if (sta_info_tx_streams(sta) == 1)
-				continue;
+		/* This station doesn't support MIMO - skip it */
+		if (sta_info_tx_streams(sta) == 1)
+			continue;
 
-			/*
-			 * Don't wake up a STA just to send the action frame
-			 * unless we are getting more restrictive.
-			 */
-			if (test_sta_flag(sta, WLAN_STA_PS_STA) &&
-			    !ieee80211_smps_is_restrictive(sta->known_smps_mode,
-							   smps_mode)) {
-				ht_dbg(sdata,
-				       "Won't send SMPS to sleeping STA %pM\n",
-				       sta->sta.addr);
-				continue;
-			}
+		/*
+		 * Don't wake up a STA just to send the action frame
+		 * unless we are getting more restrictive.
+		 */
+		if (test_sta_flag(sta, WLAN_STA_PS_STA) &&
+		    !ieee80211_smps_is_restrictive(sta->known_smps_mode,
+						   smps_mode)) {
+			ht_dbg(sdata, "Won't send SMPS to sleeping STA %pM\n",
+			       sta->sta.addr);
+			continue;
+		}
 
-			/*
-			 * If the STA is not authorized, wait until it gets
-			 * authorized and the action frame will be sent then.
-			 */
-			if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED))
-				continue;
+		/*
+		 * If the STA is not authorized, wait until it gets
+		 * authorized and the action frame will be sent then.
+		 */
+		if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+			continue;
 
-			ht_dbg(sdata, "Sending SMPS to %pM\n", sta->sta.addr);
-			ieee80211_send_smps_action(sdata, smps_mode,
-						   sta->sta.addr,
-						   sdata->vif.bss_conf.bssid);
-		}
+		ht_dbg(sdata, "Sending SMPS to %pM\n", sta->sta.addr);
+		ieee80211_send_smps_action(sdata, smps_mode, sta->sta.addr,
+					   sdata->vif.bss_conf.bssid);
 	}
 	mutex_unlock(&sdata->local->sta_mtx);
 
-- 
2.1.4

