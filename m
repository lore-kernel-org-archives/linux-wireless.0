Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752118AbeCCTkj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Mar 2018 14:40:39 -0500
From: Jouni Malinen <jouni@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Amar Singhal <asinghal@codeaurora.org>,
        Kiran Kumar Lokere <klokere@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH 2/2] cfg80211: Modify wiphy registration semantics for self managed hints
Date: Sat,  3 Mar 2018 21:40:21 +0200
Message-Id: <1520106021-16836-2-git-send-email-jouni@codeaurora.org> (sfid-20180303_204115_173622_33C29487)
In-Reply-To: <1520106021-16836-1-git-send-email-jouni@codeaurora.org>
References: <1520106021-16836-1-git-send-email-jouni@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amar Singhal <asinghal@codeaurora.org>

Call regulatory notifier conditionally for self managed hints during
wiphy registration. Call when regulatory hint source is
NL80211_REGDOM_SET_BY_USER and sub-type is
NL80211_USER_REG_HINT_CELL_BASE. Call the notifier with last
reg-domain request. This is needed to allow trusted regulatory domain
changes to be processed by the driver.

Signed-off-by: Amar Singhal <asinghal@codeaurora.org>
Signed-off-by: Kiran Kumar Lokere <klokere@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
 net/wireless/reg.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4f25a11b..48eaa8d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3518,15 +3518,21 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 {
 	struct regulatory_request *lr;
 
-	/* self-managed devices ignore external hints */
-	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
+	lr = get_last_request();
+
+	/* self-managed devices ignore beacon hints and 11d IE */
+	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
 		wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS |
 					   REGULATORY_COUNTRY_IE_IGNORE;
 
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
