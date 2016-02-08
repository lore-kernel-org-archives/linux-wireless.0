Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:36751 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbcBHMbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 07:31:34 -0500
Received: by mail-lf0-f50.google.com with SMTP id 78so94204790lfy.3
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2016 04:31:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B878B5.9070106@openwrt.org>
References: <1454920723-48071-1-git-send-email-nbd@openwrt.org>
	<CANUX_P2qQmCPvFV4SqWxGQb_JzVqQ+_nT6LFtcYb37s5KfEfdw@mail.gmail.com>
	<CABPxzY+dgMWDeQ=_c0xyFq0g7HcP459b5Ypy3OoUwjDi+eooMA@mail.gmail.com>
	<CANUX_P1+okCC7xhJtbb-tF0a+=jyDYdVguadF9-zdYrBjEYajQ@mail.gmail.com>
	<56B878B5.9070106@openwrt.org>
Date: Mon, 8 Feb 2016 14:31:33 +0200
Message-ID: <CANUX_P1fXNDDGeyQA_NmUbwxdDNQ-3L0FFO2LuzYWm8mHFa4yA@mail.gmail.com> (sfid-20160208_133138_606983_673B2134)
Subject: Re: [RFC v4] mac80211: add A-MSDU tx support
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Gregory Greenman <gregory.greenman@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 8, 2016 at 1:15 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2016-02-08 11:26, Emmanuel Grumbach wrote:
>> On Mon, Feb 8, 2016 at 11:54 AM, Krishna Chaitanya
>> <chaitanya.mgit@gmail.com> wrote:
>>> On Mon, Feb 8, 2016 at 2:56 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>> On Mon, Feb 8, 2016 at 10:38 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>>>> Requires software tx queueing support. frag_list support (for zero-copy)
>>>>> is optional.
>>>>>
>>>>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>>>>> ---
>>>>
>>>>
>>>> Ok - looks fine, but... and here comes the hard stuff.
>>>> The frame size in the PLCP is limited in a way that you can't - from a
>>>> spec POV - enable A-MSDU for low rates. Of course, you don't want to
>>>> do that for low rates at all regardless of the spec.
>>>> Since you build the A-MSDU in the mac80211 Tx queue which is not aware
>>>> of the link quality, how do we prevent A-MSDU if the rate is low /
>>>> dropping.
>>>> I'd even argue that when the rates get lower, you'll  have more
>>>> packets piling up in the software queue and ... even more chance to
>>>> get A-MSDU in the exact case where you really want to avoid it?
>>>
>>> Similar to triggering AMPDU setup, we should put this control
>>> in RC (minstrel) to start/stop AMSDU based on link quality/if the rates
>>> drop below a pre-defined MCS (or) only for best-throughput rates.
>>
>> Ok - but the size of A-MPDU is determined in the firmware / hardware
>> typically (at least for Intel devices and I have to admit my ignorance
>> about other designs...). So that if you get bad link conditions, the
>> firmware can play for that size. A-MSDU built in the host is a
>> different story. I remember that athXk devices attach the rate on the
>> Tx packet itself so that the rate control is serialized with the data
>> path.
>> iwlwifi works differently: we have a map of rates in the firmware.
>> This map is maintained in the driver updated based on the feedback we
>> get from the device. When an update is needed, iwlwifi sends a command
>> to the firmware and that command bypasses all the Tx packets currently
>> queue so that a packet that is already waiting in the queue will be
>> sent with the updated map. This allows iwlwifi to react downgrade
>> faster when needed.
> Even ath9k has been converted to use a per-sta rate table with optional
> per-packet rate overrides for probing.
>
>> So - for athXk (and maybe the MediaTek devices Felix is working on),
>> this may not be a big problem: you'd need to add another input to the
>> A-MSDU building code coming from the rate control.
>> FWIW: in iwlwifi I simply decided to be on the safe side and allowed
>> the driver to build A-MSDUs only if the rate is fairly high and we are
>> not downgrading. But you saw (and commented on) that patch already I
>> think :)
> I think it would be a good idea for iwlwifi to start using the rate
> control API properly. Not only would that simplify integration with the
> A-MSDU code, it would also make it possible to compare minstrel_ht with
> the iwlwifi rate control code.
> The iwlwifi rate control code is doing some crazy things, and I'd be
> really interested in seeing how it compares to the more simple and
> structured approach taken in minstrel_ht.

Yeah ok. So I agree that iwlwifi uses the rate control API in a crazy
way, the change is planned (well.. I've said that long ago
already...). The plan is to move to internal API only (not go through
the rate control API) though...
I guess we have enough material for a beer in Seville I think :)

>
> - Felix
