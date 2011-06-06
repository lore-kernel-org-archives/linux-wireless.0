Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay1.ukrpost.ua ([82.207.79.21]:44874 "EHLO relay1.ukrpost.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab1FFLOX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 07:14:23 -0400
Received: from mail.academy.zt.ua ([82.207.120.245])
	by relay1.ukrpost.ua with esmtp (Exim 4.75)
	(envelope-from <prvs=1138417825=george@znau.edu.ua>)
	id 1QTXGr-0006SA-7d
	for linux-wireless@vger.kernel.org; Mon, 06 Jun 2011 13:42:57 +0300
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v12.0.0)
	with ESMTP id md50000009935.msg
	for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 13:41:49 +0300
Subject: Re: [RFC][PATCH 03/10] bcma: add embedded bus
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	linux-mips@linux-mips.org, mb@bu3sch.de, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com
In-Reply-To: <BANLkTi=T6xO9q+vOCk5Fu+2J_nUTwX3dcg@mail.gmail.com>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
	 <1307311658-15853-4-git-send-email-hauke@hauke-m.de>
	 <BANLkTi=T6xO9q+vOCk5Fu+2J_nUTwX3dcg@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 06 Jun 2011 13:32:02 +0300
Message-Id: <1307356322.28734.11.camel@dev.znau.edu.ua> (sfid-20110606_131426_272671_76104F24)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Hauke,
> 
> My idea for naming schema was to use:
> bcma_host_TYPE_*
> 
> Like:
> bcma_host_pci_*
> bcma_host_sdio_*
> 
> You are using:
> bcma_host_bcma_*
> 
> What do you think about changing this to:
> bcma_host_embedded_*
> or just some:
> bcma_host_emb_*
> ?
> 
> Does it make more sense to you? I was trying to keep names in bcma
> really clear, so every first-time-reader can see differences between
> hosts, host and driver, etc.
how about bcma_host_soc ?

> 
> 
> 2011/6/6 Hauke Mehrtens <hauke@hauke-m.de>:
> > --- /dev/null
> > +++ b/drivers/bcma/host_embedded.c
> > @@ -0,0 +1,93 @@
> > +/*
> > + * Broadcom specific AMBA
> > + * PCI Host
> 
> s/PCI/Embedded/
> 
> 
> > +int bcma_host_bcma_register(struct bcma_bus *bus)
> > +{
> > +       u32 __iomem *mmio;
> > +       /* iomap only first core. We have to read some register on this core
> > +        * to get the number of cores. This is sone in bcma_scan()
> > +        */
> > +       mmio = ioremap(BCMA_ADDR_BASE, BCMA_CORE_SIZE * 1);
> > +       if (!mmio)
> > +               return -ENOMEM;
> > +       bus->mmio = mmio;
> 
> Maybe just:
> bus->mmio = ioremap(...);
> ? :)
> 
> 
> > +       /* Host specific */
> > +       bus->hosttype = BCMA_HOSTTYPE_EMBEDDED;
> > +       bus->ops = &bcma_host_bcma_ops;
> > +
> > +       /* Register */
> > +       return bcma_bus_register(bus);
> > +}
> > diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> > index 1afa107..c5bcb5f 100644
> > --- a/drivers/bcma/main.c
> > +++ b/drivers/bcma/main.c
> > @@ -119,6 +119,7 @@ static int bcma_register_cores(struct bcma_bus *bus)
> >                        break;
> >                case BCMA_HOSTTYPE_NONE:
> >                case BCMA_HOSTTYPE_SDIO:
> > +               case BCMA_HOSTTYPE_EMBEDDED:
> >                        break;
> >                }
> >
> > diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
> > index 70b39f7..9229615 100644
> > --- a/drivers/bcma/scan.c
> > +++ b/drivers/bcma/scan.c
> > @@ -203,7 +203,7 @@ static s32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 **eromptr,
> >  int bcma_bus_scan(struct bcma_bus *bus)
> >  {
> >        u32 erombase;
> > -       u32 __iomem *eromptr, *eromend;
> > +       u32 __iomem *eromptr, *eromend, *mmio;
> >
> >        s32 cia, cib;
> >        u8 ports[2], wrappers[2];
> > @@ -219,9 +219,34 @@ int bcma_bus_scan(struct bcma_bus *bus)
> >        bus->chipinfo.id = (tmp & BCMA_CC_ID_ID) >> BCMA_CC_ID_ID_SHIFT;
> >        bus->chipinfo.rev = (tmp & BCMA_CC_ID_REV) >> BCMA_CC_ID_REV_SHIFT;
> >        bus->chipinfo.pkg = (tmp & BCMA_CC_ID_PKG) >> BCMA_CC_ID_PKG_SHIFT;
> > +       bus->nr_cores = (tmp & BCMA_CC_ID_NRCORES) >> BCMA_CC_ID_NRCORES_SHIFT;
> 
To avoid using wrapper struct and at the same time to save on embedded
reservations you could let the bus get scanned twice on SoC - first time
discovering just system devices (chipcommon and mips core) required for
early setup (you will never register those to the linux device subsystem
so you can have them marked as __initdata and have no ->release callback
therefore), second time full scan with registering the whole bus when
done.

Have nice day,
George


