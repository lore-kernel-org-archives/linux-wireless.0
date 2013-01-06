Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47340 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab3AFUfX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2013 15:35:23 -0500
Message-ID: <50E9E001.6060301@hauke-m.de> (sfid-20130106_213527_608300_C42DCE36)
Date: Sun, 06 Jan 2013 21:35:13 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nlhintz@hotmail.com
Subject: Re: [PATCH 2/6] bcma: mips: explicit assign IRQ numbers
References: <1357257085-11822-1-git-send-email-hauke@hauke-m.de> <1357257085-11822-3-git-send-email-hauke@hauke-m.de> <CACna6rwincxUDM9ev9_CwH-MByS_5tGyd7hpR+wgR6D-rNzgww@mail.gmail.com>
In-Reply-To: <CACna6rwincxUDM9ev9_CwH-MByS_5tGyd7hpR+wgR6D-rNzgww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/04/2013 08:43 AM, Rafał Miłecki wrote:
> 2013/1/4 Hauke Mehrtens <hauke@hauke-m.de>:
>> The assignment of the IRQs to the cores of the chips by iterating over
>> the cores is complicated and causes problems with SoC like the BCM4706
>> with two GMAC core where just one should get a dedicated IRQ number.
> 
> Well, the only problem on BCM4706 is that second (broken/dangling)
> GMAC core gets it's own IRQ. With such a "waste" of one IRQ line we
> may end up using shared IRQ for some other core like PCIE/USB.
> This issue can be simply workarounded (with 2 LOC) and sounds sane:
> bug in HW, specific workaround in a driver. We already have similar
> workarounds for other "dangling" cores.
> 
> I don't know about any other issues with BCM4706 IRQs.
> 
> Are there any other (more serious?) issues on different SoCs? Any
> advantages of hardcoding IRQs (per chipset) rather than keeping this
> simple algorithm? Do the IRQ lines differ? Is this somehow better to
> use (just an example) IRQ 3 instead of IRQ 4 for GMAC core?

Normally the boot loader (CFE) assigns IRQs to the cores on the bus. The
old code mostly worked because CFE did it correct most of the time.

On my bcm4718 the I2S core (id 0x834) does not get any IRQ from CFE, but
at least Nathan (nlhintz) wants to assign an IRQ (shared) to this core.

It is also possible to extend the algorithm to solve all these things,
but I think the new code is better to understand.

I do not think that there will be any new SoC using bcma and a mips cpu,
I haven't seen an announcement for such a SoC at the Broadcom web page,
just arm based devices, so I assume this list is complete.

Hauke
