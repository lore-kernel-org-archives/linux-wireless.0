Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46454 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796Ab2FUMDl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 08:03:41 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Kazior Michal <Michal.Kazior@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC v2 1/7] mac80211: introduce channel contexts skeleton code
Date: Thu, 21 Jun 2012 14:03:30 +0200
Message-ID: <1340280216-18807-2-git-send-email-michal.kazior@tieto.com> (sfid-20120621_140352_366367_9D5DA1CD)
In-Reply-To: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>
References: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kazior Michal <Michal.Kazior@tieto.com>

Channel context are the foundation for
multi-channel operation.

Channel contexts are immutable and are re-created
(or re-used if other interfaces are bound to a
certain channel) on channel switching.

This is a initial implementation and more features
will come in separate patches for easier review.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/mac80211.h     |   41 +++++++++++++++
 net/mac80211/chan.c        |  123 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |   23 ++++++++
 net/mac80211/main.c        |    3 +
 4 files changed, 190 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6914f99..0089798 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -143,6 +143,41 @@ struct ieee80211_low_level_stats {
 	unsigned int dot11RTSSuccessCount;
 };
 
+
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
+/**
+ * struct ieee80211_chanctx_conf - channel context that vifs may be tuned to
+ *
+ * This is the driver-visible part. The ieee80211_chanctx
+ * that contains it is visible in mac80211 only.
+ *
+ * @channel: the channel to tune to
+ * @channel_type: the channel (HT) type
+ * @mode: the channel context mode
+ * @drv_priv: data area for driver use, will always be aligned to
+ *	sizeof(void *), size is determined in hw information.
+ */
+struct ieee80211_chanctx_conf {
+	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
+	enum ieee80211_chanctx_mode mode;
+
+	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
+};
+
 /**
  * enum ieee80211_bss_change - BSS change notification flags
  *
@@ -897,6 +932,7 @@ enum ieee80211_vif_flags {
  *	at runtime, mac80211 will never touch this field
  * @hw_queue: hardware queue for each AC
  * @cab_queue: content-after-beacon (DTIM beacon really) queue, AP mode only
+ * @chanctx_conf: channel context vif is bound to, may be NULL
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *).
  */
@@ -909,6 +945,8 @@ struct ieee80211_vif {
 	u8 cab_queue;
 	u8 hw_queue[IEEE80211_NUM_ACS];
 
+	struct ieee80211_chanctx_conf *chanctx_conf;
+
 	u32 driver_flags;
 
 	/* must be last */
@@ -1268,6 +1306,8 @@ enum ieee80211_hw_flags {
  *	within &struct ieee80211_vif.
  * @sta_data_size: size (in bytes) of the drv_priv data area
  *	within &struct ieee80211_sta.
+ * @chanctx_data_size: size (in bytes) of the drv_priv data area
+ *	within &struct ieee80211_chanctx_conf.
  *
  * @max_rates: maximum number of alternate rate retry stages the hw
  *	can handle.
@@ -1312,6 +1352,7 @@ struct ieee80211_hw {
 	int channel_change_time;
 	int vif_data_size;
 	int sta_data_size;
+	int chanctx_data_size;
 	int napi_weight;
 	u16 queues;
 	u16 max_listen_interval;
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index f0f87e5..f5b4a77 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -139,3 +139,126 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 
 	return result;
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
+	if (mode == IEEE80211_CHANCTX_EXCLUSIVE)
+		return NULL;
+	if (WARN_ON(!channel))
+		return NULL;
+
+	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (ctx->conf.mode == IEEE80211_CHANCTX_EXCLUSIVE)
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
+	ctx = kzalloc(sizeof(*ctx) + local->hw.chanctx_data_size, GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	ctx->conf.channel = channel;
+	ctx->conf.channel_type = channel_type;
+	ctx->conf.mode = mode;
+	ctx->local = local;
+
+	list_add(&ctx->list, &local->chanctx_list);
+	INIT_LIST_HEAD(&ctx->interfaces);
+
+	return ctx;
+}
+
+static void
+ieee80211_free_chanctx(struct ieee80211_chanctx *ctx)
+{
+	BUG_ON(!list_empty(&ctx->interfaces));
+
+	list_del(&ctx->list);
+	kfree(ctx);
+}
+
+static void
+ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
+			     struct ieee80211_chanctx *ctx)
+{
+	list_add(&sdata->chanctx_listitem, &ctx->interfaces);
+	sdata->vif.chanctx_conf = &ctx->conf;
+}
+
+static void
+ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
+			       struct ieee80211_chanctx *ctx)
+{
+	sdata->vif.chanctx_conf = NULL;
+	list_del(&sdata->chanctx_listitem);
+}
+
+static void
+__ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_chanctx_conf *conf = sdata->vif.chanctx_conf;
+	struct ieee80211_chanctx *ctx =
+			container_of(conf, struct ieee80211_chanctx, conf);
+
+	if (!conf)
+		return;
+
+	ieee80211_unassign_vif_chanctx(sdata, ctx);
+	if (list_empty(&ctx->interfaces))
+		ieee80211_free_chanctx(ctx);
+}
+
+bool
+ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
+			  struct ieee80211_channel *channel,
+			  enum nl80211_channel_type channel_type,
+			  enum ieee80211_chanctx_mode mode)
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
+void
+ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
+{
+	mutex_lock(&sdata->local->chanctx_mtx);
+	__ieee80211_vif_release_channel(sdata);
+	mutex_unlock(&sdata->local->chanctx_mtx);
+}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e6cbf5b..eefb932 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -645,6 +645,15 @@ enum ieee80211_sdata_state_bits {
 	SDATA_STATE_OFFCHANNEL,
 };
 
+struct ieee80211_chanctx {
+	struct list_head list;
+
+	struct ieee80211_local *local;
+	struct list_head interfaces;
+
+	struct ieee80211_chanctx_conf conf;
+};
+
 struct ieee80211_sub_if_data {
 	struct list_head list;
 
@@ -693,6 +702,8 @@ struct ieee80211_sub_if_data {
 
 	bool arp_filter_state;
 
+	struct list_head chanctx_listitem;
+
 	/*
 	 * AP this belongs to: self in AP mode and
 	 * corresponding AP in VLAN mode, NULL for
@@ -969,6 +980,10 @@ struct ieee80211_local {
 	struct ieee80211_channel *tmp_channel;
 	enum nl80211_channel_type tmp_channel_type;
 
+	/* channel contexts */
+	struct list_head chanctx_list;
+	struct mutex chanctx_mtx;
+
 	/* SNMP counters */
 	/* dot11CountersTable */
 	u32 dot11TransmittedFragmentCount;
@@ -1488,6 +1503,14 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 enum nl80211_channel_type
 ieee80211_ht_oper_to_channel_type(struct ieee80211_ht_operation *ht_oper);
 
+bool
+ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
+			  struct ieee80211_channel *channel,
+			  enum nl80211_channel_type channel_type,
+			  enum ieee80211_chanctx_mode mode);
+void
+ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
+
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
 #else
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d81c178..735edd5 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -613,6 +613,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	spin_lock_init(&local->filter_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
+	INIT_LIST_HEAD(&local->chanctx_list);
+	mutex_init(&local->chanctx_mtx);
+
 	/*
 	 * The rx_skb_queue is only accessed from tasklets,
 	 * but other SKB queues are used from within IRQ
-- 
1.7.0.4

