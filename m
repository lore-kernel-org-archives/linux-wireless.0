Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45853 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab0I0TcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 15:32:04 -0400
Message-ID: <4CA0F124.9040602@openwrt.org>
Date: Mon, 27 Sep 2010 21:31:48 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] This allows ath5k to support virtual STA and AP interfaces.
References: <1285272430-9617-1-git-send-email-greearb@candelatech.com> <AANLkTi=n9GDjiBxiS0cen2objz+BO9CeC-Uy5c6hVWhS@mail.gmail.com> <4C9CEB3F.5090804@candelatech.com> <4C9DBD69.2070700@openwrt.org> <4CA0E91A.7090704@candelatech.com>
In-Reply-To: <4CA0E91A.7090704@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-27 8:57 PM, Ben Greear wrote:
> On 09/25/2010 02:14 AM, Felix Fietkau wrote:
>> On 2010-09-24 8:17 PM, Ben Greear wrote:
>>> On 09/24/2010 10:46 AM, Nick Kossifidis wrote:
>>>> 2010/9/23<greearb@candelatech.com>:
>>>>> From: Ben Greear<greearb@candelatech.com>
>>>>>
>>>>> +#define ATH5K_VIF_MAX  2048
>>>>
>>>> This is too much !!! 2048 interfaces with a total of 4 beacon buffers
>>>> 40 rx buffers and 200 tx buffers ? Has anyone tested this ?
>>>>
>>>> Also think about embedded devices, we don't want to waste memory like this...
>>>>
>>>>> +       struct ieee80211_vif *vifs[ATH5K_VIF_MAX];
>>>
>>> It only costs 4 or 8 bytes per pointer as long as no one actually
>>> adds the vifs.
>>>
>>> We've tested at least 128 on an old 1Ghz VIA system, and I'd hope for more
>>> on more modern hardware.  I didn't think the driver should make the decision
>>> to limit un-necessarily.
>>>
>>> If you still think this is too much, then tell me the biggest number
>>> you wouldn't complain about :)
>> Actually, looking at the code, I don't see much reason to even have this
>> array. Most of the time the code is iterating over the list anyway, so
>> we might as well just have a linked list here...
>> That way we can avoid introducing bogus limitations or memory waste.
> 
> I tried really hard to just use the mac80211 vif list, but I cannot
> find a sane way to lookup a vif by a particular immutable piece of information.
> I *could* find it based on mac-addr with a linear search by abusing
> the mac80211 iterator logic, but that seems fragile (can't macs change?)
> as well as a poor perfomer.
> 
> Any other regular list based approach is going to involve linear lookups
> as well.  See ath5k_beacon_send for the need to lookup based on
> an index or similar.
For ath5k_beacon_send it's much better to just store vif pointers in the
sc->bslot array, since the number of beacon slots is much more limited
anyway.

> I think for now, I'd like to just stay with a 512 fixed size array
> for the vifs.  Maybe someday someone will add an index to ieee80211_vif
> and logic to look it up by hash, but I suspect I'd have at best
> a long slow time of trying to get that sort of change upstream.
The changes can be simplified a lot by removing the array, I think this
should be done before the patch gets merged. It would be much cleaner
that way, since it also allows you to get rid of the loop looking for a
free slot, and you no longer need to iterate over all those empty slots
when iterating over lots of interfaces.

- Felix
