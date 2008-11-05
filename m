Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:42931 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbYKEVzb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 16:55:31 -0500
Received: by wf-out-1314.google.com with SMTP id 27so238430wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 13:55:31 -0800 (PST)
Message-ID: <1ba2fa240811051355y4a38c5f1jc6433ac4eeb9dd1f@mail.gmail.com> (sfid-20081105_225538_711525_A1E6CB39)
Date: Wed, 5 Nov 2008 23:55:31 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: Thoughts about mac80211 client PS implementation
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <877i7hkgpn.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <87k5bhkjf1.fsf@nokia.com>
	 <1225917235.3619.180.camel@johannes.berg> <87fxm5ki6s.fsf@nokia.com>
	 <1225919146.3619.190.camel@johannes.berg> <877i7hkgpn.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 5, 2008 at 11:25 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>
>> On Wed, 2008-11-05 at 22:54 +0200, Kalle Valo wrote:
>>
>>> >> PS should be disabled while associated and running software scan, and
>>> >> naturally re-enabled after the scan has finished. I assume hardware
>>> >> scanning implementations are clever enough to disable PS when scanning
>>> >> and we don't have to worry about that case.
>>> >
>>> > And on that too. And should there be a monitor flag that disables PS, so
>>> > that we can "refcount" the PS bit in a way?
>>>
>>> Sorry, I don't follow you here. What do you mean by a monitor flag?
>>
>> Well if you add a monitor interface you may want to turn off PS,
>
> Ok, now I got it. I think your proposal makes sense.
>
>> but I suppose you can just do that on the wlan0 interface you're
>> associated on.
>
> Yeah, but that's an extra hassle. In my opinion better to do it in
> mac80211.
>
>>> > Why would you queue up frames? To reduce the number of radio wakeups
>>> > when TX traffic is low?
>>>
>>> Just because I assume that invoke_tx_handlers() cannot sleep but
>>> ieee80211_hw_config() sleeps. I didn't think of any other way to solve
>>> this, but I haven't thought that much about this. What do you think?
>>
>> But wouldn't that mean the other way around, i.e. whenever we transmit
>> we disable it and then start a timer that re-enables it? Ah, you're
>> thinking because TX handlers cannot sleep and the config callback may
>> sleep?
>
> Yes, that's what I'm worrying. And I definitely want op_config() to
> sleep, it makes my implementation in stlc45xx a lot easier :)
>
>> Hmm. I suppose then we'd have to defer the actual disable PS mode to
>> a work struct.
>
> Yes, that's what I was thinking. But now that I have thought about
> this more, I think queueing of the frames is not necessary. The first
> frames can be sent while in Power Save mode (ie. PSM bit set in Frame
> Control) and PS disable can happen later when the work struct is
> scheduled. I don't think this being a problem, we just have to be
> careful with race conditions.
>
>> Maybe we don't want to disable PS for a single frame though
>
> Actually I think we do. The reason why I'm interested in dynamic PS is
> the receive latency (transmit latency minimal is in practise). For
> example, let's think about DNS request. In the best scenario only one
> frame is transmitted, and if we don't come out receiving the reply to
> the dns request will take a long time. If DTIM is 3 and beacon
> interval 100 ms, the RTT for the DNS request/reply would be 300 ms.
> That's a long delay to a case where user has pressed a link in the
> browser and the browser starts to load a web page.
>
>> so how about this:
>>
>>  * When a frame is transmitted, store the current frame counter (do we
>>    have one? we could add one) somewhere and arm a timer to fire N
>>    milliseconds in the future.
>>  * The timer checks that we have transmitted
>>    more than M frames in the time since it was started, and if so queues
>>    a work struct to disable PS.
>>  * The work function also sets a flags somewhere "dynamic PS has
>>    disabled PS" and arms another timer to fire after R millisecinds,
>>    that timer will queue work to enable PS again
>>  * the TX code, when the "dynamic PS has disabled PS" flag is set, mods
>>    the re-enable timer to be R milliseconds in the future again
>>
>> That way, M frames within a period of N milliseconds will disable PS,
>> and it'll still disabled until R milliseconds elapse without traffic,
>> and no timers are fired unless they are needed.
>
> I think this sounds good. As I said above, I'm not sure about checking
> of M frames, but I'll implement it anyway and test it in practise.
>
> Johannes, thanks a lot for the help, again :)
>
> --
> Kalle Valo

What I wonder in this whole conversation is how the power is saved
here. How and what do you shut down physically in the NIC., I'm not
sure how much u save if u're just not receiving frames bur you are
still busy with scheduling timers.
In iwlwifi all the gory timing issues are handled in the firmware and
driver just may option to configure some parameters according battery
life, user preferences and current throughput plus firmware is able to
close different part of the HW as well. I'm have strong hunch that
also other vendors handle this in low level as this is kind of real
time to be in sync with DITIMs and listen intervals etc.

One other think is that PS can be enabled also in non associated state
from the HW perspective only during association and scanning it's
disabled but that not connected to the spec.

Currently we have all what you describing here enabled onfiguring
through iwconfig power and it's already working so I'm trying to
figure out how our strange HW :) will fit into this new stuff.

Tomas



 --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

\
