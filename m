Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:51957 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755301AbcHVQQj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 12:16:39 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
        Tim Shepard <shep@alum.mit.edu>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v4] ath9k: Switch to using mac80211 intermediate software
        queues.
References: <20160706193417.13080-1-toke@toke.dk>
        <20160805160346.10545-1-toke@toke.dk>
        <87mvk44xmt.fsf@purkki.adurom.net>
Date: Mon, 22 Aug 2016 18:16:34 +0200
In-Reply-To: <87mvk44xmt.fsf@purkki.adurom.net> (Kalle Valo's message of "Mon,
        22 Aug 2016 18:43:54 +0300")
Message-ID: <87bn0k4w4d.fsf@toke.dk> (sfid-20160822_181726_740949_AE8117BC)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>
>> This switches ath9k over to using the mac80211 intermediate software
>> queueing mechanism for data packets. It removes the queueing inside the
>> driver, except for the retry queue, and instead pulls from mac80211 when
>> a packet is needed. The retry queue is used to store a packet that was
>> pulled but can't be sent immediately.
>>
>> The old code path in ath_tx_start that would queue packets has been
>> removed completely, as has the qlen limit tunables (since there's no
>> longer a queue in the driver to limit).
>>
>> Based on Tim's original patch set, but reworked quite thoroughly.
>>
>> Cc: Tim Shepard <shep@alum.mit.edu>
>> Cc: Felix Fietkau <nbd@nbd.name>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>> ---
>> Changes since v3 (most due to Felix; thanks!):
>>   - Correctly notify mac80211 when there are packets in the retry queue
>>     on powersave start/stop.
>>   - Get rid of ath_tx_aggr_resume().
>>   - Some readability changes and additional WARN_ON/BUG_ON in
>>     appropriate places.
>
> This is great work but due to the regressions I'm not sure if this
> will be ready for 4.9. To get more testing time I wonder if we should
> wait for 4.10? IMHO applying this in the end of the cycle is too risky
> and we should try to maximise the time linux-next by applying this
> just after -rc1 is released.
>
> Thoughts?

Well, now that we understand what is causing the throughput regressions,
fixing them should be fairly straight forward (yeah, famous last words,
but still...). I already have a patch for the fast path and will go poke
at the slow path next. It'll probably require another workaround or two,
so I guess it won't be the architecturally clean ideal solution; but it
would make it possible to have something that works for 4.9 and then
iterate for a cleaner design for 4.10.

-Toke
