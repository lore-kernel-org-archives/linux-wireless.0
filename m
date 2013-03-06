Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51334 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab3CFWTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 17:19:32 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: emmanuel.grumbach@intel.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9] mac80211: always synchronize_net() during station removal
Date: Wed,  6 Mar 2013 23:19:26 +0100
Message-Id: <1362608366-10771-1-git-send-email-johannes@sipsolutions.net> (sfid-20130306_231940_133902_988CCAB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If there are keys left during station removal, then a
synchronize_net() will be done (for each key, I have a
patch to address this for 3.10), otherwise it won't be
done at all which causes issues because the station
could be used for TX while it's being removed from the
driver -- that might confuse the driver.

Fix this by always doing synchronize_net() if no key
was present any more.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a79ce82..238a0cc 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -766,6 +766,7 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	int ret, i;
+	bool have_key = false;
 
 	might_sleep();
 
@@ -793,12 +794,19 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	list_del_rcu(&sta->list);
 
 	mutex_lock(&local->key_mtx);
-	for (i = 0; i < NUM_DEFAULT_KEYS; i++)
+	for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
 		__ieee80211_key_free(key_mtx_dereference(local, sta->gtk[i]));
-	if (sta->ptk)
+		have_key = true;
+	}
+	if (sta->ptk) {
 		__ieee80211_key_free(key_mtx_dereference(local, sta->ptk));
+		have_key = true;
+	}
 	mutex_unlock(&local->key_mtx);
 
+	if (!have_key)
+		synchronize_net();
+
 	sta->dead = true;
 
 	local->num_sta--;
-- 
1.8.0

