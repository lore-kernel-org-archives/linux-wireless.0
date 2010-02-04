Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:52628 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933016Ab0BDVxb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 16:53:31 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] mac80211: Added a new debugfs file for reading channel_type
Date: Thu,  4 Feb 2010 22:00:20 +0100
Message-Id: <1265317220-13504-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This file helps debugging HT channels since it displays if we are on
ht20 or ht40+/ht40-

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/debugfs.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index b3bc32b..637929b 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -250,6 +250,38 @@ static const struct file_operations uapsd_max_sp_len_ops = {
 	.open = mac80211_open_file_generic
 };
 
+static ssize_t channel_type_read(struct file *file, char __user *user_buf,
+		       size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	const char *buf;
+
+	switch (local->hw.conf.channel_type) {
+	case NL80211_CHAN_NO_HT:
+		buf = "no ht\n";
+		break;
+	case NL80211_CHAN_HT20:
+		buf = "ht20\n";
+		break;
+	case NL80211_CHAN_HT40MINUS:
+		buf = "ht40-\n";
+		break;
+	case NL80211_CHAN_HT40PLUS:
+		buf = "ht40+\n";
+		break;
+	default:
+		buf = "???";
+		break;
+	}
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
+}
+
+static const struct file_operations channel_type_ops = {
+	.read = channel_type_read,
+	.open = mac80211_open_file_generic
+};
+
 static ssize_t queues_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -408,6 +440,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(noack);
 	DEBUGFS_ADD(uapsd_queues);
 	DEBUGFS_ADD(uapsd_max_sp_len);
+	DEBUGFS_ADD(channel_type);
 
 	statsd = debugfs_create_dir("statistics", phyd);
 
-- 
1.6.3.3

