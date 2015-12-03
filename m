Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:23459 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbbLCV2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 16:28:15 -0500
Message-ID: <5660B3EB.1020805@broadcom.com> (sfid-20151203_222819_307049_F3BE3A8B)
Date: Thu, 3 Dec 2015 22:28:11 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Paul Stewart <pstew@chromium.org>, Dan Williams <dcbw@redhat.com>
CC: Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 08/11] brcmfmac: Make 5G join preference configurable.
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>	<1448447567-12189-9-git-send-email-arend@broadcom.com>	<87si3nkb2l.fsf@kamboji.qca.qualcomm.com>	<565D5B77.7050501@broadcom.com>	<87d1uqijnz.fsf@kamboji.qca.qualcomm.com>	<20151201110827.GA4362@w1.fi>	<565EF307.90002@broadcom.com>	<1449074331.21648.2.camel@redhat.com> <CAMcMvshxsVZ=W6Dc=8tyHQKJGp8E=OmeQg+nJFTJyqRwHCogLQ@mail.gmail.com>
In-Reply-To: <CAMcMvshxsVZ=W6Dc=8tyHQKJGp8E=OmeQg+nJFTJyqRwHCogLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/02/2015 07:00 PM, Paul Stewart wrote:
>  From my perspective it is useful to have the driver express whether
> or not it supports this parameter.  It may not change how the system
> operates, but it will be useful in testing to determine whether it
> is expected that a (given version of a) driver is expected to act
> with respect to this property so we can flag issues with the
> implementation.

Thanks, Paul

and others. Will come up with a RFC for this incorporating all feedback 
received.

Regards,
Arend

> On Wed, Dec 2, 2015 at 8:38 AM, Dan Williams <dcbw@redhat.com> wrote:
>> On Wed, 2015-12-02 at 14:32 +0100, Arend van Spriel wrote:
>>> On 12/01/2015 12:08 PM, Jouni Malinen wrote:
>>>> On Tue, Dec 01, 2015 at 11:48:32AM +0200, Kalle Valo wrote:
>>>>> Arend van Spriel <arend@broadcom.com> writes:
>>>>>> It solves a problem for us, but admittedly it is not something
>>>>>> that is
>>>>>> very usable by user-space apps. So I guess what you are
>>>>>> suggesting
>>>>>> here is to come up with a nl80211 api for this. On the mailing
>>>>>> list
>>>>>> (or hostap list) the topic pops up from time to time so there
>>>>>> are
>>>>>> people who would like to have such a knob to play with. Still
>>>>>> would
>>>>>> like to keep the module parameter although its use may change
>>>>>> when
>>>>>> nl80211 api is added.
>>>>>
>>>>> I don't know what is the best approach, that's why I would like
>>>>> to hear
>>>>> opinions from others. Personally I don't like the idea of adding
>>>>> 802.11
>>>>> level configuration options to module parameters, but on the
>>>>> other hand
>>>>> I don't have any strong opinions about this.
>>>>
>>>> I would like to see this as a new attribute to NL80211_CMD_CONNECT
>>>> to
>>>> provide parameters for offloaded (driver and/or firmware) BSS
>>>> selection
>>>> and roaming. If there is a driver that uses roaming offload with
>>>> NL80211_CMD_ASSOCIATE, the same attribute could be used there (but
>>>> I'm
>>>> not sure how exact such offloading would work in practice since I'd
>>>> expect both authentication and (re)association to be offloaded).
>>>
>>> Sounds reasonable. Just would like to explore the use-case a bit
>>> more.
>>> Looking at tools like NetworkManager and android network list, the
>>> user
>>> is always presented with just SSID listed once. For NetworkManager
>>>
>> While NM has band locking properties, there is currently no "prefer
>> 5ghz" since as Jouni said, the supplicant should probably just prefer
>> 5ghz right now.  In any case, the best path from an NM perspective
>> would be a supplicant per-network property that would then be sent for
>> CONNECT-capable drivers, or which the supplicant would manually handle
>> for softmac drivers through its existing AP selection code.
>>
>> Dan
>>
>>> details can be configured for a connection and the bss selection
>>> parameters could be one of those. What level of detail would be
>>> needed
>>> there. Not saying we can not have more detail in the nl80211 API.
>>>
>>>>> I guess we have two different designs, one where the roaming
>>>>> logic is in
>>>>> firmware and other where wpasupplicant is responsible for this.
>>>>> (And I
>>>>> assume that brcfmac belongs to the former group.) Ideally it
>>>>> would be
>>>>> nice that we would have a same configuration knob for both but I
>>>>> don't
>>>>> know if that's really feasible.
>>>>
>>>> Both of these would work as long as wpa_supplicant has means for
>>>> providing such configuration to the driver in a generic manner.
>>>> That
>>>> NL80211_CMD_CONNECT extension with a new optional attribute would
>>>> be
>>>> such a generic design.
>>>
>>> So does the driver need to advertise support for bss selection
>>> parameters or can it simply ignore the parameters. Assuming the
>>> latter
>>> for now.
>>>
>>> Regards,
>>> Arend
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux
>>> -wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

