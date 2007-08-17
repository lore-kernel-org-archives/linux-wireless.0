Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbXHQXdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 19:33:10 -0400
Subject: [PATCH] mac80211: fix debugfs key directory
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Sat, 18 Aug 2007 01:33:11 +0200
Message-Id: <1187393591.6090.23.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The key directory in debugfs is currently based on the
key index. When writing that, I somehow thought key indizes
were unique, which of course they are not. No harm is
done by this bug except that some keys may not show up
in debugfs. Fix it by simply using an increasing counter
for the key directory, one will have to look at the key's
keyidx and station properties to find out what it really
is.

Also, add an ifidx file to figure out which device the
key belongs to if it's a group key.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
It applies after the previous key debugfs fix bug but I should probably
roll this one into that since it'd make us have less code shuffling
between this and the patch moving embedding the conf.

 net/mac80211/debugfs_key.c |   53 ++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

--- wireless-dev.orig/net/mac80211/debugfs_key.c	2007-08-17 23:03:43.285978363 +0200
+++ wireless-dev/net/mac80211/debugfs_key.c	2007-08-17 23:03:49.905978363 +0200
@@ -14,17 +14,34 @@
 #include "debugfs.h"
 #include "debugfs_key.h"
 
-#define KEY_CONF_READ(name, buflen, format_string)			\
-static ssize_t key_conf_##name##_read(struct file *file,		\
+#define KEY_READ(name, prop, buflen, format_string)			\
+static ssize_t key_##name##_read(struct file *file,			\
 				 char __user *userbuf,			\
 				 size_t count, loff_t *ppos)		\
 {									\
 	char buf[buflen];						\
 	struct ieee80211_key *key = file->private_data;			\
-	int res = scnprintf(buf, buflen, format_string, key->conf.name);\
+	int res = scnprintf(buf, buflen, format_string, key->prop);	\
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
 }
+#define KEY_READ_D(name) KEY_READ(name, name, 20, "%d\n")
+#define KEY_READ_X(name) KEY_READ(name, name, 20, "0x%x\n")
+
+#define KEY_OPS(name)							\
+static const struct file_operations key_ ##name## _ops = {		\
+	.read = key_##name##_read,					\
+	.open = mac80211_open_file_generic,				\
+}
+
+#define KEY_FILE(name, format)						\
+		 KEY_READ_##format(name)				\
+		 KEY_OPS(name)
+
+#define KEY_CONF_READ(name, buflen, format_string)			\
+	KEY_READ(conf_##name, conf.name, buflen, format_string)
+
 #define KEY_CONF_READ_D(name) KEY_CONF_READ(name, 20, "%d\n")
+#define KEY_CONF_READ_X(name) KEY_CONF_READ(name, 20, "0x%x\n")
 
 #define KEY_CONF_OPS(name)						\
 static const struct file_operations key_ ##name## _ops = {		\
@@ -41,32 +58,11 @@ KEY_CONF_FILE(keyidx, D);
 KEY_CONF_FILE(hw_key_idx, D);
 
 
-#define KEY_READ(name, buflen, format_string)				\
-static ssize_t key_##name##_read(struct file *file,			\
-				 char __user *userbuf,			\
-				 size_t count, loff_t *ppos)		\
-{									\
-	char buf[buflen];						\
-	struct ieee80211_key *key = file->private_data;			\
-	int res = scnprintf(buf, buflen, format_string, key->name);	\
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
-}
-#define KEY_READ_D(name) KEY_READ(name, 20, "%d\n")
-#define KEY_READ_X(name) KEY_READ(name, 20, "0x%x\n")
-
-#define KEY_OPS(name)							\
-static const struct file_operations key_ ##name## _ops = {		\
-	.read = key_##name##_read,					\
-	.open = mac80211_open_file_generic,				\
-}
-
-#define KEY_FILE(name, format)						\
-		 KEY_READ_##format(name)				\
-		 KEY_OPS(name)
-
 KEY_FILE(tx_rx_count, D);
 KEY_FILE(flags, X);
 
+KEY_READ(ifidx, sdata->dev->ifindex, 20, "%d\n")
+KEY_OPS(ifidx);
 
 static ssize_t key_algorithm_read(struct file *file,
 				  char __user *userbuf,
@@ -196,12 +192,15 @@ KEY_OPS(key);
 void ieee80211_debugfs_key_add(struct ieee80211_local *local,
 			       struct ieee80211_key *key)
 {
+	static int keycount = 0;
 	char buf[20];
 
 	if (!local->debugfs.keys)
 		return;
 
-	sprintf(buf, "%d", key->conf.keyidx);
+	sprintf(buf, "%d", keycount);
+	keycount++;
+
 	key->debugfs.dir = debugfs_create_dir(buf,
 					local->debugfs.keys);
 


