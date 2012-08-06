Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41414 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2HFGuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 02:50:37 -0400
Received: by weyx8 with SMTP id x8so1688054wey.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Aug 2012 23:50:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201208052240.21982.florian@openwrt.org>
References: <1344196987-32041-1-git-send-email-zajec5@gmail.com>
	<201208052240.21982.florian@openwrt.org>
Date: Mon, 6 Aug 2012 08:50:35 +0200
Message-ID: <CACna6rzFeX5rHVxZSpFVwL1psLBfuWK-X8_YAZdtLDFbNKjPPQ@mail.gmail.com> (sfid-20120806_085104_199004_5094CC03)
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

Thanks for looking at this!

2012/8/5 Florian Fainelli <florian@openwrt.org>:
> Le dimanche 05 août 2012 22:03:07, Rafał Miłecki a écrit :
>> This is basic driver for NAND flash memory that allows reading it's
>> content. It was succesfully tested on Netgear WNDR4500 which is BCM4706
>> based router.
>>
>> This driver has been written using specs at:
>> http://bcm-v4.sipsolutions.net/NAND_Flash
>
> The big problem that I see with your driver is that it does not interface with
> the MTD subsystem, and therefore:
>
> - does not conform to the MTD API for reading pages, blocks etc...

My idea for bcma responsibilities consists of:
1) Detecting hardware
2) Providing basic access to it
This is what (I believe) I provided with that submitted patch.

I'm not registering MTD driver directly in bcma, just like we don't
register ieee80211 device for 80211 core or netdev for ETH core.

After providing basic/low-level access in bcma my plan is to write
real MTD driver. In this driver I could make use of functions from
bcma_chipcommon_nflash.[ch].

Does it sound better now?


> - duplicates NAND flash detection in a manner which is far less robust than
> what the MTD NAND subsystem already does

Hm, do you mean there is some MTD driver detecting NAND flash on BCMA?
I wasn't aware of that. Grepping drivers/mtd for "bcma" didn't give me
anything. Can you say something more about this?


> I guess that this driver enables you do some stuff on your router, but clearly
> you should aim at writing a real MTD driver instead of having such an ad-hoc
> solution.

That "do some stuff" means almost nothing right now. My plan (as
explained earlier) is to write MTD driver.

-- 
Rafał
