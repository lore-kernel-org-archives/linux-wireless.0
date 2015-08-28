Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57656 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbbH1IoZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2015 04:44:25 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: reject software RSSI CQM with beacon filtering
Date: Fri, 28 Aug 2015 10:44:20 +0200
Message-Id: <1440751460-6627-1-git-send-email-johannes@sipsolutions.net> (sfid-20150828_104430_681479_C94C1C22)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When beacon filtering is enabled the mac80211 software implementation
for RSSI CQM cannot work as beacons will not be available. Rather than
accepting such a configuration without proper effect, reject it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f4ed256c2d8e..a30ec3ce3d25 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2468,6 +2468,10 @@ static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
 	    rssi_hyst == bss_conf->cqm_rssi_hyst)
 		return 0;
 
+	if (sdata->vif.driver_flags & IEEE80211_VIF_BEACON_FILTER &&
+	    !(sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI))
+		return -EOPNOTSUPP;
+
 	bss_conf->cqm_rssi_thold = rssi_thold;
 	bss_conf->cqm_rssi_hyst = rssi_hyst;
 
-- 
2.1.4

