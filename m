Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:4130 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbYAMPSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 10:18:14 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1488846rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 07:18:14 -0800 (PST)
Message-ID: <c85cb4470801130718x8069c4fi2eff95a21a11a2f3@mail.gmail.com> (sfid-20080113_151824_186391_E949B260)
Date: Sun, 13 Jan 2008 17:18:14 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 03/10] mac80211: A-MPDU Tx adding basic functionality
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1200070308.3861.203.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
	 <11999857493027-git-send-email-ron.rindjunsky@intel.com>
	 <1200070308.3861.203.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +
> > +     /* we have tried too many times, reciever does not want A-MPDU */
>
> typo: "receiver"

thanks

>
> > +     if (sta->ampdu_mlme.tid_tx[tid].addba_req_num > HT_AGG_MAX_RETRIES) {
> > +             ret = -EBUSY;
> > +             goto start_ba_exit;
>
> Can this counter reset somehow? Or do we only implicitly reset it when
> the station disassociates and associates again?
>

agree. I'll handle this value.

> > +     /* FIXME: need a better way to ensure that TX flow won't interrupt us*/
> > +     /* until the end of the call to requeue function */
> > +     spin_lock_bh(&local->mdev->queue_lock);
>
> Hm. I think the queue lock here is pretty much the only way. On the
> other hand, maybe here's the point where we should talk about
> multi-queue ethernet devices?



> > +EXPORT_SYMBOL(ieee80211_start_tx_ba_session);
>
> Why is this exported? I thought this is the first step of enabling
> aggregation?

this is the trigger to aggregation, but a load aware entity should
call it. in my next series of patches i'll work on this issue, but
basically i would like to give the option to start/stop aggregations
to other modules (e.g. rate scaling module)

> > +     if (*state != HT_AGG_STATE_OPERATIONAL) {
> > +             printk(KERN_ERR "Call to %s, whith AGG non operational\n",
> > +                                                             __func__);
>
> I dislike the __func__ usage here, why not just say "tried to disable TX
> aggregation while not operational" or something? Typo: "with".
>

will change

> > +     /* Tell the driver to stop its HW queue */
> > +     if (local->ops->ampdu_action)
> > +             ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_STOP,
> > +                                             ra, tid, NULL);
>
> Does it really stop the hw queue? Isn't that more like "stop
> aggregation"? Does the hardware actually have queues for each of these?
> Hm. I'm familiar enough with this I think.
>

I'll remove this comment anyhow, as it is misleading, but the basic
idea is what i wrote in 0/10 - first we need to drain all A-MPDUs,
only then we can delBA, otherwise we are confusing the receiver.

> > +     /* case HW denied going back to legacy */
> > +     if (ret) {
> > +             printk(KERN_ERR "Driver could not stop aggregations\n");
> > +             *state = HT_AGG_STATE_OPERATIONAL;
> > +             ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
> > +             goto stop_BA_exit;
>
> Is there really a use case for a driver denying this? IOW, can you think
> of a good reason why a driver would deny it?

can't think about one right now, but i am not familiar with other HWs.
maybe a self contained HW decision based on frames load can lead to
that. in any case i would like to give the driver this option.

>
> > +EXPORT_SYMBOL(ieee80211_stop_tx_ba_session);
>
> Again, why export this?

please see above.

>
> > +     if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
> > +             printk(KERN_ERR "%s, state not HT_ADDBA_REQUESTED_MSK: %d\n",
> > +                     __func__, *state);
>
> Please just write the message w/o the function name.

will do

>
> > +     if (*state & HT_ADDBA_DRV_READY_MSK)
> > +             printk(KERN_ERR "driver already prepared for aggregation\n");
>
> That's a bit odd. Shouldn't it rather be a WARN_ON() because the driver
> did something weird?

that's a good option, i'll put it.

> > +             printk(KERN_ERR "%s. OPERATIONNAL\n", __func__);
>
> typo, weird message :)

changed it, thanks

>
> > +     /* avoid ordering issues: we are the only one that can modify
> > +      * the content of the qdiscs */
> > +     spin_lock_bh(&local->mdev->queue_lock);
> > +     /* remove the queue for this aggregation */
> > +     ieee80211_ht_agg_queue_remove(local, sta, tid, 1);
> > +     spin_unlock_bh(&local->mdev->queue_lock);
> > +
> > +     /* Not scheduling the device leads to a stall in the TX when qdisc */
> > +     /* contains more than ~220 packets... */
> > +     netif_schedule(local->mdev);
>
> This seems a bit weird, can you explain a bit more?

i'll change the comment here to a clearer one. since the qdisc has
just been requeued then heavy load (~220 frames queued) might lead us
to miss a softirq for this qdisc. we can't use ieee80211_wake_queue as
the qdisc is not necessarily stopped, so this is a solution for it.

>
> > +     hdr = (struct ieee80211_hdr *) skb_put(skb,
> > +                                     sizeof(struct ieee80211_hdr));
> > +     memcpy(&hdr->addr1, ra, ETH_ALEN);
> > +     hdr->frame_control = tid;
>
> Hrm. This is just strange and hard to understand imho. Can't we just use
> some other structure instead of and ieee80211_hdr and push that onto the
> queue? Then we shouldn't be using an skb queue any more I guess if we're
> going to use it like this. For the skbs we can use skb->cb for our own
> list structure, and here we just use another structure that embeds our
> list structure...
>

this is a use of an existing mechanism, I wouldn't like another queue
just for this purpose, though a misuse, i agree. i can either stay
with this code, use cb for this purpose, or create a new struct in
mac80211.h, somehting like ieee80211_ra_tid and pass it. what do you
think os the best?


> > +     /* not an elegant detour, but there is no choice as the timer passes
> > +      * only one argument, and verious sta_info are needed here, so init
>
> typo: various, but I think it should read something like "both the
> sta_info and the TID are needed here"?

thanks

>
> > +     /* check if the TID waits for addBA response */
> > +     spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
> > +     if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
> > +             spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
> > +             *state = HT_AGG_STATE_IDLE;
> > +             printk(KERN_DEBUG "timer expired on tid %d but we are not "
> > +                             "expecting addBA response there", tid);
> > +             goto timer_expired_exit;
> > +     }
>
> Couldn't this also happen when the response was just received while the
> timer expires but the response grabs the ampdu_tx spinlock before the
> timer does? Seems that should be in a comment and not worry about a
> printk.

the condition is on whether addBA request was sent or not for this
address and TID, not on the addBA request.

>
> johannes
>
>
