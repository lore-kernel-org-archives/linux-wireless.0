Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59420 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbZLIUaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 15:30:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@gmail.com, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: update old static regulatory domain rules
Date: Wed,  9 Dec 2009 15:15:24 -0500
Message-Id: <1260389724-2392-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update "US" and "JP" for current rules, and replace "EU" rules with the
world roaming domain (since it was only a pseudo-domain anyway).

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/reg.c |   75 +++++++++++++++++----------------------------------
 1 files changed, 25 insertions(+), 50 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c01470e..baa898a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -141,62 +141,35 @@ static const struct ieee80211_regdomain us_regdom = {
 	.reg_rules = {
 		/* IEEE 802.11b/g, channels 1..11 */
 		REG_RULE(2412-10, 2462+10, 40, 6, 27, 0),
-		/* IEEE 802.11a, channel 36 */
-		REG_RULE(5180-10, 5180+10, 40, 6, 23, 0),
-		/* IEEE 802.11a, channel 40 */
-		REG_RULE(5200-10, 5200+10, 40, 6, 23, 0),
-		/* IEEE 802.11a, channel 44 */
-		REG_RULE(5220-10, 5220+10, 40, 6, 23, 0),
+		/* IEEE 802.11a, channel 36..48 */
+		REG_RULE(5180-10, 5240+10, 40, 6, 17, 0),
 		/* IEEE 802.11a, channels 48..64 */
-		REG_RULE(5240-10, 5320+10, 40, 6, 23, 0),
+		REG_RULE(5260-10, 5320+10, 40, 6, 20, NL80211_RRF_DFS),
+		/* IEEE 802.11a, channels 100..124 */
+		REG_RULE(5500-10, 5590+10, 40, 6, 20, NL80211_RRF_DFS),
+		/* IEEE 802.11a, channels 132..144 */
+		REG_RULE(5660-10, 5700+10, 40, 6, 20, NL80211_RRF_DFS),
 		/* IEEE 802.11a, channels 149..165, outdoor */
 		REG_RULE(5745-10, 5825+10, 40, 6, 30, 0),
 	}
 };
 
 static const struct ieee80211_regdomain jp_regdom = {
-	.n_reg_rules = 3,
+	.n_reg_rules = 6,
 	.alpha2 =  "JP",
 	.reg_rules = {
-		/* IEEE 802.11b/g, channels 1..14 */
-		REG_RULE(2412-10, 2484+10, 40, 6, 20, 0),
-		/* IEEE 802.11a, channels 34..48 */
-		REG_RULE(5170-10, 5240+10, 40, 6, 20,
-			NL80211_RRF_PASSIVE_SCAN),
+		/* IEEE 802.11b/g, channels 1..11 */
+		REG_RULE(2412-10, 2462+10, 40, 6, 20, 0),
+		/* IEEE 802.11b/g, channels 12..13 */
+		REG_RULE(2467-10, 2472+10, 20, 6, 20, 0),
+		/* IEEE 802.11b/g, channel 14 */
+		REG_RULE(2484-10, 2484+10, 20, 6, 20, NL80211_RRF_NO_OFDM),
+		/* IEEE 802.11a, channels 36..48 */
+		REG_RULE(5180-10, 5240+10, 40, 6, 20, 0),
 		/* IEEE 802.11a, channels 52..64 */
-		REG_RULE(5260-10, 5320+10, 40, 6, 20,
-			NL80211_RRF_NO_IBSS |
-			NL80211_RRF_DFS),
-	}
-};
-
-static const struct ieee80211_regdomain eu_regdom = {
-	.n_reg_rules = 6,
-	/*
-	 * This alpha2 is bogus, we leave it here just for stupid
-	 * backward compatibility
-	 */
-	.alpha2 =  "EU",
-	.reg_rules = {
-		/* IEEE 802.11b/g, channels 1..13 */
-		REG_RULE(2412-10, 2472+10, 40, 6, 20, 0),
-		/* IEEE 802.11a, channel 36 */
-		REG_RULE(5180-10, 5180+10, 40, 6, 23,
-			NL80211_RRF_PASSIVE_SCAN),
-		/* IEEE 802.11a, channel 40 */
-		REG_RULE(5200-10, 5200+10, 40, 6, 23,
-			NL80211_RRF_PASSIVE_SCAN),
-		/* IEEE 802.11a, channel 44 */
-		REG_RULE(5220-10, 5220+10, 40, 6, 23,
-			NL80211_RRF_PASSIVE_SCAN),
-		/* IEEE 802.11a, channels 48..64 */
-		REG_RULE(5240-10, 5320+10, 40, 6, 20,
-			NL80211_RRF_NO_IBSS |
-			NL80211_RRF_DFS),
-		/* IEEE 802.11a, channels 100..140 */
-		REG_RULE(5500-10, 5700+10, 40, 6, 30,
-			NL80211_RRF_NO_IBSS |
-			NL80211_RRF_DFS),
+		REG_RULE(5260-10, 5320+10, 40, 6, 20, NL80211_RRF_DFS),
+		/* IEEE 802.11a, channels 100..144 */
+		REG_RULE(5500-10, 5700+10, 40, 6, 23, NL80211_RRF_DFS),
 	}
 };
 
@@ -206,15 +179,17 @@ static const struct ieee80211_regdomain *static_regdom(char *alpha2)
 		return &us_regdom;
 	if (alpha2[0] == 'J' && alpha2[1] == 'P')
 		return &jp_regdom;
+	/* Use world roaming rules for "EU", since it was a pseudo
+	   domain anyway... */
 	if (alpha2[0] == 'E' && alpha2[1] == 'U')
-		return &eu_regdom;
-	/* Default, as per the old rules */
-	return &us_regdom;
+		return &world_regdom;
+	/* Default, world roaming rules */
+	return &world_regdom;
 }
 
 static bool is_old_static_regdom(const struct ieee80211_regdomain *rd)
 {
-	if (rd == &us_regdom || rd == &jp_regdom || rd == &eu_regdom)
+	if (rd == &us_regdom || rd == &jp_regdom || rd == &world_regdom)
 		return true;
 	return false;
 }
-- 
1.6.2.5

