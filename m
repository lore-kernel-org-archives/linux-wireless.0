Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65217 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2BNRaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 12:30:00 -0500
Received: by wgbdt10 with SMTP id dt10so159479wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 09:29:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG=dh1pTDSkkhgXGOv=n8uferq61-Db0EFGexO=ZZ+oN6w8_hQ@mail.gmail.com>
References: <20120214040120.GA2077@eris.garyseven.net>
	<CACna6rwXEjsJEPK4EZ9pbh2sGJgvt05JRfo2HkeDKpT26YORwg@mail.gmail.com>
	<CAG=dh1pTDSkkhgXGOv=n8uferq61-Db0EFGexO=ZZ+oN6w8_hQ@mail.gmail.com>
Date: Tue, 14 Feb 2012 18:29:59 +0100
Message-ID: <CACna6rw=ZJe28ahRQFU-_9+BD8+L5SNV_xdwxLxUdNk-b3HHxg@mail.gmail.com> (sfid-20120214_183005_150239_B7B08BC5)
Subject: Re: [RFC] use alternate SPROM offset for 43224
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Saul St. John" <saul.stjohn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 14 lutego 2012 17:22 użytkownik Saul St. John
<saul.stjohn@gmail.com> napisał:
> On Tue, Feb 14, 2012 at 7:34 AM, Rafał Miłecki <zajec5@gmail.com> wrote:
>> W dniu 14 lutego 2012 05:01 użytkownik Saul St. John
>> <saul.stjohn@gmail.com> napisał:
>>> I don't know if this is correct in the general sense, but the wireless on my
>>> mid-2010 MacBook Pro doesn't work without it.
>>>
>>> Signed-off-by: Saul St. John <saul.stjohn@gmail.com>
>>> ---
>>>  drivers/bcma/sprom.c |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
>>> index 6f230fb..06c87b5 100644
>>> --- a/drivers/bcma/sprom.c
>>> +++ b/drivers/bcma/sprom.c
>>> @@ -228,8 +228,8 @@ int bcma_sprom_get(struct bcma_bus *bus)
>>>        /* Most cards have SPROM moved by additional offset 0x30 (48 dwords).
>>>         * According to brcm80211 this applies to cards with PCIe rev >= 6
>>>         * TODO: understand this condition and use it */
>>> -       offset = (bus->chipinfo.id == 0x4331) ? BCMA_CC_SPROM :
>>> -               BCMA_CC_SPROM_PCIE6;
>>> +       offset = (bus->chipinfo.id == 0x4331 || bus->chipinfo.id == 43224) ?
>>> +                       BCMA_CC_SPROM : BCMA_CC_SPROM_PCIE6;
>>>        bcma_sprom_read(bus, offset, sprom);
>>>
>>>        if (bus->chipinfo.id == 0x4331)
>>
>> I'm quite sure it'll break my BCM43224. It's not chip-specific,
>> probably some status bit specific.
>>
>> --
>> Rafał
>
> My BCM43324 was broken by bmca up until "[PATCH] bcma: don't fail for
> bad SPROM CRC." Even with that patch, I still get "bmca: Failed to get
> SPROM: -71" in the dmesg log. Is that error harmless?

It's harmless for brcmsmac, which doesn't use SPROM struct of bcma bus
driver. This bug should be fixed and brcmsmac should be improved in
many contexts: using SPROM, standard bcma module functions, dropping
other cores initializing. For now you can live with this.


> The CRC check appears to pass without issue when using the 0x800
> offset on my device.

The quick fix would be probably to implement in bcma two tries of
reading SPROM. One for 0x800 second for 0x830 (base address). The real
fix is to grab the real condition from specs/brcmsmac and implement it
in bcma.

-- 
Rafał
