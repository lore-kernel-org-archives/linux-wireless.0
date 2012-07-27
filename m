Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51449 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2G0LRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 10/20] mac80211: remove freq/chantype from debugfs
Date: Fri, 27 Jul 2012 13:16:46 +0200
Message-Id: <1343387816-9414-11-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131822_976989_72DF54C2)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

You can now get these values through iw, and
they conflict with multi-channel work.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs.c |   32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index b8dfb44..97173f8 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -63,8 +63,6 @@ DEBUGFS_READONLY_FILE(user_power, "%d",
 		      local->user_power_level);
 DEBUGFS_READONLY_FILE(power, "%d",
 		      local->hw.conf.power_level);
-DEBUGFS_READONLY_FILE(frequency, "%d",
-		      local->hw.conf.channel->center_freq);
 DEBUGFS_READONLY_FILE(total_ps_buffered, "%d",
 		      local->total_ps_buffered);
 DEBUGFS_READONLY_FILE(wep_iv, "%#08x",
@@ -91,33 +89,6 @@ static const struct file_operations reset_ops = {
 	.llseek = noop_llseek,
 };
 
-static ssize_t channel_type_read(struct file *file, char __user *user_buf,
-		       size_t count, loff_t *ppos)
-{
-	struct ieee80211_local *local = file->private_data;
-	const char *buf;
-
-	switch (local->hw.conf.channel_type) {
-	case NL80211_CHAN_NO_HT:
-		buf = "no ht\n";
-		break;
-	case NL80211_CHAN_HT20:
-		buf = "ht20\n";
-		break;
-	case NL80211_CHAN_HT40MINUS:
-		buf = "ht40-\n";
-		break;
-	case NL80211_CHAN_HT40PLUS:
-		buf = "ht40+\n";
-		break;
-	default:
-		buf = "???";
-		break;
-	}
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
-}
-
 static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 			    size_t count, loff_t *ppos)
 {
@@ -205,7 +176,6 @@ static ssize_t queues_read(struct file *file, char __user *user_buf,
 }
 
 DEBUGFS_READONLY_FILE_OPS(hwflags);
-DEBUGFS_READONLY_FILE_OPS(channel_type);
 DEBUGFS_READONLY_FILE_OPS(queues);
 
 /* statistics stuff */
@@ -272,12 +242,10 @@ void debugfs_hw_add(struct ieee80211_local *local)
 
 	local->debugfs.keys = debugfs_create_dir("keys", phyd);
 
-	DEBUGFS_ADD(frequency);
 	DEBUGFS_ADD(total_ps_buffered);
 	DEBUGFS_ADD(wep_iv);
 	DEBUGFS_ADD(queues);
 	DEBUGFS_ADD_MODE(reset, 0200);
-	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(hwflags);
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
-- 
1.7.10.4

