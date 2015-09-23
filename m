Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60075 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbbIWImb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 04:42:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: allow writing TX PN in debugfs
Date: Wed, 23 Sep 2015 10:42:28 +0200
Message-Id: <1442997748-13741-1-git-send-email-johannes@sipsolutions.net> (sfid-20150923_104247_640158_5B3D926C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For certain tests, for example replay detection, it can be useful
to be able to influence/set the PN used in outgoing packets. Make
it possible to change the TX PN in debugfs.

For now, this doesn't support TKIP since I haven't needed it, but
there's no reason it couldn't be added if necessary.

Note that this must be used very carefully: it could, for example,
be used to make "valid replays" where the PN reuse happens on a
different TID. This couldn't be done by an attacker since the TID
is protected as part of the AAD.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_key.c | 51 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 702ca122c498..7961e7d0b61e 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -2,6 +2,7 @@
  * Copyright 2003-2005	Devicescape Software, Inc.
  * Copyright (c) 2006	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright (C) 2015	Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -34,6 +35,14 @@ static const struct file_operations key_ ##name## _ops = {		\
 	.llseek = generic_file_llseek,					\
 }
 
+#define KEY_OPS_W(name)							\
+static const struct file_operations key_ ##name## _ops = {		\
+	.read = key_##name##_read,					\
+	.write = key_##name##_write,					\
+	.open = simple_open,						\
+	.llseek = generic_file_llseek,					\
+}
+
 #define KEY_FILE(name, format)						\
 		 KEY_READ_##format(name)				\
 		 KEY_OPS(name)
@@ -74,6 +83,41 @@ static ssize_t key_algorithm_read(struct file *file,
 }
 KEY_OPS(algorithm);
 
+static ssize_t key_tx_spec_write(struct file *file, const char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	struct ieee80211_key *key = file->private_data;
+	u64 pn;
+	int ret;
+
+	switch (key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		return -EINVAL;
+	case WLAN_CIPHER_SUITE_TKIP:
+		/* not supported yet */
+		return -EOPNOTSUPP;
+	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		ret = kstrtou64_from_user(userbuf, count, 16, &pn);
+		if (ret)
+			return ret;
+		/* PN is a 48-bit counter */
+		if (pn >= (1ULL << 48))
+			return -ERANGE;
+		atomic64_set(&key->conf.tx_pn, pn);
+		return count;
+	default:
+		return 0;
+	}
+}
+
 static ssize_t key_tx_spec_read(struct file *file, char __user *userbuf,
 				size_t count, loff_t *ppos)
 {
@@ -110,7 +154,7 @@ static ssize_t key_tx_spec_read(struct file *file, char __user *userbuf,
 	}
 	return simple_read_from_buffer(userbuf, count, ppos, buf, len);
 }
-KEY_OPS(tx_spec);
+KEY_OPS_W(tx_spec);
 
 static ssize_t key_rx_spec_read(struct file *file, char __user *userbuf,
 				size_t count, loff_t *ppos)
@@ -278,6 +322,9 @@ KEY_OPS(key);
 #define DEBUGFS_ADD(name) \
 	debugfs_create_file(#name, 0400, key->debugfs.dir, \
 			    key, &key_##name##_ops);
+#define DEBUGFS_ADD_W(name) \
+	debugfs_create_file(#name, 0600, key->debugfs.dir, \
+			    key, &key_##name##_ops);
 
 void ieee80211_debugfs_key_add(struct ieee80211_key *key)
 {
@@ -310,7 +357,7 @@ void ieee80211_debugfs_key_add(struct ieee80211_key *key)
 	DEBUGFS_ADD(keyidx);
 	DEBUGFS_ADD(hw_key_idx);
 	DEBUGFS_ADD(algorithm);
-	DEBUGFS_ADD(tx_spec);
+	DEBUGFS_ADD_W(tx_spec);
 	DEBUGFS_ADD(rx_spec);
 	DEBUGFS_ADD(replays);
 	DEBUGFS_ADD(icverrors);
-- 
2.5.1

