Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55133 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaLOL1Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 06:27:16 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: ask driver to look at power level when starting AP
Date: Mon, 15 Dec 2014 12:27:10 +0100
Message-Id: <1418642830-4803-1-git-send-email-johannes@sipsolutions.net> (sfid-20141215_122722_934417_5BCBF8E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The power level might have been set, but as the interface was idle
it might not have taken effect yet. Ask the driver to check the
power level when starting up an AP so that in this case the correct
power level is used in case the device/driver can only set it when
the interface is actually active.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e75d5c53e97b..169665835b6c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -678,7 +678,8 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		      BSS_CHANGED_BEACON_ENABLED |
 		      BSS_CHANGED_BEACON |
 		      BSS_CHANGED_SSID |
-		      BSS_CHANGED_P2P_PS;
+		      BSS_CHANGED_P2P_PS |
+		      BSS_CHANGED_TXPOWER;
 	int err;
 
 	old = sdata_dereference(sdata->u.ap.beacon, sdata);
-- 
2.1.1

