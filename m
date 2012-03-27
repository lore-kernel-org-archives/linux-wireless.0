Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:57995 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab2C0Lml (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 07:42:41 -0400
Message-ID: <4F71A7AE.3050405@tieto.com> (sfid-20120327_134244_911790_FF644530)
Date: Tue, 27 Mar 2012 13:42:38 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 00/12] multi-channel support
References: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com>			 (sfid-20120320_154008_038091_B257E507) <1332494945.3506.23.camel@jlt3.sipsolutions.net>		 <4F6C82A5.5080302@tieto.com>	 <1332513075.10384.20.camel@jlt3.sipsolutions.net>	 <4F7060C2.9070206@tieto.com> <1332765914.5435.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332765914.5435.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Hi,
>
>>> I'm not sure we can easily use such a "stream" for off-channel
>>> operation. In particular, that "stream" might not support multiple
>>> queues.
>>
>> Does it need to? It could as well just map all queues to a single hw
>> queue with this design. I'm not sure if I get your point here.
>>
>>
>> Is it okay for us to not care if the driver supports real queues for
>> ACs? Should we care if a driver maps all ACs from a channel context (or
>> vif for that matter) onto a single hw queue? I'm wondering whether that
>> would simplify code paths?
>
> Well, ok, that would be possible, but I'm not sure I see the point in
> using a stream for off-channel. Today, we completely offload off-channel
> to the device, and I don't see how that could change? Having temporary
> context allocations all the time seems like a lot of thrash?

We could pre-allocate a fixed number of channel contexts based on the 
interface combinations, so we'd be "only" left with rebinding those 
contexts (and queue mappings along too).

I guess this part of the discussion is moot since we're going to put 
queues in vifs (and not in channel contexts).


>> But how do we then check if we need to stop given queue or not? Let's
>> say a driver stops q=2 which corresponds to BE on vif0 and vif1. But
>> then comes mac80211 aggregation and stops BE on vif0. I can only think
>> of a single solution to that: "u8 lock_reasons[256];" in ieee80211_local
>> but it seems like an overkill or is it not?
>
> Essentially that's what I was considering, we'd maintain all the queue
> state per HW queue ID. I said it would be a u8 for the HW queue ID, but
> I don't see anyone using more than say 32 or so, so we wouldn't really
> need 256. But we could go up to 256 if needed (though at that point we
> should probably do dynamic allocation instead.)

We could maybe allocate it according to hw.queues? I think it should be 
okay unless a driver has some kind of non-static queues. Are you aware 
of such a device/driver?



-- Pozdrawiam / Best regards, Michal Kazior.

