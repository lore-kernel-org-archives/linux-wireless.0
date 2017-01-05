Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35115 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938306AbdAEKGO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 05:06:14 -0500
Received: by mail-oi0-f66.google.com with SMTP id v84so78038945oie.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jan 2017 02:06:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1acc759f-0724-0ad4-fc2b-75bd41715cbb@broadcom.com>
References: <20170103161140.16919-1-zajec5@gmail.com> <1acc759f-0724-0ad4-fc2b-75bd41715cbb@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Thu, 5 Jan 2017 11:06:13 +0100
Message-ID: <CACna6rwJAjK1_Wpyj_NaOwdkegGONhTsS+-ckafkmyFRXAdphw@mail.gmail.com> (sfid-20170105_110645_753071_87A8B302)
Subject: Re: [PATCH] brcmfmac: check if we can support used firmware API version
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

On 5 January 2017 at 10:50, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 3-1-2017 17:11, Rafa=C5=82 Mi=C5=82ecki wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> Every new firmware API will most likely require changes in our code to
>> support it. Right now we support 2 versions only. Refuse to init if we
>> detect newer version.
>>
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>> ---
>> Hi Arend,
>>
>> I think you were concerned about possible firmware API changes. Please
>> review this patch, I hope it's a proper check for running unsupported
>> firmware version which could result in broken communication between host
>> driver and a device.
>> ---
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c=
 b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> index 0babfc7..c69ae84 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> @@ -6816,6 +6816,11 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach=
(struct brcmf_pub *drvr,
>>               brcmf_err("Failed to get D11 version (%d)\n", err);
>>               goto priv_out;
>>       }
>> +     if (io_type > BRCMU_D11AC_IOTYPE) {
>> +             brcmf_err("Unsupported IO version %d\n", io_type);
>> +             goto priv_out;
>> +     }
>
> I prefer to have this in brcmu_d11_attach() and have it return an error.

My too, but since you made brcmu_d11_attach part of *utils* and new IO
version support may require driver changes, I didn't want to mess
these two.

If it was up to me, I would keep brcmu_d11_attach in brcmfmac code and
then add a proper check in this function indeed.

Is there any reason you made brcmu_d11_attach part of utils?
