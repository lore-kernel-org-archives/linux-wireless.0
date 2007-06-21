Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39584 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbXFVIk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:40:57 -0400
Message-Id: <20070621221759.718314000@sipsolutions.net>
References: <20070621221603.778432000@sipsolutions.net>
Date: Fri, 22 Jun 2007 00:16:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: [PATCH 10/14] mac80211: split out some key functions from  ieee80211.c
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

into a new file key.c which doesn't have much code right now but
it makes ieee80211.c easier to read.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/Makefile      |    1 
 net/mac80211/ieee80211.c   |   56 ------------------------------------
 net/mac80211/ieee80211_i.h |   14 +++++----
 net/mac80211/key.c         |   69 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 78 insertions(+), 62 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-06-21 23:27:02.648638003 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-06-21 23:30:12.518638003 +0200
@@ -33,7 +33,6 @@
 #include "ieee80211_cfg.h"
 #include "debugfs.h"
 #include "debugfs_netdev.h"
-#include "debugfs_key.h"
 
 /* privid for wiphys to determine whether they belong to us or not */
 void *mac80211_wiphy_privid = &mac80211_wiphy_privid;
@@ -63,61 +62,6 @@ struct ieee80211_tx_status_rtap_hdr {
 } __attribute__ ((packed));
 
 
-struct ieee80211_key_conf *
-ieee80211_key_data2conf(struct ieee80211_local *local,
-			const struct ieee80211_key *data)
-{
-	struct ieee80211_key_conf *conf;
-
-	conf = kmalloc(sizeof(*conf) + data->keylen, GFP_ATOMIC);
-	if (!conf)
-		return NULL;
-
-	conf->hw_key_idx = data->hw_key_idx;
-	conf->alg = data->alg;
-	conf->keylen = data->keylen;
-	conf->flags = 0;
-	if (data->force_sw_encrypt)
-		conf->flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
-	conf->keyidx = data->keyidx;
-	if (data->default_tx_key)
-		conf->flags |= IEEE80211_KEY_DEFAULT_TX_KEY;
-	if (local->default_wep_only)
-		conf->flags |= IEEE80211_KEY_DEFAULT_WEP_ONLY;
-	memcpy(conf->key, data->key, data->keylen);
-
-	return conf;
-}
-
-struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
-					  int idx, size_t key_len, gfp_t flags)
-{
-	struct ieee80211_key *key;
-
-	key = kzalloc(sizeof(struct ieee80211_key) + key_len, flags);
-	if (!key)
-		return NULL;
-	kref_init(&key->kref);
-	return key;
-}
-
-static void ieee80211_key_release(struct kref *kref)
-{
-	struct ieee80211_key *key;
-
-	key = container_of(kref, struct ieee80211_key, kref);
-	if (key->alg == ALG_CCMP)
-		ieee80211_aes_key_free(key->u.ccmp.tfm);
-	ieee80211_debugfs_key_remove(key);
-	kfree(key);
-}
-
-void ieee80211_key_free(struct ieee80211_key *key)
-{
-	if (key)
-		kref_put(&key->kref, ieee80211_key_release);
-}
-
 static int rate_list_match(const int *rate_list, int rate)
 {
 	int i;
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-06-21 23:26:37.288638003 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-06-21 23:29:27.118638003 +0200
@@ -795,12 +795,6 @@ static inline int ieee80211_bssid_match(
 int ieee80211_hw_config(struct ieee80211_local *local);
 int ieee80211_if_config(struct net_device *dev);
 int ieee80211_if_config_beacon(struct net_device *dev);
-struct ieee80211_key_conf *
-ieee80211_key_data2conf(struct ieee80211_local *local,
-			const struct ieee80211_key *data);
-struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
-					  int idx, size_t key_len, gfp_t flags);
-void ieee80211_key_free(struct ieee80211_key *key);
 void ieee80211_rx_mgmt(struct ieee80211_local *local, struct sk_buff *skb,
 		       struct ieee80211_rx_status *status, u32 msg_type);
 void ieee80211_prepare_rates(struct ieee80211_local *local,
@@ -936,6 +930,14 @@ int ieee80211_monitor_start_xmit(struct 
 int ieee80211_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
 int ieee80211_mgmt_start_xmit(struct sk_buff *skb, struct net_device *dev);
 
+/* key handling */
+struct ieee80211_key_conf *
+ieee80211_key_data2conf(struct ieee80211_local *local,
+			const struct ieee80211_key *data);
+struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
+					  int idx, size_t key_len, gfp_t flags);
+void ieee80211_key_free(struct ieee80211_key *key);
+
 /* for wiphy privid */
 extern void *mac80211_wiphy_privid;
 
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/mac80211/key.c	2007-06-21 23:31:03.308638003 +0200
@@ -0,0 +1,69 @@
+/*
+ * Copyright 2002-2005, Instant802 Networks, Inc.
+ * Copyright 2005-2006, Devicescape Software, Inc.
+ * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+#include "debugfs_key.h"
+#include "aes_ccm.h"
+
+struct ieee80211_key_conf *
+ieee80211_key_data2conf(struct ieee80211_local *local,
+			const struct ieee80211_key *data)
+{
+	struct ieee80211_key_conf *conf;
+
+	conf = kmalloc(sizeof(*conf) + data->keylen, GFP_ATOMIC);
+	if (!conf)
+		return NULL;
+
+	conf->hw_key_idx = data->hw_key_idx;
+	conf->alg = data->alg;
+	conf->keylen = data->keylen;
+	conf->flags = 0;
+	if (data->force_sw_encrypt)
+		conf->flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
+	conf->keyidx = data->keyidx;
+	if (data->default_tx_key)
+		conf->flags |= IEEE80211_KEY_DEFAULT_TX_KEY;
+	if (local->default_wep_only)
+		conf->flags |= IEEE80211_KEY_DEFAULT_WEP_ONLY;
+	memcpy(conf->key, data->key, data->keylen);
+
+	return conf;
+}
+
+struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
+					  int idx, size_t key_len, gfp_t flags)
+{
+	struct ieee80211_key *key;
+
+	key = kzalloc(sizeof(struct ieee80211_key) + key_len, flags);
+	if (!key)
+		return NULL;
+	kref_init(&key->kref);
+	return key;
+}
+
+static void ieee80211_key_release(struct kref *kref)
+{
+	struct ieee80211_key *key;
+
+	key = container_of(kref, struct ieee80211_key, kref);
+	if (key->alg == ALG_CCMP)
+		ieee80211_aes_key_free(key->u.ccmp.tfm);
+	ieee80211_debugfs_key_remove(key);
+	kfree(key);
+}
+
+void ieee80211_key_free(struct ieee80211_key *key)
+{
+	if (key)
+		kref_put(&key->kref, ieee80211_key_release);
+}
--- wireless-dev.orig/net/mac80211/Makefile	2007-06-21 23:27:51.778638003 +0200
+++ wireless-dev/net/mac80211/Makefile	2007-06-21 23:27:55.088638003 +0200
@@ -20,4 +20,5 @@ mac80211-objs := \
 	ieee80211_cfg.o \
 	rx.o \
 	tx.o \
+	key.o \
 	$(mac80211-objs-y)

-- 

