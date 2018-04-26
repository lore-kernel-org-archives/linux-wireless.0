Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44236 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756589AbeDZROI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 13:14:08 -0400
From: Jouni Malinen <jouni@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Amar Singhal <asinghal@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCHv2] cfg80211: Call reg_notifier for self managed hints conditionally
Date: Thu, 26 Apr 2018 20:13:07 +0300
Message-Id: <1524762787-7703-1-git-send-email-jouni@codeaurora.org> (sfid-20180426_191412_118876_F33AE4FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amar Singhal <asinghal@codeaurora.org>

Currently the regulatory core does not call the regulatory callback
reg_notifier for self managed wiphys, but regulatory_hint_user() call is
independent of wiphy and is meant for all wiphys in the system. Even a
self managed wiphy may be interested in regulatory_hint_user() to know
the country code from a trusted regulatory domain change like a cellular
base station. Therefore, for the regulatory source
NL80211_REGDOM_SET_BY_USER and the user hint type
NL80211_USER_REG_HINT_CELL_BASE, call the regulatory notifier.

No current wlan driver uses the REGULATORY_WIPHY_SELF_MANAGED flag while
also registering the reg_notifier regulatory callback, therefore there
will be no impact on existing drivers without them being explicitly
modified to take advantage of this new possibility.

Signed-off-by: Amar Singhal <asinghal@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
 net/wireless/reg.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)
 
v2
- merge the two patches into a single one
- instead of modifying reg_only_self_managed_wiphys() use a new helper
  function notify_self_managed_wiphys() to clean up the implementation
- update commit message and comments to describe the desired use case
  more clearly and note that this does not change behavior with existing
  drivers without an explicit driver change

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ecfee5f..25bce79 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2768,6 +2768,21 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	reg_free_request(reg_request);
 }
 
+static void notify_self_managed_wiphys(struct regulatory_request *request)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wiphy *wiphy;
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		wiphy = &rdev->wiphy;
+		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED &&
+		    request->initiator == NL80211_REGDOM_SET_BY_USER &&
+		    request->user_reg_hint_type ==
+		    NL80211_USER_REG_HINT_CELL_BASE)
+			reg_call_notifier(wiphy, request);
+	}
+}
+
 static bool reg_only_self_managed_wiphys(void)
 {
 	struct cfg80211_registered_device *rdev;
@@ -2819,6 +2834,7 @@ static void reg_process_pending_hints(void)
 
 	spin_unlock(&reg_requests_lock);
 
+	notify_self_managed_wiphys(reg_request);
 	if (reg_only_self_managed_wiphys()) {
 		reg_free_request(reg_request);
 		return;
@@ -3698,17 +3714,26 @@ EXPORT_SYMBOL(regulatory_set_wiphy_regd_sync_rtnl);
 
 void wiphy_regulatory_register(struct wiphy *wiphy)
 {
-	struct regulatory_request *lr;
+	struct regulatory_request *lr = get_last_request();
 
-	/* self-managed devices ignore external hints */
-	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
+	/* self-managed devices ignore beacon hints and country IE */
+	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
 		wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS |
 					   REGULATORY_COUNTRY_IE_IGNORE;
 
+		/*
+		 * The last request may have been received before this
+		 * registration call. Call the driver notifier if
+		 * initiator is USER and user type is CELL_BASE.
+		 */
+		if (lr->initiator == NL80211_REGDOM_SET_BY_USER &&
+		    lr->user_reg_hint_type == NL80211_USER_REG_HINT_CELL_BASE)
+			reg_call_notifier(wiphy, lr);
+	}
+
 	if (!reg_dev_ignore_cell_hint(wiphy))
 		reg_num_devs_support_basehint++;
 
-	lr = get_last_request();
 	wiphy_update_regulatory(wiphy, lr->initiator);
 	wiphy_all_share_dfs_chan_state(wiphy);
 }
-- 
2.7.4
