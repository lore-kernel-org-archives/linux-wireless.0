Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52992 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbbKQIYv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 03:24:51 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/8] mac80211: add atomic uploaded keys iterator
Date: Tue, 17 Nov 2015 10:24:37 +0200
Message-Id: <1447748680-23075-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151117_092500_520559_C2E44DD4)
In-Reply-To: <1447748680-23075-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1447748680-23075-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

add ieee80211_iter_keys_rcu() to iterate over uploaded
keys in atomic context (when rcu is locked)

The station removal code removes the keys only after
calling synchronize_net(), so it's not safe to iterate
the keys at this point (and postponing the actual key
deletion with call_rcu() might result in some
badly-ordered ops calls).

Add a flag to indicate a station is being removed,
and skip the configured keys if it's set.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h  | 24 +++++++++++++++++++++
 net/mac80211/key.c      | 56 +++++++++++++++++++++++++++++++++++++++++++++----
 net/mac80211/sta_info.c |  1 +
 net/mac80211/sta_info.h |  2 ++
 4 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f5a9571..bcb7022 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4916,6 +4916,30 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
 			 void *iter_data);
 
 /**
+ * ieee80211_iter_keys_rcu - iterate keys programmed into the device
+ * @hw: pointer obtained from ieee80211_alloc_hw()
+ * @vif: virtual interface to iterate, may be %NULL for all
+ * @iter: iterator function that will be called for each key
+ * @iter_data: custom data to pass to the iterator function
+ *
+ * This function can be used to iterate all the keys known to
+ * mac80211, even those that weren't previously programmed into
+ * the device. Note that due to locking reasons, keys of station
+ * in removal process will be skipped.
+ *
+ * This function requires being called in an RCU critical section,
+ * and thus iter must be atomic.
+ */
+void ieee80211_iter_keys_rcu(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
+			     void (*iter)(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif,
+					  struct ieee80211_sta *sta,
+					  struct ieee80211_key_conf *key,
+					  void *data),
+			     void *iter_data);
+
+/**
  * ieee80211_iter_chan_contexts_atomic - iterate channel contexts
  * @hw: pointre obtained from ieee80211_alloc_hw().
  * @iter: iterator function
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 44388d6..5e5bc59 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -4,6 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007-2008	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright 2015	Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -320,7 +321,7 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	if (new)
-		list_add_tail(&new->list, &sdata->key_list);
+		list_add_tail_rcu(&new->list, &sdata->key_list);
 
 	WARN_ON(new && old && new->conf.keyidx != old->conf.keyidx);
 
@@ -368,7 +369,7 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (old)
-		list_del(&old->list);
+		list_del_rcu(&old->list);
 }
 
 struct ieee80211_key *
@@ -592,8 +593,8 @@ static void ieee80211_key_destroy(struct ieee80211_key *key,
 		return;
 
 	/*
-	 * Synchronize so the TX path can no longer be using
-	 * this key before we free/remove it.
+	 * Synchronize so the TX path and rcu key iterators
+	 * can no longer be using this key before we free/remove it.
 	 */
 	synchronize_net();
 
@@ -744,6 +745,53 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_iter_keys);
 
+static void
+_ieee80211_iter_keys_rcu(struct ieee80211_hw *hw,
+			 struct ieee80211_sub_if_data *sdata,
+			 void (*iter)(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_sta *sta,
+				      struct ieee80211_key_conf *key,
+				      void *data),
+			 void *iter_data)
+{
+	struct ieee80211_key *key;
+
+	list_for_each_entry_rcu(key, &sdata->key_list, list) {
+		/* skip keys of station in removal process */
+		if (key->sta && key->sta->removed)
+			continue;
+		if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
+			continue;
+
+		iter(hw, &sdata->vif,
+		     key->sta ? &key->sta->sta : NULL,
+		     &key->conf, iter_data);
+	}
+}
+
+void ieee80211_iter_keys_rcu(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
+			     void (*iter)(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif,
+					  struct ieee80211_sta *sta,
+					  struct ieee80211_key_conf *key,
+					  void *data),
+			     void *iter_data)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+
+	if (vif) {
+		sdata = vif_to_sdata(vif);
+		_ieee80211_iter_keys_rcu(hw, sdata, iter, iter_data);
+	} else {
+		list_for_each_entry_rcu(sdata, &local->interfaces, list)
+			_ieee80211_iter_keys_rcu(hw, sdata, iter, iter_data);
+	}
+}
+EXPORT_SYMBOL(ieee80211_iter_keys_rcu);
+
 static void ieee80211_free_keys_iface(struct ieee80211_sub_if_data *sdata,
 				      struct list_head *keys)
 {
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 723fa30..4402ad5 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -883,6 +883,7 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	}
 
 	list_del_rcu(&sta->list);
+	sta->removed = true;
 
 	drv_sta_pre_rcu_remove(local, sta->sdata, sta);
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 2cafb21..d605162 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -367,6 +367,7 @@ DECLARE_EWMA(signal, 1024, 8)
  * @mesh: mesh STA information
  * @debugfs: debug filesystem info
  * @dead: set to true when sta is unlinked
+ * @removed: set to true when sta is being removed from sta_list
  * @uploaded: set to true when sta is uploaded to the driver
  * @sta: station information we share with the driver
  * @sta_state: duplicates information about station state (for debug)
@@ -412,6 +413,7 @@ struct sta_info {
 	u16 listen_interval;
 
 	bool dead;
+	bool removed;
 
 	bool uploaded;
 
-- 
2.5.0

