Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51848 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab3LENBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 08:01:37 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: warn if unhashing station fails
Date: Thu,  5 Dec 2013 14:01:33 +0100
Message-Id: <1386248493-4951-1-git-send-email-johannes@sipsolutions.net> (sfid-20131205_140140_895628_E7A08A2B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This shouldn't be happening, so warn if it does, since we'd
then leak a station entry.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 8ed97f7..8ae37f6 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -868,7 +868,7 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	ieee80211_sta_tear_down_BA_sessions(sta, AGG_STOP_DESTROY_STA);
 
 	ret = sta_info_hash_del(local, sta);
-	if (ret)
+	if (WARN_ON(ret))
 		return ret;
 
 	list_del_rcu(&sta->list);
-- 
1.8.4.rc3

