Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:64235 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449AbYC0Tcv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 15:32:51 -0400
Subject: Re: Question on Wireless NICs
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Balaji Rao <balajirrao@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20080327155842.GA3624@tuxdriver.com>
References: <200803260011.29045.balajirrao@gmail.com>
	 <20080325193219.GC30587@tuxdriver.com> <1206498769.23595.6.camel@dv>
	 <20080327155842.GA3624@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 15:32:49 -0400
Message-Id: <1206646369.6433.8.camel@dv> (sfid-20080327_193255_482618_6118BA06)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-03-27 at 11:58 -0400, John W. Linville wrote:
> On Tue, Mar 25, 2008 at 10:32:48PM -0400, Pavel Roskin wrote:
> > On Tue, 2008-03-25 at 15:32 -0400, John W. Linville wrote:
> > 
> > > The gPXE (formerly etherboot) project seems to support PCI-based
> > > (e.g. cardbus, but not PCMCIA) orinoco devices.  I cannot verify that,
> > > since I have no such device (donations accepted!)...
> > 
> > Just to set the record straight, I'm unaware of any CardBus devices
> > compatible with the orinoco driver, i.e. Prism 2-3, Symbol Trilogy or
> > Hermes I based 802.11b device.
> > 
> > At the first glance, gPXE appears to support Prism chipset only, either
> > native PCI or PCMCIA behind PLX9052 bridge.
> 
> I'm not sure where you are looking.  I have a git tree from here:
> 
> 	git://git.etherboot.org/scm/gpxe.git

That's where I was looking.

> The gpxe source file src/drivers/net/prism2_pci.c claims to support
> PCI ID 1260:3873 which is listed as a prism 2.5 device supported by
> drivers/net/wireless/orinoco_pci.c in the linux tree.  Similarly the
> gpxe src/drivers/net/prism2_plx.c claims to support all of the PCI IDs
> listed in drivers/net/wireless/orinoco_plx.c from the linux tree as
> well as one that is not listed there (126c:8030 -- perhaps we should
> add it?).

126c:8030 is in orinoco_nortel.c, and I don't think it can be treated
like plx9052 based bridges.

The code in prism2.c looks similar to linux-wlan-ng, which is
Prism-only.  But on the other hand, the gpxe driver offers only very
basic functionality, which doesn't even include WEP, so it's possible
that non-Prism cards would work.

-- 
Regards,
Pavel Roskin
