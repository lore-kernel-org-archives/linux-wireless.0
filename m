Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:51010 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaB1MX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 07:23:26 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [PATCH v3 3/3] mac80211: allow reservation of a running chanctx
Date: Fri, 28 Feb 2014 14:23:20 +0200
Message-Id: <1393590200-25309-4-git-send-email-luca@coelho.fi> (sfid-20140228_132334_753669_C7AB0191)
In-Reply-To: <1393590200-25309-1-git-send-email-luca@coelho.fi>
References: <1393590200-25309-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

With single-channel drivers, we need to be able to change a running
chanctx if we want to use chanctx reservation.  Not all drivers may be
able to do this, so add a flag that indicates support for it.

Changing a running chanctx can also be used as an optimization in
multi-channel drivers when the context needs to be reserved for future
usage.

Introduce IEEE80211_CHANCTX_RESERVED chanctx mode to mark a channel as
reserved so nobody else can use it (since we know it's going to
change).  In the future, we may allow several vifs to use the same
reservation as long as they plan to use the chanctx on the same
future channel.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
In v3:

   * reworded the TODO, slightly;
---
 include/net/mac80211.h     |  7 ++++++
 net/mac80211/chan.c        | 61 ++++++++++++++++++++++++++++++++++++++++------
 net/mac80211/ieee80211_i.h |  7 +++++-
 3 files changed, 67 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 86faa41..54c9ce7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1553,6 +1553,12 @@ struct ieee80211_tx_control {
  *	for a single active channel while using channel contexts. When support
  *	is not enabled the default action is to disconnect when getting the
  *	CSA frame.
+ *
+ * @IEEE80211_HW_CHANGE_RUNNING_CHANCTX: The hardware can change a
+ * 	channel context on-the-fly.  This is needed for channel switch
+ * 	on single-channel hardware.  It can also be used as an
+ * 	optimization in certain channel switch cases with
+ * 	multi-channel.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1584,6 +1590,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TIMING_BEACON_ONLY			= 1<<26,
 	IEEE80211_HW_SUPPORTS_HT_CCK_RATES		= 1<<27,
 	IEEE80211_HW_CHANCTX_STA_CSA			= 1<<28,
+	IEEE80211_HW_CHANGE_RUNNING_CHANCTX		= 1<<29,
 };
 
 /**
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 9897c2e..1aec5ac 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -177,6 +177,13 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
 		const struct cfg80211_chan_def *compat;
 
+		/* We don't support chanctx reservation for multiple
+		 * vifs yet, so don't allow reserved chanctxs to be
+		 * reused.
+		 */
+		if (ctx->mode == IEEE80211_CHANCTX_RESERVED)
+			continue;
+
 		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
 			continue;
 
@@ -621,7 +628,9 @@ int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
 	if (WARN_ON(!sdata->reserved_chanctx))
 		return -EINVAL;
 
-	if (--sdata->reserved_chanctx->refcount == 0)
+	if (sdata->reserved_chanctx->mode == IEEE80211_CHANCTX_RESERVED)
+		sdata->reserved_chanctx->mode = sdata->reserved_mode;
+	else if (--sdata->reserved_chanctx->refcount == 0)
 		ieee80211_free_chanctx(sdata->local, sdata->reserved_chanctx);
 
 	sdata->reserved_chanctx = NULL;
@@ -651,19 +660,42 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 	/* try to find another context with the chandef we want */
 	new_ctx = ieee80211_find_chanctx(local, chandef,
 					 IEEE80211_CHANCTX_SHARED);
-	if (!new_ctx) {
-		/* create a new context */
+	if (new_ctx) {
+		/* reserve the existing compatible context */
+		sdata->reserved_chanctx = new_ctx;
+		new_ctx->refcount++;
+	} else if (curr_ctx->refcount == 1 &&
+		   (local->hw.flags & IEEE80211_HW_CHANGE_RUNNING_CHANCTX)) {
+		/* TODO: when implementing support for multiple
+		 * interfaces switching at the same time, we may want
+		 * other vifs to reserve it as well, as long as
+		 * they're planning to switch to the same channel.  In
+		 * that case, we probably have to save the
+		 * reserved_chandef and the reserved_mode elements in
+		 * the context as well.
+		 */
+		sdata->reserved_mode = curr_ctx->mode;
+
+		/* We're the only user of the current context, mark it
+		 * as reserved, so nobody tries to use it until we
+		 * finish the channel switch.  This is an optimization
+		 * to prevent waste of contexts when the number is
+		 * limited.
+		 */
+		curr_ctx->mode = IEEE80211_CHANCTX_RESERVED;
+		sdata->reserved_chanctx = curr_ctx;
+	} else {
+		/* create a new context and reserve it */
 		new_ctx = ieee80211_new_chanctx(local, chandef,
 						IEEE80211_CHANCTX_SHARED);
 		if (IS_ERR(new_ctx)) {
 			ret = PTR_ERR(new_ctx);
 			goto out;
 		}
-	}
+		sdata->reserved_chanctx = new_ctx;
 
-	/* reserve the new or existing context */
-	sdata->reserved_chanctx = new_ctx;
-	new_ctx->refcount++;
+		new_ctx->refcount++;
+	}
 
 	sdata->reserved_chandef = *chandef;
 out:
@@ -701,6 +733,21 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
 
 	old_ctx = container_of(conf, struct ieee80211_chanctx, conf);
 
+	if (old_ctx == ctx) {
+		WARN_ON(!ctx->mode != IEEE80211_CHANCTX_RESERVED);
+
+		/* This is our own context, just change it */
+		ret = __ieee80211_vif_change_channel(sdata, old_ctx,
+						     &local_changed);
+		if (ret)
+			goto out;
+
+		ctx->mode = sdata->reserved_mode;
+
+		*changed = local_changed;
+		goto out;
+	}
+
 	ieee80211_stop_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CHANCTX);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 58b6477..56f1981 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -681,10 +681,14 @@ enum ieee80211_sdata_state_bits {
  * @IEEE80211_CHANCTX_EXCLUSIVE: channel context can be used
  *	only by a single interface. This can be used for example for
  *	non-fixed channel IBSS.
+ * @IEEE80211_CHANCTX_RESERVED: the channel context is reserved for
+ * 	future change and cannot be used by other interfaces until the
+ * 	reservation is taken into use.
  */
 enum ieee80211_chanctx_mode {
 	IEEE80211_CHANCTX_SHARED,
-	IEEE80211_CHANCTX_EXCLUSIVE
+	IEEE80211_CHANCTX_EXCLUSIVE,
+	IEEE80211_CHANCTX_RESERVED
 };
 
 struct ieee80211_chanctx {
@@ -759,6 +763,7 @@ struct ieee80211_sub_if_data {
 	/* context reservation -- protected with chanctx_mtx */
 	struct ieee80211_chanctx *reserved_chanctx;
 	struct cfg80211_chan_def reserved_chandef;
+	enum ieee80211_chanctx_mode reserved_mode;
 
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
-- 
1.8.5.3

