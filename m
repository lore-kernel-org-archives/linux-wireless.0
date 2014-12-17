Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36632 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaLQNAs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 08:00:48 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: free management frame keys when removing station
Date: Wed, 17 Dec 2014 14:00:44 +0100
Message-Id: <1418821244-1952-1-git-send-email-johannes@sipsolutions.net> (sfid-20141217_140052_512092_763BB2DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When writing the code to allow per-station GTKs, I neglected to
take into account the management frame keys (index 4 and 5) when
freeing the station and only added code to free the first four
data frame keys.

Fix this by iterating the array of keys over the right length.

Cc: stable@vger.kernel.org
Fixes: e31b82136d1a ("cfg80211/mac80211: allow per-station GTKs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 434a91ad12c8..0bb7038121ac 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -656,7 +656,7 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 	int i;
 
 	mutex_lock(&local->key_mtx);
-	for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
+	for (i = 0; i < ARRAY_SIZE(sta->gtk); i++) {
 		key = key_mtx_dereference(local, sta->gtk[i]);
 		if (!key)
 			continue;
-- 
2.1.1

