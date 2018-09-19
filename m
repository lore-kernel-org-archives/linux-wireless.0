Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:39429 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730863AbeISOqG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 10:46:06 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v4 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <5e2612cbd4ea9f560a63149c599f8587@codeaurora.org>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1> <153711973109.9231.7094211814263758096.stgit@alrua-x1.karlstad.toke.dk> <13400b5f9bdb5e36c6afabd071cc7b0d@codeaurora.org> <87o9cvksiv.fsf@toke.dk> <efa33810860b2e5db789a76747bb826b@codeaurora.org> <87efdq8rn0.fsf@toke.dk> <5e2612cbd4ea9f560a63149c599f8587@codeaurora.org>
Date: Wed, 19 Sep 2018 11:09:06 +0200
Message-ID: <87y3bxkg5p.fsf@toke.dk> (sfid-20180919_110912_399796_CE6980FD)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-09-18 13:41, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>=20
>>>>> Also an option to add the node at head or tail would be preferred.=20
>>>>> If
>>>>> return_txq adds node at head of list, then it is forcing the driver=20
>>>>> to
>>>>> serve same txq until it becomes empty. Also this will not allow the
>>>>> driver to send N frames from each txqs.
>>>>=20
>>>> The whole point of this patch set is to move those kinds of decisions
>>>> out of the driver and into mac80211. The airtime scheduler won't
>>>> achieve
>>>> fairness if it allows queues to be queued to the end of the rotation
>>>> before its deficit turns negative. And obviously there's some lag in
>>>> this since we're using after-the-fact airtime information.
>>>>=20
>>> Hmm.. As you know ath10k kind of doing fairness by serving fixed=20
>>> frames
>>> from each txq. This approach will be removed from ath10k.
>>>=20
>>>> For ath9k this has not really been a problem in my tests; if the lag
>>>> turns out to be too great for ath10k (which I suppose is a=20
>>>> possibility
>>>> since we don't get airtime information on every TX-compl), I figure=20
>>>> we
>>>> can use the same estimated airtime value that is used for throttling
>>>> the
>>>> queues to adjust the deficit immediately...
>>>>=20
>>> Thats true. I am porting Kan's changes of airtime estimation for each
>>> msdu for firmware that does not report airtime.
>>=20
>> Right. My thinking with this was that we could put the per-frame=20
>> airtime
>> estimation into ieee80211_tx_dequeue(), which could track the
>> outstanding airtime and just return NULL if it goes over the threshold.
>> I think this is fairly straight-forward to do on its own; the biggest
>> problem is probably finding the space in the mac80211 cb?
>>=20
>> Is this what you are working on porting? Because then I'll wait for=20
>> your
>> patch rather than starting to write this code myself :)
>>=20
> Kind of.. something like below.
>
> tx_dequeue(){
>      compute airtime_est from last_tx_rate
>      if (sta->airtime[ac].deficit < airtime_est)
>          return NULL;
>      dequeue skb and store airtime_est in cb
> }

I think I would decouple it further and not use the deficit. But rather:

 tx_dequeue(){
      if (sta->airtime[ac].outstanding > AIRTIME_OUTSTANDING_MAX)
        return NULL
      compute airtime_est from last_tx_rate
      dequeue skb and store airtime_est in cb
      sta->airtime[ac].outstanding +=3D airtime_est;
 }

> Unfortunately ath10k is not reporting last_tx_rate in tx_status(). So
> I also applied this "ath10k: report tx rate using ieee80211_tx_status"
> change.

Yeah, that and the patch that computes the last used rate will probably
be necessary; but they can be pretty much applied as-is, right?

>> This mechanism on its own will get us the queue limiting and latency
>> reduction goodness for firmwares with deep queues. And for that it can
>> be completely independent of the airtime fairness scheduler, which can
>> use the after-tx-compl airtime information to presumably get more
>> accurate fairness which includes retransmissions etc.
>>=20
>> Now, we could *also* use the ahead-of-time airtime estimation for
>> fairness; either just as a fallback for drivers that can't get actual
>> airtime usage information for the hardware, or as an alternative in
>> cases where it works better for other reasons. But I think that
>> separating the two in the initial implementation makes more sense; that
>> will make it easier to experiment with different combinations of the
>> two.
>>=20
>> Does that make sense? :)
>>=20
> Completely agree. I was thinking of using this as fallback for devices
> that does not report airtime but tx rate.

Great! Seems we are converging on a workable solution, then :)

-Toke
