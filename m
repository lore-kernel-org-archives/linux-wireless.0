Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:37864 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3KERRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:41 -0500
Received: by mail-bk0-f43.google.com with SMTP id mz11so3092507bkb.30
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:40 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 14/19] cfg80211: move core reg_notfier() check to source
Date: Tue,  5 Nov 2013 09:18:12 -0800
Message-Id: <1383671897-7746-15-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181751_911904_876F8FA7)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers that set the WIPHY_FLAG_CUSTOM_REGULATORY skip
the core world regulatory domain updates, but do want
their reg_notifier() called. Move the check for this
closer to the source of the check that detected skipped
was required and while at it add a helper for the notifier
calling. This has no functional changes. This brings together
the place where we call the reg_notifier() will be called.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a5b3b40..e77ae8d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1223,14 +1223,30 @@ static void reg_process_ht_flags(struct wiphy *wiphy)
 		reg_process_ht_flags_band(wiphy, wiphy->bands[band]);
 }
 
+static void reg_call_notifier(struct wiphy *wiphy,
+			      struct regulatory_request *request)
+{
+	if (wiphy->reg_notifier)
+		wiphy->reg_notifier(wiphy, request);
+}
+
 static void wiphy_update_regulatory(struct wiphy *wiphy,
 				    enum nl80211_reg_initiator initiator)
 {
 	enum ieee80211_band band;
 	struct regulatory_request *lr = get_last_request();
 
-	if (ignore_reg_update(wiphy, initiator))
+	if (ignore_reg_update(wiphy, initiator)) {
+		/*
+		 * Regulatory updates set by CORE are ignored for custom
+		 * regulatory cards. Let us notify the changes to the driver,
+		 * as some drivers used this to restore its orig_* reg domain.
+		 */
+		if (initiator == NL80211_REGDOM_SET_BY_CORE &&
+		    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY)
+			reg_call_notifier(wiphy, lr);
 		return;
+	}
 
 	lr->dfs_region = get_cfg80211_regdom()->dfs_region;
 
@@ -1239,9 +1255,7 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 
 	reg_process_beacons(wiphy);
 	reg_process_ht_flags(wiphy);
-
-	if (wiphy->reg_notifier)
-		wiphy->reg_notifier(wiphy, lr);
+	reg_call_notifier(wiphy, lr);
 }
 
 static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
@@ -1254,15 +1268,6 @@ static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		wiphy = &rdev->wiphy;
 		wiphy_update_regulatory(wiphy, initiator);
-		/*
-		 * Regulatory updates set by CORE are ignored for custom
-		 * regulatory cards. Let us notify the changes to the driver,
-		 * as some drivers used this to restore its orig_* reg domain.
-		 */
-		if (initiator == NL80211_REGDOM_SET_BY_CORE &&
-		    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY &&
-		    wiphy->reg_notifier)
-			wiphy->reg_notifier(wiphy, get_last_request());
 	}
 }
 
-- 
1.8.4.rc3

