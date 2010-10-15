Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49355 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0JOXjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 19:39:52 -0400
Message-ID: <4CB8E647.9030808@candelatech.com>
Date: Fri, 15 Oct 2010 16:39:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com> <20101014225150.GB15740@tux> <20101014231958.GA3242@tux> <4CB79299.7000005@candelatech.com> <AANLkTinQmE6wm1pXkRL6p_3rkMvNrppmirjj3-jagMp8@mail.gmail.com> <20101014234853.GA10113@tux> <4CB886AF.3070800@candelatech.com> <AANLkTinhFj_iYjVzyfSfpUVdytfk4O9kCBnN8=Bwv0N7@mail.gmail.com> <4CB8AD3F.50201@candelatech.com> <20101015210720.GA2007@tux> <20101015232140.GA1796@tux> <4CB8E4DE.9070706@candelatech.com>
In-Reply-To: <4CB8E4DE.9070706@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/15/2010 04:33 PM, Ben Greear wrote:
> On 10/15/2010 04:21 PM, Luis R. Rodriguez wrote:
>> Ben, please give this patch a shot. I addresses three races on the PCU:
>>
>> * When we were stopping the CPU for non-EDMA cards we never locked
>> against
>> anything starting the PCU again
>>
>> * ath9k_hw_startpcureceive() was being called without locking
>>
>> * Although we lock on the rxbuf lock for contention against
>> starting/stopping
>> the PCU, we also need to lock on the driver in locations where we
>> start/stop
>> the PCU within the same location otherwise we end up in inconsistant
>> states
>> and the hardware may end up proessing an incorrect buffer for DMA. To
>> protect against this we use a new PCU lock on the main part of the
>> driver to
>> ensure each start/stop/reset operation is done atomically.
>>
>> And fixes one issue as a side effect:
>>
>> * No more packet loss on ping flood when you have one STA associated :)
>>
>> The only issue I see with this is I eventually run out of memory and
>> my box
>> becomes useless, unless I am mistaking that for some other issue.
>>
>> Please give this a shot and if it cures your woes I'll split it up into
>> 3 separate patches, or maybe just two, one for the first two and one for
>> the last issue.
>
> Sounds good, but this lockdep splat happens almost immediately upon
> starting
> my app:
>
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.36-rc8-wl+ #32

It ran for a bit..never did see the poison warning, but system hard-locked
(sysrq b on the serial console got no response) after a bit.  Hopefully
just because it hit this potential deadlock.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

