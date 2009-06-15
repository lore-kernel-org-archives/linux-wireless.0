Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33609 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759566AbZFOQKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 12:10:20 -0400
Subject: [PATCH 2.6.31] mac80211: fix wext bssid/ssid setting
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 18:09:45 +0200
Message-Id: <1245082185.23912.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When changing to a new BSSID or SSID, the code in
ieee80211_set_disassoc() needs to have the old data
still valid to be able to disconnect and clean up
properly. Currently, however, the old data is thrown
away before ieee80211_set_disassoc() is ever called,
so fix that by calling the function _before_ the old
data is overwritten.

This is (one of) the issue(s) causing mac80211 to hold
cfg80211's BSS structs forever, and them thus being
returned in scan results after they're long gone.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I'll be so happy when all this goes away to cfg80211...

 net/mac80211/mlme.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-06-15 17:22:34.691005518 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-06-15 17:58:42.582130381 +0200
@@ -1102,14 +1102,6 @@ static void ieee80211_set_disassoc(struc
 	struct sta_info *sta;
 	u32 changed = 0, config_changed = 0;
 
-	rcu_read_lock();
-
-	sta = sta_info_get(local, ifmgd->bssid);
-	if (!sta) {
-		rcu_read_unlock();
-		return;
-	}
-
 	if (deauth) {
 		ifmgd->direct_probe_tries = 0;
 		ifmgd->auth_tries = 0;
@@ -1120,7 +1112,14 @@ static void ieee80211_set_disassoc(struc
 	netif_tx_stop_all_queues(sdata->dev);
 	netif_carrier_off(sdata->dev);
 
-	ieee80211_sta_tear_down_BA_sessions(sta);
+	rcu_read_lock();
+	sta = sta_info_get(local, ifmgd->bssid);
+	if (sta)
+		ieee80211_sta_tear_down_BA_sessions(sta);
+	else
+		WARN(1, "Station entry for %pM (%pM) disappeared\n",
+			ifmgd->bssid, ifmgd->prev_bssid);
+	rcu_read_unlock();
 
 	bss = ieee80211_rx_bss_get(local, ifmgd->bssid,
 				   conf->channel->center_freq,
@@ -1156,8 +1155,6 @@ static void ieee80211_set_disassoc(struc
 				ifmgd->ssid, ifmgd->ssid_len);
 	}
 
-	rcu_read_unlock();
-
 	ieee80211_set_wmm_default(sdata);
 
 	ieee80211_recalc_idle(local);
@@ -2479,6 +2476,10 @@ int ieee80211_sta_set_ssid(struct ieee80
 	ifmgd = &sdata->u.mgd;
 
 	if (ifmgd->ssid_len != len || memcmp(ifmgd->ssid, ssid, len) != 0) {
+		if (ifmgd->state == IEEE80211_STA_MLME_ASSOCIATED)
+			ieee80211_set_disassoc(sdata, true, true,
+					       WLAN_REASON_DEAUTH_LEAVING);
+
 		/*
 		 * Do not use reassociation if SSID is changed (different ESS).
 		 */
@@ -2503,6 +2504,11 @@ int ieee80211_sta_set_bssid(struct ieee8
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	if (compare_ether_addr(bssid, ifmgd->bssid) != 0 &&
+	    ifmgd->state == IEEE80211_STA_MLME_ASSOCIATED)
+		ieee80211_set_disassoc(sdata, true, true,
+				       WLAN_REASON_DEAUTH_LEAVING);
+
 	if (is_valid_ether_addr(bssid)) {
 		memcpy(ifmgd->bssid, bssid, ETH_ALEN);
 		ifmgd->flags |= IEEE80211_STA_BSSID_SET;


