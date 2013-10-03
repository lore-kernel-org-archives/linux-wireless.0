Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:34128 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab3JCBdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 21:33:21 -0400
Received: by mail-oa0-f54.google.com with SMTP id n5so1674040oag.41
        for <linux-wireless@vger.kernel.org>; Wed, 02 Oct 2013 18:33:20 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com
Subject: [PATCH 2/2] cfg80211: simplfy strict custom alpha2 regdomain check
Date: Wed,  2 Oct 2013 18:33:10 -0700
Message-Id: <1380763990-5981-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131003_033323_564404_CEA4CC72)
In-Reply-To: <1380763990-5981-1-git-send-email-mcgrof@do-not-panic.com>
References: <1380763990-5981-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it easier to read.

Cc: smihir@qti.qualcomm.com
Cc: tushnimb@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9b488c7..ec3d45e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -964,6 +964,13 @@ static bool reg_dev_ignore_cell_hint(struct wiphy *wiphy)
 }
 #endif
 
+static bool wiphy_strict_alpha2_regd(struct wiphy *wiphy)
+{
+	if (wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY &&
+	    !(wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY))
+		return true;
+	return false;
+}
 
 static bool ignore_reg_update(struct wiphy *wiphy,
 			      enum nl80211_reg_initiator initiator)
@@ -990,9 +997,8 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 	 * wiphy->regd will be set once the device has its own
 	 * desired regulatory domain set
 	 */
-	if (wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY && !wiphy->regd &&
+	if (wiphy_strict_alpha2_regd(wiphy) && !wiphy->regd &&
 	    initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-	    !(wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY) &&
 	    !is_world_regdom(lr->alpha2)) {
 		REG_DBG_PRINT("Ignoring regulatory request set by %s "
 			      "since the driver requires its own regulatory "
-- 
1.8.4.rc3

