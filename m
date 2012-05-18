Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:43986 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967007Ab2ERMDT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 08:03:19 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 1/6] mac80211: introduce channel contexts skeleton code
Date: Fri, 18 May 2012 14:03:04 +0200
Message-ID: <1337342589-10617-2-git-send-email-michal.kazior@tieto.com> (sfid-20120518_140338_105322_F391A7C0)
In-Reply-To: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
References: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel context are the foundation for
multi-channel operation.

Channel contexts are immutable and are re-created
(or re-used if other interfaces are bound to a
certain channel) on channel switching.

This is a initial implementation and more features
will come in separate patches for easier review.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/mac80211.h     |   21 +++++++++
 net/mac80211/chan.c        |  108 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |   11 +++++
 net/mac80211/main.c        |    3 +
 4 files changed, 143 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1937c7d..75a613f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -144,6 +144,22 @@ struct ieee80211_low_level_stats {
 };
 
 /**
+ * struct ieee80211_channel_context - channel context that vifs may be tuned to
+ *
+ * @channel: the channel to tune to
+ * @channel_type: the channel (HT) type
+ * @vif_list: vifs bound to channel context
+ */
+struct ieee80211_channel_context {
+	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
+
+	struct list_head vif_list;
+};
+
+#define IEEE80211_MAX_CHANNEL_CONTEXTS 8
+
+/**
  * enum ieee80211_bss_change - BSS change notification flags
  *
  * These flags are used with the bss_info_changed() callback
@@ -897,6 +913,8 @@ enum ieee80211_vif_flags {
  *	at runtime, mac80211 will never touch this field
  * @hw_queue: hardware queue for each AC
  * @cab_queue: content-after-beacon (DTIM beacon really) queue, AP mode only
+ * @channel_context: channel context vif is bound to, may be NULL
+ * @list: linked list for channel context's vif_list
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *).
  */
@@ -909,6 +927,9 @@ struct ieee80211_vif {
 	u8 cab_queue;
 	u8 hw_queue[IEEE80211_NUM_ACS];
 
+	struct ieee80211_channel_context *channel_context;
+	struct list_head list;
+
 	u32 driver_flags;
 
 	/* must be last */
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index c76cf72..e9b0f3e 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -135,3 +135,111 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 
 	return result;
 }
+
+static struct ieee80211_channel_context *
+ieee80211_find_channel_context(struct ieee80211_local *local,
+			       struct ieee80211_channel *channel,
+			       enum nl80211_channel_type channel_type)
+{
+	struct ieee80211_channel_context *ctx;
+	int i;
+
+	if (WARN_ON(!channel))
+		return NULL;
+
+	for (i = 0; i < IEEE80211_MAX_CHANNEL_CONTEXTS; i++) {
+		ctx = &local->channel_contexts[i];
+		if (ctx->channel != channel)
+			continue;
+		if (ctx->channel_type != channel_type)
+			continue;
+
+		return ctx;
+	}
+
+	return NULL;
+}
+
+static struct ieee80211_channel_context *
+ieee80211_new_channel_context(struct ieee80211_local *local,
+			      struct ieee80211_channel *channel,
+			      enum nl80211_channel_type channel_type)
+{
+	struct ieee80211_channel_context *ctx = NULL;
+	int i;
+
+	for (i = 0; i < IEEE80211_MAX_CHANNEL_CONTEXTS; i++)
+		if (!local->channel_contexts[i].channel) {
+			ctx = &local->channel_contexts[i];
+			break;
+		}
+
+	if (WARN_ON(!ctx))
+		return NULL;
+
+	ctx->channel = channel;
+	ctx->channel_type = channel_type;
+	INIT_LIST_HEAD(&ctx->vif_list);
+
+	return ctx;
+}
+
+static void
+ieee80211_free_channel_context(struct ieee80211_local *local,
+			       struct ieee80211_channel_context *ctx)
+{
+	if (WARN_ON(!list_empty(&ctx->vif_list)))
+		return;
+
+	ctx->channel = NULL;
+}
+
+static void
+ieee80211_assign_vif_channel_context(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_channel_context *ctx)
+{
+	list_add(&sdata->vif.list, &ctx->vif_list);
+	sdata->vif.channel_context = ctx;
+}
+
+static void
+ieee80211_unassign_vif_channel_context(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_channel_context *ctx)
+{
+	sdata->vif.channel_context = NULL;
+	list_del(&sdata->vif.list);
+}
+
+bool
+ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
+			  struct ieee80211_channel *channel,
+			  enum nl80211_channel_type channel_type)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_context *ctx;
+
+	ieee80211_vif_release_channel(sdata);
+
+	ctx = ieee80211_find_channel_context(local, channel, channel_type);
+	if (!ctx)
+		ctx = ieee80211_new_channel_context(local, channel, channel_type);
+	if (!ctx)
+		return false;
+
+	ieee80211_assign_vif_channel_context(sdata, ctx);
+	return true;
+}
+
+void
+ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_context *ctx = sdata->vif.channel_context;
+
+	if (!ctx)
+		return;
+
+	ieee80211_unassign_vif_channel_context(sdata, ctx);
+	if (list_empty(&ctx->vif_list))
+		ieee80211_free_channel_context(local, ctx);
+}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ae046b5..d8a266e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1000,6 +1000,10 @@ struct ieee80211_local {
 	struct ieee80211_channel *tmp_channel;
 	enum nl80211_channel_type tmp_channel_type;
 
+	/* channel contexts */
+	struct ieee80211_channel_context
+			channel_contexts[IEEE80211_MAX_CHANNEL_CONTEXTS];
+
 	/* SNMP counters */
 	/* dot11CountersTable */
 	u32 dot11TransmittedFragmentCount;
@@ -1528,6 +1532,13 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 enum nl80211_channel_type
 ieee80211_ht_oper_to_channel_type(struct ieee80211_ht_operation *ht_oper);
 
+bool
+ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
+			  struct ieee80211_channel *channel,
+			  enum nl80211_channel_type channel_type);
+void
+ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
+
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
 #else
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index f5548e9..7cbc005 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -772,6 +772,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		if (c->num_different_channels > 1)
 			return -EINVAL;
 
+		if (c->num_different_channels > IEEE80211_MAX_CHANNEL_CONTEXTS)
+			return -EINVAL;
+
 		for (j = 0; j < c->n_limits; j++)
 			if ((c->limits[j].types & BIT(NL80211_IFTYPE_ADHOC)) &&
 			    c->limits[j].max > 1)
-- 
1.7.0.4

