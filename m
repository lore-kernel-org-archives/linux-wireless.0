Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49052 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbaFXONe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 10:13:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.16] nl80211: move set_qos_map command into split state
Date: Tue, 24 Jun 2014 16:13:23 +0200
Message-Id: <1403619203-18822-1-git-send-email-johannes@sipsolutions.net> (sfid-20140624_161337_471508_65914D9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The non-split wiphy state shouldn't be increased in size
so move the new set_qos_map command into the split if
statement.

Cc: stable@vger.kernel.org (3.14+)
Fixes: fa9ffc745610 ("cfg80211: Add support for QoS mapping")
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ba4f1723c83a..6668daf69326 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1497,18 +1497,17 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		}
 		CMD(start_p2p_device, START_P2P_DEVICE);
 		CMD(set_mcast_rate, SET_MCAST_RATE);
+#ifdef CONFIG_NL80211_TESTMODE
+		CMD(testmode_cmd, TESTMODE);
+#endif
 		if (state->split) {
 			CMD(crit_proto_start, CRIT_PROTOCOL_START);
 			CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
 			if (rdev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH)
 				CMD(channel_switch, CHANNEL_SWITCH);
+			CMD(set_qos_map, SET_QOS_MAP);
 		}
-		CMD(set_qos_map, SET_QOS_MAP);
-
-#ifdef CONFIG_NL80211_TESTMODE
-		CMD(testmode_cmd, TESTMODE);
-#endif
-
+		/* add into the if now */
 #undef CMD
 
 		if (rdev->ops->connect || rdev->ops->auth) {
-- 
2.0.0

