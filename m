Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:29417 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbXLRNoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 08:44:54 -0500
Received: by fk-out-0910.google.com with SMTP id z23so2064706fkz.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Dec 2007 05:44:51 -0800 (PST)
Message-ID: <c85cb4470712180544m682a93b1v9a7a34d2148a770b@mail.gmail.com> (sfid-20071218_134504_600352_E2D87D1A)
Date: Tue, 18 Dec 2007 15:44:50 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1197915515.4885.86.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782762-git-send-email-ron.rindjunsky@intel.com>
	 <1197915515.4885.86.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> >  struct ieee80211_rx_status {
> > @@ -388,6 +389,7 @@ struct ieee80211_rx_status {
> >       int noise;
> >       int antenna;
> >       int rate;
> > +     int ordered;
>
> That's not an int, and it's only used internally. Can we somehow avoid
> putting it into the rx status, have it in the txrx status structure
> instead and give it the proper type (txrx result)? More of a question
> than a suggestion, I'd like to have that but I'm not sure it's doable.

well, i was asking myself this same question, and went to
ieee80211_rx_status as ieee80211_txrx_data derives its data from
ieee80211_rx_status in __ieee80211_rx, so i have no other way to pass
info per sk_buff.
type int was chosen as it is not a bool type (can be
drop/continue/queue) so it can't be fit to flags. i can put it in u8,
but i don't think it will change much, especially if alignment is
involved.

>
> > @@ -1252,6 +1254,20 @@ void ieee80211_sta_stop_rx_BA_session(struct net_device *dev, u8 *ra, u16 tid,
> >               ieee80211_send_delba(dev, ra, tid, 0, reason);
> >
> >       /* free the reordering buffer */
> > +     for (i = 0; i < sta->ampdu_mlme.tid_rx[tid].buf_size; i++) {
> > +             if (sta->ampdu_mlme.tid_rx[tid].reorder_buf[i]) {
> > +                     /* release the reordered frames to stack,
> > +                      * but drop them there */
> > +                     memcpy(&status, sta->ampdu_mlme.tid_rx[tid].
> > +                             reorder_buf[i]->cb, sizeof(status));
> > +                     status.ordered = TXRX_DROP;
> > +                     __ieee80211_rx(hw, sta->ampdu_mlme.
> > +                                    tid_rx[tid].reorder_buf[i],
> > +                                    &status);
>
> This is strange. Why are they even passed to __ieee80211_rx?

of course i can get rid from there here, but thought it will be more
systematic and clearer to pass them back to __ieee80211_rx. if you
have any objection to this (efficiency considerations or like) i will
reconsider it.

>
> > +#define SEQ_MODULO 0x1000
> > +#define SEQ_MASK   0xfff
> > +
> > +static inline int seq_less(u16 sq1, u16 sq2)
> > +{
> > +     return (((sq1 - sq2) & SEQ_MASK) > (SEQ_MODULO >> 1));
>
> Is it really correct to subtract before masking?

as these values are already "masked" as sequence numbers the answer is yes.
if this is not the case, and somehow we deal internally with sequence
numbers > 4095 this function should be the least to worry about  ;-)

>
> > +static inline u16 seq_sub(u16 sq1, u16 sq2)
> > +{
> > +     return ((sq1 - sq2) & SEQ_MASK);
> > +}
>
> Same here.

this is modulo arithmetic. looks fine to me.

> And maybe seq_less should use seq_sub and the SEQ_MODULO
> define should be (SEQ_MASK+1)?
>

the fact these 2 #defines are 1 number apart shouldn't confuse. it is
just a more
convenient way for the 802.11 reader (used to sequence number limit)
to look at it. i could have, if i would like, decide that pass
criteria for seq_less is not 2048, but only the closest 200 frames, in
that case i would have give it the value of 200.

> I think I need to take a second look at this patch to even understand
> the problem it solves.
>

no one guarantees you get the frames in the right order... please see
the patch description for such a case.

> johannes
>
>
