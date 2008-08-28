Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:60022 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbYH1MNM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 08:13:12 -0400
Date: Thu, 28 Aug 2008 15:12:06 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix debugfs union misuse and pointer corruption
Message-ID: <20080828121206.GA4863@jm.kir.nu> (sfid-20080828_141314_642722_1FAD37BD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

debugfs union in struct ieee80211_sub_if_data is misused by including a
common default_key dentry as a union member. This ends occupying the same
memory area with the first dentry in other union members (structures;
usually drop_unencrypted). Consequently, debugfs operations on
default_key symlinks and drop_unencrypted entry are using the same
dentry pointer even though they are supposed to be separate ones. This
can lead to removing entries incorrectly or potentially leaving
something behind since one of the dentry pointers gets lost.

Fix this by moving the default_key dentry to a new struct
(common_debugfs) that contains dentries (more to be added in future)
that are shared by all vif types. The debugfs union must only be used
for vif type-specific entries to avoid this type of pointer corruption.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-testing.orig/net/mac80211/ieee80211_i.h
+++ wireless-testing/net/mac80211/ieee80211_i.h
@@ -498,8 +498,10 @@ struct ieee80211_sub_if_data {
 		struct {
 			struct dentry *mode;
 		} monitor;
-		struct dentry *default_key;
 	} debugfs;
+	struct {
+		struct dentry *default_key;
+	} common_debugfs;
 
 #ifdef CONFIG_MAC80211_MESH
 	struct dentry *mesh_stats_dir;
Index: wireless-testing/net/mac80211/debugfs_key.c
===================================================================
--- wireless-testing.orig/net/mac80211/debugfs_key.c
+++ wireless-testing/net/mac80211/debugfs_key.c
@@ -265,7 +265,7 @@ void ieee80211_debugfs_key_add_default(s
 	key = sdata->default_key;
 	if (key) {
 		sprintf(buf, "../keys/%d", key->debugfs.cnt);
-		sdata->debugfs.default_key =
+		sdata->common_debugfs.default_key =
 			debugfs_create_symlink("default_key",
 					       sdata->debugfsdir, buf);
 	} else
@@ -277,8 +277,8 @@ void ieee80211_debugfs_key_remove_defaul
 	if (!sdata)
 		return;
 
-	debugfs_remove(sdata->debugfs.default_key);
-	sdata->debugfs.default_key = NULL;
+	debugfs_remove(sdata->common_debugfs.default_key);
+	sdata->common_debugfs.default_key = NULL;
 }
 
 void ieee80211_debugfs_key_sta_del(struct ieee80211_key *key,


-- 
Jouni Malinen                                            PGP id EFC895FA
