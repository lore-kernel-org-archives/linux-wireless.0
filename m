Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33534 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbbLKOfm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 09:35:42 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: remove CFG80211_REG_DEBUG
Date: Fri, 11 Dec 2015 15:35:38 +0100
Message-Id: <1449844538-28228-1-git-send-email-johannes@sipsolutions.net> (sfid-20151211_153546_424491_72032DE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of having this Kconfig option, which just *floods* the
kernel log,
 * remove the per-channel prints that are fairly useless anyway
 * convert the conditional printing to pr_debug()

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/Kconfig |  13 ------
 net/wireless/reg.c   | 122 ++++++++++++++-------------------------------------
 2 files changed, 34 insertions(+), 101 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index da72ed32f143..ec3bf30dd526 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -61,19 +61,6 @@ config CFG80211_DEVELOPER_WARNINGS
 	  on it (or mac80211).
 
 
-config CFG80211_REG_DEBUG
-	bool "cfg80211 regulatory debugging"
-	depends on CFG80211
-	default n
-	---help---
-	  You can enable this if you want to debug regulatory changes.
-	  For more information on cfg80211 regulatory refer to the wireless
-	  wiki:
-
-	  http://wireless.kernel.org/en/developers/Regulatory
-
-	  If unsure, say N.
-
 config CFG80211_CERTIFICATION_ONUS
 	bool "cfg80211 certification onus"
 	depends on CFG80211 && EXPERT
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 0a4f5481ab83..6c1ea28f73cf 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -60,13 +60,6 @@
 #include "regdb.h"
 #include "nl80211.h"
 
-#ifdef CONFIG_CFG80211_REG_DEBUG
-#define REG_DBG_PRINT(format, args...)			\
-	printk(KERN_DEBUG pr_fmt(format), ##args)
-#else
-#define REG_DBG_PRINT(args...)
-#endif
-
 /*
  * Grace period we give before making sure all current interfaces reside on
  * channels allowed by the current regulatory domain.
@@ -178,12 +171,10 @@ enum nl80211_dfs_regions reg_get_dfs_region(struct wiphy *wiphy)
 	if (wiphy_regd->dfs_region == regd->dfs_region)
 		goto out;
 
-	REG_DBG_PRINT("%s: device specific dfs_region "
-		      "(%s) disagrees with cfg80211's "
-		      "central dfs_region (%s)\n",
-		      dev_name(&wiphy->dev),
-		      reg_dfs_region_str(wiphy_regd->dfs_region),
-		      reg_dfs_region_str(regd->dfs_region));
+	pr_debug("%s: device specific dfs_region (%s) disagrees with cfg80211's central dfs_region (%s)\n",
+		 dev_name(&wiphy->dev),
+		 reg_dfs_region_str(wiphy_regd->dfs_region),
+		 reg_dfs_region_str(regd->dfs_region));
 
 out:
 	return regd->dfs_region;
@@ -541,7 +532,7 @@ static DECLARE_DELAYED_WORK(crda_timeout, crda_timeout_work);
 
 static void crda_timeout_work(struct work_struct *work)
 {
-	REG_DBG_PRINT("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
+	pr_debug("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
 	rtnl_lock();
 	reg_crda_timeouts++;
 	restore_regulatory_settings(true);
@@ -583,7 +574,7 @@ static int call_crda(const char *alpha2)
 
 	if (!is_world_regdom((char *) alpha2))
 		pr_debug("Calling CRDA for country: %c%c\n",
-			alpha2[0], alpha2[1]);
+			 alpha2[0], alpha2[1]);
 	else
 		pr_debug("Calling CRDA to update world regulatory domain\n");
 
@@ -1130,42 +1121,6 @@ const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
 }
 EXPORT_SYMBOL(reg_initiator_name);
 
-static void chan_reg_rule_print_dbg(const struct ieee80211_regdomain *regd,
-				    struct ieee80211_channel *chan,
-				    const struct ieee80211_reg_rule *reg_rule)
-{
-#ifdef CONFIG_CFG80211_REG_DEBUG
-	const struct ieee80211_power_rule *power_rule;
-	const struct ieee80211_freq_range *freq_range;
-	char max_antenna_gain[32], bw[32];
-
-	power_rule = &reg_rule->power_rule;
-	freq_range = &reg_rule->freq_range;
-
-	if (!power_rule->max_antenna_gain)
-		snprintf(max_antenna_gain, sizeof(max_antenna_gain), "N/A");
-	else
-		snprintf(max_antenna_gain, sizeof(max_antenna_gain), "%d mBi",
-			 power_rule->max_antenna_gain);
-
-	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
-		snprintf(bw, sizeof(bw), "%d KHz, %d KHz AUTO",
-			 freq_range->max_bandwidth_khz,
-			 reg_get_max_bandwidth(regd, reg_rule));
-	else
-		snprintf(bw, sizeof(bw), "%d KHz",
-			 freq_range->max_bandwidth_khz);
-
-	REG_DBG_PRINT("Updating information on frequency %d MHz with regulatory rule:\n",
-		      chan->center_freq);
-
-	REG_DBG_PRINT("(%d KHz - %d KHz @ %s), (%s, %d mBm)\n",
-		      freq_range->start_freq_khz, freq_range->end_freq_khz,
-		      bw, max_antenna_gain,
-		      power_rule->max_eirp);
-#endif
-}
-
 static uint32_t reg_rule_to_chan_bw_flags(const struct ieee80211_regdomain *regd,
 					  const struct ieee80211_reg_rule *reg_rule,
 					  const struct ieee80211_channel *chan)
@@ -1240,20 +1195,19 @@ static void handle_channel(struct wiphy *wiphy,
 		if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 		    request_wiphy && request_wiphy == wiphy &&
 		    request_wiphy->regulatory_flags & REGULATORY_STRICT_REG) {
-			REG_DBG_PRINT("Disabling freq %d MHz for good\n",
-				      chan->center_freq);
+			pr_debug("Disabling freq %d MHz for good\n",
+				 chan->center_freq);
 			chan->orig_flags |= IEEE80211_CHAN_DISABLED;
 			chan->flags = chan->orig_flags;
 		} else {
-			REG_DBG_PRINT("Disabling freq %d MHz\n",
-				      chan->center_freq);
+			pr_debug("Disabling freq %d MHz\n",
+				 chan->center_freq);
 			chan->flags |= IEEE80211_CHAN_DISABLED;
 		}
 		return;
 	}
 
 	regd = reg_get_regdomain(wiphy);
-	chan_reg_rule_print_dbg(regd, chan, reg_rule);
 
 	power_rule = &reg_rule->power_rule;
 	bw_flags = reg_rule_to_chan_bw_flags(regd, reg_rule, chan);
@@ -1391,18 +1345,15 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 		return true;
 
 	if (!lr) {
-		REG_DBG_PRINT("Ignoring regulatory request set by %s "
-			      "since last_request is not set\n",
-			      reg_initiator_name(initiator));
+		pr_debug("Ignoring regulatory request set by %s since last_request is not set\n",
+			 reg_initiator_name(initiator));
 		return true;
 	}
 
 	if (initiator == NL80211_REGDOM_SET_BY_CORE &&
 	    wiphy->regulatory_flags & REGULATORY_CUSTOM_REG) {
-		REG_DBG_PRINT("Ignoring regulatory request set by %s "
-			      "since the driver uses its own custom "
-			      "regulatory domain\n",
-			      reg_initiator_name(initiator));
+		pr_debug("Ignoring regulatory request set by %s since the driver uses its own custom regulatory domain\n",
+			 reg_initiator_name(initiator));
 		return true;
 	}
 
@@ -1413,10 +1364,8 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 	if (wiphy_strict_alpha2_regd(wiphy) && !wiphy->regd &&
 	    initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    !is_world_regdom(lr->alpha2)) {
-		REG_DBG_PRINT("Ignoring regulatory request set by %s "
-			      "since the driver requires its own regulatory "
-			      "domain to be set first\n",
-			      reg_initiator_name(initiator));
+		pr_debug("Ignoring regulatory request set by %s since the driver requires its own regulatory domain to be set first\n",
+			 reg_initiator_name(initiator));
 		return true;
 	}
 
@@ -1697,7 +1646,7 @@ static void reg_check_chans_work(struct work_struct *work)
 {
 	struct cfg80211_registered_device *rdev;
 
-	REG_DBG_PRINT("Verifying active interfaces after reg change\n");
+	pr_debug("Verifying active interfaces after reg change\n");
 	rtnl_lock();
 
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list)
@@ -1779,8 +1728,8 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	}
 
 	if (IS_ERR(reg_rule)) {
-		REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits it\n",
-			      chan->center_freq);
+		pr_debug("Disabling freq %d MHz as custom regd has no rule that fits it\n",
+			 chan->center_freq);
 		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
 			chan->flags |= IEEE80211_CHAN_DISABLED;
 		} else {
@@ -1790,8 +1739,6 @@ static void handle_channel_custom(struct wiphy *wiphy,
 		return;
 	}
 
-	chan_reg_rule_print_dbg(regd, chan, reg_rule);
-
 	power_rule = &reg_rule->power_rule;
 	bw_flags = reg_rule_to_chan_bw_flags(regd, reg_rule, chan);
 
@@ -2522,7 +2469,7 @@ static void restore_alpha2(char *alpha2, bool reset_user)
 	if (is_user_regdom_saved()) {
 		/* Unless we're asked to ignore it and reset it */
 		if (reset_user) {
-			REG_DBG_PRINT("Restoring regulatory settings including user preference\n");
+			pr_debug("Restoring regulatory settings including user preference\n");
 			user_alpha2[0] = '9';
 			user_alpha2[1] = '7';
 
@@ -2532,24 +2479,24 @@ static void restore_alpha2(char *alpha2, bool reset_user)
 			 * back as they were for a full restore.
 			 */
 			if (!is_world_regdom(ieee80211_regdom)) {
-				REG_DBG_PRINT("Keeping preference on module parameter ieee80211_regdom: %c%c\n",
-					      ieee80211_regdom[0], ieee80211_regdom[1]);
+				pr_debug("Keeping preference on module parameter ieee80211_regdom: %c%c\n",
+					 ieee80211_regdom[0], ieee80211_regdom[1]);
 				alpha2[0] = ieee80211_regdom[0];
 				alpha2[1] = ieee80211_regdom[1];
 			}
 		} else {
-			REG_DBG_PRINT("Restoring regulatory settings while preserving user preference for: %c%c\n",
-				      user_alpha2[0], user_alpha2[1]);
+			pr_debug("Restoring regulatory settings while preserving user preference for: %c%c\n",
+				 user_alpha2[0], user_alpha2[1]);
 			alpha2[0] = user_alpha2[0];
 			alpha2[1] = user_alpha2[1];
 		}
 	} else if (!is_world_regdom(ieee80211_regdom)) {
-		REG_DBG_PRINT("Keeping preference on module parameter ieee80211_regdom: %c%c\n",
-			      ieee80211_regdom[0], ieee80211_regdom[1]);
+		pr_debug("Keeping preference on module parameter ieee80211_regdom: %c%c\n",
+			 ieee80211_regdom[0], ieee80211_regdom[1]);
 		alpha2[0] = ieee80211_regdom[0];
 		alpha2[1] = ieee80211_regdom[1];
 	} else
-		REG_DBG_PRINT("Restoring regulatory settings\n");
+		pr_debug("Restoring regulatory settings\n");
 }
 
 static void restore_custom_reg_settings(struct wiphy *wiphy)
@@ -2661,14 +2608,14 @@ static void restore_regulatory_settings(bool reset_user)
 	list_splice_tail_init(&tmp_reg_req_list, &reg_requests_list);
 	spin_unlock(&reg_requests_lock);
 
-	REG_DBG_PRINT("Kicking the queue\n");
+	pr_debug("Kicking the queue\n");
 
 	schedule_work(&reg_work);
 }
 
 void regulatory_hint_disconnect(void)
 {
-	REG_DBG_PRINT("All devices are disconnected, going to restore regulatory settings\n");
+	pr_debug("All devices are disconnected, going to restore regulatory settings\n");
 	restore_regulatory_settings(false);
 }
 
@@ -2716,10 +2663,10 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
 	if (!reg_beacon)
 		return -ENOMEM;
 
-	REG_DBG_PRINT("Found new beacon on frequency: %d MHz (Ch %d) on %s\n",
-		      beacon_chan->center_freq,
-		      ieee80211_frequency_to_channel(beacon_chan->center_freq),
-		      wiphy_name(wiphy));
+	pr_debug("Found new beacon on frequency: %d MHz (Ch %d) on %s\n",
+		 beacon_chan->center_freq,
+		 ieee80211_frequency_to_channel(beacon_chan->center_freq),
+		 wiphy_name(wiphy));
 
 	memcpy(&reg_beacon->chan, beacon_chan,
 	       sizeof(struct ieee80211_channel));
@@ -2798,8 +2745,7 @@ bool reg_supported_dfs_region(enum nl80211_dfs_regions dfs_region)
 	case NL80211_DFS_JP:
 		return true;
 	default:
-		REG_DBG_PRINT("Ignoring uknown DFS master region: %d\n",
-			      dfs_region);
+		pr_debug("Ignoring uknown DFS master region: %d\n", dfs_region);
 		return false;
 	}
 }
-- 
2.6.2

