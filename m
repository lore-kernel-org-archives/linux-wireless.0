Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47276 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935309AbYEBXE4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 19:04:56 -0400
Subject: [PATCH] mac80211: fix debugfs default key oops
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Bas Gooijen <gooijen@home.nl>
Content-Type: text/plain
Date: Sat, 03 May 2008 01:04:47 +0200
Message-Id: <1209769487.3608.33.camel@johannes.berg> (sfid-20080503_010432_525956_5103E7A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under certain circumstances (in AP mode) the debugfs function
that is supposed to add the default key symlink can encounter
a NULL default_key pointer. This patch makes it handle that
situtation gracefully.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_key.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- everything.orig/net/mac80211/debugfs_key.c	2008-04-30 19:54:02.000000000 +0200
+++ everything/net/mac80211/debugfs_key.c	2008-04-30 19:54:29.000000000 +0200
@@ -255,14 +255,23 @@ void ieee80211_debugfs_key_remove(struct
 void ieee80211_debugfs_key_add_default(struct ieee80211_sub_if_data *sdata)
 {
 	char buf[50];
+	struct ieee80211_key *key;
 
 	if (!sdata->debugfsdir)
 		return;
 
-	sprintf(buf, "../keys/%d", sdata->default_key->debugfs.cnt);
-	sdata->debugfs.default_key =
-		debugfs_create_symlink("default_key", sdata->debugfsdir, buf);
+	/* this is running under the key lock */
+
+	key = sdata->default_key;
+	if (key) {
+		sprintf(buf, "../keys/%d", key->debugfs.cnt);
+		sdata->debugfs.default_key =
+			debugfs_create_symlink("default_key",
+					       sdata->debugfsdir, buf);
+	} else
+		ieee80211_debugfs_key_remove_default(sdata);
 }
+
 void ieee80211_debugfs_key_remove_default(struct ieee80211_sub_if_data *sdata)
 {
 	if (!sdata)


