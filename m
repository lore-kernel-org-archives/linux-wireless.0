Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51839 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbZBJUdE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:33:04 -0500
Message-Id: <20090210202553.674589918@sipsolutions.net> (sfid-20090210_213307_988302_A13F37B6)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:25:42 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/27] mac80211: fix beacon enable more
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hopefully the last required fix ... disable beaconing
only on beaconing interfaces, and thus avoid calling
ieee80211_if_config for purely virtual interfaces
(those driver doesn't know about).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/scan.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/scan.c	2009-02-10 20:59:27.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-02-10 20:59:30.000000000 +0100
@@ -500,7 +500,12 @@ void ieee80211_scan_completed(struct iee
 		} else
 			netif_tx_wake_all_queues(sdata->dev);
 
-		ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON_ENABLED);
+		/* re-enable beaconing */
+		if (sdata->vif.type == NL80211_IFTYPE_AP ||
+		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
+			ieee80211_if_config(sdata,
+					    IEEE80211_IFCC_BEACON_ENABLED);
 	}
 	mutex_unlock(&local->iflist_mtx);
 
@@ -656,7 +661,12 @@ int ieee80211_start_scan(struct ieee8021
 		if (!netif_running(sdata->dev))
 			continue;
 
-		ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON_ENABLED);
+		/* disable beaconing */
+		if (sdata->vif.type == NL80211_IFTYPE_AP ||
+		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
+			ieee80211_if_config(sdata,
+					    IEEE80211_IFCC_BEACON_ENABLED);
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {

-- 

