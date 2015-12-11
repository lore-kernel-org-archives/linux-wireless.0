Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34068 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbbLKQh2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 11:37:28 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] regulatory: fix world regulatory domain data
Date: Fri, 11 Dec 2015 17:37:24 +0100
Message-Id: <1449851844-26797-1-git-send-email-johannes@sipsolutions.net> (sfid-20151211_173734_090523_E06A49FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The precise rule definition here isn't really valid, it would
be rejected if it came from userspace due to the bandwidth it
specifies being bigger than the rule's width.

This is fairly much inconsequential since the other rule before
it does enable the bandwidth, but express that better by using
the NL80211_RRF_AUTO_BW flag.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d53ef141055b..ce8b78fc8525 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -222,8 +222,8 @@ static const struct ieee80211_regdomain world_regdom = {
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
-- 
2.6.2

