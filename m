Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44564 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2LDOsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 09:48:39 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 04/18] regulatory: simplify regulatory_hint_11d
Date: Tue,  4 Dec 2012 15:48:46 +0100
Message-Id: <1354632540-21207-5-git-send-email-johannes@sipsolutions.net> (sfid-20121204_154845_976768_5E2A693E)
In-Reply-To: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
References: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
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
index dc46106..c5145c0 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1834,12 +1834,7 @@ void regulatory_hint_11d(struct wiphy *wiphy,
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

