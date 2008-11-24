Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:64957 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbYKXUZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 15:25:04 -0500
Received: by yw-out-2324.google.com with SMTP id 9so926005ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 12:25:02 -0800 (PST)
Message-ID: <40f31dec0811241225s1109b83aw244c96f2cb8ed59@mail.gmail.com> (sfid-20081124_212509_371761_B992EC09)
Date: Mon, 24 Nov 2008 22:25:02 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Richard Farina" <sidhayn@gmail.com>
Subject: Re: [Fwd: please don't regress ath5k.h]
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Renzmann" <mrenzmann@madwifi-project.org>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <492AC870.3030103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <492A14A7.4040808@gmail.com>
	 <1205.94.79.146.217.1227505499.squirrel@webmail.madwifi.org>
	 <1227507381.3599.55.camel@johannes.berg> <492AC870.3030103@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/11/24 Richard Farina <sidhayn@gmail.com>:
> Johannes Berg wrote:
>>
>> On Mon, 2008-11-24 at 06:44 +0100, Michael Renzmann wrote:
>>
>>>
>>> Hi.
>>>
>>> Richard Farina wrote:
>>>
>>>>
>>>> I recently saw this additional comment added to wireless-testing.git and
>>>> it has me a bit concerned.  I use this feature for a specific patch set
>>>> that I maintain and it would break it pretty bad to remove this.
>>>>
>>>
>>> Just an idea: what prevents you to add a patch to that patchset that
>>> reenables the amount of code you require from the CHAN_DEBUG stuff should
>>> it be removed upstream?
>>>
>>
>> Seconded, upstream should remove all the junk that it doesn't directly
>> need.
>>
>> johannes
>>
>
> I actually don't have a problem with removing chan_debug, I was merely
> requesting that the size hack it enables not be removed.
>
> More specifically in base.h I believe the code I specifically require is:
>
> #if CHAN_DEBUG
> #define ATH_CHAN_MAX    (26+26+26+200+200)
> #else
> #define ATH_CHAN_MAX    (14+14+14+252+20)
> #endif
>
>
> When removing chan_debug just please leave the higher max.  To be honest I
> don't know for sure what this code means but since enabling it fixes my
> patch it is clearly required.  There is no reason to be removing this as I
> am hoping to push a few patches upstream to properly support the
> capabilities of the hardware.
>
> Thanks,
> Rick

CHAN_DEBUG is an option i used a lot of time ago while debuging
channel flags on madwifi-old-openhal. When we switched to mac80211 and
ath5k, this code got useless, it just changes the maximum number of
channels the driver allocates and has nothing to do with debuging,
that's why i've put that TODO there. If you just want to register more
channels on mac80211, you can always change or redefine ATH_CHAN_MAX.

However have in mind that card supports (at it's best) 26 2.4GHz
channels and nearly 250 (i think) 5Ghz channels (eg. with 5Mhz
spacing) but we currently allocate much more (ATH_CHAN_MAX is huge)
because in madwifi-old-openhal we had to separate b channels from g
channels and gTurbo channels (so 3*26) etc (same for a /a turbo) which
is nonsense.

So on the technical side this code is crap and i must clean it up asap
:P even if we want to support all available hw frequencies we should
at least allocate them one time, not 3 ! Also not all channels are
actually available, synth might be able to tune to a wide range of
frequencies but the whole card is not just the MAC/PHY chip. For
example tuning your card to a frequency that hasn't been calibrated
can (and probably will) result pretty bad performance and tx
corruption due to mis-calibrated PHY. On extreme situations some other
parts of your card (probably the power amplifier or parts of auto-gain
control) might be permanently damaged, resulting a useless card (i
have reports of fried cards while tuning them way out of range -eg
6Ghz).

We can't support anything like that upstream, the best we can do is
provide a module option on ath5k to register all available hw channels
on mac80211 (and then crda takes over) for users that want to
experiment with different crda tables (eg. users that have licenses
etc) and know what they are doing, but the default behavior should be
to only register ISM channels to be on the safe side.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
