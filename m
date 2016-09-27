Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33011 "EHLO
        mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933320AbcI0MEW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 08:04:22 -0400
Received: by mail-pa0-f50.google.com with SMTP id cd13so1839663pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2016 05:04:22 -0700 (PDT)
Subject: Re: [PATCH 4.9] brcmfmac: use correct skb freeing helper when
 deleting flowring
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20160927091428.19223-1-zajec5@gmail.com>
 <86fd0b60-0f73-484b-1788-3ec740672232@broadcom.com>
 <87inthy441.fsf@kamboji.qca.qualcomm.com>
 <CACna6rwUR_GidhEFNTN+8mGQRpBdUzeM1-0NY65k6-McX7xGVg@mail.gmail.com>
 <CACna6rxDb_KMwGTFKu1Mf9azmk_PLO0aLR3foRtkqyywa1DNVQ@mail.gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <41e5f45f-1956-8c9d-49d4-cd73e2c5c7c0@broadcom.com> (sfid-20160927_140428_852135_465383C8)
Date: Tue, 27 Sep 2016 14:04:01 +0200
MIME-Version: 1.0
In-Reply-To: <CACna6rxDb_KMwGTFKu1Mf9azmk_PLO0aLR3foRtkqyywa1DNVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27-9-2016 13:58, Rafał Miłecki wrote:
> On 27 September 2016 at 13:44, Rafał Miłecki <zajec5@gmail.com> wrote:
>> On 27 September 2016 at 13:27, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> Arend Van Spriel <arend.vanspriel@broadcom.com> writes:
>>>
>>>> On 27-9-2016 11:14, Rafał Miłecki wrote:
>>>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>>>
>>>>> Flowrings contain skbs waiting for transmission that were passed to us
>>>>> by netif. It means we checked every one of them looking for 802.1x
>>>>> Ethernet type. When deleting flowring we have to use freeing function
>>>>> that will check for 802.1x type as well.
>>>>>
>>>>> Freeing skbs without a proper check was leading to counter not being
>>>>> properly decreased. This was triggering a WARNING every time
>>>>> brcmf_netdev_wait_pend8021x was called.
>>>>
>>>> Acked-by: Arend van Spriel <arend@broadcom.com>
>>>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>>>> ---
>>>>> Kalle: this isn't important enough for 4.8 as it's too late for that.
>>>>>
>>>>> I'd like to get it for 4.9 however, as this fixes bug that could lead
>>>>> to WARNING on every add_key/del_key call. We was struggling with these
>>>>> WARNINGs for some time and this fixes one of two problems causing them.
>>>
>>> Ok, I'll queue this for 4.9.
>>>
>>>> Please mark it for stable as well.
>>>
>>> I can add that. Any ideas how old releases stable releases should this
>>> go to?
>>
>> I was analyzing this.
>> 1) This patch uses brcmf_get_ifp which is available in 4.4+ only.
>> 2) It applies cleanly to 4.5+ only due to 32f90caa7debd ("brcmfmac:
>> Increase nr of supported flowrings.")
>> 3) 4.4 would also require applying to the patch without broadcom/ subdir
>>
>> That said I suggest 4.5+. Any objections?

No objections. Just a tip. I tend to look at kernel.org main page to see
the stable and long-term kernel listed. So 4.7+ and 4.5+ have same
meaning as 4.5 and 4.6 are not stable/long-term kernels.

Regards,
Arend

> Let me see if patchwork with pick Cc tag as it does for others.
> 
> Cc: stable@vger.kernel.org # 4.5+
> 
> This may be worth backporting to 4.4 as well (as it's longterm), but
> I'll do it separately due to patch not applying cleanly.
