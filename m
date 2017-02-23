Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:33319 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751222AbdBWVIK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 16:08:10 -0500
Received: by mail-ot0-f175.google.com with SMTP id k4so2455162otc.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 13:08:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2812805e-9108-284f-2165-34624d603364@broadcom.com>
References: <20170202213321.11591-1-zajec5@gmail.com> <20170202213321.11591-4-zajec5@gmail.com>
 <2812805e-9108-284f-2165-34624d603364@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Thu, 23 Feb 2017 22:08:09 +0100
Message-ID: <CACna6rxA_Nb_ha9jq73m6ynbYP9B+2Xd9XKGUTJBRJUciQofkw@mail.gmail.com> (sfid-20170223_220813_816642_C58B2389)
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

I'm a bit disappointed as this change of mind means I wasted quite
some time by reworking all brcmf_err calls :(

I intentionally sent
[PATCH RFC 2/2] brcmfmac: add brcmf_err_pub macro for better error messages
2 weeks before the final patch, to make sure my design is alright &
can be accepted :(

I'll work on another version of this patch & will send it as early RFC.

--=20
Rafa=C5=82
