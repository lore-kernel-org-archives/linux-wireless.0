Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:45903 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbeHVOfH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 10:35:07 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/3] mac80211: add ieee80211_reorder_txq
In-Reply-To: <d8775275d843cc7aa65c5005fd4c42af@codeaurora.org>
References: <1534202011-13101-1-git-send-email-rmanohar@codeaurora.org> <1534202011-13101-4-git-send-email-rmanohar@codeaurora.org> <87a7pfaovy.fsf@toke.dk> <d8775275d843cc7aa65c5005fd4c42af@codeaurora.org>
Date: Wed, 22 Aug 2018 13:10:38 +0200
Message-ID: <87a7pe8xn5.fsf@toke.dk> (sfid-20180822_131043_473975_70055007)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-08-21 05:24, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>=20
>>> This allows the driver to refill airtime fairness deficit
>>> where the driver will not access txqs by ieee80211_next_txq.
>>> In tx push mode data path, high priority txqs will be scheduled
>>> for data transmission by ieee80211_next_txq and driver will not
>>> prioritize txqs whereas in push-pull mode, the drivers can
>>> prioritize txqs and access them directly. In such mode, airtime
>>> deficit can not filled by ieee80211_next_txq.
>>>=20
> [...]
>>=20
>> This needs to check that the txq is currently at the head of
>> local->active_txqs[txqi->txq.ac]; otherwise fairness enforcement=20
>> doesn't
>> work. And with this check I'm not sure the reorder function is terribly
>> useful for what you want to use it for?
>>=20
> Hmm.. I tried to keep the same policy of next_txq(). i.e do not allow
> serving txqs when the deficit is negative. reorder_txq() limits over
> serving the same txq by driver. So that driver is given chance to
> serve other txqs.

Yeah, but the fairness comes from all TXQs being given the *same amount*
of deficit increase. I.e., with reorder_txq() there needs to be a
guarantee that it is called the same number of times for all active
TXQs. Which is what the round-robin scheduling ensures in next_txq().

> As mentioned earlier, next_txq() can not be used for fetching txq
> directly. So reorder_txq() needs to take care of refilling txq after
> serving them.

Yeah, I got that; but see above. Unless there's a guarantee that the
push/pull mechanism will be round-robin scheduled (which as I'm reading
the code there isn't), just increasing the deficit on every call to
reorder_txq() is not going to ensure fairness (it'll probably help some,
but it won't be completely fair).

However, if we add the check to reorder_txq() so the deficit increase +
rotation is only done if the TXQ is at the head of the list, we'll get
round-robin-equivalent behaviour since a TXQ will only get to continue
when it happens to have rotated to the head of the queue. As I mentioned
previously it will break MIMO, but I we could fix that later once we've
verified that the basic mechanism works.

Alternatively, if we keep it the way you've written it in this patch, we
can iterate on the driver API and make sure that airtime reporting
actually works for ath10k, and then change the scheduler once everything
else is in place...

-Toke
