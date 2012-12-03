Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40972 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab2LCRmv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 12:42:51 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/8] regulatory: simplify regulatory_hint_11d
Date: Mon,  3 Dec 2012 18:43:08 +0100
Message-Id: <1354556593-2363-4-git-send-email-johannes@sipsolutions.net> (sfid-20121203_184301_618707_75E0FE1A)
In-Reply-To: <1354556593-2363-1-git-send-email-johannes@sipsolutions.net>
References: <1354556593-2363-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to unlock before calling
queue_regulatory_request(), so simplify
the function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3da03ab..877ff5d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1843,12 +1843,7 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	request->initiator = NL80211_REGDOM_SET_BY_COUNTRY_IE;
 	request->country_ie_env = env;
 
-	mutex_unlock(&reg_mutex);
-
 	queue_regulatory_request(request);
-
-	return;
-
 out:
 	mutex_unlock(&reg_mutex);
 }
-- 
1.8.0

