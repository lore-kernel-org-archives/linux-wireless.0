Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43316 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab3FLUuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 16:50:14 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix TX aggregation TID struct leak
Date: Wed, 12 Jun 2013 22:50:09 +0200
Message-Id: <1371070209-24107-1-git-send-email-johannes@sipsolutions.net> (sfid-20130612_225018_678692_D7CFA8A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Ben reports that kmemleak is saying TX aggregation TID
structs are leaked. Given his workload, I suspect that
they're leaked because stations are destroyed before
their aggregation sessions get a chance to start. Fix
this by simply freeing structs that are not used yet.

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index b429798..aaf68d2 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -149,6 +149,7 @@ static void cleanup_single_sta(struct sta_info *sta)
 	 * directly by station destruction.
 	 */
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+		kfree(sta->ampdu_mlme.tid_start_tx[i]);
 		tid_tx = rcu_dereference_raw(sta->ampdu_mlme.tid_tx[i]);
 		if (!tid_tx)
 			continue;
-- 
1.8.0

