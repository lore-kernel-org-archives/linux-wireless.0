Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:49701 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751017AbeBBKTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Feb 2018 05:19:31 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: lockdep warning in mac80211/tx.c, 4.13.16+ kernel, ath9k related
In-Reply-To: <488be568-d9c1-0697-9fa4-e1a623b4bed5@candelatech.com>
References: <d4632910-7dd9-b066-0c10-b21dd7cbfc61@candelatech.com> <1517523817.28814.10.camel@sipsolutions.net> <e8f8b910-ffa8-fbc7-3152-58ccf70b1ace@candelatech.com> <1517524837.28814.14.camel@sipsolutions.net> <1517525226.28814.15.camel@sipsolutions.net> <488be568-d9c1-0697-9fa4-e1a623b4bed5@candelatech.com>
Date: Fri, 02 Feb 2018 11:19:29 +0100
Message-ID: <87607f1yoe.fsf@toke.dk> (sfid-20180202_111936_329097_E2F48C64)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 02/01/2018 02:47 PM, Johannes Berg wrote:
>> On Thu, 2018-02-01 at 23:40 +0100, Johannes Berg wrote:
>>>
>>> The code does a plain rcu_dereference(), no locking other than
>>> rcu_read_lock() involved.
>>>
>>> On second thought though, I'm not convinced that your modifications
>>> caused the problem.
>>>
>>> Given your call stack, we'd expect rcu_read_lock() somewhere around
>>> ath_tid_dequeue (or its caller(s)), since ieee80211_tx_dequeue clearly
>>> requires it.
>>>
>>> Normally, ieee80211_tx_dequeue() is called from various places that
>>> probably come from mac80211 and already hold the rcu_read_lock(), e.g.
>>> the wake_tx_queue op.
>>>
>>> In this case, you're coming from drv_sta_state, so not sure why the
>>> driver thinks it's OK to call the dequeue there.
>>
>> Just to clarify - it could just be that in the "normal" case, when a
>> station dies, there's nothing on the queues - so the dequeue just
>> doesn't do anything and never goes into the code path where the
>> rcu_dereference() is, hence it might be a bug in mainline that just
>> never triggers in ordinary scenarios.
>
> It looks like the code in ath9k has not been changed in that area for
> some time.

Hmm, I think the issue here is that after the switch to mac80211 txqs,
the driver is now draining mac80211 queues, whereas before it was only
draining its own driver-internal queues (which are protected by the
ath_txq_lock() that ath_tx_node_cleanup() does grab). And when the
switch to the mac80211 queues happened, a call to rcu_read_lock() should
have been added. But, well, I had no idea this was needed until just
now, so obviously I didn't add that... :)

> Would adding rcu_read_lock in drv_sta_state() be a possibility?

Think it should probably just be added in ath_tx_node_cleanup()? Can
send a patch...

-Toke
