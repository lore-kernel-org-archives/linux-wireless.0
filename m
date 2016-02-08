Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35832 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbcBHLR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 06:17:26 -0500
Received: by mail-wm0-f41.google.com with SMTP id c200so10392144wme.0
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2016 03:17:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzYJJfEG8AnU2KEefg5Cm=QBTv+Xt1nb0-Cdqy--k0X0SMw@mail.gmail.com>
References: <1454920723-48071-1-git-send-email-nbd@openwrt.org>
	<CANUX_P2qQmCPvFV4SqWxGQb_JzVqQ+_nT6LFtcYb37s5KfEfdw@mail.gmail.com>
	<CABPxzY+dgMWDeQ=_c0xyFq0g7HcP459b5Ypy3OoUwjDi+eooMA@mail.gmail.com>
	<CANUX_P1+okCC7xhJtbb-tF0a+=jyDYdVguadF9-zdYrBjEYajQ@mail.gmail.com>
	<CABPxzYJJfEG8AnU2KEefg5Cm=QBTv+Xt1nb0-Cdqy--k0X0SMw@mail.gmail.com>
Date: Mon, 8 Feb 2016 12:17:24 +0100
Message-ID: <CA+BoTQmaVJYySQ_McOMvnYpnZnBL6a8F-Pucyr6md+FrUsWy2g@mail.gmail.com> (sfid-20160208_121730_589352_D85A7404)
Subject: Re: [RFC v4] mac80211: add A-MSDU tx support
From: Michal Kazior <michal.kazior@tieto.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 February 2016 at 12:09, Krishna Chaitanya <chaitanya.mgit@gmail.com> wrote:
> On Mon, Feb 8, 2016 at 3:56 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
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
>> So - for athXk (and maybe the MediaTek devices Felix is working on),
>> this may not be a big problem: you'd need to add another input to the
>> A-MSDU building code coming from the rate control.
>> FWIW: in iwlwifi I simply decided to be on the safe side and allowed
>> the driver to build A-MSDUs only if the rate is fairly high and we are
>> not downgrading. But you saw (and commented on) that patch already I
>> think :)
>
> Yes, this approach is going to be tough for those devices with HW RC.
> We might need something like amsdu_action to get some feedback from
> device about using of amsdu?

The HW/FW rate control still may not have sufficient knobs for driver
to implement an amsdu_action().

What about if mac80211 tracked per-station-tid packet sojourn time and
based on that derive max A-MSDU bytelimit? This could also be useful
for the bufferbloat problem (discussed in the other thread) as well.


Michał
