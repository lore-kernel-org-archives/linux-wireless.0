Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37123 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbaCMNeD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2014 09:34:03 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [PATCH v9 4/4] mac80211: allow reservation of a running chanctx
Date: Thu, 13 Mar 2014 15:33:41 +0200
Message-Id: <1394717621-5608-5-git-send-email-luciano.coelho@intel.com> (sfid-20140313_143408_898689_2AD6323C)
In-Reply-To: <1394717621-5608-1-git-send-email-luciano.coelho@intel.com>
References: <1394717621-5608-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

In v4:

   * remove IEEE80211_CHANCTX_RESERVED and the reserved_mode element;
   * increase refcount also for "in-place" changes;
   * stop queues also before doing an "in-place" change;
   * refactor ieee80211_use_reserved_chanctx() a bit to fit "in-place"
     better;

In v5:

   * fix checkpatch warnings;

In v6:

   * return ret in ieee80211_chanctx_is_reserved();
   * check if sdata is running in ieee80211_chanctx_is_reserved();
   * keep check for IEEE80211_CHANCTX_EXCLUSIVE in
     ieee80211_find_channel();
   * use break instead of goto out in ieee80211_chanctx_is_reserved();

In v8:

   * don't remove recalc functions;

In v9:

   * one more fix for my major v7 rebase screw-up;
---
 include/net/mac80211.h |  7 +++++
 net/mac80211/chan.c    | 77 +++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 67 insertions(+), 17 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 86faa41..b35c608 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1553,6 +1553,12 @@ struct ieee80211_tx_control {
  *	for a single active channel while using channel contexts. When support
  *	is not enabled the default action is to disconnect when getting the
  *	CSA frame.
+ *
+ * @IEEE80211_HW_CHANGE_RUNNING_CHANCTX: The hardware can change a
+ *	channel context on-the-fly.  This is needed for channel switch
+ *	on single-channel hardware.  It can also be used as an
+ *	optimization in certain channel switch cases with
+ *	multi-channel.
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
index b1b92c1..5e5ffdc 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -162,6 +162,27 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
 	}
 }
 
+static bool ieee80211_chanctx_is_reserved(struct ieee80211_local *local,
+					  struct ieee80211_chanctx *ctx)
+{
+	struct ieee80211_sub_if_data *sdata;
+	bool ret = false;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+		if (sdata->reserved_chanctx == ctx) {
+			ret = true;
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+	return ret;
+}
+
 static struct ieee80211_chanctx *
 ieee80211_find_chanctx(struct ieee80211_local *local,
 		       const struct cfg80211_chan_def *chandef,
@@ -177,7 +198,12 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
 		const struct cfg80211_chan_def *compat;
 
-		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
+		/* We don't support chanctx reservation for multiple
+		 * vifs yet, so don't allow reserved chanctxs to be
+		 * reused.
+		 */
+		if ((ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE) ||
+		    ieee80211_chanctx_is_reserved(local, ctx))
 			continue;
 
 		compat = cfg80211_chandef_compatible(&ctx->conf.def, chandef);
@@ -695,11 +721,20 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 	/* try to find another context with the chandef we want */
 	new_ctx = ieee80211_find_chanctx(local, chandef, mode);
 	if (!new_ctx) {
-		/* create a new context */
-		new_ctx = ieee80211_new_chanctx(local, chandef, mode);
-		if (IS_ERR(new_ctx)) {
-			ret = PTR_ERR(new_ctx);
-			goto out;
+		if (curr_ctx->refcount == 1 &&
+		    (local->hw.flags & IEEE80211_HW_CHANGE_RUNNING_CHANCTX)) {
+			/* if we're the only users of the chanctx and
+			 * the driver supports changing a running
+			 * context, reserve our current context
+			 */
+			new_ctx = curr_ctx;
+		} else {
+			/* create a new context and reserve it */
+			new_ctx = ieee80211_new_chanctx(local, chandef, mode);
+			if (IS_ERR(new_ctx)) {
+				ret = PTR_ERR(new_ctx);
+				goto out;
+			}
 		}
 	}
 
@@ -747,21 +782,29 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
 
 	sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
 
-	/* unref our reservation before assigning */
+	/* unref our reservation */
 	ctx->refcount--;
 	sdata->reserved_chanctx = NULL;
 
-	ret = ieee80211_assign_vif_chanctx(sdata, ctx);
-	if (old_ctx->refcount == 0)
-		ieee80211_free_chanctx(local, old_ctx);
-	if (ret) {
-		/* if assign fails refcount stays the same */
-		if (ctx->refcount == 0)
-			ieee80211_free_chanctx(local, ctx);
-		goto out;
-	}
+	if (old_ctx == ctx) {
+		/* This is our own context, just change it */
+		ret = __ieee80211_vif_change_channel(sdata, old_ctx,
+						     &tmp_changed);
+		if (ret)
+			goto out;
+	} else {
+		ret = ieee80211_assign_vif_chanctx(sdata, ctx);
+		if (old_ctx->refcount == 0)
+			ieee80211_free_chanctx(local, old_ctx);
+		if (ret) {
+			/* if assign fails refcount stays the same */
+			if (ctx->refcount == 0)
+				ieee80211_free_chanctx(local, ctx);
+			goto out;
+		}
 
-	__ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
+		__ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
+	}
 
 	*changed = tmp_changed;
 
-- 
1.9.0

