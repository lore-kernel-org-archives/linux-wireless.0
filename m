Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:55531 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbbCIIuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 04:50:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 2/2] wl18xx: add basic device-tree support
Date: Mon, 09 Mar 2015 09:50:06 +0100
Message-ID: <2443534.iHU6YUeZ2u@wuerfel> (sfid-20150309_095057_055796_6F05B8E9)
In-Reply-To: <CAB3XZEczvZH8rYOD-P7iuU4RSurArpRp6JGYX1X22O8tj7v8Qg@mail.gmail.com>
References: <1424362401-8228-1-git-send-email-eliad@wizery.com> <2658240.aoSloEbWge@wuerfel> <CAB3XZEczvZH8rYOD-P7iuU4RSurArpRp6JGYX1X22O8tj7v8Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 09 March 2015 09:18:46 Eliad Peller wrote:
> On Sun, Mar 8, 2015 at 11:53 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Sunday 08 March 2015 13:13:13 Eliad Peller wrote:
> >>
> >> > I've looked up the what boards actually use this data and found that
> >> > all of them already support booting from DT: some omap2 boards using
> >> > arch/arm/mach-omap2/pdata-quirks.c to provide the data, and the
> >> > davinci 850evm. Can you make sure you add the correct data to all
> >> > of these dts files as part of your series and remove the
> >> > wl12xx_platform_data references?
> >>
> >> AFAICT, these board files add wl12xx platform data, while the new DT
> >> support is only for wl18xx.
> >>
> >
> > How can you tell the difference? What I see is that omap3pandora
> > (and nothing else) calls wl1251_set_platform_data(), while
> > da850-evm and all omap3/omap4 boards use wl12xx_set_platform_data().
> >
> > The latter seems to refer to all wl12xx and wl18xx variants except
> > for wl1251, based on my (very limited) understanding of that code.
> 
> right.
> i got mislead because legacy_init_wl12xx() is defined there only for
> CONFIG_WL12XX (and not for CONFIG_WL18XX).
> it looks like only "isee,omap3-igep0020-rev-f" and
> "isee,omap3-igep0020-rev-g" have pdata quirks for wl18xx (and thus
> initialize the pdata clocks to 0).

Ok.

> sorry for the trivial question, but what's the standard way to submit
> such patch? should i simply add a third patch to the patchset which
> removes the pdata quirk and adds the missing dts definition? i don't
> have such board, so i can only compile-test it.

Yes, I think that would be good. Depending on the complexity of the
patch, you can do it in multiple ways:

a) one patch to all the dts files, which also removes the
   legacy_init_wl12xx() infrastructure

b) one patch to add the .dts changes, a second patch to remove the
   code from pdata-quirks.c and a third to remove the functionality
   in the driver

c) one patch per board.

I'm fine with any of these, but the omap maintainers might have a
preference.

	Arnd
