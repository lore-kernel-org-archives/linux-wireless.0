Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42913 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2AQJcD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 04:32:03 -0500
Subject: [PATCH] mac80211: fix debugfs key->station symlink
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 10:32:01 +0100
Message-ID: <1326792721.3342.6.camel@jlt3.sipsolutions.net> (sfid-20120117_103207_287140_C4040E8C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since stations moved into a virtual interface
subdirectory, this link has been broken. Fix it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_key.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/mac80211/debugfs_key.c	2012-01-17 10:30:35.000000000 +0100
+++ b/net/mac80211/debugfs_key.c	2012-01-17 10:30:38.000000000 +0100
@@ -225,9 +225,9 @@ KEY_OPS(key);
 			    key, &key_##name##_ops);
 
 void ieee80211_debugfs_key_add(struct ieee80211_key *key)
-  {
+{
 	static int keycount;
-	char buf[50];
+	char buf[100];
 	struct sta_info *sta;
 
 	if (!key->local->debugfs.keys)
@@ -244,7 +244,8 @@ void ieee80211_debugfs_key_add(struct ie
 
 	sta = key->sta;
 	if (sta) {
-		sprintf(buf, "../../stations/%pM", sta->sta.addr);
+		sprintf(buf, "../../netdev:%s/stations/%pM",
+			sta->sdata->name, sta->sta.addr);
 		key->debugfs.stalink =
 			debugfs_create_symlink("station", key->debugfs.dir, buf);
 	}


