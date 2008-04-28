Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765222AbYD1SSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2008 14:18:51 -0400
Subject: Re: rt61pci current wireless testing git gives kernel oops
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Bas Hulsken <bhulsken@hotmail.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <200804252031.56605.IvDoorn@gmail.com> (sfid-20080425_203116_969250_F59BCB3A)
References: <1209147056.2955.7.camel@Bas>
	 <200804252031.56605.IvDoorn@gmail.com>
	 (sfid-20080425_203116_969250_F59BCB3A)
Content-Type: text/plain
Date: Mon, 28 Apr 2008 20:18:36 +0200
Message-Id: <1209406716.29025.18.camel@johannes.berg> (sfid-20080428_201857_920998_DB81EA1D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > the interface goes up well, but I get an oops as soon as I run hostapd,
> > seems something with debugfs. This shows up in dmesg, let me know if you
> > need any more info.

Bas, can you reproduce this issue? Could you try the patch below?

johannes

---
 net/mac80211/debugfs_key.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- everything.orig/net/mac80211/debugfs_key.c	2008-04-28 20:15:42.000000000 +0200
+++ everything/net/mac80211/debugfs_key.c	2008-04-28 20:15:44.000000000 +0200
@@ -255,14 +255,29 @@ void ieee80211_debugfs_key_remove(struct
 void ieee80211_debugfs_key_add_default(struct ieee80211_sub_if_data *sdata)
 {
 	char buf[50];
+	struct ieee80211_key *key;
 
 	if (!sdata->debugfsdir)
 		return;
 
-	sprintf(buf, "../keys/%d", sdata->default_key->debugfs.cnt);
-	sdata->debugfs.default_key =
-		debugfs_create_symlink("default_key", sdata->debugfsdir, buf);
+	rcu_read_lock();
+	key = rcu_dereference(sdata->default_key);
+	if (key) {
+		sprintf(buf, "../keys/%d", key->debugfs.cnt);
+		sdata->debugfs.default_key =
+			debugfs_create_symlink("default_key",
+					       sdata->debugfsdir, buf);
+	} else {
+		/*
+		 * Oops. No default key, let's remove the debugfs entry
+		 * This can happen if the workqueue is too slow.
+		 */
+		debugfs_remove(sdata->debugfs.default_key);
+		sdata->debugfs.default_key = NULL;
+	}
+	rcu_read_unlock();
 }
+
 void ieee80211_debugfs_key_remove_default(struct ieee80211_sub_if_data *sdata)
 {
 	if (!sdata)


