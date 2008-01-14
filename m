Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:3062 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbYANJ0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 04:26:07 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3548647wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2008 01:26:07 -0800 (PST)
Message-ID: <c85cb4470801140126g3e32cfebjacfe4c7d3ef22032@mail.gmail.com> (sfid-20080114_092611_573542_8D74AC45)
Date: Mon, 14 Jan 2008 11:26:07 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 03/10] mac80211: A-MPDU Tx adding basic functionality
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1200261102.5887.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
	 <11999857493027-git-send-email-ron.rindjunsky@intel.com>
	 <1200070308.3861.203.camel@johannes.berg>
	 <c85cb4470801130718x8069c4fi2eff95a21a11a2f3@mail.gmail.com>
	 <1200261102.5887.19.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > > +EXPORT_SYMBOL(ieee80211_start_tx_ba_session);
> > >
> > this is the trigger to aggregation, but a load aware entity should
> > call it. in my next series of patches i'll work on this issue, but
> > basically i would like to give the option to start/stop aggregations
> > to other modules (e.g. rate scaling module)
>
> Ah. Let only export it then though, please put the export into that
> patch series. Maybe a rate control algorithm should indicate this in
> some other way via the callbacks anyway?

ok, i'll check several ways for the A-MPDU trigger and edit the
patches accordingly

> > > > +     /* Tell the driver to stop its HW queue */
> > > > +     if (local->ops->ampdu_action)
> > > > +             ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_STOP,
> > > > +                                             ra, tid, NULL);
> > >
> > > Does it really stop the hw queue? Isn't that more like "stop
> > > aggregation"? Does the hardware actually have queues for each of these?
> > > Hm. I'm familiar enough with this I think.
> > >
> >
> > I'll remove this comment anyhow, as it is misleading, but the basic
> > idea is what i wrote in 0/10 - first we need to drain all A-MPDUs,
> > only then we can delBA, otherwise we are confusing the receiver.
>
> Ok, I'm trying to learn 11n here too, does the hardware need extra
> queues for the A-MPDU feature?

Yes, it should have queues for A-MPDU, as regular QoS queues should
not be eliminated during A-MPDU sesion. moreover, RA/TID combination
defines uniquely A-MPDU queue, so it is up to a specific HW to decide
how to maintain the queues.

> > > > +     /* case HW denied going back to legacy */
> > > > +     if (ret) {
> > > > +             printk(KERN_ERR "Driver could not stop aggregations\n");
> > > > +             *state = HT_AGG_STATE_OPERATIONAL;
> > > > +             ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
> > > > +             goto stop_BA_exit;
> > >
> > > Is there really a use case for a driver denying this? IOW, can you think
> > > of a good reason why a driver would deny it?
> >
> > can't think about one right now, but i am not familiar with other HWs.
> > maybe a self contained HW decision based on frames load can lead to
> > that. in any case i would like to give the driver this option.
>
> Ok. Let's put
>
> WARN_ON(ret != -EBUSY)
>
> into that if (ret) { block though to force the driver to give exactly
> that error code (and document that) so that callers of
> ieee80211_stop_tx_ba_session() can discover that the driver failed.
>

ok, i'll add this check

> > > +     hdr = (struct ieee80211_hdr *) skb_put(skb,
> > > +                                     sizeof(struct ieee80211_hdr));
> > > +     memcpy(&hdr->addr1, ra, ETH_ALEN);
> > > +     hdr->frame_control = tid;
> >
> > this is a use of an existing mechanism, I wouldn't like another queue
> > just for this purpose, though a misuse, i agree. i can either stay
> > with this code, use cb for this purpose, or create a new struct in
> > mac80211.h, somehting like ieee80211_ra_tid and pass it. what do you
> > think os the best?
>
> I think we should use something other than an skb queue here with some
> other struct, that other struct would be in skb->cb for the existing skb
> cases and would just sit in some new struct ieee80211_ra_tid too for
> this case. It's a bit of rework here but I think it'd help the code to
> be more readable. Not sure if we should also do it for the unreliable
> queue.

ok, i'll add this struct (ieee80211_ra_tid), and pass it in cb. this
struct can be useful in other cases too.

>
> > > > +     /* check if the TID waits for addBA response */
> > > > +     spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
> > > > +     if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
> > > > +             spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
> > > > +             *state = HT_AGG_STATE_IDLE;
> > > > +             printk(KERN_DEBUG "timer expired on tid %d but we are not "
> > > > +                             "expecting addBA response there", tid);
> > > > +             goto timer_expired_exit;
> > > > +     }
> > >
> > > Couldn't this also happen when the response was just received while the
> > > timer expires but the response grabs the ampdu_tx spinlock before the
> > > timer does? Seems that should be in a comment and not worry about a
> > > printk.
> >
> > the condition is on whether addBA request was sent or not for this
> > address and TID, not on the addBA request.
>
> Oh, hmm, ok. But that actually leads me to another problem,
> HT_ADDBA_REQUESTED_MSK is never cleared anywhere.
>

to go into A-MPDU active state we need 3 conditions:
- addBA request was sent (HT_ADDBA_REQUESTED_MSK)
- addBA response arrived (HT_ADDBA_RECEIVED_MSK)
- all legacy frames drained up to ssn (HT_ADDBA_DRV_READY_MSK)

their combination gives us HT_AGG_STATE_OPERATIONAL. so when we go to
HT_AGG_STATE_IDLE automatically we reset all the above.
