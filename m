Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:54656 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728282AbeIJTq2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 15:46:28 -0400
Message-ID: <1536591110.3224.76.camel@sipsolutions.net> (sfid-20180910_165208_114758_709C4E21)
Subject: Re: [PATCH RFC v3 1/4] mac80211: Add TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Mon, 10 Sep 2018 16:51:50 +0200
In-Reply-To: <87r2i1jxse.fsf@toke.dk>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
         <153635897010.14170.2992498632345986102.stgit@alrua-x1>
         <1536565717.3224.12.camel@sipsolutions.net> <87musplivy.fsf@toke.dk>
         <1536577419.3224.50.camel@sipsolutions.net> <87zhwpjzme.fsf@toke.dk>
         <1536583587.3224.71.camel@sipsolutions.net> <87wortjy8n.fsf@toke.dk>
         <1536585051.3224.72.camel@sipsolutions.net> <87r2i1jxse.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-09-10 at 15:18 +0200, Toke Høiland-Jørgensen wrote:

> If we have the start_schedule() / end_schedule() pair anyway, the latter
> could notify any TXQs that became eligible during the scheduling round.

Do we even need end_schedule()? It's hard to pass multiple things to a
single call (do you build a list?), so having

	start_schedule(), get_txq(), return_txq()

would be sufficient?

> Also, instead of having the three different API functions
> (next_txq()/may_tx()/schedule_txq()), we could  have get_txq(txq)/put_txq(txq)
> which would always need to be paired; but the argument to get_txq()
> could be optional, and if the driver passes NULL it means "give me the
> next available TXQ".

I can't say I like this. It makes the meaning totally different:

 * with NULL: use the internal scheduler to determine which one is good
   to use next
 * non-NULL: essentially equivalent to may_tx()

> So for ath9k it would be:
> 
> 
> start_schedule(ac);
> while ((txq = get_txq(NULL)) {
>   queue_aggregate(txq);
>   put_txq(txq);
> }
> end_schedule(ac);
> 
> And for ath10k/iwlwifi it would be:
> 
> on_hw_notify(txq) {
>  start_schedule(ac);
>  if (txq = get_txq(txq)) {
>    queue_packets(txq);
>    put_txq(txq);
>  }
>  end_schedule(ac);
> }
> 
> 
> I think that would be simpler, API-wise?

I can't say I see much point in overloading get_txq() that way. You'd
never use it the same way.

Also, would you really start_schedule(ac) in the hw-managed case? It
seems like not? Basically it seems to me that in the hw-managed case all
you need is may_tx()? And in fact, once you opt in you don't even really
need *that* since mac80211 can just return NULL from get_skb()?

johannes
