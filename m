Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:56683 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728597AbeIJSMq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 14:12:46 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH RFC v3 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <1536585051.3224.72.camel@sipsolutions.net>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1> <153635897010.14170.2992498632345986102.stgit@alrua-x1> <1536565717.3224.12.camel@sipsolutions.net> <87musplivy.fsf@toke.dk> <1536577419.3224.50.camel@sipsolutions.net> <87zhwpjzme.fsf@toke.dk> <1536583587.3224.71.camel@sipsolutions.net> <87wortjy8n.fsf@toke.dk> <1536585051.3224.72.camel@sipsolutions.net>
Date: Mon, 10 Sep 2018 15:18:41 +0200
Message-ID: <87r2i1jxse.fsf@toke.dk> (sfid-20180910_151854_506037_057D8929)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2018-09-10 at 15:08 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>=20
>> > On Mon, 2018-09-10 at 14:39 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wr=
ote:
>> >=20
>> > > > From then on, right now we basically just try to refill the hardwa=
re
>> > > > queue from the TXQ whenever the hardware releases frames from that
>> > > > queue. If there are none, we fall back to putting them on the hard=
ware
>> > > > queue from the wake signal.
>> > >=20
>> > > OK. So if the TXQ is ineligible to dequeue packets, but still have t=
hem
>> > > queued, there would need to be a signal (such as wake_txq()) when it
>> > > becomes eligible again, right?
>> >=20
>> > Right. It wouldn't have to be wake_txq, but that seems as appropriate =
as
>> > anything else.
>> >=20
>> > If we were to use ieee80211_airtime_may_transmit(), we'd have to have
>> > something that tells us "I previously told you it may not transmit, but
>> > now I changed my mind" :-)
>>=20
>> Yes, exactly. Hmm, I'll see what I can come up with :)
>
> No need to look at this right now - let's get this stuff sorted out
> first :)

Right, sure, I'll get the port of ath9k done first; but doesn't hurt to
think about API compatibility with the other drivers at the same time as
well...

If we have the start_schedule() / end_schedule() pair anyway, the latter
could notify any TXQs that became eligible during the scheduling round.

Also, instead of having the three different API functions
(next_txq()/may_tx()/schedule_txq()), we could  have get_txq(txq)/put_txq(t=
xq)
which would always need to be paired; but the argument to get_txq()
could be optional, and if the driver passes NULL it means "give me the
next available TXQ".

So for ath9k it would be:


start_schedule(ac);
while ((txq =3D get_txq(NULL)) {
  queue_aggregate(txq);
  put_txq(txq);
}
end_schedule(ac);

And for ath10k/iwlwifi it would be:

on_hw_notify(txq) {
 start_schedule(ac);
 if (txq =3D get_txq(txq)) {
   queue_packets(txq);
   put_txq(txq);
 }
 end_schedule(ac);
}


I think that would be simpler, API-wise?

-Toke
