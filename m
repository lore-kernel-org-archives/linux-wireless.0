Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:47822 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab2C0Wws (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 18:52:48 -0400
Date: Wed, 28 Mar 2012 00:52:44 +0200
From: Jakub Kicinski <kubakici@wp.pl>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 1/4] rt2x00: broaden PCIE L1-state wakeup
 configuration
Message-ID: <20120328005244.727d9f05@north> (sfid-20120328_005251_942983_75EBDC22)
In-Reply-To: <4F720494.3030509@gmail.com>
References: <1332859867-27921-1-git-send-email-kubakici@wp.pl>
	<1332859867-27921-2-git-send-email-kubakici@wp.pl>
	<4F720494.3030509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, 27 Mar 2012 20:19:00 +0200 Gertjan van Wingerde <gwingerde@gmail.com> wrote:
> On 03/27/12 16:51, Jakub Kicinski wrote:
> > Broaden wakeup configuration to all PCIE from rt3xxx on.
> > 
> > Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
> > ---
> > 2011_0406_RT5390_RT5392_Linux_STA_V2.5.0.3_DPO
> > rtmp_init_inf.c:171
> > 
> > Legacy driver applies this configuration to the following devices:
> > 3071 3090 3572 3592 3562 3062 3390 3593 5390 5370 5392 5372 5360 5362
> > if they are working on PCIE bus. AFAIK these are all post 2xxx PCIE
> > devices.
> > ---
> >  drivers/net/wireless/rt2x00/rt2800lib.c |    4 +---
> >  drivers/net/wireless/rt2x00/rt2800pci.c |    5 +----
> >  2 files changed, 2 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> > index 6c0a12e..4722030 100644
> > --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> > @@ -401,9 +401,7 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
> >  		return -EBUSY;
> >  
> >  	if (rt2x00_is_pci(rt2x00dev)) {
> > -		if (rt2x00_rt(rt2x00dev, RT3572) ||
> > -		    rt2x00_rt(rt2x00dev, RT5390) ||
> > -		    rt2x00_rt(rt2x00dev, RT5392)) {
> > +		if (rt2x00_is_pcie(rt2x00dev) && rt2x00dev->chip.rt > 0x3000) {
> >  			rt2800_register_read(rt2x00dev, AUX_CTRL, &reg);
> >  			rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
> >  			rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);
> 
> I don't like the comparison against 0x3000. Maybe you should invert the
> conditions and test for the chipsets for which this does not have to be
> applied (e.g. !rt2x00_rt(rt2x00dev, RT2860) && !rt2x00_rt(rt2x00dev,
> RT2872).
Not sure about that. Excluding old chips would be opposite to what
legacy driver is doing.

Legacy driver uses a long list of almost all > 0x3000 devices here. It
leaves out only RT3070, RT3352 and RT5350 but those chips are not used
on PCIe. The same list is later used throughout PCIe power management
code. I can only guess that from 0x3000 on PCIe devices gained some
kind of new power management capabilities.

It might be worth adding a macro which will check for all those devices
(rt2800pci_has_pcie_ps or sth) later on, when implementing support for
that PCIe PS, but for now I thought check against 0x3000 will be
equally good.

> Also, the flow looks a bit strange here. The old code applied to all PCI
> and PCIe devices, now you narrow it down to just PCIe devices.
> Is that right?
Yes, legacy driver applies this to PCIe only.

> Can anything be done to the strange flow now, with first checking for
> PCI and PCIe devices and then immediately only for PCIe devices?
Well, there are pros and cons for leaving it as it is, but I will move
PCIe checks out of PCI block if you like ;-)

  -- Kuba
