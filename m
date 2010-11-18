Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44531 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab0KRFqT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 00:46:19 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 21:46:05 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <mark@moxienet.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/4] cfg80211: move mutex locking to reg_process_pending_hints()
Date: Wed, 17 Nov 2010 21:46:08 -0800
Message-ID: <1290059169-2468-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1290059169-2468-1-git-send-email-lrodriguez@atheros.com>
References: <1290059169-2468-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be required in the next patch and it makes the
next patch easier to review.

Cc: Mark Mentovai <mark@moxienet.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3fa2474..b522c46 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1412,16 +1412,13 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 
 	BUG_ON(!reg_request->alpha2);
 
-	mutex_lock(&cfg80211_mutex);
-	mutex_lock(&reg_mutex);
-
 	if (wiphy_idx_valid(reg_request->wiphy_idx))
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
 
 	if (reg_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    !wiphy) {
 		kfree(reg_request);
-		goto out;
+		return;
 	}
 
 	r = __regulatory_hint(wiphy, reg_request);
@@ -1429,16 +1426,16 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	if (r == -EALREADY && wiphy &&
 	    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
 		wiphy_update_regulatory(wiphy, initiator);
-out:
-	mutex_unlock(&reg_mutex);
-	mutex_unlock(&cfg80211_mutex);
 }
 
 /* Processes regulatory hints, this is all the NL80211_REGDOM_SET_BY_* */
 static void reg_process_pending_hints(void)
-	{
+{
 	struct regulatory_request *reg_request;
 
+	mutex_lock(&cfg80211_mutex);
+	mutex_lock(&reg_mutex);
+
 	spin_lock(&reg_requests_lock);
 	while (!list_empty(&reg_requests_list)) {
 		reg_request = list_first_entry(&reg_requests_list,
@@ -1451,6 +1448,9 @@ static void reg_process_pending_hints(void)
 		spin_lock(&reg_requests_lock);
 	}
 	spin_unlock(&reg_requests_lock);
+
+	mutex_unlock(&reg_mutex);
+	mutex_unlock(&cfg80211_mutex);
 }
 
 /* Processes beacon hints -- this has nothing to do with country IEs */
-- 
1.7.3.2.90.gd4c43

