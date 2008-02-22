Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934306AbYBVOIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 09:08:20 -0500
Message-Id: <20080222111751.106472000@sipsolutions.net> (sfid-20080222_140845_701897_C1EA5BDF)
References: <20080222111644.183587000@sipsolutions.net>
Date: Fri, 22 Feb 2008 12:16:51 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 7/8] mac80211: remove STA infos last_ack stuff
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These things aren't used and the only possible use is within
rate control algorithms, however those can, if they need it,
keep track of it in their private data. last_ack_ms isn't
even updated so completely useless.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_sta.c      |   29 -----------------------------
 net/mac80211/rc80211_pid_algo.c |    3 ---
 net/mac80211/rc80211_simple.c   |    3 ---
 net/mac80211/sta_info.h         |    4 ----
 4 files changed, 39 deletions(-)

--- everything.orig/net/mac80211/sta_info.h	2008-02-22 09:56:08.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-22 09:57:17.000000000 +0100
@@ -182,8 +182,6 @@ struct sta_info {
 	int last_rssi; /* RSSI of last received frame from this STA */
 	int last_signal; /* signal of last received frame from this STA */
 	int last_noise; /* noise of last received frame from this STA */
-	int last_ack_rssi[3]; /* RSSI of last received ACKs from this STA */
-	unsigned long last_ack;
 	int channel_use;
 	int channel_use_raw;
 
@@ -211,8 +209,6 @@ struct sta_info {
 		struct dentry *dir;
 		struct dentry *flags;
 		struct dentry *num_ps_buf_frames;
-		struct dentry *last_ack_rssi;
-		struct dentry *last_ack_ms;
 		struct dentry *inactive_ms;
 		struct dentry *last_seq_ctrl;
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
--- everything.orig/net/mac80211/debugfs_sta.c	2008-02-22 09:58:02.000000000 +0100
+++ everything/net/mac80211/debugfs_sta.c	2008-02-22 09:58:12.000000000 +0100
@@ -98,31 +98,6 @@ static ssize_t sta_num_ps_buf_frames_rea
 }
 STA_OPS(num_ps_buf_frames);
 
-static ssize_t sta_last_ack_rssi_read(struct file *file, char __user *userbuf,
-				      size_t count, loff_t *ppos)
-{
-	char buf[100];
-	struct sta_info *sta = file->private_data;
-	int res = scnprintf(buf, sizeof(buf), "%d %d %d\n",
-			    sta->last_ack_rssi[0],
-			    sta->last_ack_rssi[1],
-			    sta->last_ack_rssi[2]);
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
-}
-STA_OPS(last_ack_rssi);
-
-static ssize_t sta_last_ack_ms_read(struct file *file, char __user *userbuf,
-				    size_t count, loff_t *ppos)
-{
-	char buf[20];
-	struct sta_info *sta = file->private_data;
-	int res = scnprintf(buf, sizeof(buf), "%d\n",
-			    sta->last_ack ?
-			    jiffies_to_msecs(jiffies - sta->last_ack) : -1);
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
-}
-STA_OPS(last_ack_ms);
-
 static ssize_t sta_inactive_ms_read(struct file *file, char __user *userbuf,
 				    size_t count, loff_t *ppos)
 {
@@ -311,8 +286,6 @@ void ieee80211_sta_debugfs_add(struct st
 
 	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(num_ps_buf_frames);
-	DEBUGFS_ADD(last_ack_rssi);
-	DEBUGFS_ADD(last_ack_ms);
 	DEBUGFS_ADD(inactive_ms);
 	DEBUGFS_ADD(last_seq_ctrl);
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
@@ -326,8 +299,6 @@ void ieee80211_sta_debugfs_remove(struct
 {
 	DEBUGFS_DEL(flags);
 	DEBUGFS_DEL(num_ps_buf_frames);
-	DEBUGFS_DEL(last_ack_rssi);
-	DEBUGFS_DEL(last_ack_ms);
 	DEBUGFS_DEL(inactive_ms);
 	DEBUGFS_DEL(last_seq_ctrl);
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-02-22 09:56:46.000000000 +0100
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-02-22 09:56:52.000000000 +0100
@@ -282,9 +282,6 @@ static void rate_control_pid_tx_status(v
 		sta->tx_num_consecutive_failures++;
 		sta->tx_num_mpdu_fail++;
 	} else {
-		sta->last_ack_rssi[0] = sta->last_ack_rssi[1];
-		sta->last_ack_rssi[1] = sta->last_ack_rssi[2];
-		sta->last_ack_rssi[2] = status->ack_signal;
 		sta->tx_num_consecutive_failures = 0;
 		sta->tx_num_mpdu_ok++;
 	}
--- everything.orig/net/mac80211/rc80211_simple.c	2008-02-22 09:58:29.000000000 +0100
+++ everything/net/mac80211/rc80211_simple.c	2008-02-22 09:59:32.000000000 +0100
@@ -133,9 +133,6 @@ static void rate_control_simple_tx_statu
 		sta->tx_num_consecutive_failures++;
 		sta->tx_num_mpdu_fail++;
 	} else {
-		sta->last_ack_rssi[0] = sta->last_ack_rssi[1];
-		sta->last_ack_rssi[1] = sta->last_ack_rssi[2];
-		sta->last_ack_rssi[2] = status->ack_signal;
 		sta->tx_num_consecutive_failures = 0;
 		sta->tx_num_mpdu_ok++;
 	}

-- 

