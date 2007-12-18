Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:27349 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbXLRNmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 08:42:53 -0500
Received: by fk-out-0910.google.com with SMTP id z23so2063917fkz.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Dec 2007 05:42:51 -0800 (PST)
Message-ID: <c85cb4470712180542k7b59cd4fs2dafef3da54ee666@mail.gmail.com> (sfid-20071218_134257_823639_0482422D)
Date: Tue, 18 Dec 2007 15:42:45 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/8] mac80211: A-MPDU Rx adding basic functionality
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1197914801.4885.74.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070781347-git-send-email-ron.rindjunsky@intel.com>
	 <1197914801.4885.74.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +/* BACK parties */
>
> Please write out "block-ack" or "BACK (block-ack)" :)

will do

>
> > +#define IEEE80211_MIN_AMPDU_BUF 0x8
> > +#define IEEE80211_MAX_AMPDU_BUF 0x40
>
> Any comments on what these represent? Should they be tunable?
>

no, they are not tuneable, but were determined in the 802.11n spec. I
will add comments here.

> > +     if (tid_agg_rx->state != HT_AGG_STATE_IDLE) {
> > +#ifdef CONFIG_MAC80211_HT_DEBUG
> > +             if (net_ratelimit())
> > +                     printk(KERN_DEBUG "unexpected Block Ack Req from "
> > +                             "%s on tid %u\n",
> > +                             print_mac(mac, mgmt->sa), tid);
> > +#endif /* CONFIG_MAC80211_HT_DEBUG */
> > +             goto end;
> > +     }
> > +
> > +     /* prepare reordering buffer */
> > +     tid_agg_rx->reorder_buf =
> > +             kmalloc(buf_size * sizeof(struct sk_buf *), GFP_ATOMIC);
> > +     if (!tid_agg_rx->reorder_buf) {
> > +             printk(KERN_ERR "can not allocate reordering buffer "
> > +                                             "to tid %d\n", tid);
> > +             tid_agg_rx->state = HT_AGG_STATE_IDLE;
>
> That's unnecessary, you can't get here w/ state != IDLE afaict.

right, thanks.

> > +#ifdef CONFIG_MAC80211_HT_DEBUG
> > +             if (net_ratelimit())
> > +                     printk(KERN_DEBUG "A-MPDU on tid %d result: %s", tid,
> > +                     (ret == -EOPNOTSUPP)? "Not Supported": "Driver Error");
>
> I'm not sure we need to ratelimit debug messages, and I think we should
> print out the error code. People who are writing a driver will need to
> decipher the number but it's an error they return so I think we should
> give them a chance to see which error path was hit.

agree, will change.

>
> > +void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
> > +                             u16 initiator, u16 reason_code)
> > +     if (!skb) {
> > +             printk(KERN_ERR "%s: failed to allocate buffer "
> > +                                     "for delba frame\n", dev->name);
>
> Do we send this as a reply to anything, ie. should it be rate-limited
> too?

no, this Tx is due to internal events only, so it will occur at most
once per session.

>
> > +     /* check if the TID is in opertional state */
>
> small typo

thanks, will change

>
> > +     /* stop HW Rx aggregation */
> > +     if (local->ops->ampdu_action) {
>
> Can we get into that path with ops->ampdu_action == NULL? I'd think not
> because state is required to be active... I'd rather stick in a
>        BUG_ON(!local->ops->ampdu_action)
> because it seems to me that'd be a mac80211 bug.

i agree, will do.

>
> > + * After receiving Block Ack Request (BAR) we activated a
> > + * timer after each frame arrives from the originator.
> > + * if this timer expires ieee80211_sta_stop_rx_BA_session will be executed.
> > + */
> > +void sta_rx_agg_session_timer_expired(unsigned long data)
> > +{
> > +     /* not an elegant detour, but there is no choice as the timer passes
> > +     * only one argument, and ieee80211_local is needed here */
> > +     int *ptid = (int *)data;
> > +     int *timer_to_id = ptid - *ptid;
> > +     struct sta_info *temp_sta = container_of(timer_to_id, struct sta_info,
> > +                                      timer_to_tid[0]);
>
> I think this needs more comments. I can, after a while, see what it
> does, but I'm not even sure it's correct. The whole timer_to_id thing is
> only for this code?

i will add comments.
currently we use it only here, but as Tx will suffer from the same
problem (MLME there requires to limit the time for addBA response per
TID) it will be soon used elsewhere.

> > +     u16 tid = (u16)*ptid;
> > +     sta = sta_info_get(local, temp_sta->addr);
>
> Missing newline.
>

certainly, thanks

> > +     if (!sta)
> > +             return;
>
> Why do you even do a sta_info_get() on the temp_sta's addr? Either you
> already have a good pointer or the whole thing will access invalid
> memory.
>

excellent and many thanks.
I forgot to add my del_timer_sync in sta_info_release to prevent this
problem, will add it now.
