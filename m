Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f174.google.com ([209.85.210.174]:34020 "EHLO
        mail-wj0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754187AbdAGLoP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Jan 2017 06:44:15 -0500
Received: by mail-wj0-f174.google.com with SMTP id tn15so47718210wjb.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2017 03:44:15 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: check if we can support used firmware API
 version
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <20170103161140.16919-1-zajec5@gmail.com>
 <1acc759f-0724-0ad4-fc2b-75bd41715cbb@broadcom.com>
 <CACna6rwJAjK1_Wpyj_NaOwdkegGONhTsS+-ckafkmyFRXAdphw@mail.gmail.com>
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
Message-ID: <545c00cc-9d80-19ab-ae39-319696888f6e@broadcom.com> (sfid-20170107_124539_481808_B5FFC1F2)
Date: Sat, 7 Jan 2017 12:44:12 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rwJAjK1_Wpyj_NaOwdkegGONhTsS+-ckafkmyFRXAdphw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5-1-2017 11:06, Rafał Miłecki wrote:
> On 5 January 2017 at 10:50, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 3-1-2017 17:11, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> Every new firmware API will most likely require changes in our code to
>>> support it. Right now we support 2 versions only. Refuse to init if we
>>> detect newer version.
>>>
>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>> ---
>>> Hi Arend,
>>>
>>> I think you were concerned about possible firmware API changes. Please
>>> review this patch, I hope it's a proper check for running unsupported
>>> firmware version which could result in broken communication between host
>>> driver and a device.
>>> ---
>>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> index 0babfc7..c69ae84 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> @@ -6816,6 +6816,11 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
>>>               brcmf_err("Failed to get D11 version (%d)\n", err);
>>>               goto priv_out;
>>>       }
>>> +     if (io_type > BRCMU_D11AC_IOTYPE) {
>>> +             brcmf_err("Unsupported IO version %d\n", io_type);
>>> +             goto priv_out;
>>> +     }
>>
>> I prefer to have this in brcmu_d11_attach() and have it return an error.
> 
> My too, but since you made brcmu_d11_attach part of *utils* and new IO
> version support may require driver changes, I didn't want to mess
> these two.
> 
> If it was up to me, I would keep brcmu_d11_attach in brcmfmac code and
> then add a proper check in this function indeed.
> 
> Is there any reason you made brcmu_d11_attach part of utils?

The plan was/is to add 11ac support in brcmsmac so it would need the
brcmu_d11_*() functions.

Regards,
Arend
