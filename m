Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40985 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab1J1FLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 01:11:50 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [wireless-next PATCH 4/5] wifi: Warn if cannot add station debugfs entries.
Date: Thu, 27 Oct 2011 22:11:19 -0700
Message-Id: <1319778680-11405-4-git-send-email-greearb@candelatech.com> (sfid-20111028_071154_398499_47BB01A2)
In-Reply-To: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 c5f3417... 1ceec86... M	net/mac80211/debugfs_sta.c
 net/mac80211/debugfs_sta.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index c5f3417..1ceec86 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -337,8 +337,11 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 
 	sta->debugfs.add_has_run = true;
 
-	if (!stations_dir)
+	if (!stations_dir) {
+		printk(KERN_DEBUG "%s: sta_debugfs_add: stations_dir is NULL\n",
+			sta->sdata->name);
 		return;
+	}
 
 	snprintf(mac, sizeof(mac), "%pM", sta->sta.addr);
 
@@ -352,8 +355,11 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	 * dir might still be around.
 	 */
 	sta->debugfs.dir = debugfs_create_dir(mac, stations_dir);
-	if (!sta->debugfs.dir)
+	if (!sta->debugfs.dir) {
+		printk(KERN_DEBUG "%s: sta_debugfs_add: Failed to create sta->debugfs.dir\n",
+			sta->sdata->name);
 		return;
+	}
 
 	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(num_ps_buf_frames);
-- 
1.7.3.4

