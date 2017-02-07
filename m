Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54770 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753309AbdBGJl0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 04:41:26 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add back lost debugfs files
Date: Tue,  7 Feb 2017 10:41:18 +0100
Message-Id: <20170207094118.6769-1-johannes@sipsolutions.net> (sfid-20170207_104137_498218_B117706A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Somehow these files were never present or lost, but the code
is there and they seem somewhat useful, so add them back.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs.c     | 1 +
 net/mac80211/debugfs_sta.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index f62cd0e13c58..47bea0babe78 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -356,6 +356,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 
 	DEBUGFS_ADD(total_ps_buffered);
 	DEBUGFS_ADD(wep_iv);
+	DEBUGFS_ADD(rate_ctrl_alg);
 	DEBUGFS_ADD(queues);
 	DEBUGFS_ADD(misc);
 #ifdef CONFIG_PM
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index f6003b8c2c33..42601820db20 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -522,6 +522,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 		return;
 
 	DEBUGFS_ADD(flags);
+	DEBUGFS_ADD(aid);
 	DEBUGFS_ADD(num_ps_buf_frames);
 	DEBUGFS_ADD(last_seq_ctrl);
 	DEBUGFS_ADD(agg_status);
-- 
2.9.3
