Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47770 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab0HBKrs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 06:47:48 -0400
Message-ID: <4C56A251.7080903@openwrt.org>
Date: Mon, 02 Aug 2010 12:47:45 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Bruno Randolf <br1@einfach.org>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5] cfg80211: Add nl80211 antenna configuration
References: <20100729035820.5930.29864.stgit@tt-desk> <201007291812.28639.br1@einfach.org> 	<AANLkTi=ihY=pAmKaEp7Pga=DOxwASZqSxqmURbgnks-d@mail.gmail.com> 	<201008021313.54850.br1@einfach.org> <AANLkTimRnfa8HVpi0hcP7Eo9Nrns60ff3Hs+fq39WoJh@mail.gmail.com> 	<4C5688F7.1070200@openwrt.org> <AANLkTi=Qm53CgFNNgtF4iBvh3jbfYzd8XPH4y9ysUaoV@mail.gmail.com> 	<4C568D23.2000203@openwrt.org> <AANLkTinGdwt4bSPRDV=ZfPBmoKS42GgUVjLAg_O1vL3i@mail.gmail.com> 	<4C5690C7.2080104@openwrt.org> <AANLkTimoU+iF2bVJ-Fs4iT3k5v0iU9PaE783NhUdnQQ-@mail.gmail.com> 	<4C5699AE.6090103@openwrt.org> <AANLkTimWnefNaiPzqMXwc6d8aePmy3SZ8w9FB4=6CRko@mail.gmail.com>
In-Reply-To: <AANLkTimWnefNaiPzqMXwc6d8aePmy3SZ8w9FB4=6CRko@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-08-02 12:18 PM, Luis R. Rodriguez wrote:
> On Mon, Aug 2, 2010 at 3:10 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2010-08-02 11:52 AM, Luis R. Rodriguez wrote:
>>> On Mon, Aug 2, 2010 at 2:32 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>>> On 2010-08-02 11:23 AM, Luis R. Rodriguez wrote:
>>>>> Sure, I just did not see any code for this in these patches. My point
>>>>> about the hw config vs fake/mod'd is if we'd expose the mod'd config
>>>>> changes to userspace or if we'd keep them internal to cfg80211. How
>>>>> would this be dealt with?
>>>> Right now, cfg80211 doesn't know enough to handle this stuff on its own,
>>>> so let's handle it in the driver completely on the first iteration. The
>>>> patches do not need any changes for this right now.
>>>
>>> I'd prefer that code to be written rather then let this be defined as
>>> API now and let drivers deal with this differently. But that's me, I'm
>>> not the maintainer, I just will not deal with bug reports dealing with
>>> this and I'll assign them to you guys if this gets through. Still
>>> think its crap and should just go through debugfs until all the code
>>> mentioned does exist.
>> Sorry, but WTF? There's two parts to this: API visible to user space,
>> and the internal API for handling changes.
>> So you're suggesting to reject the user space API, because of missing
>> parts in the internal API (which we can change any time) that will only
>> be used for drivers that this series doesn't even contain any code for??
>> Am I confused here, or does this seem rather strange?
> 
> If the current patches are accepted it means anyone *can* submit
> patches for an 802.11n driver and expect it to be accepted. Hence why
> I was asking for this to be defined as a legacy API only, if that is
> the only purpose right now.
This discussion is getting quite redundant. I would like to ask you
again, what the specific concern purely from a user space API point of
view is.

You asked how run time changes should be handled, I made a proposal for
that (simply not accepting them at run time on 802.11n hardware if they
affect the chainmask), and then you started complaining about what
should be in cfg80211 and what should be in the drivers. What does that
have to do with the public API?

The limitations wrt. chainmask changes at run time are known, and they
aren't really hardware specific, so you won't see some random driver
suddenly implementing some hypothetical crazy scheme that nobody
expects. This has nothing to do with code being in cfg80211 vs code
being in the driver.

It's really simple: in AP mode, hostapd needs to have the HT stuff set
when it starts up, in STA mode, it needs to be set at least at assoc
time. Since this is affected by the chainmask, we can't just change
stuff at a random point in time, but this is expected.

So the lowest common denominator that we can use for all 802.11n
hardware in all modes is to just refuse changes unless the interface is
down. Then we use the antenna mask to calculate the chainmask (an
inherently driver specific aspect, at least at the moment), recalculate
the HT capabilities based on the chainmask (driver has to do this at
init time already, needs very little refactoring), and then just apply
the new settings to the hardware (again, driver specific, will probably
be deferred to the interface bringup sequence).

So aside from the meaning of the actual value, which we need to make
easier to understand in the user space code, the only thing that users
need to be aware of is this:

Legacy hardware  => run time changes possible (actually optional)
802.11n hardware => need to bring down the interface before changing
                    the antenna settings

What else is left that we need to figure out? What would we need the
temporary debugfs crap for?

- Felix
