Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51823 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYIOIak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 04:30:40 -0400
Subject: [PATCH] cfg80211: fix static regdomains
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 10:30:34 +0200
Message-Id: <1221467435.3700.27.camel@johannes.berg> (sfid-20080915_103044_560057_24DB1061)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When Luis added the static regdomains back he used +/-20
of the centre frequencies to account for 40MHz bandwidth
neglecting the fact that 40MHz bandwidth cannot be used
on the channels close to the allowed band edges.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Maybe this bandwidth vs. centre frequency and band use is
just too complicated?

 net/wireless/core.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- everything.orig/net/wireless/core.c	2008-09-15 10:23:47.000000000 +0200
+++ everything/net/wireless/core.c	2008-09-15 10:24:27.000000000 +0200
@@ -41,7 +41,7 @@ const struct ieee80211_regdomain world_r
 	.n_reg_rules = 1,
 	.alpha2 =  "00",
 	.reg_rules = {
-		REG_RULE(2402, 2472, 40, 6, 20,
+		REG_RULE(2412-10, 2462+10, 40, 6, 20,
 			NL80211_RRF_PASSIVE_SCAN |
 			NL80211_RRF_NO_IBSS),
 	}
@@ -64,17 +64,17 @@ const struct ieee80211_regdomain us_regd
 	.alpha2 =  "US",
 	.reg_rules = {
 		/* IEEE 802.11b/g, channels 1..11 */
-		REG_RULE(2412-20, 2462+20, 40, 6, 27, 0),
+		REG_RULE(2412-10, 2462+10, 40, 6, 27, 0),
 		/* IEEE 802.11a, channel 36 */
-		REG_RULE(5180-20, 5180+20, 40, 6, 23, 0),
+		REG_RULE(5180-10, 5180+10, 40, 6, 23, 0),
 		/* IEEE 802.11a, channel 40 */
-		REG_RULE(5200-20, 5200+20, 40, 6, 23, 0),
+		REG_RULE(5200-10, 5200+10, 40, 6, 23, 0),
 		/* IEEE 802.11a, channel 44 */
-		REG_RULE(5220-20, 5220+20, 40, 6, 23, 0),
+		REG_RULE(5220-10, 5220+10, 40, 6, 23, 0),
 		/* IEEE 802.11a, channels 48..64 */
-		REG_RULE(5240-20, 5320+20, 40, 6, 23, 0),
+		REG_RULE(5240-10, 5320+10, 40, 6, 23, 0),
 		/* IEEE 802.11a, channels 149..165, outdoor */
-		REG_RULE(5745-20, 5825+20, 40, 6, 30, 0),
+		REG_RULE(5745-10, 5825+10, 40, 6, 30, 0),
 	}
 };
 
@@ -83,12 +83,12 @@ const struct ieee80211_regdomain jp_regd
 	.alpha2 =  "JP",
 	.reg_rules = {
 		/* IEEE 802.11b/g, channels 1..14 */
-		REG_RULE(2412-20, 2484+20, 40, 6, 20, 0),
+		REG_RULE(2412-10, 2484+10, 40, 6, 20, 0),
 		/* IEEE 802.11a, channels 34..48 */
-		REG_RULE(5170-20, 5240+20, 40, 6, 20,
+		REG_RULE(5170-10, 5240+10, 40, 6, 20,
 			NL80211_RRF_PASSIVE_SCAN),
 		/* IEEE 802.11a, channels 52..64 */
-		REG_RULE(5260-20, 5320+20, 40, 6, 20,
+		REG_RULE(5260-10, 5320+10, 40, 6, 20,
 			NL80211_RRF_NO_IBSS |
 			NL80211_RRF_DFS),
 	}
@@ -101,22 +101,22 @@ const struct ieee80211_regdomain eu_regd
 	.alpha2 =  "EU",
 	.reg_rules = {
 		/* IEEE 802.11b/g, channels 1..13 */
-		REG_RULE(2412-20, 2472+20, 40, 6, 20, 0),
+		REG_RULE(2412-10, 2472+10, 40, 6, 20, 0),
 		/* IEEE 802.11a, channel 36 */
-		REG_RULE(5180-20, 5180+20, 40, 6, 23,
+		REG_RULE(5180-10, 5180+10, 40, 6, 23,
 			NL80211_RRF_PASSIVE_SCAN),
 		/* IEEE 802.11a, channel 40 */
-		REG_RULE(5200-20, 5200+20, 40, 6, 23,
+		REG_RULE(5200-10, 5200+10, 40, 6, 23,
 			NL80211_RRF_PASSIVE_SCAN),
 		/* IEEE 802.11a, channel 44 */
-		REG_RULE(5220-20, 5220+20, 40, 6, 23,
+		REG_RULE(5220-10, 5220+10, 40, 6, 23,
 			NL80211_RRF_PASSIVE_SCAN),
 		/* IEEE 802.11a, channels 48..64 */
-		REG_RULE(5240-20, 5320+20, 40, 6, 20,
+		REG_RULE(5240-10, 5320+10, 40, 6, 20,
 			NL80211_RRF_NO_IBSS |
 			NL80211_RRF_DFS),
 		/* IEEE 802.11a, channels 100..140 */
-		REG_RULE(5500-20, 5700+20, 40, 6, 30,
+		REG_RULE(5500-10, 5700+10, 40, 6, 30,
 			NL80211_RRF_NO_IBSS |
 			NL80211_RRF_DFS),
 	}


