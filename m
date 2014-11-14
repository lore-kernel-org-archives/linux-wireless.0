Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53210 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161286AbaKNTec (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 14:34:32 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: send statistics with delete station event
Date: Fri, 14 Nov 2014 20:34:27 +0100
Message-Id: <1415993667-6527-1-git-send-email-johannes@sipsolutions.net> (sfid-20141114_203435_813324_FEF04A9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use the new cfg80211_del_sta_sinfo() function to send the
statistics about the deleted station with the delete event.
This lets userspace see how much traffic etc. the deleted
station used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index adc25371b171..bffab579be1b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -862,6 +862,7 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 {
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct station_info sinfo = {};
 	int ret;
 
 	/*
@@ -896,7 +897,8 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 
 	sta_dbg(sdata, "Removed STA %pM\n", sta->sta.addr);
 
-	cfg80211_del_sta(sdata->dev, sta->sta.addr, GFP_KERNEL);
+	sta_set_sinfo(sta, &sinfo);
+	cfg80211_del_sta_sinfo(sdata->dev, sta->sta.addr, &sinfo, GFP_KERNEL);
 
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
-- 
2.1.1

