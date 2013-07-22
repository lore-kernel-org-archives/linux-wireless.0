Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41549 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3GVMfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 08:35:09 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add debugfs for driver-buffered TID bitmap
Date: Mon, 22 Jul 2013 14:35:04 +0200
Message-Id: <1374496504-17705-1-git-send-email-johannes@sipsolutions.net> (sfid-20130722_143513_854987_E9A417DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add a per-station debugfs file indicating the TIDs (as
a bitmap) that the driver has data buffered on.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 44e201d..19c54a4 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -455,6 +455,15 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD_COUNTER(tx_retry_count, tx_retry_count);
 	DEBUGFS_ADD_COUNTER(wep_weak_iv_count, wep_weak_iv_count);
 
+	if (sizeof(sta->driver_buffered_tids) == sizeof(u32))
+		debugfs_create_x32("driver_buffered_tids", 0400,
+				   sta->debugfs.dir,
+				   (u32 *)&sta->driver_buffered_tids);
+	else
+		debugfs_create_x64("driver_buffered_tids", 0400,
+				   sta->debugfs.dir,
+				   (u64 *)&sta->driver_buffered_tids);
+
 	drv_sta_add_debugfs(local, sdata, &sta->sta, sta->debugfs.dir);
 }
 
-- 
1.8.0

