Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33453 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab0JTRTM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 13:19:12 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 10:19:02 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <easwar.krishnan@atheros.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 7/7] cfg80211: prefix REG_DBG_PRINT() with cfg80211
Date: Wed, 20 Oct 2010 10:18:59 -0700
Message-ID: <1287595139-10761-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1287595139-10761-1-git-send-email-lrodriguez@atheros.com>
References: <1287595139-10761-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Everyone's doing it, its the cool thing.

Cc: Easwar Krishnan <easwar.krishnan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f0ff146..9b0b011 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -48,7 +48,7 @@
 #ifdef CONFIG_CFG80211_REG_DEBUG
 #define REG_DBG_PRINT(format, args...) \
 	do { \
-		printk(KERN_DEBUG format , ## args); \
+		printk(KERN_DEBUG "cfg80211: " format , ## args); \
 	} while (0)
 #else
 #define REG_DBG_PRINT(args...)
@@ -746,12 +746,12 @@ static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
 	else
 		snprintf(max_antenna_gain, 32, "%d", power_rule->max_antenna_gain);
 
-	REG_DBG_PRINT("cfg80211: Updating information on frequency %d MHz "
+	REG_DBG_PRINT("Updating information on frequency %d MHz "
 		      "for %d a MHz width channel with regulatory rule:\n",
 		      chan->center_freq,
 		      KHZ_TO_MHZ(desired_bw_khz));
 
-	REG_DBG_PRINT("cfg80211: %d KHz - %d KHz @  KHz), (%s mBi, %d mBm)\n",
+	REG_DBG_PRINT("%d KHz - %d KHz @  KHz), (%s mBi, %d mBm)\n",
 		      freq_range->start_freq_khz,
 		      freq_range->end_freq_khz,
 		      max_antenna_gain,
@@ -818,8 +818,7 @@ static void handle_channel(struct wiphy *wiphy,
 		    r == -ERANGE)
 			return;
 
-		REG_DBG_PRINT("cfg80211: Disabling freq %d MHz\n",
-			      chan->center_freq);
+		REG_DBG_PRINT("Disabling freq %d MHz\n", chan->center_freq);
 		chan->flags = IEEE80211_CHAN_DISABLED;
 		return;
 	}
@@ -877,7 +876,7 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 			      enum nl80211_reg_initiator initiator)
 {
 	if (!last_request) {
-		REG_DBG_PRINT("cfg80211: Ignoring regulatory request %s since "
+		REG_DBG_PRINT("Ignoring regulatory request %s since "
 			      "last_request is not set\n",
 			      reg_initiator_name(initiator));
 		return true;
@@ -885,7 +884,7 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 
 	if (initiator == NL80211_REGDOM_SET_BY_CORE &&
 	    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY) {
-		REG_DBG_PRINT("cfg80211: Ignoring regulatory request %s "
+		REG_DBG_PRINT("Ignoring regulatory request %s "
 			      "since the driver uses its own custom "
 			      "regulatory domain ",
 			      reg_initiator_name(initiator));
@@ -899,7 +898,7 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 	if (wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY && !wiphy->regd &&
 	    initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    !is_world_regdom(last_request->alpha2)) {
-		REG_DBG_PRINT("cfg80211: Ignoring regulatory request %s "
+		REG_DBG_PRINT("Ignoring regulatory request %s "
 			      "since the driver requires its own regulaotry "
 			      "domain to be set first",
 			      reg_initiator_name(initiator));
@@ -1161,7 +1160,7 @@ static void handle_channel_custom(struct wiphy *wiphy,
 			       regd);
 
 	if (r) {
-		REG_DBG_PRINT("cfg80211: Disabling freq %d MHz as custom "
+		REG_DBG_PRINT("Disabling freq %d MHz as custom "
 			      "regd has no rule that fits a %d MHz "
 			      "wide channel\n",
 			      chan->center_freq,
@@ -1661,7 +1660,7 @@ static void restore_alpha2(char *alpha2, bool reset_user)
 	if (is_user_regdom_saved()) {
 		/* Unless we're asked to ignore it and reset it */
 		if (reset_user) {
-			REG_DBG_PRINT("cfg80211: Restoring regulatory settings "
+			REG_DBG_PRINT("Restoring regulatory settings "
 			       "including user preference\n");
 			user_alpha2[0] = '9';
 			user_alpha2[1] = '7';
@@ -1672,7 +1671,7 @@ static void restore_alpha2(char *alpha2, bool reset_user)
 			 * back as they were for a full restore.
 			 */
 			if (!is_world_regdom(ieee80211_regdom)) {
-				REG_DBG_PRINT("cfg80211: Keeping preference on "
+				REG_DBG_PRINT("Keeping preference on "
 				       "module parameter ieee80211_regdom: %c%c\n",
 				       ieee80211_regdom[0],
 				       ieee80211_regdom[1]);
@@ -1680,7 +1679,7 @@ static void restore_alpha2(char *alpha2, bool reset_user)
 				alpha2[1] = ieee80211_regdom[1];
 			}
 		} else {
-			REG_DBG_PRINT("cfg80211: Restoring regulatory settings "
+			REG_DBG_PRINT("Restoring regulatory settings "
 			       "while preserving user preference for: %c%c\n",
 			       user_alpha2[0],
 			       user_alpha2[1]);
@@ -1688,14 +1687,14 @@ static void restore_alpha2(char *alpha2, bool reset_user)
 			alpha2[1] = user_alpha2[1];
 		}
 	} else if (!is_world_regdom(ieee80211_regdom)) {
-		REG_DBG_PRINT("cfg80211: Keeping preference on "
+		REG_DBG_PRINT("Keeping preference on "
 		       "module parameter ieee80211_regdom: %c%c\n",
 		       ieee80211_regdom[0],
 		       ieee80211_regdom[1]);
 		alpha2[0] = ieee80211_regdom[0];
 		alpha2[1] = ieee80211_regdom[1];
 	} else
-		REG_DBG_PRINT("cfg80211: Restoring regulatory settings\n");
+		REG_DBG_PRINT("Restoring regulatory settings\n");
 }
 
 /*
@@ -1763,7 +1762,7 @@ static void restore_regulatory_settings(bool reset_user)
 
 void regulatory_hint_disconnect(void)
 {
-	REG_DBG_PRINT("cfg80211: All devices are disconnected, going to "
+	REG_DBG_PRINT("All devices are disconnected, going to "
 		      "restore regulatory settings\n");
 	restore_regulatory_settings(false);
 }
@@ -1793,7 +1792,7 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
 	if (!reg_beacon)
 		return -ENOMEM;
 
-	REG_DBG_PRINT("cfg80211: Found new beacon on "
+	REG_DBG_PRINT("Found new beacon on "
 		      "frequency: %d MHz (Ch %d) on %s\n",
 		      beacon_chan->center_freq,
 		      ieee80211_frequency_to_channel(beacon_chan->center_freq),
-- 
1.7.0.4

