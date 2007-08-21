Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37376 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbXHUQBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 12:01:48 -0400
Message-Id: <20070821160002.157469000@sipsolutions.net>
References: <20070821155725.489738000@sipsolutions.net>
Date: Tue, 21 Aug 2007 17:57:28 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mac80211: add interface index to key debugfs
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new file 'ifindex' to each key's debugfs dir to
allow finding which interface the key was configured on.
This isn't done as a symlink because of possible netdev
name changes.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_key.c   |    4 ++++
 net/mac80211/ieee80211_key.h |    1 +
 2 files changed, 5 insertions(+)

--- wireless-dev.orig/net/mac80211/debugfs_key.c	2007-08-21 16:26:46.415923881 +0200
+++ wireless-dev/net/mac80211/debugfs_key.c	2007-08-21 16:27:34.505923881 +0200
@@ -56,6 +56,8 @@ KEY_CONF_FILE(keyidx, D);
 KEY_CONF_FILE(hw_key_idx, D);
 KEY_FILE(flags, X);
 KEY_FILE(tx_rx_count, D);
+KEY_READ(ifindex, sdata->dev->ifindex, 20, "%d\n");
+KEY_OPS(ifindex);
 
 static ssize_t key_algorithm_read(struct file *file,
 				  char __user *userbuf,
@@ -209,6 +211,7 @@ void ieee80211_debugfs_key_add(struct ie
 	DEBUGFS_ADD(rx_spec);
 	DEBUGFS_ADD(replays);
 	DEBUGFS_ADD(key);
+	DEBUGFS_ADD(ifindex);
 };
 
 #define DEBUGFS_DEL(name) \
@@ -229,6 +232,7 @@ void ieee80211_debugfs_key_remove(struct
 	DEBUGFS_DEL(rx_spec);
 	DEBUGFS_DEL(replays);
 	DEBUGFS_DEL(key);
+	DEBUGFS_DEL(ifindex);
 
 	debugfs_remove(key->debugfs.stalink);
 	key->debugfs.stalink = NULL;
--- wireless-dev.orig/net/mac80211/ieee80211_key.h	2007-08-21 16:26:46.375923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_key.h	2007-08-21 16:27:34.505923881 +0200
@@ -101,6 +101,7 @@ struct ieee80211_key {
 		struct dentry *rx_spec;
 		struct dentry *replays;
 		struct dentry *key;
+		struct dentry *ifindex;
 	} debugfs;
 #endif
 

-- 

