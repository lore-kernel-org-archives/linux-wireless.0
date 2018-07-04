Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54372 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752975AbeGDEZK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 00:25:10 -0400
Subject: Re: [PATCH] mac80211: don't put null-data frames on the normal TXQ
To: Johannes Berg <johannes@sipsolutions.net>,
        Peter Oh <peter.oh@bowerswilkins.com>,
        linux-wireless@vger.kernel.org
References: <20180703124725.30917-1-johannes@sipsolutions.net>
 <e9813f60-5cf5-a4bf-5906-623282319991@bowerswilkins.com>
 <1530661681.4735.51.camel@sipsolutions.net>
Cc: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Felix Fietkau <nbd@nbd.name>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <e6812d98-53b4-a593-fc76-69b6e5f7b0fd@candelatech.com> (sfid-20180704_062515_058422_F3D02918)
Date: Tue, 3 Jul 2018 21:24:58 -0700
MIME-Version: 1.0
In-Reply-To: <1530661681.4735.51.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/03/2018 04:48 PM, Johannes Berg wrote:
> On Tue, 2018-07-03 at 13:40 -0700, Peter Oh wrote:
>>
>> On 07/03/2018 05:47 AM, Johannes Berg wrote:
>>> From: Johannes Berg <johannes.berg@intel.com>
>>>
>>> Since (QoS) NDP frames shouldn't be put into aggregation nor are
>>> assigned real sequence numbers, etc. it's better to treat them as
>>> non-data packets and not put them on the normal TXQs, for example
>>> when building A-MPDUs they need to be treated specially,
>>
>> To be treated specially at which layer, mac80211 or drivers?
>
> They cannot be put into an A-MPDU, so you need to skip them when
> building A-MPDUs.
>
>> Are you seeing any issues other than complexity of handling NDP or is it
>> just improvement?
>
> I'm not actually running any hardware on my development setup that would
> use TXQs today. However, I'm starting to work on converting iwlwifi to
> it, and if we put the NDPs on there it means we no longer can schedule
> the TXQ to a single hardware queue.
>
> Similarly, I think for other drivers it would be a complexity reduction
> and possibly performance improvement with aggregation because you no
> longer need to check if the next frame is an NDP and if yes, finish the
> open A-MPDU and put both frames on the HW queue.
>
> That said, I hadn't looked much at the drivers. Seems the situation is
> worse than I thought, with those not doing it so well.
>
> ath10k appears to not do aggregation in the host, and I guess the data
> isn't split over multiple queues so the firmware has to determine/buffer
> it some other way. No idea how that would work.

This is my current understanding of ath10k..hope it helps.

ath10k firmware does handle the aggregation.  It doesn't pay much attention
to the driver's txqueues.  For wave-2 firmware, the firmware will
attempt to fetch frames for peers in a fair/optimal way, and that should
indirectly take the txqueues into account.

Wave-1 does not do any of the prefetch logic as far as I know.

Stock firmware sends mgt frames through an entirely different tx path,
while my ath10k-ct firmware can send all frames through the same 'htt'
transmit path.  Either way, the firmware has final control over what
goes to what tid and what is aggregated.

That said, there are memory use-after-free and other bugs related to
txq in ath10k.  Hopefully it will be fixed by the stop-txqueue patch
that has been in recent discussion.

Thanks,
Ben

> I see no evidence of ath9k doing this correctly, so this might fix a bug
> there, but I may have missed it.
>
> mt76 also appears to behave erroneously: if the txq is marked with
> aggregation it will even update the mtxq->agg_ssn to 0x10 for QoS NDPs,
> because those always have seqno 0; in mt76_check_agg_ssn:
> 	mtxq->agg_ssn = le16_to_cpu(hdr->seq_ctrl) + 0x10;
>
> johannes
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
