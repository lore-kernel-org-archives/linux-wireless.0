Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:61863 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbZKHTHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 14:07:12 -0500
Received: by ewy3 with SMTP id 3so2530622ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 11:07:16 -0800 (PST)
Message-ID: <4AF716E2.3030608@gmail.com>
Date: Sun, 08 Nov 2009 20:07:14 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/9] rt2800: prepare for unification of EEPROM support
 code
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain> <4AF6D2A0.50204@gmail.com> <200911081841.20717.bzolnier@gmail.com>
In-Reply-To: <200911081841.20717.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/09 18:41, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 08 November 2009 15:16:00 Gertjan van Wingerde wrote:
>> On 11/08/09 14:38, Bartlomiej Zolnierkiewicz wrote:
>>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> Subject: [PATCH] rt2800: prepare for unification of EEPROM support code
>>>
>>> * Factor out common code from rt2800[pci,usb]_validate_eeprom()
>>>   to rt2800_validate_eeprom().
>>>
>>> * Fix interface specific comment in rt2800[pci,usb]_validate_eeprom().
>>>
>>> * Enclose interface specific code in rt2800[pci,usb]_init_eeprom()
>>>   with rt2x00_intf_is_[pci,usb]() checks.
>>>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> ---
>>> on top of "rt2x00: Add dynamic detection of eFuse EEPROM in rt2800pci."
>>> patch from Gertjan
>>>
>>>  drivers/net/wireless/rt2x00/rt2800pci.c |   51 ++++++++++++++++++--------------
>>>  drivers/net/wireless/rt2x00/rt2800usb.c |   40 +++++++++++++++----------
>>>  2 files changed, 55 insertions(+), 36 deletions(-)
>>>
>>
>> <snip>
>>
>>> @@ -1234,8 +1241,10 @@ static int rt2800pci_init_eeprom(struct 
>>>  	    !rt2x00_rf(&rt2x00dev->chip, RF2750) &&
>>>  	    !rt2x00_rf(&rt2x00dev->chip, RF3020) &&
>>>  	    !rt2x00_rf(&rt2x00dev->chip, RF2020) &&
>>> -	    !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
>>> -	    !rt2x00_rf(&rt2x00dev->chip, RF3022)) {
>>> +	    (rt2x00_intf_is_usb(rt2x00dev) ||
>>> +	     (rt2x00_intf_is_pci(rt2x00dev) &&
>>> +	      !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
>>> +	      !rt2x00_rf(&rt2x00dev->chip, RF3022)))) {
>>>  		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
>>>  		return -ENODEV;
>>>  	}
>>
>> Can we leave this as-is. There are rt2800usb devices that support these RF chipsets as well (I am now the proud owner of such a device), so there is no
>> need to restrict the use of these RF chipsets to just PCI devices.
> 
> Please note that the patch doesn't change the current behavior of rt2800usb
> and for bisectability reasons I would strongly prefer for it to stay this way.
> 
>> So, if we leave this as-is then the EEPROM unification ensures rt2800usb will "support" these RF chipsets as well.
> 
> Lets work in incremental fashion -- when there is a need to do such change
> lets just do it against current tree and apply it as soon as possible (this
> way we won't be spending time on micro-decisions).
> 
> IOW just make a post- (or pre-) patch and I'll deal with it.
> 
> Thanks.

Yeah, while spending more time on this this afternoon I found out that actually a lot more is needed, so doing this right now doesn't help at all.
So, on second thought,

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

---
Gertjan.
