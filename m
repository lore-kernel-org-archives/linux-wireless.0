Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48382 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752118AbeCCTkd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Mar 2018 14:40:33 -0500
From: Jouni Malinen <jouni@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Amar Singhal <asinghal@codeaurora.org>,
        Kiran Kumar Lokere <klokere@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH 1/2] cfg80211: Enhance semantics for self-managed hints
Date: Sat,  3 Mar 2018 21:40:20 +0200
Message-Id: <1520106021-16836-1-git-send-email-jouni@codeaurora.org> (sfid-20180303_204038_659087_DA708CFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amar Singhal <asinghal@codeaurora.org>

Currently, kernel ignores regulatory_hint_user for a wiphy
with flag REGULATORY_WIPHY_SELF_MANAGED set. Wiphy with
REGULATORY_WIPHY_SELF_MANAGED set would ignore beacon hints and country
IE hints and updates from other wiphys in the system, but it may want
to know regulatory setting originating from user-space
(NL80211_REGDOM_SET_BY_USER) that can be trusted
(NL80211_USER_REG_HINT_CELL_BASE). Therefore, conditionally call the
regulatory notifier for a self managed wiphy.

Signed-off-by: Amar Singhal <asinghal@codeaurora.org>
Signed-off-by: Kiran Kumar Lokere <klokere@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
 include/net/regulatory.h |  7 ++++---
 net/wireless/reg.c       | 14 ++++++++++----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index f83cacc..25241c7 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -156,9 +156,10 @@ struct regulatory_request {
  *	system. Conversely, a self-managed wiphy does not share its regulatory
  *	hints with other devices in the system. If a system contains several
  *	devices, one or more of which are self-managed, there might be
- *	contradictory regulatory settings between them. Usage of flag is
- *	generally discouraged. Only use it if the FW/driver is incompatible
- *	with non-locally originated hints.
+ *	contradictory regulatory settings between them. Regulatory information
+ *	from trusted user space sources can still be passed to self-managed
+ *	wiphy. Usage of this flag is generally discouraged. Only use it if the
+ *	FW/driver is incompatible with non-locally originated hints.
  *	This flag is incompatible with the flags: %REGULATORY_CUSTOM_REG,
  *	%REGULATORY_STRICT_REG, %REGULATORY_COUNTRY_IE_FOLLOW_POWER,
  *	%REGULATORY_COUNTRY_IE_IGNORE and %REGULATORY_DISABLE_BEACON_HINTS.
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7b42f0b..4f25a11b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2580,7 +2580,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	reg_free_request(reg_request);
 }
 
-static bool reg_only_self_managed_wiphys(void)
+static bool reg_only_self_managed_wiphys(struct regulatory_request *reg_request)
 {
 	struct cfg80211_registered_device *rdev;
 	struct wiphy *wiphy;
@@ -2590,10 +2590,16 @@ static bool reg_only_self_managed_wiphys(void)
 
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		wiphy = &rdev->wiphy;
-		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
+		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
 			self_managed_found = true;
-		else
+			if (reg_request->initiator ==
+			    NL80211_REGDOM_SET_BY_USER &&
+			    reg_request->user_reg_hint_type ==
+			    NL80211_USER_REG_HINT_CELL_BASE)
+				reg_call_notifier(wiphy, reg_request);
+		} else {
 			return false;
+		}
 	}
 
 	/* make sure at least one self-managed wiphy exists */
@@ -2631,7 +2637,7 @@ static void reg_process_pending_hints(void)
 
 	spin_unlock(&reg_requests_lock);
 
-	if (reg_only_self_managed_wiphys()) {
+	if (reg_only_self_managed_wiphys(reg_request)) {
 		reg_free_request(reg_request);
 		return;
 	}
-- 
2.7.4
