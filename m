Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34060 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753107AbdARSjV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 13:39:21 -0500
Received: by mail-lf0-f65.google.com with SMTP id q89so2952507lfi.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2017 10:39:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <bab86bb5-7815-e5ea-053d-ed6b18af6677@broadcom.com>
References: <20170117232405.7672-1-gavinli@thegavinli.com> <bab86bb5-7815-e5ea-053d-ed6b18af6677@broadcom.com>
From: Gavin Li <gavinli@thegavinli.com>
Date: Wed, 18 Jan 2017 10:39:07 -0800
Message-ID: <CA+GxvY43AbKOVJFWAxHg1Gku=LD-dveHY8m6=zPPu9qR4+r=Fg@mail.gmail.com> (sfid-20170118_193925_062760_4A5B0982)
Subject: Re: [PATCH v3] brcmfmac: fix incorrect event channel deduction
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        Stable <stable@vger.kernel.org>, Gavin Li <git@thegavinli.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think calling this a performance regression is a bit understated; my
download speed jumped from 1Mbit/s back up to 40MBit/s after applying
the patch due to the sheer amount of packets being incorrectly
processed.

In addition, processing arbitrary data frames as firmware events might
be a security vulnerability.

On Wed, Jan 18, 2017 at 4:38 AM, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 18-1-2017 0:24, gavinli@thegavinli.com wrote:
>> From: Gavin Li <git@thegavinli.com>
>>
>> brcmf_sdio_fromevntchan() was being called on the the data frame
>> rather than the software header, causing some frames to be
>> mischaracterized as on the event channel rather than the data channel.
>>
>> This fixes a major performance regression (due to dropped packets).
>>
>> Fixes: c56caa9db8ab ("brcmfmac: screening firmware event packet")
>
> Actually would prefer Franky to chime in as well as he made the change
> and confirm correctness. It was introduced a couple of kernel versions
> back and only a performance regression so seems ok to let this go in
> 4.11 for now and backport as needed for stable later.
>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Gavin Li <git@thegavinli.com>
>> Cc: <stable@vger.kernel.org> [4.7+]
>> ---
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> index dfb0658713d9..d2219885071f 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> @@ -1661,7 +1661,7 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
>>                                          pfirst->len, pfirst->next,
>>                                          pfirst->prev);
>>                       skb_unlink(pfirst, &bus->glom);
>> -                     if (brcmf_sdio_fromevntchan(pfirst->data))
>> +                     if (brcmf_sdio_fromevntchan(&dptr[SDPCM_HWHDR_LEN]))
>>                               brcmf_rx_event(bus->sdiodev->dev, pfirst);
>>                       else
>>                               brcmf_rx_frame(bus->sdiodev->dev, pfirst,
>>
