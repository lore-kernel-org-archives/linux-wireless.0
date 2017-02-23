Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:33751 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbdBWVla (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 16:41:30 -0500
Received: by mail-ot0-f193.google.com with SMTP id k4so410791otc.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 13:41:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2812805e-9108-284f-2165-34624d603364@broadcom.com>
References: <20170202213321.11591-1-zajec5@gmail.com> <20170202213321.11591-4-zajec5@gmail.com>
 <2812805e-9108-284f-2165-34624d603364@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Thu, 23 Feb 2017 22:41:28 +0100
Message-ID: <CACna6rzxbgkuvHWEk=7CgCzSeDfyR-RT_gHY=rwoZW_yC=LdOQ@mail.gmail.com> (sfid-20170223_224133_341323_B5CCF9F4)
Subject: Re: [PATCH V3 4/9] brcmfmac: add struct brcmf_pub parameter to the __brcmf_err
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Arend,

On 8 February 2017 at 10:54, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 2-2-2017 22:33, Rafa=C5=82 Mi=C5=82ecki wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> This will allow getting struct device reference from the passed
>> brcmf_pub for the needs of dev_err. More detailed messages are really
>> important for home routers which frequently have 2 (or even 3) wireless
>> cards supported by brcmfmac.
>>
>> Note that all calls are yet to be updated as for now brcmf_err macro
>> always passes NULL. This will be handled in following patch to make this
>> change easier to review.
>
> I prefer brcmf_err() to have struct device reference directly instead of
> using brcmf_pub. That would remove the need for patches 5 till 7 as bus
> specific code already has struct device. So I have acked the first three
> patches, but would like to revise 8 and 9.

I wanted to have some better perspective so I analyzed few upstream
Linux wireless drivers. It seems to be a pretty common pattern to have
one struct describing hardware that gets passed across the whole
driver. This way you can access any important info from any place of
the driver & some will probably say it also simplifies a driver.

For example following drivers use following struct in almost every
part of their code (across multiple files):
ath9k: struct ath_hw
ath10k: struct ath10k
iwlmvm: struct iwl_mvm
mt7601u: struct mt7601u_dev
mwifiex: struct mwifiex_private
rt2x00: struct rt2x00_dev

The most common / generic struct I found in brcmfmac was struct
brcmf_pub. That's why I tried to use it for the commonly used
brcmf_err.

What's the reason for hiding this struct from few random parts of the
code? Is there any real gain from this?

--=20
Rafa=C5=82
