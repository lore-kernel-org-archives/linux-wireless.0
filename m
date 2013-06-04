Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3FDMfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 08:35:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] regulatory: use proper enum return value
Date: Tue,  4 Jun 2013 14:35:44 +0200
Message-Id: <1370349344-16234-1-git-send-email-johannes@sipsolutions.net> (sfid-20130604_143551_783704_2B477181)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

get_reg_request_treatment() returns 0 in one case but is
defined to return an enum, use the proper value REG_REQ_OK.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e1d6749..5a24c98 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1345,7 +1345,7 @@ get_reg_request_treatment(struct wiphy *wiphy,
 				return REG_REQ_OK;
 			return REG_REQ_ALREADY_SET;
 		}
-		return 0;
+		return REG_REQ_OK;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		if (lr->initiator == NL80211_REGDOM_SET_BY_CORE) {
 			if (regdom_changes(pending_request->alpha2))
-- 
1.8.0

