Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:19952 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397AbaGAHlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 03:41:13 -0400
Date: Tue, 1 Jul 2014 10:41:02 +0300
From: Tony Lindgren <tony@atomide.com>
To: James Cameron <quozl@laptop.org>
Cc: Bing Zhao <bzhao@marvell.com>, Daniel Mack <daniel@zonque.org>,
	Andreas Fenkart <afenkart@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-mmc <linux-mmc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: mwifiex card reset
Message-ID: <20140701074101.GA8806@atomide.com> (sfid-20140701_094133_372965_DAA5142F)
References: <CALtMJEBWPM+75wxM2Mp5EX_o6NWtZUJdYRCv6psbvdUn4k295w@mail.gmail.com>
 <20140628052220.GG10407@us.netrek.org>
 <20140628072322.GC7410@atomide.com>
 <CALtMJED5vfgkAhMBXKaDP6u9U9n41c-wziyTxt6e_7XTSxG3oQ@mail.gmail.com>
 <20140630061912.GA2461@atomide.com>
 <53B1BAC1.3090902@zonque.org>
 <477F20668A386D41ADCC57781B1F70430FE5F37540@SC-VEXCH1.marvell.com>
 <20140701065721.GM24891@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430FE5F3754E@SC-VEXCH1.marvell.com>
 <20140701070349.GN24891@us.netrek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140701070349.GN24891@us.netrek.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* James Cameron <quozl@laptop.org> [140701 10:05]:
> On Tue, Jul 01, 2014 at 12:02:25AM -0700, Bing Zhao wrote:
> > Hi James,
> > 
> > > On Mon, Jun 30, 2014 at 11:44:29PM -0700, Bing Zhao wrote:
> > > > I may have missed something, but doesn't the MMC_POWER_OFF and
> > > > MMC_POWER_ON|UP handling in controller driver help?
> > > > Anyway the clocks/GPIOs/regulators are sort of platform dependent.
> > > > Would it be better putting it in /arch/arm/mach-xxxxx/?
> > > 
> > > Wouldn't device tree for mmc be better?
> > 
> > Yes, device tree is better for defining clocks/GPIO/regulators, etc.
> > But I guess the reset logic (making use of these definitions) cannot
> > be device tree?
> 
> I think the reset logic can exist, but does nothing unless the device
> tree definitions are present.

It might be possible to support the SDIO card specific
clocks/GPIOs/regulators the MMC bus driver. But that may not
work well in the long run as those pins are not connected to
the MMC bus at all. If we wanted to explore adding card
specific features to the MMC bus, I guess we should have:

- Card reset-gpios

- Card specific regulators on the card controlled by
  a GPIO

- External card specific regulators

- Card specific idle status pin (no idea what these pins
  do on some of the mwifiex cards though?)

And then these would have to be configured to get the
SDIO card to probe. And they should be controllable also
from user space to reset a card or to power it off.

Then if we get a device that muxes two different SDIO cards
on the same bus, then what do we do? They may both have
their own regulators and reset GPIO pins.

Regards,

Tony
