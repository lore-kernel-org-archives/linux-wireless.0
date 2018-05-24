Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35653 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751385AbeEXF2m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 01:28:42 -0400
Received: by mail-wm0-f66.google.com with SMTP id o78-v6so1525414wmg.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2018 22:28:41 -0700 (PDT)
Subject: Re: [PATCH 1/3] brcmfmac: allow specifying features per firmware
 version
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20180522131836.26858-1-zajec5@gmail.com>
 <5B051F2A.9090501@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <f79ad17d-5d7f-ceac-19e6-2e55d9bb20bf@gmail.com> (sfid-20180524_072852_807676_F124A80C)
Date: Thu, 24 May 2018 07:27:07 +0200
MIME-Version: 1.0
In-Reply-To: <5B051F2A.9090501@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23.05.2018 09:58, Arend van Spriel wrote:
> On 5/22/2018 3:18 PM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> Some features supported by firmware aren't advertised and there is no
>> way for a driver to query them. This includes e.g. monitor mode details.
>> Some firmwares support tagging monitor frames, some build radiotap
>> header but there is no way to detect it.
>>
>> This commit adds table that will allow specifying features like:
>> { "01-abcdef01", BIT(BRCMF_FEAT_FOO) }
> 
> I have my reservations taking this route. Full-dongle monitor mode is not very reliable especially when running it next to regular STA/AP interface due to memory constraints. So enabling a feature from host side could cause issues that are hard to debug.

I was using this *really* intensively on BCM4366 and didn't notice any
problems. My use case is listening to the air traffic for 300 ms every
few seconds (and I got that running for months!).


 > So I think it would be better if the cap iovar would get a new flag for this. Please hold this patch and let me discuss internally.

That would be a pretty big limitation to have to wait for and use a
special firmware for this feature. Also considering time it takes to
release brcmfmac4366c-pcie.bin, Broadcom vs. Cypress, licensing issues
with Cypress, we will likely never get all firmwares updated properly.

As for me (!) it seems rather unacceptable (no offence!). I believe we
should have a free choice to use that discovered feature even if
Broadcom didn't test it for host machine purposes (just internal fw
purposes as I get it).


> some more specific comments below...
> 
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>>   .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 24 ++++++++++++++++++++++
>>   1 file changed, 24 insertions(+)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> index 876731c57bf5..1194d31d3902 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> @@ -91,6 +91,28 @@ static int brcmf_feat_debugfs_read(struct seq_file *seq, void *data)
>>   }
>>   #endif /* DEBUG */
>>
>> +struct brcmf_feat_fwfeat {
>> +    const char * const fwid;
>> +    u32 flags;
> 
> For consistency call this feat_flags as well.

Sure.


>> +};
>> +
>> +static const struct brcmf_feat_fwfeat brcmf_feat_fwfeat_map[] = {
>> +};
>> +
>> +static void brcmf_feat_firmware_features(struct brcmf_pub *pub)
> 
> Try to keep name of the struct brcmf_pub instance 'drvr'.

Wait, doesn't "pub" make more sense for "struct brcmf_pub" than "drvr"?
:) I'm sure I also saw "pub" variables all over the code, so this isn't
some new/mine convention.


 > Maybe the function name could be brcmf_feat_firmware_overrides() instead.

Sure!
