Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab1H0PV5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 11:21:57 -0400
Date: Sat, 27 Aug 2011 08:21:44 -0700
From: Greg KH <gregkh@suse.de>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110827152144.GA10126@suse.de> (sfid-20110827_172206_317555_EFE33DAF)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
 <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
 <20110827143513.GN3775@shale.localdomain>
 <20110827145003.GA9405@suse.de>
 <CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 27, 2011 at 05:08:26PM +0200, Rafał Miłecki wrote:
> 2011/8/27 Greg KH <gregkh@suse.de>:
> > On Sat, Aug 27, 2011 at 05:35:13PM +0300, Dan Carpenter wrote:
> >> On Thu, Aug 25, 2011 at 10:55:26PM +0200, Rafał Miłecki wrote:
> >> > 2011/8/25 Henry Ptasinski <henryp@broadcom.com>:
> >> > > With the latest series of cleanup patches merged in by Greg KH, I'd like to
> >> > > once again propose moving brcm80211 out of staging and into mainline.
> >> >
> >> > Henry: a simple question, please explain it to me, what brcmsmac does
> >> > provide that b43 doesn't?
> >> >
> >>
> >> Wow.  Why are we only having this discussion now?  Somewhere along
> >> the line, there has been a massive communications failure.  What
> >> happened here?  Henry, did you know about the b43 driver?  Can
> >> someone explain what's going on?
> >
> > I always thought that b43 and the staging driver supported different
> > devices and had no overlap, which is why I had no problem with it.
> >
> > Was I totally mistaken and got this wrong?
> 
> Please see my last e-mail in this thread for history overview.

Thanks for this, I appreciate it, and it confirms that when the driver
was originally added, there was no duplication.

> Right now the only card that is supported by brcmsmac and is not
> supported by b43 is 14e4:4727. That card is based on PHY type LCN, and
> I'm working on adding support for it in b43.

That sounds good.

> Other cards supported by brcmsmac (14e4:4353, 14e4:4357) are supported
> by b43. They still need some work (no HT support, but I'm not sure if
> even brcmsmac has support for it), but are usable and seem to work
> stable. Plus b43 supports some feature like monitor mode, etc. on that
> cards.

Very nice.

> I've also crated comparison of driver few days ago:
> http://wireless.kernel.org/en/users/Drivers/b43#Comparison_of_recent_drivers
> It doesn't cover cards by pci ids, but gives some overview.

Ok, we don't want/accept duplicate drivers for the same devices (well, I
sure don't want that, we had it in the past in the USB subsystem and it
was a nightmare).

So, as b43 was here first, it looks like brcmfmac is the only part that
should really move out of staging, right?

Henry, thoughts?  Have you all been tracking the b43 support for the
past year?

greg k-h
