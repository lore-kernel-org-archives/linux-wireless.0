Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57946 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab2LMU3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 15:29:08 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so1815678pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 12:29:08 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net, greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFT 2/3] cfg80211: move reg_is_world_roaming()
Date: Thu, 13 Dec 2012 12:28:53 -0800
Message-Id: <1355430534-7881-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20121213_212920_913643_63B427B3)
In-Reply-To: <1355430534-7881-1-git-send-email-mcgrof@do-not-panic.com>
References: <1355430534-7881-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This will be used later by other code. This has no
functional change.

Reported-by: Ben Greear <greearb@candelatech.com>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a2d5a03..f649b5e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1042,6 +1042,18 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 	return false;
 }
 
+static bool reg_is_world_roaming(struct wiphy *wiphy)
+{
+	if (is_world_regdom(cfg80211_regdomain->alpha2) ||
+	    (wiphy->regd && is_world_regdom(wiphy->regd->alpha2)))
+		return true;
+	if (last_request &&
+	    last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY)
+		return true;
+	return false;
+}
+
 static void handle_reg_beacon(struct wiphy *wiphy,
 			      unsigned int chan_idx,
 			      struct reg_beacon *reg_beacon)
@@ -1128,18 +1140,6 @@ static void wiphy_update_beacon_reg(struct wiphy *wiphy)
 	}
 }
 
-static bool reg_is_world_roaming(struct wiphy *wiphy)
-{
-	if (is_world_regdom(cfg80211_regdomain->alpha2) ||
-	    (wiphy->regd && is_world_regdom(wiphy->regd->alpha2)))
-		return true;
-	if (last_request &&
-	    last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-	    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY)
-		return true;
-	return false;
-}
-
 /* Reap the advantages of previously found beacons */
 static void reg_process_beacons(struct wiphy *wiphy)
 {
-- 
1.7.10.4

