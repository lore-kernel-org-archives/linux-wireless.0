Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0050.outbound.protection.outlook.com ([104.47.36.50]:53760
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750795AbcK2KWV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 05:22:21 -0500
Subject: Re: [RFC] qtn: add FullMAC firmware for Quantenna QSR10G wifi device
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Kyle McMartin <kyle@mcmartin.ca>
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <1478706966.18306.1.camel@sipsolutions.net>
 <2fcb5f28-808e-f296-7e91-e5185e7577c9@quantenna.com>
 <1478725543.21403.4.camel@sipsolutions.net>
 <d1cfaf8a-55a6-3a7c-9e9d-ec810fe5b80d@quantenna.com>
 <1478864146.4129.4.camel@sipsolutions.net>
 <ec6a249c-ef57-40d8-0cd2-31613f046e23@quantenna.com>
 <CANLJ0sm_iBfXB5TkjwTNO8RyYK3W7z8ecOrZo5f65qjb4WMXKQ@mail.gmail.com>
 <063b80df-9cfa-14f1-4695-4239b42dfccb@rempel-privat.de>
 <217ac48f-d822-62d5-3def-744500821ac9@rempel-privat.de>
 <f4bf1f6a-6f5a-ea85-0835-c6805afdcd04@quantenna.com>
 <ad7935a1-735b-706a-9ac1-cd5076d8f307@rempel-privat.de>
 <12af5088-f026-380a-333d-2a2bb2b7a248@quantenna.com>
 <5370cbc3-638f-8346-e8ae-ac247a03fb4f@broadcom.com>
CC: Ben Hutchings <ben@decadent.org.uk>,
        Kyle McMartin <kyle@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <btherthala@quantenna.com>,
        <hwang@quantenna.com>, <smaksimenko@quantenna.com>,
        <dlebed@quantenna.com>, Igor Mitsyanko <imitsyanko@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
From: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <c98fbac9-1009-d582-4a0a-5a7291d9b13f@quantenna.com> (sfid-20161129_112234_077430_B4D3AC9D)
Date: Tue, 29 Nov 2016 13:22:05 +0300
MIME-Version: 1.0
In-Reply-To: <5370cbc3-638f-8346-e8ae-ac247a03fb4f@broadcom.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2016 12:34 PM, Arend Van Spriel wrote:
>
> On 29-11-2016 10:10, IgorMitsyanko wrote:
>> On 11/29/2016 06:49 AM, Oleksij Rempel wrote:
>>> Am 28.11.2016 um 20:01 schrieb IgorMitsyanko:
>>>> On 11/28/2016 08:33 PM, Oleksij Rempel wrote:
>>>>> Am 28.11.2016 um 18:10 schrieb Oleksij Rempel:
> [...]
>
>>>> Oleksij, yes, that's correct, it includes entire Linux environment; the
>>>> reasoning is that it allows to hide all WiFi-related logic inside device
>>>> itself, and emulate simple Ethernet device for external system
>>>> (therefore, freeing external system resources).
>>>>
>>>> This approach was working really well for us until recently, but now
>>>> that company is expanding, we want to have more flexible and standardize
>>>> interface available for external system to manage wireless connection,
>>>> and FullMAC driver seems to be the best solution here.
>>> you mean, this driver will not use mac80211 framework provided by kernel?
>> Yes, this driver is FullMAC - converting Quantenna drivers codebase to
>> mac80211 framework will require significant effort from developers and
>> QA, but I think in the future it will have to be done anyway.
> Why? The linux wireless subsystem supports both models, ie.
> cfg80211-based drivers and mac80211-based drivers, so there is no
> technical reason for making the effort. There are clearly benefits in
> using a generic and freely available 802.11 stack like mac80211.

There is definitely a benefit if starting a new product development, 
however with existing products its not that simple due to highly 
conservative approach:
- for many years development was based on old MadWiFi driver and older 
kernel. Over time it was modified and rewritten to fit internal needs, 
and integrating it into mac80211 (to preserve the same behavior) would 
require significant effort.
- it takes a lot of resources to validate that system works as expected. 
Quantenna itself is doing QA testing and certification + engineering has 
to be sure there is no performance/feature regression + end product 
manufacturers has to do their own QA. Each change means a lot of time 
and money spend on validation, new potential bugs to fix etc

With FullMAC driver on the other hand, device firmware is a "black box" 
for external system and firmware changes can be kept to a minimum.
I'd like to clarify that I think that moving to mac80211 is inevitable 
in any case and will happen in the future.

>
> Regards,
> Arend
