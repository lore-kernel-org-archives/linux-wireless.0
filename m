Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35723 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751055AbdB1Jbe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 04:31:34 -0500
Received: by mail-wm0-f41.google.com with SMTP id v186so80549485wmd.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2017 01:30:28 -0800 (PST)
Subject: Re: [PATCH 4.12 1/2] brcmfmac: don't use 43602a1 firmware for 43602a0
 chipset
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20170224122739.1778-1-zajec5@gmail.com>
 <c7c82c1f-df42-c4a2-4f1f-1ff4928590d1@broadcom.com>
 <6d84044d4d51bbe99492b3cf06b1cae1@milecki.pl>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <7a50007a-60d0-9b4a-bac5-d5a8eac5ea2f@broadcom.com> (sfid-20170228_103212_921884_007208BD)
Date: Tue, 28 Feb 2017 10:23:02 +0100
MIME-Version: 1.0
In-Reply-To: <6d84044d4d51bbe99492b3cf06b1cae1@milecki.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24-2-2017 14:43, Rafał Miłecki wrote:
> On 2017-02-24 14:21, Arend Van Spriel wrote:
>> On 24-2-2017 13:27, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> 43602a0 uses chip revision 0 compared to 43602a1 with revision 1. In
>>> brcmfmac there is support for 43602a1 and from what I know supporting
>>> 43602a0 would require loading a different firmware.
>>
>> This is not necessarily true. It depends on whether the rom image is
>> different or not and there is no way to tell up front. So if a0 has same
>> rom image as a1 the firmware is compatible and no distinction is needed.
>> This tends to be the case for chips that only change the digit and not
>> the letter in the chip revision. Anyway, I do not know if a0 has
>> different rom image, but the a0 was never sold so there is no harm in
>> keeping it as is.
> 
> Just to be sure (I don't have such a good hardware knowledge):
> 1) Does ROM image mean some code that is permanently on the device?
> 2) Does firmware mean code we upload from the host driver?

Correct. For fullmac chips we select which functionality ends up in ROM.
Together with firmware loaded in RAM it comprises the running code on
the device.

> I'm not sure if I understand the rest of your description.
> 
> AFAIU first you said ROM image tends to be the same on chipset
> variations using
> the same letter. If this is so, why we need different firmware for
> 43602a0 and
> 43602a1? Or different firmware for 43570a0 and 43570a2?

The "tends to" provides an escape ;-) Things do not always turn out as
planned. Apart from the ROM image the differences can be due to
different core revisions.

> Also if what you said about sharing one ROM image between chip
> variations using
> the same letter was correct, shouldn't you expect the same ROM image on
> 43602a0
> and 43602a1?
> 
> Forgive me if something of this is obvious for you, I just don't have
> access to
> any Broadcom internal documentation :)

Well, to us these things are not always obvious either :-p

Regards,
Arend
