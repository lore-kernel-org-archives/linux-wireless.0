Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47136 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab0JOXmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 19:42:16 -0400
Message-ID: <4CB8E6D7.602@candelatech.com>
Date: Fri, 15 Oct 2010 16:42:15 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <20101014231958.GA3242@tux> <4CB79299.7000005@candelatech.com> <AANLkTinQmE6wm1pXkRL6p_3rkMvNrppmirjj3-jagMp8@mail.gmail.com> <20101014234853.GA10113@tux> <4CB886AF.3070800@candelatech.com> <AANLkTinhFj_iYjVzyfSfpUVdytfk4O9kCBnN8=Bwv0N7@mail.gmail.com> <4CB8AD3F.50201@candelatech.com> <20101015210720.GA2007@tux> <20101015232140.GA1796@tux> <4CB8E4DE.9070706@candelatech.com> <20101015233814.GA1866@tux>
In-Reply-To: <20101015233814.GA1866@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/15/2010 04:38 PM, Luis R. Rodriguez wrote:
> On Fri, Oct 15, 2010 at 04:33:50PM -0700, Ben Greear wrote:
>> On 10/15/2010 04:21 PM, Luis R. Rodriguez wrote:
>>> Ben, please give this patch a shot. I addresses three races on the PCU:
>>>
>>>     * When we were stopping the CPU for non-EDMA cards we never locked against
>>>       anything starting the PCU again
>>>
>>>     * ath9k_hw_startpcureceive() was being called without locking
>>>
>>>     * Although we lock on the rxbuf lock for contention against starting/stopping
>>>       the PCU, we also need to lock on the driver in locations where we start/stop
>>>       the PCU within the same location otherwise we end up in inconsistant states
>>>       and the hardware may end up proessing an incorrect buffer for DMA. To
>>>       protect against this we use a new PCU lock on the main part of the driver to
>>>       ensure each start/stop/reset operation is done atomically.
>>>
>>> And fixes one issue as a side effect:
>>>
>>>     * No more packet loss on ping flood when you have one STA associated :)
>>>
>>> The only issue I see with this is I eventually run out of memory and my box
>>> becomes useless, unless I am mistaking that for some other issue.
>>>
>>> Please give this a shot and if it cures your woes I'll split it up into
>>> 3 separate patches, or maybe just two, one for the first two and one for
>>> the last issue.
>>
>> Sounds good, but this lockdep splat happens almost immediately upon starting
>> my app:
>>
>> =======================================================
>> [ INFO: possible circular locking dependency detected ]
>> 2.6.36-rc8-wl+ #32
>> -------------------------------------------------------
>> swapper/0 is trying to acquire lock:
>>    (&(&sc->rx.pcu_lock)->rlock){+.-...}, at: [<fa16e5c7>] ath9k_tasklet+0x7e/0x140 [ath9k]
>>
>> but task is already holding lock:
>>    (&(&sc->rx.rxflushlock)->rlock){+.-...}, at: [<fa16e5b9>] ath9k_tasklet+0x70/0x140 [ath9k]
>>
>> which lock already depends on the new lock.
>>
>>
>> the existing dependency chain (in reverse order) is:
>>
>> ->  #1 (&(&sc->rx.rxflushlock)->rlock){+.-...}:
>>          [<c0457639>] lock_acquire+0x5a/0x78
>>          [<c075f6ed>] _raw_spin_lock_bh+0x20/0x2f
>>          [<fa170513>] ath_flushrecv+0x14/0x61 [ath9k]
>
> Ah we just need to nuke the flush lock, one second. Also remove my
> skb_copy() otherwise you will really run out of memory quickly,
> unless you really want to test with it :)

Since you free the pkt, it shouldn't really consume, eh?

Seems like we should be able to handle an extra 5 skbs floating
around the system..

I'll try your new patch now...

Thanks,
Ben

>
>    Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

