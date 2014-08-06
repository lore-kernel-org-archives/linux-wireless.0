Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54069 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbaHFGoi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2014 02:44:38 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix agg_status debugfs file alignment
Date: Wed,  6 Aug 2014 08:44:31 +0200
Message-Id: <1407307471-11217-1-git-send-email-johannes@sipsolutions.net> (sfid-20140806_084441_283392_9F1F97E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The "RX active" string is too long, so the columns get
shifted. Change it to just "RX" to avoid this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 4a20fb8f1e23..33eb4a43a2f3 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -168,7 +168,7 @@ static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 	p += scnprintf(p, sizeof(buf) + buf - p, "next dialog_token: %#02x\n",
 			sta->ampdu_mlme.dialog_token_allocator + 1);
 	p += scnprintf(p, sizeof(buf) + buf - p,
-		       "TID\t\tRX active\tDTKN\tSSN\t\tTX\tDTKN\tpending\n");
+		       "TID\t\tRX\tDTKN\tSSN\t\tTX\tDTKN\tpending\n");
 
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
 		tid_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[i]);
-- 
2.0.0

