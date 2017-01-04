Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60230 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751551AbdADKJb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 05:09:31 -0500
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
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH] brcmfmac: avoid writing channel out of allocated array
References: <20170103083858.6981-1-zajec5@gmail.com>
        <f74a07d7-94a6-f9c6-ba12-adec6f708c3a@broadcom.com>
        <CACna6rzGRHLCdzxS_+MHXeZwF=BW4S52pDb9g9MuanNGyToEOw@mail.gmail.com>
Date: Wed, 04 Jan 2017 10:14:57 +0200
In-Reply-To: <CACna6rzGRHLCdzxS_+MHXeZwF=BW4S52pDb9g9MuanNGyToEOw@mail.gmail.com>
        (=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Tue, 3 Jan 2017
 12:31:30 +0100")
Message-ID: <87o9zni6m6.fsf@kamboji.qca.qualcomm.com> (sfid-20170104_110934_404021_C7DAC85D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

>>> @@ -5873,33 +5872,33 @@ static int brcmf_construct_chaninfo(struct brcm=
f_cfg80211_info *cfg,
>>>                   ch.bw =3D=3D BRCMU_CHAN_BW_80)
>>>                       continue;
>>>
>>> -             channel =3D band->channels;
>>> -             index =3D band->n_channels;
>>> +             channel =3D NULL;
>>>               for (j =3D 0; j < band->n_channels; j++) {
>>> -                     if (channel[j].hw_value =3D=3D ch.control_ch_num)=
 {
>>> -                             index =3D j;
>>> +                     if (band->channels[j].hw_value =3D=3D ch.control_=
ch_num) {
>>> +                             channel =3D &band->channels[j];
>>>                               break;
>>>                       }
>>>               }
>>
>> You could have kept the index construct and simply check if j =3D=3D
>> band->n_channels here to determine something is wrong.
>
> I wanted to simplify code at the same time. Having channel[index]
> repeated 7 times was a hint for me it could be handled better. I
> should have made that clear, I'll fix improve this in V2.

If you are making a patch to stable or -rc releases you should keep the
patch as simple as possible and do all the cleanup later. But I see that
you dropped "cc stable" in this patch so all is good, just a general
remark.

--=20
Kalle Valo
