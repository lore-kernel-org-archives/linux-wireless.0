Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43359 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2BGP3Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 10:29:25 -0500
Date: Tue, 7 Feb 2012 09:29:21 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Arend van Spriel <arend@broadcom.com>,
	Scott Sanbar <scott.sanbar@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: BCM4331 fails to associate after suspend
Message-ID: <20120207152921.GA8464@ubuntu-macmini> (sfid-20120207_162928_702453_5F57A608)
References: <20120203222818.GA3749@ubuntu-mba>
 <4F2D0C07.1010704@broadcom.com>
 <20120204142502.GA10858@ubuntu-mba>
 <CACna6ryR2xm2EAJaV4vCO8WebR5pXCyFknEMrf8ynVF+HYrxTw@mail.gmail.com>
 <20120206173757.GC31938@ubuntu-macmini>
 <4F302647.2070102@hauke-m.de>
 <20120206223447.GE31938@ubuntu-macmini>
 <CACna6rx7E9tM82iyYP=eRnTU+QZA1rMfdk8vNnX5k1_jbc5DqQ@mail.gmail.com>
 <CACna6rzDNfAMq+RHO_X2y3XrQn3oFJxmf9bsR2mzLs3X0o3dSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rzDNfAMq+RHO_X2y3XrQn3oFJxmf9bsR2mzLs3X0o3dSA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 07, 2012 at 08:08:11AM +0100, Rafał Miłecki wrote:
> W dniu 7 lutego 2012 08:04 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> > 2012/2/6 Seth Forshee <seth.forshee@canonical.com>:
> >> On Mon, Feb 06, 2012 at 08:13:11PM +0100, Hauke Mehrtens wrote:
> >>> According to the Broadcom SDK for SoCs bcma_pcicore_serdes_workaround()
> >>> should be called when coming out of standby/hibernate.
> >>> The code wl uses to do the same thing as bcma does is open source. You
> >>> find it in the GPL package of many Broadcom based Wifi Routers.
> >>
> >> Thanks for the suggestion. Unfortunately calling
> >> bcma_pcicore_serdes_workaround() during resume doesn't help. I'll look
> >> at the wl code to see if I can learn anything there.
> >
> > Can you try
> >
> >
> > diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> > index febbc0a..a097a26 100644
> > --- a/drivers/bcma/main.c
> > +++ b/drivers/bcma/main.c
> > @@ -267,6 +267,13 @@ int bcma_bus_resume(struct bcma_bus *bus)
> >                bcma_core_chipcommon_init(&bus->drv_cc);
> >        }
> >
> > +       /* Init PCIE core */
> > +       core = bcma_find_core(bus, BCMA_CORE_PCIE);
> > +       if (core) {
> > +               bus->drv_pci.setup_done = false;
> > +               bcma_core_pci_init(&bus->drv_pci);
> > +       }
> > +
> >        list_for_each_entry(core, &bus->cores, list) {
> >                struct device_driver *drv = core->dev.driver;
> >                if (drv) {
> 
> If this doesn't work out of box, please check if reloading b43 is
> enough. AFAIR now you have to reload both: b43 and bcma. I hope this
> patch will let you avoid reloading at least bcma.

I tried exactly that yesterday, but it doesn't fix the issue. I just
checked to see if it allows reloading only b43, and it does not. I still
have to reload bcma to get the wireless working again.

Seth
