Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4447 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757384AbYC0QUg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 12:20:36 -0400
Date: Thu, 27 Mar 2008 11:58:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Balaji Rao <balajirrao@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Question on Wireless NICs
Message-ID: <20080327155842.GA3624@tuxdriver.com> (sfid-20080327_162057_809248_C324590E)
References: <200803260011.29045.balajirrao@gmail.com> <20080325193219.GC30587@tuxdriver.com> <1206498769.23595.6.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1206498769.23595.6.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 25, 2008 at 10:32:48PM -0400, Pavel Roskin wrote:
> On Tue, 2008-03-25 at 15:32 -0400, John W. Linville wrote:
> 
> > The gPXE (formerly etherboot) project seems to support PCI-based
> > (e.g. cardbus, but not PCMCIA) orinoco devices.  I cannot verify that,
> > since I have no such device (donations accepted!)...
> 
> Just to set the record straight, I'm unaware of any CardBus devices
> compatible with the orinoco driver, i.e. Prism 2-3, Symbol Trilogy or
> Hermes I based 802.11b device.
> 
> At the first glance, gPXE appears to support Prism chipset only, either
> native PCI or PCMCIA behind PLX9052 bridge.

I'm not sure where you are looking.  I have a git tree from here:

	git://git.etherboot.org/scm/gpxe.git

The gpxe source file src/drivers/net/prism2_pci.c claims to support
PCI ID 1260:3873 which is listed as a prism 2.5 device supported by
drivers/net/wireless/orinoco_pci.c in the linux tree.  Similarly the
gpxe src/drivers/net/prism2_plx.c claims to support all of the PCI IDs
listed in drivers/net/wireless/orinoco_plx.c from the linux tree as
well as one that is not listed there (126c:8030 -- perhaps we should
add it?).

As I said, I do not have _any_ pci-based prism2-3 hardware (donations
welcome!), so I can not verify whether or not the gpxe code (or for
that matter the linux code) actually works -- YMMV.  I'm just going
by what information I have.

John
-- 
John W. Linville
linville@tuxdriver.com
