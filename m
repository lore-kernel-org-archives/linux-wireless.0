Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:49000 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934310AbXCWUnk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:40 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 13/19] mac80211: fix remaining sparse warnings
Message-Id: <20070323204456.154BC48584@silver.suse.cz>
Date: Fri, 23 Mar 2007 21:44:56 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

This patch fixes the sparse warnings that remain after Michael Wu's
patches as well as those I might have introduced myself during the
debugfs restructuring...

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/mac80211/debugfs_netdev.c  |    4 ++--
 net/mac80211/ieee80211.c       |    2 +-
 net/mac80211/ieee80211_ioctl.c |    2 +-
 net/mac80211/sta_info.c        |   21 +++++++++++++++------
 4 files changed, 19 insertions(+), 10 deletions(-)

a290e1fe4bd5779b96e07cc9deff9c75b7887a54
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 7b713fb..9e39646 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
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
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index db04fd8..24cc3a0 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -97,7 +97,7 @@ struct ieee80211_key *ieee80211_key_allo
 	return key;
 }
 
-void ieee80211_key_release(struct kref *kref)
+static void ieee80211_key_release(struct kref *kref)
 {
 	struct ieee80211_key *key;
 
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index cb75015..21a17eb 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -518,7 +518,7 @@ int ieee80211_set_hw_encryption(struct n
 
 
 static int ieee80211_set_encryption(struct net_device *dev, u8 *sta_addr,
-				    int idx, int alg, int set_tx_key, int *err,
+				    int idx, int alg, int set_tx_key, u32 *err,
 				    const u8 *_key, size_t key_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index dfbd369..4e341f6 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -102,7 +102,7 @@ int sta_info_min_txrate_get(struct ieee8
 }
 
 
-void sta_info_release(struct kref *kref)
+static void sta_info_release(struct kref *kref)
 {
 	struct sta_info *sta = container_of(kref, struct sta_info, kref);
 	struct ieee80211_local *local = sta->local;
@@ -210,14 +210,11 @@ #endif /* CONFIG_MAC80211_VERBOSE_DEBUG 
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
-- 
1.3.0

