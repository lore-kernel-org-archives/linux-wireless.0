Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51577 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbYDHO1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 10:27:47 -0400
Subject: [PATCH] mac80211: fix key debugfs default_key link
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 08 Apr 2008 13:07:50 +0200
Message-Id: <1207652870.14253.2.camel@johannes.berg> (sfid-20080408_153016_119072_96ECDC7C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The default_key symlink points to the key index rather than
they key counter, fix it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_key.c   |    3 ++-
 net/mac80211/ieee80211_key.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- everything.orig/net/mac80211/debugfs_key.c	2008-04-08 11:20:39.000000000 +0200
+++ everything/net/mac80211/debugfs_key.c	2008-04-08 11:20:43.000000000 +0200
@@ -194,6 +194,7 @@ void ieee80211_debugfs_key_add(struct ie
 		return;
 
 	sprintf(buf, "%d", keycount);
+	key->debugfs.cnt = keycount;
 	keycount++;
 	key->debugfs.dir = debugfs_create_dir(buf,
 					local->debugfs.keys);
@@ -246,7 +247,7 @@ void ieee80211_debugfs_key_add_default(s
 	if (!sdata->debugfsdir)
 		return;
 
-	sprintf(buf, "../keys/%d", sdata->default_key->conf.keyidx);
+	sprintf(buf, "../keys/%d", sdata->default_key->debugfs.cnt);
 	sdata->debugfs.default_key =
 		debugfs_create_symlink("default_key", sdata->debugfsdir, buf);
 }
--- everything.orig/net/mac80211/ieee80211_key.h	2008-04-08 11:20:39.000000000 +0200
+++ everything/net/mac80211/ieee80211_key.h	2008-04-08 11:20:43.000000000 +0200
@@ -115,6 +115,7 @@ struct ieee80211_key {
 		struct dentry *replays;
 		struct dentry *key;
 		struct dentry *ifindex;
+		int cnt;
 	} debugfs;
 #endif
 


