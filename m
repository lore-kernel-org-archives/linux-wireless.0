Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36737 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965474AbdADKkx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 05:40:53 -0500
Received: by mail-oi0-f66.google.com with SMTP id u15so74052360oie.3
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2017 02:40:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <17d4eeb8-0cc2-4e0a-ad16-442dfec32a08@broadcom.com>
References: <20170103083858.6981-1-zajec5@gmail.com> <20170103164930.29989-1-zajec5@gmail.com>
 <17d4eeb8-0cc2-4e0a-ad16-442dfec32a08@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 4 Jan 2017 11:40:52 +0100
Message-ID: <CACna6rzFvpjfV_aTmYOac6_jE4XPmq6k6kNGwFM9_xFKgJ7MuA@mail.gmail.com> (sfid-20170104_114549_286342_682BBB28)
Subject: Re: [PATCH next V2] brcmfmac: avoid writing channel out of allocated array
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

On 4 January 2017 at 10:39, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 3-1-2017 17:49, Rafa=C5=82 Mi=C5=82ecki wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> Our code was assigning number of channels to the index variable by
>> default. If firmware reported channel we didn't predict this would
>> result in using that initial index value and writing out of array. This
>> never happened so far (we got a complete list of supported channels) but
>> it means possible memory corruption so we should handle it anyway.
>>
>> This patch simply detects unexpected channel and ignores it.
>>
>> As we don't try to create new entry now, it's also safe to drop hw_value
>> and center_freq assignment. For known channels we have these set anyway.
>>
>> I decided to fix this issue by assigning NULL or a target channel to the
>> channel variable. This was one of possible ways, I prefefred this one as
>> it also avoids using channel[index] over and over.
>>
>> Fixes: 58de92d2f95e ("brcmfmac: use static superset of channels for wiph=
y bands")
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>> ---
>> V2: Add extra comment in code for not-found channel.
>>     Make it clear this problem have never been seen so far
>>     Explain why it's safe to drop extra assignments
>>     Note & reason changing channel variable usage
>> ---
>>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 32 ++++++++++++---=
-------
>>  1 file changed, 17 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c=
 b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> index 9c2c128..a16dd7b 100644
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
>> @@ -5873,33 +5872,36 @@ static int brcmf_construct_chaninfo(struct brcmf=
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
>> -             channel[index].center_freq =3D
>> -                     ieee80211_channel_to_frequency(ch.control_ch_num,
>> -                                                    band->band);
>> -             channel[index].hw_value =3D ch.control_ch_num;
>> +             if (!channel) {
>> +                     /* It seems firmware supports some channel we neve=
r
>> +                      * considered. Something new in IEEE standard?
>> +                      */
>> +                     brcmf_err("Firmware reported unexpected channel %d=
\n",
>> +                               ch.control_ch_num);
>
> Maybe rephrase to "Ignoring unexpected firmware channel %d\n" so
> end-users are not alarmed by this error message. I think using
> brcmf_err() is justified, but you may even consider chiming down to
> brcmf_dbg(INFO, ...).

Can you suggest a better error message? It seems I'm too brave and I
don't find this one alarming, so I need suggestion.

--=20
Rafa=C5=82
