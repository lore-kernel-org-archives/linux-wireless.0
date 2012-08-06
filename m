Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50165 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab2HFIuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 04:50:21 -0400
Received: by eeil10 with SMTP id l10so737589eei.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 01:50:20 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH V2] bcma: add basic NAND flash driver
Date: Mon, 06 Aug 2012 10:50:15 +0200
Message-ID: <1673359.JloXiOZbAj@flexo> (sfid-20120806_105026_077270_B44DFEA7)
In-Reply-To: <CACna6rzFeX5rHVxZSpFVwL1psLBfuWK-X8_YAZdtLDFbNKjPPQ@mail.gmail.com>
References: <1344196987-32041-1-git-send-email-zajec5@gmail.com> <201208052240.21982.florian@openwrt.org> <CACna6rzFeX5rHVxZSpFVwL1psLBfuWK-X8_YAZdtLDFbNKjPPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Rafal,

On Monday 06 August 2012 08:50:35 Rafał Miłecki wrote:
> Thanks for looking at this!
> 
> 2012/8/5 Florian Fainelli <florian@openwrt.org>:
> > Le dimanche 05 août 2012 22:03:07, Rafał Miłecki a écrit :
> >> This is basic driver for NAND flash memory that allows reading it's
> >> content. It was succesfully tested on Netgear WNDR4500 which is BCM4706
> >> based router.
> >>
> >> This driver has been written using specs at:
> >> http://bcm-v4.sipsolutions.net/NAND_Flash
> >
> > The big problem that I see with your driver is that it does not interface 
with
> > the MTD subsystem, and therefore:
> >
> > - does not conform to the MTD API for reading pages, blocks etc...
> 
> My idea for bcma responsibilities consists of:
> 1) Detecting hardware
> 2) Providing basic access to it
> This is what (I believe) I provided with that submitted patch.
> 
> I'm not registering MTD driver directly in bcma, just like we don't
> register ieee80211 device for 80211 core or netdev for ETH core.
> 
> After providing basic/low-level access in bcma my plan is to write
> real MTD driver. In this driver I could make use of functions from
> bcma_chipcommon_nflash.[ch].
> 
> Does it sound better now?

A little, but I still wonder why this would be needed at all, unless you 
cannot rely on MTD because you are doing stuff very early with the Flash.
I find perfectly legitimate to export some bcma-specific symbols for accessing 
the NAND flash controller, but am a little more dubious about duplicating the 
reading/detection.

> 
> 
> > - duplicates NAND flash detection in a manner which is far less robust than
> > what the MTD NAND subsystem already does
> 
> Hm, do you mean there is some MTD driver detecting NAND flash on BCMA?
> I wasn't aware of that. Grepping drivers/mtd for "bcma" didn't give me
> anything. Can you say something more about this?

No I meant that all the ID code decoding to determine the chip size, 
manufacturer etc ... is already well handled within MTD.

> 
> 
> > I guess that this driver enables you do some stuff on your router, but 
clearly
> > you should aim at writing a real MTD driver instead of having such an ad-
hoc
> > solution.
> 
> That "do some stuff" means almost nothing right now. My plan (as
> explained earlier) is to write MTD driver.

Ok, well maybe I should just let you write your MTD driver and we see how that 
interfaces with this current patch.

> 
> -- 
> Rafał
