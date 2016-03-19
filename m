Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11473 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbcCSOaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2016 10:30:11 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <mohammed@codeaurora.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] mac80211: Remove unused variable in per STA debugfs struct
Date: Sat, 19 Mar 2016 19:59:43 +0530
Message-ID: <1458397784-15279-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160319_153015_700709_9D51BC6A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Remove unused variable in per STA debugfs structure, 'commit 34e895075e21
("mac80211: allow station add/remove to sleep")' removed the only user of
'add_has_run'.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 net/mac80211/debugfs_sta.c |    2 --
 net/mac80211/sta_info.h    |    1 -
 2 files changed, 3 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index a39512f..43d6ab8 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -339,8 +339,6 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	struct dentry *stations_dir = sta->sdata->debugfs.subdir_stations;
 	u8 mac[3*ETH_ALEN];
 
-	sta->debugfs.add_has_run = true;
-
 	if (!stations_dir)
 		return;
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 57545e5..aae260b 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -487,7 +487,6 @@ struct sta_info {
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct sta_info_debugfsdentries {
 		struct dentry *dir;
-		bool add_has_run;
 	} debugfs;
 #endif
 
-- 
1.7.9.5

