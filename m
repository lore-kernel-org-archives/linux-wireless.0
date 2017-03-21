Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:34664 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932411AbdCUN5C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Mar 2017 09:57:02 -0400
Received: by mail-qt0-f178.google.com with SMTP id n21so131334141qta.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Mar 2017 06:57:01 -0700 (PDT)
Subject: Re: [PATCH V3 4/9] brcmfmac: add struct brcmf_pub parameter to the
 __brcmf_err
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <20170202213321.11591-1-zajec5@gmail.com>
 <20170202213321.11591-4-zajec5@gmail.com>
 <2812805e-9108-284f-2165-34624d603364@broadcom.com>
 <CACna6rzxbgkuvHWEk=7CgCzSeDfyR-RT_gHY=rwoZW_yC=LdOQ@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <76a76500-c673-78b6-a3f3-3cba68d21da8@broadcom.com> (sfid-20170321_145707_956485_1B616033)
Date: Tue, 21 Mar 2017 14:49:10 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rzxbgkuvHWEk=7CgCzSeDfyR-RT_gHY=rwoZW_yC=LdOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23-2-2017 22:41, Rafał Miłecki wrote:
> Hey Arend,
> 
> On 8 February 2017 at 10:54, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 2-2-2017 22:33, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> This will allow getting struct device reference from the passed
>>> brcmf_pub for the needs of dev_err. More detailed messages are really
>>> important for home routers which frequently have 2 (or even 3) wireless
>>> cards supported by brcmfmac.
>>>
>>> Note that all calls are yet to be updated as for now brcmf_err macro
>>> always passes NULL. This will be handled in following patch to make this
>>> change easier to review.
>>
>> I prefer brcmf_err() to have struct device reference directly instead of
>> using brcmf_pub. That would remove the need for patches 5 till 7 as bus
>> specific code already has struct device. So I have acked the first three
>> patches, but would like to revise 8 and 9.
> 
> I wanted to have some better perspective so I analyzed few upstream
> Linux wireless drivers. It seems to be a pretty common pattern to have
> one struct describing hardware that gets passed across the whole
> driver. This way you can access any important info from any place of
> the driver & some will probably say it also simplifies a driver.
> 
> For example following drivers use following struct in almost every
> part of their code (across multiple files):
> ath9k: struct ath_hw
> ath10k: struct ath10k
> iwlmvm: struct iwl_mvm
> mt7601u: struct mt7601u_dev
> mwifiex: struct mwifiex_private
> rt2x00: struct rt2x00_dev
> 
> The most common / generic struct I found in brcmfmac was struct
> brcmf_pub. That's why I tried to use it for the commonly used
> brcmf_err.
> 
> What's the reason for hiding this struct from few random parts of the
> code? Is there any real gain from this?

Hi Rafał,

Time flies when you are ... well, me apparently. I realized I did not
get back on this and looked at it myself. In brcmfmac we have layering
with a common layer and bus specific layer. The interface between those
layers is in bus.h, ie. struct brcmf_bus which holds reference to struct
device. So I would think using struct brcmf_bus in brcmf_err() would be
best fit. I also looked at doing some type introspection using
__builtin_types_compatible_p() which is built-in function available in
both GCC and Clang. Might be worth exploring.

Regards,
Arend
