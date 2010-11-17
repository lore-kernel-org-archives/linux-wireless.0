Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54677 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759025Ab0KQWNg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 17:13:36 -0500
Date: Wed, 17 Nov 2010 14:11:27 -0800
From: Greg KH <gregkh@suse.de>
To: Mike Rapoport <mike.rapoport@gmail.com>
Cc: Greg KH <greg@kroah.com>, Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] staging: brcm80211: brcmfmac: remove PCI SDIO
 controller binding
Message-ID: <20101117221127.GB3851@suse.de>
References: <20101116200420.GA10793@kroah.com>
 <1289980726-28706-1-git-send-email-mike.rapoport@gmail.com>
 <20101117211035.GA2442@kroah.com>
 <AANLkTi=p_iH32zads+9RwQGY+m7JK+FTmhBTth_x9ouK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTi=p_iH32zads+9RwQGY+m7JK+FTmhBTth_x9ouK@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 18, 2010 at 12:00:16AM +0200, Mike Rapoport wrote:
> On Wed, Nov 17, 2010 at 11:10 PM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Nov 17, 2010 at 09:58:46AM +0200, Mike Rapoport wrote:
> >> Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
> >> ---
> >>  drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |  229 ---------------------
> >>  1 files changed, 0 insertions(+), 229 deletions(-)
> >
> > Wait, is this really ok code to be removing from the driver?
> >
> > Brett and Henry, any objections to this?
> >
> > Mike, why do you think this is ok to remove?  Is it because no one is
> > ever calling this even for both types of config for this driver?
> 
> There's a lot of code in the brcmfmac part of the driver that tries to
> re-implement SDIO stack. In particular, the code removed by this patch
> registers a pci_driver for SDIO controller and then the brcmfmac
> driver accesses the WiFi device attached to that SDIO controller by
> means of custom re-implementation of SDHC.

Ok, so even with this patch, it will still work properly in the SDIO
mode?

Have you been able to test this?

Brett, Henry, I would like to get your ack on this before applying it.

thanks,

greg k-h
