Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946084Ab2LFQwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:52:43 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/2] cfg80211: check (VHT) bandwidth against regulatory
Date: Thu,  6 Dec 2012 17:53:04 +0100
Message-Id: <1354812784-15845-3-git-send-email-johannes@sipsolutions.net> (sfid-20121206_175312_766678_F5F435BA)
In-Reply-To: <1354812784-15845-1-git-send-email-johannes@sipsolutions.net>
References: <1354812784-15845-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Now that we can access the regulatory database without
holding locks, check the desired bandwidth against it
when a channel definition is checked. This addresses
the missing VHT bandwidth check, HT is already handled
by setting flags when the regdomain changes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/chan.c | 12 +++++++++++-
 net/wireless/reg.c  | 37 ++++++++++++++++++++++++++++++-------
 net/wireless/reg.h  |  3 +++
 3 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index a7990bb..10b3475 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -10,6 +10,7 @@
 #include <net/cfg80211.h>
 #include "core.h"
 #include "rdev-ops.h"
+#include "reg.h"
 
 void cfg80211_chandef_create(struct cfg80211_chan_def *chandef,
 			     struct ieee80211_channel *chan,
@@ -201,6 +202,9 @@ static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 		c = ieee80211_get_channel(wiphy, freq);
 		if (!c || c->flags & prohibited_flags)
 			return false;
+		if (!reg_check_bandwidth(wiphy, MHZ_TO_KHZ(freq),
+					 MHZ_TO_KHZ(bandwidth)))
+			return false;
 	}
 
 	return true;
@@ -263,7 +267,13 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 		return false;
 	}
 
-	/* TODO: missing regulatory check on 80/160 bandwidth */
+	/*
+	 * TODO: What if there are only certain 80/160/80+80 MHz channels
+	 *	 allowed by the driver, or only certain combinations?
+	 *	 For 40 MHz the driver can set the NO_HT40 flags, but for
+	 *	 80/160 MHz and in particular 80+80 MHz this isn't really
+	 *	 feasible -- should we ask the driver here?
+	 */
 
 	if (width > 20)
 		prohibited_flags |= IEEE80211_CHAN_NO_OFDM;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 422b93e..d57148d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -122,13 +122,15 @@ static inline void assert_reg_lock(void)
 static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
 {
 	return rcu_dereference_protected(cfg80211_regdomain,
-					 lockdep_is_held(&reg_mutex));
+					 lockdep_is_held(&reg_mutex) ||
+					 rcu_read_lock_held());
 }
 
 static const struct ieee80211_regdomain *get_wiphy_regdom(struct wiphy *wiphy)
 {
 	return rcu_dereference_protected(wiphy->regd,
-					 lockdep_is_held(&reg_mutex));
+					 lockdep_is_held(&reg_mutex) ||
+					 rcu_read_lock_held());
 }
 
 static void rcu_free_regdom(const struct ieee80211_regdomain *r)
@@ -141,7 +143,8 @@ static void rcu_free_regdom(const struct ieee80211_regdomain *r)
 static struct regulatory_request *get_last_request(void)
 {
 	return rcu_dereference_protected(last_request,
-					 lockdep_is_held(&reg_mutex));
+					 lockdep_is_held(&reg_mutex) ||
+					 rcu_read_lock_held());
 }
 
 /* Used to queue up regulatory hints */
@@ -758,7 +761,7 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
 					       u32 center_freq)
 {
-	const struct ieee80211_regdomain *regd;
+	const struct ieee80211_regdomain *regd = NULL;
 	struct regulatory_request *lr = get_last_request();
 
 	/*
@@ -766,16 +769,36 @@ const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
 	 * IE has been processed or a user wants to help complaince further
 	 */
 	if (lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-	    lr->initiator != NL80211_REGDOM_SET_BY_USER &&
-	    wiphy->regd)
+	    lr->initiator != NL80211_REGDOM_SET_BY_USER)
 		regd = get_wiphy_regdom(wiphy);
-	else
+
+	if (!regd)
 		regd = get_cfg80211_regdom();
 
 	return freq_reg_info_regd(wiphy, center_freq, regd);
 }
 EXPORT_SYMBOL(freq_reg_info);
 
+bool reg_check_bandwidth(struct wiphy *wiphy,
+			 u32 center_freq_khz, u32 bw_khz)
+{
+	const struct ieee80211_reg_rule *reg_rule;
+
+	/*
+	 * This interpretation is a bit of a strange quirk in the regulatory
+	 * rules definitions that we have today: each 20 MHz channel must fit
+	 * entirely into a single regulatory range, but if this range forbids
+	 * using more than 20 MHz then it forbids even using a small part of
+	 * this for the wider channel.
+	 */
+
+	reg_rule = freq_reg_info(wiphy, center_freq_khz);
+	if (!IS_ERR(reg_rule))
+		return reg_rule->freq_range.max_bandwidth_khz >= bw_khz;
+
+	return false;
+}
+
 #ifdef CONFIG_CFG80211_REG_DEBUG
 static const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
 {
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index af2d5f8..d6740ab 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -35,6 +35,9 @@ int set_regdom(const struct ieee80211_regdomain *rd);
 
 bool reg_last_request_cell_base(void);
 
+bool reg_check_bandwidth(struct wiphy *wiphy,
+			 u32 center_freq_khz, u32 bw_khz);
+
 /**
  * regulatory_hint_found_beacon - hints a beacon was found on a channel
  * @wiphy: the wireless device where the beacon was found on
-- 
1.8.0

