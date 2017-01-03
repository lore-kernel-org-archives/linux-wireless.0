Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33974 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755581AbdACLbb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 06:31:31 -0500
Received: by mail-oi0-f68.google.com with SMTP id 3so41019900oih.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2017 03:31:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f74a07d7-94a6-f9c6-ba12-adec6f708c3a@broadcom.com>
References: <20170103083858.6981-1-zajec5@gmail.com> <f74a07d7-94a6-f9c6-ba12-adec6f708c3a@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 3 Jan 2017 12:31:30 +0100
Message-ID: <CACna6rzGRHLCdzxS_+MHXeZwF=BW4S52pDb9g9MuanNGyToEOw@mail.gmail.com> (sfid-20170103_123141_728214_0951B9D2)
Subject: Re: [PATCH] brcmfmac: avoid writing channel out of allocated array
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

On 3 January 2017 at 12:02, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 3-1-2017 9:38, Rafa=C5=82 Mi=C5=82ecki wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> Our code was assigning number of channels to the index variable by
>> default. If firmware reported channel we didn't predict this would
>> result in using that initial index value and writing out of array.
>>
>> Fix this by detecting unexpected channel and ignoring it.
>>
>> Fixes: 58de92d2f95e ("brcmfmac: use static superset of channels for wiph=
y bands")
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>> ---
>> I'm not sure what kind of material it is. It fixes possible memory corru=
ption
>> (serious thing?) but this bug was there since Apr 2015, so is it worth f=
ixing
>> in 4.10? Or maybe I should even cc stable?
>> I don't think any released firmware reports any unexpected channel, so I=
 guess
>> noone ever hit this problem. I just noticed this possible problem when w=
orking
>> on another feature.
>
> Looking at the change I was going to ask if you actually hit the issue
> you are addressing here. The channels in __wl_2ghz_channels and
> __wl_5ghz_channels are complete list of channels for the particular band
> so it would mean firmware behaves out-of-spec or firmware api was
> changed. For robustness a change is acceptable I guess.

I guess that point of view depends on one's trust to the firmware. I
think it's wrong if a wrong/bugged/hacked firmware can result in
memory corruption in the kernel. Even if it's only about sizeof(struct
ieee80211_channel).


> My general policy is to submit fixes to wireless-drivers (and stable)
> only if it resolves a critical issue found during testing or a reported
> issue.

I'm OK with that.


>> ---
>>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 29 +++++++++++----=
-------
>>  1 file changed, 14 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c=
 b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> index 13ca3eb..0babfc7 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> @@ -5825,7 +5825,6 @@ static int brcmf_construct_chaninfo(struct brcmf_c=
fg80211_info *cfg,
>>       u32 i, j;
>>       u32 total;
>>       u32 chaninfo;
>> -     u32 index;
>>
>>       pbuf =3D kzalloc(BRCMF_DCMD_MEDLEN, GFP_KERNEL);
>>
>> @@ -5873,33 +5872,33 @@ static int brcmf_construct_chaninfo(struct brcmf=
_cfg80211_info *cfg,
>>                   ch.bw =3D=3D BRCMU_CHAN_BW_80)
>>                       continue;
>>
>> -             channel =3D band->channels;
>> -             index =3D band->n_channels;
>> +             channel =3D NULL;
>>               for (j =3D 0; j < band->n_channels; j++) {
>> -                     if (channel[j].hw_value =3D=3D ch.control_ch_num) =
{
>> -                             index =3D j;
>> +                     if (band->channels[j].hw_value =3D=3D ch.control_c=
h_num) {
>> +                             channel =3D &band->channels[j];
>>                               break;
>>                       }
>>               }
>
> You could have kept the index construct and simply check if j =3D=3D
> band->n_channels here to determine something is wrong.

I wanted to simplify code at the same time. Having channel[index]
repeated 7 times was a hint for me it could be handled better. I
should have made that clear, I'll fix improve this in V2.


>> -             channel[index].center_freq =3D
>> -                     ieee80211_channel_to_frequency(ch.control_ch_num,
>> -                                                    band->band);
>> -             channel[index].hw_value =3D ch.control_ch_num;
>
> So you are also removing these assignments which indeed seem redundant.
> Maybe make note of that in the commit message?

Good idea.


>> +             if (!channel) {
>> +                     brcmf_err("Firmware reported unexpected channel %d=
\n",
>> +                               ch.control_ch_num);
>> +                     continue;
>> +             }
>
> As stated above something is really off when this happens so should we
> continue and try to make sense of what firmware provides or simply fail.

Well, I could image something like this happening and not being critical.
The simplest case: Broadcom team releases a new firmware which
supports extra 5 GHz channels (e.g. due to the IEEE standard change).
Why should we refuse to run & support all "old" channel just because of tha=
t?

What do you mean by "make sense of what firmware provides"? Would kind
of solution would you suggest?

--=20
Rafa=C5=82
