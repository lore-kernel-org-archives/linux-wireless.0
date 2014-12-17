Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36825 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbaLQN6H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 08:58:07 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/9] mac80211: send statistics with delete station event
Date: Wed, 17 Dec 2014 14:57:55 +0100
Message-Id: <1418824679-31530-6-git-send-email-johannes@sipsolutions.net> (sfid-20141217_145813_058549_10A07A4B)
In-Reply-To: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net>
References: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use the new cfg80211_del_sta_sinfo() function to send the
statistics about the deleted station with the delete event.
This lets userspace see how much traffic etc. the deleted
station used.

Change-Id: I5d3e5e88cd492005317c188d4bf77ead6959be63
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index db8b07ac6b10..388ff0b2ad2b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -874,6 +874,7 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 {
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct station_info sinfo = {};
 	int ret;
 
 	/*
@@ -908,7 +909,8 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 
 	sta_dbg(sdata, "Removed STA %pM\n", sta->sta.addr);
 
-	cfg80211_del_sta(sdata->dev, sta->sta.addr, GFP_KERNEL);
+	sta_set_sinfo(sta, &sinfo);
+	cfg80211_del_sta_sinfo(sdata->dev, sta->sta.addr, &sinfo, GFP_KERNEL);
 
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
-- 
2.1.1

