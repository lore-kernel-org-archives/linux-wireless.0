Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47632 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2LSKwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 05:52:10 -0500
Message-ID: <1355914350.9954.3.camel@jlt4.sipsolutions.net> (sfid-20121219_115214_706287_1724491B)
Subject: Re: [PATCH 3/3] mac80211: fix channel context iteration
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 19 Dec 2012 11:52:30 +0100
In-Reply-To: <CAB3XZEf5eSQVPPdTz0ZA_X2S51bkHCtkoerJCERFdXUEcwVyDg@mail.gmail.com> (sfid-20121216_100205_891284_5CEFC2BC)
References: <1355486368-14563-1-git-send-email-johannes@sipsolutions.net>
	 <1355486368-14563-4-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEf5eSQVPPdTz0ZA_X2S51bkHCtkoerJCERFdXUEcwVyDg@mail.gmail.com>
	 (sfid-20121216_100205_891284_5CEFC2BC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-12-16 at 11:02 +0200, Eliad Peller wrote:
> On Fri, Dec 14, 2012 at 1:59 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > During suspend/resume channel contexts might be
> > iterated even if they haven't been re-added to
> > the driver, keep track of this and skip them in
> > iteration. Also use the new status for sanity
> > checks.
> >
> > Change-Id: Ibac29191dcc24578d56565c36a543d7a9733be10
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  net/mac80211/chan.c        |  3 ++-
> >  net/mac80211/driver-ops.h  | 15 ++++++++++++---
> >  net/mac80211/ieee80211_i.h |  1 +
> >  3 files changed, 15 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
> > index 80e5552..1bfe0a8 100644
> > --- a/net/mac80211/chan.c
> > +++ b/net/mac80211/chan.c
> > @@ -381,7 +381,8 @@ void ieee80211_iter_chan_contexts_atomic(
> >
> >         rcu_read_lock();
> >         list_for_each_entry_rcu(ctx, &local->chanctx_list, list)
> > -               iter(hw, &ctx->conf, iter_data);
> > +               if (ctx->driver_present)
> > +                       iter(hw, &ctx->conf, iter_data);
> >         rcu_read_unlock();
> >  }
> this will behave differently on hw restart (as ctx->driver_present
> will remain true).
> at least worth documenting :)

Yes, good point.

johannes


From: Johannes Berg <johannes.berg@intel.com>
Date: Thu, 13 Dec 2012 17:42:30 +0100
Subject: [PATCH] mac80211: fix channel context iteration

During suspend/resume channel contexts might be
iterated even if they haven't been re-added to
the driver, keep track of this and skip them in
iteration. Also use the new status for sanity
checks.

Also clarify the fact that during HW restart all
contexts are iterated over (thanks Eliad.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |  5 +++++
 net/mac80211/chan.c        |  3 ++-
 net/mac80211/driver-ops.h  | 15 ++++++++++++---
 net/mac80211/ieee80211_i.h |  1 +
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ee50c5e..0978b0f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3754,6 +3754,11 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
  * The iterator will not find a context that's being added (during
  * the driver callback to add it) but will find it while it's being
  * removed.
+ *
+ * Note that during hardware restart, all contexts that existed
+ * before the restart are considered already present so will be
+ * found while iterating, whether they've been re-added already
+ * or not.
  */
 void ieee80211_iter_chan_contexts_atomic(
 	struct ieee80211_hw *hw,
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 80e5552..1bfe0a8 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -381,7 +381,8 @@ void ieee80211_iter_chan_contexts_atomic(
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(ctx, &local->chanctx_list, list)
-		iter(hw, &ctx->conf, iter_data);
+		if (ctx->driver_present)
+			iter(hw, &ctx->conf, iter_data);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(ieee80211_iter_chan_contexts_atomic);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index c6560cc..70dcc42 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -913,6 +913,8 @@ static inline int drv_add_chanctx(struct ieee80211_local *local,
 	if (local->ops->add_chanctx)
 		ret = local->ops->add_chanctx(&local->hw, &ctx->conf);
 	trace_drv_return_int(local, ret);
+	if (!ret)
+		ctx->driver_present = true;
 
 	return ret;
 }
@@ -924,6 +926,7 @@ static inline void drv_remove_chanctx(struct ieee80211_local *local,
 	if (local->ops->remove_chanctx)
 		local->ops->remove_chanctx(&local->hw, &ctx->conf);
 	trace_drv_return_void(local);
+	ctx->driver_present = false;
 }
 
 static inline void drv_change_chanctx(struct ieee80211_local *local,
@@ -931,8 +934,10 @@ static inline void drv_change_chanctx(struct ieee80211_local *local,
 				      u32 changed)
 {
 	trace_drv_change_chanctx(local, ctx, changed);
-	if (local->ops->change_chanctx)
+	if (local->ops->change_chanctx) {
+		WARN_ON_ONCE(!ctx->driver_present);
 		local->ops->change_chanctx(&local->hw, &ctx->conf, changed);
+	}
 	trace_drv_return_void(local);
 }
 
@@ -945,10 +950,12 @@ static inline int drv_assign_vif_chanctx(struct ieee80211_local *local,
 	check_sdata_in_driver(sdata);
 
 	trace_drv_assign_vif_chanctx(local, sdata, ctx);
-	if (local->ops->assign_vif_chanctx)
+	if (local->ops->assign_vif_chanctx) {
+		WARN_ON_ONCE(!ctx->driver_present);
 		ret = local->ops->assign_vif_chanctx(&local->hw,
 						     &sdata->vif,
 						     &ctx->conf);
+	}
 	trace_drv_return_int(local, ret);
 
 	return ret;
@@ -961,10 +968,12 @@ static inline void drv_unassign_vif_chanctx(struct ieee80211_local *local,
 	check_sdata_in_driver(sdata);
 
 	trace_drv_unassign_vif_chanctx(local, sdata, ctx);
-	if (local->ops->unassign_vif_chanctx)
+	if (local->ops->unassign_vif_chanctx) {
+		WARN_ON_ONCE(!ctx->driver_present);
 		local->ops->unassign_vif_chanctx(&local->hw,
 						 &sdata->vif,
 						 &ctx->conf);
+	}
 	trace_drv_return_void(local);
 }
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0360b74..2bb0c98 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -687,6 +687,7 @@ struct ieee80211_chanctx {
 
 	enum ieee80211_chanctx_mode mode;
 	int refcount;
+	bool driver_present;
 
 	struct ieee80211_chanctx_conf conf;
 };
-- 
1.8.0



