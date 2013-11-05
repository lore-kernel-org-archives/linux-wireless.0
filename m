Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:65043 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab3KERRV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:21 -0500
Received: by mail-bk0-f44.google.com with SMTP id mx11so1056757bkb.3
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:20 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 04/19] cfg80211: remove second argument from reg_process_hint()
Date: Tue,  5 Nov 2013 09:18:02 -0800
Message-Id: <1383671897-7746-5-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181724_314931_5419FA6E)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iniator is already available to us, so use it.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ff595d1..dd2ff68 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1537,8 +1537,7 @@ new_request:
 }
 
 /* This processes *all* regulatory hints */
-static void reg_process_hint(struct regulatory_request *reg_request,
-			     enum nl80211_reg_initiator reg_initiator)
+static void reg_process_hint(struct regulatory_request *reg_request)
 {
 	struct wiphy *wiphy = NULL;
 
@@ -1548,7 +1547,7 @@ static void reg_process_hint(struct regulatory_request *reg_request,
 	if (reg_request->wiphy_idx != WIPHY_IDX_INVALID)
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
 
-	if (reg_initiator == NL80211_REGDOM_SET_BY_DRIVER && !wiphy) {
+	if (reg_request->initiator == NL80211_REGDOM_SET_BY_DRIVER && !wiphy) {
 		kfree(reg_request);
 		return;
 	}
@@ -1557,10 +1556,10 @@ static void reg_process_hint(struct regulatory_request *reg_request,
 	case REG_REQ_ALREADY_SET:
 		/* This is required so that the orig_* parameters are saved */
 		if (wiphy && wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
-			wiphy_update_regulatory(wiphy, reg_initiator);
+			wiphy_update_regulatory(wiphy, reg_request->initiator);
 		break;
 	default:
-		if (reg_initiator == NL80211_REGDOM_SET_BY_USER)
+		if (reg_request->initiator == NL80211_REGDOM_SET_BY_USER)
 			schedule_delayed_work(&reg_timeout,
 					      msecs_to_jiffies(3142));
 		break;
@@ -1598,7 +1597,7 @@ static void reg_process_pending_hints(void)
 
 	spin_unlock(&reg_requests_lock);
 
-	reg_process_hint(reg_request, reg_request->initiator);
+	reg_process_hint(reg_request);
 }
 
 /* Processes beacon hints -- this has nothing to do with country IEs */
-- 
1.8.4.rc3

