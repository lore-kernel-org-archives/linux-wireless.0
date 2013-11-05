Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:60417 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3KERRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:32 -0500
Received: by mail-bk0-f47.google.com with SMTP id d7so2786564bkh.6
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:30 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 09/19] cfg80211: process non country IE conflicting first
Date: Tue,  5 Nov 2013 09:18:07 -0800
Message-Id: <1383671897-7746-10-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181804_504203_E54C2025)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By dealing with non country IE conficts first we can shift
the code that deals with the conflict to the left. This has
no functional changes.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 20e64bd..4d552d8 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1539,31 +1539,32 @@ __reg_process_hint_country_ie(struct wiphy *wiphy,
 		return REG_REQ_ALREADY_SET;
 	}
 
-	last_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
-
 	if (unlikely(!is_an_alpha2(country_ie_request->alpha2)))
 		return -EINVAL;
-	if (lr->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-		if (last_wiphy != wiphy) {
-			/*
-			 * Two cards with two APs claiming different
-			 * Country IE alpha2s. We could
-			 * intersect them, but that seems unlikely
-			 * to be correct. Reject second one for now.
-			 */
-			if (regdom_changes(country_ie_request->alpha2))
-				return REG_REQ_IGNORE;
-			return REG_REQ_ALREADY_SET;
-		}
+
+	if (lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE)
+		return REG_REQ_OK;
+
+	last_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
+
+	if (last_wiphy != wiphy) {
 		/*
-		 * Two consecutive Country IE hints on the same wiphy.
-		 * This should be picked up early by the driver/stack
+		 * Two cards with two APs claiming different
+		 * Country IE alpha2s. We could
+		 * intersect them, but that seems unlikely
+		 * to be correct. Reject second one for now.
 		 */
-		if (WARN_ON(regdom_changes(country_ie_request->alpha2)))
-			return REG_REQ_OK;
+		if (regdom_changes(country_ie_request->alpha2))
+			return REG_REQ_IGNORE;
 		return REG_REQ_ALREADY_SET;
 	}
-	return REG_REQ_OK;
+	/*
+	 * Two consecutive Country IE hints on the same wiphy.
+	 * This should be picked up early by the driver/stack
+	 */
+	if (WARN_ON(regdom_changes(country_ie_request->alpha2)))
+		return REG_REQ_OK;
+	return REG_REQ_ALREADY_SET;
 }
 
 /**
-- 
1.8.4.rc3

