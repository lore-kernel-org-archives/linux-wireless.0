Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46986 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbZH0Xe6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 19:34:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/2] cfg80211: initialize rate control after station inserted
Date: Thu, 27 Aug 2009 16:34:53 -0700
Message-Id: <1251416094-10420-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Station information may be needed by rate control algorithms, so call rate
scaling initialization after adding the station.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 net/mac80211/cfg.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5608f6c..598db11 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -729,8 +729,6 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 
 	sta_apply_parameters(local, sta, params);
 
-	rate_control_rate_init(sta);
-
 	layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
 		sdata->vif.type == NL80211_IFTYPE_AP;
 
@@ -742,13 +740,17 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 		if (err == -EEXIST && layer2_update) {
 			/* Need to update layer 2 devices on reassociation */
 			sta = sta_info_get(local, mac);
-			if (sta)
+			if (sta) {
+				rate_control_rate_init(sta);
 				ieee80211_send_layer2_update(sta);
+			}
 		}
 		rcu_read_unlock();
 		return err;
 	}
 
+	rate_control_rate_init(sta);
+
 	if (layer2_update)
 		ieee80211_send_layer2_update(sta);
 
-- 
1.5.6.3

