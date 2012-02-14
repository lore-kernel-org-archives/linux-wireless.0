Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38679 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab2BNUK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 15:10:28 -0500
Received: by yenm8 with SMTP id m8so279617yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 12:10:27 -0800 (PST)
Message-ID: <4F3ABFB0.3020502@lwfinger.net> (sfid-20120214_211032_744426_A0271733)
Date: Tue, 14 Feb 2012 14:10:24 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Saul St. John" <saul.stjohn@gmail.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] use alternate SPROM offset for 43224
References: <20120214040120.GA2077@eris.garyseven.net> <CACna6rwXEjsJEPK4EZ9pbh2sGJgvt05JRfo2HkeDKpT26YORwg@mail.gmail.com> <CAG=dh1pTDSkkhgXGOv=n8uferq61-Db0EFGexO=ZZ+oN6w8_hQ@mail.gmail.com> <CACna6rw=ZJe28ahRQFU-_9+BD8+L5SNV_xdwxLxUdNk-b3HHxg@mail.gmail.com> <20120214185202.GA5339@eris.garyseven.net>
In-Reply-To: <20120214185202.GA5339@eris.garyseven.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2012 12:52 PM, Saul St. John wrote:
> On Tue, Feb 14, 2012 at 06:29:59PM +0100, Rafał Miłecki wrote:
>> W dniu 14 lutego 2012 17:22 użytkownik Saul St. John
>> <saul.stjohn@gmail.com>  napisał:
>>> On Tue, Feb 14, 2012 at 7:34 AM, Rafał Miłecki<zajec5@gmail.com>  wrote:
>>>> W dniu 14 lutego 2012 05:01 użytkownik Saul St. John
>>>> <saul.stjohn@gmail.com>  napisał:
>>>>> I don't know if this is correct in the general sense, but the wireless on my
>>>>> mid-2010 MacBook Pro doesn't work without it.
>>>>>
>>>>> Signed-off-by: Saul St. John<saul.stjohn@gmail.com>
>>>>> ---
>>>>>   drivers/bcma/sprom.c |    4 ++--
>>>>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
>>>>> index 6f230fb..06c87b5 100644
>>>>> --- a/drivers/bcma/sprom.c
>>>>> +++ b/drivers/bcma/sprom.c
>>>>> @@ -228,8 +228,8 @@ int bcma_sprom_get(struct bcma_bus *bus)
>>>>>         /* Most cards have SPROM moved by additional offset 0x30 (48 dwords).
>>>>>          * According to brcm80211 this applies to cards with PCIe rev>= 6
>>>>>          * TODO: understand this condition and use it */
>>>>> -       offset = (bus->chipinfo.id == 0x4331) ? BCMA_CC_SPROM :
>>>>> -               BCMA_CC_SPROM_PCIE6;
>>>>> +       offset = (bus->chipinfo.id == 0x4331 || bus->chipinfo.id == 43224) ?
>>>>> +                       BCMA_CC_SPROM : BCMA_CC_SPROM_PCIE6;
>>>>>         bcma_sprom_read(bus, offset, sprom);
>>>>>
>>>>>         if (bus->chipinfo.id == 0x4331)
>>>>
>>>> I'm quite sure it'll break my BCM43224. It's not chip-specific,
>>>> probably some status bit specific.
>>>>
>>>> --
>>>> Rafał
>>>
>>> My BCM43324 was broken by bmca up until "[PATCH] bcma: don't fail for
>>> bad SPROM CRC." Even with that patch, I still get "bmca: Failed to get
>>> SPROM: -71" in the dmesg log. Is that error harmless?
>>
>> It's harmless for brcmsmac, which doesn't use SPROM struct of bcma bus
>> driver. This bug should be fixed and brcmsmac should be improved in
>> many contexts: using SPROM, standard bcma module functions, dropping
>> other cores initializing. For now you can live with this.
>>
> My worry is that, were the brcmsmac driver to be improved in the ways you
> suggest, the BCM43224 in my MBP would start failing again.
>>
>>> The CRC check appears to pass without issue when using the 0x800
>>> offset on my device.
>>
>> The quick fix would be probably to implement in bcma two tries of
>> reading SPROM. One for 0x800 second for 0x830 (base address). The real
>> fix is to grab the real condition from specs/brcmsmac and implement it
>> in bcma.
>>
> Real fix: any leads on where the real condition can be found? I looked through
> the brcmsmac driver, but it wasn't obvious to me.
>
> Quick fix: something like this?
>
> Signed-off-by: Saul St. John<saul.stjohn@gmail.com>
> ---
>   drivers/bcma/sprom.c |   24 ++++++++++++++----------
>   1 files changed, 14 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
> index 6f230fb..e99807e 100644
> --- a/drivers/bcma/sprom.c
> +++ b/drivers/bcma/sprom.c
> @@ -207,7 +207,7 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
>
>   int bcma_sprom_get(struct bcma_bus *bus)
>   {
> -	u16 offset;
> +	u16 offset = 0;
>   	u16 *sprom;
>   	int err = 0;
>
> @@ -222,20 +222,24 @@ int bcma_sprom_get(struct bcma_bus *bus)
>   	if (!sprom)
>   		return -ENOMEM;
>
> -	if (bus->chipinfo.id == 0x4331)
> -		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, false);
> -
>   	/* Most cards have SPROM moved by additional offset 0x30 (48 dwords).
>   	 * According to brcm80211 this applies to cards with PCIe rev>= 6
>   	 * TODO: understand this condition and use it */
> -	offset = (bus->chipinfo.id == 0x4331) ? BCMA_CC_SPROM :
> -		BCMA_CC_SPROM_PCIE6;
> -	bcma_sprom_read(bus, offset, sprom);
> +	do {
> +		if (bus->chipinfo.id == 0x4331)
> +			bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc,
> +							     false);
> +
> +		offset = (offset == 0) ? BCMA_CC_SPROM : BCMA_CC_SPROM_PCIE6;
> +		bcma_sprom_read(bus, offset, sprom);
> +
> +		if (bus->chipinfo.id == 0x4331)
> +			bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc,
> +							     true);
>
> -	if (bus->chipinfo.id == 0x4331)
> -		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, true);
> +		err = bcma_sprom_valid(sprom);
> +	} while (err&&  (offset != BCMA_CC_SPROM_PCIE6));
>
> -	err = bcma_sprom_valid(sprom);
>   	if (err)
>   		goto out;
>

I think it is more complicated than the above. On my 43224, I get the message 
"No SPROM available", which arises because bcma_sprom_get() is returning 
-ENOENT. The reason is that the value tested in "if (!(sromctrl & 
BCMA_CC_SROM_CONTROL_PRESENT))" is zero. The contents of sromctl are 0x12, and 
the mask is 1.

I am still investigating. When I comment out the test of sromctl, then the 
driver seems to find the SPROM at offset 0x830, but neither b43 nor brcmsmac works.

Larry



//                      return -ENOENT;

