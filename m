Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48520 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab0IUEVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 00:21:53 -0400
Received: by pvg2 with SMTP id 2so1320247pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 21:21:53 -0700 (PDT)
From: greearb@gmail.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
Date: Mon, 20 Sep 2010 21:21:43 -0700
Message-Id: <1285042903-19189-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

MAC address of AP isn't unique..need to add the device
name as well.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 76839d4... 4cf451c... M	net/mac80211/debugfs_sta.c
 net/mac80211/debugfs_sta.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 76839d4..4cf451c 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -301,14 +301,18 @@ STA_OPS(ht_capa);
 void ieee80211_sta_debugfs_add(struct sta_info *sta)
 {
 	struct dentry *stations_dir = sta->local->debugfs.stations;
-	u8 mac[3*ETH_ALEN];
+	u8 mac[3*ETH_ALEN + IFNAMSIZ + 2];
 
 	sta->debugfs.add_has_run = true;
 
 	if (!stations_dir)
 		return;
 
-	snprintf(mac, sizeof(mac), "%pM", sta->sta.addr);
+	if (sta->sdata)
+		snprintf(mac, sizeof(mac), "%pM-%s",
+			 sta->sta.addr, sta->sdata->name);
+	else
+		snprintf(mac, sizeof(mac), "%pM-NULL", sta->sta.addr);
 
 	/*
 	 * This might fail due to a race condition:
-- 
1.7.2.2

