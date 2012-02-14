Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47701 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab2BNSdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 13:33:44 -0500
Message-ID: <4F3AA8F6.6090602@hauke-m.de> (sfid-20120214_193350_428650_C23C6A08)
Date: Tue, 14 Feb 2012 19:33:26 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "Saul St. John" <saul.stjohn@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] use alternate SPROM offset for 43224
References: <20120214040120.GA2077@eris.garyseven.net> <CACna6rwXEjsJEPK4EZ9pbh2sGJgvt05JRfo2HkeDKpT26YORwg@mail.gmail.com> <CAG=dh1pTDSkkhgXGOv=n8uferq61-Db0EFGexO=ZZ+oN6w8_hQ@mail.gmail.com> <CACna6rw=ZJe28ahRQFU-_9+BD8+L5SNV_xdwxLxUdNk-b3HHxg@mail.gmail.com>
In-Reply-To: <CACna6rw=ZJe28ahRQFU-_9+BD8+L5SNV_xdwxLxUdNk-b3HHxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2012 06:29 PM, Rafał Miłecki wrote:
> W dniu 14 lutego 2012 17:22 użytkownik Saul St. John
> <saul.stjohn@gmail.com> napisał:
>> On Tue, Feb 14, 2012 at 7:34 AM, Rafał Miłecki <zajec5@gmail.com> wrote:
>>> W dniu 14 lutego 2012 05:01 użytkownik Saul St. John
>>> <saul.stjohn@gmail.com> napisał:
>>>> I don't know if this is correct in the general sense, but the wireless on my
>>>> mid-2010 MacBook Pro doesn't work without it.
>>>>
>>>> Signed-off-by: Saul St. John <saul.stjohn@gmail.com>
>>>> ---
>>>>  drivers/bcma/sprom.c |    4 ++--
>>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
>>>> index 6f230fb..06c87b5 100644
>>>> --- a/drivers/bcma/sprom.c
>>>> +++ b/drivers/bcma/sprom.c
>>>> @@ -228,8 +228,8 @@ int bcma_sprom_get(struct bcma_bus *bus)
>>>>        /* Most cards have SPROM moved by additional offset 0x30 (48 dwords).
>>>>         * According to brcm80211 this applies to cards with PCIe rev >= 6
>>>>         * TODO: understand this condition and use it */
>>>> -       offset = (bus->chipinfo.id == 0x4331) ? BCMA_CC_SPROM :
>>>> -               BCMA_CC_SPROM_PCIE6;
>>>> +       offset = (bus->chipinfo.id == 0x4331 || bus->chipinfo.id == 43224) ?
>>>> +                       BCMA_CC_SPROM : BCMA_CC_SPROM_PCIE6;
>>>>        bcma_sprom_read(bus, offset, sprom);
>>>>
>>>>        if (bus->chipinfo.id == 0x4331)
>>>
>>> I'm quite sure it'll break my BCM43224. It's not chip-specific,
>>> probably some status bit specific.
>>>
>>> --
>>> Rafał
>>
>> My BCM43324 was broken by bmca up until "[PATCH] bcma: don't fail for
>> bad SPROM CRC." Even with that patch, I still get "bmca: Failed to get
>> SPROM: -71" in the dmesg log. Is that error harmless?
> 
> It's harmless for brcmsmac, which doesn't use SPROM struct of bcma bus
> driver. This bug should be fixed and brcmsmac should be improved in
> many contexts: using SPROM, standard bcma module functions, dropping
> other cores initializing. For now you can live with this.
> 
> 
>> The CRC check appears to pass without issue when using the 0x800
>> offset on my device.
> 
> The quick fix would be probably to implement in bcma two tries of
> reading SPROM. One for 0x800 second for 0x830 (base address). The real
> fix is to grab the real condition from specs/brcmsmac and implement it
> in bcma.
> 
Hi,

I am unable to find the 0x830 address in brcmsmac or any other source
code from Broadcom.

This is the place where brcmsmac gets the offset:

/* determine core to read */
if (ai_get_ccrev(sih) < 32) {
	core = ai_findcore(sih, BCMA_CORE_80211, 0);
	sprom_offset = PCI_BAR0_SPROM_OFFSET; // (4 * 1024)
} else {
	core = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
	sprom_offset = CHIPCREGOFFS(sromotp); // 0x800
}

What chipcommon rev does the device have?
This device is probably using the otp instead of a sprom and that is not
implemented in bcma.

The thing with the pcie core rev >= 6, is about sprom rev >= 4 being
bigger than the old ones which is fully implemented in bcma.

Hauke
