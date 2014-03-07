Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:44441 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaCGTbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 14:31:13 -0500
Received: by mail-ee0-f42.google.com with SMTP id d17so1915239eek.15
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 11:31:12 -0800 (PST)
Message-ID: <1394174602.4192.7.camel@dubbel> (sfid-20140307_203118_435585_4CF69C0E)
Subject: Re: [PATCH v5 3/3] mac80211: allow reservation of a running chanctx
From: Luca Coelho <lrothc@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
In-Reply-To: <CA+BoTQnXAjPRNLvEs3XrtGOBcayyOKHm74WSYMJh-MDuUxJKsA@mail.gmail.com>
References: <1394017904-4012-1-git-send-email-luca@coelho.fi>
	 <1394017904-4012-4-git-send-email-luca@coelho.fi>
	 <CA+BoTQnXAjPRNLvEs3XrtGOBcayyOKHm74WSYMJh-MDuUxJKsA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Mar 2014 08:43:22 +0200
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-05 at 12:32 +0100, Michal Kazior wrote:
> On 5 March 2014 12:11, Luca Coelho <luca@coelho.fi> wrote:
> > From: Luciano Coelho <luciano.coelho@intel.com>
> >
> > With single-channel drivers, we need to be able to change a running
> > chanctx if we want to use chanctx reservation.  Not all drivers may be
> > able to do this, so add a flag that indicates support for it.
> >
> > Changing a running chanctx can also be used as an optimization in
> > multi-channel drivers when the context needs to be reserved for future
> > usage.
> >
> > Introduce IEEE80211_CHANCTX_RESERVED chanctx mode to mark a channel as
> > reserved so nobody else can use it (since we know it's going to
> > change).  In the future, we may allow several vifs to use the same
> > reservation as long as they plan to use the chanctx on the same
> > future channel.
> >
> > Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> > ---
> > In v3:
> >
> >    * reworded the TODO, slightly;
> >
> > In v4:
> >
> >    * remove IEEE80211_CHANCTX_RESERVED and the reserved_mode element;
> >    * increase refcount also for "in-place" changes;
> >    * stop queues also before doing an "in-place" change;
> >    * refactor ieee80211_use_reserved_chanctx() a bit to fit "in-place"
> >      better;
> >
> > In v5:
> >
> >    * fix checkpatch warnings;
> > ---
> >  include/net/mac80211.h |  7 ++++
> >  net/mac80211/chan.c    | 97 +++++++++++++++++++++++++++++++++++---------------
> >  2 files changed, 75 insertions(+), 29 deletions(-)
> >
> > diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> > index 86faa41..b35c608 100644
> > --- a/include/net/mac80211.h
> > +++ b/include/net/mac80211.h
> > @@ -1553,6 +1553,12 @@ struct ieee80211_tx_control {
> >   *     for a single active channel while using channel contexts. When support
> >   *     is not enabled the default action is to disconnect when getting the
> >   *     CSA frame.
> > + *
> > + * @IEEE80211_HW_CHANGE_RUNNING_CHANCTX: The hardware can change a
> > + *     channel context on-the-fly.  This is needed for channel switch
> > + *     on single-channel hardware.  It can also be used as an
> > + *     optimization in certain channel switch cases with
> > + *     multi-channel.
> >   */
> >  enum ieee80211_hw_flags {
> >         IEEE80211_HW_HAS_RATE_CONTROL                   = 1<<0,
> > @@ -1584,6 +1590,7 @@ enum ieee80211_hw_flags {
> >         IEEE80211_HW_TIMING_BEACON_ONLY                 = 1<<26,
> >         IEEE80211_HW_SUPPORTS_HT_CCK_RATES              = 1<<27,
> >         IEEE80211_HW_CHANCTX_STA_CSA                    = 1<<28,
> > +       IEEE80211_HW_CHANGE_RUNNING_CHANCTX             = 1<<29,
> >  };
> >
> >  /**
> > diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
> > index 9dfdba5..d634f41 100644
> > --- a/net/mac80211/chan.c
> > +++ b/net/mac80211/chan.c
> > @@ -162,6 +162,26 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
> >         }
> >  }
> >
> > +static bool ieee80211_chanctx_is_reserved(struct ieee80211_local *local,
> > +                                    struct ieee80211_chanctx *ctx)
> > +{
> > +       struct ieee80211_sub_if_data *sdata;
> > +       bool ret = false;
> > +
> > +       lockdep_assert_held(&local->chanctx_mtx);
> > +       rcu_read_lock();
> > +       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > +               if (sdata->reserved_chanctx == ctx) {
> > +                       ret = true;
> > +                       goto out;
> > +               }
> > +       }
> > +
> > +out:
> > +       rcu_read_unlock();
> > +       return false;
> 
> `return ret` ;-)

Gack! I'll fix.


> It's probably a good idea to check ieee80211_sdata_running() before
> even considering reserved_chanctx?

Yes, good point.  reserved->chanctx should not be set if the sdata is
not running, but for consistency, if nothing else, I'll add the check
here.


> 
> > +}
> > +
> >  static struct ieee80211_chanctx *
> >  ieee80211_find_chanctx(struct ieee80211_local *local,
> >                        const struct cfg80211_chan_def *chandef,
> > @@ -177,7 +197,11 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
> >         list_for_each_entry(ctx, &local->chanctx_list, list) {
> >                 const struct cfg80211_chan_def *compat;
> >
> > -               if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
> > +               /* We don't support chanctx reservation for multiple
> > +                * vifs yet, so don't allow reserved chanctxs to be
> > +                * reused.
> > +                */
> > +               if (ieee80211_chanctx_is_reserved(local, ctx))
> >                         continue;
> 
> Are you really sure you want to drop the ctx->mode == EXCLUSIVE check here?

Nope, I don't.  I should teach myself to be more careful when I'm trying
to multitask. :\


> 
> > -       /* reserve the new or existing context */
> >         sdata->reserved_chanctx = new_ctx;
> >         new_ctx->refcount++;
> > -
> >         sdata->reserved_chandef = *chandef;
> 
> Shouldn't this be in the [2/3]?

Yeah.


> 
> >  out:
> >         mutex_unlock(&local->chanctx_mtx);
> > @@ -703,37 +734,45 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
> >         ieee80211_stop_queues_by_reason(&local->hw,
> >                                         IEEE80211_MAX_QUEUE_MAP,
> >                                         IEEE80211_QUEUE_STOP_REASON_CHANCTX);
> > +       /* unref our reservation */
> > +       ctx->refcount--;
> > +       sdata->reserved_chanctx = NULL;
> >
> > -       ieee80211_unassign_vif_chanctx(sdata, old_ctx);
> > -       if (old_ctx->refcount == 0)
> > -               ieee80211_free_chanctx(local, old_ctx);
> > +       if (old_ctx == ctx) {
> > +               /* This is our own context, just change it */
> > +               ret = __ieee80211_vif_change_channel(sdata, old_ctx,
> > +                                                    &local_changed);
> > +               if (ret)
> > +                       goto out;
> > +       } else {
> > +               ieee80211_unassign_vif_chanctx(sdata, old_ctx);
> > +               if (old_ctx->refcount == 0)
> > +                       ieee80211_free_chanctx(local, old_ctx);
> >
> > -       if (sdata->vif.bss_conf.chandef.width != sdata->reserved_chandef.width)
> > -               local_changed |= BSS_CHANGED_BANDWIDTH;
> > +               if (sdata->vif.bss_conf.chandef.width !=
> > +                   sdata->reserved_chandef.width)
> > +                       local_changed |= BSS_CHANGED_BANDWIDTH;
> >
> > -       sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
> > +               sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
> >
> > -       /* unref our reservation before assigning */
> > -       ctx->refcount--;
> > -       sdata->reserved_chanctx = NULL;
> > -       ret = ieee80211_assign_vif_chanctx(sdata, ctx);
> > -       if (ret) {
> > -               /* if assign fails refcount stays the same */
> > -               if (ctx->refcount == 0)
> > -                       ieee80211_free_chanctx(local, ctx);
> > -               goto out_wake;
> > +               ret = ieee80211_assign_vif_chanctx(sdata, ctx);
> > +               if (ret) {
> > +                       /* if assign fails refcount stays the same */
> > +                       if (ctx->refcount == 0)
> > +                               ieee80211_free_chanctx(local, ctx);
> > +                       goto out;
> > +               }
> > +
> > +               ieee80211_recalc_chanctx_chantype(local, ctx);
> > +               ieee80211_recalc_smps_chanctx(local, ctx);
> > +               ieee80211_recalc_radar_chanctx(local, ctx);
> >         }
> 
> Not really sure if you need to `else` and re-indent the whole thing
> because you already do a `goto` in the `if`..

No, I don't do a goto in the 'if', unless
__ieee80211_vif_change_channel() fails.  I just reckoned this would be a
bit cleaner like this.


> >         *changed = local_changed;
> > -
> > -       ieee80211_recalc_chanctx_chantype(local, ctx);
> > -       ieee80211_recalc_smps_chanctx(local, ctx);
> > -       ieee80211_recalc_radar_chanctx(local, ctx);
> > -out_wake:
> > +out:
> >         ieee80211_wake_queues_by_reason(&sdata->local->hw,
> >                                         IEEE80211_MAX_QUEUE_MAP,
> >                                         IEEE80211_QUEUE_STOP_REASON_CHANCTX);
> > -out:
> >         mutex_unlock(&local->chanctx_mtx);
> >         return ret;
> >  }
> 
> Are you sure you want to remove the `out_wake` from here? Why not in the [2/3]?

Well, this patch is somewhat refactoring this function, so I think it's
okay to have this here as well.

--
Luca.

