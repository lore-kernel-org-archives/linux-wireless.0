Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52627 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab2INMgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 08:36:43 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/10] mac80211: add channel context iterator
Date: Fri, 14 Sep 2012 14:37:12 +0200
Message-Id: <1347626233-21916-10-git-send-email-johannes@sipsolutions.net> (sfid-20120914_143653_683949_3143E4D6)
In-Reply-To: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
References: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Drivers may need to iterate the active channel
contexts, export an iterator function to allow
that. To make it possible, use RCU-safe list
functions.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |   21 +++++++++++++++++++++
 net/mac80211/chan.c    |   22 ++++++++++++++++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3560881..f12df5b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3597,6 +3597,27 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
 			 void *iter_data);
 
 /**
+ * ieee80211_iter_chan_contexts_atomic - iterate channel contexts
+ * @hw: pointre obtained from ieee80211_alloc_hw().
+ * @iter: iterator function
+ * @iter_data: data passed to iterator function
+ *
+ * Iterate all active channel contexts. This function is atomic and
+ * doesn't acquire any locks internally that might be held in other
+ * places while calling into the driver.
+ *
+ * The iterator will not find a context that's being added (during
+ * the driver callback to add it) but will find it while it's being
+ * removed.
+ */
+void ieee80211_iter_chan_contexts_atomic(
+	struct ieee80211_hw *hw,
+	void (*iter)(struct ieee80211_hw *hw,
+		     struct ieee80211_chanctx_conf *chanctx_conf,
+		     void *data),
+	void *iter_data);
+
+/**
  * ieee80211_ap_probereq_get - retrieve a Probe Request template
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index c2df2b6..7ebf8e4 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/nl80211.h>
+#include <linux/export.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
 #include "driver-ops.h"
@@ -134,7 +135,7 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 		}
 	}
 
-	list_add(&ctx->list, &local->chanctx_list);
+	list_add_rcu(&ctx->list, &local->chanctx_list);
 
 	return ctx;
 }
@@ -153,7 +154,7 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 		drv_remove_chanctx(local, ctx);
 	}
 
-	list_del(&ctx->list);
+	list_del_rcu(&ctx->list);
 	kfree_rcu(ctx, rcu_head);
 }
 
@@ -377,3 +378,20 @@ void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 	__ieee80211_vif_release_channel(sdata);
 	mutex_unlock(&sdata->local->chanctx_mtx);
 }
+
+void ieee80211_iter_chan_contexts_atomic(
+	struct ieee80211_hw *hw,
+	void (*iter)(struct ieee80211_hw *hw,
+		     struct ieee80211_chanctx_conf *chanctx_conf,
+		     void *data),
+	void *iter_data)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_chanctx *ctx;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ctx, &local->chanctx_list, list)
+		iter(hw, &ctx->conf, iter_data);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(ieee80211_iter_chan_contexts_atomic);
-- 
1.7.10.4

