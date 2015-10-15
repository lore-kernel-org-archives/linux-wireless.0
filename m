Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37499 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbbJOJrC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 05:47:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/6] cfg80211: reg: rename reg_call_crda to reg_query_database
Date: Thu, 15 Oct 2015 11:46:54 +0200
Message-Id: <1444902418-25668-2-git-send-email-johannes@sipsolutions.net> (sfid-20151015_114711_675192_F8FCD15B)
In-Reply-To: <1444902418-25668-1-git-send-email-johannes@sipsolutions.net>
References: <1444902418-25668-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The new name is more appropriate since in the case of a built-in
database it may not really rely on CRDA.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3acb51462cc6..c63a13185905 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -555,7 +555,7 @@ static int call_crda(const char *alpha2)
 }
 
 static enum reg_request_treatment
-reg_call_crda(struct regulatory_request *request)
+reg_query_database(struct regulatory_request *request)
 {
 	if (call_crda(request->alpha2))
 		return REG_REQ_IGNORE;
@@ -1867,7 +1867,7 @@ reg_process_hint_core(struct regulatory_request *core_request)
 
 	reg_update_last_request(core_request);
 
-	return reg_call_crda(core_request);
+	return reg_query_database(core_request);
 }
 
 static enum reg_request_treatment
@@ -1935,7 +1935,7 @@ reg_process_hint_user(struct regulatory_request *user_request)
 	user_alpha2[0] = user_request->alpha2[0];
 	user_alpha2[1] = user_request->alpha2[1];
 
-	return reg_call_crda(user_request);
+	return reg_query_database(user_request);
 }
 
 static enum reg_request_treatment
@@ -2016,7 +2016,7 @@ reg_process_hint_driver(struct wiphy *wiphy,
 		return treatment;
 	}
 
-	return reg_call_crda(driver_request);
+	return reg_query_database(driver_request);
 }
 
 static enum reg_request_treatment
@@ -2101,7 +2101,7 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 
 	reg_update_last_request(country_ie_request);
 
-	return reg_call_crda(country_ie_request);
+	return reg_query_database(country_ie_request);
 }
 
 /* This processes *all* regulatory hints */
-- 
2.5.1

