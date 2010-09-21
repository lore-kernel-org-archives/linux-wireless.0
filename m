Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57831 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab0IUMPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 08:15:20 -0400
Received: by pzk34 with SMTP id 34so1383458pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Sep 2010 05:15:20 -0700 (PDT)
From: greearb@gmail.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
Date: Tue, 21 Sep 2010 05:15:10 -0700
Message-Id: <1285071310-11440-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

MAC address of AP isn't unique..need to add the device
name as well.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 76839d4... e802fce... M	net/mac80211/debugfs_sta.c
 net/mac80211/debugfs_sta.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 76839d4..e802fce 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -301,14 +301,15 @@ STA_OPS(ht_capa);
 void ieee80211_sta_debugfs_add(struct sta_info *sta)
 {
 	struct dentry *stations_dir = sta->local->debugfs.stations;
-	u8 mac[3*ETH_ALEN];
+	u8 mac[3*ETH_ALEN + IFNAMSIZ + 2];
 
 	sta->debugfs.add_has_run = true;
 
 	if (!stations_dir)
 		return;
 
-	snprintf(mac, sizeof(mac), "%pM", sta->sta.addr);
+	snprintf(mac, sizeof(mac), "%pM-%s",
+		 sta->sta.addr, sta->sdata->name);
 
 	/*
 	 * This might fail due to a race condition:
-- 
1.7.2.2

