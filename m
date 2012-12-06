Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53220 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945996Ab2LFQrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:47:48 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 12/24] regulatory: simplify restore_regulatory_settings
Date: Thu,  6 Dec 2012 17:47:36 +0100
Message-Id: <1354812468-15709-13-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174824_730224_B4FB235B)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use list_splice_tail_init() and also simplify the locking.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f40e90b..1c19d70 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1879,9 +1879,6 @@ static void restore_regulatory_settings(bool reset_user)
 			restore_custom_reg_settings(&rdev->wiphy);
 	}
 
-	mutex_unlock(&reg_mutex);
-	mutex_unlock(&cfg80211_mutex);
-
 	regulatory_hint_core(world_alpha2);
 
 	/*
@@ -1892,18 +1889,8 @@ static void restore_regulatory_settings(bool reset_user)
 	if (is_an_alpha2(alpha2))
 		regulatory_hint_user(user_alpha2, NL80211_USER_REG_HINT_USER);
 
-	if (list_empty(&tmp_reg_req_list))
-		return;
-
-	mutex_lock(&cfg80211_mutex);
-	mutex_lock(&reg_mutex);
-
 	spin_lock(&reg_requests_lock);
-	list_for_each_entry_safe(reg_request, tmp, &tmp_reg_req_list, list) {
-		REG_DBG_PRINT("Adding request for country %c%c back into the queue\n",
-			      reg_request->alpha2[0], reg_request->alpha2[1]);
-		list_move_tail(&reg_request->list, &reg_requests_list);
-	}
+	list_splice_tail_init(&tmp_reg_req_list, &reg_requests_list);
 	spin_unlock(&reg_requests_lock);
 
 	mutex_unlock(&reg_mutex);
-- 
1.8.0

