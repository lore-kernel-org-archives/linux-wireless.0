Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43128 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab3AILTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 06:19:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] regulatory: fix restore_regulatory_settings
Date: Wed,  9 Jan 2013 12:20:05 +0100
Message-Id: <1357730405-31853-1-git-send-email-johannes@sipsolutions.net> (sfid-20130109_121943_526291_1A8E091B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My commit 379b82f4c9dc6e67bf61aa61b096c06a2f320f60
("regulatory: pass new regdomain to reset function")
broke the restore_regulatory_settings() function due
to a logic change. Consider this change:

-	reset_regdomains(true);
-	cfg80211_regdomain = cfg80211_world_regdom;
+	reset_regdomains(true, cfg80211_world_regdom);

This looks innocent enough, until you realise that the
called function (reset_regdomains) also resets the
cfg80211_world_regdom pointer, so that the old version
of the code would use the new object it pointed to and
the new version of the code uses the old object. This
lead to a double-free of this object.

Since reset_regdomains() sets it to &world_regdom, use
that directly.

Reported-by: Sujith Manoharan <sujith@msujith.org>
Tested-by: Sujith Manoharan <sujith@msujith.org>
Reported-by: Bob Copeland <me@bobcopeland.com>
Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2193f62..8c114e8 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1848,7 +1848,7 @@ static void restore_regulatory_settings(bool reset_user)
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
 
-	reset_regdomains(true, cfg80211_world_regdom);
+	reset_regdomains(true, &world_regdom);
 	restore_alpha2(alpha2, reset_user);
 
 	/*
-- 
1.8.0

