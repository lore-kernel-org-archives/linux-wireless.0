Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34109 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbbLKQn7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 11:43:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] regulatory: fix world regulatory domain data
Date: Fri, 11 Dec 2015 17:43:56 +0100
Message-Id: <1449852236-27022-1-git-send-email-johannes@sipsolutions.net> (sfid-20151211_174402_255168_7C034B6A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The rule definitions here aren't really valid, they would
be rejected if it came from userspace due to the bandwidth
specified being bigger than the rule's width.

This is fairly much inconsequential since the other rules
around them do enable the bandwidth, but express that better
using the NL80211_RRF_AUTO_BW flag.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d53ef141055b..6474d42b40a9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -222,20 +222,22 @@ static const struct ieee80211_regdomain world_regdom = {
 		/* IEEE 802.11b/g, channels 1..11 */
 		REG_RULE(2412-10, 2462+10, 40, 6, 20, 0),
 		/* IEEE 802.11b/g, channels 12..13. */
-		REG_RULE(2467-10, 2472+10, 40, 6, 20,
-			NL80211_RRF_NO_IR),
+		REG_RULE(2467-10, 2472+10, 20, 6, 20,
+			NL80211_RRF_NO_IR | NL80211_RRF_AUTO_BW),
 		/* IEEE 802.11 channel 14 - Only JP enables
 		 * this and for 802.11b only */
 		REG_RULE(2484-10, 2484+10, 20, 6, 20,
 			NL80211_RRF_NO_IR |
 			NL80211_RRF_NO_OFDM),
 		/* IEEE 802.11a, channel 36..48 */
-		REG_RULE(5180-10, 5240+10, 160, 6, 20,
-                        NL80211_RRF_NO_IR),
+		REG_RULE(5180-10, 5240+10, 80, 6, 20,
+                        NL80211_RRF_NO_IR |
+                        NL80211_RRF_AUTO_BW),
 
 		/* IEEE 802.11a, channel 52..64 - DFS required */
-		REG_RULE(5260-10, 5320+10, 160, 6, 20,
+		REG_RULE(5260-10, 5320+10, 80, 6, 20,
 			NL80211_RRF_NO_IR |
+			NL80211_RRF_AUTO_BW |
 			NL80211_RRF_DFS),
 
 		/* IEEE 802.11a, channel 100..144 - DFS required */
-- 
2.6.2

