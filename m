Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:5395 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbZA1Mda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 07:33:30 -0500
Received: by fk-out-0910.google.com with SMTP id f33so3725096fkf.5
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 04:33:28 -0800 (PST)
To: Tomas Winkler <tomasw@gmail.com>
Cc: johannes@sipsolutions.net, vivek.natraj@gmail.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/2] mac80211: use ps-poll when dynamic power save  mode is disabled
References: <20090122114240.31443.18218.stgit@tikku>
	<20090122114546.31443.79387.stgit@tikku>
	<1ba2fa240901231528m21f13c1m43721f1d673e7cc7@mail.gmail.com>
	<874ozj964m.fsf@litku.valot.fi>
	<1ba2fa240901280346v6b4000b9m74eef26aabf86419@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 28 Jan 2009 14:33:24 +0200
In-Reply-To: <1ba2fa240901280346v6b4000b9m74eef26aabf86419@mail.gmail.com> (Tomas Winkler's message of "Wed\, 28 Jan 2009 13\:46\:16 +0200")
Message-ID: <87tz7j7gq3.fsf@litku.valot.fi> (sfid-20090128_133343_661527_D0C9F4BE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@gmail.com> writes:

> On Wed, Jan 28, 2009 at 10:39 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> Tomas Winkler <tomasw@gmail.com> writes:
>>
>>> On Thu, Jan 22, 2009 at 1:45 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
>>>> When a directed tim bit is set, mac80211 currently disables power save
>>>> ands sends a null frame to the AP. But if dynamic power save is
>>>> disabled, mac80211 will not enable power save ever gain.
>>>
>>> Why not?
>>
>> Because of a bug.
>
> So wouldn't be better to fix the bug.

I was planning to implement ps-poll feature anyway and concluded that
it's good idea to do it now that I can fix the bug at the same time.

>>>> Fix this by
>>>> adding ps-poll functionality to mac80211. When a directed tim bit is
>>>> set, mac80211 sends a ps-poll frame to the AP and checks for the more
>>>> data bit in the returned data frames.
>>>
>>> Still have to see the implementation but this sounds strange.
>>
>> Please be more specific, I don't understand what part you think is
>> strange. This is specified in the spec, see chapter 11.2.
>>
> Strange you've decided implementing another feature instead of fixing
> a bug. Not that I'm against existence of PS-poll implementation in
> mac80211 it just should not be in order to fix a bug.

It was just convenient for, nothing else. If this is very important, I
can add a new bug which fixes the bug first.

>> Let's take the null frame approach:
>>
>> 1. notice tim bit set
>> 2. send null frame (pm=0)
>> 3. receive data frames
>> 4. wait for all buffered data frames
>> 5. send null frame (pm=1)
>>
>> How do you know when the station has received all buffered data frames
>> from the AP (item 4 above)? By waiting a certain period after the last
>> received data frame? If that timeout is too short, we will get packet
>> loss, which is not good. If the timeout is too long, we waste too much
>> power.
>
> You can manage the idle timeout according the power save
> aggressiveness you want to achieve. There is no free lunch
> as result of power save you get some packet loss and jitter. Packet
> loss and jitter are natural to wifi also in normal operation.

Exactly what I was thinking. We seem to agree quite a lot :)

> Last packet loss is not really an issue it's guarded by 802.11
> retransmission mechanism and by higher protocol.

Yes, but counting on upper level retransmission has a bad vibe. And
upper level retransmission means more 802.11 frames, which means
increased power consumption. My assumption is that we will need
ps-poll feature in mac80211 in certain cases. It just needs to be
dynamically enabled, most probably userspace is the best place to make
this decision.

>> With ps-poll we don't have to set any timeouts, the station can go to
>> sleep immeadiately after receiving a data frame with moredata bit not
>> set. So I see a clear advantage in certain cases where the data
>> troughput is very low and maximum power savings is desired. For
>> example when the device is idle on the table, display turned off and
>> only irc/jabber session is running in the background.
>
> You certainly cannot predict the RX activity especially when you have
> irc running in background.

Of course not, nobody can. We just have to make good guesses.

>> And remember that userspace can control this with the power timeout
>> setting. My recommendation would be to use this only when the device
>> is idle and display is turned off.
>
> I guess that environment is more dynamic then user space can react
> upon and I thing that null packet method is more
> flexible then PS-poll but I also doesn't  have numbers to support my view
>
> Now maybe I'm a bit biased towards null frame approach because what we
> are doing in iwlwifi with and I know there was a lot of data collected
> in different environments to tune the numbers deep in HW and firmware
> but still this is was only on laptops usage in corporate or
> coffee/airport environments.
> There might be a case that for handhelds and different HW PS-poll
> might be preferable.  My point is that you cannot find universally
> said what is correct and there shell be configuration possibility from
> HW, user space, environment perspective.

If we find that the null frame wakeup is a better solution we can
remove ps-poll feature from mac80211, that's easy.

> Frankly I don't like much mapping power save aggressiveness to timeout
> number because there so much more parameters that governs it that is
> says nothing.

We have to start somewhere, this is definitely not the final solution.
We should add proper power save configuration to nl80211, but I think
we don't yet have enough understanding to do that. Better to use the
existing interfaces for now and try to get at least minimal power save
support to the drivers.

> I would suggest to expose to user space non-unit index of power save
> aggressiveness which can be mapped to different methods such as
> PS-Poll, dynamic power save or iwlwifi firmware implementation by
> other more reach configurable interface

That's something which we need to think about.

>>> Do you measure power consumption on of the NIC or the whole system?
>>
>> Usually I measure just the whole system. I can measure the nic, but
>> that's very time consuming.
>
> This can be important in tuning since you cannot distinguish between
> wasting of power by some wakening up timer or thread in the driver or
> by the fact that NIC itself doesn't enter power save state.

In N800/N810 the radio consumes so much power compared to the cpu that
I can spot the differences. But you are right, of course. It is good
to measure the consumption of the wi-fi chip itself also.

-- 
Kalle Valo
