Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:62816 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3ADHns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 02:43:48 -0500
Received: by mail-we0-f175.google.com with SMTP id z53so7786149wey.34
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jan 2013 23:43:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1357257085-11822-3-git-send-email-hauke@hauke-m.de>
References: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
	<1357257085-11822-3-git-send-email-hauke@hauke-m.de>
Date: Fri, 4 Jan 2013 08:43:46 +0100
Message-ID: <CACna6rwincxUDM9ev9_CwH-MByS_5tGyd7hpR+wgR6D-rNzgww@mail.gmail.com> (sfid-20130104_084352_816815_12F4B593)
Subject: Re: [PATCH 2/6] bcma: mips: explicit assign IRQ numbers
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nlhintz@hotmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/1/4 Hauke Mehrtens <hauke@hauke-m.de>:
> The assignment of the IRQs to the cores of the chips by iterating over
> the cores is complicated and causes problems with SoC like the BCM4706
> with two GMAC core where just one should get a dedicated IRQ number.

Well, the only problem on BCM4706 is that second (broken/dangling)
GMAC core gets it's own IRQ. With such a "waste" of one IRQ line we
may end up using shared IRQ for some other core like PCIE/USB.
This issue can be simply workarounded (with 2 LOC) and sounds sane:
bug in HW, specific workaround in a driver. We already have similar
workarounds for other "dangling" cores.

I don't know about any other issues with BCM4706 IRQs.

Are there any other (more serious?) issues on different SoCs? Any
advantages of hardcoding IRQs (per chipset) rather than keeping this
simple algorithm? Do the IRQ lines differ? Is this somehow better to
use (just an example) IRQ 3 instead of IRQ 4 for GMAC core?

-- 
Rafał
