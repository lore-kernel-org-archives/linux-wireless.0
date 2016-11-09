Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:60277 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752824AbcKIXMR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 18:12:17 -0500
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: <make-wifi-fast@lists.bufferbloat.net>,
        <linux-wireless@vger.kernel.org>, Tim Shepard <shep@alum.mit.edu>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [v6] ath9k: Switch to using mac80211 intermediate software queues.
References: <20161109113149.5724-1-toke@toke.dk>
        <689eea51fa77432cbe4c70c6c2fe7b13@euamsexm01a.eu.qualcomm.com>
Date: Thu, 10 Nov 2016 00:10:40 +0100
In-Reply-To: <689eea51fa77432cbe4c70c6c2fe7b13@euamsexm01a.eu.qualcomm.com>
        (Kalle Valo's message of "Wed, 9 Nov 2016 23:42:47 +0100")
Message-ID: <87k2ccz1u7.fsf@toke.dk> (sfid-20161110_001221_142541_EBFD54BC)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> This switches ath9k over to using the mac80211 intermediate software
>> queueing mechanism for data packets. It removes the queueing inside the
>> driver, except for the retry queue, and instead pulls from mac80211 when
>> a packet is needed. The retry queue is used to store a packet that was
>> pulled but can't be sent immediately.
>>=20
>> The old code path in ath_tx_start that would queue packets has been
>> removed completely, as has the qlen limit tunables (since there's no
>> longer a queue in the driver to limit).
>>=20
>> The mac80211 intermediate software queues offer significant latency
>> reductions, and this patch allows ath9k to realise them. The exact gains
>> from this varies with the test scenario, but in an access point scenario
>> we have seen latency reductions ranging from 1/3 to as much as an order
>> of magnitude. We also achieve slightly better aggregation.
>>=20
>> Median latency (ping) figures with this patch applied at the access poin=
t,
>> with two high-rate stations and one low-rate station (HT20 5Ghz), running
>> a Flent rtt_fair_var_up test with one TCP flow and one ping flow going to
>> each station:
>>=20
>>                                  Fast station        Slow station
>> Default pfifo_fast qdisc:            430.4 ms            638.7 ms
>> fq_codel qdisc on iface:              35.5 ms            211.8 ms
>> This patch set:                       22.4 ms             38.2 ms
>>=20
>> Median aggregation sizes over the same test:
>>=20
>> Default pfifo_fast qdisc:            9.5 pkts            1.9 pkts
>> fq_codel qdisc on iface:            11.2 pkts            1.9 pkts
>> This patch set:                     13.9 pkts            1.9 pkts
>>=20
>> This patch is based on Tim's original patch set, but reworked quite
>> thoroughly.
>>=20
>> Cc: Tim Shepard <shep@alum.mit.edu>
>> Cc: Felix Fietkau <nbd@nbd.name>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>
> Perfect, just what I was hoping to see :) Unless something really
> surprising comes up I should apply this within the next few days.

Awesome, thanks! :)

-Toke
