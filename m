Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2765 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733198AbeGTULa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jul 2018 16:11:30 -0400
From: Amar Singhal <asinghal@codeaurora.org>
To: johannes@sipsolutions.net
Cc: jouni@codeaurora.org, jjohnson@codeaurora.org,
        linux-wireless@vger.kernel.org,
        Amar Singhal <asinghal@codeaurora.org>
Subject: [PATCH] cfg80211: Do not ignore user regulatory hint
Date: Fri, 20 Jul 2018 12:15:18 -0700
Message-Id: <1532114118-32141-1-git-send-email-asinghal@codeaurora.org> (sfid-20180720_212155_515377_E5293AE4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently user regulatory hint is ignored if all wiphys
in the system are self managed. But the hint is not ignored
if there is no wiphy in the system. This affects the global
regulatory setting. Global regulatory setting needs to be
maintained so that it can be applied to a new wiphy entering
the system. Therefore, do not ignore user regulatory setting
even if all wiphys in the system are self managed.

Signed-off-by: Amar Singhal <asinghal@codeaurora.org>
---
 net/wireless/reg.c | 28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index bbe6298..4fc66a1 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2240,7 +2240,9 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 		 * as some drivers used this to restore its orig_* reg domain.
 		 */
 		if (initiator == NL80211_REGDOM_SET_BY_CORE &&
-		    wiphy->regulatory_flags & REGULATORY_CUSTOM_REG)
+		    wiphy->regulatory_flags & REGULATORY_CUSTOM_REG &&
+		    !(wiphy->regulatory_flags &
+		      REGULATORY_WIPHY_SELF_MANAGED))
 			reg_call_notifier(wiphy, lr);
 		return;
 	}
@@ -2787,26 +2789,6 @@ static void notify_self_managed_wiphys(struct regulatory_request *request)
 	}
 }
 
-static bool reg_only_self_managed_wiphys(void)
-{
-	struct cfg80211_registered_device *rdev;
-	struct wiphy *wiphy;
-	bool self_managed_found = false;
-
-	ASSERT_RTNL();
-
-	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
-		wiphy = &rdev->wiphy;
-		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
-			self_managed_found = true;
-		else
-			return false;
-	}
-
-	/* make sure at least one self-managed wiphy exists */
-	return self_managed_found;
-}
-
 /*
  * Processes regulatory hints, this is all the NL80211_REGDOM_SET_BY_*
  * Regulatory hints come on a first come first serve basis and we
@@ -2839,10 +2821,6 @@ static void reg_process_pending_hints(void)
 	spin_unlock(&reg_requests_lock);
 
 	notify_self_managed_wiphys(reg_request);
-	if (reg_only_self_managed_wiphys()) {
-		reg_free_request(reg_request);
-		return;
-	}
 
 	reg_process_hint(reg_request);
 
-- 
1.9.1
