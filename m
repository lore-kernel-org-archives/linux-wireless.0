Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:49182 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbaIAU6G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 16:58:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Gorski <jogo@openwrt.org>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
Date: Mon, 01 Sep 2014 22:57:46 +0200
Message-ID: <7233866.BdZFBc3HWf@wuerfel> (sfid-20140901_225830_902497_AC2B3E05)
In-Reply-To: <CAOiHx==sRquiqrQW6T0S+UsOz5H8V1Wt7x1RD=SVo6=gu7M1Vg@mail.gmail.com>
References: <CACna6rzRf7qf0YAFWqp4VgwR76-N8HO12eSz_H5NW9LpjBArdw@mail.gmail.com> <4072992.6HB7sP7z87@wuerfel> <CAOiHx==sRquiqrQW6T0S+UsOz5H8V1Wt7x1RD=SVo6=gu7M1Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 01 September 2014 22:45:25 Jonas Gorski wrote:
> On Mon, Sep 1, 2014 at 4:57 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 01 September 2014 09:48:48 Rafał Miłecki wrote:
> >> On 31 August 2014 11:20, Rafał Miłecki <zajec5@gmail.com> wrote:
> >> So I think we'll need to change our vision of flash access in
> >> bcm74xx_nvram driver. I guess we will have to:
> >> 1) Register NAND core early
> >> 2) Initialize NAND driver
> >> 3) Use mtd/nand API in bcm47xx_nvram
> >
> > This would mean it's available really late. Is that a problem?
> 
> That's probably mostly fine (for MIPS), except for two places:
> a) the kernel command line is stored in nvram, and used for finding
> out the correct console tty.

Is this also the case on ARM? According to the documented boot protocol,
ARM systems are supposed to pass the command line either through the
ATAGS interface or through a DT, and we have code to move it from
the former into the latter one. Of course it wouldn't be the first
system that ignores the boot protocol, but it has fortunately become
rather rare these days.

> b) on one specific chip, the configured system clock rate needs to be
> read out from nvram.
> 
> Both can be also done through DT, but b) is somewhat important to do
> right, as it will cause the time running fast/slow if the value is
> wrong.

Can you have two systems that can use the same DTB with the exception
of the clock rate? This sounds no different than on any other system
that has a variable clock input.

	Arnd
