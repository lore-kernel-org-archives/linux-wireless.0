Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53238 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946004Ab2LFQsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:48:12 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 21/24] regulatory: pass new regdomain to reset function
Date: Thu,  6 Dec 2012 17:47:45 +0100
Message-Id: <1354812468-15709-22-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174858_802570_8C0D4D61)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of assigning after calling the function do
it inside the function. This will later avoid a
period of time where the pointer is NULL.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5a34830..ff5ac4a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -184,7 +184,8 @@ static char user_alpha2[2];
 module_param(ieee80211_regdom, charp, 0444);
 MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
 
-static void reset_regdomains(bool full_reset)
+static void reset_regdomains(bool full_reset,
+			     const struct ieee80211_regdomain *new_regdom)
 {
 	assert_cfg80211_lock();
 	assert_reg_lock();
@@ -201,7 +202,7 @@ static void reset_regdomains(bool full_reset)
 	kfree(cfg80211_world_regdom);
 
 	cfg80211_world_regdom = &world_regdom;
-	cfg80211_regdomain = NULL;
+	cfg80211_regdomain = new_regdom;
 
 	if (!full_reset)
 		return;
@@ -222,10 +223,9 @@ static void update_world_regdomain(const struct ieee80211_regdomain *rd)
 	assert_cfg80211_lock();
 	assert_reg_lock();
 
-	reset_regdomains(false);
+	reset_regdomains(false, rd);
 
 	cfg80211_world_regdom = rd;
-	cfg80211_regdomain = rd;
 }
 
 bool is_world_regdom(const char *alpha2)
@@ -1818,7 +1818,7 @@ static void restore_regulatory_settings(bool reset_user)
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
 
-	reset_regdomains(true);
+	reset_regdomains(true, cfg80211_world_regdom);
 	restore_alpha2(alpha2, reset_user);
 
 	/*
@@ -1849,9 +1849,8 @@ static void restore_regulatory_settings(bool reset_user)
 	}
 
 	/* First restore to the basic regulatory settings */
-	cfg80211_regdomain = cfg80211_world_regdom;
-	world_alpha2[0] = cfg80211_regdomain->alpha2[0];
-	world_alpha2[1] = cfg80211_regdomain->alpha2[1];
+	world_alpha2[0] = cfg80211_world_regdom->alpha2[0];
+	world_alpha2[1] = cfg80211_world_regdom->alpha2[1];
 
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		if (rdev->wiphy.flags & WIPHY_FLAG_CUSTOM_REGULATORY)
@@ -2102,8 +2101,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 
 	if (!last_request->intersect) {
 		if (last_request->initiator != NL80211_REGDOM_SET_BY_DRIVER) {
-			reset_regdomains(false);
-			cfg80211_regdomain = rd;
+			reset_regdomains(false, rd);
 			return 0;
 		}
 
@@ -2126,8 +2124,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		}
 
 		request_wiphy->regd = regd;
-		reset_regdomains(false);
-		cfg80211_regdomain = rd;
+		reset_regdomains(false, rd);
 		return 0;
 	}
 
@@ -2150,8 +2147,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 
 		rd = NULL;
 
-		reset_regdomains(false);
-		cfg80211_regdomain = intersected_rd;
+		reset_regdomains(false, intersected_rd);
 
 		return 0;
 	}
@@ -2322,7 +2318,7 @@ void regulatory_exit(void)
 	/* Lock to suppress warnings */
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
-	reset_regdomains(true);
+	reset_regdomains(true, NULL);
 	mutex_unlock(&cfg80211_mutex);
 	mutex_unlock(&reg_mutex);
 
-- 
1.8.0

