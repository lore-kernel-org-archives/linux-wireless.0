Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59640 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933233AbcI0MI1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 08:08:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list\:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH 4.9] brcmfmac: use correct skb freeing helper when deleting flowring
References: <20160927091428.19223-1-zajec5@gmail.com>
        <86fd0b60-0f73-484b-1788-3ec740672232@broadcom.com>
        <87inthy441.fsf@kamboji.qca.qualcomm.com>
        <CACna6rwUR_GidhEFNTN+8mGQRpBdUzeM1-0NY65k6-McX7xGVg@mail.gmail.com>
        <CACna6rxDb_KMwGTFKu1Mf9azmk_PLO0aLR3foRtkqyywa1DNVQ@mail.gmail.com>
Date: Tue, 27 Sep 2016 15:08:20 +0300
In-Reply-To: <CACna6rxDb_KMwGTFKu1Mf9azmk_PLO0aLR3foRtkqyywa1DNVQ@mail.gmail.com>
        (=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Tue, 27 Sep 2016
 13:58:56 +0200")
Message-ID: <8760phy28b.fsf@kamboji.qca.qualcomm.com> (sfid-20160927_140853_053964_DDA16E70)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

>>>>> Kalle: this isn't important enough for 4.8 as it's too late for that.
>>>>>
>>>>> I'd like to get it for 4.9 however, as this fixes bug that could lead
>>>>> to WARNING on every add_key/del_key call. We was struggling with these
>>>>> WARNINGs for some time and this fixes one of two problems causing the=
m.
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
>
> Let me see if patchwork with pick Cc tag as it does for others.
>
> Cc: stable@vger.kernel.org # 4.5+

An excellent idea but no luck:

Signed-off-by: Rafa? Mi?ecki <rafal@milecki.pl>
Acked-by: Arend van Spriel <arend@broadcom.com>

I'll add this to my patchwork wishlist though, I think it would be a
really useful feature to have.

(The question marks are because of my buggy copy paste, ignore those)

--=20
Kalle Valo
