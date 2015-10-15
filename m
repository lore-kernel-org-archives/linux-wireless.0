Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37503 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbbJOJrC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 05:47:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/6] cfg80211: reg: remove useless reg_timeout scheduling
Date: Thu, 15 Oct 2015 11:46:56 +0200
Message-Id: <1444902418-25668-4-git-send-email-johannes@sipsolutions.net> (sfid-20151015_114717_772010_A111B53F)
In-Reply-To: <1444902418-25668-1-git-send-email-johannes@sipsolutions.net>
References: <1444902418-25668-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the functions reg_set_rd_driver() and reg_set_rd_country_ie()
return with an error, the calling function already restores data
by calling restore_regulatory_settings(), so there's no need to
also schedule a timeout (which would lead to other side effects
such as indicating CRDA failed, which clearly isn't true.) Remove
the scheduling.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6ad01b264eb0..3c4363be6bb0 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2885,11 +2885,8 @@ static int reg_set_rd_driver(const struct ieee80211_regdomain *rd,
 	}
 
 	request_wiphy = wiphy_idx_to_wiphy(driver_request->wiphy_idx);
-	if (!request_wiphy) {
-		queue_delayed_work(system_power_efficient_wq,
-				   &reg_timeout, 0);
+	if (!request_wiphy)
 		return -ENODEV;
-	}
 
 	if (!driver_request->intersect) {
 		if (request_wiphy->regd)
@@ -2946,11 +2943,8 @@ static int reg_set_rd_country_ie(const struct ieee80211_regdomain *rd,
 	}
 
 	request_wiphy = wiphy_idx_to_wiphy(country_ie_request->wiphy_idx);
-	if (!request_wiphy) {
-		queue_delayed_work(system_power_efficient_wq,
-				   &reg_timeout, 0);
+	if (!request_wiphy)
 		return -ENODEV;
-	}
 
 	if (country_ie_request->intersect)
 		return -EINVAL;
-- 
2.5.1

