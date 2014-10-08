Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:34530 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750858AbaJHGlA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 02:41:00 -0400
Message-ID: <1412750448.3599.3.camel@coelho.fi> (sfid-20141008_084118_537791_79113C5F)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 08 Oct 2014 09:40:48 +0300
In-Reply-To: <CA+BoTQmG+GJieeQevaHxoQ8xdu1_OE=SWuC5QsS=JFzP2FQtRA@mail.gmail.com>
References: <1411760105-18614-1-git-send-email-luca@coelho.fi>
	 <1411760105-18614-7-git-send-email-luca@coelho.fi>
	 <CA+BoTQmG+GJieeQevaHxoQ8xdu1_OE=SWuC5QsS=JFzP2FQtRA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 6/7] mac80211: wait for the first beacon on the new
 channel after CSA
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for the delay in replying.


On Mon, 2014-09-29 at 11:02 +0200, Michal Kazior wrote:
> On 26 September 2014 21:35, Luca Coelho <luca@coelho.fi> wrote:
> > From: Luciano Coelho <luciano.coelho@intel.com>
> >
> > Instead of immediately reopening the queues (in case of block_tx),
> > calling the post_channel_switch operation and sending the
> > notification, wait for the first beacon on the new channel.  This
> > makes sure that we don't lose packets if the AP/GO is not on the new
> > channel yet.
> >
> > Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> [...]
> 
> Just a few nitpicks from me:
> 
> > +static void ieee80211_chswitch_post_beacon(struct ieee80211_sub_if_data *sdata)
> > +{
> > +       struct ieee80211_local *local = sdata->local;
> > +       struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> > +       int ret;
> > +
> > +       sdata_assert_lock(sdata);
> >
> 
> I was thinking about WARN_ON(!sdata->vif.csa_active) here. csa_active
> should be set in all cases if csa_waiting_bcn is set, no?

Good idea, csa_active must still be true otherwise we may get into
trouble.  I'll add the WARN_ON.


> 
> > -       /* XXX: wait for a beacon first? */
> >         if (sdata->csa_block_tx) {
> >                 ieee80211_wake_vif_queues(local, sdata,
> >                                           IEEE80211_QUEUE_STOP_REASON_CSA);
> >                 sdata->csa_block_tx = false;
> >         }
> >
> > +       sdata->vif.csa_active = false;
> > +       ifmgd->csa_waiting_bcn = false;
> > +
> >         ret = drv_post_channel_switch(sdata);
> >         if (ret) {
> >                 sdata_info(sdata,
> >                            "driver post channel switch failed, disconnecting\n");
> >                 ieee80211_queue_work(&local->hw,
> >                                      &ifmgd->csa_connection_drop_work);
> > -               goto out;
> > +               return;
> >         }
> >       <---- here
> > -       ieee80211_sta_reset_beacon_monitor(sdata);
> > -       ieee80211_sta_reset_conn_monitor(sdata);
> > -
> > -out:
> > -       mutex_unlock(&local->chanctx_mtx);
> > -       mutex_unlock(&local->mtx);
> > -       sdata_unlock(sdata);
> >  }
> 
> Is that an empty line I before final `}`?

Yep, good catch, I'll fix it.

--
Luca.

