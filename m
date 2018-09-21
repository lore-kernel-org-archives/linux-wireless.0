Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:50651 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728098AbeIUSgb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 14:36:31 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Kan Yan <kyan@google.com>
Subject: Re: [RFC v2] mac80211: budget outstanding airtime for transmission
In-Reply-To: <8d8e3775-4504-7b37-19b0-4a7fae054d12@nbd.name>
References: <1537470331-6270-1-git-send-email-rmanohar@codeaurora.org> <8d8e3775-4504-7b37-19b0-4a7fae054d12@nbd.name>
Date: Fri, 21 Sep 2018 14:47:45 +0200
Message-ID: <87r2hnhv9q.fsf@toke.dk> (sfid-20180921_144750_413072_FCD5A8A8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> On 2018-09-20 21:05, Rajkumar Manoharan wrote:
>> Per frame airtime estimation could be used to track outstanding airtime
>> of each txq and can be used to throttle ieee80211_tx_dequeue(). This
>> mechanism on its own will get us the queue limiting and latency
>> reduction goodness for firmwares with deep queues. And for that it can
>> be completely independent of the airtime fairness scheduler, which can
>> use the after-tx-compl airtime information to presumably get more
>> accurate fairness which includes retransmissions etc.
> What about packets that get dequeued from the txq, but get freed by
> ieee80211_free_txskb?
> I think this may be a bit fragile, since if for any reason accounting
> isn't perfect here, tx queues might stall.

Yeah, I worry about that as well. I guess we basically have three
avenues for fixing this?

1. Make sure packets are not freed after dequeue (probably not
feasible).

2. Add a mechanism to get queues unstuck if accounting does deviate (a
watchdog-type thing, or tie it to packet enqueue or something?).

3. Tie this back into the airtime fairness scheduler deficit, the same
way Kan's original patch did.


The problem with (3) is that we lose the ability to use a different
source of airtime usage information for the fairness scheduler (without
doing weird subtractions in the accounting). In particular, this would
mean we can't account for retransmissions. So I'd prefer (2), I think.

Anyone else with bright ideas? :)

-Toke
