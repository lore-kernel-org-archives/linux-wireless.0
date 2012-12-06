Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53208 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945964Ab2LFQr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:47:29 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 06/24] regulatory: simplify regulatory_hint_11d
Date: Thu,  6 Dec 2012 17:47:30 +0100
Message-Id: <1354812468-15709-7-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174802_359344_694A789F)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
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
index 333a921..902e138 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1826,12 +1826,7 @@ void regulatory_hint_11d(struct wiphy *wiphy,
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

