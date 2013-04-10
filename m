Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32878 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932803Ab3DJTym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 15:54:42 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH] mac80211: remove warning from ieee80211_beacon_loss
Date: Wed, 10 Apr 2013 21:54:33 +0200
Message-Id: <1365623673-2368-1-git-send-email-johannes@sipsolutions.net> (sfid-20130410_215447_644627_5CA90C05)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Currently, mac80211 assumes that connection monitor offload
for BSS station implies that the device:
- sends periodic keep alive packets to associated AP
- monitors missed beacons
- actively probes the AP in case of missed beacons

In case of poor connection conditions it expects the function
ieee80211_connection_loss() to be called by driver. However,
some devices implement connection monitor offload excluding
active AP probing.

To allow them to call ieee80211_beacon_loss() cleanly, remove
the warning there and thus allow them to use mac80211 for the
AP probing even if connection monitor offload is supported.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 43023f0..c7860d0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2215,7 +2215,6 @@ void ieee80211_beacon_loss(struct ieee80211_vif *vif)
 
 	trace_api_beacon_loss(sdata);
 
-	WARN_ON(hw->flags & IEEE80211_HW_CONNECTION_MONITOR);
 	sdata->u.mgd.connection_loss = false;
 	ieee80211_queue_work(hw, &sdata->u.mgd.beacon_connection_loss_work);
 }
-- 
1.8.0

