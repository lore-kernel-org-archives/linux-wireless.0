Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54972 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab0KRQ35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 11:29:57 -0500
Date: Thu, 18 Nov 2010 11:27:48 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH] ssb: fail registration for unknown SPROM revision
Message-ID: <20101118162748.GB2468@tuxdriver.com>
References: <1288823326-9686-1-git-send-email-zajec5@gmail.com>
 <1288823326-9686-2-git-send-email-zajec5@gmail.com>
 <20101116212321.GF10774@tuxdriver.com>
 <1290013976.2513.14.camel@maggie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1290013976.2513.14.camel@maggie>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 17, 2010 at 06:12:56PM +0100, Michael Büsch wrote:
> On Tue, 2010-11-16 at 16:23 -0500, John W. Linville wrote: 
> > > -		ssb_printk(KERN_WARNING PFX "Unsupported SPROM"
> > > -			   "  revision %d detected. Will extract"
> > > -			   " v1\n", out->revision);
> > > -		out->revision = 1;
> > > -		sprom_extract_r123(out, in);
> > > +		ssb_printk(KERN_ERR PFX "Unsupported SPROM revision %d"
> > > +			   " detected\n", out->revision);
> > > +		return -EINVAL;
> > >  	}
> > >  
> > >  	if (out->boardflags_lo == 0xFFFF)
> > 
> > I think this is going to make my b43 PCI-E card not work...I'll try
> > it and get back to you...
> 
> Hm, what version does it report?

This is what I see in dmesg (w/o the patch):

[ 1036.277235] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x11, vendor 0x4243)
[ 1036.277249] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0A, vendor 0x4243)
[ 1036.277267] ssb: Core 2 found: USB 1.1 Host (cc 0x817, rev 0x03, vendor 0x4243)
[ 1036.277277] ssb: Core 3 found: PCI-E (cc 0x820, rev 0x01, vendor 0x4243)
[ 1036.293856] ssb: WARNING: Invalid SPROM CRC (corrupt SPROM)
[ 1036.293865] ssb: Unsupported SPROM  revision 255 detected. Will extract v1
[ 1036.301254] ssb: Sonics Silicon Backplane found on PCI device 0000:04:00.0
[ 1036.420643] b43-phy1: Broadcom 4311 WLAN found (core revision 10)
[ 1036.435060] b43-phy1 debug: Found PHY: Analog 4, Type 2, Revision 8
[ 1036.435082] b43-phy1 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
[ 1036.445105] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
[ 1036.450914] Registered led device: b43-phy1::tx
[ 1036.451466] Registered led device: b43-phy1::rx
[ 1036.451890] Registered led device: b43-phy1::radio
[ 1036.452226] Broadcom 43xx driver loaded [ Features: PMLS, Firmware-ID: FW13 ]
[ 1036.480736] udev[2440]: renamed network interface wlan1 to wlan2
[ 1036.513712] cfg80211: Calling CRDA for country: US
[ 1036.623061] b43-phy1: Loading OpenSource firmware version 410.31754
[ 1036.623075] b43-phy1: Hardware crypto acceleration not supported by firmware
[ 1036.623083] b43-phy1: QoS not supported by firmware
[ 1036.656362] b43-phy1 debug: Chip initialized
[ 1036.661477] b43-phy1 debug: 32-bit DMA initialized
[ 1036.661499] b43-phy1 debug: QoS disabled
[ 1036.672035] b43-phy1 debug: Wireless interface started
[ 1036.674628] b43-phy1 debug: Adding Interface type 2
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
