Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:61720 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab2C0OlG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 10:41:06 -0400
Message-ID: <4F71D17F.6090405@tieto.com> (sfid-20120327_164110_737361_9437160C)
Date: Tue, 27 Mar 2012 16:41:03 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 00/12] multi-channel support
References: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com>			 (sfid-20120320_154008_038091_B257E507) <1332494945.3506.23.camel@jlt3.sipsolutions.net>		 <4F6C82A5.5080302@tieto.com>	 (sfid-20120323_150333_004349_1A5648D7) <1332514895.10384.40.camel@jlt3.sipsolutions.net>	 <4F706122.6080107@tieto.com> <1332767991.5435.34.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332767991.5435.34.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Ok, so ... I think we're getting to the bottom of our misunderstanding&
> confusion. I've completely ignored scan/off-channel in this because I
> don't have to handle it in software, our device handles it itself. It
> seems from this that you do need it handled in software.

No, not really. I was just worried as to not break things and maybe 
improve them as a bonus.


>>> Wrt. off-channel, I'm not sure I've understood you correctly. The
>>> current off-channel is a very short-lived thing that doesn't really use
>>> a "complete" channel context. In fact, in our implementation it is
>>> completely separate since it's temporary (**).
>>
>> Maybe you're right, but how can we then express off-channel in a neat
>> clean way? If we use channel contexts we get software AND hardware
>> off-channel (as long as the device supports it) at the same time.
>
> I'm not sure. The detach logic etc. you proposed above will really not
> be implementable in our device's context handling.

Right. I was trying to compensate for the sw off-channel channel 
contexts. I think I'm just going overboard and forget about practical 
usage of things sometimes, silly me.


>>   >>  Should we add capability
>>   >>  flags for each ieee80211_channel_stream? Or we could add new driver
>>   >>  callback, eg. "set_channel_try" and allow the driver to decide
>>   >>  whether it allows a certain hardware state or not.
>>   >
>>   >  This is not a fully feasible "stream" anyway. Think of it more like a
>>   >  single scan dwell -- you wouldn't express that as a separate "stream"
>>   >  I think?
>>
>> Why not? Should we care what vif we're working with, or hw for that
>> matter? Off-channel, as well as other operation means we want to do
>> something on a certain channel. It shouldn't matter how long we use that
>> channel (except if we're borrowing time from another operational mode).
>
> I'm not sure how your device works, but it seems that the device would
> require binding vifs to a channel context so that it knows which is
> active where? When to synchronise with beacons, for example?

I was thinking in general "what if".


>> Another question would be if we could do software multi-channel
>> operation. Do you think it's even possible and worth exploring?
>
> I don't think it's feasible to implement in mac80211 because of timing
> constraints. With devices like ath9k it can probably be done by relying
> on hardware timers, interrupts and queue blocking/opening, but because
> mac80211 has to deal with USB and SDIO chips too which can be really
> slow it can't really do this. So no, I wouldn't think it's worth
> exploring at least not directly in mac80211 -- maybe as a separate
> helper library or something.

I see. But then again - one should not expect software multi-channel to 
yield great performance, in fact I would expect it to be very slow.


> Now let's go back to the question of off-channel/scan -- this seems to
> be the fundamental difference in how we look at things. First, the same
> thing applies here. SW scanning in mac80211 right now is very
> inefficient when you try to do background scanning, since it doesn't
> synchronise with beacons etc. With multiple virtual interfaces, this
> will only get worse. With multiple channels, probably more so.
>
> Then also I'm in a bit of a luxurious position -- our device implements
> scanning and off-channel all by itself. For this reason, but also
> because of the timing, I've always wanted to ignore off-channel and
> scanning in the multi-channel code as much as possible.
>
> Your proposal to add temporary channel contexts might be feasible, but I
> wonder how complex it would become and how much of it can really be
> shared? I expect that ath9k will implement multi-channel completely in
> software, and any scheduler there would probably also roll in
> scanning/off-channel. (Not that I know, I don't work for QCA :) )

It would be nice if someone from Atheros camp could give us a hint on that.


> Also, I'm a bit afraid that doing so would make the channel context API
> even more complex, and it's not really easy anyway.
>
> I think I need to know more about how you would need to use those
> temporary channel contexts, but I have a feeling that we might be better
> off by splitting it into a separate helper library. I'm thinking this
> would essentially sit between mac80211 and the driver, and offer
> "translation services", i.e. it would have a "remain_on_channel"
> function that the driver could call for mac80211's remain_on_channel
> callback, and then this separate code could do something like your
> temporary channel context detach/attach etc.
>
> Would that seem okay to you? I'd rather leave this complexity out of
> mac80211, not just for complexity reasons but also to make the API have
> easier semantics.

I get the general idea but I can't imagine any detailed examples. I'm 
yet to fully understand mac80211 and other drivers/devices.


-- 
Pozdrawiam / Best regards, Michal Kazior.
