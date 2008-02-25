Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbYBYPch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 10:32:37 -0500
Message-Id: <20080225153006.347624000@sipsolutions.net> (sfid-20080225_153259_596459_5A725E25)
References: <20080225152740.360393000@sipsolutions.net>
Date: Mon, 25 Feb 2008 16:27:44 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 04/10] mac80211: remove STA infos last_ack stuff
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

--- everything.orig/net/mac80211/sta_info.h	2008-02-24 10:15:38.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-24 10:22:49.000000000 +0100
@@ -189,8 +189,6 @@ struct sta_info {
 	int last_rssi; /* RSSI of last received frame from this STA */
 	int last_signal; /* signal of last received frame from this STA */
 	int last_noise; /* noise of last received frame from this STA */
-	int last_ack_rssi[3]; /* RSSI of last received ACKs from this STA */
-	unsigned long last_ack;
 	int channel_use;
 	int channel_use_raw;
 
@@ -226,8 +224,6 @@ struct sta_info {
 		struct dentry *dir;
 		struct dentry *flags;
 		struct dentry *num_ps_buf_frames;
-		struct dentry *last_ack_rssi;
-		struct dentry *last_ack_ms;
 		struct dentry *inactive_ms;
 		struct dentry *last_seq_ctrl;
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
--- everything.orig/net/mac80211/debugfs_sta.c	2008-02-23 14:45:46.000000000 +0100
+++ everything/net/mac80211/debugfs_sta.c	2008-02-24 10:22:49.000000000 +0100
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
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-02-23 14:59:28.000000000 +0100
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-02-24 10:22:49.000000000 +0100
@@ -290,9 +290,6 @@ static void rate_control_pid_tx_status(v
 		sta->tx_num_consecutive_failures++;
 		sta->tx_num_mpdu_fail++;
 	} else {
-		sta->last_ack_rssi[0] = sta->last_ack_rssi[1];
-		sta->last_ack_rssi[1] = sta->last_ack_rssi[2];
-		sta->last_ack_rssi[2] = status->ack_signal;
 		sta->tx_num_consecutive_failures = 0;
 		sta->tx_num_mpdu_ok++;
 	}
--- everything.orig/net/mac80211/rc80211_simple.c	2008-02-23 13:03:38.000000000 +0100
+++ everything/net/mac80211/rc80211_simple.c	2008-02-24 10:22:49.000000000 +0100
@@ -131,9 +131,6 @@ static void rate_control_simple_tx_statu
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

