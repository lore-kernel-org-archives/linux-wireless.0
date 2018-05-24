Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 1.mo68.mail-out.ovh.net ([46.105.41.146]:53509 "EHLO
        1.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965787AbeEXJkz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 05:40:55 -0400
Received: from player774.ha.ovh.net (unknown [10.109.122.56])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id 4E244E176F
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2018 10:21:39 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 24 May 2018 10:21:25 +0200
From: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH 1/3] brcmfmac: allow specifying features per firmware
 version
In-Reply-To: <5B066F28.5070706@broadcom.com>
References: <20180522131836.26858-1-zajec5@gmail.com>
 <5B051F2A.9090501@broadcom.com>
 <f79ad17d-5d7f-ceac-19e6-2e55d9bb20bf@gmail.com>
 <5B066F28.5070706@broadcom.com>
Message-ID: <cacf02df5ce961891e33344ab14a4629@milecki.pl> (sfid-20180524_142443_426523_9ADFA569)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-24 09:52, Arend van Spriel wrote:
> On 5/24/2018 7:27 AM, Rafał Miłecki wrote:
>> On 23.05.2018 09:58, Arend van Spriel wrote:
>>> On 5/22/2018 3:18 PM, Rafał Miłecki wrote:
>>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>> 
>>>> Some features supported by firmware aren't advertised and there is 
>>>> no
>>>> way for a driver to query them. This includes e.g. monitor mode 
>>>> details.
>>>> Some firmwares support tagging monitor frames, some build radiotap
>>>> header but there is no way to detect it.
>>>> 
>>>> This commit adds table that will allow specifying features like:
>>>> { "01-abcdef01", BIT(BRCMF_FEAT_FOO) }
>>> 
>>> I have my reservations taking this route. Full-dongle monitor mode is
>>> not very reliable especially when running it next to regular STA/AP
>>> interface due to memory constraints. So enabling a feature from host
>>> side could cause issues that are hard to debug.
>> 
>> I was using this *really* intensively on BCM4366 and didn't notice any
>> problems. My use case is listening to the air traffic for 300 ms every
>> few seconds (and I got that running for months!).
> 
> I understand. I am just saying that we have quite a variety of devices
> that we support with brcmfmac and this allows enabling features from
> the host driver. So any patch adding an entry will need to be reviewed
> with more scrutiny.

Sounds OK to me!


>>  > So I think it would be better if the cap iovar would get a new flag
>> for this. Please hold this patch and let me discuss internally.
>> 
>> That would be a pretty big limitation to have to wait for and use a
>> special firmware for this feature. Also considering time it takes to
>> release brcmfmac4366c-pcie.bin, Broadcom vs. Cypress, licensing issues
>> with Cypress, we will likely never get all firmwares updated properly.
>> 
>> As for me (!) it seems rather unacceptable (no offence!). I believe we
>> should have a free choice to use that discovered feature even if
>> Broadcom didn't test it for host machine purposes (just internal fw
>> purposes as I get it).
> 
> Not sure if "unacceptable" is the right word here. Having it
> discoverable from the firmware itself seems preferred to me
> regardless. For the 4366 firmware you are right it is taking a lot of
> time. It has passed verification. It needed to pass sensitive topic of
> radar detection for FCC and ETSI. So I am preparing that release.

OT: is your brcmfmac4366c-pcie.bin going to include BCM4366E support?


> So I
> just have to discuss this monitor feature tomorrow. That is not too
> long, is it?

Sure thing, let us know when you know some details :)


>>> some more specific comments below...
>>> 
>>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>>> ---
>>>>   .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 24
>>>> ++++++++++++++++++++++
>>>>   1 file changed, 24 insertions(+)
>>>> 
>>>> diff --git
>>>> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>>>> index 876731c57bf5..1194d31d3902 100644
>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>>>> @@ -91,6 +91,28 @@ static int brcmf_feat_debugfs_read(struct 
>>>> seq_file
>>>> *seq, void *data)
>>>>   }
>>>>   #endif /* DEBUG */
>>>> 
>>>> +struct brcmf_feat_fwfeat {
>>>> +    const char * const fwid;
>>>> +    u32 flags;
>>> 
>>> For consistency call this feat_flags as well.
>> 
>> Sure.
>> 
>> 
>>>> +};
>>>> +
>>>> +static const struct brcmf_feat_fwfeat brcmf_feat_fwfeat_map[] = {
>>>> +};
>>>> +
>>>> +static void brcmf_feat_firmware_features(struct brcmf_pub *pub)
>>> 
>>> Try to keep name of the struct brcmf_pub instance 'drvr'.
>> 
>> Wait, doesn't "pub" make more sense for "struct brcmf_pub" than 
>> "drvr"?
>> :) I'm sure I also saw "pub" variables all over the code, so this 
>> isn't
>> some new/mine convention.
> 
> We used to have a private and public structure long ago and we
> collapsed it into brcmf_pub. So not all places changed the variable to
> 'drvr' and I do not care that much for existing stuff. Could put the
> rename task on TODO list on wireless wiki, but not sure if newbies
> would look there. For new stuff let's try to stick with 'drvr'.
