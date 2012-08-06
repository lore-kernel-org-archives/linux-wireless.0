Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59630 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab2HFMIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 08:08:54 -0400
Received: by wgbfm10 with SMTP id fm10so1386020wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 05:08:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1673359.JloXiOZbAj@flexo>
References: <1344196987-32041-1-git-send-email-zajec5@gmail.com>
	<201208052240.21982.florian@openwrt.org>
	<CACna6rzFeX5rHVxZSpFVwL1psLBfuWK-X8_YAZdtLDFbNKjPPQ@mail.gmail.com>
	<1673359.JloXiOZbAj@flexo>
Date: Mon, 6 Aug 2012 14:08:52 +0200
Message-ID: <CACna6rxFKWwjELcTO4kTNt=iEAsVmVTAW2fZ-JNRAL990sHGkw@mail.gmail.com> (sfid-20120806_140859_219032_4B63F5DF)
Subject: Re: [PATCH V2] bcma: add basic NAND flash driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/8/6 Florian Fainelli <florian@openwrt.org>:
> On Monday 06 August 2012 08:50:35 Rafał Miłecki wrote:
>> Thanks for looking at this!
>>
>> 2012/8/5 Florian Fainelli <florian@openwrt.org>:
>> > Le dimanche 05 août 2012 22:03:07, Rafał Miłecki a écrit :
>> >> This is basic driver for NAND flash memory that allows reading it's
>> >> content. It was succesfully tested on Netgear WNDR4500 which is BCM4706
>> >> based router.
>> >>
>> >> This driver has been written using specs at:
>> >> http://bcm-v4.sipsolutions.net/NAND_Flash
>> >
>> > The big problem that I see with your driver is that it does not interface
> with
>> > the MTD subsystem, and therefore:
>> >
>> > - does not conform to the MTD API for reading pages, blocks etc...
>>
>> My idea for bcma responsibilities consists of:
>> 1) Detecting hardware
>> 2) Providing basic access to it
>> This is what (I believe) I provided with that submitted patch.
>>
>> I'm not registering MTD driver directly in bcma, just like we don't
>> register ieee80211 device for 80211 core or netdev for ETH core.
>>
>> After providing basic/low-level access in bcma my plan is to write
>> real MTD driver. In this driver I could make use of functions from
>> bcma_chipcommon_nflash.[ch].
>>
>> Does it sound better now?
>
> A little, but I still wonder why this would be needed at all, unless you
> cannot rely on MTD because you are doing stuff very early with the Flash.
> I find perfectly legitimate to export some bcma-specific symbols for accessing
> the NAND flash controller, but am a little more dubious about duplicating the
> reading/detection.

I've tested nand_scan_ident and it seems to be working for NAND flash
in my BCM4706. I'm pretty sure we can use it for MTD driver without
re-implementing all that detecting stuff.

Unfortunately I'm not sure what to do about early init. Do you know if
we may need NAND flash access during early init? Is reading nvram
during early init important? I guess devices with nvram placed on NAND
flash will become common sooner or later.

If we want to read nvram during early init, we may not be able to rely
on MTD driver. Oh and it would cause additional problems like lacking
kzalloc and maybe lacking sleep on some devices. Should we call
nand_scan_ident from bcma then? I'm not sure if I like this idea.

Any comments/ideas? Hauke?


>> > - duplicates NAND flash detection in a manner which is far less robust than
>> > what the MTD NAND subsystem already does
>>
>> Hm, do you mean there is some MTD driver detecting NAND flash on BCMA?
>> I wasn't aware of that. Grepping drivers/mtd for "bcma" didn't give me
>> anything. Can you say something more about this?
>
> No I meant that all the ID code decoding to determine the chip size,
> manufacturer etc ... is already well handled within MTD.

Yeah, it detected my flash more or less correctly:

NAND device: Manufacturer ID: 0xec, Chip ID: 0xf1 (Samsung NAND 128MiB
3,3V 8-bit), page size: 2048, OOB size: 64


>> > I guess that this driver enables you do some stuff on your router, but
> clearly
>> > you should aim at writing a real MTD driver instead of having such an ad-
> hoc
>> > solution.
>>
>> That "do some stuff" means almost nothing right now. My plan (as
>> explained earlier) is to write MTD driver.
>
> Ok, well maybe I should just let you write your MTD driver and we see how that
> interfaces with this current patch.

-- 
Rafał
