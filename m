Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:42241 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbeDLKvX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 06:51:23 -0400
Received: by mail-qt0-f171.google.com with SMTP id j3so5624838qtn.9
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2018 03:51:23 -0700 (PDT)
Subject: Re: second wifi card enforce CN reg dom
To: solsTiCe d'Hiver <solstice.dhiver@gmail.com>
References: <CAE4vF2fCTEmEX8i+XVpvTJ1sRYDHDLr+fYFAM2PzTQTqkCoXVQ@mail.gmail.com>
 <CAE4vF2f2oXEvOJWDXPjmiWZTC=HOq5+xE_R64-_VvH6zc-Vw+A@mail.gmail.com>
 <5ACF0F5A.3090301@broadcom.com>
 <CAE4vF2ftgMPhKEUHr2rPaobM9Dtuc-B9rtbF5tWavvrwUXA7Ag@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5ACF3A28.4060303@broadcom.com> (sfid-20180412_125132_254760_353B94F8)
Date: Thu, 12 Apr 2018 12:51:20 +0200
MIME-Version: 1.0
In-Reply-To: <CAE4vF2ftgMPhKEUHr2rPaobM9Dtuc-B9rtbF5tWavvrwUXA7Ag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/12/2018 10:42 AM, solsTiCe d'Hiver wrote:
> Hi.
>
> This is beyond my comprehension that you could assert this is a non issue.

Well. I am just saying that it is by design. There is no way for the 
regulatory code to determine where you and your hardware actually reside 
so instead it takes a conservative approach.

btw. can you change the global reg back to FR using iw reg set?

Regards,
Arend

> If this is a hint, then someone should take this as a hint , and not
> enforce it blindly.
>
> I loose the capability to use a lot of channels on a card because of
> the mis-behaving of another. Or the crda framework, or whatever.
>
> What is even more stupid is that the TL-W722N is a 2.4GHz only band
> and that breaks operation on the 5GHz band of the other card.
>
> I am not even speaking about the fact that I use this in monitor mode,
> hence I will never emit anything. But anyway... crda has already
> broken everyhting even before I am entering monitor mode for the
> cards.
>
> Well, non issue... sight
>
> 2018-04-12 9:48 GMT+02:00 Arend van Spriel <arend.vanspriel@broadcom.com>:
>> On 4/12/2018 9:00 AM, solsTiCe d'Hiver wrote:
>>>
>>> Nobody cares about this ?
>>>
>>> Should I report this as a bug to the LKML ? or elsewhere ? to
>>> ath9k_htc dev ? to crda dev ?
>>>
>>> Please.
>>
>>
>> Hi,
>>
>> I do not think nobody cares, but what you describe is actually no issue as
>> far as I can determine. Wifi cards are typically programmed with some
>> country code and both provide that as a regulatory hint to the regulatory
>> framework, which adapts to a regulatory domain in which only channels and
>> power limits are set that are allowed for both devices. That is why some of
>> the rules in the global set #98 are matching the FR set and some rules match
>> the CN set. And because FR uses ETSI DFS and CN uses FCC DFS you are loosing
>> all channels that require DFS.
>>
>> Regards,
>> Arend
>>
>>
>>>
>>> 2018-04-10 21:57 GMT+02:00 solsTiCe d'Hiver <solstice.dhiver@gmail.com>:
>>>>
>>>> hi.
>>>>
>>>> I am trying to capture on 2 channels at the same time with 2 cards.
>>>>
>>>> One card is TP-Link TL-W722N v1 using ath9k_htc and the second one is
>>>> an Alfa AWUS051NH v2 using rt2800usb.
>>>>
>>>> I have tried this, first, on raspberry pi 0 W  using archlinux-arm and
>>>> reproduced the issue on a netbook using archlinux x64 too using latest
>>>> kernel and drivers. (seems to happen on ubuntu 17.10 on dell laptop
>>>> too)
>>>>
>>>> So when the Alfa card is used alone using the default reg dom FR, one
>>>> can change to 112 channel for example (using iw dev wlan1 set channel
>>>> 112)
>>>>
>>>> But once the tp-link is plugged in, reg dom seems to become CN and one
>>>> can't change the alfa card to 112 channel.
>>>>
>>>> iw reg get output change from
>>>> global
>>>> country FR: DFS-ETSI
>>>> (2402 - 2482 @ 40), (N/A, 20), (N/A)
>>>> (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW
>>>> (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW
>>>> (5490 - 5710 @ 160), (N/A, 27), (0 ms), DFS
>>>> (57000 - 66000 @ 2160), (N/A, 40), (N/A)
>>>> to
>>>> global
>>>> country 98: DFS-UNSET
>>>> (2402 - 2482 @ 40), (N/A, 20), (N/A)
>>>> (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW
>>>> (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW
>>>> (57240 - 59400 @ 2160), (N/A, 28), (N/A)
>>>> (59400 - 63720 @ 2160), (N/A, 40), (N/A)
>>>> (63720 - 65880 @ 2160), (N/A, 28), (N/A)
>>>>
>>>> phy#2
>>>> country CN: DFS-FCC
>>>> (2402 - 2482 @ 40), (N/A, 20), (N/A)
>>>> (5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
>>>> (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
>>>> (5735 - 5835 @ 80), (N/A, 30), (N/A)
>>>> (57240 - 59400 @ 2160), (N/A, 28), (N/A)
>>>> (59400 - 63720 @ 2160), (N/A, 44), (N/A)
>>>> (63720 - 65880 @ 2160), (N/A, 28), (N/A)
>>>>
>>>>
>>>> and all the channels above 100 are marked as disabled in iw list
>>>> output (after the plug not before) for the alfa card
>>>>
>>>> It is as if the TL-WN722N has CN reg dom hard-coded and that switches
>>>> it globally to CN too ???
>>>>
>>>> Is this a bug in ath9k_htc ? a bug with the TL-WN722N card ??
>>
>>
