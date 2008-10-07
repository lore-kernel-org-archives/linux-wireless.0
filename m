Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660AbYJGQ6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 12:58:11 -0400
Message-Id: <20081007100437.357527000@sipsolutions.net> (sfid-20081007_185819_337403_F32DFC99)
References: <20081007100428.868688000@sipsolutions.net>
Date: Tue, 07 Oct 2008 12:04:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Robin Holt <holt@sgi.com>
Subject: [PATCH 1/8] mac80211: fix debugfs lockup
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When debugfs_create_dir fails, sta_info_debugfs_add_work will not
terminate because it will find the same station again and again.
This is possible whenever debugfs fails for whatever reason; one
reason is a race condition in mac80211, unfortunately we cannot
do much about it, so just document it, it just means some station
may be missing from debugfs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Robin Holt <holt@sgi.com>
---
 net/mac80211/debugfs_sta.c |   11 +++++++++++
 net/mac80211/sta_info.c    |    7 ++++++-
 net/mac80211/sta_info.h    |    1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

--- everything.orig/net/mac80211/debugfs_sta.c	2008-10-07 11:26:52.000000000 +0200
+++ everything/net/mac80211/debugfs_sta.c	2008-10-07 11:26:58.000000000 +0200
@@ -249,11 +249,22 @@ void ieee80211_sta_debugfs_add(struct st
 	DECLARE_MAC_BUF(mbuf);
 	u8 *mac;
 
+	sta->debugfs.add_has_run = true;
+
 	if (!stations_dir)
 		return;
 
 	mac = print_mac(mbuf, sta->sta.addr);
 
+	/*
+	 * This might fail due to a race condition:
+	 * When mac80211 unlinks a station, the debugfs entries
+	 * remain, but it is already possible to link a new
+	 * station with the same address which triggers adding
+	 * it to debugfs; therefore, if the old station isn't
+	 * destroyed quickly enough the old station's debugfs
+	 * dir might still be around.
+	 */
 	sta->debugfs.dir = debugfs_create_dir(mac, stations_dir);
 	if (!sta->debugfs.dir)
 		return;
--- everything.orig/net/mac80211/sta_info.c	2008-10-07 11:26:52.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-10-07 11:26:58.000000000 +0200
@@ -635,7 +635,12 @@ static void sta_info_debugfs_add_work(st
 
 		spin_lock_irqsave(&local->sta_lock, flags);
 		list_for_each_entry(tmp, &local->sta_list, list) {
-			if (!tmp->debugfs.dir) {
+			/*
+			 * debugfs.add_has_run will be set by
+			 * ieee80211_sta_debugfs_add regardless
+			 * of what else it does.
+			 */
+			if (!tmp->debugfs.add_has_run) {
 				sta = tmp;
 				__sta_info_pin(sta);
 				break;
--- everything.orig/net/mac80211/sta_info.h	2008-10-07 11:26:52.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-10-07 11:26:58.000000000 +0200
@@ -300,6 +300,7 @@ struct sta_info {
 		struct dentry *inactive_ms;
 		struct dentry *last_seq_ctrl;
 		struct dentry *agg_status;
+		bool add_has_run;
 	} debugfs;
 #endif
 

-- 

