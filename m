Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab2GETjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 15:39:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix debugfs default key links
Date: Thu,  5 Jul 2012 21:38:56 +0200
Message-Id: <1341517136-6246-1-git-send-email-johannes@sipsolutions.net> (sfid-20120705_213907_401502_2BDD35EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Due to the way the default key links are created,
it happens that a link is left dangling:
 * both unicast/multicast links are created
 * unicast link is destroyed, and the links
   are updated
 * during this update, adding the multicast
   link again fails because it is present,
   destroying the debugfs pointer
 * removing the multicast link won't work as
   the pointer has been destroyed

Fix this by always removing the links and then
re-creating them if needed.

Reported-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_key.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 7932767..090d08f 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -283,6 +283,11 @@ void ieee80211_debugfs_key_update_default(struct ieee80211_sub_if_data *sdata)
 
 	lockdep_assert_held(&sdata->local->key_mtx);
 
+	if (sdata->debugfs.default_unicast_key) {
+		debugfs_remove(sdata->debugfs.default_unicast_key);
+		sdata->debugfs.default_unicast_key = NULL;
+	}
+
 	if (sdata->default_unicast_key) {
 		key = key_mtx_dereference(sdata->local,
 					  sdata->default_unicast_key);
@@ -290,9 +295,11 @@ void ieee80211_debugfs_key_update_default(struct ieee80211_sub_if_data *sdata)
 		sdata->debugfs.default_unicast_key =
 			debugfs_create_symlink("default_unicast_key",
 					       sdata->debugfs.dir, buf);
-	} else {
-		debugfs_remove(sdata->debugfs.default_unicast_key);
-		sdata->debugfs.default_unicast_key = NULL;
+	}
+
+	if (sdata->debugfs.default_multicast_key) {
+		debugfs_remove(sdata->debugfs.default_multicast_key);
+		sdata->debugfs.default_multicast_key = NULL;
 	}
 
 	if (sdata->default_multicast_key) {
@@ -302,9 +309,6 @@ void ieee80211_debugfs_key_update_default(struct ieee80211_sub_if_data *sdata)
 		sdata->debugfs.default_multicast_key =
 			debugfs_create_symlink("default_multicast_key",
 					       sdata->debugfs.dir, buf);
-	} else {
-		debugfs_remove(sdata->debugfs.default_multicast_key);
-		sdata->debugfs.default_multicast_key = NULL;
 	}
 }
 
-- 
1.7.10

