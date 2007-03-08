Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57086 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbXCHPc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 10:32:57 -0500
Subject: [PATCH] mac80211: fix remaining sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 02:47:43 +0100
Message-Id: <1173318463.3546.48.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the sparse warnings that remain after Michael Wu's
patches as well as those I might have introduced myself during the
debugfs restructuring...

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/debugfs_netdev.c  |    4 ++--
 net/mac80211/ieee80211.c       |    2 +-
 net/mac80211/ieee80211_ioctl.c |    2 +-
 net/mac80211/sta_info.c        |   21 +++++++++++++++------
 4 files changed, 19 insertions(+), 10 deletions(-)

--- wireless-dev.orig/net/mac80211/debugfs_netdev.c	2007-03-08 02:39:03.713607522 +0100
+++ wireless-dev/net/mac80211/debugfs_netdev.c	2007-03-08 02:39:10.883607522 +0100
@@ -244,7 +244,7 @@ static void add_monitor_files(struct iee
 	DEBUGFS_ADD(mode, monitor);
 }
 
-void add_files(struct ieee80211_sub_if_data *sdata)
+static void add_files(struct ieee80211_sub_if_data *sdata)
 {
 	if (!sdata->debugfsdir)
 		return;
@@ -337,7 +337,7 @@ static void del_monitor_files(struct iee
 	DEBUGFS_DEL(mode, monitor);
 }
 
-void del_files(struct ieee80211_sub_if_data *sdata, int type)
+static void del_files(struct ieee80211_sub_if_data *sdata, int type)
 {
 	if (!sdata->debugfsdir)
 		return;
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-03-08 02:39:38.093607522 +0100
+++ wireless-dev/net/mac80211/ieee80211.c	2007-03-08 02:39:41.913607522 +0100
@@ -97,7 +97,7 @@ struct ieee80211_key *ieee80211_key_allo
 	return key;
 }
 
-void ieee80211_key_release(struct kref *kref)
+static void ieee80211_key_release(struct kref *kref)
 {
 	struct ieee80211_key *key;
 
--- wireless-dev.orig/net/mac80211/sta_info.c	2007-03-08 02:40:13.943607522 +0100
+++ wireless-dev/net/mac80211/sta_info.c	2007-03-08 02:45:05.433607522 +0100
@@ -102,7 +102,7 @@ int sta_info_min_txrate_get(struct ieee8
 }
 
 
-void sta_info_release(struct kref *kref)
+static void sta_info_release(struct kref *kref)
 {
 	struct sta_info *sta = container_of(kref, struct sta_info, kref);
 	struct ieee80211_local *local = sta->local;
@@ -210,14 +210,11 @@ static void finish_sta_info_free(struct 
 	sta_info_put(sta);
 }
 
-void sta_info_free(struct sta_info *sta, int locked)
+static void sta_info_remove(struct sta_info *sta)
 {
-	struct sk_buff *skb;
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata;
 
-	if (!locked)
-		spin_lock_bh(&local->sta_lock);
 	sta_info_hash_del(local, sta);
 	list_del(&sta->list);
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
@@ -228,8 +225,20 @@ void sta_info_free(struct sta_info *sta,
 	}
 	local->num_sta--;
 	sta_info_remove_aid_ptr(sta);
-	if (!locked)
+}
+
+void sta_info_free(struct sta_info *sta, int locked)
+{
+	struct sk_buff *skb;
+	struct ieee80211_local *local = sta->local;
+
+	if (!locked) {
+		spin_lock_bh(&local->sta_lock);
+		sta_info_remove(sta);
 		spin_unlock_bh(&local->sta_lock);
+	} else {
+		sta_info_remove(sta);
+	}
 	if (local->ops->sta_table_notification)
 		local->ops->sta_table_notification(local_to_hw(local),
 						  local->num_sta);
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-03-08 02:40:52.703607522 +0100
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-03-08 02:41:19.163607522 +0100
@@ -518,7 +518,7 @@ int ieee80211_set_hw_encryption(struct n
 
 
 static int ieee80211_set_encryption(struct net_device *dev, u8 *sta_addr,
-				    int idx, int alg, int set_tx_key, int *err,
+				    int idx, int alg, int set_tx_key, u32 *err,
 				    const u8 *_key, size_t key_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);


