Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46909 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1EYUBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 16:01:34 -0400
Received: by iwn34 with SMTP id 34so5849iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 May 2011 13:01:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimRiU9Pv1B1=VC3XuREbmnpLk3S7w@mail.gmail.com>
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com>
 <201105241627.49201.helmut.schaa@googlemail.com> <BANLkTikcEsKYo=c=ZmzJRbmfgjmrFmx9bg@mail.gmail.com>
 <BANLkTin4MvdbqugTjtXvmjz5N8_TyTY7OA@mail.gmail.com> <BANLkTi=xfv_0C1mVAtO=w5JqyXLvh=vtAQ@mail.gmail.com>
 <BANLkTimMXbZE=vY95C0b2H3hx=4XWdU2Qg@mail.gmail.com> <BANLkTi=rS_kDhB8oKBLsz2Mk2nvRJMu5mg@mail.gmail.com>
 <4DDD5691.2040205@openwrt.org> <BANLkTi=1uj52P208p--5NU=Ow4rDndMkAw@mail.gmail.com>
 <BANLkTimRiU9Pv1B1=VC3XuREbmnpLk3S7w@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 25 May 2011 13:01:14 -0700
Message-ID: <BANLkTi=wFT0kUXEZ=vVNa1FqoxPEtxU3=w@mail.gmail.com> (sfid-20110525_220138_624571_5196F650)
Subject: Re: Initial automatic channel selection implementation
To: Felix Fietkau <nbd@openwrt.org>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	hostap@lists.shmoo.com, Matt Smith <Matt.Smith@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 25, 2011 at 12:27 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Wed, May 25, 2011 at 12:24 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Wed, May 25, 2011 at 12:20 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>>> On 2011-05-25 5:01 PM, Luis R. Rodriguez wrote:
>>>>
>>>> On Wed, May 25, 2011 at 7:45 AM, Helmut Schaa
>>>> <helmut.schaa@googlemail.com>  wrote:
>>>>>
>>>>>  On Wed, May 25, 2011 at 4:37 PM, Luis R. Rodriguez<mcgrof@gmail.com>
>>>>>  wrote:
>>>>>>
>>>>>>  On Wed, May 25, 2011 at 5:19 AM, Helmut Schaa
>>>>>>  <helmut.schaa@googlemail.com>  wrote:
>>>>>>>
>>>>>>>  On Wed, May 25, 2011 at 12:54 AM, Luis R. Rodriguez<mcgrof@gmail.com>
>>>>>>>  wrote:
>>>>>>>>
>>>>>>>>  Yes, thanks this is a lot of work already done. Now we just need a
>>>>>>>>  basic algorithm to parse this, quantify how ideal this channel is and
>>>>>>>>  then spit out a desired optimal channel.
>>>>>>>
>>>>>>>  That's what I've hacked some time ago (in form of the attached _ugly_
>>>>>>> shell
>>>>>>>  script that does auto channel selection with rt2x00, not sure if it
>>>>>>> works
>>>>>>>  correct with other drivers as the survey dump differs somehow between
>>>>>>>  rt2x00, ath5k and ath9k, and it only does channel 1-11):
>>>>>>>
>>>>>>>  - Iterate over all channels and stay on each channel for some time
>>>>>>
>>>>>>  Nice, yeah I was thinking of using the offchannel operation if we want
>>>>>>  to spend more time there for inspection and if associated. For first
>>>>>>  iteration it should be possible to just move around. In fact for AP
>>>>>>  purposes I suppose one will want to just start AP mode ASAP and then
>>>>>>  later do offchannel operations to do the inspection on the ideal
>>>>>>  channel. Otherwise we sit there idle until we complete the Automatic
>>>>>>  Channel Selection thingy.
>>>>>
>>>>>  Correct, especially if we also consider 5Ghz channels. Offchannel
>>>>> operations
>>>>>  would be nice but how can we ensure AP mode while being offchannel?
>>>>
>>>> Notification of absence.
>>>>
>>>>>>>  - Store busy time stats for each channel
>>>>>>>  - Choose the channel with the lowest busy time (and on 2.4Ghz also
>>>>>>>   check the busy times on adjacent channels)
>>>>>>
>>>>>>  So I was reviewing this -- if we are TX'ing or RX'ing it seems to me
>>>>>>  we should skip that time from the busy time, otherwise the "busy" time
>>>>>>  includes time we induced on TX'ing or RX'ing ourselves. So I was
>>>>>>  thinking of using the:
>>>>>>
>>>>>>   (active time - rx time - tx time)  / busy time
>>>>>
>>>>>  Looks good ;) just one problem from a rt2x00 POV: We can't report rx/tx
>>>>> busy
>>>>>  time separately, we can only advice the hw to include or exclude rx/tx
>>>>> time
>>>>>  from the busy time statistics.
>>>>
>>>> Doh, I see.. well in order for the above math to be useful we'd have
>>>> to be consistent across drivers. What is being done by rt2x00 right
>>>> now? If the later then the math would still work, otherwise then we'd
>>>> need to adjust.
>>>
>>> Excluding rx time isn't even a good idea, since it makes no distinction
>>> between local BSS or other activity in the area.
>>
>> What if we do an offchannel operation?
>
> Once we figure out that...
>
> The missing piece is how to deal with noise info here. In short the
> lower noise we have the better signal we'll get. The challenge then is
> to take into consideration the noise mathematically in such a that a
> high noise value would nullify any clean idle air time ratio
> conditions from the formula postulated before. Let me review again
> with some modifications.
>
> Active time is the time we spend on the channel, so to get an idea of
> how "busy" that channel is we have to remove the tx and rx time from
> that channel. That gives us the time we spent idle on that channel.
> Then the busy time is a subset of the entire active time but we should
> also exclude the time we spent tx'ing and rx'ing as well. We then
> have:
>
>  (busy time - rx time - tx time) / (active time - rx time - tx time)
>
> This is a bounded ratio already, given that if we spent 0 time tx'ing
> 0 time rx'ing, but 10 ms on a channel, and all that time we had busy
> time as well we'd have a ratio of 10 / 10 = 1. In the best case we'd
> have  0 / 10 = 0.
>
> What I'd like to do is to affect the ratio to nullify it if the noise
> is very low on the channel. Given that noise is logarithmic we'd have
> to use a logarithmic function as well. Working on that now.

I also noticed that the survey results will stale out after a period
of time. As such the offchannel operation should ideally be followed
imediately by a survey of the channel. Our current API though allows
only for an entire survey, not a channel specific survey query. Not a
big deal but just something to keep in mind if we intend on using this
further for repetitive heuristics on a channel. We'll have to extend
the survey dump later to accept channel specific queries.

  Luis
