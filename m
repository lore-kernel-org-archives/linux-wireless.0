Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3387 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935047Ab0KQWdC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 17:33:02 -0500
From: "Brett Rudley" <brudley@broadcom.com>
To: "Greg KH" <gregkh@suse.de>,
	"Mike Rapoport" <mike.rapoport@gmail.com>
cc: "Greg KH" <greg@kroah.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Dowan Kim" <dowan@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 17 Nov 2010 14:32:49 -0800
Subject: RE: [PATCH 2/4] staging: brcm80211: brcmfmac: remove PCI SDIO
 controller binding
Message-ID: <7A94256FD72B884D9E7C55586C3CBCEE13842932BE@SJEXCHCCR01.corp.ad.broadcom.com>
References: <20101116200420.GA10793@kroah.com>
 <1289980726-28706-1-git-send-email-mike.rapoport@gmail.com>
 <20101117211035.GA2442@kroah.com>
 <AANLkTi=p_iH32zads+9RwQGY+m7JK+FTmhBTth_x9ouK@mail.gmail.com>
 <20101117221127.GB3851@suse.de>
In-Reply-To: <20101117221127.GB3851@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not familiar with the fullmac code so I am getting someone from fullmac team to answer...hang on just a little.

In the meantime Mike, does the driver still work with all your patches?

Thanks
Brett

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Wednesday, November 17, 2010 2:11 PM
> To: Mike Rapoport
> Cc: Greg KH; Brett Rudley; Henry Ptasinski; Dowan Kim; linux-
> wireless@vger.kernel.org
> Subject: Re: [PATCH 2/4] staging: brcm80211: brcmfmac: remove PCI SDIO
> controller binding
> 
> On Thu, Nov 18, 2010 at 12:00:16AM +0200, Mike Rapoport wrote:
> > On Wed, Nov 17, 2010 at 11:10 PM, Greg KH <greg@kroah.com> wrote:
> > > On Wed, Nov 17, 2010 at 09:58:46AM +0200, Mike Rapoport wrote:
> > >> Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
> > >> ---
> > >>  drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |  229 ----------
> -----------
> > >>  1 files changed, 0 insertions(+), 229 deletions(-)
> > >
> > > Wait, is this really ok code to be removing from the driver?
> > >
> > > Brett and Henry, any objections to this?
> > >
> > > Mike, why do you think this is ok to remove?  Is it because no one is
> > > ever calling this even for both types of config for this driver?
> >
> > There's a lot of code in the brcmfmac part of the driver that tries to
> > re-implement SDIO stack. In particular, the code removed by this patch
> > registers a pci_driver for SDIO controller and then the brcmfmac
> > driver accesses the WiFi device attached to that SDIO controller by
> > means of custom re-implementation of SDHC.
> 
> Ok, so even with this patch, it will still work properly in the SDIO
> mode?
> 
> Have you been able to test this?
> 
> Brett, Henry, I would like to get your ack on this before applying it.
> 
> thanks,
> 
> greg k-h


