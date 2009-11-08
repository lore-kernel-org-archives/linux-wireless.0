Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:31362 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZKHSdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 13:33:17 -0500
Received: by ey-out-2122.google.com with SMTP id 25so36176eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 10:33:22 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/9] rt2800: add eFuse EEPROM support code to rt2800lib
Date: Sun, 8 Nov 2009 19:32:37 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain> <200911081913.49917.bzolnier@gmail.com> <200911081927.30754.IvDoorn@gmail.com>
In-Reply-To: <200911081927.30754.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200911081932.37575.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009 19:27:30 Ivo van Doorn wrote:
> On Sunday 08 November 2009, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 08 November 2009 19:08:23 Ivo van Doorn wrote:
> > > On Sunday 08 November 2009, Bartlomiej Zolnierkiewicz wrote:
> > > > On Sunday 08 November 2009 14:55:59 Ivo van Doorn wrote:
> > > > > On Sunday 08 November 2009, Bartlomiej Zolnierkiewicz wrote:
> > > > > > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > > > > Subject: [PATCH] rt2800: add eFuse EEPROM support code to rt2800lib
> > > > > > 
> > > > > > eFuse EEPROM is used also by USB chips (i.e. RT3070)
> > > > > > so move the needed code from rt2800pci to rt2800lib.
> > > > > > 
> > > > > > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > > > > ---
> > > > > >  drivers/net/wireless/rt2x00/rt2800.h    |   29 +++++++++++++++++++++
> > > > > >  drivers/net/wireless/rt2x00/rt2800lib.c |   43 ++++++++++++++++++++++++++++++++
> > > > > >  drivers/net/wireless/rt2x00/rt2800lib.h |    2 +
> > > > > >  drivers/net/wireless/rt2x00/rt2800pci.c |   38 ++--------------------------
> > > > > >  drivers/net/wireless/rt2x00/rt2800pci.h |   29 ---------------------
> > > > > >  5 files changed, 77 insertions(+), 64 deletions(-)
> > > > > 
> > > > > 
> > > > > > ===================================================================
> > > > > > --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> > > > > > +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> > > > > > @@ -147,44 +147,12 @@ static void rt2800pci_read_eeprom_pci(st
> > > > > >  
> > > > > >  static int rt2800pci_efuse_detect(struct rt2x00_dev *rt2x00dev)
> > > > > >  {
> > > > > > -	u32 reg;
> > > > > > -
> > > > > > -	rt2800_register_read(rt2x00dev, EFUSE_CTRL, &reg);
> > > > > > -
> > > > > > -	return rt2x00_get_field32(reg, EFUSE_CTRL_PRESENT);
> > > > > > +	return rt2800_efuse_detect(rt2x00dev);
> > > > > >  }
> > > > > 
> > > > > It would be better to fix all calls to rt2800pci_efuse_detect to use rt2800_efuse_detect
> > > > > rather then adding a special wrapper function for it.
> > > > > 
> > > > > > -static void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
> > > > > > +static inline void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
> > > > > >  {
> > > > > > -	unsigned int i;
> > > > > > -
> > > > > > -	for (i = 0; i < EEPROM_SIZE / sizeof(u16); i += 8)
> > > > > > -		rt2800pci_efuse_read(rt2x00dev, i);
> > > > > > +	rt2800_read_eeprom_efuse(rt2x00dev);
> > > > > >  }
> > > > > 
> > > > > Same here.
> > > > 
> > > > Could you please explain some more what do you mean by that?
> > > > (Please note that we have an extra SOC handling in rt2800pci.c.)
> > > 
> > > Your changes made the following 2 functions:
> > > 
> > > int rt2800pci_efuse_detect(struct rt2x00_dev *rt2x00dev)
> > > {
> > > 	return rt2800_efuse_detect(rt2x00dev);
> > > }
> > > 
> > > void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
> > > {
> > > 	rt2800_read_eeprom_efuse(rt2x00dev);
> > > }
> > > 
> > > So why do we need rt2800pci_* versions in this case? They simply wrap
> > > the rt2800 library function without providing anything extra...
> > 
> > Please go read the original code..
> > 
> > #ifdef CONFIG_RT2800PCI_PCI
> > ...
> > [ the code quoted in your mail ]
> > ...
> > #else
> > static inline void rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
> > {
> > }
> > 
> > static inline void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
> > {
> > }
> > #endif /* CONFIG_RT2800PCI_PCI */
> > 
> > [ #else is for CONFIG_RT2800PCI_WISOC ]
> 
> True, but rt2800pci_read_eeprom_efuse() has no WISOC counterpart,
> the fact that it is compiled into rt2x00lib without any restriction makes
> the ifdef statements in the rt2800pci obsolete.

Not really.  Please note that driver's behavior WRT WISOC is preserved.

> The purpose of the defines was to keep the EFUSE code out of the driver
> on embedded systems. So either rt2800lib should do the same with ifdefs
> in the rt2800lib.c and rt2800lib.h files, or we don't need the efuse specific
> wrappers in rt2800pci.c.

Said wrappers predate all of my rt2800 patches.

I think that they shouldn't have been added in the first place and I'll be
happy to add patch removing them to rt2800 tree (since code savings seem to
be really marginal and not worth the maintenance cost). 

Thanks.
-- 
Bartlomiej Zolnierkiewicz
