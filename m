Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40286 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2IKNZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 09:25:47 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC v2 01/12] mac80211: introduce channel context skeleton code
Date: Tue, 11 Sep 2012 15:26:12 +0200
Message-Id: <1347369983-12459-2-git-send-email-johannes@sipsolutions.net> (sfid-20120911_152555_787317_E0DAB13C)
In-Reply-To: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net>
References: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Channel context are the foundation for multi-channel
operation. They are are immutable and are re-created
(or re-used if other interfaces are bound to a certain
channel and a compatible channel type) on channel
switching.

This is an initial implementation and more features
will come in separate patches.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
[some changes including RCU protection]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |   36 ++++++++++++
 net/mac80211/chan.c        |  136 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |   34 +++++++++++
 net/mac80211/main.c        |    3 +
 4 files changed, 209 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 82558c8..ab1b5ba 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -144,6 +144,32 @@ struct ieee80211_low_level_stats {
 };
 
 /**
+ * enum ieee80211_chanctx_change - change flag for channel context
+ * @IEEE80211_CHANCTX_CHANGE_CHANNEL_TYPE: The channel type was changed
+ */
+enum ieee80211_chanctx_change {
+	IEEE80211_CHANCTX_CHANGE_CHANNEL_TYPE	= BIT(0),
+};
+
+/**
+ * struct ieee80211_chanctx_conf - channel context that vifs may be tuned to
+ *
+ * This is the driver-visible part. The ieee80211_chanctx
+ * that contains it is visible in mac80211 only.
+ *
+ * @channel: the channel to tune to
+ * @channel_type: the channel (HT) type
+ * @drv_priv: data area for driver use, will always be aligned to
+ *	sizeof(void *), size is determined in hw information.
+ */
+struct ieee80211_chanctx_conf {
+	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
+
+	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
+};
+
+/**
  * enum ieee80211_bss_change - BSS change notification flags
  *
  * These flags are used with the bss_info_changed() callback
@@ -931,6 +957,11 @@ enum ieee80211_vif_flags {
  *	at runtime, mac80211 will never touch this field
  * @hw_queue: hardware queue for each AC
  * @cab_queue: content-after-beacon (DTIM beacon really) queue, AP mode only
+ * @chanctx_conf: The channel context this interface is assigned to, or %NULL
+ *	when it is not assigned. This pointer is RCU-protected due to the TX
+ *	path needing to access it; even though the netdev carrier will always
+ *	be off when it is %NULL there can still be races and packets could be
+ *	processed after it switches back to %NULL.
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *).
  */
@@ -943,6 +974,8 @@ struct ieee80211_vif {
 	u8 cab_queue;
 	u8 hw_queue[IEEE80211_NUM_ACS];
 
+	struct ieee80211_chanctx_conf __rcu *chanctx_conf;
+
 	u32 driver_flags;
 
 	/* must be last */
@@ -1325,6 +1358,8 @@ enum ieee80211_hw_flags {
  *	within &struct ieee80211_vif.
  * @sta_data_size: size (in bytes) of the drv_priv data area
  *	within &struct ieee80211_sta.
+ * @chanctx_data_size: size (in bytes) of the drv_priv data area
+ *	within &struct ieee80211_chanctx_conf.
  *
  * @max_rates: maximum number of alternate rate retry stages the hw
  *	can handle.
@@ -1369,6 +1404,7 @@ struct ieee80211_hw {
 	int channel_change_time;
 	int vif_data_size;
 	int sta_data_size;
+	int chanctx_data_size;
 	int napi_weight;
 	u16 queues;
 	u16 max_listen_interval;
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 0bfc914..9674968 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -168,3 +168,139 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 	return true;
 
 }
+
+static struct ieee80211_chanctx *
+ieee80211_find_chanctx(struct ieee80211_local *local,
+		       struct ieee80211_channel *channel,
+		       enum nl80211_channel_type channel_type,
+		       enum ieee80211_chanctx_mode mode)
+{
+	struct ieee80211_chanctx *ctx;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	if (mode == IEEE80211_CHANCTX_EXCLUSIVE)
+		return NULL;
+	if (WARN_ON(!channel))
+		return NULL;
+
+	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
+			continue;
+		if (ctx->conf.channel != channel)
+			continue;
+		if (ctx->conf.channel_type != channel_type)
+			continue;
+
+		return ctx;
+	}
+
+	return NULL;
+}
+
+static struct ieee80211_chanctx *
+ieee80211_new_chanctx(struct ieee80211_local *local,
+		      struct ieee80211_channel *channel,
+		      enum nl80211_channel_type channel_type,
+		      enum ieee80211_chanctx_mode mode)
+{
+	struct ieee80211_chanctx *ctx;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	ctx = kzalloc(sizeof(*ctx) + local->hw.chanctx_data_size, GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	ctx->conf.channel = channel;
+	ctx->conf.channel_type = channel_type;
+	ctx->mode = mode;
+
+	list_add(&ctx->list, &local->chanctx_list);
+
+	return ctx;
+}
+
+static void ieee80211_free_chanctx(struct ieee80211_local *local,
+				   struct ieee80211_chanctx *ctx)
+{
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	WARN_ON_ONCE(ctx->refcount != 0);
+
+	list_del(&ctx->list);
+	kfree_rcu(ctx, rcu_head);
+}
+
+static void ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
+					 struct ieee80211_chanctx *ctx)
+{
+	struct ieee80211_local *local __maybe_unused = sdata->local;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
+	ctx->refcount++;
+}
+
+static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
+					   struct ieee80211_chanctx *ctx)
+{
+	struct ieee80211_local *local __maybe_unused = sdata->local;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	ctx->refcount--;
+	rcu_assign_pointer(sdata->vif.chanctx_conf, NULL);
+}
+
+static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *conf;
+	struct ieee80211_chanctx *ctx;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (!conf)
+		return;
+
+	ctx = container_of(conf, struct ieee80211_chanctx, conf);
+
+	ieee80211_unassign_vif_chanctx(sdata, ctx);
+	if (ctx->refcount == 0)
+		ieee80211_free_chanctx(local, ctx);
+}
+
+bool ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
+			       struct ieee80211_channel *channel,
+			       enum nl80211_channel_type channel_type,
+			       enum ieee80211_chanctx_mode mode)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx *ctx;
+
+	mutex_lock(&local->chanctx_mtx);
+	__ieee80211_vif_release_channel(sdata);
+
+	ctx = ieee80211_find_chanctx(local, channel, channel_type, mode);
+	if (!ctx)
+		ctx = ieee80211_new_chanctx(local, channel, channel_type, mode);
+	if (!ctx) {
+		mutex_unlock(&local->chanctx_mtx);
+		return false;
+	}
+
+	ieee80211_assign_vif_chanctx(sdata, ctx);
+	mutex_unlock(&local->chanctx_mtx);
+	return true;
+}
+
+void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
+{
+	mutex_lock(&sdata->local->chanctx_mtx);
+	__ieee80211_vif_release_channel(sdata);
+	mutex_unlock(&sdata->local->chanctx_mtx);
+}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8c80455..6199a25 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -658,6 +658,30 @@ enum ieee80211_sdata_state_bits {
 	SDATA_STATE_OFFCHANNEL,
 };
 
+/**
+ * enum ieee80211_chanctx_mode - channel context configuration mode
+ *
+ * @IEEE80211_CHANCTX_SHARED: channel context may be used by
+ *	multiple interfaces
+ * @IEEE80211_CHANCTX_EXCLUSIVE: channel context can be used
+ *	only by a single interface. This can be used for example for
+ *	non-fixed channel IBSS.
+ */
+enum ieee80211_chanctx_mode {
+	IEEE80211_CHANCTX_SHARED,
+	IEEE80211_CHANCTX_EXCLUSIVE
+};
+
+struct ieee80211_chanctx {
+	struct list_head list;
+	struct rcu_head rcu_head;
+
+	enum ieee80211_chanctx_mode mode;
+	int refcount;
+
+	struct ieee80211_chanctx_conf conf;
+};
+
 struct ieee80211_sub_if_data {
 	struct list_head list;
 
@@ -987,6 +1011,10 @@ struct ieee80211_local {
 	struct ieee80211_channel *tmp_channel;
 	enum nl80211_channel_type tmp_channel_type;
 
+	/* channel contexts */
+	struct list_head chanctx_list;
+	struct mutex chanctx_mtx;
+
 	/* SNMP counters */
 	/* dot11CountersTable */
 	u32 dot11TransmittedFragmentCount;
@@ -1510,6 +1538,12 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 enum nl80211_channel_type
 ieee80211_ht_oper_to_channel_type(struct ieee80211_ht_operation *ht_oper);
 
+bool ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
+			       struct ieee80211_channel *channel,
+			       enum nl80211_channel_type channel_type,
+			       enum ieee80211_chanctx_mode mode);
+void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
+
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
 #else
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c80c449..9be3ef1 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -626,6 +626,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	spin_lock_init(&local->filter_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
+	INIT_LIST_HEAD(&local->chanctx_list);
+	mutex_init(&local->chanctx_mtx);
+
 	/*
 	 * The rx_skb_queue is only accessed from tasklets,
 	 * but other SKB queues are used from within IRQ
-- 
1.7.10.4

