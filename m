Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab3EPVDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 17:03:45 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/9] regulatory: use RCU in regulatory_hint_11d()
Date: Thu, 16 May 2013 23:03:35 +0200
Message-Id: <1368738218-7597-7-git-send-email-johannes@sipsolutions.net> (sfid-20130516_232936_367244_95DAE7B5)
In-Reply-To: <1368738218-7597-1-git-send-email-johannes@sipsolutions.net>
References: <1368738218-7597-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since it just does a quick check of the last regulatory
request, the function doesn't have to hold the reg mutex
but can use RCU instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5ceadbb..a06412fb 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1725,20 +1725,18 @@ void regulatory_hint_11d(struct wiphy *wiphy, enum ieee80211_band band,
 {
 	char alpha2[2];
 	enum environment_cap env = ENVIRON_ANY;
-	struct regulatory_request *request, *lr;
-
-	mutex_lock(&reg_mutex);
-	lr = get_last_request();
-
-	if (unlikely(!lr))
-		goto out;
+	struct regulatory_request *request = NULL, *lr;
 
 	/* IE len must be evenly divisible by 2 */
 	if (country_ie_len & 0x01)
-		goto out;
+		return;
 
 	if (country_ie_len < IEEE80211_COUNTRY_IE_MIN_LEN)
-		goto out;
+		return;
+
+	request = kzalloc(sizeof(*request), GFP_KERNEL);
+	if (!request)
+		return;
 
 	alpha2[0] = country_ie[0];
 	alpha2[1] = country_ie[1];
@@ -1748,6 +1746,12 @@ void regulatory_hint_11d(struct wiphy *wiphy, enum ieee80211_band band,
 	else if (country_ie[2] == 'O')
 		env = ENVIRON_OUTDOOR;
 
+	rcu_read_lock();
+	lr = get_last_request();
+
+	if (unlikely(!lr))
+		goto out;
+
 	/*
 	 * We will run this only upon a successful connection on cfg80211.
 	 * We leave conflict resolution to the workqueue, where can hold
@@ -1757,10 +1761,6 @@ void regulatory_hint_11d(struct wiphy *wiphy, enum ieee80211_band band,
 	    lr->wiphy_idx != WIPHY_IDX_INVALID)
 		goto out;
 
-	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
-	if (!request)
-		goto out;
-
 	request->wiphy_idx = get_wiphy_idx(wiphy);
 	request->alpha2[0] = alpha2[0];
 	request->alpha2[1] = alpha2[1];
@@ -1768,8 +1768,10 @@ void regulatory_hint_11d(struct wiphy *wiphy, enum ieee80211_band band,
 	request->country_ie_env = env;
 
 	queue_regulatory_request(request);
+	request = NULL;
 out:
-	mutex_unlock(&reg_mutex);
+	kfree(request);
+	rcu_read_unlock();
 }
 
 static void restore_alpha2(char *alpha2, bool reset_user)
-- 
1.8.0

