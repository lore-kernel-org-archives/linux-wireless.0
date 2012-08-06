Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59127 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756990Ab2HFX1K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 19:27:10 -0400
Message-ID: <502052C5.80308@hauke-m.de> (sfid-20120807_012737_882470_97FBC6AE)
Date: Tue, 07 Aug 2012 01:27:01 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Florian Fainelli <florian@openwrt.org>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] bcma: add basic NAND flash driver
References: <1344196987-32041-1-git-send-email-zajec5@gmail.com> <201208052240.21982.florian@openwrt.org> <CACna6rzFeX5rHVxZSpFVwL1psLBfuWK-X8_YAZdtLDFbNKjPPQ@mail.gmail.com> <1673359.JloXiOZbAj@flexo> <CACna6rxFKWwjELcTO4kTNt=iEAsVmVTAW2fZ-JNRAL990sHGkw@mail.gmail.com>
In-Reply-To: <CACna6rxFKWwjELcTO4kTNt=iEAsVmVTAW2fZ-JNRAL990sHGkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/06/2012 02:08 PM, Rafał Miłecki wrote:
> 2012/8/6 Florian Fainelli <florian@openwrt.org>:
>> On Monday 06 August 2012 08:50:35 Rafał Miłecki wrote:
>>> Thanks for looking at this!
>>>
>>> 2012/8/5 Florian Fainelli <florian@openwrt.org>:
>>>> Le dimanche 05 août 2012 22:03:07, Rafał Miłecki a écrit :
>>>>> This is basic driver for NAND flash memory that allows reading it's
>>>>> content. It was succesfully tested on Netgear WNDR4500 which is BCM4706
>>>>> based router.
>>>>>
>>>>> This driver has been written using specs at:
>>>>> http://bcm-v4.sipsolutions.net/NAND_Flash
>>>>
>>>> The big problem that I see with your driver is that it does not interface
>> with
>>>> the MTD subsystem, and therefore:
>>>>
>>>> - does not conform to the MTD API for reading pages, blocks etc...
>>>
>>> My idea for bcma responsibilities consists of:
>>> 1) Detecting hardware
>>> 2) Providing basic access to it
>>> This is what (I believe) I provided with that submitted patch.
>>>
>>> I'm not registering MTD driver directly in bcma, just like we don't
>>> register ieee80211 device for 80211 core or netdev for ETH core.
>>>
>>> After providing basic/low-level access in bcma my plan is to write
>>> real MTD driver. In this driver I could make use of functions from
>>> bcma_chipcommon_nflash.[ch].
>>>
>>> Does it sound better now?
>>
>> A little, but I still wonder why this would be needed at all, unless you
>> cannot rely on MTD because you are doing stuff very early with the Flash.
>> I find perfectly legitimate to export some bcma-specific symbols for accessing
>> the NAND flash controller, but am a little more dubious about duplicating the
>> reading/detection.
> 
> I've tested nand_scan_ident and it seems to be working for NAND flash
> in my BCM4706. I'm pretty sure we can use it for MTD driver without
> re-implementing all that detecting stuff.
> 
> Unfortunately I'm not sure what to do about early init. Do you know if
> we may need NAND flash access during early init? Is reading nvram
> during early init important? I guess devices with nvram placed on NAND
> flash will become common sooner or later.
> 
> If we want to read nvram during early init, we may not be able to rely
> on MTD driver. Oh and it would cause additional problems like lacking
> kzalloc and maybe lacking sleep on some devices. Should we call
> nand_scan_ident from bcma then? I'm not sure if I like this idea.
> 
> Any comments/ideas? Hauke?

We need access to the nvram to get the sprom and for a router model
detection to run some special cases for some devices. This router model
is currently needed for the flash partition parsing for serial and
parallel flash, as there is no partition table and the factory firmware
has the partition layout stored on the kernel image itself. In addition
we need the router module for the Ethernet drivers and some other driver
loaded later.

We can not use normal *alloc functions in early boot, like when the bcma
subsystem is first initiated, I do not know if sleep is not working but
udelay should still work at that time.

Just devices with chip common core rev 38 and not the BCM4706 are
supporting booting form nand flash according to the Broadcom Source
code. The code needed to implement nflash_checkbadb() to check if the
block is ok just for cc rev 38 is not big, we could duplicate it. The
code needed to detect the blocksize is bigger, but we could also use the
smallest block size possible (8K) and to more checks than necessary
(512) which is also not so many.

For code sharing we could also export the two needed functions from the
mtd driver and abuse them in the arch mode, if reading nvram from nand
flash is only possible when the mtd driver is also installed nobody will
care, but the code would not look nicely, but we should use the nand
flash functions the kernel already provides.

Does anybody have a bcm47xx device which boots from nand flash? The
WNR3500Lv2 is the only device with nand boot I know of.

I am for writing a mtd driver using the nand flash functions the kernel
provides and store all the code in drivers/mtd/ for that. The arch code
should then use two of these functions for nvram read if possible.

>>>> - duplicates NAND flash detection in a manner which is far less robust than
>>>> what the MTD NAND subsystem already does
>>>
>>> Hm, do you mean there is some MTD driver detecting NAND flash on BCMA?
>>> I wasn't aware of that. Grepping drivers/mtd for "bcma" didn't give me
>>> anything. Can you say something more about this?
>>
>> No I meant that all the ID code decoding to determine the chip size,
>> manufacturer etc ... is already well handled within MTD.
> 
> Yeah, it detected my flash more or less correctly:
> 
> NAND device: Manufacturer ID: 0xec, Chip ID: 0xf1 (Samsung NAND 128MiB
> 3,3V 8-bit), page size: 2048, OOB size: 64
> 
> 
>>>> I guess that this driver enables you do some stuff on your router, but
>> clearly
>>>> you should aim at writing a real MTD driver instead of having such an ad-
>> hoc
>>>> solution.
>>>
>>> That "do some stuff" means almost nothing right now. My plan (as
>>> explained earlier) is to write MTD driver.
>>
>> Ok, well maybe I should just let you write your MTD driver and we see how that
>> interfaces with this current patch.
> 

