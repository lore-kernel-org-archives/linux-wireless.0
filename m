Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:39242 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbeIKOSm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 10:18:42 -0400
Message-ID: <1536657605.3224.122.camel@sipsolutions.net> (sfid-20180911_112019_889732_0BB2413D)
Subject: Re: [PATCH RFC v3 1/4] mac80211: Add TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Tue, 11 Sep 2018 11:20:05 +0200
In-Reply-To: <87muspjt38.fsf@toke.dk>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
         <153635897010.14170.2992498632345986102.stgit@alrua-x1>
         <1536565717.3224.12.camel@sipsolutions.net> <87musplivy.fsf@toke.dk>
         <1536577419.3224.50.camel@sipsolutions.net> <87zhwpjzme.fsf@toke.dk>
         <1536583587.3224.71.camel@sipsolutions.net> <87wortjy8n.fsf@toke.dk>
         <1536585051.3224.72.camel@sipsolutions.net> <87r2i1jxse.fsf@toke.dk>
         <1536591110.3224.76.camel@sipsolutions.net> <87muspjt38.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-09-10 at 17:00 +0200, Toke Høiland-Jørgensen wrote:

> > Do we even need end_schedule()? It's hard to pass multiple things to a
> > single call (do you build a list?), so having
> > 
> > 	start_schedule(), get_txq(), return_txq()
> > 
> > would be sufficient?
> 
> Well, start_schedule() / end_schedule() would be needed if we are going
> to add locking in mac80211?

[...]

> If we decide mac80211 needs to do locking to prevent two threads from
> scheduling the same ac, that would also be needed for the hw-managed
> case?

Yes, good point.

> > It seems like not? Basically it seems to me that in the hw-managed
> > case all you need is may_tx()? And in fact, once you opt in you don't
> > even really need *that* since mac80211 can just return NULL from
> > get_skb()?
> 
> Yeah, we could just throttle in get_skb(); the separate call was to
> avoid the overhead of the check for every packet. Typically, you'll pick
> a TXQ, then dequeue multiple packets from it in succession; with a
> separate call to may_tx(), you only do the check once, not for every
> packet...

Yeah, also a good point.

Still, txq = get_txq(txq) doesn't feel right, so better to keep that
separate I think.

johannes
